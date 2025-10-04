include <constants.scad>
include <materials.scad>
include <van_dimensions.scad>
include <common_dimensions.scad>

use <panels.scad>
use <draws.scad>
use <functions.scad>
use <appliances.scad>
use <water.scad>

//----------------------------------------------------------------------------------------------
// Kitchen Panel Placement relative to the Kitchen Bench rather than the Van
//----------------------------------------------------------------------------------------------

// This is a vector
kitchenOffset = panelOffset - frontSeatOffset*panelIdentity;
kitchenInnerOffset = panelInnerOffset - frontSeatOffset*panelIdentity;

topOfBenchCabinet = bench[z]-benchThickness;

champfer = bench[y] - cupboard[y];

kitchenBenchTop = [bench[x], bench[y]+lip, benchThickness];
 
sinkBenchX = panelThickness+gap+fridge()[x]+gap+panelThickness+lip;

kitchenPoly = [
  [0,0],
  [0, bench[y]+lip],
  [bench[x],bench[y]+lip],
  [bench[x],champfer],
  [sinkBenchX+champfer,champfer], // create a champfer
  [sinkBenchX,0],
];

splashBack = [bench[x], benchThickness, 100];

hobs = 1;


//----------------------------------------------------------------------------------------------
// Draw, cover panels and shelf [x,y,z] origins relative to the Kitchen Bench
// Draws, cover panels and shelfs are numbered starting from 0 and start at the bottom
// incrementing vertically then horizontally
//----------------------------------------------------------------------------------------------

// Minimum height for cutlery plus 10 on top and 10 on bottom for gap
cutleryDrawHeight = 60 + 20;

// Minimum height for draw in front of water filter
filterDrawHeight = filter("twin")[z];

// Second Draw height
secondDrawHeight =  bench[z]-hob()[z]-cutleryDrawHeight-filterDrawHeight-tankShelfHeight()-ply12;
origin = [
	// 0 - Fridge
	[panelThickness,0,0],                   	
	[panelThickness,lip,fridge()[z]+gap],			// 1 - Draw above fridge
	[panelThickness,lip,bench[z]-sink()[z]],	// 2 - Cover plate in front of sink

	// 3 - Base of cupboard right of fridge
	[kitchenOffset[fr],lip,0],								
	// 4 - Bottom Draw
	[kitchenInnerOffset[fr], champfer+lip, ply12],	
	// 5 - Shelf above water tank
	[kitchenInnerOffset[fr], champfer+lip, tankShelfHeight()],	
	// 6 - Second Draw
	[kitchenInnerOffset[fr], champfer+lip, tankShelfHeight()+ply12],	
	// 7 - Third Draw
	[kitchenInnerOffset[fr], champfer+lip, bench[z]-hob()[z]-cutleryDrawHeight-filterDrawHeight],	
	// 8 - Top Draw - Cutlery
	[kitchenInnerOffset[fr], champfer+lip, bench[z]-hob()[z]-cutleryDrawHeight],
	// 9 - Hob cover Panel
	[kitchenInnerOffset[fr], champfer+lip, bench[z]-hob()[z]],	
];

function origin() = origin;

//----------------------------------------------------------------------------------------------
// Kitchen Bench 
//----------------------------------------------------------------------------------------------

module Kitchen(
	showCupboardDoors,
	openDrawsAndDoors,
	showBenchTop,
	showSplashBack,
	showAppliances,
	showBackPanel,
	showDimensions,
	drawTypeIsBox,
	doorOpen,
	rightOpening) {
	sinkClearance = 30;
	hobClearance = 20;
	
	if (showBenchTop) {
    color(benchColour)

    // Cutout sink and hob then insert
    difference() {
        translate([0,0,topOfBenchCabinet]) {
            color(benchColour)
            linear_extrude(benchThickness)
            polygon(kitchenPoly);
        }
        translate([centre(sinkBenchX-lip,sink()[x]),sinkClearance , topOfBenchCabinet]) {
            SinkCutout();
        }
        translate([sinkBenchX+sinkClearance ,champfer+hobClearance ,topOfBenchCabinet]) {
            rotate([0,0,0]) HobCutout();            
        }
    }

		if (showAppliances) {
	    translate([centre(sinkBenchX-lip,sink()[x]),sinkClearance ,bench[z] - sink()[z]])
			Sink();

	    translate([sinkBenchX+sinkClearance ,champfer+hobClearance ,bench[z] - hob()[z]+5])
      Hob(1);
		}

    // Add a splash back
    if (showSplashBack) {
	    color(benchColour) translate([0,kitchenBenchTop[y]-benchThickness,bench[z]]) 
			cube(splashBack);
		}
	}

  // Left side fridge panel
  FridgeLeftPanel();

  // Sink cover panel
  SinkCoverPanel(showCupboardDoors, showDimensions);
	
	// Fridge Draw
	translate(origin[1])
	FridgeDraw(drawTypeIsBox, openDrawsAndDoors, drainOffset(), 40, showCupboardDoors, showDimensions);
	
  // Right side fridge panel
  translate(origin()[3]) 
	FridgeRightPanel();

	//
	// Add cover panels and draws from bottom up
	// 

	drawDepth =  cupboard[y]-facePly;

	// Draw at floor level between fridge and water tank
  translate(origin()[4])
	Draw("Floor", cupboardWidth[wtank], tankShelfHeight()-ply12, drawDepth, drawTypeIsBox, openDrawsAndDoors, showCupboardDoors, showDimensions);

  // Water Tank top shelf
  waterTankShelfWidth = 2*kitchenCupboardWidth+3*panelThickness-2*panelPly;
  translate(origin()[5])
  color(woodColour3)
	cube([
		waterTankShelfWidth,
		cupboard[y],
		shelfPly
	]);

	// Second Draw
  translate(origin()[6])
	Draw("2", cupboardWidth[LHKitchen], secondDrawHeight, drawDepth, drawTypeIsBox, openDrawsAndDoors, showCupboardDoors, showDimensions);

	// Third Draw - allow room behind for water pipes 
	pipesAndClips = 15;
	
  translate(origin()[7])
	Draw("3", cupboardWidth[LHKitchen], filterDrawHeight, drawDepth-pipesAndClips, drawTypeIsBox, openDrawsAndDoors, showCupboardDoors, showDimensions);

	// Cutlery Draw
  translate(origin()[8])
	Draw("Cutlery", cupboardWidth[LHKitchen], cutleryDrawHeight, drawDepth, drawTypeIsBox, openDrawsAndDoors, showCupboardDoors, showDimensions);

	// Hob cover Panel
	coverHeight = hob()[z]-benchThickness;
	translate(origin()[9]) 
	color(woodColour6) cube([cupboardWidth[1],facePly,coverHeight]);

	// Water Filter mounting plate
	mountingHeight = benchHeight-cutleryDrawHeight-hob()[z];
	// color(woodColour)
	// translate([
	// 	kitchenOffset[2]+panelThickness,
	// 	cupboard()[y]+lip-framingPly,
	// 	mountingHeight-framingWidth
	// ])
	// cube([kitchenCupboardWidth, framingPly, framingWidth]);

  // Kitchen Middle panel
  color(woodColour)
  translate([
      kitchenOffset[km],
      champfer+lip,
      tankShelfHeight()+shelfPly
  ])
	KitchenMiddlePanel();

	// Right Hand Kitchen cabinet draw at top
	drawHeight =  coverHeight+cutleryDrawHeight;

  translate([
		kitchenOffset[km]+panelThickness,
		champfer+lip,
		topOfBenchCabinet-drawHeight
	])
	Draw("4", cupboardWidth[RHKitchen], drawHeight, drawDepth, drawTypeIsBox, openDrawsAndDoors,showCupboardDoors, showDimensions);

  // End of bench
  translate([kitchenOffset[be],champfer+lip,0])
	KitchenBenchEndPanel();

	// Water Tank Shelf support panel
	waterTankOffset = wheelArchFront-frontSeatOffset-tankL-2*gap-panelThickness;
	translate([waterTankOffset,champfer+lip,0]) WaterTankLeftPanel();

	// Base support - mounted to furring strips
	color(woodColour)
	translate([0,lip,-floorPly])
	union() {
		cube([cupboardWidth[fridge]+2*panelThickness,bench()[y],floorPly]);
		translate([kitchenOffset[fr]+panelThickness,champfer,0])
		cube([waterTankOffset-kitchenOffset[fr],cupboard()[y],floorPly]);
	}		

	// Back panel against campervan wall
	
	panelHeight = benchHeight+splashBack[z]-tank()[z]-tankGap()[z];
	if (showBackPanel) {
		translate([0,bench()[y]+lip,-floorPly])
		color(woodColour6) union() {
			cube([
				wheelArchFront-frontSeatOffset-cladding,
				panelPly,
				floorPly+benchHeight+splashBack[z]
			]);
			translate([
				kitchenOffset[fr]+panelThickness,
				0,
				floorPly+tankShelfHeight()
			])
			cube([
				cupboardWidth[LHKitchen ]+cupboardWidth[RHKitchen]+2*panelThickness,
				panelPly,
				panelHeight
			]);
		}
	}

  // Fridge
  // airgap is inlcuded in fridge depth
  airGap = 0;
	filter = "single";

	if (showAppliances) {
		
    translate([panelThickness+gap,kitchenBenchTop[y] - fridge()[y] - airGap,0])
    Fridge(doorOpen,rightOpening);

		// Water Filter
		translate([
		    kitchenOffset[2]+panelThickness+clearance,
		    bench[y]+lip-framingPly,
		    mountingHeight,
		]) {
			// Filter
			translate([0,0,-filter(filter)[h]]) Filter(filter);
			// // Pump
			// translate([
			// 	filter(filter)[diameter]+clearance,
			// 	0,
			// 	-pump()[z]
			// ])
			// Pump();

			// // Strainer
			// translate([
			// 	filter(filter)[diameter]+clearance+pump()[x]-pumpInlet()[x]+strainer()[x]/2,
			// 	// 0,
			// 	pumpInlet()[y],
			// 	pumpInlet()[z]-pump()[z]
			// ])
			// Strainer();
		}
	}
}
