# frozen_string_literal: true

require_relative "lib/zatca/version"

Gem::Specification.new do |spec|
  spec.name = "zatca"
  spec.version = ZATCA::VERSION
  spec.authors = ["Omar Bahareth"]
  spec.email = ["obahareth@mrsool.co"]

  spec.summary = "A library for generating QR Codes for the e-invoice standard by ZATCA in Saudi Arabia."
  spec.description = "A library for generating QR Codes for the e-invoice standard by ZATCA in Saudi Arabia."
  spec.homepage = "https://github.com/mrsool/zatca"
  spec.required_ruby_version = ">= 2.5.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mrsool/zatca"
  spec.metadata["changelog_uri"] = "https://github.com/mrsool/zatca/releases"

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
  spec.add_dependency "dry-schema", ">= 1.5"
  spec.add_dependency "rqrcode", "~> 2.1.0"
  spec.add_dependency "httpx", "~> 0.21.0"
  spec.add_dependency "nokogiri", ">= 1.12"
  spec.add_dependency "activesupport", ">= 5.2"
  spec.add_dependency "dry-initializer", ">= 3.0"

  # Development Dependencies
  spec.add_development_dependency "standard", "~> 1.3"
  spec.add_development_dependency "byebug", "~> 9.0"
  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "vcr", "~> 6.0.0"
  spec.add_development_dependency "webmock", "~> 3.18.1"
  spec.add_development_dependency "amazing_print", "~> 1.4.0"
  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
