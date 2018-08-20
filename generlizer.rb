include Math
require "cmath"

class Generlizer

  def distance(x,y,x0,y0)
    return CMath.sqrt((x-x0)**2 + (y-y0)**2)
end
  def radial_thin(nodes, tolerance)
     node_split = nodes.split(",")[1..-2]
     puts node_split
     puts node_split.each_cons(2).map {|a,b| a[0] == b[0]}
  end
end
