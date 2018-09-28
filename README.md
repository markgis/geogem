# geogem
## Basic spatial functions - bit of a learning for myself


Simple start to a spatial library in Ruby to practice my coding and learn some maths.

Wanted to make some simple spatial functions to calculate the distance between two points, find the area of a polygon etc. Just uses ruby and maths so far but might have to add in other libraries - proj4 most likely if I want to add in the ability to use multiple projection systems.  

Only works in British national grid. 

So far no conversion from or to geometries, the fucntions take in coordinates as strings using the WKT format - remove the words and brackets i.e. "x y,x y,x y" 

There are a number of functions and slowly movig them into different sections. Most have specs but arent really working as proper objects yet.

1. distance - the distance between two points - using Euclidean distance.
2. point_buffer- creates a circle - takes in a point, the radius and the distance between each node - smoothness of circle - must be >0 smaller number means a smoother cicrle but more nodes returned
3. centre_point - feed in polygon and returns its centre point
4. bound_box- feed in site and this will return bounding box of the polygon
5. Generalization - both radial thinning and perpendicular distance- might work on other algorithms as well



To do:
1. refactor- pretty dirty
2. Area of polygon
3. BUffer lines
4. buffer polygons
5. intersection of multiple polygons
6. clipping of polygons
7. Fix generalization algorithms both work but some strange behaviour
8. Validation - self intertsections, syntax errors of WKT, UK bounds check, etc
