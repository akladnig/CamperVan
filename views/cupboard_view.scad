include <../cabinets.scad>

use <../water.scad>
use <../electrical.scad>

/* [Cupboard and Draws] */
showCupboardDoors = false;
showBackPanel = false;
openDrawsAndDoors = false;

//
// CupBoard
// 
InternalSlidingDoorCupboard(showCupboardDoors, openDrawsAndDoors, showBackPanel);
RearmostCupboard(showCupboardDoors, showBackPanel);

