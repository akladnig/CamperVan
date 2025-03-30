include <van_dimensions.scad>
include <materials.scad>

// Double Bed
bedLength = 1880;
bedWidth = 1240;

// Matresses
clarkRubberComfortDeluxe = [1880, 1220, 100]; 
clarkRubber = 142; 
newentor = 220;

mattress= clarkRubberComfortDeluxe;

// Couch
// Is made from mattress and cut into 3x pieces
// Back rest angle 100-110 degrees
// angle = 70; 
// 
// Build a test frame using a single slat to confirm lengths and operation
// 
seatWidth  = 553.5-hingeClosed[z]/2; // - hinge depths
seatHeight = 460;
backShelf = 100;
angle = 14;

base = [bedWidth,850,seatHeight-mattress[height]];

function base() = base;

x1 = slatDepth*cos(angle);
w = base[width] - seatWidth - backShelf;
x2 = w - x1 - slatDepth - 3*hingeClosed[z];

backrest = x2/sin(angle)-hingeClosed[z];

rearSupport = mattress[length] -seatWidth -backrest -backShelf-3*hingeClosed[z];

function mattress() = mattress;

// 850 + 142 + 19 + 50 = 1061
function sofaBedWidth() = base[width] + mattress[height] + slatDepth + rearDoorClearance;


module sofaBed(sofaMode, perforatedPanel, showPanels) {
	// supportFrame();
	module sofaBedPanel(perforatedPanel, panelWidth) {
		if (perforatedPanel) {
			sofaBedPerforatedPanel(panelWidth);
		} else {
			sofaBedSlatPanel(panelWidth);
		}
	}

	echo(seatWidth=seatWidth, backrest=backrest, rearSupport=rearSupport);

	if (sofaMode) {
		outerSlidingFrame();

		if (showPanels) {
			translate([seatWidth, 0, base[height] - slatDepth]) {
				rotate([0,0, 90])
				sofaBedPanel(perforatedPanel, seatWidth);
			}

			translate([seatWidth+hingeClosed[z],0, base[height]]) {
		    rotate([0,90+angle,0])
		    rotate([0,0,90])
		    sofaBedPanel(perforatedPanel, backrest);
			}

			translate([base[width]-backShelf-slatDepth-hingeClosed[z],0,base[height]]) {
		    rotate([0,90,0])
		    rotate([0,0,90])
				union() {
			    sofaBedPanel(perforatedPanel, rearSupport);
					translate([slatDepth+5,0,-slatDepth])
					color(woodColour) cube([base[length]-2*slatDepth-10,slatWidth,slatDepth]);
				}
			}
	}
	translate([base[width]-backShelf,0,base[height] - slatDepth]) {
		color(woodColour) cube([backShelf, base[length], slatDepth]);
	}

	// Bed Mode
	} else {
		seatOffset = base[width] - rearSupport - backrest - backShelf ;

		translate([seatOffset-seatWidth, 0, 0]) {
			outerSlidingFrame();
		}

		if (showPanels) {
			xOffset =  base[width]-mattress[length];
			translate([xOffset, 0, base[height] - slatDepth]) {
				translate([seatWidth,0,0])
				rotate([0,0, 90])
				sofaBedPanel(perforatedPanel, seatWidth);
			}

			translate([xOffset+seatWidth+hingeClosed[z],0, base[height] - slatDepth]) {
				translate([backrest,0,0])
		    rotate([0,0,90])
		    sofaBedPanel(perforatedPanel, backrest);
			}

			translate([xOffset+seatWidth+backrest+2*hingeClosed[z],0,base[height] - slatDepth]) {
				translate([rearSupport,0,0])
		    rotate([0,0,90])
		    sofaBedPanel(perforatedPanel, rearSupport);
			}
		}
		translate([base[width]-backShelf,0,base[height] - slatDepth]) {
			color(woodColour) cube([backShelf, base[length], slatDepth]);
		}
	}
}

//
// SofaBed Cushions
//
module sofaBedCushions(sofaMode, showCushions) {
	
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
module sofaBedSlatPanel(panelWidth) {
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

module sofaBedPerforatedPanel(panelWidth) {
	radius = 38;
	gap = 15;
	rg = radius + gap;

	n = round((base[length]-2*rg)/2/rg);
	m = round((panelWidth-4*rg)/3.464/rg);

	xoffset = (base[length]-2*n*rg)/2;
	yoffset = (panelWidth - 2*(1+m*1.732)*rg)/2;

	echo(n=n, m=m, xoff=xoffset, yoff=yoffset);

	difference() {
		color(woodColour)
		cube([base[length], panelWidth, slatDepth]);
		for (i = [0:n-1]) {
			for (j = [0:m]) {
				translate([xoffset + rg + i*2*rg,yoffset+rg+j*3.464*rg,-1]) cylinder(h=slatDepth+2,r=radius);
			}
		}
		for (i = [0:n-2]) {
			for (j = [0:m-1]) {
				translate([xoffset + 2*rg + i*2*rg,yoffset+2.732*rg+j*3.464*rg,-1]) cylinder(h=slatDepth+2,r=radius);
			}
		}
	}
}

overhang = 50;

//
// Internal support panel
//
module internalSupport() {

	// Top Support
	translate([slatDepth+overhang,0,base[height]-slatWidth-slatDepth]) {
    color(woodColour5) 
		cube([base[width]-2*slatDepth-overhang, slatDepth, slatWidth]);
	}

	// Bottom Support
	translate([slatWidth+overhang,0,slatDepth]) {
    color(woodColour5) 
		cube([base[width]-2*slatWidth-overhang, slatDepth, slatWidth]);
	}

	// Left Support
	translate([overhang,0,slatDepth]) {
    color(woodColour) 
		cube([slatWidth, slatDepth, base[height]-slatWidth-2*slatDepth]);
	}

	// Right Support
	translate([base[width]-slatWidth,0,slatDepth]) {
    color(woodColour) 
		cube([slatWidth, slatDepth, base[height]-slatWidth-2*slatDepth]);
	}
}

//
// Support frame
//
module supportFrame() {
	
	// OuterFrame
	outerFrameOffset = wheelArch[width]+slatDepth;
	translate([0,outerFrameOffset,0]) {
		internalSupport();
	}

	// MiddleFrame
	middleFrameOffset = (base[length]+wheelArch[width]-slatDepth)/2;
	translate([0,middleFrameOffset ,0]) {
		internalSupport();
	}

	// InnerFrame
	innerFrameOffset = base[length]-2*slatDepth; 
	translate([0,innerFrameOffset,0]) {
		internalSupport();
	}

	frontPlateLength = base[length]-wheelArch[width]-2*slatDepth;
	frontPlateOffset = wheelArch[width]+slatDepth;

	// Front Top Plate
	translate([overhang,frontPlateOffset ,base[height]-slatWidth-slatDepth]) {
		color(woodColour3)
		cube([slatDepth, frontPlateLength , slatWidth]);
	}

	// Rear Top Plate
	translate([base[width]-slatDepth,frontPlateOffset ,base[height]-slatWidth-slatDepth]) {
		color(woodColour3)
		cube([slatDepth, frontPlateLength , slatWidth]);
	}

	// Front Bottom Plate
	translate([overhang,frontPlateOffset ,0]) {
		color(woodColour3)
		cube([slatWidth, frontPlateLength , slatDepth]);
	}

	// Rear Bottom Plate
	translate([base[width]-slatWidth,frontPlateOffset ,0]) {
		color(woodColour3)
		cube([slatWidth, frontPlateLength , slatDepth]);
	}

	sidePlateLength = base[width]-2*slatWidth-overhang;

	// Outer frame bottom plate
	translate([slatWidth+overhang,outerFrameOffset,0]) {
		color(woodColour6)
		cube([sidePlateLength, slatWidth, slatDepth]);
	}

	// Middle frame bottom plate
	translate([slatWidth+overhang,middleFrameOffset-slatWidth/2+slatDepth/2,0]) {
		color(woodColour6)
		cube([sidePlateLength, slatWidth, slatDepth]);
	}

	// Inner frame bottom plate
	translate([slatWidth+overhang,innerFrameOffset-slatWidth+slatDepth,0]) {
		color(woodColour6)
		cube([sidePlateLength, slatWidth, slatDepth]);
	}

}

//
// Outer Sliding Support frame
//
module outerSlidingSupport() {

	supportX = base[width]-wheelArchOffset-2*slatWidth-slatDepth-overhang;
	offsetX = supportX+overhang+slatWidth;

	// Top Support
	translate([overhang,0,base[height]-slatWidth-slatDepth]) {
    color(woodColour) 
		cube([base[width]-wheelArchOffset-slatWidth, slatDepth, slatWidth]);
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
module innerSlidingSupport() {

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
module outerSlidingFrame() {
	
	// OuterFrame
	translate([0,wheelArch[width],0]) {
		outerSlidingSupport();
	}

	// InnerFrame
	translate([0,base[length]-2*slatDepth,0]) {
		innerSlidingSupport();
	}

	// Front Top Plate
	translate([overhang-slatDepth,wheelArch[width]+legWidth,base[height]-slatWidth-slatDepth-ply15-spacing]) {
    color(woodColour6) 
		cube([slatDepth, base[length]-wheelArch[width]-2*legWidth-slatDepth, slatWidth]);
	}

	// Front Legs
	translate([overhang-slatDepth,wheelArch[width],0]) {
    color(woodColour2) 
		cube([slatDepth, legWidth, base[height]-slatDepth]);
	}

	translate([overhang-slatDepth,base[length]-legWidth-slatDepth,0]) {
    color(woodColour2) 
		cube([slatDepth, legWidth, base[height]-slatDepth]);
	}
}

