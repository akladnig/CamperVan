include <dimlines.scad>
include <constants.scad>
include <materials.scad>
include <common_dimensions.scad>

use <kitchen_bench.scad>
use <sofa_bed.scad>

//
// Create a draw based on the draw front and cupboard depth  
// 
module Draw(frontWidth, frontHeight, drawDepth, showFront=true) {
	rearGap = 10;
	sideGap = 12.5;
	topGap = 10;
	bottomGap = 10;
	drawPly = ply6;

	draw = [frontWidth-2*sideGap, drawDepth-rearGap, frontHeight-topGap-bottomGap];
	drawOffset = [];

	module DrawSide() {
		// Sides - to be finger jointed
		translate([drawPly,ply15,bottomGap])
		rotate([0,0,90])
		cube([draw[y], drawPly, draw[z]]);
	}

	module DrawFrontBack() {
		// front and back to be finger jointed
		translate([ply15 + sideGap,ply15, bottomGap])
		cube([draw[x], drawPly, draw[z]]);
	}

	union() {
		// Front panel
		if (showFront) {
			translate([spacing/2,0]) color(woodColour)
			cube([frontWidth+2*ply15-spacing, ply15, frontHeight]);
			color(woodColour3) DrawFrontBack();
		}
		color(woodColour3) translate([0,drawDepth-rearGap-drawPly]) DrawFrontBack();
		color(woodColour5) translate([ply15+sideGap,0]) DrawSide();
		color(woodColour5) translate([frontWidth+ply15-drawPly-sideGap,0]) DrawSide();
		// bottom
		color(woodColour) translate([ply15 + sideGap, ply15, bottomGap])
		cube([draw[x], draw[y], ply6]);
	}
}


//
// Table Design
// 
tableLength = base()[length]-wheelArch[width]-3*slatDepth-2*spacing;
tableWidth = 500;
tableHeight = 750;
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

//
// Lagun Table Design
// 
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

module Cupboard(showDoors) {
  translate([frontSeatOffset+bench()[x]+kitchenCupboardWidth,vi[y]-cupboard[width]+lip-plyMm,0]) color(woodColour) cube([panelPly, cupboard[width]+lip-plyMm, vanInternal[height]]);
}
