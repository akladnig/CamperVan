include <dimlines.scad>
include <materials.scad>
include <van_dimensions.scad>

use <sofa_bed.scad>
include <kitchen_bench.scad>
use <appliances.scad>
include <cabinets.scad>
use <electrical.scad>

module Dimensions() {
	//
	// X axis dimensions - passenger
	// 
	color("white") {
	  // Internal Van length
		dim_dimension(length=vanInternal[length], weight=$weight, offset=-200);
	  // Internal bed mode space
	  dim_dimension(length=vanInternal[length]-mattress()[length], weight=$weight, offset=-100);
	  // Internal sofa mode space
	  dim_dimension(length=vanInternal[length]-base()[width], weight=$weight, offset=-150);
	  // Rear Storage space to wheel arch
	  translate([vanInternal[length]-wheelArchOffset,0]) dim_dimension(length=wheelArchOffset, weight=$weight, offset=-100);
	}

	//
	// X axis dimensions - driver
	// 
	color("white") translate([0,vanInternal[width],0]) {
	  // Internal Van length
	  dim_dimension(length=vanInternal[length], weight=$weight, offset=200);
	  // Bench offset
	  dim_dimension(length=frontSeatOffset, weight=$weight, offset=100);
	  // Kitchen Bench
	  translate([frontSeatOffset,0,0]) dim_dimension(length=bench[length], weight=$weight, offset=100);
	  // Rear cupboard
	  offset = vanInternal[length]-frontSeatOffset-bench[length];
	  translate([frontSeatOffset+bench[length],0,0]) dim_dimension(length=offset, weight=$weight, offset=100);
	}

	//
	// Y axis dimensions - back end
	// 
	color("white") translate([vanInternal[length],0,0]) rotate([0,0,90]) {
	  // Internal Van width
	  dim_dimension(length=vanInternal[width], weight=$weight, offset=-200);
	  // Cupboard width
	  translate([vanInternal[width]-cladding-cupboard[width],0,0])
	  dim_dimension(length=cupboard[width], weight=$weight, offset=-100);
	  // Space between cupboard and sofa bed
	  translate([cladding+base()[length]+slatDepth,0,0])
	  dim_dimension(length=vanInternal[width]-2*cladding-cupboard[width]-base()[length]-slatDepth, weight=$weight, offset=-100, loc="left");
	  // Storage Space
	  translate([cladding,0,0]) dim_dimension(length=base()[length]-2*slatDepth-toilet()[length], weight=$weight, offset=-100);
	}
}
