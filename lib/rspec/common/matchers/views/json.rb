# frozen_string_literal: true

module JsonMatcherChains
  def initialize(parent, *)
    @parent = parent
  end

  attr_reader :parent

  def containing(&block)
    JsonContainsMatcher.new(self, &block)
  end

  def of_length(length)
    JsonLengthMatcher.new(self, length)
  end

  def with_element(*keys)
    JsonElementMatcher.new(self, *keys)
  end

  def and
    JsonMatcherAnd.new(self)
  end

  def results_for(json)
    @results_for ||= generate_results_for(json)
  end
end

class JsonElementMatcher
  include JsonMatcherChains

  def initialize(parent, *keys)
    super
    # JSON elements are camelcase strings
    @keys = keys.collect { |key| key.to_s.camelize(:lower) }
  end

  def with_value(expected)
    @value = expected.as_json
    @expecting_value = true
    self
  end

  def matches?(actual)
    @actual = actual
    match = results_for(actual)
    expecting_value ? has_keys? && match == value : match
  end

  def failure_message
    message = parent.failure_message
    message += " with element #{keys.join('/')}"
    message += " with value '#{value}'" if expecting_value
    message
  end

  def description
    "have JSON element"
  end

  private

  attr_reader :keys, :value, :expecting_value, :actual

  def generate_results_for(json)
    hash = parent.results_for(json)
    hash.dig(*keys) if hash.is_a?(Hash)
  end

  # rubocop:disable Naming/PredicateName
  def has_keys?
    hash = parent.results_for(actual)

    keys.inject(true) do |memo, key|
      if memo && hash.has_key?(key)
        hash = hash[key]
        true
      else
        false
      end
    end
  end
  # rubocop:enable Naming/PredicateName
end

class JsonArrayMatcher
  include JsonMatcherChains

  def matches?(json)
    results_for(json)
  end

  def failure_message
    parent.failure_message + " be array"
  end

  def description
    "be JSON array"
  end

  private

  def generate_results_for(json)
    array = parent.results_for(json)
    array if array.is_a?(Array)
  end
end

class JsonLengthMatcher
  include JsonMatcherChains

  def initialize(parent, length)
    super
    @length = length
  end

  def matches?(json)
    results_for(json)&.length == length
  end

  def failure_message
    parent.failure_message + " with length #{length}"
  end

  def description
    "have length"
  end

  private

  attr_reader :length

  def generate_results_for(json)
    array = parent.results_for(json)
    array if array.is_a?(Array)
  end
end

class JsonContainsMatcher
  include JsonMatcherChains

  def initialize(parent, &block)
    super
    @block = block
  end

  def matches?(json)
    results_for(json)
  end

  def failure_message
    parent.failure_message + " containing a specific element"
  end

  def description
    "contain JSON element"
  end

  private

  attr_reader :parent, :block

  def generate_results_for(json)
    array = parent.results_for(json)
    array.detect(&block) if array.is_a?(Array)
  end
end

class JsonMatcherAnd
  include JsonMatcherChains
  def results_for(json)
    parent.parent.results_for(json)
  end

  def failure_message
    parent.failure_message + " and"
  end
end

class JsonMatcherRoot
  class << self
    def instance
      @instance ||= new
    end
  end

  attr_reader :failure_message

  def results_for(json)
    JSON.parse(json)
  end

  private

  def initialize
    @failure_message = "expected a JSON response"
  end
end

define_method :be_json_array do
  JsonArrayMatcher.new(JsonMatcherRoot.instance)
end

# rubocop:disable Naming/PredicateName
define_method :have_json_element do |*elements|
  JsonElementMatcher.new(JsonMatcherRoot.instance, *elements)
end
# rubocop:enable Naming/PredicateName

