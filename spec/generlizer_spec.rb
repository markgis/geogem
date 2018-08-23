require_relative 'spec_helper'

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
      expect(Generlizer.new.first_node('0 1, 0 2, 0 4, 1 4, 2 4, 4 4')).to eq('0 1')
    end
  end

  describe 'last_node' do
    it 'returns the last node x and y from string' do
      expect(Generlizer.new.last_node('0 1, 0 2, 0 4, 1 4, 2 4, 4 4')).to eq('4 4')
    end
  end

  describe 'node_thin' do
    it 'removes nodes that are closer then tolerance' do
      expect(Generlizer.new.radial_thin('0 1, 0 2, 0 4, 1 4, 2 4, 4 4', 2)).to eq('0 1, 0 4, 1 4, 4 4')
    end
  end
  end
end
