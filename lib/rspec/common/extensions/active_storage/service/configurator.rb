# frozen_string_literal: true

module ActiveStorage
  class Service::Configurator # :nodoc:
    private

    # This is copied from the ActiveStorage gem in order to remove the first
    # line, which requires files based on assumed, static locations.
    #
    # Since the MemoryStorage service doesn't live in the standard service
    # directory, this require will fail.  But, no need to require it explicitly
    # since the spec process should require all of these files together when
    # setting up.
    def resolve(class_name)
      # require "active_storage/service/#{class_name.to_s.underscore}_service"
      ActiveStorage::Service.const_get(:"#{class_name.camelize}Service")
    rescue LoadError
      raise "Missing service adapter for #{class_name.inspect}"
    end
  end
end

