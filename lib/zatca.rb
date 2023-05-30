# frozen_string_literal: true

require_relative "zatca/version"

require "active_support"
require "zeitwerk"
require "dry-initializer"
require "dry-types"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  "zatca" => "ZATCA",
  "qr_code_generator" => "QRCodeGenerator",
  "ubl" => "UBL",
  "csr" => "CSR",
  "ubl_document_signature" => "UBLDocumentSignature",
  "ubl_document_signatures" => "UBLDocumentSignatures",
  "ubl_extension" => "UBLExtension",
  "ubl_extensions" => "UBLExtensions",
  "id" => "ID"
)
loader.setup

module ZATCA
  extend self

  class Error < StandardError; end

  module Types
    include Dry.Types()
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
