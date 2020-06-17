# frozen_string_literal: true

# rubocop:disable Lint/SuppressedException
begin
  require "elasticsearch/model"

  module Doubles
    module Elasticsearch
      class ResponseBuilder
        def initialize(ids: [], total_count: nil)
          @ids = ids
          @total_count = total_count || ids.size
        end

        def response
          {
            "hits" => {
              "total" => { "value" => total_count },
              "hits" => ids.collect { |id| { "_id" => id } }
            }
          }
        end

        private

        attr_reader :ids, :total_count
      end
    end
  end
rescue LoadError
end
# rubocop:enable Lint/SuppressedException

