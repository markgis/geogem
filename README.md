# geogem
Basic spatial functions - bit of a learning for myself


Simple start to a spatial library in Ruby. Geos and GDAL are old and not maintained that much, also gdal althoguh powerful isnt particularly nice to use.

Wanted to make some simple spatial functions to calculate the distance between two points, find the area of a polygon etc. Just uses ruby and maths so far but have to add in other libraries.

Only works in British national grid. 

So far no conversion from or to geometries, the fucntions take in coordinates as strings using the WKT format - remove the words and brackets i.e. "x y,x y,x y" 

only four functions so far;
distance - the distance between two points
point_buffer- creates a circle - takes in a point, the radius and the distance between each node - smoothness of circle
centre_point - feed in polygon and returns its centre point
bound_box- feed in site and this will return bounding box of the polygon


To do:
refactor- pretty dirty
Area of polygon
BUffer lines
buffer polygons
intersection of multiple polygons
clipping of polygons
