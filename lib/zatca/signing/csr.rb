class ZATCA::Signing::CSR
  attr_reader :key, :csr_options, :mode

  # For security purposes, please provide your own private key.
  # If you don't provide one, a new unsecure one will be generated for testing purposes.
  def initialize(
    csr_options:,
    mode: :production,
    private_key_path: nil,
    private_key_password: nil
  )
    @csr_options = default_csr_options.merge(csr_options)
    @mode = mode.to_sym
    @private_key_path = private_key_path
    @private_key_password = private_key_password
    @generated_private_key_path = nil
  end

  # Returns a hash with two keys
  # - csr
  # - csr_without_headers
  def generate(csr_options: {})
    set_key
    write_csr_config

    command = generate_openssl_csr_command

    # Run the command and return the output
    output = `#{command}`

    cleanup_leftover_files

    output

    # TODO: Ruby version
    # request = OpenSSL::X509::Request.new
    # request.version = 0
    # request.subject = OpenSSL::X509::Name.new([
    #   ["C", csr_options[:country], OpenSSL::ASN1::PRINTABLESTRING],
    #   ["O", csr_options[:organization], OpenSSL::ASN1::UTF8STRING],
    #   ["OU", csr_options[:organization_unit], OpenSSL::ASN1::UTF8STRING],
    #   ["CN", csr_options[:common_name], OpenSSL::ASN1::UTF8STRING]
    # ])

    # extensions = [
    #   OpenSSL::X509::ExtensionFactory.new.create_extension("subjectAltName")
    # ]

    # # add SAN extension to the CSR
    # attribute_values = OpenSSL::ASN1::Set [OpenSSL::ASN1::Sequence(extensions)]
    # [
    #   OpenSSL::X509::Attribute.new("SN", attribute_values),
    #   OpenSSL::X509::Attribute.new("UID", attribute_values),
    #   OpenSSL::X509::Attribute.new("title", attribute_values),
    #   OpenSSL::X509::Attribute.new("registeredAddress", attribute_values),
    #   OpenSSL::X509::Attribute.new("businessCategory", attribute_values)
    # ]

    # attribute_values.each do |attribute|
    #   request.add_attribute attribute
    # end

    # request.public_key = public_key
    # csr = request.sign(key, OpenSSL::Digest.new("SHA256"))
    # csr_pem = csr.to_pem
    # csr_without_headers = csr_pem
    #   .to_s
    #   .gsub("-----BEGIN CERTIFICATE REQUEST-----", "")
    #   .gsub("-----END CERTIFICATE REQUEST-----", "")
    #   .delete("\n")

    # {
    #   csr: csr_pem,
    #   csr_without_headers: csr_without_headers
    # }
  end

  private

  def default_csr_options
    {
      common_name: "",
      organization_identifier: "",
      organization_name: "",
      organization_unit: "",
      country: "SA",
      invoice_type: "1100",
      address: "",
      business_category: "",
      egs_solution_name: "",
      egs_model: "",
      egs_serial_number: ""
    }
  end

  def set_key
    if private_key_provided? && @key.blank?
      @key = OpenSSL::PKey::RSA.new(
        File.read(@private_key_path),
        @private_key_password
      )
    else
      generate_key
    end
  end

  def generated_key?
    @key.present?
  end

  def private_key_provided?
    @private_key_path.present?
  end

  def generate_key
    return if private_key_provided?

    temp_key = OpenSSL::PKey::EC.new("secp256k1").generate_key
    @generated_private_key_path = "./#{SecureRandom.uuid}.pem"
    @key = temp_key

    File.write(@generated_private_key_path, @key.to_pem)
  end

  def delete_generated_key
    File.delete(@generated_private_key_path) if @generated_private_key_path.present?
  end

  def cert_environment
    case mode
    when :production
      "ZATCA-Code-Signing"
    when :simulation
      "PREZATCA-Code-Signing"
    when :sandbox
      "TSTZATCA-Code-Signing"
  end

  def generate_openssl_csr_command
    "openssl req -new -sha256 -key #{@private_key_path || @generated_private_key_path} -config #{@csr_config_path}"
  end

  def write_csr_config
    @csr_config_path = "./#{SecureRandom.uuid}.conf}"
    File.write(@csr_config_path, generate_csr_config)
  end

  def cleanup_leftover_files
    delete_generated_key
    delete_csr_config_file
  end

  def delete_csr_config_file
    File.delete(@csr_config_path) if @csr_config_path.present?
  end

  def egs_serial_number
    "1-#{csr_options[:egs_solution_name]}|2-#{csr_options[:egs_model]}|3-#{csr_options[:egs_serial_number]}"
  end

  # Adapted from:
  # https://github.com/wes4m/zatca-xml-js/blob/main/src/zatca/templates/csr_template.ts
  def generate_csr_config
    <<~TEMPLATE
      # ------------------------------------------------------------------
      # Default section for "req" command csr_options
      # ------------------------------------------------------------------
      [req]

      # Password for reading in existing private key file
      # input_password = todo_private_key_password

      # Prompt for DN field values and CSR attributes in ASCII
      prompt = no
      utf8 = no

      # Section pointer for DN field csr_options
      distinguished_name = my_req_dn_prompt

      # Extensions
      req_extensions = v3_req

      [ v3_req ]
      #basicConstraints=CA:FALSE
      #keyUsage = digitalSignature, keyEncipherment
      # Production or Testing Template (TSTZATCA-Code-Signing - ZATCA-Code-Signing)
      1.3.6.1.4.1.311.20.2 = ASN1:PRINTABLESTRING:#{cert_environment}
      subjectAltName=dirName:dir_sect

      [ dir_sect ]
      # EGS Serial number (1-SolutionName|2-ModelOrVersion|3-serialNumber)
      SN = #{egs_serial_number}
      # VAT Registration number of TaxPayer (Organization identifier [15 digits begins with 3 and ends with 3])
      UID = #{csr_options[:organization_identifier]}
      # Invoice type (TSCZ)(1 = supported, 0 not supported) (Tax, Simplified, future use, future use)
      title = #{csr_options[:invoice_type]}
      # Location (branch address or website)
      registeredAddress = #{csr_options[:address]}
      # Industry (industry sector name)
      businessCategory = #{csr_options[:business_category]}

      # ------------------------------------------------------------------
      # Section for prompting DN field values to create "subject"
      # ------------------------------------------------------------------
      [my_req_dn_prompt]
      # Common name (EGS TaxPayer PROVIDED ID [FREE TEXT])
      commonName = #{csr_options[:common_name]}

      # Organization Unit (Branch name)
      organizationalUnitName = #{csr_options[:organization_unit]}

      # Organization name (Tax payer name)
      organizationName = #{csr_options[:organization_name]}

      # ISO2 country code is required with US as default
      countryName = #{csr_options[:country]}
    TEMPLATE
  end
end
