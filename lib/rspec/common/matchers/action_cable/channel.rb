# frozen_string_literal: true

RSpec::Matchers.define :confirm_subscription do
  match do |action|
    action.call
    subscription.confirmed?
  end

  failure_message do
    "Expected subscription to be confirmed"
  end

  failure_message_when_negated do
    "Expected subscription not to be confirmed"
  end
end

RSpec::Matchers.define :reject_subscription do
  match do |action|
    action.call
    subscription.rejected?
  end

  failure_message do
    "Expected subscription to be rejected"
  end

  failure_message_when_negated do
    "Expected subscription not to be rejected"
  end
end

RSpec::Matchers.define :stream_from do |*streams|
  match do |action|
    action.call
    streams.all? { |stream| subscription.streams.include?(stream) }
  end

  failure_message do
    "Expected subscription to stream from #{streams.join(', ')}"
  end

  failure_message_when_negated do
    "Expected subscription not to stream from #{streams.join(', ')}"
  end
end

# NB: rspec-rails provides the #have_streams matcher
RSpec::Matchers.define :have_no_streams do
  match do |action|
    action.call
    subscription.streams.empty?
  end

  failure_message do
    "Expected subscription to have no streams"
  end

  failure_message_when_negated do
    "Expected subscription to have streams"
  end
end

RSpec::Matchers.define :transmit do |message|
  match do |action|
    old_transmissions = transmissions
    action.call
    @new_transmissions = transmissions - old_transmissions

    if message == :anything
      @new_transmissions.any?
    else
      @new_transmissions.any?(message.as_json)
    end
  end

  failure_message do
    "Expected channel to transmit #{message.as_json}\n\n" \
      "Actual transmissions: #{@new_transmissions}"
  end

  failure_message_when_negated do
    "Expected channel not to transmit #{message.as_json}, but it did"
  end
end

