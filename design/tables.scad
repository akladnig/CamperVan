include <constants.scad>
include <materials.scad>
include <common_dimensions.scad>

use <sofa_bed.scad>

//----------------------------------------------------------------------------------------------
// Table Design
//----------------------------------------------------------------------------------------------

tableLength = base()[length]-wheelArch[width]-3*slatDepth-2*spacing;
table = [tableLength, 500, 750];

function table() = table;

r = 50;

tablePoly = [[0,0,0], [0,table[x],r], [table[y], table[x],r], [table[y],0,0]];

module Table(showDims) {
	translate([0,spacing]) color(woodColour) linear_extrude(ply15) polyedge(tablePoly);

	if (showDims) {
		color("white") {
			translate([0,0,ply15]) rotate([0,0,90])
			dim_dimension(length=table[x], weight=$weight, offset=-table[y]+50, ext=false);

			translate([0,0,ply15]) dim_dimension(length=table[y], weight=$weight, offset=50, ext=false);
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

