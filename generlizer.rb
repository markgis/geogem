include Math
require "cmath"

class Generlizer

  def distance(x, y, x0, y0)
    CMath.sqrt((x - x0)**2 + (y - y0)**2)
  end

  def first_node(nodes)
    nodes.strip.split(',').first.strip
  end

  def last_node(nodes)
    nodes.split(',').last.strip
  end

  def node_split(nodes)
    node_split = nodes.split(',')[1..-2]
    node_split.map do |node|
      split_node = node.strip!.split
      { x: split_node[0].to_i, y: split_node[1].to_i }
    end
  end

  def node_distance(nodes)
    points_distance = []
    points = node_split(nodes)
    points.each_with_index do |point, index|
      if (index + 1) < points.length
      dist = distance(point[:x], point[:y], points[index + 1][:x], points[index + 1][:y])
      else
        dist = -1
      end
      points_distance.push(dist)
    end
    points_distance
  end

  def radial_thin(nodes, tolerance)
    distance = node_distance(nodes)
  end

end
