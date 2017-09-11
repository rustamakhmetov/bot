# require 'capybara'
# require './settings'
# Capybara::Webkit.configure do |config|
#   config.allow_unknown_urls
# end

# require 'watir-webdriver'
# b = Watir::Browser.new
# b.goto 'bit.ly/watir-webdriver-demo'
# b.text_field(:id => 'entry_1000000').set 'your name'
# b.select_list(:id => 'entry_1000001').select 'Ruby'
# b.select_list(:id => 'entry_1000001').selected? 'Ruby'
# b.button(:name => 'submit').click
# b.text.include? 'Thank you'

class Cabinet
  def initialize(test: false)
    @url = test ? "https://target-sandbox.my.com" : "https://target.my.com"
    @session = Capybara::Session.new(:selenium)
  end

  def login(email, password)
    @session.visit @url
    wait_for_ajax
    @session.save_and_open_page
    elem = @session.find(:css, "span:contains('Log In')")
    @session.click_on "Log In"
    a=1
  end

  def method_missing(method, *args, &block)
    # if [:id, :created_at].include?(method)
    #   return nil unless @user
      @session.__send__(method, *args, &block)
    # else
    #   super(method, *args, &block)
    # end
  end

  private

  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    @session.evaluate_script('window.jQuery.active').zero?
  end

end

require 'watir'

browser = Watir::Browser.new :phantomjs

browser.goto 'https://target-sandbox.my.com'
File.open('../tmp/google', 'w') {|f| f.write browser.html }
#browser.link(text: 'LOG IN').click

puts browser.title
# => 'Documentation – Watir Project...'
browser.close

exit



email = "rustamakhmetov@yandex.ru"
password = "yxe99kyr"

cabinet = Cabinet.new(test: true)
cabinet.login(email, password)



#session.driver.browser.window.resize_to(2_500, 2_500)
#session.visit("http://e1.ru")

#session.save_and_open_page