include <constants.scad>

//----------------------------------------------------------------------------------------------
// Twin 40mm Fan Duct for Sanyo Denki 9GAX0412P3S001
//----------------------------------------------------------------------------------------------

// 40mm duct size: ID = 38.5, OD = 43;

// Fan dimensions
fanWidth = 40;
ductId = 39;
ductOd = 43.2;

mountingHoleOffset = 4;
m = mountingHoleOffset;
mountingHoleRadius = 3.5;
rm = mountingHoleRadius;
// edge rounding
r = 5;

$fn = 40;

basePlate = 3;
// Spacing between the two ducts
ductSpacing = 20;

ductHeight = 20;
couplingHeight = 20;

plateWidth = 6;
tabLength = 20;
thickness = 2.5;

shim = ductId + 2 * thickness - fanWidth;

// M3 fan mounting screw size
// [screw diameter, head diameter including clearance]
m3 = [3, 5.7 + 0.3];

//----------------------------------------------------------------------------------------------
// Mounting Hole
//----------------------------------------------------------------------------------------------

module mountingHole(size = rm) {
  cylinder(basePlate + 0.2, size / 2, size / 2, $fn=36);
}

//----------------------------------------------------------------------------------------------
// Screw Head
//----------------------------------------------------------------------------------------------

module ScrewHead(size = m3, cutout = false) {
  h = cutout ? 2 * m3[0] + 0.2 : m3[0];
  translate([0, 0, -h]) cylinder(h=h, d=m3[1], $fn=36);
}

//----------------------------------------------------------------------------------------------
// 40mm Duct Coupler
//----------------------------------------------------------------------------------------------

scBR = fanWidth / 2 - m;
scFL = -fanWidth / 2 + m;

coneHeight = ductHeight;

//----------------------------------------------------------------------------------------------
// Screw cutout in the Top Cone
//----------------------------------------------------------------------------------------------

module ScrewCutout(xPos, yPos) {
  translate([xPos, yPos, coneHeight / 2 + 0.1]) ScrewHead(cutout=true);
}

//----------------------------------------------------------------------------------------------
// Screw Wall to thicken the TopCone around the ScrewCutout
//----------------------------------------------------------------------------------------------

module ScrewWall(xPos, yPos) {
  h = 2 * m3[0] + 0.2;

  screwWallOffset = coneHeight + m3[0] - basePlate - h - thickness;

  translate([xPos, yPos, screwWallOffset])
    difference() {
      cylinder(h=h + thickness, d=m3[1] + 2 * thickness, $fn=36);
      translate([0, 0, thickness + 0.1]) cylinder(h=h + 0.2, d=m3[1], $fn=36);
    }
}

//----------------------------------------------------------------------------------------------
// The ConeIntersect is the intersection of the the four ScrewWalls with the solid Outer TopCone
// which will then be used to create the TopCone with clearance for the M3 screw heads
//----------------------------------------------------------------------------------------------

module ConeIntersect() {

  module SolidCone() {
    cylinder(coneHeight, d2=ductId + 2 * thickness, d1=ductOd + 2 * thickness, center=false, $fn=36);
  }
  translate([0, 0, -coneHeight - basePlate]) {
    intersection() {
      SolidCone();
      ScrewWall(scBR, scFL);
    }
    intersection() {
      SolidCone();
      ScrewWall(scFL, scFL);
    }
    intersection() {
      SolidCone();
      ScrewWall(scBR, scBR);
    }
    intersection() {
      SolidCone();
      ScrewWall(scFL, scBR);
    }
  }
}

//----------------------------------------------------------------------------------------------
// The TopCone which is the union of the ConeIntersect and the Cone with the screw cutouts
//----------------------------------------------------------------------------------------------

module TopCone() {
  union() {
    ConeIntersect();
    translate([0, 0, -basePlate - ductHeight / 2]) {
      difference() {
        cylinder(coneHeight, d2=ductId + 2 * thickness, d1=ductOd + 2 * thickness, center=true, $fn=36);
        cylinder(coneHeight + 0.2, d2=ductId, d1=ductOd, center=true, $fn=36);
        ScrewCutout(scBR, scFL);
        ScrewCutout(scFL, scFL);
        ScrewCutout(scBR, scBR);
        ScrewCutout(scFL, scBR);
      }
    }
  }
}

//----------------------------------------------------------------------------------------------
// The Coupler which sits below the TopCone and is used to couple to a standard 40mm
// PVC pipe
//----------------------------------------------------------------------------------------------

module Duct40mmCoupler() {
  id = ductId;

  translate([0, 0, -0.1])
    union() {
      TopCone();

      // Coupling to PVC pipe
      translate([0, 0, -basePlate - ductHeight / 2 + 0.2])
        color("green")
          translate([0, 0, -(ductHeight + couplingHeight) / 2])
            difference() {
              cylinder(couplingHeight, d1=ductOd + 2 * thickness, d2=ductOd + 2 * thickness, center=true, $fn=36);
              cylinder(couplingHeight + 0.2, d1=ductOd, d2=ductOd, center=true, $fn=36);
            }
      // end stop for PVC pipe
      color("blue")
        translate([0, 0, -(basePlate + ductHeight + thickness / 2) - 0.2])
          difference() {
            cylinder(thickness, d1=ductOd + 0.2, d2=ductOd + 0.2, center=true, $fn=36);
            cylinder(thickness + 0.2, d1=ductOd - 2 * thickness, d2=ductOd - 2 * thickness, center=true, $fn=36);
          }
    }
}

//----------------------------------------------------------------------------------------------
// Base Plate for mounting the two fans
// The plate is a wider than the fans to match the diameter of the duct coupling
//----------------------------------------------------------------------------------------------

module BasePlate() {
  // translate([-20, -20, -basePlate])
  //   translate([m, m, -0.1]) {
  //     ScrewHead();
  //   }
  color("white")
    translate([-20, -20, -basePlate])
      union() {
        difference() {
          // The rectangular base plate
          translate([r - shim / 2, r - shim / 2, 0]) linear_extrude(basePlate) offset(r=r)

                square(size=[2 * fanWidth + ductSpacing + shim - 2 * r, fanWidth + 5 - 2 * r]);
          // Add the mounting holes for the two fans
          translate([m, m, -0.1]) mountingHole();
          translate([m, fanWidth - m, -0.1]) mountingHole();
          translate([fanWidth - m, m, -0.1]) mountingHole();
          translate([fanWidth - m, fanWidth - m, -0.1]) mountingHole();

          translate([fanWidth + ductSpacing + m, m, -0.1]) mountingHole();
          translate([fanWidth + ductSpacing + m, fanWidth - m, -0.1]) mountingHole();
          translate([2 * fanWidth + ductSpacing - m, m, -0.1]) mountingHole();
          translate([2 * fanWidth + ductSpacing - m, fanWidth - m, -0.1]) mountingHole();
          // cutout the fan holes
          translate([20, 20, -0.1]) cylinder(h=basePlate + 0.2, d=ductId, $fn=36);
          translate([20 + fanWidth + ductSpacing, 20, -0.1]) cylinder(h=basePlate + 0.2, d=ductId, $fn=36);
        }
      }
}

//----------------------------------------------------------------------------------------------
// The Duct Plate connects the MountingPlate to the Duct 
//----------------------------------------------------------------------------------------------

module DuctPlate(d = ductOd) {
  translate([0, 0, -thickness])
    linear_extrude(height=thickness)
      difference() {
        translate([0, d / 4 + shim / 4, 0]) square([d + thickness, ductOd / 2 + shim], center=true);
        circle(d=d + thickness - 0.2);
      }
}

//----------------------------------------------------------------------------------------------
// The base Mounting Plate used to create the TopMountingPlate and BottomMountingPlate
// to attach the completed unit to the side of the battery box
// Mounting hole size is set to m4
//----------------------------------------------------------------------------------------------

module MountingPlate() {
  plate = [2 * (fanWidth + tabLength) + ductSpacing - 2 * r, plateWidth];

  translate([0, (ductOd + 1) / 2, 0])
    rotate([-90, 0, 0])
      translate([r - 20 - 20, r, 0])
        difference() {
          linear_extrude(basePlate) offset(r=r)
              square(
                size=plate
              );
          translate([m, plate[y] / 2, -0.1]) mountingHole(4);
          translate([plate[x] - m, plate[y] / 2, -0.1]) mountingHole(4);
        }
}

//----------------------------------------------------------------------------------------------
// The Top Mounting Plate which uses a single DuctPlate as the top of the plate is connected
// to the BasePlate
//----------------------------------------------------------------------------------------------

module TopMountingPlate() {
  MountingPlate();
  translate([0, 0, thickness - plateWidth - 2 * r]) {
    DuctPlate(43);
    translate([fanWidth + ductSpacing, 0, 0]) {
      DuctPlate(43);
    }
  }
}

//----------------------------------------------------------------------------------------------
// The Top Mounting Plate which uses 2x DuctPlates
//----------------------------------------------------------------------------------------------

module BottomMountingPlate() {
  plateOffset = [0, 0, -basePlate - ductHeight - couplingHeight + plateWidth + 2 * r + 0.2];
  translate(plateOffset) {
    MountingPlate();
    DuctPlate();
    translate([0, 0, thickness - plateWidth - 2 * r]) DuctPlate();
    translate([fanWidth + ductSpacing, 0, 0]) {
      DuctPlate();
      translate([0, 0, thickness - plateWidth - 2 * r]) DuctPlate();
    }
  }
}

//----------------------------------------------------------------------------------------------
// The complete twin fan duct unit
//----------------------------------------------------------------------------------------------

module TwinFanDuct() {

  color("white") {
    TopMountingPlate();
    BottomMountingPlate();
    Duct40mmCoupler();
    {
      BasePlate();
      translate([fanWidth + ductSpacing, 0, 0]) {
        Duct40mmCoupler();
      }
    }
  }
}

TwinFanDuct();
