include <constants.scad>
include <van_dimensions.scad>

windowFrame = [[320,0,150], [0,450,70], [ 1020,450,70], [1020,0,70]];

module WindowFrame() {
	color("blue")
	translate([150, vi[y], 700])
	rotate([90,0,0])
	difference() {
		linear_extrude(5)
		polyedge(windowFrame);
		translate([250,140,-1])
		cube([700,300,7]);
	}
}
