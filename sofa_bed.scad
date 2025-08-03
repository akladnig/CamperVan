include <van_dimensions.scad>
include <common_dimensions.scad>
include <dimlines.scad>
include <materials.scad>

use <common.scad>
use <electrical.scad>

// Double Bed
bedLength = 1880;
bedWidth = 1240;

// Mattress Sizes
// Double: 1880 x 1370
// Queen:  2030 x 1530

// Matresses
clarkRubberComfortDeluxe = [1880, 1220, 100]; 
clarkRubberComfortDeluxe2 = [1840, 1220, 100]; 
custom = [1840, 1340, 100]; 
clarkRubber = 142; 
newentor = 220;

// mattress = clarkRubberComfortDeluxe2;
mattress = custom;

//
// Headboard box should be around 600x200 to fit the doona inside
// 
headBoardBox = [mattress[width],headBoardBoxWidth,600];

// Couch
// Is made from mattress and cut into 3x pieces
// Back rest angle 100-110 degrees
// angle = 70; 
// 
// Build a test frame using a single slat to confirm lengths and operation
// 
seatWidth  = 557-hingeClosed[z]/2; // - hinge depths
backShelf = 100;
headBoardShelf = [mattress[y], headBoardBox[y], slatDepth];
angle = 15;

base = [mattress[width],baseWidth,seatHeight-mattress[height]];

function base() = base;

x1 = slatDepth*cos(angle);
w = base[width] - seatWidth - backShelf;
x2 = w - x1 - slatDepth - 3*hingeClosed[z];

backrest = x2/sin(angle)-hingeClosed[z];

rearSupport = mattress[length] -seatWidth -backrest -backShelf-3*hingeClosed[z];

function mattress() = mattress;

// 850 + 142 + 19 + 50 = 1061
function sofaBed(sofaMode) = sofaMode ?
	[base[width] + mattress[height] + slatDepth + rearDoorClearance,0] : [0,0];


module SofaBed(sofaMode, perforatedPanel, showPanels) {
	module SofaBedPanel(perforatedPanel, panelWidth) {
		if (perforatedPanel) {
			SofaBedPerforatedPanel(panelWidth);
		} else {
			SofaBedSlatPanel(panelWidth);
		}
	}

	echo(seatWidth=seatWidth, backrest=backrest, rearSupport=rearSupport);

	if (sofaMode) {
		OuterSlidingFrame();

		if (showPanels) {
			translate([seatWidth, 0, base[height] - slatDepth]) {
				rotate(z90)
				SofaBedPanel(perforatedPanel, seatWidth);
			}

			translate([seatWidth+hingeClosed[z],0, base[height]]) {
		    rotate([0,90+angle,0])
				rotate(z90)
		    SofaBedPanel(perforatedPanel, backrest);
			}

			translate([base[width]-backShelf-slatDepth-hingeClosed[z],0,base[height]]) {
		    rotate([0,90,0])
				rotate(z90)
		    SofaBedPanel(perforatedPanel, rearSupport);
			}

			translate([base[width]-backShelf,0,base[height] - slatDepth]) {
				color(woodColour) cube([backShelf, base[length], slatDepth]);
			}
		}

	// Bed Mode
	} else {
		seatOffset = base[width] - rearSupport - backrest - backShelf ;

		translate([seatOffset-seatWidth, 0, 0]) {
			OuterSlidingFrame();
		}

		if (showPanels) {
			xOffset =  base[width]-mattress[length];
			translate([xOffset, 0, base[height] - slatDepth]) {
				translate([seatWidth,0,0])
				rotate([0,0, 90])
				SofaBedPanel(perforatedPanel, seatWidth);
			}

			translate([xOffset+seatWidth+hingeClosed[z],0, base[height] - slatDepth]) {
				translate([backrest,0,0])
		    rotate([0,0,90])
		    SofaBedPanel(perforatedPanel, backrest);
			}

			translate([xOffset+seatWidth+backrest+2*hingeClosed[z],0,base[height] - slatDepth]) {
				translate([rearSupport,0,0])
		    rotate([0,0,90])
		    SofaBedPanel(perforatedPanel, rearSupport);
			}
		
			translate([base[width]-backShelf,0,base[height] - slatDepth]) {
				color(woodColour) cube([backShelf, base[length], slatDepth]);
			}
		}
	}
}

//
// SofaBed Cushions
//
module SofaBedCushions(sofaMode, showCushions) {
	
couchSeat = [seatWidth, base[length], mattress[height]];
backrestM = [backrest, base[length], mattress[height]];
rearSupportM = [rearSupport+backShelf+hingeClosed[z], base[length], mattress[height]];
couchGap =  rearSupport*sin(angle);

if (sofaMode) {
	if (showCushions) {
			translate([0, 0, seatHeight - mattress[height]]) {
		    color(couchCushionColour) 
		    cube(couchSeat);
			}

			offsetX =  mattress[height] * sin(angle) * cos(angle);
			offsetZ =  mattress[height] * sin(angle) * sin(angle);
	
			translate([seatWidth+offsetX, 0, seatHeight-offsetZ]) {
		    rotate([0,270+angle,0])
		    color(couchCushionColour) 
		    cube(backrestM);
			}

			translate([base[width]-backShelf,0,seatHeight-mattress[height]]) {
		    translate([mattress[height],0,0]) rotate([0,-90,0])
		    color(couchCushionColour) 
		    cube(rearSupportM);
			}
		}
	} else {
		if (showCushions) {
			seatOffset = base[width] - mattress[length];

			translate([seatOffset, 0, seatHeight - mattress[height]]) {
		    color(couchCushionColour) 
		    cube(couchSeat);
			}

			translate([seatOffset + seatWidth + hingeClosed[z], 0, seatHeight - mattress[height]]) {
		    color(couchCushionColour) 
		    cube(backrestM);
			}

			translate([seatOffset + seatWidth + backrest + 2*hingeClosed[z],0,seatHeight - mattress[height]]) {
		    color(couchCushionColour) 
		    cube(rearSupportM);
			}
		}
	}
}

ratio = 0.5;
slats = ceil((base[length] - slatWidth) * ratio/slatWidth);
slatGap = round((base[length] - slatWidth)/slats) - slatWidth;

//
// Sofa Bed Panels
// 
module SofaBedSlatPanel(panelWidth) {
	// Bottom
	translate([slatWidth,0,0]) {
		color(woodColour5)
		cube([base[length] - 2 * slatWidth, slatWidth, slatDepth]);
	}

	// Top
	translate([slatWidth,panelWidth - slatWidth,0]) {
		color(woodColour5)
		cube([base[length] - 2 * slatWidth, slatWidth, slatDepth]);
	}

	// Right Side
	translate([base[length] - slatWidth,0,0]) {
		color(woodColour)
		cube([slatWidth, panelWidth, slatDepth]);
	}

	// Left Side
	translate([0,0,0]) {
		color(woodColour)
		cube([slatWidth, panelWidth, slatDepth]);
	}

	// Slats
	for (i = [1:slats-1]) {
		color(woodColour)
		translate([i*(slatWidth + slatGap) ,slatWidth,0]) {
			cube([slatWidth, panelWidth-2*slatWidth, slatDepth]);
		}
	}
}

//
// Sofa Bed hole panel
//

module SofaBedPerforatedPanel(panelWidth) {
	diameter = 86;
	radius = diameter/2;
	gap = round(0.2*radius+15);
	rg = radius + gap;

	n = round((base[length]-2*rg)/2/rg);
	m = round((panelWidth-4*rg)/3.464/rg);

	xoffset = round((base[length]-2*n*rg)/2);
	yoffset = round((panelWidth - 2*(1+m*1.732)*rg)/2);

	if (yoffset > 2*radius) {
		newGap = (panelWidth-(2+m)*diameter)/(m+1);
		echo(gap=gap, newGap=newGap);
	}
	echo(n=n, m=m, xoff=xoffset, yoff=yoffset);

	difference() {
		color(woodColour)
		cube([base[length], panelWidth, slatDepth]);
		color("white") translate([0,0,slatDepth]) dim_dimension(length=(xoffset+gap), loc="right", weight=$weight, offset=50);
		color("white") translate([0,panelWidth,slatDepth]) rotate([0,0,-90]) dim_dimension(length=(yoffset+gap), loc="right", weight=$weight, offset=50);
		color("white") translate([200,panelWidth-yoffset-gap-diameter,slatDepth]) rotate([0,0,-90]) dim_dimension(length=gap, loc="left", weight=$weight, offset=50);

		for (i = [0:n-1]) {
			for (j = [0:m]) {
				translate([xoffset + rg + i*2*rg,yoffset+rg+j*3.464*rg,-1])
				cylinder(h=slatDepth+2,r=radius);
			}
		}
		for (i = [0:n-2]) {
			for (j = [0:m-1]) {
				translate([xoffset + 2*rg + i*2*rg,yoffset+2.732*rg+j*3.464*rg,-1])
				cylinder(h=slatDepth+2,r=radius);
			}
		}
	}
}

overhang = 50;

//
// Outer Sliding Support frame - closest to the passenger side
//
module OuterSlidingSupport() {

	supportX = batteryBox()[y]-ductLge()[diameter]-ductPosition()[y]-2*slatWidth-gap;
	offsetX = supportX+overhang+slatWidth;

	// Top Support
	translate([overhang,0,base[height]-slatWidth-slatDepth]) {
    color(woodColour) 
		cube([supportX+2*slatWidth, slatDepth, slatWidth]);
	}

	// Bottom Support
	translate([overhang+slatWidth,0,0]) {
    color(woodColour) 
		cube([supportX, slatDepth, slatWidth]);
	}

	// Left Support
	translate([overhang,0,0]) {
    color(woodColour5) 
		cube([slatWidth, slatDepth, base[height]-slatWidth-slatDepth]);
	}

	// Right Support
	translate([offsetX,0,0]) {
    color(woodColour5) 
		cube([slatWidth, slatDepth, base[height]-slatWidth-slatDepth]);
	}
}

//
// Inner Sliding Support frame
//
module InnerSlidingSupport() {

	supportX = base[width]-wheelArchOffset-2*slatWidth-slatDepth-overhang;
	offsetX = supportX+overhang+slatWidth;

	// Top Support
	translate([overhang,0,base[height]-slatWidth-slatDepth]) {
    color(woodColour) 
		cube([seatWidth-overhang+slatWidth/2, slatDepth, slatWidth]);
	}

	// Bottom Support
	translate([overhang+slatWidth,0,0]) {
    color(woodColour) 
		cube([seatWidth-overhang-1.5*slatWidth, slatDepth, slatWidth]);
	}

	// Left Support
	translate([overhang,0,0]) {
    color(woodColour5) 
		cube([slatWidth, slatDepth, base[height]-slatWidth-slatDepth]);
	}

	// Right Support
	translate([seatWidth-slatWidth/2,0,0]) {
    color(woodColour5) 
		cube([slatWidth, slatDepth, base[height]-slatWidth-slatDepth]);
	}
}

//
// Outer frame is attached to the seatSlat and is pulled out to transform from Sofa to Bed
//
module OuterSlidingFrame() {
	
	// OuterFrame
	translate([0,wheelArch[width],0]) {
		OuterSlidingSupport();
	}

	// InnerFrame
	translate([0,base[length]-2*slatDepth,0]) {
		InnerSlidingSupport();
	}

	// Front Top Plate
	translate([overhang-slatDepth,wheelArch[width]+legWidth,base[height]-slatWidth-slatDepth-ply15-spacing]) {
    color(woodColour6) 
		cube([slatDepth, base[length]-wheelArch[width]-2*legWidth-slatDepth, slatWidth]);
	}

	// Front Legs
	translate([overhang-slatDepth,wheelArch[width],0]) {
    color(woodColour2)
		difference() {
			cube([slatDepth, legWidth, base[height]-slatDepth]);
			translate([-0.1,slatDepth,base[height]-slatDepth-ply15-spacing])
			cube([slatDepth+0.2,legWidth-slatDepth+0.1,ply15+spacing+0.1]);
		}
	}

	translate([overhang-slatDepth,base[length]-legWidth-slatDepth,0]) {
    color(woodColour2) 
		difference() {
			cube([slatDepth, legWidth, base[height]-slatDepth]);
			translate([-0.1,-0.1,base[height]-slatDepth-ply15-spacing])
			cube([slatDepth+0.2,legWidth-slatDepth+0.1,ply15+spacing+0.1]);
		}
	}
}

//----------------------------------------------------------------------------------------------
// 
// Box Draws to fit inside Head Board
// 
//----------------------------------------------------------------------------------------------


function headBoardBox() = headBoardBox;

boxDrawWidth = floor((headBoardBox[x]-cy-3*boxPly)/3);
bottomBoxHeight = 150;
rearLip = 50;

hingePivot=13.5;
hingeRadius = 3;


module BoxDraw(width, angle) {
	module EndPlate() {
		difference() {
			linear_extrude(boxPly)
			polyedge([
				[0,0,hingePivot],
				[0,headBoardBox[y]-boxPly,0],
			 	[rearLip,headBoardBox[y]-boxPly,0],
				[bottomBoxHeight-2*boxPly-spacing,0,0],
			]);
			translate([hingePivot,hingePivot,-0.1]) cylinder(r=hingeRadius, h=boxPly+0.2);
		}
	}


	drawPoly = [
		[0,0,hingePivot],
		[0,headBoardBox[y]-boxPly,0],
	 	[rearLip,headBoardBox[y]-boxPly,0],
	 	[rearLip,headBoardBox[y]-2*boxPly,0],
	 	[boxPly,headBoardBox[y]-2*boxPly,0],
		[boxPly,boxPly,0],
		[bottomBoxHeight-2*boxPly-spacing,boxPly,0],
		[bottomBoxHeight-2*boxPly-spacing,0,0],
	];

	color(woodColour)
	rotate([0,-angle,0])
	translate([-hingePivot,width-spacing/2,-hingePivot])
	rotate([90,0,0]) {
		union() {
			linear_extrude(width-spacing)
			polyedge(drawPoly);
			EndPlate();
			translate([0,0,width-boxPly-spacing]) EndPlate();
		}
	}
}


//----------------------------------------------------------------------------------------------
// Head Board Box Base Plates
//----------------------------------------------------------------------------------------------

basePlate = [
	[cy,0],
	[0,cx],
	[0,headBoardBox[y]],
	[headBoardBox[x], headBoardBox[y]],
	[headBoardBox[x],0],
];

module BasePlate() {
	linear_extrude(boxPly)
	polygon(basePlate);	
}

//----------------------------------------------------------------------------------------------
// Head Board Top Box
//----------------------------------------------------------------------------------------------

dy = cx/cy*boxPly;

topBoxPoly = [
	[cy,0],
	[0,cx],
	[0,headBoardBox[y]],

	[boxPly,headBoardBox[y]],
	[boxPly, cx+dy],
	[cy+dy,boxPly],

	[headBoardBox[x]-boxPly,boxPly],
	[headBoardBox[x]-boxPly, headBoardBox[y]],

	[headBoardBox[x], headBoardBox[y]],
	[headBoardBox[x],0],
];

module TopBox() {
	color(woodColour6) { 
		linear_extrude(headBoardBox[z]-bottomBoxHeight)
		polygon(topBoxPoly);
		translate([0,0,headBoardBox[z]-bottomBoxHeight]) BasePlate();
	}
}

//----------------------------------------------------------------------------------------------
// Head Board Bottom Box
//----------------------------------------------------------------------------------------------

bottomBoxPoly = [
	[cy,0],
	[0,cx],
	[0,headBoardBox[y]],

	[headBoardBox[x], headBoardBox[y]],
	[headBoardBox[x],0],

	[headBoardBox[x]-boxPly,0],
	[headBoardBox[x]-boxPly, headBoardBox[y]-boxPly],

	[boxPly,headBoardBox[y]-boxPly],
	[boxPly, cx+dy],
	[cy,boxPly],
];

module BottomBox() {
	color(woodColour5) { 
		linear_extrude(bottomBoxHeight)
		polygon(bottomBoxPoly);

		// Add the top and bottom base
		BasePlate();
		translate([0,0,bottomBoxHeight-boxPly]) BasePlate();

		// Add the divider plates
		translate([cy+boxDrawWidth,0,0]) cube([boxPly,headBoardBox[y], bottomBoxHeight]);
		translate([cy+2*(boxDrawWidth)+boxPly,0,0]) cube([boxPly,headBoardBox[y], bottomBoxHeight]);
	}
}

//----------------------------------------------------------------------------------------------
// Head Board Box
//----------------------------------------------------------------------------------------------

module HeadBoardBox(angle) {
	bottomBox = [headBoardBox[x], headBoardBox[y], bottomBoxHeight ];
	topBox = [headBoardBox[x], headBoardBox[y], headBoardBox[z]-bottomBoxHeight ];
	translate([-hingePivot,cy,boxPly+hingePivot]) {
		BoxDraw(boxDrawWidth, angle);
		translate([0,boxDrawWidth+boxPly,0]) BoxDraw(boxDrawWidth, angle);
		translate([0,2*(boxDrawWidth+boxPly),0]) BoxDraw(boxDrawWidth, angle);
	}
	rotate(z90)
	{
		BottomBox();
		translate([0,0,bottomBoxHeight ]) TopBox();
	}
}
