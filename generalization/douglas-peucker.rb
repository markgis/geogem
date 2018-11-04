include Math

class PolygonThin
  attr_reader :nodes
  def initialize(wkt)
    @nodes = wkt.split(', ').map { |xy| Point.new(xy) }
  end

  def dp(tol = 0.5)
    control_point = nodes.first
    distances = nodes.map { |xy| point_point_distance(control_point, xy) }
    furthest = distances.each_with_index.max[1]
    new_poly = [nodes.first]
    new_poly = dp_calc(new_poly, nodes.slice(0, furthest+1), tol)
    new_poly = dp_calc(new_poly, nodes.slice(furthest, nodes.length), tol)
    return to_wkt(new_poly)
  end

  def to_wkt(list_of_points)
    list_of_points.map { |p| "#{p.x} #{p.y}" }.join(', ')
  end

  private
  
  # Calculates the distance between 2 points
  def point_point_distance(a, b)
    (((a.x - b.x) ** 2 + (a.y - b.y) ** 2) ** 0.5).abs
  end

  # Calculates the distance between a line and  point
  def line_point_distance(line_start, line_end, point)
    top = ((line_end.y - line_start.y) * point.x) -
          ((line_end.x - line_start.x) * point.y) +
          (line_end.x * line_start.y) - 
          (line_end.y * line_start.x)
    bottom = ((line_end.y - line_start.y) ** 2 +
              (line_end.x - line_start.x) ** 2) ** 0.5
    return (top / bottom).abs
  end

  # Recursive checks smaller sections of polygon!
  def dp_calc(new_poly, points, tol)
    return new_poly << points.last unless points.length > 2
    distances = points.map do |xy|
      line_point_distance(points.first, points.last, xy)
    end
    return new_poly << points.last unless distances.any?{ |d| d > tol }
    furthest = distances.each_with_index.max[1]
    new_poly = dp_calc(new_poly, points.slice(0, furthest+1), tol)
    new_poly = dp_calc(new_poly, points.slice(furthest, points.length), tol)
    return new_poly
  end

  # Small class for individual points as to provide clarity in calculations
  # As to what is being uses
  class Point
  	attr_reader :x
  	attr_reader :y

  	def initialize(node)
  	  @x = node.split(' ').first.to_i
  	  @y = node.split(' ').last.to_i
  	end
  end

end

#puts Polygon.new("0 0, 10 0, 20 0, 20 20, 0 20, 0 0").dp(0.5)