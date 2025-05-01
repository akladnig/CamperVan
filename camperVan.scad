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
angle = 45;

/* [Kitchen] */
showBenchTop = true;
showAppliances = true;

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

module __Customiser_Limit__() {}

//
// Draw the van base
//

translate([0,0,-step[height]]) color(floorColour) VanBase();

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
            vi[x]-base()[width]-headBoardBox()[y]-tableWidth,
            cladding,
            tableHeight
        ])
        Table(showTableDimensions);
    }
}
railLength = vi[x] - base()[width] - stepOffset - step[x];
echo(railLength=railLength);
color(woodColour)
translate([stepOffset+step[x],cladding,tableHeight-rail[x]])
cube([railLength,rail[y],rail[x]]);

//
// Kitchen
// 
translate([frontSeatOffset, vi[y]-bench[y]-lip-cladding,0])
Kitchen(
    showCupboardDoors,
    openDrawsAndDoors,
    showBenchTop,
    showAppliances,
    showBackPanel,
    drawTypeIsBox,
    fridgeDoorOpen,
    fridgeRightOpening
);

//
// CupBoard
// 
Cupboard(showCupboardDoors, showBackPanel);

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
    translate([frontSeatOffset,vi[y]-cladding-bench()[width]-lagunTable()[x]-lip,lagunTable()[z]]) LagunTable(showTableDimensions);
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
translate([vi[x],cladding,base()[z]-slatDepth]) HeadBoardBox(angle);

// Couch rail bolted to side of van - use unistrut plus a support plate or just a support plate?
color(woodColour)
translate([stepOffset+step[length],cladding,base()[height]-slatWidth-slatDepth])
cube([vi[x]-stepOffset-step[length], slatDepth, slatWidth]);

// Second short rail bolted to cupboard
color(woodColour)
translate([sofaBedOffset[x],base()[length]-slatDepth+cladding,base()[height]-slatWidth-slatDepth])
cube([base()[width], slatDepth, slatWidth]);

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

// Hot Water Tank
translate([panelInnerOffset[wa]+hotWater()[y],vi[y]-hotWater()[x]-cladding-clearance,0])
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

//
// Electrics
//

// Battery
echo(batteryBox=batteryBox());

translate([
    // sofaBedOffset[x] + 2*slatDepth,
    sofaBedOffset[x] + 50,
    wheelArch[z]+2*gap+slatDepth,
    0
]) 
translate([batteryBox()[width],0,0]) rotate([0,0,90]) BatteryBox();

translate([
    panelInnerOffset[be],
    vi[y]-cladding-inverter()[y],
    tankShelfHeight()+shelfPly,
]) color("green") Inverter();

// translate([
//     panelInnerOffset[be],
//     vi[y]-cladding-dcdc()[y],
//     tankShelfHeight()+2*shelfPly+inverter()[z],
// ]) color("blue") DcDc("IP67");

// translate([
//     panelInnerOffset[be],
//     vi[y]-cladding-dcdc()[y],
//     tankShelfHeight()+2*shelfPly+inverter()[z]+gap,
// ]) color("blue") DcDc("DCDC20A");

// Packs

xoff=vi[x]-pack("overland")[y]-cx/2+15;
yoff=pack("overland")[z]+cladding+cy/2-15;
zoff=pack("overland")[x];

translate([xoff,yoff,zoff]) rotate([90,90,0]) Pack(model="overland");
translate([xoff-pack("overland")[y]-spacing,yoff,zoff]) rotate([90,90,0]) Pack(model="overland");

//
// Heater
//
// translate([stepOffset+step[x]-heater()[x],290-heater()[y],-step[z]]) Heater("separated");
// translate([panel2+hotWater()[y]+heater()[y],vi[y]-heater()[x],0]) rotate([0,0,90])
// Heater("separated");
translate([heater()[y],vi[y]-heater()[x],0]) rotate([0,0,90])
Heater("vertical");
echo(panel2=panel2);

// Show Dimensions
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

//
// Air Compressor
//
translate([stepOffset+step[x]-clearance,step[y],-step[z]])
rotate([0,0,180]) AirCompressor();
