# frozen_string_literal: true

# This adds Pundit to test view objects, so view tests that use Pundit methods
# such as #policy or #pundit_user will work properly.  Useful if you are using
# Jbuilder#authorize! from the rails-boost gem along with Pundit.
module RSpec::Common
  module Helpers
    module Views
      module Pundit
        class << self
          def included(klass)
            klass.setup(:add_pundit_to_test_views)
          end
        end

        private

        def add_pundit_to_test_views
          view.singleton_class.instance_eval { include ::Pundit::Authorization }
        end
      end
    end
  end
end

