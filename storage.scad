overland60 = [290,220,760];
wollemi90 = [340,240,820];

function pack(model) = model=="overland" ? overland60 : wollemi90;

module Pack(model) {
	if (model == "overland") {
		color("white") cube(overland60);
	} else {
		color("white") cube(wollemi90);
	}
}


module Pillow() {
	
}
