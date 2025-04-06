
include <constants.scad>
include <materials.scad>
include <van_dimensions.scad>
include <common_dimensions.scad>

use <panels.scad>
use <functions.scad>
use <appliances.scad>
use <water.scad>


// Kitchen Bench
// width = 366 + 50 + 50 + 15 = 481

fridgeCupboard = 500;

//
// Kitchen Panel Placement relative to the Kitchen Bench
//

fridgePanelLeft = lip;
fridgePanelRight = fridgePanelLeft + plyMm + gap + fridge()[x] + gap;
hobPanelRight = fridgePanelRight + plyMm + plyMm + kitchenCupboardWidth + plyMm;
kitchenBenchEndPanel = hobPanelRight + plyMm + kitchenCupboardWidth;
waterTankPanelRight = fridgePanelRight + plyMm + tankGap()[x] + tankGap()[x];

bench = [
    kitchenBenchEndPanel + plyMm,
    500,
    benchHeight
];

function bench() = bench;

topOfBenchCabinet = bench[height]-benchPly;

benchChampfer = bench[y] - cupboard[y];
benchNarrow = [bench[x], bench[y]-benchChampfer, 900];

champfer = bench[y] - cupboard[y];

kitchenBench = [bench[length], bench[width]+lip, plyMm];
 
sinkBenchWidth = lip+plyMm+gap+fridge()[x]+gap+plyMm+lip;
kitchenPoly = [
    [0,0],
    [0, bench[width]+lip],
    [bench[length],bench[width]+lip],
    [bench[length],benchChampfer],
    [sinkBenchWidth+benchChampfer,benchChampfer], // create a champfer
    [sinkBenchWidth,0],
];

backingBoard = [bench[x], plyMm, 100];

hobs = 1;

//
// Kitchen Bench 
// 

module Kitchen(showCupboardDoors, doorOpen, rightOpening) {
	translate([frontSeatOffset, vanInternal[width]-kitchenBench[width]-cladding,0]) {
    color(benchColour)

    // Cutout sink and hob then insert
    difference() {
        translate([0,0,topOfBenchCabinet]) {
            color(benchColour)
            linear_extrude(benchPly)
            polygon(kitchenPoly);
        }
        translate([centre(sinkBenchWidth,sink()[length]),50, topOfBenchCabinet]) {
            SinkCutout();
        }
        translate([sinkBenchWidth+50,champfer+50,topOfBenchCabinet]) {
            rotate([0,0,0]) HobCutout();            
        }
    }
    translate([centre(sinkBenchWidth,sink()[length]),50,bench[height] - sink()[height]+5]) Sink();

    translate([sinkBenchWidth+50,champfer+50,bench[height] - hob()[height]+5]) {
        translate([0,0,0])
        Hob(1);
    }

    // translate([50,50,bench[height]+5]) SinkCover();

    // Add a backing board
        translate([0,kitchenBench[width]-benchPly,bench[height]]) color(benchColour) cube(backingBoard);
  
    // Left side fridge panel
    translate([fridgePanelLeft,lip,0]) FridgeLeftPanel();

    // Fridge cover panel
    if (showCupboardDoors) {
    translate([facePly+gap+spacing,lip,fridge()[height]+gap]) color(woodColour)
    cube([
        fridge()[x]+2*gap-2*spacing,
        facePly,
        topOfBenchCabinet-spacing-gap-fridge()[height]]);
    }
    // Right side fridge panel
    translate([fridgePanelRight,lip,0]) FridgeRightPanel();

    translate([fridgePanelRight+plyMm,champfer+lip, topOfBenchCabinet-hob()[z]-120-spacing]) {
			
	    Draw(kitchenCupboardWidth, 120, benchNarrow[y], showCupboardDoors);
	    translate([kitchenCupboardWidth+2*ply15,0,-50]) Draw(kitchenCupboardWidth, 120, benchNarrow[y], showCupboardDoors);
		}

    // Kitchen Middle panel
        translate([
            hobPanelRight,
            champfer+lip,
            tank()[z]+tankGap()[z]+shelfPly
        ])
        color(woodColour)
				KitchenMiddlePanel();

    // Right side panel of bench
    translate([bench[length],champfer+plyMm,0])
        color(woodColour) cube([panelPly, cupboard[width]+lip-plyMm, vanInternal[height]]);

    // Water Tank top panel
    translate([
        fridgePanelRight+plyMm,
        champfer+plyMm,
        tank()[height]+tankGap()[z]
    ])
    color(woodColour3) cube([2*kitchenCupboardWidth+4*plyMm, cupboard[width]+lip-plyMm, shelfPly]);

		// Water Tank side panel
		translate([
        fridgePanelRight+plyMm+tankGap()[x]+tank()[x]+tankGap()[x],
		    champfer+plyMm,
		    0
		])
		color(woodColour) cube([panelPly, cupboard()[width], tank()[height]+tankGap()[z]]);

    // Fridge
    // airgap is inlcuded in fridge depth
    airGap = 0;
    translate([fridgePanelLeft+plyMm+gap,kitchenBench[width] - fridge()[width] - airGap,0])
    Fridge(doorOpen,rightOpening);
	}
}
