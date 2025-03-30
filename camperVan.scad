include <dimlines.scad>
include <constants.scad>
include <materials.scad>
include <van_dimensions.scad>

use <functions.scad>
use <sofa_bed.scad>
use <appliances.scad>
include <cabinets.scad>
use <electrical.scad>

sofaMode = true; // false = bed mode 
showSofaSlats = false;
showSofaCushions = false;
showCupboardDoors = false;
perforatedPanel = true; // false = slat panel
storeTable = false;
doorOpen = false;
rightOpening = false;
plyMm = ply15;

module __Customiser_Limit__() {}

translate([0,0,-step[height]]) color(floorColour) VanBase();

//
// Table - mount on unistrut?
// 
if (storeTable) {
    translate([vi[x]-base()[width],wheelArch[width]+gap+slatDepth,base()[height]-slatDepth-ply15]) Table();
} else {
    translate([vi[x]-base()[width]-table[x],0,tableHeight]) Table();
}

// Kitchen Bench
// width = 366 + 50 + 50 + 15 = 481
cupboard = [600, 480, vanInternal[height]];

fridgeCupboard = 500;
cupboardWidth = 500;

bench = [
    lip + plyMm  + gap + fridge()[x] + gap + plyMm + cupboardWidth + plyMm + cupboardWidth,
    500,
    900
];

benchChampfer = bench[y] - cupboard[y];
benchNarrow = [bench[x], bench[y]-benchChampfer, 900];

champfer = bench[y] - cupboard[y];

kitchenBench = [bench[length], bench[width]+lip, plyMm];
 
sinkBenchWidth = lip+plyMm+gap+fridge()[x]+gap+plyMm+lip;
kitchenPoly = [
    [0,0],
    [0, bench[width]+lip],
    [bench[length],bench[width]+lip],
    [bench[length],benchChampfer],
    [sinkBenchWidth+benchChampfer,benchChampfer], // create a champfer
    [sinkBenchWidth,0],
];

backingBoard = [bench[x], plyMm, 100];

hobs = 1;

// Kitchen 
translate([frontSeatOffset, vanInternal[width]-kitchenBench[width]-cladding,0]) {
    color(benchColour)

    // Cutout sink and hob then insert
    difference() {
        translate([0,0,bench[height]-plyMm]) {
            color(benchColour)
            linear_extrude(ply18)
            polygon(kitchenPoly);
        }
        translate([centre(sinkBenchWidth,sink()[length]),50, bench[height]-plyMm]) {
            SinkCutout();
        }
        translate([sinkBenchWidth+50,champfer+50,bench[height]-plyMm]) {
            rotate([0,0,0]) HobCutout();            
        }
    }
    translate([centre(sinkBenchWidth,sink()[length]),50,bench[height] - sink()[height]+5]) Sink();

    translate([sinkBenchWidth+50,champfer+50,bench[height] - hob()[height]+5]) {
        translate([0,0,0])
        Hob(1);
    }

    // translate([50,50,bench[height]+5]) SinkCover();

    // Add a backing board
        translate([0,kitchenBench[width]-plyMm,bench[height]]) color(benchColour) cube(backingBoard);
    
    // Left side panel
    translate([gap,lip,0])
        color(woodColour) cube([plyMm, bench[width], bench[height]-plyMm]);

    // Fridge cover panel
    if (showCupboardDoors) {
    translate([plyMm+gap+spacing,lip,fridge()[height]+gap]) color(woodColour)
    cube([
        fridge()[x]+2*gap-2*spacing,
        plyMm,
        bench[height]-plyMm-spacing-gap-fridge()[height]]);
    }
    // Right side fridge panel
    RHSPanel =  sinkBenchWidth-gap-plyMm;

    translate([RHSPanel,lip,0])
        color(woodColour) cube([plyMm, bench[width], bench[height]-plyMm]);

    // Add a support strip to the left side
    translate([RHSPanel+plyMm,champfer+lip+plyMm,tank()[height]+tankGap()[z]+plyMm])
        color(woodColour5) cube([plyMm, 50, bench[height]-plyMm-tank()[height]-tankGap()[z]]);
    
    translate([RHSPanel+plyMm,champfer+lip, bench[height]-plyMm-120-spacing])
    Draw(cupboardWidth, 120, benchNarrow[y], showCupboardDoors);

    // Middle panel
        translate([
            RHSPanel+plyMm+cupboardWidth+plyMm,
            champfer+lip+plyMm,
            tank()[z]+tankGap()[z]+plyMm
        ])
        color(woodColour) cube([
            plyMm,
            cupboard[width]-plyMm,
            bench[height]-tank()[z]-2*plyMm-tankGap()[z]
        ]);

    // Add a support strip to the right side
    translate([RHSPanel+cupboardWidth+plyMm,champfer+lip+plyMm,tank()[height]+tankGap()[z]+plyMm])
        color(woodColour5) cube([plyMm, 50, bench[height]-plyMm-tank()[height]-tankGap()[z]]);

    mp = RHSPanel+centre(bench[length],RHSPanel);
    echo(fridgePanel=RHSPanel, middlePanel=mp);

    // Right side panel
    translate([bench[length],champfer+plyMm,0])
        color(woodColour) cube([plyMm, cupboard[width]+lip-plyMm, vanInternal[height]]);

    // Water Tank top panel
    translate([
        sinkBenchWidth-lip,
        champfer+plyMm,
        tank()[height]+tankGap()[z]
    ])
    color(woodColour3) cube([2*cupboardWidth+plyMm, cupboard[width]+lip-plyMm, plyMm]);

    // Fridge
    // airgap is inlcuded in fridge depth
    airGap = 0;
    translate([gap+plyMm+gap,kitchenBench[width] - fridge()[width] - airGap,0])
    Fridge(doorOpen,rightOpening);
}

// Pullout vertical draw behind driver's seat
frontDraw = [frontSeatOffset,bench[width], 680];
translate([0,vi[width]-frontDraw[width],0]) rotate([0,15,0]) cube([plyMm, frontDraw[width], 1035]);

// cupboard depth =  spacing = 383 + 20 = 403
translate([vanInternal[length]-base()[width], base()[length]+cladding, 0]) {
    color(woodColour)
    cube([base()[width], panelDepth, base()[height]-slatDepth]);
}


// Sofa Bed placement

sbx =  vanInternal[length]- base()[width];
sby = base()[width]+cladding;
translate([sbx,cladding,0]) {
    sofaBed(sofaMode, perforatedPanel, showSofaSlats);
    sofaBedCushions(sofaMode, showSofaCushions);
}

// Couch rail bolted to side of van - use unistrut plus a support plate or just a support plate?
translate([stepOffset+step[length],cladding,base()[height]-slatWidth-slatDepth]) cube([vanInternal[length]-stepOffset-step[length], slatDepth, slatWidth]);

// Second short rail bolted to cupboard
translate([sbx,base()[length]-slatDepth+cladding,base()[height]-slatWidth-slatDepth]) cube([base()[width], slatDepth, slatWidth]);

// Toilet placement
translate([vanInternal[length], base()[width]-3*slatDepth-cladding+toilet()[width]-toilet()[length],0]) {
    rotate([0,0,90]) Toilet();
}

// WaterTank
waterTankPanelOffset = wheelArchFrontOffset - plyMm - cladding;
translate([
    waterTankPanelOffset-tank()[length]-gap,
    vanInternal[width] - tank()[width] - gap,
    0
])
WaterTank();

// Water Tank side panel
translate([
    waterTankPanelOffset,
    vi[y]-cladding-cupboard[width],
    0
])
color(woodColour) cube([plyMm, cupboard[width], tank()[height]+tankGap()[z]]);


// Battery
qty = 1;
echo(battery=battery(qty));

translate([
    sbx + 2*slatDepth,
    base()[length]+cladding-3*slatDepth-battery(qty)[length],
    // cladding+wheelArch[width]+2*slatDepth,
    0
]) 
translate([battery(qty)[width],0,0]) rotate([0,0,90]) Battery(qty);

// Inverter
// translate([
//     frontSeatOffset+bench[x]-inverter()[width],
//     vanInternal[width]-inverter()[height]-cladding,
//     bench[z]-plyMm-inverter()[length]-100
// ]) color("red") rotate([-90,-90,0]) Inverter();

translate([
    sbx + 2*slatDepth+battery(qty)[width],
    base()[length]+cladding-3*slatDepth,
    inverter()[width]
]) color("green") rotate([-90,0,-90]) Inverter();


//
// Draw Dimension lines
// 
$dim_fontsize = 30;
$dim_linewidth = 1;
weight = 5;
//
// X axis dimensions - passenger
// 
color("white") {
    // Internal Van length
     dim_dimension(length=vanInternal[length], weight=weight, offset=-200);
    // Internal bed mode space
    dim_dimension(length=vanInternal[length]-mattress()[length], weight=weight, offset=-100);
    // Internal sofa mode space
    dim_dimension(length=vanInternal[length]-base()[width], weight=weight, offset=-150);
    // Rear Storage space to wheel arch
    translate([vanInternal[length]-wheelArchOffset,0]) dim_dimension(length=wheelArchOffset, weight=weight, offset=-100);
}

//
// X axis dimensions - driver
// 
color("white") translate([0,vanInternal[width],0]) {
    // Internal Van length
    dim_dimension(length=vanInternal[length], weight=weight, offset=200);
    // Bench offset
    dim_dimension(length=frontSeatOffset, weight=weight, offset=100);
    // Kitchen Bench
    translate([frontSeatOffset,0,0]) dim_dimension(length=bench[length], weight=weight, offset=100);
    // Rear cupboard
    offset = vanInternal[length]-frontSeatOffset-bench[length];
    translate([frontSeatOffset+bench[length],0,0]) dim_dimension(length=offset, weight=weight, offset=100);
}

//
// Y axis dimensions - back end
// 
color("white") translate([vanInternal[length],0,0]) rotate([0,0,90]) {
    // Internal Van width
    dim_dimension(length=vanInternal[width], weight=weight, offset=-200);
    // Cupboard width
    translate([vanInternal[width]-cladding-cupboard[width],0,0])
    dim_dimension(length=cupboard[width], weight=weight, offset=-100);
    // Space between cupboard and sofa bed
    translate([cladding+base()[length]+slatDepth,0,0])
    dim_dimension(length=vanInternal[width]-2*cladding-cupboard[width]-base()[length]-slatDepth, weight=weight, offset=-100, loc="left");
    // Storage Space
    translate([cladding,0,0]) dim_dimension(length=base()[length]-2*slatDepth-toilet()[length], weight=weight, offset=-100);
}

