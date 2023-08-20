require "test_helper"

class BroadcasterJobTest < ActionDispatch::IntegrationTest
  include ActionCable::TestHelper

  test "receives a string and broadcasts it through turbo stream channel broadbox" do
    BroadcasterJob.perform_now("Hello, World!")
    assert_broadcasts "broadcaster", 1
  end
end
