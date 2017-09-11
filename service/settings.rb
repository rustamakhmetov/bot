require 'capybara'
#require './wait_for_ajax.rb'
#require 'capybara/webkit'
#require 'capybara/selenium'

Capybara.default_driver = :selenium
Capybara.javascript_driver = :selenium_chrome

#Capybara.javascript_driver = :webkit
#Capybara.server = :puma
Capybara.default_max_wait_time = 5
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end