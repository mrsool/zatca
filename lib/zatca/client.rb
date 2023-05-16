require "httpx"

# This wraps the API described here:
# https://sandbox.zatca.gov.sa/IntegrationSandbox
class ZATCA::Client
  # TODO: Find production URL
  PRODUCTION_BASE_URL = "https://gw-apic-gov.gazt.gov.sa/e-invoicing/developer-portal".freeze
  SANDBOX_BASE_URL = "https://gw-apic-gov.gazt.gov.sa/e-invoicing/developer-portal".freeze

  DEFAULT_API_VERSION = "V2".freeze
  LANGUAGES = %w[ar en].freeze

  def initialize(username:, password:, language: "ar", version: DEFAULT_API_VERSION, environment: :production)
    raise "Invalid language: #{language}, Please use one of: #{LANGUAGES}" unless LANGUAGES.include?(language)

    @username = username
    @password = password
    @language = language
    @version = version

    @base_url = if environment.to_sym == :production
      PRODUCTION_BASE_URL
    else
      SANDBOX_BASE_URL
    end
  end

  # Reporting API
  def report_invoice(uuid:, invoice_hash:, invoice:, cleared:)
    request(
      path: "invoices/reporting/single",
      method: :post,
      body: {
        uuid: uuid,
        invoiceHash: invoice_hash,
        invoice: invoice
      },
      headers: {
        "Clearance-Status" => cleared ? "1" : "0"
      }
    )
  end

  # Clearance API
  def clear_invoice(uuid:, invoice_hash:, invoice:, cleared:)
    request(
      path: "invoices/clearance/single",
      method: :post,
      body: {
        uuid: uuid,
        invoiceHash: invoice_hash,
        invoice: invoice
      },
      headers: {
        "Clearance-Status" => cleared ? "1" : "0"
      }
    )
  end

  # Compliance CSID API
  # This should be used to obtain credentials to issue a certificate in the next
  # request (issue_production_csid)
  #
  # csid stands for Cryptographic Stamp Identifier
  #
  # csr stands for Certificate Signing Request
  #     You should generate this via the ZATCA::Signing::CSR class
  #
  # otp stands for One Time Password.
  #     You can get this from the fatoora portal
  # Returns:
  # {
  #   "binarySecurityToken": "string" # To be used as a username in next request
  #   "secret": "string" # To be used as a password in next request
  # }
  def issue_csid(csr:, otp:)
    request(
      path: "compliance",
      method: :post,
      body: {csr: csr},
      headers: {"OTP" => otp},
      authenticated: false
    )
  end

  # Compliance Invoice API
  def compliance_check(uuid:, invoice_hash:, invoice:)
    request(
      path: "compliance/invoices",
      method: :post,
      body: {
        uuid: uuid,
        invoiceHash: invoice_hash,
        invoice: invoice
      }
    )
  end

  # Production CSID (Onboarding) API
  # This endpoint gives you the Base64-encoded certificate back
  # compliance_request_id is retrieved from the issue_csid request, and is
  # in the response as responseID
  def issue_production_csid(compliance_request_id:)
    request(
      path: "production/csids",
      method: :post,
      body: {compliance_request_id: compliance_request_id}
    )
  end

  # Production CSID (Renewal) API
  # csr stands for Certificate Signing Request
  # otp stands for One Time Password
  def renew_production_csid(otp:, csr:)
    request(
      path: "production/csids",
      method: :patch,
      body: {csr: csr},
      headers: {"OTP" => otp}
    )
  end

  private

  def request(method:, path:, body: {}, headers: {}, authenticated: true)
    url = "#{@base_url}/#{path}"
    headers = default_headers.merge(headers)

    client = if authenticated
      authenticated_request_cilent
    else
      unauthenticated_request_client
    end

    response = client.send(method, url, json: body, headers: headers)

    if response.headers["Content-Type"] == "application/json"
      response.json
    else
      response.body.to_s
    end
  end

  def authenticated_request_cilent
    HTTPX.plugin(:basic_authentication).basic_auth(@username, @password)
  end

  def unauthenticated_request_client
    HTTPX
  end

  def default_headers
    {
      "Accept-Language" => @language,
      "Content-Type" => "application/json",
      "Accept-Version" => @version
    }
  end
end
