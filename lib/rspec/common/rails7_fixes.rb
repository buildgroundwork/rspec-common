# frozen_string_literal: true

Dir.glob(File.expand_path("rails7_fixes/**/*.rb", __dir__)).each do |path|
  require path
end

