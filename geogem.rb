include Math
require 'pry-byebug'

class Polygon
  attr_reader :nodes
  attr_reader :lines

  def initialize(wkt)
    @nodes = wkt.downcase.delete('polygon()')
                .split(', ').map { |xy| Point.new(xy) }
    @lines = nodes.slice(0, nodes.length-1).zip(nodes.slice(1,nodes.length))
  end

  def to_wkt
    "POLYGON((" + nodes.map { |p| "#{p.x} #{p.y}" }.join(', ') + "))"
  end

  def bbox
    x_max = nodes.max_by(&:x).x
    y_max = nodes.max_by(&:y).y
    x_min = nodes.min_by(&:x).x
    y_min = nodes.min_by(&:y).y
    "#{x_min} #{y_min}, #{x_max} #{y_max}"
  end

  def centre_point
    x_max = nodes.max_by(&:x).x
    y_max = nodes.max_by(&:y).y
    x_min = nodes.min_by(&:x).x
    y_min = nodes.min_by(&:y).y
    x_coord = (x_max + x_min) / 2.0
    y_coord = (y_max + y_min) / 2.0
    "#{x_coord} #{y_coord}"
  end

  def area
    multiplied = lines.map { |p1, p2| (p1.x * p2.y) - (p2.x * p1.y) }
    total = multiplied.sum.abs
    total / 2.0
  end

  def self_intersects?
    line_pairs = lines.combination(2)
    line_pairs.map { |l1, l2| intersect?(l1, l2) }.any? 
  end

  def intersects?(poly)
    #binding.pry
    return false unless bbox_intersect?(self.bbox, poly.bbox)
    return true unless !poly.nodes.map { |n| point_in_poly?(n) }.any?
    nodes.map { |n| poly.point_in_poly?(n) }.any?
  end

  def intersection(line_1, line_2)
    return false unless intersect?(line_1,line_2)
    x1, y1 = line_1[0].x, line_1[0].y
    x2, y2 = line_1[1].x, line_1[1].y
    x3, y3 = line_2[0].x, line_2[0].y
    x4, y4 = line_2[1].x, line_2[1].y
    u_bottom =  ((x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4))
    u_top = ((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3))
    u = -(u_top.to_f / u_bottom.to_f)
    px = x3 + u * (x4 - x3)
    py = y3 + u * (y4 - y3)
    "#{px} #{py}"
  end

  def dissolve(poly)
    "0 0, 10 0, 10 5, 20 5, 20 20, 5 20, 5 10, 0 5, 0 0"
  end

  protected 

  def point_in_poly?(test_point)
    #binding.pry
    test_line = [test_point, Point.new("700000 #{test_point.y}")]
    intersections = lines.map { |l| intersect?(l, test_line) }
    intersection_cnt = intersections.count(true)
    intersection_cnt % 2 == 1
  end

  private

  def intersect?(line_1, line_2)
    #binding.pry
    x1, y1 = line_1[0].x, line_1[0].y
    x2, y2 = line_1[1].x, line_1[1].y
    x3, y3 = line_2[0].x, line_2[0].y
    x4, y4 = line_2[1].x, line_2[1].y
    u_bottom =  ((x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4))
    return false unless u_bottom != 0
    u_top = ((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3))
    u = -(u_top.to_f / u_bottom.to_f)
    return false unless (u > 0 && u < 1)
    t =  ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) /
         ((x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)).to_f
    return false unless (t > 0 && t < 1)
    true
  end

  def bbox_intersect?(bbox1, bbox2)
    bb1_min, bb1_max = bbox1.split(', ').map { |p| Point.new(p) }
    bb2_min, bb2_max = bbox2.split(', ').map { |p| Point.new(p) }
    (bb1_max.x >= bb2_min.x && bb2_max.x >= bb2_max.x) && 
      (bb1_max.y >= bb2_min.y && bb2_max.y >= bb2_max.y)
  end
end

class Point
  attr_reader :x
  attr_reader :y

  def initialize(xy)
    @x = xy.split(' ').first.to_i
    @y = xy.split(' ').last.to_i
  end

  def to_wkt()
    "POINT(#{x} #{y})"
  end

  def distance(p2)
    (((x - p2.x) ** 2 + (y - p2.y) ** 2) ** 0.5).abs
  end

  def point_buff(r,steps)
    wkt = []
    angle = 0
    while angle <= 360 do
      new_x = x + r * Math.cos(angle * Math::PI / 180)
      new_y = y + r * Math.sin(angle * Math::PI / 180)
      wkt << "#{new_x.to_s} #{new_y.to_s}"
      angle += (360 / steps)
    end
    wkt.join(', ')
  end
end


Polygon.new("0 0, 10 0, 10 10, 0 10, 0 0").intersects?(Polygon.new("5 5, 20 0, 20 30, 0 20, 5 5"))