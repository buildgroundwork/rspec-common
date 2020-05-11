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
          end

          def calls
            @calls ||= {}
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
      end
    end
  end

  Elasticsearch::Client.class_eval do
    def new(*)
      Doubles::Elasticsearch::Client.new
    end
  end
rescue LoadError
end
# rubocop:enable Lint/SuppressedException

