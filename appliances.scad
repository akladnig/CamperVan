include <constants.scad>
include <materials.scad>
use <functions.scad>
use <polyedge.scad>

//
// Fridge
// 

// Bushman DC85-X Fridge
fridgeMain = [475, 500, 625];
fridgeDoor = [475, 50, 625];

fd = 50;
depth = [2*fd,fd,2*fd];
fridgeInternal = fridgeMain - depth;

handle = [100, 25, 50];

function fridge() = [fridgeMain[x], fridgeMain[y]+fridgeDoor[y], fridgeMain[z]];

module FridgeDoor(rightOpening) {
	if (rightOpening) {
		union() {
			color(monument)
			cube(fridgeDoor);
			translate([50,-handle[width], fridgeMain[height]-handle[height]])

			color(monument3)
			cube(handle);

			translate([0,fd,0]) color("white") cube([fridgeDoor[x],0.1,fridgeDoor[z]]);
		}
	} else {
		union() {
			color(monument)
			cube(fridgeDoor);
			translate([
				fridgeMain[width]-handle[length]-50,
				-handle[width],
				fridgeMain[height]-handle[height]
			])

			color(monument3)
			cube(handle);

			translate([0,fd,0]) color("white") cube([fridgeDoor[x],0.1,fridgeDoor[z]]);
		}
	}
		
}

module Fridge(doorOpen=false, rightOpening=true) {
	a=fridge()[length];
	difference() {
		color(monument)
		translate([0,fd,0]) cube(fridgeMain);
		translate([fd,fd-0.1,fd]) color("white") cube(fridgeInternal);
	}
	if (doorOpen) {
		if (rightOpening) {
			translate([fridgeMain[x]+fd,-fridgeDoor[x]+fd])
			rotate([0,0,90])
			FridgeDoor(rightOpening);
		} else {
			translate([-fd,fd])
			rotate([0,0,-90])
			FridgeDoor(rightOpening);
		}
	} else {
		FridgeDoor(rightOpening);		
	}

}

//
// Sink
// 
 
// Dometic VA8005 / SNG4237
va8005 = [420, 370, 146.5];
va8005Cut = [405, 355, 146.5];

// Dometic VA8006 / SNG4244
va8006 = [420, 440, 146.5];
va8006Cut = [405, 425, 146.5];

sink = va8005;
sinkCutout = va8005Cut;

rSink = 30;
sinkPoly = [[0,0,rSink],[0,sink[y],rSink],[sink[x],sink[y],rSink],[sink[x],0,rSink]];

rCover = 70;
sinkCover = [[0,0,rCover],[0,sink[y],rCover],[sink[x],sink[y],rCover],[sink[x],0,rCover]];

r1=30;
r2=70;
w=sinkCutout[x];
d=sinkCutout[y];
c=75; //champfer

cutout = [[0,0,r2], [0,d-c,r1], [c,d,r1], [w-c,d,r1], [w,d-c,r1], [w,0,r2]];

function sink() = sink;

module Sink() {
	difference() {
		color("Silver") linear_extrude(sink[height]) polyedge(sinkPoly);
		color("Silver")
		translate([centre(sink[length], w),centre(sink[width], d),5]) linear_extrude(sink[height])
		polyedge(cutout);
	}
}

module SinkCutout() {
	difference() {
		translate([centre(sink[length], w),centre(sink[width], d),-5]) linear_extrude(benchThickness+10)
		polyedge(cutout);
	}
}

module SinkCover() {
difference() {
		color(monument) linear_extrude(10) offset(delta=-10) polyedge(sinkCover);
		translate([sink[length]/2,50,-5])  cylinder(h=20, r=20);
	}
}

//
// Hob
// 
safierySingle = [276, 366, 75];
safieryDual = [290, 520, 55];
safierySingleCutout = [252, 342, benchThickness+10];
safieryDualCutout = [270, 497, benchThickness+10];

hob = safierySingle;
hobCutout = safierySingleCutout;

function hob() = hob;

module Hob(hobs) {
	color(monument)
	cube(hob);
	if (hobs == 1) {
		translate([hob[x]/2,hob[width]-30-90,hob[height]]) circle3d(90, 2, vividWhite, monument);
		translate([hob[x]/2+10,50,hob[height]]) circle3d(5, 1, vividWhite, monument);
		translate([hob[x]/2+40,50,hob[height]]) circle3d(5, 1, vividWhite, monument);
		translate([hob[x]/2+70,50,hob[height]]) circle3d(5, 1, vividWhite, monument);
	} else {
		translate([hob[x]/2,180,hob[height]]) circle3d(80, 2, vividWhite, monument);
		translate([hob[x]/2,hob[width]-30-90,hob[height]]) circle3d(90, 2, vividWhite, monument);
		translate([hob[x]/2+10,50,hob[height]]) circle3d(5, 1, vividWhite, monument);
		translate([hob[x]/2+40,50,hob[height]]) circle3d(5, 1, vividWhite, monument);
		translate([hob[x]/2+70,50,hob[height]]) circle3d(5, 1, vividWhite, monument);
	}
}

module HobCutout() {
	translate([0,0,-5]) cube(hobCutout);
}

