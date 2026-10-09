-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
local hostname = io.popen("hostname"):read("l")

-- desc: matches by prefix, so this covers any EIZO, not one serial number.
local eizo = {
	output = "desc:Eizo Nanao Corporation",
	mode = "preferred",
	scale = 1.2,
	position = "auto-right",
}
if hostname == "shiina" then
	eizo.mode = "highres"
end
hl.monitor(eizo)

-- Auto positions follow the order monitors are arranged in. Pinning eDP-1 at
-- the origin keeps the EIZO on its right whichever is connected first.
hl.monitor({
	output = "eDP-1",
	mode = "preferred",
	position = "0x0",
	scale = "auto",
})

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto-left",
	scale = "auto",
})
