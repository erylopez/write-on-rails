ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

OmniAuth.config.test_mode = true
OmniAuth.config.logger = Rails.logger

class ActiveSupport::TestCase
  include OmniauthHelper
  include Devise::Test::IntegrationHelpers

  parallelize(workers: :number_of_processors)
  fixtures :all
end
