include <constants.scad>

renogy100 = [268,193,205];
renogy200 = [467,212,208];

gap = [200,5,50];
boxThickness = 10;

battery = renogy200;

function battery(qty) = [
		battery[x]+qty*(boxThickness+gap[x]),
		qty*(battery[y]+gap[y]+boxThickness),
		battery[z]+gap[z]+qty*boxThickness
];

module Battery(qty) {
	color("red")
	cube(battery(qty));
	translate([50,50,battery(qty)[height]]) color("black") text("Battery Top", size=40);
}

renogy2000WInverter = [442,220,92];
renogy3000WInverter = [482,220,92];

inverter = renogy2000WInverter;

function inverter() = inverter;

module Inverter() {
	cube(inverter);
}
