include Math
require "cmath"


class GeomCheck

  def radians(point1, point2)
    dy = Float(point2[1] - point1[1])
    dx = Float(point2[0] - point1[0])
    atan(dy/dx)
  end

  def bearing(point1, point2)
    radians = radians(point1,point2)
    (180/Math::PI)*radians
  end

end
