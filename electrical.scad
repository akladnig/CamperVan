// include <constants.scad>
// include <materials.scad>
// include <van_dimensions.scad>
include <common_dimensions.scad>

use <common.scad>

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
// Fan Extraction Duct
//
ductDiameter = 90;
duct = [wheelArch[z]+2*gap+slatDepth+boxPly,ductDiameter];
function duct() = duct;

module Duct(orientation, diameter=duct[diameter], h=duct[h]) {
	yPos = orientation == "long" ? -120 : 0;
	color("white") {
		translate([-h/2,yPos + diameter/2,diameter/2])
		rotate(y90)
		difference() {
			cylinder(d=diameter, h=h, center=true);
			cylinder(d=diameter-4, h=h+10, center=true);
		};

		if (orientation == "long") {
			translate([diameter/2,yPos+diameter/2, diameter/2])
			rotate([0,90,180]) {
				difference() {
					sphere(r=diameter/2);
					sphere(r=diameter/2-4);
					cylinder(d=diameter-4, h=diameter/2+10);
					rotate(x90)
					cylinder(d=diameter-4, h=boxPly-diameter/2-yPos+10);
				}
				difference() {
					cylinder(d=diameter, h=diameter/2);
					cylinder(d=diameter-4, h=diameter/2+10);
					rotate(x90)
					cylinder(d=diameter-4, h=boxPly-diameter/2-yPos+10);
				}

				rotate(x90)
				difference() {
					cylinder(d=diameter, h=boxPly-diameter/2-yPos);
					cylinder(d=diameter-4, h=boxPly-diameter/2-yPos+10);
					rotate(-x90)
					cylinder(d=diameter-4, h=diameter/2+10);
				};
			}
		}
	}
}

module DuctCutout(orientation, diameter=duct[diameter]) {
	rotation = orientation == "long" ? [90,0,0] : y90;
	if (orientation == "long") {
		translate([diameter/2,-1,diameter/2])
		rotate(x90)
		cylinder(d=diameter, h=10*boxPly+2, center=true);
	} else {
		translate([-1,diameter/2,diameter/2])
		rotate(y90)
		cylinder(d=diameter, h=10*boxPly+2, center=true);
	}
}

// Position of duct on Battery Box relative to lower left corner
function ductPosition(orientation) = orientation == "long"
	? [clearance,0,batteryBox[z]-duct[diameter]-clearance]
	: [0,clearance,batteryBox[z]-duct[diameter]-clearance];

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

batteryBoxLong = [
		2*battery[x]+2*boxPly+2*boxGap[y]+10+20,
		battery[y]+dcdc("DCDC20A")[y]+2*(boxGap[y]+boxPly),
		battery[z]+2*boxGap[z]+boxPly
];

function batteryBox(orientation) = orientation == "long" ? batteryBoxLong : batteryBox;

module BatteryBox(orientation="long") {
	difference() {
		OpenBox(batteryBox(orientation), "top", "red");
		translate(ductPosition(orientation)) DuctCutout(orientation=orientation);
	}

	// Batteries
	translate([boxPly,boxPly,boxPly]) {
		translate([boxGap[y],boxGap[y]]) Battery();
		if (orientation == "long") {
			translate([battery[x]+boxGap[y]+10,boxGap[y],0]) Battery();
		} else {
			translate([boxGap[y],battery[y]+boxGap[y]+5,0]) Battery();
		}
	}

	// Add an extraction Fan and Duct
		if (orientation == "long") {
			translate([0,0])
			translate(ductPosition(orientation)) Duct(orientation=orientation);	
		} else {
			translate([boxPly,0])
			translate(ductPosition(orientation)) Duct(orientation=orientation);	
		}


	// Busbars
	translate([boxPly,boxPly,boxPly]) {
		// translate([batteryBox()[x]-(boxGap[x]-busBar()[y])/2,boxGap[z],0]) rotate([0,0,90])
		// BusBar("-ve");

		translate([
			batteryBox(orientation)[x]-(boxGap[x]-busBar()[y])/2,
			batteryBox(orientation)[y]-busBar()[x]-boxPly-50,
			0
		])
		rotate([0,0,90])
		BusBar("+ve");
	}

	// 50A DC-DC convertor
	color("blue") {
		if (orientation == "long") {
		translate([
			boxPly+100,
			batteryBox(orientation)[y]-dcdc("IP67")[y]-boxPly,
			boxPly+100
		])
		DcDc("IP67");	
	} else {
		translate([
			batteryBox(orientation)[x]-dcdc("IP67")[x]-100,
			boxPly,
			boxPly+100
		])
		DcDc("IP67");	
	}
}

	// 20A DC-DC convertor
	dcdc20xOffset = orientation == "long"
		? dcdc("IP67")[x] + boxPly + 200
		: batteryBox(orientation)[x]-dcdc("DCDC20A")[x]-100;

	color("green") translate([
		dcdc20xOffset,
		batteryBox(orientation)[y]-dcdc("DCDC20A")[y]-boxPly,
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
		// cube([inverter[x]+inverterboxGap[x], inverter[y]+inverterboxGap[y],1]);
		translate([inverterboxGap[x]/2, inverterboxGap[y]/2, 0]) cube(inverter);
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
