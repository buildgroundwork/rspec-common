# frozen_string_literal: true

if defined?(Elasticsearch::Model::Naming)
  module Elasticsearch::Model::Naming::ClassMethods
    private

    def default_index_name
      "test_#{model_name.collection.tr('/', '-')}"
    end
  end
end

