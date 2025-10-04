include <../constants.scad>
include <../materials.scad>
include <../common_dimensions.scad>
include <../van_dimensions.scad>
use <../functions.scad>

use <../sofa_bed.scad>
/* [Sofa Bed] */
sofaMode = true; // false = bed mode 
showSofaSlats = false;
showSofaCushions = false;
perforatedPanel = true; // false = slat panel
showHeadBoard = true;
rearDrawAngle = 45;

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

