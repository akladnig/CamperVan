include <common.scad>
include <constants.scad>


airFryer = [280,295,370];
radius = 100;

function airFryer() = airFryer;

module AirFryer() {
	module handle() {
		translate([airFryer[x]/2-15,-65,50])
		difference() {
			cube([30,65,150]);
			translate([-0.5,30,30])
			cube([31,35,90]);
		}
	}
	color(monument) {
		translate([radius,radius])
		linear_extrude(airFryer[z])
		offset(r=radius)
		square([airFryer[x]-2*radius, airFryer[y]-2*radius]);
		handle();
	}
}
