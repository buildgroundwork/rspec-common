# frozen_string_literal: true

RSpec::Matchers.define :create_record do |model_class|
  chain :where do |**attributes|
    @attributes = attributes
  end

  match do |action|
    relation = model_class.all
    relation = relation.where(**@attributes) if @attributes

    before_count = relation.count
    action.call

    relation.count == before_count + 1
  end

  failure_message do
    "expected action to create a #{model_class} record"
  end

  failure_message_when_negated do |actual|
    "expected that #{actual} would not be created"
  end
end

