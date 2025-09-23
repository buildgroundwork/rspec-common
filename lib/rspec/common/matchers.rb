# frozen_string_literal: true

Dir.glob(File.expand_path('matchers/**/*.rb', __dir__)).each do |path|
  require path
end

RSpec::Matchers.define :satisfy do
  supports_block_expectations

  match do |action|
    action.call
    block_arg.call
    true
  end

  failure_message do
    'expected action to satisfy expectation'
  end
end
