require "test_helper"

class Hashnode::GetPublicationsTest < ActiveSupport::TestCase
  test "should get publications" do
    VCR.use_cassette("hashnode/publications") do
      publications = Hashnode::GetPublications.new(authorization_code: "{authorization-token}", username: "hinczuk").call
      assert_equal HTTParty::Response, publications.class
      assert publications.dig("data", "user", "publication", "_id").present?
    end
  end

  test "should not get publications with no authorization code" do
    assert_not Hashnode::GetPublications.new(authorization_code: nil, username: "hinczuk").call
  end

  test "should not get publications with no username code" do
    assert_not Hashnode::GetPublications.new(authorization_code: "something", username: nil).call
  end
end
