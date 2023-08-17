require "simplecov"
SimpleCov.start("rails")
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "mocha/minitest"
require "vcr"

Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

OmniAuth.config.test_mode = true
OmniAuth.config.logger = Rails.logger
Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new

VCR.configure do |config|
  config.cassette_library_dir = Rails.root.join "test/vcr_cassettes"
  config.hook_into :webmock
end

class ActiveSupport::TestCase
  include OmniauthHelper
  include Devise::Test::IntegrationHelpers

  parallelize(workers: :number_of_processors)

  parallelize_setup do |worker|
    SimpleCov.command_name "cov-#{worker}"
  end

  parallelize_teardown do |worker|
    SimpleCov.result
  end

  fixtures :all
end
