include <constants.scad>
include <materials.scad>
include <van_dimensions.scad>
include <common_dimensions.scad>

use <common.scad>
use <electrical.scad>

//
// Toilet
// 
thetford335 = [342,382,313];
thetford345 = [383,427,330];
thetford365 = [383,427,414];
toilet = thetford345;

function toilet() = toilet;

module Toilet() {
	r = 50;
	bottom = 50;
	middle = 50;
	top = toilet[z] - bottom - middle;
	color(vividWhite)
	translate([r,r,0]) linear_extrude(bottom) offset(r=r) square(toilet[x]-2*r,toilet[y]-2*r);
	color("grey")
	translate([r,r,bottom]) linear_extrude(middle) offset(r=r) square(toilet[x]-2*r,toilet[y]-2*r);
	color(vividWhite)
	translate([r,r,bottom+middle]) linear_extrude(top) offset(r=r) square(toilet[x]-2*r,toilet[y]-2*r);
	translate([50,0,150]) rotate([90,0,0]) color("black") text("Toilet Front", size=40);
}

//
// HotWater
// 

// Volume = 29l
duoettoMk2Dims = [410,250,270];
d2d = duoettoMk2Dims;
rf = 100;
rr = 50;
duoettoMk2Poly = [[0,0, rf], [0,d2d[z],rf], [d2d[y],d2d[z],rr],[d2d[y],0,rr]];

IO = [20,20];

hotWater = duoettoMk2Dims;
hotWaterPoly = duoettoMk2Poly;


function hotWater() = hotWater;

module HotWater() {
	color("white") translate([d2d[x],0,d2d[z]])
	rotate([-90,0,0])
	rotate([0,-90,0])
	linear_extrude(hotWater[x]) polyedge(hotWaterPoly);
	color("red") translate([d2d[x],d2d[y]/2,d2d[z]-50]) rotate([0,90,0])
	cylinder(h=IO[h], d=IO[diameter]);
	color("blue") translate([d2d[x],d2d[y]/2,50]) rotate([0,90,0])
	cylinder(h=IO[h], d=IO[diameter]);
	color("blue") translate([50,0,100]) rotate([90,0,0]) text("Duoetto Mk2", size=40);
}

//
// Water Tank
// 
CAN_SB39 = [550, 390, 200];
CAN_SB57 = [550, 390, 290];
CAN_SB77 = [750, 390, 290];
Vetus42 = [610, 350, 400];
Vetus61 = [780, 350, 400];

// Custom L shape
//     ┣━   a + wheelArch[x]   ━┫
//  ┳━ ┏━━━━━━━━━━━━━━━━━━━━━━━━┓
//     ┃                        ┃
//  b  ┃                        ┃
//     ┃                        ┃
//  ┻━ ┗━━━━━━━━━━━━━━━━┓       ┃
//                      ⎥       ┃
//                      ┗━━━━━━━┛
//                      ┣━  a  ━┫
// 

a = tankL;
b = cupboard[y]-wheelArch[y]-gap;

tankGap = [10,10,10];
tank = [a+wheelArch[x], cupboard[y]-gap-framingPly,wheelArch[z]];
// tank = [a+wheelArch[x], cupboard[y]-gap-framingPly,seatHeight-inverter()[z]-clearance-2*framingPly-25];

custom = [
	[0,0],
	[0,tank[width]],
	[a,tank[width]],
	[a,b],
	[tank[length],b],
	[tank[length],0],
];

w = wheelArch[z]-gap;
module wheelArchInfill() {
	translate([a+wheelArch[x],b,-w])
	rotate([90,0,0])
	rotate([0,180,0])
	linear_extrude(wheelArch[y]-gap)
	difference() {
		polygon([[0,0],[0,w],[w,w]]);
		translate([r1-gap,w-r1]) circle(r=r1+gap);
	}
}


volume = (tank[length]*tank[width]-wheelArch[x]*(wheelArch[y]+gap))*tank[z]/1000/1000;
tankStr = str("Water Tank ", floor(volume), " litres"); 

function tank() = tank;
function tankGap() = tankGap;

//
// Tank Shelf Height
// 
function tankShelfHeight() = tank()[z] + tankGap()[z];

module WaterTank() {
	echo(tank=tank);
	union(){
		color("green") {
			linear_extrude(tank[z]) polygon(custom);
			translate([0,0,tank[z]]) wheelArchInfill();
		}
	}
	translate([50,0,100]) rotate([90,0,0]) color("black") text(tankStr, size=40);
}

//
// Water Pump
//
seaflo43 = [114.5,111,202.5];

pump = seaflo43;

function pump() = pump;
function pumpInlet() = [9.5,27-14-95,138+28];

module Pump() {
	module MountingPlate(position) {
		offsetY = position == "top" ?  -23/2 : 23/2-8;
		offsetZ = position == "top" ? 23/2+18 : 74+23/2+18;

		color("black")
		translate([-83/2,14+95/2,offsetZ])
		rotate(x90) {
			cylinder(d=23, h=14);
			translate([83,0,0]) cylinder(d=23, h=14);
			translate([0,offsetY,0]) cube([83,8,14]);
		}
	}
	translate([95/2,-95/2-14,0]) {
		color("black") translate([0,0,179+33/2]) cube([48,48,33],center=true);
		color("orange") translate([0,0,138+41/2]) cube([95,95,41],center=true);
		// Inlet and outlet
		color("black")  translate([-57,27-95/2,138+28]) rotate(y90) cylinder(d=20, h=114);
		color("black") translate([0,0,124+14/2]) cube([95,95,14],center=true);
		color("black") translate([0,0,107+17/2]) cylinder(r1=76/2, r2=95/2, h=17,center=true);
		color("white") translate([0,0,18]) cylinder(d=76, h=89);
		color("black") cylinder(d=29,h=18);
		// Mounting plate
		MountingPlate("bottom");
		MountingPlate("top");
	}
}

//
// Water Filter
//

//  https://www.filtersystemsaustralia.com.au/heavy-duty-single-outdoor-caravan-water-filter-system-watermark-certified-gt1-0.html

FSAFilter = [380,150];
FSAFilterTwin = [235,130,235];
FSAFilterTwinD = [190,105];
AquaBlue = [390, 81];

filter = AquaBlue;

//
// type is "single" or "twin"
// 
function filter(type) = type == "single" ? AquaBlue : FSAFilterTwin;

module Filter(type) {
	if (type == "single") {
		color("blue")
		translate([filter[diameter]/2,-filter[diameter]/2,0])
		cylinder(h=filter[h], d=filter[diameter]);
	} else {
		color("white")
		// translate([0,FSAFilterTwinD[diameter],0]) {
		translate([0,0,0]) {
			translate([0,-5,FSAFilterTwinD[h]]) {
				cube([FSAFilterTwin[x],5, FSAFilterTwin[z]-FSAFilterTwinD[h]]);
			}
			translate([FSAFilterTwinD[diameter]/2,-FSAFilterTwinD[diameter]/2,0]) {
			cylinder(h=FSAFilterTwinD[h], d=FSAFilterTwinD[diameter]);
			translate([FSAFilterTwin[x]-FSAFilterTwinD[diameter],0,0])
			cylinder(h=FSAFilterTwinD[h], d=FSAFilterTwinD[diameter]);
			}
		}
	}
}

//
// Jerry Can
// 
jerryCan = [348,179,460];
waterCube = [280,280,370];
dunnWatson20 = [500,240,221];

hotWaterContainer = dunnWatson20;

function hotWaterContainer(model) = model == "square" ? waterCube :
	model == "dw" ? dunnWatson20 : jerryCan;

module HotWaterContainer(model) {
	color("lightBlue")
	if (model=="square") {
		cube(waterCube);
	} else if (model == "dw") {
		cube(dunnWatson20);
	} else {
		cube(jerryCan);
	}
}

//
// Shower
// 

shower = [189,180,117];
rad = shower[z]/2;
function shower() = shower;

module Shower() {
	color("white")
	translate([rad,shower[y],shower[z]])
	rotate(x90)	
	linear_extrude(shower[y])
	union() {
		circle(d=shower[z]);
		translate([0,-rad,0]) square([shower[x]-shower[z],shower[z]]);
		translate([shower[x]-shower[z],0,0]) 
		circle(d=shower[z]);
	}
}

module my_sphere(r) {
	rotate_extrude()
	difference() {
		circle(r);
		translate([0,-r,0]) square(2*r);
	}
}

OD = 23;
ID = 12;

module DmFitElbow() {
	color("white") rotate(z90){
		sphere(r=OD/2);
		cylinder(d=OD, h=32);
		rotate(x90) cylinder(d=OD, h=32);
	}
}

module DmFitTee() {
	len = 61;
	color("white") {
		rotate(y90) cylinder(d=OD, h=len);
		translate([len/2,0,0]) cylinder(d=OD, h=32);
	}
}

module DmFitValve() {
	len = 67;
	
		color("white") rotate(y90) cylinder(d=OD, h=len);
		color("white") translate([len/2,0,-OD/2]) cylinder(d=OD, h=25);
		color("blue") translate([len/2,0,25-OD/2]) cylinder(d=27, h=10);
		color("blue") translate([len/2-27/2,-2,35-OD/2]) cube([42,4,9]);
}

function strainer() = [52,22,62];
module Strainer() {
	translate([0,0,-62+12.5]) {
		color("blue")  cylinder(d=37, h=20.5);
		color("blue") translate([0,0,20.5]) cylinder(d=44, h=14.5);
		color("white") translate([0,0,35]) cylinder(d=37, h=27);
		color("white") translate([-26,0,62-12.5]) rotate(y90) cylinder(d=25, h=52);
	}
}
