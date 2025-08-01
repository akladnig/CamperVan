include <constants.scad>
include <materials.scad>
include <van_dimensions.scad>

use <appliances.scad>

gap = 10; // gap between appliances and panels
spacing = 2; // spacing between doors/draws and cupboard panels
lip = 10; // lip over benchtop
clearance = 50; // General clearance between things

shelfLipHeight = 75;
drawSetback = 50;

//
// Custom Tank - the width of the L shape
//
tankL = 350;

//
// Sofa Bed
//
seatHeight = 460;
baseWidth = 850;
// headBoardBoxWidth = 150;
headBoardBoxWidth = 200;

sofaBedWidth = baseWidth+headBoardBoxWidth;
sofaBedOffset = [vi[x]-sofaBedWidth,0];

//
// Kitchen cupboard width calculations based on a 50mm clearance from the end of the bench
// and the sofa which will effectively set the bench length.
//
// benchHeight = 900;
benchHeight = 850;
benchLength = sofaBedOffset[x]-clearance-frontSeatOffset;
bench = [benchLength, fridge()[y]-50,benchHeight];

function bench() = bench;

fridgeCupboardWidth = fridge()[x]+2*gap; 

// Calculate the width of the 2x kitchen cupboards
totalCupboardsWidth = vi[x] - frontSeatOffset - panelThickness - fridgeCupboardWidth -panelThickness - sofaBedWidth - clearance - panelThickness;
kitchenCupboardWidth = floor((totalCupboardsWidth-panelThickness)/2);


//
// Panel offsets from front on front side edge of panel
//
fl = 0;
fr = 1;
km = 2;
be = 3;
wa = 4;
vr = 5;

panel1 = frontSeatOffset + panelThickness + fridgeCupboardWidth;
panel2 = panel1 + panelThickness + kitchenCupboardWidth;

panelOffset = [
	frontSeatOffset, // Fridge Left
	panel1, // Fridge Right
	panel2, // Kitchen Middle
	sofaBedOffset[x]-clearance-panelThickness, // Bench End
	wheelArchRear, // Rear of Wheel Arch
	vi[x], // Rear of Van
];

//
// Panel offsets from front on inside or back edge of panel
//
panelIdentity = [1,1,1,1,1,1];
panelInnerOffset = panelOffset + panelThickness*panelIdentity;

//
// Cupboard Internal Widths from front to back of Van
//
fridge = 0;
LHKitchen = 1;
RHKitchen = 2;
clothes = 3;
end = 4;
wtank = 5;

cupboardWidth = [
	fridgeCupboardWidth, // Fridge Cupboard
	kitchenCupboardWidth, // LH Kitchen Cupboard
	kitchenCupboardWidth, // RH Kitchen Cupboard
	panelOffset[wa]-panelInnerOffset[be], // Clothes Cupboard
	vi[x] - panelInnerOffset[wa], // End Cupboard
	panelOffset[wa]-panelInnerOffset[fr]-wheelArch[x]-tankL-2*gap-panelThickness // Water Tank Cupboard
];

//
// Cupboard Width and Height
// 

cupboard = [600, 400, vanInternal[height]];
function cupboard() = cupboard;

cupboardFace = vi[y]-cladding-cupboard[y];

