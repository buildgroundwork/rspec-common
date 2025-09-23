# frozen_string_literal: true

module RSpec
  module Common
    module Helpers
      module ActiveStorage
        module Configurator
          private

          def resolve(class_name)
            if class_name == 'Memory'
              require 'rspec/common/extensions/active_storage/service/memory'
              return ::ActiveStorage::Service::MemoryService
            end

            super
          end
        end
      end
    end
  end
end
