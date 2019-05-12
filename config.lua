local ratio = display.pixelHeight/display.pixelWidth

application =
{
	content =
	{
		width = 540,
		--height = 960,
		height = 540*ratio,
		scale = "letterbox",
		fps = 60,
	},
}
