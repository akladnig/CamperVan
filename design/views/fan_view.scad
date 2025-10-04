use <../electrical.scad>
use <../fan_duct2.scad>

// Fan();
// translate([60,0,0]) Fan();

TwinFanDuct();

translate([150, 0, 0]) ConeIntersect();

translate([170, 0, 0]) ScrewWall(0, 0);

// translate([200,0,0]) TopCone();
translate([200, 0, 0]) Duct40mmCoupler();
