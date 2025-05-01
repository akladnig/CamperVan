use <panels.scad>

rotate([0,0,-90]) FridgeLeftPanel();
translate([600,0,0]) rotate([0,0,-90]) FridgeRightPanel();

translate([1200,0,0]) HorizontalPlate(500);
translate([1800,0,0]) VerticalPlate(500);
