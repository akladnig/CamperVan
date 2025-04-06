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
	OpenBox(batteryBox(qty), "red");
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

function inverter() = inverter;
function inverterGap() = 100;

module Inverter() {
	cube(inverter);
}

//
// DC - DC convertor
//

module DcDc() {
	
}

//
// Power Point
// 

click = [100, 30, 105];
powerPoint = click;

module PowerPoint() {
	color("white") cube(powerPoint);
}
