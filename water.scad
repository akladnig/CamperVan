include <constants.scad>
include <materials.scad>
include <van_dimensions.scad>
include <common_dimensions.scad>

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
// Water Tank
// 
CAN_SB39 = [550, 390, 200];
CAN_SB57 = [550, 390, 290];
CAN_SB77 = [750, 390, 290];
Vetus42 = [610, 350, 400];
Vetus61 = [780, 350, 400];

// Custom L shape
a = 300;
b = cupboard[y]-wheelArch[y]-gap;

tank = [a+wheelArch[x], cupboard[y]-gap-framingPly, wheelArch[z]+cladding];

custom = [
	[0,0],
	[0,tank[width]],
	[a,tank[width]],
	[a,b],
	[tank[length],b],
	[tank[length],0],
] ; //97.5 litres

volume = (tank[length]*tank[width]-wheelArch[x]*(wheelArch[y]+gap))*wheelArch[z]/1000/1000;
tankStr = str("Water Tank ", floor(volume), " litres"); 

function tank() = tank;
function tankGap() = [10,10,50];

module WaterTank() {
	echo(volume=volume);
	color("green") linear_extrude(wheelArch[z]) polygon(custom);	
	translate([50,0,100]) rotate([90,0,0]) color("black") text(tankStr, size=40);
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
// HotWater
// 

duoettoG3 = [450,275,265];
hotWater = duoettoG3;

function hotWater() = hotWater;

module HotWater() {
	color("white") cube(hotWater);	
}

//
// Shower
// 
joolca = [290,170,450];

shower = joolca;

function shower() = shower;

module Shower() {
	color("white") cube(shower);
	translate([50,0,100]) color(monument)rotate([90,0,0]) text("Shower", size=40);
}

//
// Gas Bottle
// 
4kg = [350,250];
9kg = [464,314];

gasBottle = 4kg;

function gasBottle() = gasBottle;

module GasBottle() {
	color("blue") translate([0,0,gasBottle[x]/2])
	cylinder(h=gasBottle[x], d=gasBottle[y], center=true);	
}

//
// Heater
// 
vevorVertical = [150, 380, 410];
heater = vevorVertical;
function heater() = heater;

module Heater() {
	cube(heater);
}
