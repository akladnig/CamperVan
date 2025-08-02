include <dimlines.scad>
include <constants.scad>
include <materials.scad>
include <common_dimensions.scad>

use <panels.scad>
use <kitchen_bench.scad>
use <sofa_bed.scad>

//----------------------------------------------------------------------------------------------
// Draw constants
//----------------------------------------------------------------------------------------------

// Use sideGap of 12.5mm if using draw runners or 1.5mm for plain box draws
boxSideGap = 1.5;
runnerSideGap = 12.5;

rearGap = 10;
topGap = 10;
bottomGap = 10;
drawPly = ply6;

latchDiameter = 25;
latchOffset = 12;

//----------------------------------------------------------------------------------------------
// Draw Module
// Create a draw based on the draw front and cupboard depth and chosen draw type:
// - "box"
// - "runner"
//----------------------------------------------------------------------------------------------

module Draw(label,
	frontWidth,
	frontHeight,
	drawDepth,
	isDrawTypeABox,
	openDrawsAndDoors,
	showFront=true,
	showDimensions) {

	sideGap = isDrawTypeABox ? boxSideGap : runnerSideGap; 

	draw = [frontWidth-2*sideGap, drawDepth-rearGap, frontHeight-topGap-bottomGap];

	drawExtension = openDrawsAndDoors
		? drawSetback - draw[y]
		: 0;

	module DrawSide() {
		// Sides - to be finger jointed
		translate([0,facePly,bottomGap])
		cube([drawPly, draw[y], draw[z]]);
	}

	module DrawFrontBack() {
		// front and back to be finger jointed
		translate([sideGap,facePly, bottomGap])
		cube([draw[x], drawPly, draw[z]]);
	}

	translate([0,drawExtension,0]) {
		union() {
			// Front panel
			if (showFront) {
				faceX = frontWidth-spacing;
				faceY = frontHeight-spacing;

				translate([spacing/2,0,spacing/2]) color(woodColour)
				difference() {
					// The front panel and front part of the draw
					union() {
						cube([faceX, facePly+0.1, faceY]);
						color(woodColour3) DrawFrontBack();
					}
					// The cutout for the draw latch
					translate([
						(frontWidth-spacing)/2,
						(facePly+drawPly)/2,
						frontHeight-latchOffset-latchDiameter/2
					])
					 rotate(x90) cylinder(d=latchDiameter,h=facePly+drawPly+0.2, center=true);
				}
				if (showDimensions) {
					color("black") translate([20,0,10]) rotate(x90)
					text(str(label, ": ", faceX, " x ", faceY));		
				}
			}
			color(woodColour3) translate([0,drawDepth-rearGap-drawPly]) DrawFrontBack();
			color(woodColour5) translate([sideGap,0]) DrawSide();
			color(woodColour5) translate([frontWidth-drawPly-sideGap,0]) DrawSide();

			// base of draw
			color(woodColour) translate([sideGap, facePly, bottomGap])
			cube([draw[x], draw[y], ply6]);
		}
	}
}

//----------------------------------------------------------------------------------------------
// Fridge Draw - draw above the fridge
//----------------------------------------------------------------------------------------------

module FridgeDraw(
	isDrawTypeABox,
	openDrawsAndDoors,
	drainOffset,
	drainDiameter,
	showFront=true,
	showDimensions) {

	frontWidth = cupboardWidth[fridge];
	frontHeight = benchHeight-fridge()[z]-sink()[z]-gap;
	drawDepth = sink()[y];

	drawExtension = openDrawsAndDoors
		? drawSetback - drawDepth
		: 0;

	sideGap =  isDrawTypeABox ? boxSideGap : runnerSideGap; 

	draw = [frontWidth-2*sideGap, drawDepth-rearGap, frontHeight-topGap-bottomGap];
	backX = (draw[x]-drainDiameter)/2;
	frontY = drawDepth-drainOffset;

	module drawBase() {
		polygon([
			[sideGap,0],
			[sideGap,drawDepth],
			[sideGap+backX-gap,drawDepth],
			[sideGap+backX-gap,drawDepth-drainOffset-gap],
			[frontWidth-sideGap-backX+gap,drawDepth-drainOffset-gap],
			[frontWidth-sideGap-backX+gap,drawDepth],
			[frontWidth-sideGap,drawDepth],
			[frontWidth-sideGap,0]
		]);
	}

	translate([0,drawExtension,0]) {
	// Front panel
	if (showFront) {
		faceX = frontWidth-spacing;
		faceY = frontHeight-spacing;

		translate([spacing/2,0,spacing/2]) color(woodColour)
		difference() {
			// the front panel
			cube([faceX, facePly, faceY]);
			// the latch cutout
			translate([
				faceX/2,
				(facePly+drawPly)/2,
				frontHeight-latchOffset-latchDiameter/2
			])
		 rotate(x90) cylinder(d=latchDiameter,h=facePly+drawPly+0.2, center=true);
		}
		if (showDimensions) {
			color("black") translate([20,0,10]) rotate(x90) text(str(faceX, " x ", faceY));		
		}
	}

	color(woodColour) translate([0,facePly,bottomGap]){
		linear_extrude(drawPly) drawBase();

		difference() {
			// the actual draw
			linear_extrude(draw[z])
			difference() {
				drawBase();
				offset(delta=-drawPly) drawBase();		
			}
			// the latch cutout
			translate([
				(frontWidth-spacing)/2,
				(facePly+drawPly)/2,
				frontHeight-topGap-latchOffset-latchDiameter/2
			])
		 rotate(x90) cylinder(d=latchDiameter,h=facePly+drawPly+0.2, center=true);
		}
	}
	}
}

//----------------------------------------------------------------------------------------------
// Table Design
//----------------------------------------------------------------------------------------------

tableLength = base()[length]-wheelArch[width]-3*slatDepth-2*spacing;
tableWidth = 500;
// Set at 720 so that the top draw can be opened - 750 is the usual table height
tableHeight = 720;
r = 50;

table = [[0,0,0], [0,tableLength,r], [tableWidth, tableLength,r], [tableWidth,0,0]];

module Table(showDims) {
	translate([0,spacing]) color(woodColour) linear_extrude(ply15) polyedge(table);

	if (showDims) {
		color("white") {
			translate([0,0,ply15]) rotate([0,0,90])
			dim_dimension(length=tableLength, weight=$weight, offset=-tableWidth+50, ext=false);

			translate([0,0,ply15]) dim_dimension(length=tableWidth, weight=$weight, offset=50, ext=false);
		}
	}
}

//----------------------------------------------------------------------------------------------
// Lagun Table
//----------------------------------------------------------------------------------------------

lagunTable = [750,500,750];
function lagunTable() = lagunTable;

lagunTablePoly = [
	[0,0,r],
	[0,lagunTable[length],r],
	[lagunTable[width],lagunTable[length],r],
	[lagunTable[width],0,r]
];


module LagunTable(showDims) {
	translate([0,spacing]) color(woodColour) linear_extrude(ply15) polyedge(lagunTablePoly);

	if (showDims) {
		color("white") {
			translate([0,0,ply15]) rotate([0,0,90])
			dim_dimension(length=lagunTable[length], weight=$weight, offset=-lagunTable[width]+50, ext=false);

			translate([0,0,ply15])
			dim_dimension(length=lagunTable[width], weight=$weight, offset=50, ext=false);
		}
	}
}

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
