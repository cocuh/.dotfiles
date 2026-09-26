local SUB_WORKSPACE = "sub"

local monitor_roles = {}

-- subs[i] holds sub_workspace(i).
local current = { main = nil, subs = {} }

-- Keeps the first sub workspace named "sub", as with a single sub monitor.
local function sub_workspace(i)
	return i == 1 and SUB_WORKSPACE or SUB_WORKSPACE .. i
end

local function sub_index(name)
	if name == SUB_WORKSPACE then
		return 1
	end
	local i = name:match("^" .. SUB_WORKSPACE .. "(%d+)$")
	return i and tonumber(i)
end

-- A disconnected monitor can still be listed (disabled).
-- Some Hyprland builds leave `enabled` nil, so only an explicit false rejects.
local function usable(mon)
	return mon and mon.enabled ~= false and not mon.is_mirror
end

local function others_usable(name)
	local names = {}
	for _, mon in ipairs(hl.get_monitors()) do
		if usable(mon) and mon.name ~= name then
			names[#names + 1] = mon.name
		end
	end
	return names
end

-- Roles are not updated on hotplug, so a stored monitor may be gone.
local function connected(name)
	if name and usable(hl.get_monitor(name)) then
		return name
	end
end

local function connected_subs()
	local subs = {}
	for _, name in ipairs(current.subs) do
		if connected(name) then
			subs[#subs + 1] = name
		end
	end
	return subs
end

function monitor_roles.set_main_to_focused()
	local focused = hl.get_active_monitor()
	if not usable(focused) then
		return
	end
	current.main, current.subs = focused.name, others_usable(focused.name)

	for _, ws in ipairs(hl.get_workspaces()) do
		if not ws.special and not sub_index(ws.name) and ws.monitor and ws.monitor.name ~= current.main then
			hl.dispatch(hl.dsp.workspace.move({ workspace = "name:" .. ws.name, monitor = current.main }))
		end
	end

	for i, sub in ipairs(current.subs) do
		local name = sub_workspace(i)
		hl.dispatch(hl.dsp.focus({ monitor = sub }))
		if hl.get_workspace("name:" .. name) then
			hl.dispatch(hl.dsp.workspace.move({ workspace = "name:" .. name, monitor = sub }))
		end
		hl.dispatch(hl.dsp.focus({ workspace = "name:" .. name }))
	end
	hl.dispatch(hl.dsp.focus({ monitor = current.main }))
end

-- Recovers the roles from where the sub workspaces live, without moving anything.
function monitor_roles.restore()
	local subs, on_sub = {}, {}
	for _, ws in ipairs(hl.get_workspaces()) do
		local i = sub_index(ws.name)
		local mon = i and ws.monitor and connected(ws.monitor.name)
		if mon and not on_sub[mon] then
			subs[#subs + 1] = { index = i, name = mon }
			on_sub[mon] = true
		end
	end
	table.sort(subs, function(a, b) return a.index < b.index end)

	local main
	for _, name in ipairs(others_usable(nil)) do
		if not on_sub[name] then
			main = name
			break
		end
	end

	if main then
		current.main, current.subs = main, {}
		for _, sub in ipairs(subs) do
			current.subs[#current.subs + 1] = sub.name
		end
	else
		local focused = hl.get_active_monitor()
		current.main = usable(focused) and focused.name or nil
		current.subs = current.main and others_usable(current.main) or {}
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

-- Cycles through the sub monitors when there are several.
function monitor_roles.focus_sub()
	local subs = connected_subs()
	if #subs == 0 then
		hl.dispatch(hl.dsp.focus({ workspace = "name:" .. SUB_WORKSPACE }))
		return
	end

	local focused = hl.get_active_monitor()
	local target = subs[1]
	for i, name in ipairs(subs) do
		if focused and name == focused.name then
			target = subs[i % #subs + 1]
			break
		end
	end
	hl.dispatch(hl.dsp.focus({ monitor = target }))
end

function monitor_roles.move_window_to_sub()
	hl.dispatch(hl.dsp.window.move({ workspace = "name:" .. SUB_WORKSPACE, follow = false }))
end

return monitor_roles
