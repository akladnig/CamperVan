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
			translate([framingPly/2+0.1,panelHeight-framingWidth+0.1,-0.1])
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
	panelHeight = vi[z]-wheelArch[z];
	topPanelHeight = vi[z]-benchHeight;
	bottomPanelHeight = benchFrameHeight-wheelArch[z];
	panelWidth = cupboard()[y];
	verticalPlate = panelHeight;

	// Bottom Panel
  color(woodColour) translate([framingPly,0,wheelArch[z]])
	cube([panelPly, panelWidth, bottomPanelHeight]);

	// Top Panel
  color(woodColour) translate([-panelPly,0,benchHeight])
	cube([panelPly, panelWidth, topPanelHeight]);

	// Front Plate
	color(woodColour5) translate([0,0,wheelArch[z]])
	cube([framingPly,framingWidth,verticalPlate]);

	// Rear Plate
	color(woodColour5) translate([0,panelWidth-framingWidth,wheelArch[z]])
	cube([framingPly,framingWidth,verticalPlate]);

	// Top Plate
	color(woodColour6) translate([0,0,vi[z]-framingWidth])
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

module CupboardMiddlePanel() {
	BasePanel(cupboard()[width], vi[z]);
}

module CupboardEndPanel() {
}

module WaterTankLeftPanel() {
	BasePanel(cupboard()[width], tank()[z]+tankGap()[z]);
}

