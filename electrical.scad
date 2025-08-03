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
dcDc60A = [311, 175, 68];

IP67_50A = [178, 36, 122];
IP67_50AboxGap = [300, 300, 0];
DCDC_20AboxGap = [300, 300, 0];

function dcdc(model) = model == "IP67" ? IP67_50A : DCDC_20A;

module DcDc(model) {
  if (model == "IP67") {
    union() {
      cube(IP67_50A);
    }
  } else if (model == "DCDC20A") {
    cube(DCDC_20A);
  }
}

//----------------------------------------------------------------------------------------------
// 40mm Fan - Sanyo Denki 9GAX0412P3S001
//----------------------------------------------------------------------------------------------
r = 5;
rm = 3.5 / 2;
fanHeight = 28;
module Fan() {

  module mountingHole() {
    cylinder(fanHeight + 0.2, rm, rm);
  }

  $fn = 40;
  color("black")
    translate([-20, -20, 0])
      union() {
        difference() {
          translate([r, r, 0]) linear_extrude(28) offset(r=r) square(40 - 2 * r);
          translate([4, 4, -0.1]) mountingHole();
          translate([4, 36, -0.1]) mountingHole();
          translate([36, 4, -0.1]) mountingHole();
          translate([36, 36, -0.1]) mountingHole();
          translate([20, 20, -0.1]) cylinder(h=fanHeight + 0.2, r=19);
        }
        translate([20, 20, -0.1]) cylinder(h=fanHeight, r=10);
      }
}

//----------------------------------------------------------------------------------------------
// 90mm Fan Extraction Duct
//----------------------------------------------------------------------------------------------

ductLge = [wheelArch[z] + 2 * gap + slatDepth + boxPly, 90];

function ductLge() = ductLge;

module DuctLge(orientation, diameter = ductLge[diameter], h = ductLge[h]) {
  yPos = orientation == "long" ? -120 : 0;
  color("white") {
    translate([-h / 2, yPos + diameter / 2, diameter / 2])
      rotate(y90)
        difference() {
          cylinder(d=diameter, h=h, center=true);
          cylinder(d=diameter - 4, h=h + 10, center=true);
        }
    ;

    if (orientation == "long") {
      translate([diameter / 2, yPos + diameter / 2, diameter / 2])
        rotate([0, 90, 180]) {
          difference() {
            sphere(r=diameter / 2);
            sphere(r=diameter / 2 - 4);
            cylinder(d=diameter - 4, h=diameter / 2 + 10);
            rotate(x90)
              cylinder(d=diameter - 4, h=boxPly - diameter / 2 - yPos + 10);
          }
          difference() {
            cylinder(d=diameter, h=diameter / 2);
            cylinder(d=diameter - 4, h=diameter / 2 + 10);
            rotate(x90)
              cylinder(d=diameter - 4, h=boxPly - diameter / 2 - yPos + 10);
          }

          rotate(x90)
            difference() {
              cylinder(d=diameter, h=boxPly - diameter / 2 - yPos);
              cylinder(d=diameter - 4, h=boxPly - diameter / 2 - yPos + 10);
              rotate(-x90)
                cylinder(d=diameter - 4, h=diameter / 2 + 10);
            }
          ;
        }
    }
  }
}

//----------------------------------------------------------------------------------------------
// Bus Bar
//----------------------------------------------------------------------------------------------

busBar = [150, 28, 36];
function busBar() = busBar;

module BusBar(polarity) {
  colour = polarity == "+ve" ? "red" : "black";
  color(colour) cube(busBar);
}

//----------------------------------------------------------------------------------------------
// Battery
//----------------------------------------------------------------------------------------------

renogy100 = [268, 193, 205];
renogy200 = [467, 212, 208];

boxGap = [200, 25, 50];
boxPly = 6;

battery = renogy200;

function battery() = [battery];

module Battery() {
  color(monument) cube(battery);
  // +ve terminal
  color("red") translate([175, 40, battery[z]]) cylinder(h=10, r=10);
  // -ve terminal
  color("black") translate([285, 40, battery[z]]) cylinder(h=10, r=10);
}

//----------------------------------------------------------------------------------------------
// Constants for the Battery Box
//----------------------------------------------------------------------------------------------

ductClearance = 25; // clearance around duct
batteryBoxHeight = battery[z] + 2 * boxGap[z] + boxPly;
ductSml = [batteryBoxHeight, 40];

//----------------------------------------------------------------------------------------------
// Duct Cutouts
//----------------------------------------------------------------------------------------------

module DuctCutout(orientation, diameter = ductLge[diameter]) {
  rotation = orientation == "long" ? [90, 0, 0] : y90;
  if (orientation == "long") {
    translate([diameter / 2, -1, diameter / 2])
      rotate(x90)
        cylinder(d=diameter, h=10 * boxPly + 2, center=true);
  } else {
    translate([-1, diameter / 2, diameter / 2])
      rotate(y90)
        cylinder(d=diameter, h=10 * boxPly + 2, center=true);
  }
}
module DuctCutoutSml(diameter = ductSml[diameter]) {
  cylinder(d=diameter, h=10 * boxPly + 2, center=true);
}

//----------------------------------------------------------------------------------------------
// Duct Position
//----------------------------------------------------------------------------------------------

// Position of duct on Battery Box relative to lower left corner
function ductPosition(orientation) =
  orientation == "long" ? [ductClearance, 0, batteryBox[z] - ductLge[diameter] - ductClearance]
  : [0, ductClearance, batteryBox[z] - ductLge[diameter] - ductClearance];

// Position of duct on Battery Box relative to lower left corner
function ductPositionSml(duct = 1) =
  [
    batteryBox("long")[x] - ductSml[diameter] / 2 - boxPly - 5,
    ductSml[diameter] / 2 + boxPly + 5 + (duct - 1) * (ductSml[diameter] + 5),
    0,
  ];

//----------------------------------------------------------------------------------------------
// Inlet Vent Position
//----------------------------------------------------------------------------------------------

// Position of inlet vents on Battery Box relative to top left corner
function inletPositionSml(duct = 1) =
  duct == 1 ?
    [
      ductSml[diameter] / 2 + boxPly + 5,
      batteryBox("long")[y] - ductSml[diameter] / 2 - boxPly - 5,
      0,
    ]
  : [
    ductSml[diameter] / 2 + boxPly + 5 + 200,
    batteryBox("long")[y] - ductSml[diameter] / 2 - boxPly - 5,
    0,
  ];

//----------------------------------------------------------------------------------------------
// 40mm Fan Extraction Duct
//----------------------------------------------------------------------------------------------

function ductSml() = ductSml;

module DuctSml(diameter = ductSml[diameter], h = ductSml[h]) {
  color("white") {
    translate([0, 0, h / 2])
      difference() {
        cylinder(d=diameter, h=h, center=true);
        cylinder(d=diameter - 4, h=h + 10, center=true);
      }
    ;
  }
}

//----------------------------------------------------------------------------------------------
// Battery Box
//----------------------------------------------------------------------------------------------

batteryBox = [
  battery[x] + 2 * boxPly + 2 * boxGap[x] + boxGap[y],
  2 * battery[y] + 2 * (boxGap[y] + boxPly),
  batteryBoxHeight,
];

batteryBoxLong = [
  boxPly + boxGap[y] + battery[x] + 10 + battery[x] + 5 + ductSml[diameter] + 5 + boxPly,
  battery[y] + dcdc("DCDC20A")[y] + 2 * (boxGap[y] + boxPly),
  batteryBoxHeight,
];

function batteryBox(orientation) = orientation == "long" ? batteryBoxLong : batteryBox;

module BatteryBox(ductSize = 40, orientation = "long") {
  // The box with cutouts for the ducts and inlets
  if (ductSize != ductSml[diameter]) {
    difference() {
      OpenBox(batteryBox(orientation), "top", "red");
      translate(ductPosition(orientation)) DuctCutout(orientation=orientation);
    }
  } else {
    difference() {
      OpenBox(batteryBox(orientation), "top", "red");
      translate(ductPositionSml(1)) DuctCutoutSml();
      translate(ductPositionSml(2)) DuctCutoutSml();
      translate(inletPositionSml(1)) DuctCutoutSml();
      translate(inletPositionSml(2)) DuctCutoutSml();
    }
  }

  // Add extraction Fan and Duct
  if (ductSize != ductSml[diameter]) {
    ductX = orientation == "long" ? 0 : boxPly;
    translate([ductX, 0])
      translate(ductPosition(orientation)) DuctLge(orientation=orientation);
  } else {
    // Add small extraction Fans and Duct
    translate([0, 0, -fanHeight - 25]) {
      translate(ductPositionSml(1)) DuctSml();
      translate(ductPositionSml(2)) DuctSml();
    }
    translate([0, 0, batteryBoxHeight - fanHeight - 25]) {
      translate(ductPositionSml(1)) Fan();
      translate(ductPositionSml(2)) Fan();
    }
  }

  // Add inlet vents

  if (ductSize == ductSml[diameter]) {
    translate([0, 0, -40]) translate(inletPositionSml(1)) DuctSml(h=80);
    translate([0, 0, -40]) translate(inletPositionSml(2)) DuctSml(h=80);
  }

  // Batteries
  translate([boxPly, boxPly, boxPly]) {
    translate([boxGap[y], boxGap[y]]) Battery();
    if (orientation == "long") {
      translate([battery[x] + boxGap[y] + 10, boxGap[y], 0]) Battery();
    } else {
      translate([boxGap[y], battery[y] + boxGap[y] + 5, 0]) Battery();
    }
  }

  // Busbars
  // translate([batteryBox()[x]-(boxGap[x]-busBar()[y])/2,boxGap[z],0]) rotate([0,0,90])
  // BusBar("-ve");

  translate(
    [
      // batteryBox(orientation)[x] - (boxGap[x] - busBar()[y]) / 2,
      // batteryBox(orientation)[y] - busBar()[x] - boxPly - 50,
      batteryBox(orientation)[x] - busBar()[x] - 200,
      boxPly,
      batteryBox(orientation)[z] - busBar()[z] - 25,
    ]
  )
    rotate([0, 0, 0])
      BusBar("+ve");

  // 50A DC-DC convertor
  color("blue") {
    if (orientation == "long") {
      translate(
        [
          boxPly + 100,
          batteryBox(orientation)[y] - dcdc("IP67")[y] - boxPly,
          boxPly + 100,
        ]
      )
        DcDc("IP67");
    } else {
      translate(
        [
          batteryBox(orientation)[x] - dcdc("IP67")[x] - 100,
          boxPly,
          boxPly + 100,
        ]
      )
        DcDc("IP67");
    }
  }

  // 20A DC-DC convertor
  dcdc20xOffset =
    orientation == "long" ? dcdc("IP67")[x] + boxPly + 200
    : batteryBox(orientation)[x] - dcdc("DCDC20A")[x] - 100;

  color("green") translate(
      [
        dcdc20xOffset,
        batteryBox(orientation)[y] - dcdc("DCDC20A")[y] - boxPly,
        boxPly + 100,
      ]
    )
      DcDc("DCDC20A");
}

//----------------------------------------------------------------------------------------------
// Inverter
//----------------------------------------------------------------------------------------------

renogy2000WInverter = [442, 220, 92];
renogy3000WInverter = [482, 220, 92];

inverter = renogy2000WInverter;
inverterboxGap = [200, 200, 0];

function inverter() = inverter + inverterboxGap;
function inverterboxGap() = inverterboxGap;

module Inverter() {
  union() {
    // cube([inverter[x]+inverterboxGap[x], inverter[y]+inverterboxGap[y],1]);
    translate([inverterboxGap[x] / 2, inverterboxGap[y] / 2, 0]) cube(inverter);
  }
}

//----------------------------------------------------------------------------------------------
// Power Point
//----------------------------------------------------------------------------------------------

click = [100, 30, 105];
powerPoint = click;

module PowerPoint() {
  color("white") cube(powerPoint);
}
