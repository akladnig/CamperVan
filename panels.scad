include <constants.scad>
include <common_dimensions.scad>
include <materials.scad>

use <kitchen_bench.scad>
use <water.scad>

verticalPlate = benchHeight-benchThickness-2*framingWidth;
benchFrameHeight = benchHeight-benchThickness;

//
// Horizontal Plate for use in panels
// Use half lap joints
// 
module HorizontalPlate(panelWidth, plateColour=woodColour6) {
		color(plateColour)
		difference() {
			cube([framingPly, panelWidth, framingWidth]);

			// half lap cutouts
			translate([-1,-1,-1])
			cube([framingPly/2+1, framingWidth+2, framingWidth+2]);
			translate([-0.1,panelWidth-framingWidth+0.1,-0.1])
			cube([framingPly/2+0.1, framingWidth+0.2, framingWidth+0.2]);
		}
}

//
// Vertical Plate for use in panels
// 
module VerticalPlate(panelHeight, plateColour=woodColour5) {
	difference() {
		color(plateColour) cube([framingPly, framingWidth, panelHeight]);

			// half lap cutouts
			translate([framingPly/2,-1,-1])
			cube([framingPly/2+1, framingWidth+2, framingWidth+1]);
			translate([framingPly/2+0.1,-0.1, panelHeight-framingWidth+0.1])
			cube([framingPly/2+0.1, framingWidth+0.2, framingWidth+0.2]);
	}
}

//----------------------------------------------------------------------------------------------
// Base panel with framing on all sides
//----------------------------------------------------------------------------------------------
 
module BasePanel(panelWidth, panelHeight) {

	// The Panel
  color(woodColour) cube([panelPly, panelWidth, panelHeight]);

	// Front Plate
	translate([panelPly,0,0])
	VerticalPlate(panelHeight);

	// Rear Plate
	translate([panelPly,panelWidth-framingWidth,0])
	VerticalPlate(panelHeight);

	// Top Plate
	translate([panelPly,0,panelHeight-framingWidth])
	HorizontalPlate(panelWidth);

	// Bottom Plate
	translate([panelPly,0,0])
	HorizontalPlate(panelWidth);
}

//----------------------------------------------------------------------------------------------
// Full height Cupboard base panel with framing on all sides
//----------------------------------------------------------------------------------------------
 
// The offset of the champfer above the bench
panelZOffset = 0;

module CupboardBasePanel(panelWidth, panelHeight) {
	
	panelPoly = [
		[0,0],
		[0,panelHeight-vi[z]+bench()[z]+panelZOffset],
		[panelWidth-popTopClearance, panelHeight],
		[panelWidth, panelHeight],
		[panelWidth,0]
	];
	
	// The Panel
  color(woodColour) {
		rotate([90,0,0])
		rotate([0,90,0])
		linear_extrude(panelPly)
		polygon(panelPoly);
	}

	// Vertical Front Plate
	translate([panelPly,0,0])
	VerticalPlate(panelHeight-vi[z]+bench()[z]+panelZOffset);

	// Angled Top Front Plate
	// translate([panelPly,0,0])
	// VerticalPlate(panelHeight);

	// Rear Plate
	translate([panelPly,panelWidth-framingWidth,0])
	VerticalPlate(panelHeight);

	// Top Plate
	translate([panelPly,panelWidth-popTopClearance,panelHeight-framingWidth])
	HorizontalPlate(popTopClearance);

	// Bottom Plate
	translate([panelPly,0,0])
	HorizontalPlate(panelWidth);
}

//----------------------------------------------------------------------------------------------
// Fridge Left Panel
//----------------------------------------------------------------------------------------------

module FridgeLeftPanel() {
	// Needs to be high enough to mount the Lagun table mounting plate
	bottomPlate = 100;

	translate([0,lip,0])
	BasePanel(bench()[width], benchFrameHeight);
}

//----------------------------------------------------------------------------------------------
// Fridge Right Panel
//----------------------------------------------------------------------------------------------

module FridgeRightPanel() {
	drawHeight = 150;

	BasePanel(bench()[width], benchFrameHeight);

	// Top Draw Plate
	color(woodColour6) translate([panelPly,0,benchFrameHeight-drawHeight-framingWidth])
	cube([framingPly,bench()[width], framingWidth]);

	// Bottom Shelf Plate
	color(woodColour6) translate([panelPly,0,tank()[height]+tankGap()[z]-framingWidth])
	cube([framingPly,bench()[width], framingWidth]);
}

//----------------------------------------------------------------------------------------------
// Sink Cover Panel
//----------------------------------------------------------------------------------------------

module SinkCoverPanel(showCupboardDoors, showDimensions) {
	faceX = cupboardWidth[fridge];
	faceY = sink()[z]-benchThickness;

  if (showCupboardDoors) {
		translate(origin()[2]) {
	    color(woodColour)
	    cube([
	      faceX,
	      facePly,
	      faceY
			]);
			if (showDimensions) {
				color("black") translate([20,0,10]) rotate(x90) text(str(faceX, " x ", faceY));
			}
		}
	}
}

//----------------------------------------------------------------------------------------------
// Kitchen Mid Panel
//----------------------------------------------------------------------------------------------

module KitchenMiddlePanel() {
	drawHeight = 150;
	panelHeight = benchFrameHeight-tank()[z]-tankGap()[z]-shelfPly;

	BasePanel(cupboard()[y], panelHeight);

	// Top Draw Plate
	translate([panelPly,0,panelHeight-drawHeight-framingWidth])
	HorizontalPlate(cupboard()[y]);
}

//----------------------------------------------------------------------------------------------
// Kitchen Bench End Panel
//----------------------------------------------------------------------------------------------

module KitchenBenchEndPanel() {
	drawHeight = 150;
	panelHeight = benchFrameHeight-wheelArch[z];
	panelWidth = cupboard()[y];
	verticalPlate = panelHeight;

	// Bottom Panel
  color(woodColour) translate([framingPly,0,wheelArch[z]])
	cube([panelPly, panelWidth, panelHeight]);

	// Front Plate
	color(woodColour5) translate([0,0,wheelArch[z]])
	cube([framingPly,framingWidth,verticalPlate]);

	// Rear Plate
	color(woodColour5) translate([0,panelWidth-framingWidth,wheelArch[z]])
	cube([framingPly,framingWidth,verticalPlate]);

	// Top Plate
	color(woodColour6) translate([0,0,benchFrameHeight-framingWidth])
	cube([framingPly, panelWidth, framingWidth]);

	// Bench Plate
	color(woodColour6) translate([0,0,benchFrameHeight-framingWidth])
	cube([framingPly, panelWidth, framingWidth]);

	// Top Draw Plate
	color(woodColour6) translate([0,0,benchFrameHeight-drawHeight-framingWidth])
	cube([framingPly, panelWidth, framingWidth]);

	// Bottom Plate
	color(woodColour6) translate([0,0,wheelArch[z]])
	cube([framingPly, panelWidth, tankGap()[z]-(wheelArch[z]-tank()[z])]);
}

//----------------------------------------------------------------------------------------------
// Cupboard First Panel
//----------------------------------------------------------------------------------------------

module CupboardFirstPanel() {
	panelHeight = vi[z]-wheelArch[z];
	panelWidth = cupboard()[y];

	translate([0,0,wheelArch[z]]) CupboardBasePanel(panelWidth,panelHeight)

	// Bench Plate
	color(woodColour6) translate([0,0,benchFrameHeight-framingWidth])
	cube([framingPly, panelWidth, framingWidth]);
}

//----------------------------------------------------------------------------------------------
// Cupboard Middle Panel
//----------------------------------------------------------------------------------------------

module CupboardMiddlePanel() {
	CupboardBasePanel(cupboard()[width], vi[z]);
}

//----------------------------------------------------------------------------------------------
// Cupboard End Panel
//----------------------------------------------------------------------------------------------

endPanelWidth =  panelOffset[vr]-panelInnerOffset[wa];

endPanelAngle = atan((cupboard()[width]-popTopClearance)/(vi[z]-bench()[z]-panelZOffset));
endPanelFactor = 1/cos(endPanelAngle);

endPanelPoly = [
	[0,0],
	[0,endPanelFactor*(vi[z]-bench()[z]-panelZOffset)],
	[endPanelWidth-rearDoorChampfer[x],endPanelFactor*(vi[z]-bench()[z]-panelZOffset)],
	[endPanelWidth,0]
];	

YOffset = panelThickness*sin(endPanelAngle);

module CupboardEndPanel() {
	translate([endPanelWidth,0,0])
	rotate(z90) BasePanel(endPanelWidth,bench()[z]+panelZOffset);
	translate([0,0,bench()[z]+panelZOffset]) {
	rotate([-endPanelAngle,0,0])
	translate([0,panelThickness,0])
		rotate(x90)
		linear_extrude(panelThickness)
		polygon(endPanelPoly);
	}
}

//----------------------------------------------------------------------------------------------
// Cupboard Backing Panel
//----------------------------------------------------------------------------------------------

module CupboardBackingPanel() {
	color(woodColour)
	union() {
		translate([panelInnerOffset[be]-panelPly,vi[y]-cladding, tankShelfHeight()])
		cube([cupboardWidth[clothes]+panelThickness,panelPly,vi[z]-tankShelfHeight()]);
		translate([panelInnerOffset[wa]-panelThickness,vi[y]-cladding,0]) cube([endPanelWidth-rearDoorChampfer[x],panelPly,vi[z]]);
	}
}

//----------------------------------------------------------------------------------------------
// Champfer Panel
//----------------------------------------------------------------------------------------------

module ChampferPanel(side) {
	position = side == "right" ? 
		[vi[x]-cx,vi[y]-cladding,0] :
		[vi[x]-cx,0,0];

	angle = side == "right" ? ca-90 : 90-ca;

	color(woodColour)
		translate(position)
		rotate([0,0,angle])
		cube([cl,panelPly,vi[z]]);
}

//----------------------------------------------------------------------------------------------
// Water Tank Left Panel
//----------------------------------------------------------------------------------------------

module WaterTankLeftPanel() {
	BasePanel(cupboard()[width], tank()[z]+tankGap()[z]);
}

