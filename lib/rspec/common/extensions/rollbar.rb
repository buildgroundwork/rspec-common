# frozen_string_literal: true

if defined?(Rollbar)
  module Rollbar
    class << self
      def reset!
        @logs = nil
      end

      def logs
        @logs ||= []
      end
    end

    FakeItem = Struct.new(:level, :message, :exception, :extra, :context) do
      def to_s
        "#<Item level=#{level}, exception_class=#{exception.class}, message=#{message}, extra=#{extra.inspect}>"
      end
    end

    class Notifier
      def enabled?
        true
      end

      def report(*args)
        Rollbar.logs << FakeItem.new(*args)
      end
    end
  end
end

