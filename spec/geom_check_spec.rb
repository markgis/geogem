require_relative 'spec_helper'

RSpec.describe GeomCheck do

  describe 'radians' do
    it 'gets the bearing in radians between two points' do
      expect(GeomCheck.new.radians([1,2],[3,4])).to eq(0.7853981633974483)
    end
  end

  describe 'bearing' do
    it 'gets the bearing in degrees between two points' do
      expect(GeomCheck.new.bearing([1,2],[3,4])).to eq(44.999999999999999449063216305326)
    end
  end

end
