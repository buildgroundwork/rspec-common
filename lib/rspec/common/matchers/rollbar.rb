# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec::Matchers.define :send_rollbar_report do |level|
  chain :with_exception_class do |exception_class|
    @exception_class = exception_class
  end

  chain :with_extra do |extra|
    @extra = extra
  end

  chain :with_message do |message|
    @message = message
  end

  chain :once do
    @once = true
  end

  match do |action|
    Rollbar.reset!
    @level = level

    action.call

    matches = Rollbar.logs.select do |item|
      match = item.level.to_sym == @level.to_sym
      match &&= item.message == @message if @message
      match &&= item.exception.is_a?(@exception_class) if @exception_class
      match &&= item.extra == @extra if @extra
      match
    end

    @once ? matches.one? : matches.any?
  end

  def failure_message
    message = "Expected Rollbar to receive report with level '#{@level}'"
    message << " exactly once" if @once
    message << "\n    with message #{@message.inspect}" if @message
    message << "\n    with exception class #{@exception_class}" if @exception_class
    message << "\n    with extra params #{@extra.inspect}" if @extra
    message << "\n"
    message << "\nActual logs:"
    Rollbar.logs.each { |item| message << "\n    - #{item}" }
    message
  end
end
# rubocop:enable Metrics/BlockLength

