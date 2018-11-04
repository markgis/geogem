require_relative 'spec_helper'

RSpec.describe PolygonThin do
  describe '#dp ' do
    it 'Reduces the number of nodes in a polygon using the douglas peucker method' do 
      expect(PolygonThin.new("0 0, 10 0, 20 0, 20 20, 0 20, 0 0").dp()).to eq("0 0, 20 0, 20 20, 0 20, 0 0")
    end
  end

  describe '#point_point_distance ' do
  	it 'Measures the distance between 2 points' do
  	  my_object = PolygonThin.new("0 0, 10 0")
  	  expect(my_object.send(:point_point_distance, my_object.nodes[0], my_object.nodes[1])).to eq(10)
		end
	end

	describe '#line_point_distance ' do
		it 'Measures the perpendicular distance between a line and a point' do
		  my_object = PolygonThin.new("0 0, 10 0, 0 10")
		  expect(my_object.send(:line_point_distance, my_object.nodes[0], my_object.nodes[1], my_object.nodes[2]))
		  .to eq(10)
		end
	end
end
