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

//
// Base panel with framing on all sides
// 
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

module FridgeLeftPanel() {
	// Needs to be high enough to mount the Lagun table mounting plate
	bottomPlate = 100;

	translate([0,lip,0])
	BasePanel(bench()[width], benchFrameHeight);
}

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

module SinkCoverPanel(showCupboardDoors) {
  if (showCupboardDoors) {
    color(woodColour)
		translate(origin()[2]) 
    cube([
      cupboardWidth[fridge],
      facePly,
      sink()[z]-benchThickness
		]);
  }
}

module KitchenMiddlePanel() {
	drawHeight = 150;
	panelHeight = benchFrameHeight-tank()[z]-tankGap()[z]-shelfPly;

	BasePanel(cupboard()[y], panelHeight);

	// Top Draw Plate
	translate([panelPly,0,panelHeight-drawHeight-framingWidth])
	HorizontalPlate(cupboard()[y]);
}

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

module CupboardFirstPanel() {
	panelHeight = vi[z]-wheelArch[z];
	panelWidth = cupboard()[y];

	translate([0,0,wheelArch[z]]) BasePanel(panelWidth,panelHeight)

	// Bench Plate
	color(woodColour6) translate([0,0,benchFrameHeight-framingWidth])
	cube([framingPly, panelWidth, framingWidth]);
}

module CupboardMiddlePanel() {
	BasePanel(cupboard()[width], vi[z]);
}

// End Panels

endPanelWidth =  panelOffset[vr]-panelInnerOffset[wa];

endPanelPoly = [
	[0,0],
	[0,vi[z]],
	[endPanelWidth-rearDoorChampfer[x],vi[z]],
	[endPanelWidth, vi[z]-rearDoorChampfer[y]],
	[endPanelWidth,0]
];	

module CupboardEndPanel() {
	translate([0,panelThickness]) rotate(x90) linear_extrude(panelThickness) polygon(endPanelPoly);
}

module CupboardBackingPanel() {
	color(woodColour)
	union() {
		translate([panelInnerOffset[be]-panelPly,vi[y]-cladding, tankShelfHeight()])
		cube([cupboardWidth[clothes]+panelThickness,panelPly,vi[z]-tankShelfHeight()]);
		translate([panelInnerOffset[wa]-panelThickness,vi[y]-cladding,0]) cube([endPanelWidth-rearDoorChampfer[x],panelPly,vi[z]]);
	}
}

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

module WaterTankLeftPanel() {
	BasePanel(cupboard()[width], tank()[z]+tankGap()[z]);
}

