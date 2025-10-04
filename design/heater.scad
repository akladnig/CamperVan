vevor2kwSeparated = [340,115,140];
vevor2kwVertical = [380,150,410];
vevor5kw = [375,140,175];
vevor8kw = [375,140,175];

function heater(model) = model == "vertical" ? vevor2kwVertical : vevor2kwSeparated;

module Heater(model) {
	color("orange")
	if (model=="vertical") {
		cube(vevor2kwVertical);
	} else {
		cube(vevor2kwSeparated);
	}
}
