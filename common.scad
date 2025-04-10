include <materials.scad>

//
// Open Box
// 
module OpenBox(box,openSide,colour) {

	// Wall Thickness
	wallThickness = [2*boxPly,2*boxPly,boxPly];
	translate(box/2)
	difference() {
		color(colour) cube(box, center=true);
		if (openSide=="top") {
			translate([0,0,boxPly+0.1]) cube(box - wallThickness, center=true);
		} else if (openSide=="front") {
			translate([0,boxPly+0.1,0]) cube(box - wallThickness, center=true);
		} else {
			translate([boxPly+0.1,0,0]) cube(box - wallThickness, center=true);
		}
	}
}
