# frozen_string_literal: true

require_relative "zatca/version"
require_relative "zatca/types"

require "active_support/all"
require "zeitwerk"
require "dry-initializer"
require "dry-types"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  "zatca" => "ZATCA",
  "qr_code_generator" => "QRCodeGenerator",
  "qr_code_extractor" => "QRCodeExtractor",
  "ubl" => "UBL",
  "csr" => "CSR",
  "ubl_document_signature" => "UBLDocumentSignature",
  "ubl_document_signatures" => "UBLDocumentSignatures",
  "ubl_extension" => "UBLExtension",
  "ubl_extensions" => "UBLExtensions",
  "id" => "ID",
  "ecdsa" => "ECDSA"
)
loader.setup

module ZATCA
  extend self

  class Error < StandardError; end

  def self.extract_qr_base64_from_base64_invoice(base64_invoice)
    QRCodeExtractor.new(invoice_base64: base64_invoice).extract
  end

  def self.render_qr_code(tags: nil, base64: nil)
    if tags.present?
      tags = ZATCA::Tags.new(tags) if tags.is_a?(Hash)
      QRCodeGenerator.new(tags: tags).render
    elsif base64.present?
      QRCodeGenerator.new(base64: base64).render
    else
      raise ArgumentError, "Either tags or base64 must be provided"
    end
  end
end

loader.eager_load
