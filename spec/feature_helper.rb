require 'rails_helper'

RSpec.configure do |config|
  require 'capybara/poltergeist'
  Capybara.javascript_driver = :poltergeist
  Capybara.default_max_wait_time = 5
end
