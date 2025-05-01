use <../kitchen_bench.scad>
include <../cabinets.scad>

include <../constants.scad>
include <../materials.scad>
include <../van_dimensions.scad>
include <../common_dimensions.scad>
use <../functions.scad>

use <../kitchen_appliances.scad>

/* [Kitchen] */
showBenchTop = true;
showAppliances = true;

/* [Cupboard and Draws] */
showCupboardDoors = false;

/* [Fridge] */
fridgeDoorOpen = false;
fridgeRightOpening = false;

module __Customiser_Limit__() {}

//
// Kitchen
// 
translate([frontSeatOffset, vi[y]-bench[y]-lip-cladding,0])
Kitchen(showCupboardDoors, showBenchTop, showAppliances, fridgeDoorOpen, fridgeRightOpening);

