require 'spec_helper'
require 'rspec/core'
require './service/cabinet'
require 'json'

#Watir.default_timeout = 5

RSpec.describe Cabinet do
  let(:cab) { Cabinet.new(test:true) }
  let(:email) { "kubayi@p33.org" }
  let(:password) { "yxe99kyr" }

  describe "#login" do
    context "with valid attributes" do
      it "success authorization" do
        expect(cab.login(email, password)).to eq true
      end
    end

    context "with invalid attributes" do
      it "empty login/password" do
        expect{cab.login("", "")}.to raise_error(Errors::UnprocessableEntity,
                                                 "Please input email or mobile phone number")
      end

      it "invalid login/password" do
        expect{cab.login("test@test.com", "123456")}.to raise_error(Errors::UnprocessableEntity,
                                                 /Login attempts limit has been exceeded|Invalid email or password/)
      end
    end
  end

  describe "#add_app" do
    before do
      cab.login(email, password)
    end

    context "with valid attributes" do
      let(:app_url) { "https://itunes.apple.com/us/app/angry-birds/id343200656?mt=8" }

      it 'returns data with app_id, placement_id, slot_id' do
        app_id = cab.add_app(app_url)
        app_json = cab[app_id].to_json
        %w{id name placements/0/id placements/0/name placements/0/ad_type placements/0/slot_id}.each do |path|
          expect(app_json).to have_json_path(path)
        end
      end
    end

    context "with invalid attributes" do
      context "returns error message" do
        it 'invalid app link' do
          expect{ cab.add_app("dddfsdf") }.to raise_error(Errors::UnprocessableEntity, "Invalid app link")
        end
      end
    end
  end

  describe "#add_all_placements" do
    before do
      cab.login(email, password)
    end

    context "with valid attributes" do
      let(:app_url) { "https://itunes.apple.com/us/app/angry-birds/id343200656?mt=8" }

      it 'returns data with app_id, placement_id, slot_id' do
        app_id = cab.add_app(app_url)
        cab.add_all_placements(app_id)
        app_json = cab[app_id].to_json

        %w{id name placements/0/id placements/0/name placements/0/ad_type placements/0/slot_id}.each do |path|
          expect(app_json).to have_json_path(path)
        end
        expect(app_json).to have_json_size(8).at_path("placements")
      end
    end
  end
end