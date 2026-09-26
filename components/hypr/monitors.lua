-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
local hostname = io.popen("hostname"):read("l")

if hostname == "shiina" then
	local EIZO = "desc:Eizo Nanao Corporation EV3285 0x022E6D7F"
	hl.monitor({
		output = EIZO,
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
end

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto-left",
	scale = "auto",
})
