include <BOSL2/std.scad>

$overlap = 0.002;
shiftout = 0.01;
cutout = 0.1;
tolerance = 0.3;

//----------------------------------------------------------------------------------------------
// Twin 40mm Fan Duct for Sanyo Denki 9GAX0412P3S001
//----------------------------------------------------------------------------------------------

// 40mm duct size: ID = 38.5, OD = 43;

// Fan dimensions
fanWidth = 40;
fanWall = 1.8;
fanEdgeRadius = 3.75;
fanTolerance = 0.3;
fanHoleSpacing = 32;
mountingHoleOffset = 4;
m = mountingHoleOffset;
mountingHoleRadius = 3.5;
rm = mountingHoleRadius;

// PVC
pvcId = 39;
pvcIr = pvcId / 2;
pvcOd = 43.2;
pvcOr = pvcOd / 2;

wall = 2;

couplerOd = pvcOd + 2 * wall;
couplerOr = couplerOd / 2;

// edge rounding

r = 5;

$fn = 60;

basePlate = 5;
// Spacing between the two ducts
ductSpacing = 20;

ductHeight = 20;
couplingHeight = 20;

plateWidth = 6;
mountingPlateWidth = 14;
tabLength = 15;

ductOd = pvcId + 2 * wall;

// M3 fan mounting screw size
// [screw diameter, head diameter including clearance, cutout height]
m3 = [3, 5.7 + fanTolerance, 6];

//----------------------------------------------------------------------------------------------
// Mounting Hole
//----------------------------------------------------------------------------------------------

module mountingHole(size = rm) {
  cylinder(basePlate + cutout, size / 2, size / 2, center=true);
}

//----------------------------------------------------------------------------------------------
// Screw Head
//----------------------------------------------------------------------------------------------

module ScrewHead(size = m3) {
  down(h) cylinder(h=m3.x, d=m3.y);
}

//----------------------------------------------------------------------------------------------
// 40mm Duct Coupler
//----------------------------------------------------------------------------------------------

coneHeight = ductHeight;

//----------------------------------------------------------------------------------------------
// Screw Wall to thicken the TopCone around the ScrewCutout
//----------------------------------------------------------------------------------------------

module ScrewWall() {
  h = 2 * m3.x;
  d = m3.y + 2 * fanWall;

  attachable(h=h + fanWall, d=d, anchor=TOP) {
    tag_scope()
      diff()
        cylinder(h=h + fanWall, d=d, anchor=CENTER)
          align(TOP, inside=true, shiftout=shiftout)
            tag("remove") cylinder(h=h + 0.2, d=m3.y);
    align(BOTTOM)
      cylinder(h=2 * h, d1=fanWall, d2=d, anchor=CENTER)
        children();
  }
}

//----------------------------------------------------------------------------------------------
// The ConeIntersect is the intersection of the the four ScrewWalls with the solid Outer TopCone
// which will then be used to create the TopCone with clearance for the M3 screw heads
//----------------------------------------------------------------------------------------------

module ConeIntersect() {

  module SolidCone() {
    cylinder(coneHeight, d1=couplerOd, d2=ductOd, anchor=TOP);
  }

  attachable(h=2 * m3.x + fanWall, d=couplerOd, anchor=TOP) {
    tag_scope()
      up(m3.x + fanWall / 2)
        intersection() {
          SolidCone();
          grid_copies(fanWidth - 2 * m, n=2) ScrewWall();
        }
    children();
  }
}

//----------------------------------------------------------------------------------------------
// The TopCone which is the union of the ConeIntersect and the Cone with the screw cutouts
//----------------------------------------------------------------------------------------------

module TopCone() {
  attachable(h=coneHeight, d1=couplerOd, d2=pvcOd, anchor=TOP) {
    tag_scope()
      union() {

        diff() {
          tube(coneHeight, od1=couplerOd, od2=pvcOd, wall=wall)
            tag("remove") align(TOP)
                grid_copies(fanWidth - 2 * m, n=2)
                  down(m3.z) cylinder(m3.z + cutout, d=m3.y, anchor=TOP);
        }
        align(TOP, inside=true)
          ConeIntersect();
      }
    children();
  }
}

//----------------------------------------------------------------------------------------------
// The Coupler which sits below the TopCone and is used to couple to a standard 40mm
// PVC pipe. The inside of the coupler is tapered to account for tolerances.
//----------------------------------------------------------------------------------------------

module Duct40mmCoupler() {
  attachable(h=couplingHeight, d=couplerOd, anchor=TOP) {
    tag_scope()
      union() {
        tube(h=couplingHeight, id1=pvcOd+tolerance, id2=pvcOd, wall=wall, ichamfer=tolerance)
          align(TOP, inside=true)
            // end stop for PVC pipe
            tube(h=2 * wall, od1=pvcOd + 0.1, od2=pvcOd + 0.1, id1=pvcId, id2=pvcOd);
      }
    children();
  }
}

module TwinDucts(n=2) {
  attachable(size=[2 * fanWidth + ductSpacing, couplerOd, coneHeight + couplingHeight], anchor=TOP + BACK) {
    tag_scope()
      up((coneHeight + couplingHeight) / 2)
        xcopies(spacing=fanWidth + ductSpacing, n=n)
          TopCone()
            align(anchor=BOTTOM)
              Duct40mmCoupler();
    children();
  }
}

//----------------------------------------------------------------------------------------------
// Fan Base Plate 
//----------------------------------------------------------------------------------------------

module FanBasePlate() {
  cuboid(size=[fanWidth + fanTolerance, fanWidth + fanTolerance, 1], edges="Z", rounding=fanEdgeRadius);
}

//----------------------------------------------------------------------------------------------
// Base Plate for mounting the two fans
// The plate is a wider than the fans to match the diameter of the duct coupling
//----------------------------------------------------------------------------------------------

module BasePlate() {
  basePlateSize = [2 * couplerOd + ductSpacing, couplerOd, basePlate];

  color("white")
    attachable(size=basePlateSize, anchor=TOP + BACK) {

      diff() {
        tag_scope() diff() {
            // The rectangular base plate with rounded front edge
            cuboid(basePlateSize, rounding=r, edges=[FRONT + LEFT, FRONT + RIGHT]);

            // Add the mounting holes for the two fans
            // and cut out the fan holes
            xcopies(fanWidth + ductSpacing, n=2) {
              tag("remove") grid_copies(fanWidth - 2 * m, n=2) mountingHole();
              tag("remove") cylinder(h=basePlate + 0.2, d=pvcId, center=true);
              tag("keep") grid_copies(fanWidth - 2 * m, n=2) tube(h=basePlate, id=m3.y, wall=fanWall);
            }
          }
        xcopies(fanWidth + ductSpacing, n=2) {
          tag("remove") align(TOP, inside=true, shiftout=shiftout) FanBasePlate();
        }
      }
      children();
    }
}

//----------------------------------------------------------------------------------------------
// The Duct Plate connects the MountingPlate to the Duct 
//----------------------------------------------------------------------------------------------

module DuctPlate(small = false, isSolid = false) {
  // Shim is the distance from the mounting plate to the cone.
  theta = atan((couplerOr - pvcOr) / coneHeight);
  shim = (coneHeight + basePlate - (mountingPlateWidth - wall)) * tan(theta);
  dSmall = couplerOd - 2 * shim;

  wallSize = isSolid ? mountingPlateWidth : wall;
  plateWidth = small ? fanHoleSpacing - m3.y : couplerOd;
  size = [plateWidth, couplerOr, wallSize];
  d = small ? dSmall : couplerOd;

  attachable(size=size) {
    diff() {
      cube(size, anchor=CENTER)
        tag("remove")
          position(FRONT)
            cylinder(d=d - cutout, h=wallSize + cutout, anchor=CENTER);
    }
    children();
  }
}

//----------------------------------------------------------------------------------------------
// The base Mounting Plate used to create the TopMountingPlate and BottomMountingPlate
// to attach the completed unit to the side of the battery box
// Mounting hole size is set to m4
//----------------------------------------------------------------------------------------------

plateSize = [2 * (fanWidth + tabLength) + ductSpacing, mountingPlateWidth, basePlate];

module MountingPlate() {

  attachable(size=plateSize) {
    diff() {
      cuboid(plateSize, edges="Z", rounding=r)
        tag("remove") xcopies(plateSize.x - 2 * m, n=2) mountingHole();
    }
    children();
  }
}

//----------------------------------------------------------------------------------------------
// The Top Mounting Plate which uses a single DuctPlate as the top of the plate is connected
// to the BasePlate
//----------------------------------------------------------------------------------------------

module TopMountingPlate() {

  attachable(size=plateSize) {
    MountingPlate()
      attach(TOP, BACK, align=FRONT)
        xcopies(fanWidth + ductSpacing)
          DuctPlate(small=true);
    children();
  }
}

//----------------------------------------------------------------------------------------------
// The Top Mounting Plate which uses 2x DuctPlates
//----------------------------------------------------------------------------------------------

module BottomMountingPlate() {
  attachable(size=plateSize) {
    MountingPlate()
      attach(TOP, BACK, align=FRONT)
        xcopies(fanWidth + ductSpacing) DuctPlate(isSolid=true);
    // grid_copies([fanWidth + ductSpacing, mountingPlateWidth - wall]) DuctPlate(isSolid=true);
    children();
  }
}

//----------------------------------------------------------------------------------------------
// The complete twin fan duct unit
//----------------------------------------------------------------------------------------------

module TwinFanDuct() {

  color("white") {

    BasePlate() {
      attach(BACK, TOP, align=TOP) TopMountingPlate();
      attach(BOTTOM, TOP) TwinDucts() {
          attach(BACK, TOP, align=BOTTOM) BottomMountingPlate();
        }
      ;
    }
  }
}

// TwinDucts(n=1);
// TopMountingPlate();
TwinFanDuct();
