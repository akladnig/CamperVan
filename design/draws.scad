include <constants.scad>
include <materials.scad>
include <common_dimensions.scad>

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
					text(str(label, ": ", faceX, " x ", faceY), size=14);		
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
			color("black") translate([20,0,10]) rotate(x90) text(str(faceX, " x ", faceY), size=14);		
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

