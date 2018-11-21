class PerpendDistance

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

  def last_node_plain(nodes)
    nodes.split(',').last.strip.split(' ')
  end

  def first_node_plain(nodes)
    nodes.strip.split(',').first.strip.split(' ')
  end

  def node_split(nodes)
    node_split = nodes.split(',')[1..-2]
    node_split.map do |node|
      split_node = node.strip!.split
      { x: split_node[0].to_f, y: split_node[1].to_f }
    end
  end

  def point_x(point)
    point.split.first.to_f
  end

  def point_y(point)
    point.split.last.to_f
  end

  def n_node(site, n)
    site.split(',')[n].split(' ')
  end

  def line_distance(site)
    line_distance = []
    nodes = site.split(',')
    nodes.each_with_index do |node, index|
      if (index + 2) < nodes.length
        line = n_node(site, index).join(' ') + ',' + n_node(site, index + 2).join(' ')
        dist = line_point_distance(line, nodes[index + 1])
      else
        dist = -1
      end
      line_distance.push({node: node, dist_to_line: dist})
    end
    line_distance
  end

  def perpend_thin(site, tolerance)
    distance = line_distance(site)
    distance.each_with_index do |x, index|
      if x.values[1] <= tolerance && x.values[1] != -1
        distance.delete_at(index)
      end
    end
    distance.map do |x|
      "#{x[:node].split()[0]} #{x[:node].split()[1]}"
    end.join(',')
  end

  def line_point_distance(line, point)
  last_node_x = last_node_plain(line).first.to_f
  last_node_y = last_node_plain(line).last.to_f
  first_node_x = first_node_plain(line).first.to_f
  first_node_y = first_node_plain(line).last.to_f
  point_x = point_x(point)
  point_y = point_y(point)
  numer = (last_node_x - first_node_x) * (first_node_y - point_y) - (first_node_x - point_x) * (last_node_y - first_node_y)
  denom = (last_node_x - first_node_x)**2 + (last_node_y - first_node_y)**2
  numer.abs / denom**0.5
  end
end
