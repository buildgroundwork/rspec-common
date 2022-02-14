# frozen_string_literal: true

require_relative "lib/rspec/common/version"

Gem::Specification.new do |spec|
  spec.name          = "rspec-common"
  spec.version       = Rspec::Common::VERSION
  spec.authors       = ["Adam Milligan"]
  spec.email         = ["adam@buildgroundwork.com"]

  spec.summary       = "Helpful shared examples and matchers for Rails."
  spec.homepage      = "https://github.com/buildgroundwork/rspec-common"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/buildgroundwork/rspec-common"
  spec.metadata["changelog_uri"] = "https://github.com/buildgroundwork/rspec-common/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) { `git ls-files -z`.split("\x0") }
  spec.require_paths = ["lib"]

  spec.add_dependency("rack-test", "~> 1.1")
  spec.add_dependency("rspec-collection_matchers", "~> 1.2")
  spec.add_dependency("rspec-core", "~> 3.10", ">= 3.10.1")
  # Version 3.11 of RSpec expectations deprecates using a block in a spec
  # subject (see https://github.com/rubocop/rspec-style-guide/issues/76).
  spec.add_dependency("rspec-expectations", "~> 3.10.0")
  spec.add_dependency("rspec-rails", "~> 5.0", ">= 5.0.1")

  spec.add_development_dependency("rake", "~> 13.0", ">= 13.0.3")
  spec.add_development_dependency("rubocop")
  spec.metadata = { "rubygems_mfa_required" => "true" }
end

