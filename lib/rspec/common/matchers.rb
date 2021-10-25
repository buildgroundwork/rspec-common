# frozen_string_literal: true

Dir.glob(File.expand_path("matchers/**/*.rb", __dir__)).each do |path|
  require path
end

