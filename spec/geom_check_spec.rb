require_relative 'spec_helper'
require_relative '../geogem'

RSpec.describe GeomCheck do

  pt1 = Point.new('1 2')
  pt2 = Point.new('3 4')

  describe 'radians' do
    it 'gets the bearing in radians between two points' do
      expect(GeomCheck.new.radians(pt1,pt2)).to eq(0.7853981633974483)
    end
  end

  describe 'bearing' do
    it 'gets the bearing in degrees between two points' do
      expect(GeomCheck.new.bearing(pt1,pt2)).to eq(44.999999999999999449063216305326)
    end
  end

end
