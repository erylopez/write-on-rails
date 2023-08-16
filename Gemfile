source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"
gem "rails", "~> 7.0.6"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "turbo-rails"
gem "stimulus-rails"
gem "cssbundling-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "bootsnap", require: false
gem "vite_rails"
gem "devise"
gem "omniauth-github", "~> 2.0.0"
gem "omniauth-rails_csrf_protection"
gem "pry-rails"
gem "httparty"
gem "notion-ruby-client"
gem "notion_to_md"
gem "state_machines-activerecord"

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "standard", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "minitest-reporters"
  gem "mocha"
  gem "vcr"
  gem "webmock"
  gem "simplecov", require: false
end
