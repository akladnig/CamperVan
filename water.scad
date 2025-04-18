include <constants.scad>
include <materials.scad>
include <van_dimensions.scad>
include <common_dimensions.scad>

use <common.scad>

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
a = tankL;
b = cupboard[y]-wheelArch[y]-gap;

tankGap = [10,10,50];
tank = [a+wheelArch[x], cupboard[y]-gap-framingPly, hotWater[z]-tankGap[z]];

custom = [
	[0,0],
	[0,tank[width]],
	[a,tank[width]],
	[a,b],
	[tank[length],b],
	[tank[length],0],
] ; //97.5 litres

volume = (tank[length]*tank[width]-wheelArch[x]*(wheelArch[y]+gap))*tank[z]/1000/1000;
tankStr = str("Water Tank ", floor(volume), " litres"); 

function tank() = tank;
function tankGap() = [10,10,50];

//
// Tank Shelf Height
// 
function tankShelfHeight() = tank()[z] + tankGap()[z];

module WaterTank() {
	echo(tank=tank);
	color("green") linear_extrude(tank[z]) polygon(custom);	
	translate([50,0,100]) rotate([90,0,0]) color("black") text(tankStr, size=40);
}

//
// Water Pump
//
seaflo43 = [114.5,111,202.5];

pump = seaflo43;

function pump() = pump;

module Pump() {
	color("orange") cube(pump);
}

//
// Water Filter
// 
//  https://www.filtersystemsaustralia.com.au/heavy-duty-single-outdoor-caravan-water-filter-system-watermark-certified-gt1-0.html

FSAFilter = [380,150];
FSAFilterTwin = [235,130,235];
FSAFilterTwinD = [190,105];

filter = FSAFilter;

function filter(type) = type == "single" ? FSAFilter : FSAFilterTwin;

module Filter(type) {
	if (type == "single") {
		color("blue") cylinder(h=filter[h], d=filter[diameter]);
	} else {
		color("white") {
			translate([0,-5,FSAFilterTwinD[h]]) {
				cube([FSAFilterTwin[x],5, FSAFilterTwin[z]-FSAFilterTwinD[h]]);
			}
			translate([FSAFilterTwinD[diameter]/2,-FSAFilterTwinD[diameter]/2,0]) {
			cylinder(h=FSAFilterTwinD[h], d=FSAFilterTwinD[diameter]);
			translate([FSAFilterTwin[x]-FSAFilterTwinD[diameter],0,0])
			cylinder(h=FSAFilterTwinD[h], d=FSAFilterTwinD[diameter]);
			}
		}
		// cube(FSAFilterTwin);
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

// Volume = 22l
joolca = [290,170,450];

shower = joolca;

function shower() = shower;

module Shower() {
	color("white") cube(shower);
	translate([50,0,100]) color(monument)rotate([90,0,0]) text("Shower", size=40);
}
