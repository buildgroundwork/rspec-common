# frozen_string_literal: true

require "rspec/rails/example/view_example_group"

module RSpec::Rails::ViewExampleGroup::ExampleMethods::Rails7Fixes
  private

  # ActionView has changed its template lookup to be more strict.  It now
  # expects the name of the handler to be a symbol, while previously it would
  # accept a string.  RSpec still sets the handler as a string, so we change it
  # here to a symbol so template lookup will work.
  def _default_render_options
    render_options = super
    render_options.tap { |options| options[:handlers]&.collect!(&:to_sym) }
  end
end

module RSpec::Rails::ViewExampleGroup::ExampleMethods
  prepend Rails7Fixes
end

