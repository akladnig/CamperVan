include <constants.scad>
use <polyedge.scad>

cladding = 3+6;

// Van Sizing
vanExternal = [5265, 1950, 1990];
vanInternal = [2700, 1760, 1340];
rearDoorWidth = 1500;
rearDoorChampfer = [55,480];

step = [1010, 215,200];
stepOffset = 130;
frontSeatOffset = 130;

doorOpening = 520;

vi = vanInternal;
r = 20;
rd = rearDoorWidth;
cx = 80; // champferS
cy = (vi[y] - rd)/2;
cl = round(sqrt(cx*cx+cy*cy));
ca = atan(cx/cy);

vanInternalPoly = [
	[0,0,r],
	[0,vi[y],r],
	[vi[x]-cx, vi[y],r],
	[vi[x], vi[y]-cy,r],
	[vi[x], cy,r],
	[vi[x]-cx, 0,r],
	];

wheelBase = 3210;
frontToWheel = 950;
rearToWheel = 1105;

// Clearance between rear door and sofa bed
rearDoorClearance = 50;
wheelArch = [840, 240, 240];
wheelArchOffset = 500;
wheelArchFront = vi[x]-wheelArchOffset-wheelArch[x];
wheelArchRear = vi[x]-wheelArchOffset;

r1 = 280;
r2 = 160;
wheelArchPoly = [[0,0,0], [0,240,r1], [840,240,r2], [840,0,0]];

module WheelArch() {
	 translate([wheelArch[x],0,0]) rotate([90,0,180]) linear_extrude(wheelArch[y]) polyedge(wheelArchPoly);
}

module VanBase() {
difference() {
	union() {
		linear_extrude(step[height]) polyedge(vanInternalPoly);
		translate([vi[x] - wheelArch[x]-wheelArchOffset,0,step[z]]) WheelArch();
		translate([vi[x] - wheelArch[x]-wheelArchOffset,vi[y]-wheelArch[y],step[z]]) WheelArch();
	}
	translate([stepOffset,-0.1,0.1]) color("green") cube(step);
	}
}

module DoorFill() {
	cube([step[x]-doorOpening, step[y],floorPly]);
}

popTopClearance = 360;
