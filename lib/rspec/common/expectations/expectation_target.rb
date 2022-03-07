# frozen_string_literal: true

require "rspec/core/memoized_helpers"
require "rspec/expectations/expectation_target"

# The RSpec team decided that they don't like the "implicit block expectation
# syntax," e.g.:
#
# subject { -> { do_something } }
# it { should change(foo, :count).to be_something }
#
# They prefer this:
#
# it "something something" do
#   expect { do_something }.to change(foo, :count).to be_something
# end
#
# See https://github.com/rubocop/rspec-style-guide/issues/76
#
# In order to enforce this arbitrary style choice they added a bunch of
# explicit checks, and added complexity, into the expectation methods.
#
# The RSpec team is entitled to their perfectly valid opinions, but prohibiting
# other styles is too draconian for my tastes.  This removes the unnecessary
# style enforcement.
module RSpec
  module Core::MemoizedHelpers
    def enforce_value_expectation(matcher, method_name); end
  end

  module Expectations
    if const_defined?(:ValueExpectationTarget)
      remove_const(:ValueExpectationTarget)
      ValueExpectationTarget = Class.new(ExpectationTarget)
    end
  end
end

