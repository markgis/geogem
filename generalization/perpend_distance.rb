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

  def third_node(site)
    site.split(',', 4)[2].strip!.split(' ')
  end

  def perpend_thin(site,tolerance)
    first_node_plain(site).join(',') + last_node_plain(site).join(',')
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
