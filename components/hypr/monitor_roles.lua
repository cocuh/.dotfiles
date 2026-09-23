local monitors = require("monitors")

local SUB_WORKSPACE = "sub"

local M = {}

local current = { main = nil, sub = nil }

local function resolve()
	local main
	for _, selector in ipairs(monitors.main_candidates) do
		local mon = hl.get_monitor(selector)
		if mon and not mon.is_mirror then
			main = mon
			break
		end
	end

	local sub
	for _, mon in ipairs(hl.get_monitors()) do
		if not mon.is_mirror then
			main = main or mon
			if mon.name ~= main.name and not sub then
				sub = mon
			end
		end
	end
	return main.name, sub and sub.name
end

local function restart_waybar(output)
	local home = os.getenv("HOME")
	local path = os.getenv("XDG_RUNTIME_DIR") .. "/waybar-config.jsonc"
	local f = assert(io.open(path, "w"))
	f:write(string.format('{ "output": %q, "include": [%q] }\n', output, home .. "/.config/waybar/config.jsonc"))
	f:close()
	hl.exec_cmd(string.format("pkill -x waybar; waybar -c %s -s %s/.config/waybar/style.css", path, home))
end

function M.reassign()
	current.main, current.sub = resolve()

	for _, ws in ipairs(hl.get_workspaces()) do
		if not ws.special and ws.name ~= SUB_WORKSPACE and ws.monitor and ws.monitor.name ~= current.main then
			hl.dispatch(hl.dsp.workspace.move({ workspace = "name:" .. ws.name, monitor = current.main }))
		end
	end

	if current.sub then
		hl.dispatch(hl.dsp.focus({ monitor = current.sub }))
		if hl.get_workspace("name:" .. SUB_WORKSPACE) then
			hl.dispatch(hl.dsp.workspace.move({ workspace = "name:" .. SUB_WORKSPACE, monitor = current.sub }))
		end
		hl.dispatch(hl.dsp.focus({ workspace = "name:" .. SUB_WORKSPACE }))
	end
	hl.dispatch(hl.dsp.focus({ monitor = current.main }))

	restart_waybar(current.main)
end

-- Focusing main first keeps new workspaces from being created on sub.
function M.focus_workspace(name)
	if current.main then
		hl.dispatch(hl.dsp.focus({ monitor = current.main }))
	end
	hl.dispatch(hl.dsp.focus({ workspace = "name:" .. name }))
end

function M.move_window_to_workspace(name)
	hl.dispatch(hl.dsp.window.move({ workspace = "name:" .. name, follow = false }))
	local ws = hl.get_workspace("name:" .. name)
	if current.main and ws and ws.monitor and ws.monitor.name ~= current.main then
		hl.dispatch(hl.dsp.workspace.move({ workspace = "name:" .. name, monitor = current.main }))
	end
end

function M.focus_sub()
	if current.sub then
		hl.dispatch(hl.dsp.focus({ monitor = current.sub }))
	else
		hl.dispatch(hl.dsp.focus({ workspace = "name:" .. SUB_WORKSPACE }))
	end
end

function M.move_window_to_sub()
	hl.dispatch(hl.dsp.window.move({ workspace = "name:" .. SUB_WORKSPACE, follow = false }))
end

return M
