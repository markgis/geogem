include Math
require "cmath"


class GeomCheck

  def radians(point1, point2)
    dy = Float(point2.y - point1.y)
    dx = Float(point2.x - point1.x)
    radians = atan2(dx,dy)
    return radians unless radians < 0
    radians+(2*Math::PI)
  end

  def bearing(point1, point2)
    radians = radians(point1,point2)
    (180/Math::PI)*radians
  end

end
