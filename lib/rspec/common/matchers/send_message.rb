# frozen_string_literal: true

RSpec::Matchers.define :send_message do |message|
  chain :to do |receiver|
    @receiver = receiver
  end

  chain :with do |args|
    @args = args
  end

  match do |action|
    raise "The `send_message` matcher requires a receiver" unless @receiver

    allow(@receiver).to receive(message)

    action.call

    match = have_received(message)
    match.with(@args) if @args
    expect(@receiver).to(match)
  end
end

