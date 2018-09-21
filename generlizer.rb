include Math
require "cmath"

class Generlizer

  def distance(x, y, x0, y0)
    CMath.sqrt((x - x0)**2 + (y - y0)**2)
  end

  def first_node(nodes)
    xy = nodes.strip.split(',').first.strip.split(' ')
    { point: {x: xy.first, y: xy.last}}
  end

  def last_node(nodes)
    xy = nodes.split(',').last.strip.split(' ')
    { point: {x: xy.first, y: xy.last}}
  end

  def node_split(nodes)
    node_split = nodes.split(',')[1..-2]
    node_split.map do |node|
      split_node = node.strip!.split
      { x: split_node[0].to_f, y: split_node[1].to_f }
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
      points_distance.push({point: point, dist_to_next: dist})
    end
    points_distance
  end

  def radial_thin(nodes, tolerance)
    distance = node_distance(nodes)
    distance.each_with_index do |x, index|
      if x.values[1] < tolerance && x.values[1] != -1
        distance.delete_at(index)
      end
    end
    distance << last_node(nodes)
    distance.unshift(first_node(nodes))
    distance.map do |x|
      "#{x[:point][:x]} #{x[:point][:y]}"
    end.join(',')
  end
end
