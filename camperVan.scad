include <constants.scad>
include <materials.scad>
include <van_dimensions.scad>
use <functions.scad>

use <windows.scad>
use <kitchen_bench.scad>
include <cabinets.scad>
use <sofa_bed.scad>
use <tables.scad>
use <appliances.scad>
use <water.scad>
use <electrical.scad>
use <heater.scad>
use <storage.scad>
use <grey_water_tank.scad>

use <kitchen_appliances.scad>
use <draw_dimensions.scad>

/* [Sofa Bed] */
sofaMode = true; // false = bed mode 
showSofaSlats = false;
showSofaCushions = false;
perforatedPanel = true; // false = slat panel
showHeadBoard = true;
rearDrawAngle = 45;

/* [Kitchen] */
showBenchTop = true;
showAppliances = true;
showSplashBack = true;

/* [Cupboard and Draws] */
showCupboardDoors = false;
showBackPanel = false;
openDrawsAndDoors = false;
drawTypeIsBox = true;

/* [Table] */
storeTable = false;
showTable = true;

/* [Fridge] */
fridgeDoorOpen = false;
fridgeRightOpening = false;

/* [Dimensions] */
showExternalDims = true;
showApplianceDims = false;
showKitchenDims = false;
showTableDimensions = false;
showCupboardDimensions = false;

module __Customiser_Limit__() {}

//
// Draw the van base
//

translate([0,0,-step[height]]) color(floorColour) VanBase();

//
// Draw the Windows
// 
WindowFrame();

//
// Draw the furring strips
//  

// for (s = [0:440:vi[x]]) {
//     translate([s,0,0]) cube([40,1760,15]);
// }

//
// Rear angled panel on passenger side
//
// ChampferPanel("left");

//
// Table - mount on unistrut?
// 
if (showTable) {
    if (storeTable || !sofaMode) {
        translate([
            vi[x]-base()[width]-headBoardBox()[y],
            wheelArch[width]+gap+slatDepth,
            base()[height]-slatDepth-ply15
        ])
        Table(showTableDimensions);
    } else {
        translate([
            vi[x]-base()[width]-headBoardBox()[y]-table()[y],
            cladding,
            table()[z]
        ])
        Table(showTableDimensions);
    }
}
railLength = vi[x] - base()[width] - stepOffset - step[x];
echo(railLength=railLength);
color(woodColour)
translate([stepOffset+step[x],cladding,table()[z]-rail[x]])
cube([railLength,rail[y],rail[x]]);

//----------------------------------------------------------------------------------------------
// Kitchen
//----------------------------------------------------------------------------------------------
 
translate([frontSeatOffset, vi[y]-bench[y]-lip-cladding,0])
Kitchen(
    showCupboardDoors,
    openDrawsAndDoors,
    showBenchTop,
    showSplashBack,
    showAppliances,
    showBackPanel,
    showCupboardDimensions,
    drawTypeIsBox,
    fridgeDoorOpen,
    fridgeRightOpening
);

//----------------------------------------------------------------------------------------------
// CupBoard modules
//----------------------------------------------------------------------------------------------
 
InternalSlidingDoorCupboard(showCupboardDoors, openDrawsAndDoors, showBackPanel);
RearmostCupboard(showCupboardDoors, showBackPanel);

// Panel on side of bed - needs to be robust to support bed
translate([vi[x]-base()[width], base()[length]+cladding, 0]) {
    // color(woodColour5)
    color("red")
    cube([base()[width], panelThickness, base()[height]-slatDepth]);
}

//----------------------------------------------------------------------------------------------
// Lagun Table
//----------------------------------------------------------------------------------------------

if (storeTable) {
    translate([frontSeatOffset-ply15,vi[y]-cladding-lagunTable()[y],0]) rotate([90,0,0]) rotate([0,90,0]) LagunTable(showTableDimensions);
} else {
    translate([frontSeatOffset,vi[y]-cladding-bench()[width]-lagunTable()[x]-lip,lagunTable()[z]]) LagunTable(showTableDimensions);
}

//----------------------------------------------------------------------------------------------
// Sofa Bed placement
//----------------------------------------------------------------------------------------------

translate([sofaBedOffset[x],cladding,0]) {
    SofaBed(sofaMode, perforatedPanel, showSofaSlats);
    SofaBedCushions(sofaMode, showSofaCushions);
}

//----------------------------------------------------------------------------------------------
// HeadBoard Box
//----------------------------------------------------------------------------------------------

if (showHeadBoard) {
    translate([vi[x],cladding,base()[z]-slatDepth]) HeadBoardBox(rearDrawAngle);
}

// Couch rail bolted to side of van - use unistrut plus a support plate or just a support plate?
color(woodColour)
translate([stepOffset+step[length],cladding,base()[height]-slatWidth-slatDepth])
cube([vi[x]-stepOffset-step[length], slatDepth, slatWidth]);

// Second short rail bolted to cupboard
color(woodColour)
translate([sofaBedOffset[x],base()[length]-slatDepth+cladding,base()[height]-slatWidth-slatDepth])
cube([base()[width], slatDepth, slatWidth]);

//----------------------------------------------------------------------------------------------
// Toilet, Shower and Water Tank Placement
//----------------------------------------------------------------------------------------------

// WaterTank
waterTankPanelOffset = vi[x]-wheelArchOffset-tank()[x]-gap;
translate([
    waterTankPanelOffset,
    vi[y] - tank()[width] - gap,
    0
])
WaterTank();

// Hot Water Tank
translate([panelInnerOffset[wa]+hotWater()[y],vi[y]-hotWater()[x]-cladding,0])
rotate(z90)
HotWater();

// Shower
translate([
    panelOffset[vr],
    vi[y]-cladding-cx,
    hotWater()[z]+30
])
rotate(x90) rotate(z90)
Shower();

//----------------------------------------------------------------------------------------------
// Electrics
//----------------------------------------------------------------------------------------------

// Battery
echo(batteryBox=batteryBox());

translate([
    // sofaBedOffset[x] + 2*slatDepth,
    sofaBedOffset[x] + 50,
    wheelArch[z]+2*gap+slatDepth,
    0
]) 
translate([batteryBox("long")[width],0,0]) rotate([0,0,90]) BatteryBox("long");

translate([
    panelInnerOffset[be],
    vi[y]-cladding-inverter()[y],
    tankShelfHeight()+shelfPly,
]) color("green")
// rotate([90,0,0]) Inverter();
rotate([0,0,0]) Inverter();

//----------------------------------------------------------------------------------------------
// Rear under sofabed storage
//----------------------------------------------------------------------------------------------

// Packs

xoff=vi[x]-pack("overland")[y]-cx/2+15;
yoff=pack("overland")[z]+cladding+cy/2-15;
zoff=pack("overland")[x];

translate([xoff,yoff,zoff]) rotate([90,90,0]) Pack(model="overland");
translate([xoff-pack("overland")[y]-spacing,yoff,zoff]) rotate([90,90,0]) Pack(model="overland");

// Toilet placement
translate([vi[x], base()[width]-3*slatDepth-cladding+toilet()[width]-toilet()[length],0]) {
    rotate([0,0,90]) Toilet();
}

//
// Floor Filler
//
color(woodColour) translate([stepOffset+doorOpening,0,-floorPly]) DoorFill();

//----------------------------------------------------------------------------------------------
// Kitchen Appliances
//----------------------------------------------------------------------------------------------

translate([panelInnerOffset[2]+airFryer()[y], cupboardFace,tankShelfHeight()+shelfPly]) rotate(z90) AirFryer();

echo(cupboardWidth=cupboardWidth);

if (showAppliances) {

    filter = "single";

    translate([panelOffset[4]+2*clearance,vi[y]-cladding,hotWater()[z]])
    {
    	// Pump
    	Pump();

    	// Strainer
    	translate([
    		pump()[x]-pumpInlet()[x]+strainer()[x]/2,
    		pumpInlet()[y],
    		pumpInlet()[z]
    	])
    	Strainer();
    }
}

//----------------------------------------------------------------------------------------------
// Grey Water Tank
//----------------------------------------------------------------------------------------------

translate([wheelArchFront-greyWaterTank()[x],vi[y]-greyWaterTank()[y],-greyWaterTank()[z]]) GreyWaterTank();

//----------------------------------------------------------------------------------------------
// Show Dimensions
//----------------------------------------------------------------------------------------------
 
Dimensions();
