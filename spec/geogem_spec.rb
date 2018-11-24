require_relative '../spec/spec_helper'

RSpec.describe Point do
  describe ' #distance' do
    it 'returns distance from two points' do
      expect(Point.new("400000 200000").distance(Point.new("400100 200000")))
      .to eq(100)
    end
  end

  describe ' #point_buff' do
    it 'returns circle geometry buffering point' do
      expect(Point.new("500000 150000").point_buff(100,12))
      .to eq("500100.0 150000.0, 500086.60254037846 150050.0, 500050.0 150086.60254037843, 500000.0 150100.0, 499950.0 150086.60254037843, 499913.39745962154 150050.0, 499900.0 150000.0, 499913.39745962154 149950.0, 499950.0 149913.39745962157, 500000.0 149900.0, 500050.0 149913.39745962157, 500086.60254037846 149950.0, 500100.0 150000.0")
    end
  end

  describe ' #to_wkt' do
    it 'returns the point in Well Known Text format' do
      expect(Point.new("200000 300000").to_wkt)
      .to eq("POINT(200000 300000)")
    end
  end
end

RSpec.describe Polygon do
  describe ' #centre_point' do
    it 'returns centre point of a polygon' do
      expect(Polygon.new("520575 170388, 520617 170405, 520624 170389, 520582 170371, 520575 170388").centre_point)
      .to eq("520599.5 170388.0")
    end
  end

  describe ' #bbox' do
    it 'returns bounding box geometry of a polygon' do
      expect(Polygon.new("520575 170388, 520617 170405, 520624 170389, 520582 170371, 520575 170388").bbox)
      .to eq("520575 170371, 520624 170405")
    end
  end

  # describe ' #area' do
  #   it 'returns the area of a polyon' do
  #     expect(Polygon.new("0 0, 10 0, 10 10, 0 10, 0 0").area)
  #     .to eq(100)
  #   end
  # end

  describe ' #intersect?' do
    it 'returns true if 2 line segments intersect' do
      my_obj = Polygon.new("0 0")
      expect(my_obj.send(:intersect?, [Point.new("0 0"), Point.new("2 2")], [Point.new("2 0"), Point.new("0 2")]))
      .to eq(true)
    end
  end

  describe '#intersect?' do
    it 'returns false when 2 line segments don\'t intersect' do
      my_obj = Polygon.new("0 0")
      expect(my_obj.send(:intersect?, [Point.new("10 0"), Point.new("0 10")], [Point.new("0 5"), Point.new("0 4")]))
      .to eq(false)
    end
  end

  describe ' #self_intersects?' do
    it 'returns true if a polygon intersects with it\'s self' do
      expect(Polygon.new("0 0, 2 2, 0 2, 2 0, 0 0").self_intersects?)
      .to eq(true)
    end
  end

  describe 'self_intersects?' do
    it 'returns false when a polygon does not cross itself' do
      expect(Polygon.new("0 0, 0 2, 2 2, 2 0, 0 0").self_intersects?)
      .to eq(false)
    end
  end

  describe '#to_wkt(polygon)' do
    it 'returns the wkt of a polygon' do
      expect(Polygon.new("Polygon((0 0, 10 0, 10 10, 0 10, 0 0))").to_wkt)
      .to eq("POLYGON((0 0, 10 0, 10 10, 0 10, 0 0))")
    end
  end

  describe '#intersects?' do
    it 'returns true if 2 polygons intersect' do
      expect(Polygon.new("0 0, 10 0, 10 10, 0 10, 0 0").intersects?(Polygon.new("5 5, 20 0, 20 30, 0 20, 5 5")))
      .to eq(true)
    end
  end

  describe 'intersects?' do
    it 'returns false when 2 polygon do not intersect' do
      expect(Polygon.new("0 0, 0 10, 5 5, 10 10, 10 0, 0 0").intersects?(Polygon.new("0 11, 5 6, 10 11, 10 20, 0 20, 0 11")))
      .to eq(false)
    end
  end

  describe '#point_in_poly?' do
    it 'returns true if a point lies inside a polygon' do
      expect(Polygon.new("0 0, 100 0, 100 100, 0 100, 0 0").send(:point_in_poly?, Point.new("50 50")))
      .to eq(true)
    end
  end

  describe 'intersection' do
    it 'returns the intersection point of 2 lines' do
      my_obj = Polygon.new("0 50, 100 50, 50 0, 50 100, 0 50")
      expect(my_obj.intersection(my_obj.lines[0],my_obj.lines[2]))
      .to eq("50.0 50.0")
    end
  end

  describe 'intersection' do
    it 'returns false if 2 lines don\'t intersect' do
      my_obj = Polygon.new("0 0, 0 100, 100 50, 200, 50, 0 0")
      expect(my_obj.intersection(my_obj.lines[0],my_obj.lines[2]))
      .to eq(false)
    end
  end

  describe 'intersection' do
    it 'returns the intersection point of 2 lines' do
      my_obj = Polygon.new("0 0, 20 20, 0 20, 20 0, 0 0")
      expect(my_obj.intersection(my_obj.lines[0],my_obj.lines[2]))
      .to eq("10.0 10.0")
    end
  end

  describe 'dissolve' do
    it 'returns the combination of 2 polygons' do
      expect(Polygon.new("0 0, 10 0, 10 10, 0 10, 0 0").dissolve(Polygon.new("5 5, 20 5, 20 20, 5 20, 5 5")))
      .to eq("0 0, 0 10, 5.0 10.0, 5 20, 20 20, 20 5, 10.0 5.0, 10 0, 0 0")
    end
  end

  describe 'dissolve' do
    it 'returns false if two polygons don\'t intersect' do
      expect(Polygon.new("0 0, 0 1, 1 1, 1 0, 0 0").dissolve(Polygon.new("5 5, 10 5, 10 10, 5 10, 5 5")))
      .to eq (false)
    end
  end

  describe 'dissolve' do
    it 'returns the combination of 2 polygons when the start point is inside another polygon' do
      expect(Polygon.new("5 5, 20 5, 20 20, 5 20, 5 5").dissolve(Polygon.new("0 0, 10 0, 10 10, 0 10, 0 0")))
      .to eq("20 5, 10.0 5.0, 10 0, 0 0, 0 10, 5.0 10.0, 5 20, 20 20, 20 5")
    end
  end

  describe 'dissolve' do
    it 'returns the combination of 2 polygons when the lines are in opposite directions' do
      expect(Polygon.new("0 0, 10 0, 10 10, 0 10, 0 0").dissolve(Polygon.new("5 5, 5 20, 20 20, 20 5, 5 5")))
      .to eq("0 0, 0 10, 5.0 10.0, 5 20, 20 20, 20 5, 10.0 5.0, 10 0, 0 0")
    end
  end

  describe 'clockwise?' do
    it 'returns true if a polygon\'s nodes are in a clockwise orientation' do
      expect(Polygon.new("0 0, 0 10, 10 10, 10 0, 10").send(:clockwise?))
      .to eq(true)
    end
  end

  describe 'clockwise?' do
    it 'returns false if a polygon\'s nodes are in a counter clockwise formation' do
      expect(Polygon.new("0 0, 10 0, 10 10, 0 10, 0 0").send(:clockwise?))
      .to eq(false)
    end
  end

  describe 'polygon' do
    it 'removes double nodes' do
      expect(Polygon.new("0 0, 10 0, 10 0, 10 10, 0 10, 0 0").to_wkt)
      .to eq("POLYGON((0 0, 10 0, 10 10, 0 10, 0 0))")
    end
  end

  describe 'cleaner' do
    it 'returns a polygon without a self_intersection while maintaining the same shape' do
      expect(Polygon.new("0 0, 20 20, 0 20, 20 0, 0 0").cleaner)
      .to eq("0 0, 9.99 9.99, 0 20, 20 20, 10.01 10.01, 20 0, 0 0")
    end
  end

  describe 'cleaner' do
    it 'returns the same polygon as put in if there is no self intersection' do
      expect(Polygon.new("0 0, 10 0, 10 10, 0 10, 0 0").cleaner)
      .to eq("0 0, 10 0, 10 10, 0 10, 0 0")
    end
  end

  describe 'cleaner' do
    it 'removes self-intersections without moving nodes too far apart' do
      expect(Polygon.new("500000 100000, 500100 100100, 500100 100000, 500000 100100, 500000 100000").cleaner)
      .to eq("500000 100000, 500049.95 100049.95, 500100 100000, 500100 100100, 500050.05 100050.05, 500000 100100, 500000 100000")
    end
  end

  describe 'clip' do
    it 'returns the nodes of a polygon with the nodes of another polygon removed' do
      expect(Polygon.new("0 0, 10 0, 10 10, 0 10, 0 0").clip(Polygon.new("5 5, 15 5, 15 15, 5 15, 5 5")))
      .to eq("0 0, 0 10, 5.0 10.0, 5 5, 10.0 5.0, 10 0, 0 0")
    end
  end

  describe 'clip' do
    it 'returns the original polygon if the 2 polygons don\'t intersect' do
      expect(Polygon.new("0 0, 1 0, 1 1, 0 1, 0 0").clip(Polygon.new("10 10, 15 10, 15, 15, 10 15, 10 10")))
      .to eq("POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))")
    end
  end
end
