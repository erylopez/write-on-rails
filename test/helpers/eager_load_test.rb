require "test_helper"

class EagerLoadTest < ActiveSupport::TestCase
  # We test this to ensure that we don't have syntax errors in our code on eager load
  # These errors are silent in development and test environments, but wont let the app boot in production
  test "eager loads all files without errors" do
    assert_nothing_raised { Rails.application.eager_load! }
  end
end
