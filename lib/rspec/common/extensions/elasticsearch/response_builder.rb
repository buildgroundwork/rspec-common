# frozen_string_literal: true

# rubocop:disable Lint/SuppressedException
begin
  require "elasticsearch/model"

  module Doubles
    module Elasticsearch
      class ResponseBuilder
        def initialize(ids: [], total_count: nil, aggregations: nil)
          @ids = ids
          @total_count = total_count
          @aggregations = aggregations
        end

        def response
          response = {
            "hits" => {
              "total" => { "value" => total_count || ids.size },
              "hits" => ids.collect { |id| { "_id" => id } }
            }
          }

          response["aggregations"] = aggregations

          response
        end

        private

        attr_reader :ids, :total_count, :aggregations
      end
    end
  end
rescue LoadError
end
# rubocop:enable Lint/SuppressedException

