# frozen_string_literal: true

# The ActionCable test case assumes that channels will simply pass broadcasts
# along the connection, so it ignores any parameters you give to #stream_from.
# However, #stream_from can accept a callback function, which can modify the
# content of the broadcast and re-transmit it; this seems like something that
# is definitely worth testing.
#
# This extension holds onto the callback and coder parameters to #stream_from,
# as well as adding the #receive_broadcast test method.  To test the a stream
# with a callback simply call #receive_broadcast with the stream name and the
# content (in JSON format) that you expect the channel to receive.
module ActionCable::Channel
  module BetterChannelStub
    def stream_from(broadcasting, callback = nil, coder: nil, &block)
      handler = test_stream_handler(broadcasting, callback || block, coder:)
      streams[broadcasting] = handler
    end

    def test_stream_handler(broadcasting, user_handler, coder: )
      handler = stream_handler(broadcasting, user_handler, coder:)
      ->(message) { handler.call(message) }
    end

    def stop_all_streams
      @_streams = {}
    end

    # This is from Rails.
    # rubocop:disable Naming/MemoizedInstanceVariableName
    def streams
      @_streams ||= {}
    end
    # rubocop:enable Naming/MemoizedInstanceVariableName
  end

  ChannelStub.prepend(BetterChannelStub)

  class TestCase
    module BetterBehavior
      def receive_broadcast(stream, data)
        @subscription.streams.fetch(stream).call(data)
      end
    end

    Behavior.include BetterBehavior
  end
end

