local SUB_WORKSPACE = "sub"

local monitor_roles = {}

local current = { main = nil, sub = nil }

-- A disconnected monitor can still be listed (disabled).
local function usable(mon)
	return mon and mon.enabled and not mon.is_mirror
end

local function other_usable(name)
	for _, mon in ipairs(hl.get_monitors()) do
		if usable(mon) and mon.name ~= name then
			return mon.name
		end
	end
end

-- Roles are not updated on hotplug, so a stored monitor may be gone.
local function connected(name)
	if name and usable(hl.get_monitor(name)) then
		return name
	end
end

function monitor_roles.set_main_to_focused()
	local focused = hl.get_active_monitor()
	if not usable(focused) then
		return
	end
	current.main, current.sub = focused.name, other_usable(focused.name)

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
end

-- Recovers the roles from where the sub workspace lives, without moving anything.
function monitor_roles.restore()
	local ws = hl.get_workspace("name:" .. SUB_WORKSPACE)
	local sub = ws and ws.monitor and connected(ws.monitor.name)
	local main = sub and other_usable(sub)
	if main then
		current.main, current.sub = main, sub
	else
		local focused = hl.get_active_monitor()
		current.main = usable(focused) and focused.name or nil
		current.sub = current.main and other_usable(current.main)
	end
end

-- Focusing main first keeps new workspaces from being created on sub.
function monitor_roles.focus_workspace(name)
	local main = connected(current.main)
	if main then
		hl.dispatch(hl.dsp.focus({ monitor = main }))
	end
	hl.dispatch(hl.dsp.focus({ workspace = "name:" .. name }))
end

function monitor_roles.move_window_to_workspace(name)
	hl.dispatch(hl.dsp.window.move({ workspace = "name:" .. name, follow = false }))
	local main = connected(current.main)
	local ws = hl.get_workspace("name:" .. name)
	if main and ws and ws.monitor and ws.monitor.name ~= main then
		hl.dispatch(hl.dsp.workspace.move({ workspace = "name:" .. name, monitor = main }))
	end
end

function monitor_roles.focus_sub()
	local sub = connected(current.sub)
	if sub then
		hl.dispatch(hl.dsp.focus({ monitor = sub }))
	else
		hl.dispatch(hl.dsp.focus({ workspace = "name:" .. SUB_WORKSPACE }))
	end
end

function monitor_roles.move_window_to_sub()
	hl.dispatch(hl.dsp.window.move({ workspace = "name:" .. SUB_WORKSPACE, follow = false }))
end

return monitor_roles
