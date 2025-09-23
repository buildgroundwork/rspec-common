# frozen_string_literal: true

if defined?(Elasticsearch::Model::Naming)
  module Elasticsearch
    module Model
      module Naming
        module ClassMethods
          private

          def default_index_name
            "test_#{model_name.collection.tr('/', '-')}"
          end
        end
      end
    end
  end
end
