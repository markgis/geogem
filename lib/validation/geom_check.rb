include Math
require "cmath"


class GeomCheck

  def slope(point1, point2)
    dy = Float(point2[1] - point1[1])
    dx = Float(point2[0] - point1[0])
    return 0.0 if dy == 0
    dy / dx
  end
end
