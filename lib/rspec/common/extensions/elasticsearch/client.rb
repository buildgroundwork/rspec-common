# frozen_string_literal: true

# rubocop:disable Lint/SuppressedException
begin
  require "elasticsearch/model"

  module Doubles
    module Elasticsearch
      class Client
        class << self
          def reset!
            @calls = nil
            @to_return = nil
          end

          def calls
            @calls ||= {}
          end

          def return(**kwargs)
            @response_builder = ResponseBuilder.new(**kwargs)
          end

          def response_builder
            @response_builder ||= ResponseBuilder.new
          end
        end

        def initialize(*args); end

        def index(**params)
          self.class.calls[:create] ||= []
          self.class.calls[:create] << params

          nil
        end

        def search(params)
          self.class.calls[:search] ||= []
          self.class.calls[:search] << params

          self.class.response_builder.response
        end

        def bulk(params)
          self.class.calls[:bulk] ||= []
          self.class.calls[:bulk] << params

          { "errors" => false }
        end

        # rubocop:disable Lint/MissingSuper
        def method_missing(method, *_args, **params, &_block)
          self.class.calls[method] ||= []
          self.class.calls[method] << params

          nil
        end

        def respond_to_missing?(*)
          true
        end
        # rubocop:enable Lint/MissingSuper
      end
    end
  end
rescue LoadError
end

def elasticsearch_return(*args, **kwargs)
  Doubles::Elasticsearch::Client.return(*args, **kwargs)
end
# rubocop:enable Lint/SuppressedException

