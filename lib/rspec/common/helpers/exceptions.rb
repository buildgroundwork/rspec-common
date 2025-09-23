# frozen_string_literal: true

module RSpec::Common
  module Helpers
    module Exceptions
      # rubocop:disable Lint/RescueException
      def fallible(suppress: :runtime)
        yield
      rescue => e
        raise unless suppress == :all || suppress == :runtime || e.is_a?(suppress)
      rescue Exception => e
        raise unless suppress == :all || e.is_a?(suppress)
      end
      # rubocop:enable Lint/RescueException
    end
  end
end

