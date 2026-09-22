-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
local hostname = io.popen("hostname"):read("l")

-- Earlier entries win the main role; any other connected monitor becomes sub.
local main_priority = {}

if hostname == "shiina" then
	hl.monitor({
		output = "desc:Eizo Nanao Corporation EV3285 0x022E6D7F",
		mode = "highres",
		scale = 1.2,
		position = "auto-right",
	})
	hl.monitor({
		output = "eDP-1",
		mode = "preferred",
		position = "auto",
		scale = "auto",
	})
	main_priority = { "desc:Eizo Nanao Corporation EV3285 0x022E6D7F", "eDP-1" }
end

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto-left",
	scale = "auto",
})

return { main_priority = main_priority }
