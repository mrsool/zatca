# frozen_string_literal: true

require_relative "lib/zatca/version"

Gem::Specification.new do |spec|
  spec.name = "zatca-qr-code"
  spec.version = ZATCA::VERSION
  spec.authors = ["Omar Bahareth"]
  spec.email = ["obahareth@mrsool.co"]

  spec.summary = "A library for generating QR Codes for the e-invoice standard by ZATCA in Saudi Arabia."
  spec.description = "A library for generating QR Codes for the e-invoice standard by ZATCA in Saudi Arabia."
  spec.homepage = "https://github.com/mrsool/zatca-qr-code"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mrsool/zatca-qr-code"
  spec.metadata["changelog_uri"] = "https://github.com/mrsool/zatca-qr-code/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Dependencies
  spec.add_dependency "zeitwerk", "~> 2.4"
  spec.add_dependency "dry-schema", "~> 1.5"
  spec.add_dependency "rqrcode", "~> 2.1.0"

  # Development Dependencies
  spec.add_development_dependency "standard", "~> 1.3"
  spec.add_development_dependency "byebug", "~> 9.0"
  spec.add_development_dependency "rspec", "~> 3.10"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
