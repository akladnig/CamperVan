function centre(a, b) = (a - b) / 2;

module circle3d(radius, d, colour, backgroundColour) {
	 color(colour) cylinder(h=0.1, r=radius);
	 color(backgroundColour) cylinder(h=0.2, r=radius-d);
}
	
