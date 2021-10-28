# frozen_string_literal: true

require_relative "zatca/version"

require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  "zatca" => "ZATCA",
  "qr_code_generator" => "QRCodeGenerator"
)
loader.setup

module ZATCA
  extend self

  class Error < StandardError; end

  def self.render_qr_code(tags)
    QRCodeGenerator.new(ZATCA::Tags.new(tags)).render
  end
end

loader.eager_load
