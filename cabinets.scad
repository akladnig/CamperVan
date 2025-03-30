include <constants.scad>
include <materials.scad>

module cabinet(dimensions) {
	cube(dimensions);
}

//
// Create a draw based on the draw front and cupboard depth  
// 
module Draw(frontWidth, frontHeight, drawDepth, showFront=true) {
	rearGap = 10;
	sideGap = 12.5;
	topGap = 10;
	bottomGap = 10;
	drawPly = ply9;

	draw = [frontWidth-2*sideGap, drawDepth-rearGap, frontHeight-topGap-bottomGap];
	drawOffset = [];
	module DrawSide() {
		// Sides - to be finger jointed
		translate([spacing/2 + ply15/2 + sideGap+drawPly,ply15,bottomGap])
		rotate([0,0,90])
		cube([draw[y], drawPly, draw[z]]);
	}

	module DrawFrontBack() {
		// front and back to be finger jointed
		translate([spacing/2 + ply15/2 + sideGap,ply15, bottomGap])
		cube([draw[x], drawPly, draw[z]]);
	}

	union() {
		// Front panel
		if (showFront) {
			translate([spacing/2,0]) color(woodColour) cube([frontWidth+ply15-spacing, ply15, frontHeight]);
			color(woodColour3) DrawFrontBack();
		}
		color(woodColour3) translate([0,drawDepth-rearGap-drawPly]) DrawFrontBack();
		color(woodColour5) DrawSide();
		color(woodColour5) translate([draw[x]-drawPly,0]) DrawSide();
		// bottom
		color(woodColour) translate([spacing/2 + ply15/2 + sideGap, ply15, bottomGap])
		cube([draw[x], draw[y], ply6]);
	}
}


tableLength = base()[length]-wheelArch[width]-3*slatDepth-2*spacing;
tableWidth = 460;
tableHeight = 750;
r = 50;
$fn=40;

table = [[0,0,0], [0,tableLength,r], [460, tableLength,r], [460,0,0]];

module Table() {
	translate([0,spacing]) color(woodColour) linear_extrude(ply15) polyedge(table);
}
