include <materials.scad>

//
// Open Box
// 
module OpenBox(box,colour) {

	// Wall Thickness
	wallThickness = [2*boxPly,2*boxPly,boxPly];
	translate(box/2)
	difference() {
		color(colour) cube(box, center=true);
		translate([0,0,boxPly+0.1]) cube(box - wallThickness, center=true);
	}
}
