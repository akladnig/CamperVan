include <dimlines.scad>
include <constants.scad>
include <materials.scad>
include <common_dimensions.scad>

use <panels.scad>
use <kitchen_bench.scad>
use <sofa_bed.scad>

//----------------------------------------------------------------------------------------------
// Cupboard Module
//----------------------------------------------------------------------------------------------

module Cupboard(showDoors, showBackPanel) {
	cupboardYOffset =  vi[y]-cupboard[width]-cladding;

	// First Panel
	translate([panelOffset[be]+panelThickness,cupboardYOffset,0]) CupboardFirstPanel();

	// Middle Panel
	translate([panelOffset[wa],cupboardYOffset,0]) CupboardMiddlePanel();

	// Bottom Shelf just above water tank
	translate([panelInnerOffset[be],cupboardYOffset, tankShelfHeight()])
	color(woodColour) cube([cupboardWidth[clothes],cupboard[y],shelfPly]);

	// Middle 1 Shelf supports the inverter with a 50mm air gap above the inverter
	// translate([panelInnerOffset[be],cupboardYOffset, seatHeight])
	translate([panelInnerOffset[be],cupboardYOffset, tankShelfHeight()+inverter()[z]+clearance])
	color(woodColour) cube([cupboardWidth[clothes],cupboard[y],shelfPly]);

	// Middle 2 Shelf
	translate([panelInnerOffset[be],cupboardYOffset, benchHeight-benchThickness])
	color(woodColour) cube([cupboardWidth[clothes],cupboard[y],shelfPly]);

	// Cupboard Top - needs more of an offset due to split face panel
	translate([panelInnerOffset[be]+panelPly,vi[y]-popTopClearance-cladding, vi[z]-shelfPly])
	color(woodColour) cube([
		cupboardWidth[clothes]+cupboardWidth[end]-rearDoorChampfer[x]+panelThickness,
		popTopClearance,
		shelfPly
	]);

	// Panel at rear on side of bed
	// 90 degrees to other panels
	translate([panelInnerOffset[wa],cupboardYOffset, 0])
	color(woodColour) CupboardEndPanel();

	// Backing Panel
	if (showBackPanel){
		CupboardBackingPanel();
		ChampferPanel("right");
	}

	// Base support - mounted to furring strips
	baseLength = panelOffset[vr]-panelOffset[wa]-panelPly;
	basePoly = [
		[0,0],
		[0,cupboard[y]],
		[baseLength-cx,cupboard[y]],
		[baseLength,cupboard[y]-cy],
		[baseLength,0]
	];

	// Base Support
	color(woodColour) translate([panelOffset[wa]+panelPly,cupboardYOffset,-floorPly])
	linear_extrude(floorPly) polygon(basePoly);

	// Shelf above water heater
	 color(woodColour) translate([panelOffset[wa]+panelPly,cupboardYOffset,500]) {
		color(woodColour5) linear_extrude(shelfPly) polygon(basePoly);
		translate([baseLength-framingPly,panelThickness,facePly])
		color(woodColour5)
		cube([facePly,cupboard[y]-cy-panelThickness,shelfLipHeight]);
	}

	// Top Shelf
	color(woodColour)
	translate([panelOffset[wa]+panelPly,cupboardYOffset,vi[z]-rearDoorChampfer[y]-panelThickness])
	{
		linear_extrude(shelfPly) polygon(basePoly);
		translate([baseLength-framingPly,panelThickness,facePly])
		color(woodColour5)
		translate([-panelPly-6,0,0])
		cube([facePly,cupboard[y]-cy-panelThickness+16,shelfLipHeight]);
	}
}
