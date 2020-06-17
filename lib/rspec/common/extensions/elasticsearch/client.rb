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
        end

        def update(**params)
          self.class.calls[:update] ||= []
          self.class.calls[:update] << params
        end

        def delete(**params)
          self.class.calls[:delete] ||= []
          self.class.calls[:delete] << params
        end

        def search(params)
          self.class.calls[:search] ||= []
          self.class.calls[:search] << params

          self.class.response_builder.response
        end
      end
    end
  end
rescue LoadError
end

def elasticsearch_return(*args, **kwargs)
  Doubles::Elasticsearch::Client.return(*args, **kwargs)
end
# rubocop:enable Lint/SuppressedException

