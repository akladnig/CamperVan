include <constants.scad>
include <common_dimensions.scad>
include <materials.scad>

use <kitchen_bench.scad>
use <water.scad>

verticalPlate = benchHeight-benchPly-2*framingWidth;
benchFrameHeight = benchHeight-benchPly;

module FridgeLeftPanel() {
	// Needs to be high enough to mount the Lagun table mounting plate
	bottomPlate = 100;
	verticalPlate = benchHeight-benchPly-framingWidth-bottomPlate;

	// The Panel
  color(woodColour) cube([panelPly, bench()[width], benchFrameHeight]);

	// Front Plate
	color(woodColour5) translate([panelPly,0,bottomPlate])
	cube([framingPly,framingWidth,verticalPlate]);

	// Rear Plate
	color(woodColour5) translate([panelPly,bench()[width]-framingWidth,bottomPlate])
	cube([framingPly,framingWidth,verticalPlate]);

	// Top Plate
	color(woodColour6) translate([panelPly,0,benchFrameHeight-framingWidth])
	cube([framingPly,bench()[width], framingWidth]);

	// Bottom Plate
	color(woodColour6) translate([panelPly,0,0])
	cube([framingPly,bench()[width], bottomPlate]);
}

module FridgeRightPanel() {
	drawHeight = 150;

	// The Panel
  color(woodColour) cube([panelPly, bench()[width], benchFrameHeight]);

	// Front Plate
	color(woodColour5) translate([panelPly,0,framingWidth])
	cube([framingPly,framingWidth,verticalPlate]);

	// Rear Plate
	color(woodColour5) translate([panelPly,bench()[width]-framingWidth,framingWidth])
	cube([framingPly,framingWidth,verticalPlate]);

	// Top Plate
	color(woodColour6) translate([panelPly,0,benchFrameHeight-framingWidth])
	cube([framingPly,bench()[width], framingWidth]);

	// Top Draw Plate
	color(woodColour6) translate([panelPly,0,benchFrameHeight-drawHeight-framingWidth])
	cube([framingPly,bench()[width], framingWidth]);

	// Bottom Shelf Plate
	color(woodColour6) translate([panelPly,0,tank()[height]+tankGap()[z]-framingWidth])
	cube([framingPly,bench()[width], framingWidth]);

	// Bottom Plate
	color(woodColour6) translate([panelPly,0,0])
	cube([framingPly,bench()[width], framingWidth]);
}

module KitchenMiddlePanel() {
	drawHeight = 150;
	benchFrameHeight = benchFrameHeight-tank()[z]-tankGap()[z];
	verticalPlate = benchFrameHeight - 2*framingWidth;

	// The Panel
  color(woodColour) cube([panelPly, cupboard()[width], benchFrameHeight]);

	// Front Plate
	color(woodColour5) translate([panelPly,0,framingWidth])
	cube([framingPly,framingWidth,verticalPlate]);

	// Rear Plate
	color(woodColour5) translate([panelPly,cupboard()[width]-framingWidth,framingWidth])
	cube([framingPly,framingWidth,verticalPlate]);

	// Top Plate
	color(woodColour6) translate([panelPly,0,benchFrameHeight-framingWidth])
	cube([framingPly,cupboard()[width], framingWidth]);

	// Top Draw Plate
	color(woodColour6) translate([panelPly,0,benchFrameHeight-drawHeight-framingWidth])
	cube([framingPly,cupboard()[width], framingWidth]);

	// Bottom Plate
	color(woodColour6) translate([panelPly,0,0])
	cube([framingPly,cupboard()[width], framingWidth]);
}

module KitchenBenchEndPanel() {

	drawHeight = 150;
	panelHeight = vi[z]-wheelArch[z];
	verticalPlate = panelHeight;

	// The Panel
  color(woodColour) translate([0,0,wheelArch[z]]) cube([panelPly, cupboard()[width], panelHeight]);

	// Front Plate
	color(woodColour5) translate([panelPly,0,wheelArch[z]-framingWidth])
	cube([framingPly,framingWidth,verticalPlate]);

	// Rear Plate
	color(woodColour5) translate([panelPly,cupboard()[width]-framingWidth,framingWidth])
	cube([framingPly,framingWidth,verticalPlate]);

	// Top Plate
	color(woodColour6) translate([panelPly,0,benchFrameHeight-framingWidth])
	cube([framingPly,cupboard()[width], framingWidth]);

	// Top Draw Plate
	color(woodColour6) translate([panelPly,0,benchFrameHeight-drawHeight-framingWidth])
	cube([framingPly,cupboard()[width], framingWidth]);

	// Bottom Plate
	color(woodColour6) translate([panelPly,0,0])
	cube([framingPly,cupboard()[width], framingWidth]);
}

module CupboardMiddlePanel() {
}

module CupboardEndPanel() {
}

module WaterTankLeftPanel() {
}

