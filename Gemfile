source "https://rubygems.org"

gem "rails",          "3.2.13"
gem "mysql2"
gem "ruby-trello",    :require => "trello"
gem "dotenv"

group :test do
  gem "database_cleaner"
  gem "factory_girl_rails", "~> 4.0"
  gem "timecop"
end

group :development, :test do
  gem "faker"
  gem "jazz_hands"  # opinionated set of pry plugins
  gem "rspec-rails",    ">= 2.12.2"
end

group :assets do
  gem "sass-rails",   "~> 3.2.3"
  gem "coffee-rails", "~> 3.2.1"

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem "therubyracer", :platforms => :ruby

  gem "uglifier",     ">= 1.0.3"
end

gem "jquery-rails"