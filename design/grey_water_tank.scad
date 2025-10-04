greyWaterTankPoly = [
	[0,0],
	[0,180],
	[50,240],
	[950,240],
	[950,130],
	[895,130],
	[805,0]
	];

function greyWaterTank() = [950,240,220];

greyWaterTankArea = 950*240 - 180*50/2 - 55*130 - 130*90;

function greyWaterTankVolume() = greyWaterTankArea * 220 / 1000 / 1000;

module GreyWaterTank() {
	linear_extrude(220) polygon(greyWaterTankPoly);
}
