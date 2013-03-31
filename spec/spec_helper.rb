require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
# require 'capybara/rspec'
# require 'rack_session_access/capybara'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.use_transactional_fixtures = false

  config.before(:all) do
    DatabaseCleaner.clean_with :truncation
  end

  config.after(:all) do
    DatabaseCleaner.clean_with :truncation
  end
end

require 'support/factories'