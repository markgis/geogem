include Math

class Polygon
  attr_reader :nodes

  def initialize(wkt)
    @nodes = wkt.split(', ').map { |xy| Point.new(xy) }
  end

  def bbox()
    x_max = nodes.max_by(&:x).x
    y_max = nodes.max_by(&:y).y
    x_min = nodes.min_by(&:x).x
    y_min = nodes.min_by(&:y).y
    "#{x_min} #{y_min}, #{x_max} #{y_max}"

  def distance(x,y,x0,y0)
    return CMath.sqrt((x-x0)**2 + (y-y0)**2)
  end

  # puts distance(520500,170500,520700,170510)

  def point_buff(sitex,sitey,r,steps)
    wkt = ""
    angle = 0
    while angle <= 360 do
      x= sitex + r* Math.cos(angle * Math::PI / 180)
      y= sitey + r* Math.sin(angle * Math::PI / 180)
      wkt << x.to_s + " " + y.to_s + ","
      angle += steps
    end
    return wkt
  end

  # puts point_buff(520500,170500,200,10)

  def centre_point(shape)
    xcoords = []
    ycoords = []
    shape.split(",").each do |shape|
      xcoords << shape.split(" ")[0].to_i
      ycoords << shape.split(" ")[1].to_i
      end
    xcen= xcoords.min + (xcoords.max - xcoords.min)/2
    ycen = ycoords.min + (ycoords.max - ycoords.min)/2
      return xcen,ycen
  end

  def bound_box(shape)
    xcoords = []
    ycoords = []
    shape.split(",").each do |shape|
      xcoords << shape.split(" ")[0]
      ycoords << shape.split(" ")[1]
    end
    return xcoords.min + " " + ycoords.min + "," + xcoords.max + " " + ycoords.min + "," + xcoords.max + " " + ycoords.max + "," + xcoords.min + " " + ycoords.max + "," + xcoords.min + " " + ycoords.min
  end

  def area(shape)
    xcoords = []
    ycoords = []
    shape.split(",").each do |shape|
      xcoords << shape.split(" ")[0].to_f
      ycoords << shape.split(" ")[1].to_f
    end
   ycoords.each_with_index do |item,index|
    # puts ycoords[index + 1]
  end
  end



end

# puts Geo.new.distance(520500,170500,520700,170510)

# puts Geo.new.centre_point("520575 170388, 520617 170405, 520624 170389, 520582 170371, 520575 170388")
shape = "520575 170388, 520617 170405, 520624 170389, 520582 170371, 520575 170388"
Geo.new.area(shape)

# puts bound_box(shape)
