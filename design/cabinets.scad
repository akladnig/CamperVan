include <dimlines.scad>
include <constants.scad>
include <materials.scad>
include <common_dimensions.scad>

use <panels.scad>
use <kitchen_bench.scad>
use <sofa_bed.scad>

//----------------------------------------------------------------------------------------------
// Internal Sliding Door Cupboard Module
//----------------------------------------------------------------------------------------------

cupboardYOffset =  vi[y]-cupboard[width]-cladding;

// Inset from the front of the cupboard so that the door is inset to make sure there is enough
// meat to route out the channel
slidingDoorInset = 6; 

// Clearance between the sliding door and the end cupboard
slidingDoorClearance = 2;
endCupboardDepth = cupboardYOffset+facePly+slidingDoorInset+slidingDoorClearance;

// Channel Depths and Widths
topChannelDepth = 6;
bottomChannelDepth = 4;
channelWidth = 6;

module InternalSlidingDoorCupboard(showDoors, openDrawsAndDoors, showBackPanel) {

	//
	// Panels
	// 
	
	// First Panel
	translate([panelOffset[be]+panelThickness,cupboardYOffset,0]) CupboardFirstPanel();

	// Middle Panel
	translate([panelOffset[wa],endCupboardDepth,0])
	CupboardMiddlePanel(cupboard()[width]-framingPly-slidingDoorInset-slidingDoorClearance);

	//
	// Shelves
	//
	
	// Bottom Shelf just above water tank supports the inverter with a 50mm air gap above
	// the inverter
	
	// translate([panelInnerOffset[be],cupboardYOffset, seatHeight])
	translate([panelInnerOffset[be],cupboardYOffset, tankShelfHeight()])
	color(woodColour) cube([cupboardWidth[clothes],cupboard[y],shelfPly]);

	// Middle 1 Shelf supports the inverter with a 50mm air gap above the inverter
	shelf1Height = tankShelfHeight()+inverter()[z]+clearance;

	translate([panelInnerOffset[be],cupboardYOffset, shelf1Height])
	color(woodColour)
	difference() {
		cube([cupboardWidth[clothes],cupboard[y],shelfPly]);
		translate([0,slidingDoorInset+facePly-channelWidth, shelfPly-bottomChannelDepth])
		cube([cupboardWidth[clothes]+0.1,channelWidth, bottomChannelDepth+0.1]);
	}

	// Middle 2 Shelf
	shelf2Height = benchHeight-benchThickness;
	translate([panelInnerOffset[be],cupboardYOffset, shelf2Height])
	color(woodColour)
	difference() {
		cube([cupboardWidth[clothes],cupboard[y],shelfPly]);
		translate([0,slidingDoorInset+facePly-channelWidth, shelfPly-bottomChannelDepth])
		cube([cupboardWidth[clothes]+0.1,channelWidth, bottomChannelDepth+0.1]);
	}

	//
	// Sliding Doors
	//

	openOffset = panelInnerOffset[wa]-framingPly-spacing;
	closedOffset = panelInnerOffset[be]+framingPly+spacing;

	doorOffset = openDrawsAndDoors ? openOffset : closedOffset;

	// Top Sliding Door
	
	topDoorOffset = openDrawsAndDoors ? openOffset-50 : closedOffset;
	translate([
		topDoorOffset,
		cupboardYOffset+slidingDoorInset,
		shelf2Height+shelfPly+spacing
	])
	rotate([-topPanelAngles()[0],0,0])
	union(){
		color(woodColour5)
		cube([
			cupboardWidth[clothes]-spacing,
			facePly,
			topPanelAngles()[1]*(vi[z]-shelf2Height-2*shelfPly-2*spacing)
		]);
		translate([0,facePly-channelWidth,-bottomChannelDepth])
		color(woodColour4)
		cube([
			cupboardWidth[clothes]-spacing,
			channelWidth,
			topPanelAngles()[1]*(vi[z]-shelf2Height-2*shelfPly-2*spacing + topChannelDepth + bottomChannelDepth)
		]);
	}

	// Bottom Sliding Door
	
	translate([
		doorOffset,
		cupboardYOffset+slidingDoorInset,
		shelf1Height+shelfPly+spacing
	])
	union(){
	color(woodColour5)
		cube([
			cupboardWidth[clothes]-spacing,
			facePly,
			shelf2Height-shelf1Height-shelfPly-2*spacing
		]);
		translate([0,facePly-channelWidth,-bottomChannelDepth])
	color(woodColour4)
		cube([
			cupboardWidth[clothes]-spacing,
			channelWidth,
			shelf2Height-shelf1Height-shelfPly-2*spacing + topChannelDepth + bottomChannelDepth
		]);
	}
	// Cupboard Top - needs more of an offset due to split face panel
	translate([panelInnerOffset[be]+panelPly,vi[y]-popTopClearance-cladding, vi[z]-shelfPly])
	color(woodColour) cube([
		cupboardWidth[clothes]+cupboardWidth[end]-rearDoorChampfer[x]+panelThickness,
		popTopClearance,
		shelfPly
	]);

	// Backing Panel
	if (showBackPanel){
		CupboardBackingPanel();
		ChampferPanel("right");
	}

}

//----------------------------------------------------------------------------------------------
// Rearmost Cupboard Module
//----------------------------------------------------------------------------------------------

module RearmostCupboard(showDoors, showBackPanel) {
	cupboardYOffset =  vi[y]-cupboard[width]-cladding;

	// Panel at rear on side of bed
	// 90 degrees to other panels
	translate([panelInnerOffset[wa],cupboardYOffset+facePly+slidingDoorInset, 0])
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

	shelfY = cupboard[y]-facePly-slidingDoorInset;
	shelfPoly = [
		[0,0],
		[0,shelfY],
		[baseLength-cx,shelfY],
		[baseLength,shelfY-cy],
		[baseLength,0]
	];

	// Base Support
	color(woodColour) translate([panelOffset[wa]+panelPly,cupboardYOffset,-floorPly])
	linear_extrude(floorPly) polygon(basePoly);

	// Shelf above water heater
	 color(woodColour) translate([
			panelOffset[wa]+panelPly,
			cupboardYOffset+facePly+slidingDoorInset,
			500
		]) {
		color(woodColour5) linear_extrude(shelfPly) polygon(shelfPoly);
		translate([baseLength-framingPly,panelThickness,facePly])
		color(woodColour5)
		cube([facePly,cupboard[y]-cy-panelThickness,shelfLipHeight]);
	}

	// Top Shelf
	color(woodColour)
	translate([
		panelOffset[wa]+panelPly,
		cupboardYOffset,
		benchHeight-benchThickness])
		// vi[z]-rearDoorChampfer[y]-panelThickness])
	{
		linear_extrude(shelfPly) polygon(basePoly);
		translate([baseLength-framingPly,panelThickness,facePly])
		color(woodColour5)
		translate([-panelPly-6,0,0])
		cube([facePly,cupboard[y]-cy-panelThickness+16,shelfLipHeight]);
	}
}
