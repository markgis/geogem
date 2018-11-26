require_relative 'spec_helper'
require_relative '../lib/geogem'

RSpec.describe GeomMeasure do

  pt1 = Point.new('1 2')
  pt2 = Point.new('3 4')

  pt3 = Point.new('531280 104073')
  pt4 = Point.new('531209 104125')
  pt5 = Point.new('531280 304073')
  pt6 = Point.new('623891 308256')
  pt7 = Point.new('169546 11645')

  describe 'radians' do
    it 'returns a bearing of 0.785[...] radians for point (1 2) to (3 4)' do
      #skip
      expect(GeomMeasure.new.radians(pt1,pt2)).to eq(0.7853981633974483)
    end
    it 'returns a bearing of 5.344[...] radians for point (531280 104073) to (531209 104125)' do
      #skip
      expect(GeomMeasure.new.radians(pt3,pt4)).to eq(5.344526941913683)
    end
    it 'returns a bearing of 0 radians for point (1 2) to itself' do
      #skip
      expect(GeomMeasure.new.radians(pt1,pt1)).to eq(0)
    end
    it 'returns a bearing 0 radians for point (531280 104073) to (531280 304073)' do
      #skip
      expect(GeomMeasure.new.radians(pt3,pt5)).to eq(0)
    end
  end

  describe 'bearing' do
    it 'returns a bearing of 44.999[...] degrees for point (1 2) to (3 4)' do
      #skip
      expect(GeomMeasure.new.bearing(pt1,pt2)).to eq(44.999999999999999449063216305326)
    end
    it 'returns a bearing 306.218[...] degrees for point (531280 104073) to (531209 104125)' do
      #skip
      expect(GeomMeasure.new.bearing(pt3,pt4)).to eq(306.2188372656145)
    end
    it 'returns a bearing of 0 degrees for point (1 2) to itself' do
      #skip
      expect(GeomMeasure.new.bearing(pt1,pt1)).to eq(0)
    end
    it 'returns a bearing 180 degrees for point (531280 304073) to (531280 104073)' do
      #skip
      expect(GeomMeasure.new.bearing(pt5,pt3)).to eq(180)
    end
    it 'returns a bearing of 24.39[...] degrees for point (531280 104073) to (623891 308256)' do
      expect(GeomMeasure.new.bearing(pt3,pt6)).to eq(24.397552507469438)
    end
    it 'returns a bearing of 236.86[...] degrees for point (623891 308256) to (169546 11645)' do
      expect(GeomMeasure.new.bearing(pt6,pt7)).to eq(236.86220809677928)
    end
  end

end
