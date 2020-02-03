require_relative 'lib/rspec/common/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec-common"
  spec.version       = Rspec::Common::VERSION
  spec.authors       = ["Adam Milligan"]
  spec.email         = ["adam@buildgroundwork.com"]

  spec.summary       = %q{Helpful shared examples and matchers for Rails.}
  spec.homepage      = "https://github.com/buildgroundwork/rspec-common"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/buildgroundwork/rspec-common"
  spec.metadata["changelog_uri"] = "https://github.com/buildgroundwork/rspec-common/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) { `git ls-files -z`.split("\x0") }
  spec.require_paths = ["lib"]

  spec.add_dependency('rspec-core')
  spec.add_dependency('rspec-rails')
  spec.add_dependency('rspec-collection_matchers')
  spec.add_dependency('rack-test')

  spec.add_development_dependency('rake')
  spec.add_development_dependency('rubocop')
  spec.add_development_dependency('rubocop-rails')
  spec.add_development_dependency('rubocop-rspec')
end

