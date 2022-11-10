# frozen_string_literal: true

MatchRefinement = Struct.new(:message, :args, :kwargs)

RSpec::Matchers.define :send_message do |message|
  chain :to, :receiver
  chain :with, :args

  define_method :refinements do
    @refinements ||= []
  end
  private :refinements

  define_method(:method_missing) do |method, *args, **kwargs|
    if respond_to?(method)
      super(method, *args, **kwargs)
    else
      refinements << MatchRefinement.new(method, args, kwargs)
      self
    end
  end

  match do |action|
    raise "The `send_message` matcher requires a receiver" unless receiver

    allow(receiver).to receive(message)

    action.call

    match = have_received(message)
    match = match.with(args) if args
    match = refinements.inject(match) { |refined, ref| refined.public_send(ref.message, *ref.args, **ref.kwargs) }
    expect(receiver).to(match)
  end
end

