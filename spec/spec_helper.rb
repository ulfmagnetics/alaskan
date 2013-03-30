require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
# require 'capybara/rspec'
# require 'rack_session_access/capybara'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

require 'support/factories'