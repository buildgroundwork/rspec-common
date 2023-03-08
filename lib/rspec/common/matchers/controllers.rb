# frozen_string_literal: true

RSpec::Matchers.define :respond_with_status do |expected_status|
  match do |action|
    action.call
    expect(response).to have_http_status(expected_status)
    true
  end

  failure_message do
    "expected action to respond with #{expected_status}, but got #{response.status}"
  end
end

class RespondWithRedirectMatcher
  def initialize(rspec, response, target_path, &target_path_block)
    @rspec = rspec
    @response = response
    @target_path = target_path
    @target_path_block = target_path_block
  end

  def matches?(block)
    block.call
    target_path = @target_path_block.try(:call) || @target_path
    @rspec.expect(@response).to @rspec.redirect_to(target_path)
    true
  end

  def failure_message
    "expected a redirect to #{@target_path}"
  end

  def description
    "respond with redirect"
  end
end

define_method :respond_with_redirect_to do |*target_paths, &target_path_block|
  target_path = target_paths.first
  RespondWithRedirectMatcher.new(self, response, target_path, &target_path_block)
end

RSpec::Matchers.define :respond_with_template do |template_name|
  match do |block|
    block.call
    expect(response).to have_rendered(template_name)
    true
  end
end

RSpec::Matchers.define :respond_with_text do |text|
  match do |block|
    block.call
    response.body == text
  end

  failure_message do
    "expected response body text to be '#{text}' but was '#{response.body}'"
  end
end

RSpec::Matchers.define :assign do |*vars|
  match do |block|
    block.call
    vars.all? { |var| assigns.symbolize_keys[var] }
  end
end

RSpec::Matchers.define :set_flash do |type|
  chain :to do |message|
    @expected_message = message
  end

  chain :now do
    @now = true
  end

  match do |block|
    block.call

    message = @now ? flash.now[type] : flash[type]

    if @expected_message
      message.match(@expected_message)
    else
      message.present?
    end
  end

  failure_message do |_actual|
    message = "Expected flash#{'.now' if @now}[#{type}] to "
    if @expected_message
      "#{message} match '#{@expected_message}', but was '#{flash[type]}'"
    else
      "#{message} be set, but it was not"
    end
  end
end

