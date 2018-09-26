require_relative 'spec_helper'

line = '378191.75 390015.55000000074505806, 378198.59999999962747097 390020.05000000074505806, 378198.59999999962747097 390020.05000000074505806'
point = '378197.19792838295688853 390015.77902741997968405'
site = '378217.70000000018626451 389999.80000000074505806, 378217.5 390000, 378211.59999999962747097 390006.40000000037252903, 378211.15000000037252903 390007.15000000037252903, 378210.84999999962747097 390007.90000000037252903, 378210.70000000018626451 390008.75, 378210.70000000018626451 390009.55000000074505806, 378210.84999999962747097 390010.34999999962747097, 378211.20000000018626451 390011.09999999962747097, 378211.59999999962747097 390011.65000000037252903, 378212.15000000037252903 390012.09999999962747097, 378212.75 390012.5, 378224.40000000037252903 390019.75, 378237.65000000037252903 390028.15000000037252903, 378242.75 390021.65000000037252903, 378238.95000000018626451 390018.30000000074505806, 378237.15000000037252903 390016.80000000074505806, 378217.95000000018626451 390000, 378217.70000000018626451 389999.80000000074505806'

RSpec.describe PerpendDistance do
  describe 'distance' do
    it 'returns distance from two points' do
      expect(PerpendDistance.new.distance(400000,200000,400100,200000)).to eq(100)
    end
  end

  describe 'node_split' do
    it 'returns nodes split as array of objects' do
      expect(PerpendDistance.new.node_split('0 1, 0 2, 0 4, 1 4, 2 4, 4 4')).to eq([{:x=>0, :y=>2}, {:x=>0, :y=>4}, {:x=>1, :y=>4}, {:x=>2, :y=>4}])
    end
  end

  describe 'first_node' do
    it 'returns the first node x and y from string' do
      expect(PerpendDistance.new.first_node('0 1, 0 2, 0 4, 1 4, 2 4, 4 4')).to eq(:point => {:x=>"0", :y=>"1"})
    end
  end

  describe 'first_node_plain' do
    it 'returns the first node x and y from string' do
      expect(PerpendDistance.new.first_node_plain(site)).to eq(['378217.70000000018626451','389999.80000000074505806'])
    end
  end

  describe 'last_node' do
    it 'returns the last node x and y from string' do
      expect(PerpendDistance.new.last_node('0 1, 0 2, 0 4, 1 4, 2 4, 4 4')).to eq(:point => {:x=>"4", :y=>"4"})
    end
  end

  describe 'line_point_distance' do
    it 'returns distance between line and point' do
      expect(PerpendDistance.new.line_point_distance(line, point)).to eq(2.799800776373077)
    end
  end

  describe 'third_node' do
    it 'returns third node from a line' do
      expect(PerpendDistance.new.third_node(site)).to eq(['378211.59999999962747097','390006.40000000037252903'])
    end
  end

  describe 'perpend_thin' do
    it 'returns polygon with thinned nodes' do
      expect(PerpendDistance.new.perpend_thin(site,1)).to eq('378211.59999999962747097 390006.40000000037252903')
    end
  end
end
