local monitors = require("monitors")

local SUB = "sub"

local M = { main = nil, sub = nil }

local function matches(mon, selector)
	local desc = selector:match("^desc:(.*)$")
	if desc then
		return mon.description:sub(1, #desc) == desc
	end
	return mon.name == selector
end

local function resolve()
	local connected = {}
	for _, mon in ipairs(hl.get_monitors()) do
		if not mon.is_mirror then
			table.insert(connected, mon)
		end
	end

	local main
	for _, selector in ipairs(monitors.main_priority) do
		for _, mon in ipairs(connected) do
			if matches(mon, selector) then
				main = mon
				break
			end
		end
		if main then
			break
		end
	end
	main = main or connected[1]

	for _, mon in ipairs(connected) do
		if mon.name ~= main.name then
			return main.name, mon.name
		end
	end
	return main.name, nil
end

local function restart_waybar(output)
	local home = os.getenv("HOME")
	local path = os.getenv("XDG_RUNTIME_DIR") .. "/waybar-config.jsonc"
	local f = assert(io.open(path, "w"))
	f:write(string.format('{ "output": %q, "include": [%q] }\n', output, home .. "/.config/waybar/config.jsonc"))
	f:close()
	hl.exec_cmd(string.format("pkill -x waybar; waybar -c %s -s %s/.config/waybar/style.css", path, home))
end

function M.apply()
	M.main, M.sub = resolve()

	for _, ws in ipairs(hl.get_workspaces()) do
		if not ws.special and ws.name ~= SUB and ws.monitor and ws.monitor.name ~= M.main then
			hl.dispatch(hl.dsp.workspace.move({ workspace = "name:" .. ws.name, monitor = M.main }))
		end
	end

	if M.sub then
		hl.dispatch(hl.dsp.focus({ monitor = M.sub }))
		if hl.get_workspace("name:" .. SUB) then
			hl.dispatch(hl.dsp.workspace.move({ workspace = "name:" .. SUB, monitor = M.sub }))
		end
		hl.dispatch(hl.dsp.focus({ workspace = "name:" .. SUB }))
	end
	hl.dispatch(hl.dsp.focus({ monitor = M.main }))

	restart_waybar(M.main)
end

-- Focusing main first keeps new workspaces from being created on sub.
function M.focus_workspace(name)
	if M.main then
		hl.dispatch(hl.dsp.focus({ monitor = M.main }))
	end
	hl.dispatch(hl.dsp.focus({ workspace = "name:" .. name }))
end

function M.move_window(name)
	hl.dispatch(hl.dsp.window.move({ workspace = "name:" .. name, follow = false }))
	local ws = hl.get_workspace("name:" .. name)
	if M.main and ws and ws.monitor and ws.monitor.name ~= M.main then
		hl.dispatch(hl.dsp.workspace.move({ workspace = "name:" .. name, monitor = M.main }))
	end
end

function M.focus_sub()
	if M.sub then
		hl.dispatch(hl.dsp.focus({ monitor = M.sub }))
	else
		hl.dispatch(hl.dsp.focus({ workspace = "name:" .. SUB }))
	end
end

function M.move_window_to_sub()
	hl.dispatch(hl.dsp.window.move({ workspace = "name:" .. SUB, follow = false }))
end

return M
