class DouglasPeucker

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
end
