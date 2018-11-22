# geogem
## Spatial functions built in pure Ruby


Simple start to a spatial library in Ruby.

Simple spatial functions to calculate the distance between two points, find the area of a polygon etc. Just uses ruby and maths so far but might have to add in other libraries - proj4 most likely if I want to add in the ability to use multiple projection systems.  

Only works in British national grid, curently.

So far no conversion from or to geometries, the fucntions take in coordinates as strings using the WKT format - you can either add the brackets or without i.e. "x y,x y,x y" 

The gem has been split into 2 seperate class objects Polygon and Point, with Polygon objects comprising of list of points. Both classes have a variety of functions that can be used to perform various gis functions.

Rspecs are in place to ensure the functions work for basic cases. More detailed test will need to be conducted to further devlop the functions and ensure all special cases work correctly i.e. insection of 2 parallel lines might casue it error.

1. distance - the distance between two points - using Euclidean distance.
2. point_buffer- creates a circle - takes in a point, the radius and the distance between each node - smoothness of circle - must be >0 smaller number means less nodes and less detail returned
3. centre_point - feed in polygon and returns its centre point
4. bound_box- feed in site and this will return the min and the max of the polygon
5. Generalization - both radial thinning, perpendicular distance and douglas Puecker
6. to_wkt - returns the class object nodes as a wkt
7. Area - will return the area of the polygon
8. intersects? - returns true if the 2 polygons intersect with each other or 1 polygon sites on top of the other


To do:
- [ ] refactor- pretty dirty
- [ ] BUffer function/class (buffer class that buffers any geom type)
- [ ] Validation - syntax errors of WKT, self intersections, hanging lines etc
- [ ] clipping functions
- [ ] Fix generalization algorithms (radil and perpendicular distance) both work but some strange behaviour - pretty much done?
- [ ] WKTto geom class - wrap/unwrap wkt strings
- [ ] Geom binary (faster processing of large polygons?
- [ ] projections? - conversions etc (too complicated?)
- [ ] geometry tools - line to polygons, polygons to line etc
- [ ] analysis - nearest neighbour, spatial stats etc

