# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
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
    relation = filter_by_proc_attributes(relation) if @proc_attributes
    relation
  end

  def filter_by_proc_attributes(relation)
    relation.select do |record|
      @proc_attributes.all? do |name, block|
        expected = block.call
        methods = name.to_s.split(".")
        actual = methods.inject(record) { |receiver, method| receiver.public_send(method) }
        actual == expected
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength

