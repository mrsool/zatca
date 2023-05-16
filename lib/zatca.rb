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

  def self.render_qr_code(tags)
    QRCodeGenerator.new(ZATCA::Tags.new(tags)).render
  end
end

loader.eager_load
