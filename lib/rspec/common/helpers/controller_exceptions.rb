# frozen_string_literal: true

# This acts as a stand-in for the Rack middleware that catches exceptions and
# returns appropriate HTTP responses.  Since that does not exist in the test
# environment, controller specs will emit any exceptions thrown.
#
# This allows checking for appropriate HTTP status, rather than catching
# exceptions (the exceptions being an implementation detail from the point of
# view of controller specs.
#
#   config.before { config.include(RSpec::Common::Helpers::ControllerExceptions, type: :controller) }

# rubocop:disable Metrics/MethodLength
module RSpec::Common
  module Helpers
    module ControllerExceptions
      def process(...)
        super
      rescue ActiveRecord::RecordNotFound, ActionController::RoutingError
        @response.status = 404
        @response
      rescue ActionController::UnknownFormat
        @response.status = 406
        @response
      rescue ActionController::ParameterMissing
        @response.status = 400
        @response
      rescue => e
        if Object.const_defined?(:Pundit) && e.is_a?(Pundit::NotAuthorizedError)
          @response.status = 404
          @response
        else
          raise
        end
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength

