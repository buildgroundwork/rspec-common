# frozen_string_literal: true

RSpec::Matchers.define :create_record do |model_class|
  chain :where do |**attributes|
    @proc_attributes, @value_attributes =
      attributes
        .partition { |_, v| v.is_a?(Proc) }
        .collect(&:to_h)
  end

  match do |action|
    relation = model_class.all
    relation = relation.where(**@value_attributes) if @value_attributes.try(:any?)

    before_count = records_for(relation).size
    action.call

    after_count = records_for(relation.reload).size
    after_count == before_count + 1
  end

  failure_message do
    "expected action to create a #{model_class} record"
  end

  failure_message_when_negated do |actual|
    "expected that #{actual} would not be created"
  end

  private

  def records_for(relation)
    if @proc_attributes
      relation = relation.select do |record|
        @proc_attributes.all? { |name, block| record.public_send(name) == block.call }
      end
    end

    relation
  end
end

