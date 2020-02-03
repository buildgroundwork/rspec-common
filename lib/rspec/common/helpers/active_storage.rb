# frozen_string_literal: true

# Methods for use in specs to create and manipulate ActiveStorage entities.  To
# use, add the following to your rails_helper.rb for RSpec:
#
#   config.before { config.include(RSpec::Common::Helpers::ActiveStorage) }
#
# The #set_uploaded_content depends on use of the ActiveStorage Memory service,
# also included in this gem.

module RSpec::Common
  module Helpers
    module ActiveStorage
      # Create a new 'upload' that is compatible with what ActionController expects
      # to receive.
      def fixture_upload(content: "test content", filename: "text.csv", content_type: "text/csv")
        io = StringIO.new(content)
        Rack::Test::UploadedFile.new(io, content_type, original_filename: filename).tap do |test_file|
          # This works around the erroneous assumption in ActiveStorage that all IO
          # objects provided as attachments will have an #open method.  StringIO
          # objects have no #open method, so a Rack::Test::Uploaded file created
          # with a StringIO will fail when ActiveStorage calls #open on it.
          test_file.singleton_class.instance_eval { define_method(:open) { tempfile } }
        end
      end

      # Insert an ActiveStorage attachment into the test storage.  It will then be
      # available for associated models to 'download.'
      def set_uploaded_content(attachment, content)
        ActiveStorage::Blob.service.override(attachment.blob.key, content)
      end
    end
  end
end

