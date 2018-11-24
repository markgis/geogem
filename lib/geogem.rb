include Math
# require 'pry-byebug'

class Polygon
  attr_reader :nodes
  attr_reader :lines

  def initialize(wkt)
    @nodes = wkt.downcase.delete('polygon()')
                .split(', ')
                .chunk { |p| p }.map(&:first)
                .map { |xy| Point.new(xy) }

    @lines = nodes.slice(0, nodes.length-1).zip(nodes.slice(1,nodes.length))
  end

  def to_wkt
    "POLYGON((" + nodes.map { |p| "#{p.x} #{p.y}" }.join(', ') + "))"
  end

  def bbox
    x_min, x_max = nodes.minmax_by(&:x).map(&:x)
    y_min, y_max = nodes.minmax_by(&:y).map(&:y)
    "#{x_min} #{y_min}, #{x_max} #{y_max}"
  end

  def centre_point
    x_min, x_max = nodes.minmax_by(&:x).map(&:x)
    y_min, y_max = nodes.minmax_by(&:y).map(&:y)
    x_coord = (x_max + x_min) / 2.0
    y_coord = (y_max + y_min) / 2.0
    "#{x_coord} #{y_coord}"
  end

  def area
    multiplied = lines.map { |p1, p2| (p1.x * p2.y) - (p2.x * p1.y) }
    total = multiplied.reduce(0,:+).abs
    total / 2.0
  end

  def self_intersects?
    line_pairs = lines.combination(2)
    line_pairs.any? { |l1, l2| intersect?(l1,l2) }
  end

  def intersects?(poly)
    #binding.pry
    return false unless bbox_intersect?(self.bbox, poly.bbox)
    return true unless !poly.nodes.any? { |n| point_in_poly?(n) }
    nodes.any? { |n| poly.point_in_poly?(n) }
  end

  def intersection(line_1, line_2, cleaning = false)
    return false unless intersect?(line_1,line_2)
    x1, y1 = line_1[0].x, line_1[0].y
    x2, y2 = line_1[1].x, line_1[1].y
    x3, y3 = line_2[0].x, line_2[0].y
    x4, y4 = line_2[1].x, line_2[1].y
    u_bottom =  ((x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4))
    u_top = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4))
    u = (u_top.to_f / u_bottom.to_f)
    u *= 0.999 if cleaning
    px = x1 + u * (x2 - x1)
    py = y1 + u * (y2 - y1)
    "#{px} #{py}"
  end

  def dissolve(poly)
    #binding.pry
    return false unless intersects?(poly)
=begin
    p1_x_min = nodes.min_by(&:x).x
    p1_y_min = nodes.min_by(&:y).y
    p2_x_min = poly.nodes.min_by(&:x).x
    p2_y_min = poly.nodes.min_by(&:y).y
    x_min = [p1_x_min, p2_x_min].min
    y_min = [p1_y_min, p2_y_min].min
    p1_dis, p1_min_index = nodes.map { |p| p.distance(Point.new("#{x_min} #{y_min}")) }.each_with_index.min
    p2_dis, p2_min_index= poly.nodes.map { |p| p.distance(Point.new("#{x_min} #{y_min}")) }.each_with_index.min
    p1_lines = lines.slice(p1_min_index, lines.length) + lines.slice(0, p1_min_index)
    p2_lines = poly.lines.slice(p2_min_index, poly.lines.length) + poly.lines.slice(0, p2_min_index)
    if p1_dis <= p2_dis
      n_lines = clockwise? ? p1_lines : p1_lines.map(&:reverse).reverse
      n_lines2 = poly.clockwise? ? p2_lines : p2_lines.map(&:reverse).reverse
    else
      n_lines2 = clockwise? ? p1_lines : p1_lines.map(&:reverse).reverse
      n_lines = poly.clockwise? ? p2_lines : p2_lines.map(&:reverse).reverse
    end
=end
    p1_out_index = nodes.index { |n| !poly.point_in_poly?(n) }
    p2_in_index = poly.nodes.index { |n| point_in_poly?(n) }
    p1_lines = lines.slice(p1_out_index, lines.length) + lines.slice(0, p1_out_index)
    p2_lines = poly.lines.slice(p2_in_index, poly.lines.length) + poly.lines.slice(0, p2_in_index)
    n_lines = clockwise? ? p1_lines : p1_lines.map(&:reverse).reverse
    n_lines2 = poly.clockwise? ? p2_lines : p2_lines.map(&:reverse).reverse
    new_poly = ["#{n_lines.first.first.x} #{n_lines.first.first.y}"]
    finished_poly = geom_switch(n_lines, n_lines2, new_poly)
    finished_poly.join(', ')
  end

  def clip(poly)
    #binding.pry
    return to_wkt unless intersects?(poly)
    p1_out_index = nodes.index { |n| !poly.point_in_poly?(n) }
    p2_out_index = poly.nodes.index { |n| !point_in_poly?(n) }
    p1_lines = lines.slice(p1_out_index, lines.length) + lines.slice(0, p1_out_index)
    p2_lines = poly.lines.slice(p2_out_index, poly.lines.length) + poly.lines.slice(0, p2_out_index)
    n_lines = clockwise? ? p1_lines : p1_lines.map(&:reverse).reverse
    n_lines2 = poly.clockwise? ? p2_lines.map(&:reverse).reverse: p2_lines
    new_poly = ["#{n_lines.first.first.x} #{n_lines.first.first.y}"]
    finished_poly = geom_switch(n_lines, n_lines2, new_poly)
    finished_poly.join(', ')
  end

  def cleaner
    new_poly = ["#{lines.first.first.x} #{lines.first.first.y}"]
    lines_reverse = lines.map(&:reverse).reverse
    finished_poly = geom_switch(lines, lines_reverse, new_poly, true)
    finished_poly.join(', ')
  end

  protected

  def point_in_poly?(test_point)
    #binding.pry
    test_line = [test_point, Point.new("700000 #{test_point.y}")]
    intersections = lines.map { |l| intersect?(l, test_line) }
    intersection_cnt = intersections.count(true)
    intersection_cnt % 2 == 1
  end

  def clockwise?
    multiplied = lines.map { |p1, p2| (p1.x * p2.y) - (p2.x * p1.y) }
    total = multiplied.sum
    return total < 0
  end

  private

  def geom_switch(lines1, lines2, new_poly, cleaning = false)
    lines1.each_with_index do |l1, in1|
      lines2.each_with_index do |l2, in2|
        if intersect?(l1,l2)
          new_poly << intersection(l1,l2, cleaning)
          rest_lines2 = lines2.slice(in2, lines2.length)
          rest_lines1 = lines1.slice(in1+1, lines1.length)
          return geom_switch(rest_lines2, rest_lines1, new_poly, cleaning)
        end
      end
      new_poly << "#{l1.last.x} #{l1.last.y}"
    end
    new_poly
  end

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


#puts Polygon.new("551000 235000, 551000 233000, 552500 234000, 551500 234000, 553000 233000, 553000 235000, 551000 235000").cleaner
