// include <constants.scad>
// include <materials.scad>
// include <van_dimensions.scad>
include <common_dimensions.scad>

use <common.scad>

//
// Fan Extraction Duct
//
duct = [wheelArch[z]+2*gap+slatDepth+boxPly,100];
function duct() = duct;

module Duct(diameter=duct[diameter], h=duct[h]) {
	color("white")
	translate([h/2,diameter/2,diameter/2])
	rotate(y90)
	difference() {
		cylinder(d=diameter, h=h, center=true);
		cylinder(d=diameter-4, h=h+10, center=true);
	};
}

module DuctCutout(diameter=duct[diameter]) {
	translate([-1,diameter/2,diameter/2])
	rotate(y90)
	cylinder(d=diameter, h=10*boxPly+2);
}

// Position of duct on Battery Box relative to lower left corner
function ductPosition() = [0,clearance,batteryBox[z]-duct[diameter]-clearance];

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

boxGap = [200,25,50];
boxPly = 6;

battery = renogy200;

function battery() = [battery];

module Battery() {
	color(monument) cube(battery);
}

//
// Battery Box
// 
clearance = 25; // clearance around duct

batteryBox = [
		battery[x]+2*boxPly+2*boxGap[x]+boxGap[y],
		2*battery[y]+2*(boxGap[y]+boxPly),
		battery[z]+2*boxGap[z]+boxPly
];

function batteryBox() = batteryBox;

module BatteryBox() {
	difference() {
		OpenBox(batteryBox(), "top", "red");
		translate(ductPosition()) DuctCutout();
	}

	// Add an extraction Fan and Duct
	translate([-duct[h]+boxPly,0])
	translate(ductPosition()) Duct();	

	translate([boxPly,boxPly,boxPly]) {
		translate([boxGap[y],boxGap[y]]) Battery();
		translate([boxGap[y],battery[y]+boxGap[y]+5,0]) Battery();
		translate([batteryBox()[x]-(boxGap[x]-busBar()[y])/2,boxGap[z],0]) rotate([0,0,90])
		BusBar("-ve");
		translate([batteryBox()[x]-(boxGap[x]-busBar()[y])/2,batteryBox()[y]-busBar()[x]-boxPly-50,0]) rotate([0,0,90])
		BusBar("+ve");
	}
	color("blue") translate([
		batteryBox[x]-dcdc("IP67")[x]-100,
		boxPly,
		boxPly+100
	])
	DcDc("IP67");	

	color("green") translate([
		batteryBox[x]-dcdc("DCDC20A")[x]-100,
		batteryBox[y]-dcdc("DCDC20A")[y]-boxPly,
		boxPly+100
	])
	DcDc("DCDC20A");	
}

//
// Inverter
// 

renogy2000WInverter = [442,220,92];
renogy3000WInverter = [482,220,92];

inverter = renogy2000WInverter;
inverterboxGap = [200,200,0];

function inverter() = inverter+inverterboxGap;
function inverterboxGap() = inverterboxGap;

module Inverter() {
	union() {
		cube([inverter[x]+inverterboxGap[x], inverter[y]+inverterboxGap[y],1]);
		translate([inverterboxGap[x]/2, inverterboxGap[y]/2, 0]) cube(inverter);
	}
}

//
// DC - DC convertor
// To be vertically mounted for air flow
// so dimensions are oriented for vertical mount
//

DCDC_20A = [237, 59, 132];
DCC50S = [244, 146, 96];
dcDc60A = [311, 175,68];

IP67_50A = [178,36, 122];
IP67_50AboxGap = [300,300,0];
DCDC_20AboxGap = [300,300,0];

function dcdc(model) = model == "IP67" ? IP67_50A : DCDC_20A;

module DcDc(model) {
	if (model=="IP67") {
		union() {
			cube(IP67_50A);
		}
	} else if (model=="DCDC20A") {
		cube(DCDC_20A);
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
