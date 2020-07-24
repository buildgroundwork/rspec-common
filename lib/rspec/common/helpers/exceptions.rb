# frozen_string_literal: true

module RSpec::Common
  module Helpers
    module Exceptions
      # rubocop:disable Lint/RescueException
      def fallible(suppress: :runtime)
        raise ArgumentError unless %i[none runtime all].include?(suppress)

        yield
      rescue
        raise if suppress == :none
      rescue Exception
        raise unless suppress == :all
      end
      # rubocop:enable Lint/RescueException
    end
  end
end

