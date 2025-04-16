include <constants.scad>
include <materials.scad>
include <van_dimensions.scad>
include <common_dimensions.scad>

use <panels.scad>
use <functions.scad>
use <appliances.scad>
use <water.scad>

// Kitchen Bench

cutleryDrawHeight = 80;

//
// Kitchen Panel Placement relative to the Kitchen Bench
//

kitchenOffset = panelOffset - frontSeatOffset*panelIdentity;

function bench() = bench;

topOfBenchCabinet = bench[z]-benchThickness;

champfer = bench[y] - cupboard[y];

kitchenBenchTop = [bench[x], bench[y]+lip, benchThickness];
 
sinkBenchX = lip+panelThickness+gap+fridge()[x]+gap+panelThickness+lip;

kitchenPoly = [
    [0,0],
    [0, bench[y]+lip],
    [bench[x],bench[y]+lip],
    [bench[x],champfer],
    [sinkBenchX+champfer,champfer], // create a champfer
    [sinkBenchX,0],
];

backingBoard = [bench[x], benchThickness, 100];

hobs = 1;

//
// Kitchen Bench 
// 

module Kitchen(showCupboardDoors, showBenchTop, doorOpen, rightOpening) {
	{
		if (showBenchTop) {
	    color(benchColour)

	    // Cutout sink and hob then insert
	    difference() {
	        translate([0,0,topOfBenchCabinet]) {
	            color(benchColour)
	            linear_extrude(benchThickness)
	            polygon(kitchenPoly);
	        }
	        translate([centre(sinkBenchX,sink()[x]),50, topOfBenchCabinet]) {
	            SinkCutout();
	        }
	        translate([sinkBenchX+50,champfer+50,topOfBenchCabinet]) {
	            rotate([0,0,0]) HobCutout();            
	        }
	    }
	    translate([centre(sinkBenchX,sink()[x]),50,bench[z] - sink()[z]+5]) Sink();

	    translate([sinkBenchX+50,champfer+50,bench[z] - hob()[z]+5]) {
	        translate([0,0,0])
	        Hob(1);
	    }

	    // Add a backing board
	        translate([0,kitchenBenchTop[y]-benchThickness,bench[z]]) color(benchColour) cube(backingBoard);
		}
  
    // Left side fridge panel
    translate([0,lip,0]) FridgeLeftPanel();

    // Fridge cover panel
    if (showCupboardDoors) {
	    translate([facePly+gap+spacing,lip,fridge()[z]+gap]) color(woodColour)
	    cube([
	        fridge()[x]+2*gap-2*spacing,
	        facePly,
	        topOfBenchCabinet-spacing-gap-fridge()[z]]);
    }

    // Right side fridge panel
    translate([kitchenOffset[fr],lip,0]) {
			FridgeRightPanel();

			// Add cover panels and draws from top down
			coverHeight = hob()[z]-benchThickness;

			translate([
				panelThickness,
				champfer,
				topOfBenchCabinet - coverHeight
			]) {
				// Hob cover Panel
				color(woodColour6) cube([cupboardWidth[1],facePly,coverHeight]);

				// Cutlery Draw
		    translate([0,0,-cutleryDrawHeight])
				Draw(kitchenCupboardWidth, cutleryDrawHeight, cupboard[y]-facePly, showCupboardDoors);
			}
		}

    translate([
			kitchenOffset[km]+panelThickness,
			champfer+lip,
			topOfBenchCabinet-hob()[z]-120-spacing
		])
		Draw(kitchenCupboardWidth, 120, cupboard[y]-facePly, showCupboardDoors);

		// Water Filter mounting plate
		mountingHeight = benchHeight-cutleryDrawHeight-hob()[z];
		translate([kitchenOffset[fr]+panelThickness,bench[y],mountingHeight -framingWidth])
		color(woodColour) cube([kitchenCupboardWidth, framingPly, framingWidth]);

    // Kitchen Middle panel
        translate([
            kitchenOffset[km],
            champfer+lip,
            tankShelfHeight()+shelfPly
        ])
        color(woodColour)
				KitchenMiddlePanel();

    // End of bench
    translate([kitchenOffset[be],champfer+lip,0])
		KitchenBenchEndPanel();

    // Water Tank top shelf
    translate([
      kitchenOffset[fr]+panelPly,
      champfer+lip,
			tankShelfHeight()
		])
    color(woodColour3)
		cube([
			2*kitchenCupboardWidth+3*panelThickness-2*panelPly,
			cupboard[y],
			shelfPly
		]);

		// Water Tank Shelf support panel
		translate([kitchenOffset[wa]-tank()[x]-2*gap-panelThickness,champfer+lip,0]) WaterTankLeftPanel();
		
    // Fridge
    // airgap is inlcuded in fridge depth
    airGap = 0;
    translate([panelThickness+gap,kitchenBenchTop[y] - fridge()[y] - airGap,0])
    Fridge(doorOpen,rightOpening);

		// Water Filter
		translate([
		    kitchenOffset[1]+panelThickness+clearance,
		    bench[y],
		    mountingHeight - filter("twin")[z],
		])
		Filter("twin");
	}
}
