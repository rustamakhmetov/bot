require 'watir'
require 'securerandom'

class AdUnit
  attr_accessor :id, :name, :type
end

class Placement
  attr_accessor :id, :name, :units

  def add_unit

  end
end

class App
  attr_accessor :id, :url
end


class Cabinet
  def initialize(test: false)
    @url = test ? "https://target-sandbox.my.com" : "https://target.my.com"
    @browser = Watir::Browser.new   #.visible = false
    @data = {}
  end

  def login(email, password)
    @email = email
    @browser.goto @url
    @browser.div(text: "Get started").when_present.click
    @browser.text_field(:name => "login").set email
    @browser.text_field(:name => "password").set password
    @browser.button(data_class_name: "Submit").when_present.click
    wait_load_page
  end

  def add_app(app_url)
    @browser.goto "#{@url}/create_pad_groups/"
    wait_load_page

    @browser.text_field(placeholder: "Enter site/app URL").set app_url
    @browser.div(text: "Ad unit").wait_until_present # wait load ad types

    app = {name: @browser.input(placeholder: "Site/app name").value }
    app[:available_ad_types] =
        @browser.elements(xpath: "//ul[@class='adv-block-form__list']//span[@class='format-item__desc-text']").map(&:data_platform_format_id)

    placement_name = "#{@browser.input(placeholder: "Name of placement").value} [#{SecureRandom.hex[0,4]}]"
    @browser.input(placeholder: "Name of placement").to_subtype.set(placement_name)
    placement =  { name: placement_name }
    placement[:ad_type] = app[:available_ad_types].first

    select_ad_type(placement[:ad_type])
    @browser.span(text: "Create app").click
    @browser.link(text: "Add App").wait_until_present #wait load page
    app[:id] = @browser.a(text: app[:name]).href.scan(/\d+$/)[0]

    # placement page
    @browser.goto "#{@url}/pad_groups/#{app[:id]}"
    @browser.link(text: placement[:name]).wait_until_present
    placement[:id] = @browser.link(text: placement[:name]).href.scan(/\d+$/)[0]
    fill_placement_attrs(placement)
    app[:placements] = []
    app[:placements] << placement

    @data[app[:id]] = app
    app[:id]
  end

  def available_ad_types(app)
    @data[app][:available_ad_types] - @data[app][:placements].map {|x| x[:ad_type]}
  end

  def add_placement(app, ad_type)
    @browser.goto "#{@url}/pad_groups/#{app}/create"
    @browser.span(text: "Add placement").wait_until_present
    select_ad_type(ad_type)
    placement_name = "#{@browser.input(placeholder: "Name of placement").value} [#{SecureRandom.hex[0,4]}]"
    @browser.input(placeholder: "Name of placement").to_subtype.set(placement_name)
    placement =  { name: placement_name, ad_type: ad_type }
    @browser.span(text: "Add placement").click
    @browser.link(text: placement[:name]).wait_until_present
    placement[:id] = @browser.link(text: placement[:name]).href.scan(/\d+$/)[0]
    fill_placement_attrs(placement)
    @data[app][:placements] << placement
  end

  def add_all_placements(app)
    available_ad_types(app).each do |ad_type|
      add_placement(app, ad_type)
    end
  end

  def fill_placement_attrs(placement)
    @browser.goto "#{@url}/pads/#{placement[:id]}"
    @browser.div(text: "Placement parameters").wait_until_present
    placement[:slot_id] = @browser.p(text: /slot_id/).text.scan(/\d+$/)[0]
  end

  def select_ad_type(ad_type)
    @browser.span(data_platform_format_id: ad_type).parent.element(xpath: './following-sibling::*').click
  end

  def save(fname)
    File.write(fname, @data.to_json)
  end

  def load(fname)
    @data=JSON.parse(File.read(fname))
  end

  # def method_missing(method, *args, &block)
  #   # if [:id, :created_at].include?(method)
  #   #   return nil unless @user
  #     @session.__send__(method, *args, &block)
  #   # else
  #   #   super(method, *args, &block)
  #   # end
  # end

  private

  def wait_load_page
    @browser.span(text: @email).wait_until_present
  end
end




app_url = "https://itunes.apple.com/us/app/angry-birds/id343200656?mt=8"
email = "rustamakhmetov@yandex.ru"
password = "yxe99kyr"
fname = "../tmp/test.json"

cabinet = Cabinet.new
cabinet.login(email, password)
# if File.exists?(fname)
#   cabinet.load(fname)
# end

app = cabinet.add_app(app_url)
cabinet.add_all_placements(app)
cabinet.save(fname)

