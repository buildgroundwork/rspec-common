# frozen_string_literal: true

require_relative 'lib/rspec/common/version'

Gem::Specification.new do |spec|
  spec.name = 'rspec-common'
  spec.version = Rspec::Common::VERSION
  spec.authors = ['Adam Milligan', 'Grant Hutchins']
  spec.email = ['adam@buildgroundwork.com', 'grant.hutchins@srp-ok.com']

  spec.summary = 'Helpful shared examples and matchers for Rails.'
  spec.homepage = 'https://github.com/srpatx/rspec-common'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.1.0')

  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/srpatx/rspec-common'
  spec.metadata['changelog_uri'] = 'https://github.com/srpatx/rspec-common/releases'
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) { `git ls-files -z`.split("\x0") }
  spec.require_paths = ['lib']

  spec.add_dependency('rack-test')
  spec.add_dependency('rails', '>= 6.1', '< 8.2')
  spec.add_dependency('rspec-collection_matchers')
  spec.add_dependency('rspec-core')
  spec.add_dependency('rspec-expectations')
  spec.add_dependency('rspec-rails', '>= 8.0')

  spec.add_development_dependency('rake')
  spec.add_development_dependency('standard')
  spec.add_development_dependency('standard-performance')
  spec.add_development_dependency('standard-rails')
end
