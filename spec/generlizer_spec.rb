require_relative 'spec_helper'

RSpec.describe Generlizer do
  describe 'distance' do
    it 'returns distance from two points' do
      expect(Generlizer.new.distance(400000,200000,400100,200000)).to eq(100)
end
  # describe 'node_thin' do
  #   it 'removes nodes that are closer then tolerance' do
  #     expect(Generlizer.new.radial_thin('0 1, 0 2, 0 4, 1 4, 2 4, 4 4', 1)).to eq('0 1, 0 4, 1 4, 4 4')
  #   end
  # end
end
end
