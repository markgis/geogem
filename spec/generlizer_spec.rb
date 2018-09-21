require_relative 'spec_helper'

site = '378217.70000000018626451 389999.80000000074505806, 378217.5 390000, 378211.59999999962747097 390006.40000000037252903, 378211.15000000037252903 390007.15000000037252903, 378210.84999999962747097 390007.90000000037252903, 378210.70000000018626451 390008.75, 378210.70000000018626451 390009.55000000074505806, 378210.84999999962747097 390010.34999999962747097, 378211.20000000018626451 390011.09999999962747097, 378211.59999999962747097 390011.65000000037252903, 378212.15000000037252903 390012.09999999962747097, 378212.75 390012.5, 378224.40000000037252903 390019.75, 378237.65000000037252903 390028.15000000037252903, 378242.75 390021.65000000037252903, 378238.95000000018626451 390018.30000000074505806, 378237.15000000037252903 390016.80000000074505806, 378217.95000000018626451 390000, 378217.70000000018626451 389999.80000000074505806'

expect_output = '378217.70000000018626451 389999.80000000074505806,378217.5 390000.0,378211.5999999996 390006.4000000004,378211.1500000004 390007.1500000004,378210.8499999996 390007.9000000004,378210.7000000002 390008.75,378210.7000000002 390009.55000000075,378210.8499999996 390010.3499999996,378211.5999999996 390011.6500000004,378212.1500000004 390012.0999999996,378212.75 390012.5,378224.4000000004 390019.75,378237.6500000004 390028.1500000004,378242.75 390021.6500000004,378238.9500000002 390018.30000000075,378237.1500000004 390016.80000000075,378217.9500000002 390000.0,378217.70000000018626451 389999.80000000074505806'

RSpec.describe Generlizer do
  describe 'distance' do
    it 'returns distance from two points' do
      expect(Generlizer.new.distance(400000,200000,400100,200000)).to eq(100)
    end
  end

  describe 'node_split' do
    it 'returns nodes split as array of objects' do
      expect(Generlizer.new.node_split('0 1, 0 2, 0 4, 1 4, 2 4, 4 4')).to eq([{:x=>0, :y=>2}, {:x=>0, :y=>4}, {:x=>1, :y=>4}, {:x=>2, :y=>4}])
    end

  describe'node_distance' do
    it 'returns distance between nodes' do
      expect(Generlizer.new.node_distance('0 1, 0 2, 0 4, 1 4, 2 4, 4 4')).to eq([{:point=>{:x=>0, :y=>2}, :dist_to_next=>2.0}, {:point=>{:x=>0, :y=>4}, :dist_to_next=>1.0}, {:point=>{:x=>1, :y=>4}, :dist_to_next=>1.0}, {:point=>{:x=>2, :y=>4}, :dist_to_next=>-1}])
    end
  end

  describe 'first_node' do
    it 'returns the first node x and y from string' do
      expect(Generlizer.new.first_node('0 1, 0 2, 0 4, 1 4, 2 4, 4 4')).to eq(:point => {:x=>"0", :y=>"1"})
    end
  end

  describe 'last_node' do
    it 'returns the last node x and y from string' do
      expect(Generlizer.new.last_node('0 1, 0 2, 0 4, 1 4, 2 4, 4 4')).to eq(:point => {:x=>"4", :y=>"4"})
    end
  end

  # describe 'node_thin' do
  #   it 'removes nodes that are closer then tolerance' do
  #     expect(Generlizer.new.radial_thin('0 1, 0 2, 0 4, 1 4, 2 4, 4 4', 1)).to eq('0 1, 0 4, 1 4, 2 4, 4 4')
  #   end

  describe 'node_thin' do
    it 'removes nodes that are closer then tolerance from live example' do
      expect(Generlizer.new.radial_thin(site, 0.7)).to eq(expect_output)
    end
  end
  end
end
# end
