# frozen_string_literal: true

%i[create update delete].each do |action|
  RSpec::Matchers.define :"#{action}_elasticsearch_index_with" do |**params|
    match do |block|
      Doubles::Elasticsearch::Client.reset!

      block.call

      @matches = Doubles::Elasticsearch::Client.calls[action]&.select { |match| match == params }
      @matches&.one?
    end

    failure_message do
      message = "expected to #{action} Elasticsearch index with #{params.inspect}\n\n"
      message += "Actual #{action} changes to Elasticsearch indices:\n"
      Doubles::Elasticsearch::Client.calls[action]&.each do |match|
        message += "\t- #{match.inspect}"
      end
      message
    end
  end
end

