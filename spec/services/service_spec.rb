#require 'spec_helper'
require 'rspec/core'
require './services/service'

RSpec.describe Service do
  describe ".max_multiplication" do
    context "with valid attributes" do
      it "returns max multiplication" do
        expect(Service.max_multiplication("abc12345def")).to eq 120
        expect(Service.max_multiplication("a1b2c3d4e9876ghgfgh876r")).to eq 3024
      end
    end

    context "with invalid attributes" do
      it "returns nil" do
        expect(Service.max_multiplication("a1b2c3d4e")).to eq nil
        expect(Service.max_multiplication(Class)).to eq nil
        expect(Service.max_multiplication(1234)).to eq nil
      end
    end
  end

  describe ".sort" do
    context "with valid attributes" do
      it "returns sorted array of numbers" do
        expect(Service.sort([3,7,8,9])).to match_array([8,3,9,7])
      end

      it "returns sorted array of numbers by binary and decimap representations" do
        #  Dec           Bin             1's
        # 16375   0011111111110111        13
        # 15342   0011101111101110        11
        # 32425   0111111010101001        10
        # 11746   0010110111100010         8
        # 28436   0000110111110100         8
        # 19944   0100110111101000         8
        # 28943   0000011100011111         8
        # 3944    0000011111101000         7
        # 15752   0011110110001000         7
        # 825     0000000011111001         6
        # 21826   0101010101000010         6

        values = [16375, 15342, 32425, 11746, 28436, 19944, 28943, 3944, 15752, 825, 21826]
        expect(Service.sort(values.shuffle)).to match_array(values)
      end
    end

    context "with invalid attributes" do
      it "returns sorted array of numbers with ignore nil" do
        expect(Service.sort([nil,7,8,9])).to match_array([8,9,7])
      end
    end
  end

end
