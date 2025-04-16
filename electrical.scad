include <constants.scad>
include <materials.scad>

use <common.scad>

//
// Bus Bar
//
busBar = [150,28,36];
function busBar() = busBar;

module BusBar(polarity) {
	colour = polarity == "+ve" ? "red" : "black";	
	color(colour) cube(busBar);
}

//
// Battery
// 
renogy100 = [268,193,205];
renogy200 = [467,212,208];

gap = [200,5,50];
boxPly = 6;

battery = renogy200;

function battery() = [battery];

module Battery() {
	color(monument) cube(battery);
}

//
// Battery Box
// 
function batteryBox(qty) = [
		battery[x]+2*boxPly+gap[x]+gap[y],
		qty*battery[y]+2*(gap[y]+boxPly),
		battery[z]+gap[z]+boxPly
];

module BatteryBox(qty) {
	OpenBox(batteryBox(qty), "top", "red");
	translate([boxPly,boxPly,boxPly]) {
		translate([gap[y],gap[y]]) Battery();
		translate([gap[y],battery[y]+gap[y],0]) Battery();
		translate([batteryBox(qty)[x]-(gap[x]-busBar()[y])/2,gap[z],0]) rotate([0,0,90])
		BusBar("-ve");
		translate([batteryBox(qty)[x]-(gap[x]-busBar()[y])/2,batteryBox(qty)[y]-busBar()[x]-boxPly-50,0]) rotate([0,0,90])
		BusBar("+ve");
	}

	// Text
	translate([50,50,batteryBox(qty)[height]]) color("black") text("Battery Top", size=40);
}

//
// Inverter
// 

renogy2000WInverter = [442,220,92];
renogy3000WInverter = [482,220,92];

inverter = renogy2000WInverter;
inverterGap = [200,200,0];

function inverter() = inverter+inverterGap;
function inverterGap() = inverterGap;

module Inverter() {
	union() {
		cube([inverter[x]+inverterGap[x], inverter[y]+inverterGap[y],1]);
		translate([inverterGap[x]/2, inverterGap[y]/2, 0]) cube(inverter);
	}
}

//
// DC - DC convertor
//

DCC50S = [244, 146, 96];
dcDc60A = [311, 175,68];

IP67_50A = [178,122,36];
IP67_50AGap = [300,300,0];

function dcdc() = IP67_50A + IP67_50AGap;

module DcDc(model) {
	if (model=="IP67") {
		union() {
			cube([IP67_50A[x]+IP67_50AGap[x], IP67_50A[x]+IP67_50AGap[x],1]);
			translate([IP67_50AGap[x]/2, IP67_50AGap[y]/2, 0]) cube(IP67_50A);
		}
	} else if (model=="DCC50S") {
		cube(dcDc60A);
	}
}

//
// Power Point
// 

click = [100, 30, 105];
powerPoint = click;

module PowerPoint() {
	color("white") cube(powerPoint);
}
