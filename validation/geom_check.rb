include Math
require "cmath"


class GeomCheck

  def radians(point1, point2)
    dy = Float(point2.x - point1.x)
    dx = Float(point2.y - point1.y)
    atan(dy/dx)
  end

  def bearing(point1, point2)
    radians = radians(point1,point2)
    (180/Math::PI)*radians
  end

end
