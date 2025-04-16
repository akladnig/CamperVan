include <constants.scad>
include <materials.scad>
include <van_dimensions.scad>
use <functions.scad>

use <kitchen_bench.scad>
include <cabinets.scad>
use <sofa_bed.scad>
use <appliances.scad>
use <water.scad>
use <electrical.scad>
use <heater.scad>
use <storage.scad>

use <kitchen_appliances.scad>
use <draw_dimensions.scad>

/* [Sofa Bed] */
sofaMode = true; // false = bed mode 
showSofaSlats = false;
showSofaCushions = false;
perforatedPanel = true; // false = slat panel

/* [Kitchen] */
showBenchTop = true;

/* [Cupboard and Draws] */
showCupboardDoors = false;

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

module __Customiser_Limit__() {}

//
// Draw the van base
//
// 
translate([0,0,-step[height]]) color(floorColour) VanBase();

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
        vi[x]-base()[width]-headBoardBox()[y]-tableWidth,
        cladding,
        tableHeight
    ])
    Table(showTableDimensions);
}
}
railLength = vi[x] - base()[width] - stepOffset - step[x];
echo(railLength=railLength);
translate([stepOffset+step[x],cladding,tableHeight-rail[x]]) cube([railLength,rail[y],rail[x]]);

//
// Kitchen
// 
translate([frontSeatOffset, vi[y]-bench[y]-lip-cladding,0])
Kitchen(showCupboardDoors, showBenchTop, fridgeDoorOpen, fridgeRightOpening);

//
// CupBoard
// 
Cupboard(showCupboardDoors);

// Panel on side of bed - needs to be robust to support bed
translate([vi[x]-base()[width], base()[length]+cladding, 0]) {
    color(woodColour5)
    cube([base()[width], panelThickness, base()[height]-slatDepth]);
}

//
// Lagun Table
//
if (storeTable) {
    translate([frontSeatOffset-ply15,vi[y]-cladding-lagunTable()[y],0]) rotate([90,0,0]) rotate([0,90,0]) LagunTable(showTableDimensions);
} else {
    translate([frontSeatOffset,vi[y]-cladding-bench()[width]-lagunTable()[x]-lip,tableHeight]) LagunTable(showTableDimensions);
}

//
// Sofa Bed placement
//
translate([sofaBedOffset[x],cladding,0]) {
    SofaBed(sofaMode, perforatedPanel, showSofaSlats);
    SofaBedCushions(sofaMode, showSofaCushions);
}

//
// HeadBoard Box
//
translate([vi[x],cladding,base()[z]-slatDepth]) HeadBoardBox();

// Couch rail bolted to side of van - use unistrut plus a support plate or just a support plate?
translate([stepOffset+step[length],cladding,base()[height]-slatWidth-slatDepth]) cube([vi[x]-stepOffset-step[length], slatDepth, slatWidth]);

// Second short rail bolted to cupboard
translate([sofaBedOffset[x],base()[length]-slatDepth+cladding,base()[height]-slatWidth-slatDepth]) cube([base()[width], slatDepth, slatWidth]);

//
// Toilet, Shower and Water Tank Placement
// 

// Toilet placement
translate([vi[x], base()[width]-3*slatDepth-cladding+toilet()[width]-toilet()[length],0]) {
    rotate([0,0,90]) Toilet();
}

// WaterTank
waterTankPanelOffset = vi[x]-wheelArchOffset-tank()[x]-gap;
translate([
    waterTankPanelOffset,
    vi[y] - tank()[width] - gap,
    0
])
WaterTank();

// Pump
translate([panelInnerOffset[wa], vi[y]-cladding-hotWater()[y]-30-pump()[y], 0])
 Pump();

// Water Filter
// Filter("twin");

// Hot Water
translate([panelInnerOffset[wa],vi[y]-hotWater()[y]-cladding-30,0]) HotWater();

//
// Electrics
//

// Battery
qty = 2;
echo(batteryBox=batteryBox(qty));

translate([
    // sofaBedOffset[x] + 2*slatDepth,
    sofaBedOffset[x] + 50 - slatDepth,
    base()[length]+cladding-slatDepth-legWidth-batteryBox(qty)[length],
    0
]) 
translate([batteryBox(qty)[width],0,0]) rotate([0,0,90]) BatteryBox(qty);

translate([
    panelInnerOffset[be],
    vi[y]-cladding-inverter()[y],
    tankShelfHeight()+shelfPly,
]) color("green") Inverter();

translate([
    panelInnerOffset[be],
    vi[y]-cladding-dcdc()[y],
    tankShelfHeight()+2*shelfPly+inverter()[z],
]) color("blue") DcDc("IP67");

// Packs

xoff=vi[x]-pack("overland")[y];
yoff=pack("overland")[z]+cladding;
zoff=pack("overland")[x];

translate([xoff,yoff,zoff]) rotate([90,90,0]) Pack(model="overland");
translate([xoff-pack("overland")[y],yoff,zoff]) rotate([90,90,0]) Pack(model="overland");

//
// Heater
//
translate([stepOffset+step[x]-heater()[x],290-heater()[y],-step[z]]) Heater("separated");
// translate([panel2+hotWater()[y]+heater()[y],vi[y]-heater()[x],0]) rotate([0,0,90])
// Heater("separated");
translate([heater()[y],vi[y]-heater()[x],0]) rotate([0,0,90])
Heater("vertical");
echo(panel2=panel2);
Dimensions();

//
// Floor Filler
//
color(woodColour) translate([stepOffset+doorOpening,0,-floorPly]) DoorFill();

//
// Kitchen Appliances
//
translate([panelInnerOffset[2], cupboardFace,tankShelfHeight()+shelfPly]) AirFryer();

echo(cupboardWidth=cupboardWidth);
