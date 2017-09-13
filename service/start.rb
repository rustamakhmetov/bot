require './cabinet'

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


app_url = "https://itunes.apple.com/us/app/angry-birds/id343200656?mt=8"
email = "rustamakhmetov@yandex.ru"
password = "yxe99kyr"
fname = "../tmp/test.json"

cabinet = Cabinet.new
cabinet.login(email, password)
app = cabinet.add_app(app_url)
cabinet.add_all_placements(app)
cabinet.save(fname)

