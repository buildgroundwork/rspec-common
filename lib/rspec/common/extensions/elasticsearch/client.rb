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

          def return(ids: , total_count: nil)
            @to_return = {
              ids: ids,
              total_count: total_count
            }
          end

          attr_reader :to_return
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

          search_results
        end

        private

        def search_results
          hits, total_count =
            if (to_return = self.class.to_return)
              ids = to_return[:ids].collect { |id| { "_id" => id } }
              total_count = to_return[:total_count] || ids.count
              [ids, total_count]
            else
              [[], 0]
            end
          { "hits" => { "total" => { "value" => total_count }, "hits" => hits } }
        end
      end
    end
  end
rescue LoadError
end

def elasticsearch_return(*args)
  Doubles::Elasticsearch::Client.return(*args)
end
# rubocop:enable Lint/SuppressedException

