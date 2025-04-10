include <constants.scad>
include <materials.scad>
include <van_dimensions.scad>

use <appliances.scad>
use <water.scad>

//
// Kitchen Bench Height
// 
benchHeight = 900;

cupboard = [600, 480, vanInternal[height]];
function cupboard() = cupboard;

kitchenCupboardWidth = 460;

panel1 = frontSeatOffset+framingPly+panelPly;
panel2 = panel1 + panelPly+framingPly + gap + fridge()[x] + gap + framingPly;
