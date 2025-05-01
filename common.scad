include <materials.scad>

//
// Open Box
// 
module OpenBox(box,openSide,colour) {

	// Wall Thickness
	wallThicknessTB = [2*boxPly,2*boxPly,boxPly];
	wallThicknessFB = [2*boxPly,boxPly,2*boxPly];
	translate(box/2)
	difference() {
		color(colour) cube(box, center=true);
		if (openSide=="top") {
			translate([0,0,boxPly+0.1]) cube(box - wallThicknessTB, center=true);
		} else if (openSide=="front") {
			translate([0,boxPly+0.1,0]) cube(box - wallThicknessFB, center=true);
		} else if (openSide=="bottom") {
			translate([0,0,-boxPly-0.1]) cube(box - wallThicknessTB, center=true);
		} else if (openSide=="back") {
			translate([0,-boxPly-0.1,0]) cube(box - wallThicknessFB, center=true);
		} else {
			translate([boxPly+0.1,0,0]) cube(box - wallThicknessFB, center=true);
		}
	}
}
