# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec::Matchers.define :create_record do |model_class|
  chain :where do |attributes|
    raise ArgumentError unless attributes.is_a?(Hash)

    @proc_attributes, @value_attributes =
      attributes
        .partition { |_, v| v.is_a?(Proc) }
        .collect(&:to_h)
  end

  match do |action|
    relation = model_class.all
    existing_ids = relation.pluck(:id)

    relation = relation.where(**@value_attributes) if @value_attributes.try(:any?)

    action.call

    @created_count = records_for(relation.where.not(id: existing_ids)).size

    @created_count == 1
  end

  failure_message do
    "expected action to create 1 #{model_class} record, but created #{@created_count}"
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

RSpec::Matchers.define :destroy_record do |model|
  match do |action|
    action.call

    model.class.where(id: model).none?
  end

  failure_message do
    "expected action to destroy #{model}, but did not"
  end

  failure_message_when_negated do
    "expected action to not destroy #{model}, but the record was destroyed"
  end
end
# rubocop:enable Metrics/BlockLength

