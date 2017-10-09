-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")

-- Widget and layout library
local wibox = require("wibox")
local lain = require("lain")
local markup = lain.util.markup
local vicious = require('vicious')

-- Theme handling library
local beautiful = require("beautiful")
beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")
beautiful.graph_fg = "#7F9F7F"
beautiful.graph_border_color = "#7F9F7F"

-- Notification
awful.util.spawn("dunst")
_dbus = dbus
dbus = nil
local naughty = require("naughty")
dbus = _dbus
local menubar = require("menubar")

local hotkeys_popup = require("awful.hotkeys_popup").widget
local pomodoro = require('pomodoro')

local is_double_screen = screen.count() == 2
local is_secondary_main = true
local screen_id_main
local screen_id_secondary
if is_secondary_main then
    screen_id_main = 2
    screen_id_secondary = 1
else
    screen_id_main = 1
    screen_id_secondary = 2
end

local homedir = os.getenv("HOME")

local hostname = (
    function ()
        local f = io.popen ("/bin/hostname")
        local hostname = f:read("*a") or ""
        f:close()
        hostname =string.gsub(hostname, "\n$", "")
        return hostname
    end
)()
local is_laptop = (hostname == "saya" or hostname == "shiina")
local nic_id;
if is_laptop then
    nic_id = 'enp0s31f6'
else
    nic_id = 'eno1'
end

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, there were errors during startup!",
                         text = err })
        in_error = false
    end)
end
-- }}}


--}}}

--- {{{ mpd wiget
--local mpdwidget = lain.widgets.mpd({
--    music_dir = homedir .. "/music",
--    settings = function()
--        if mpd_now.state == "play" then
--            artist = " " .. mpd_now.artist .. " "
--            title  = mpd_now.title  .. " "
--        elseif mpd_now.state == "pause" then
--            artist = " mpd "
--            title  = "paused "
--        else
--            artist = " mpd "
--            title  = "unknown "
--        end
--
--        widget:set_markup(markup("#EA6F81", artist) .. title)
--    end
--})
--mpdwidget:buttons(awful.util.table.join(
--    awful.button({ }, 1, function () awful.spawn("mpc toggle") end)
--))
---}}}

--{{{ pomodoro timer
pomodoro.init()
pomodoro.on_work_pomodoro_finish_callbacks = {
    function()
        awful.spawn('ogg123 /usr/share/sounds/freedesktop/stereo/complete.oga')
    end
}
pomodoro.on_pause_pomodoro_finish_callbacks = {
    function()
        awful.spawn('ogg123 /usr/share/sounds/freedesktop/stereo/complete.oga')
    end
}
--}}}


-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.

-- This is used later as the default terminal
terminal = "urxvt"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating,
}
-- }}}


-- {{{ Tags
-- Define a tag table which hold all screen tags.
local left_tag_names = { "1", "2", "3", "4", "5", "6", "7" }
local right_tag_names = { "8", "9", "0", "-", "="}
local tag_names = awful.util.table.clone(left_tag_names)
awful.util.table.merge(tag_names, right_tag_names)

if not is_double_screen then
    tags = {}
    tags[1] = awful.tag(tag_names, 1, layouts[1])
else
    tags = {}
    tags[1] = awful.tag(left_tag_names, screen_id_main, layouts[1])
    tags[2] = awful.tag(right_tag_names, screen_id_secondary, awful.layout.suit.max)
end

function focus_home_position()
    if is_double_screen then
        awful.tag.viewonly(tags[2][#tags[2]])
    end
    awful.tag.viewonly(tags[1][1])
end

-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then
        right_layout:add(wibox.container.background(wibox.widget.systray(), beautiful.bg_focus))
        --right_layout:add(wibox.container.background(mpdwidget, beautiful.bg_focus))
        right_layout:add(wibox.container.background(pomodoro.icon_widget, beautiful.bg_focus))
        right_layout:add(wibox.container.background(pomodoro.widget, beautiful.bg_focus))
        if is_laptop then
            local memtext = wibox.widget.textbox()
            vicious.register(memtext, vicious.widgets.mem, '<b><span color="#7F9F7F"> mem: $2 kB($1%)</span><span color="#cccccc"> | </span></b>', 2)
            right_layout:add(wibox.container.background(memtext, beautiful.bg_focus))

            cpuwidget = wibox.widget.graph()
            cpuwidget:set_width(50)
            cpuwidget:set_background_color(beautiful.bg_focus)
            cpuwidget_t = awful.tooltip({ objects = { cpuwidget.widget },})
            vicious.register(cpuwidget, vicious.widgets.cpu, "$1", 1)
            right_layout:add(
                wibox.container.mirror(
                    cpuwidget,
                    { horizontal = true }
                )
            )

            local battext = wibox.widget.textbox()
            local formatter = function(widget, args)
                local status = args[1]
                local percent = args[2]
                local str =
                    "<span weight='bold' color='%s'>" ..
                    "%s</span>%d "
                if percent > 75 then
                    return string.format(str, "#00CC00", status, percent)
                elseif percent > 50 then
                    return string.format(str, "#66CC00", status, percent)
                elseif percent > 25 then
                    return string.format(str, "#CCCC00", status, percent)
                elseif percent > 10 then
                    return string.format(str, "#CC6600", status, percent)
                else
                    return string.format(str, "#CC0000", status, percent)
                end
            end
            vicious.register(battext, vicious.widgets.bat, formatter, 3, "BAT0")
            right_layout:add(battext)

            local battext = wibox.widget.textbox()
            local formatter = function(widget, args)
                local status = args[1]
                local percent = args[2]
                local str =
                    "<span weight='bold' color='%s'>" ..
                    "%s</span>%d "
                if percent > 75 then
                    return string.format(str, "#00CC00", status, percent)
                elseif percent > 50 then
                    return string.format(str, "#66CC00", status, percent)
                elseif percent > 25 then
                    return string.format(str, "#CCCC00", status, percent)
                elseif percent > 10 then
                    return string.format(str, "#CC6600", status, percent)
                else
                    return string.format(str, "#CC0000", status, percent)
                end
            end
            vicious.register(battext, vicious.widgets.bat, formatter, 3, "BAT1")
            right_layout:add(battext)
        end
    else
        memtext = wibox.widget.textbox()
        vicious.register(memtext, vicious.widgets.mem, '<b><span color="#7F9F7F"> mem: $2 kB($1%)</span><span color="#cccccc"> | </span></b>', 2)
        right_layout:add(wibox.container.background(memtext, beautiful.bg_focus))

        nettext = wibox.widget.textbox()
        vicious.register(nettext, vicious.widgets.net, '<b><span color="#CC9933">down: ${' .. nic_id .. ' down_kb} kB/s</span> <span color="#7F9F7F"> up: ${' .. nic_id .. ' up_kb} kB/s</span></b> ', 2)
        right_layout:add(wibox.container.background(nettext, beautiful.bg_focus))

        cpuwidget = wibox.widget.graph()
        cpuwidget:set_width(50)
        cpuwidget_t = awful.tooltip({ objects = { cpuwidget.widget },})
        vicious.register(cpuwidget, vicious.widgets.cpu, "$1", 1)
        right_layout:add(wibox.container.background(cpuwidget, beautiful.bg_focus))
    end
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
local cmd_rofi_window_selector = "rofi -show window -font 'Ricty 14' -fg '#a0a0a0' -bg '#000000' -hlfg '#ffb964' -hlbg '#303030' -fg-active '#ffb0b0' -opacity 85"
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),

    -- Screen focus
    awful.key({ modkey,           }, "[", function () awful.screen.focus(screen_id_main) end),
    awful.key({ modkey,           }, "]", function ()
        if is_double_screen then
            awful.screen.focus(screen_id_secondary)
        end
    end),
    awful.key({ modkey,           }, "r", focus_home_position),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Shift"   }, "Return", function () awful.util.spawn("xterm") end),
    awful.key({ modkey, "Shift"   }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "Escape", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "Tab", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "Tab", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Shift"   }, "n", awful.client.restore),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey,           }, "d", function() menubar.show() end),

    awful.key({ modkey,           }, "s", hotkeys_popup.show_help,
        {description="show help", group="awesome"}),

    awful.key({ modkey,           }, "e",
        function ()
            for s = 1, screen.count() do
                mywibox[s].visible = not mywibox[s].visible
            end
        end,
        {description="toggle bar", group="bar"}),

    awful.key({ modkey,           }, "b", function() awful.util.spawn("xbacklight =5") end),
    awful.key({ modkey, "Shift"   }, "b", function() awful.util.spawn("xbacklight +5") end),

    -- program
    awful.key({ modkey, "Shift"   }, "l", function() awful.util.spawn("xscreensaver-command -lock") end),
    awful.key({ modkey, "Shift"   }, "d", function() awful.util.spawn("rofi -show run -font 'Ricty 14' -fg '#00ff00' -bg '#000000' -hlfg '#b9ff64' -hlbg '#303030' -opacity 85") end),
    awful.key({ modkey,           }, "w", function() awful.util.spawn(cmd_rofi_window_selector) end),
    awful.key({ modkey,           }, "m", function() awful.util.spawn(cmd_rofi_window_selector) end),
    awful.key({ modkey, "Shift"   }, "w", function() awful.spawn.with_shell("python ~/workspace/wallpaperchanger/wallpaperchanger.py") end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end),
    awful.key({ modkey, "Shift"   }, "f",  awful.client.floating.toggle                     ),
    awful.key({ modkey,           }, "space",  function (c) c:swap(awful.client.getmaster()) end),

    -- screen moving
    awful.key({ modkey,           }, "o",
        function (c)
            c.no_opacity = (not c.no_opacity)
        end),
    awful.key({ modkey, "Shift"   }, "[",
        function (c)
            local screen = mouse.screen
            awful.client.movetoscreen(c, 1)
            awful.screen.focus(screen)
        end),
    awful.key({ modkey, "Shift"   }, "]",
        function (c)
            if is_double_screen then
                local screen = mouse.screen
                awful.client.movetoscreen(c, 2)
                awful.screen.focus(screen)
            end
        end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
function gen_tag_key_binds(screen_id, tag_idx, tag_name)
    return awful.util.table.join(
        -- View tag only.
        awful.key({ modkey }, tag_name,
                  function ()
                        local tag = awful.tag.gettags(screen_id)[tag_idx]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end,
                  {description="", group="tag"}
                  ),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, tag_name,
                  function ()
                      local tag = awful.tag.gettags(screen_id)[tag_idx]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, tag_name,
                  function ()
                      local scr = mouse.screen
                      if client.focus then
                          local tag = awful.tag.gettags(screen_id)[tag_idx]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                     awful.screen.focus(scr)
                  end))
end


function gen_globalkeys_by_screen_id(globalkeys, screen_id, tag_names)
    for i, t in ipairs(tag_names) do
        globalkeys = awful.util.table.join(globalkeys,
            gen_tag_key_binds(screen_id, i, t)
        )
    end
    return globalkeys
end

if not is_double_screen then
    for i, t in ipairs(tag_names) do
        globalkeys = awful.util.table.join(globalkeys,
            gen_tag_key_binds(1, i, t)
        )
    end
else
    local _tag_names_list
    globalkeys = gen_globalkeys_by_screen_id(globalkeys, 1, right_tag_names)
    globalkeys = gen_globalkeys_by_screen_id(globalkeys, 2, left_tag_names)
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { --border_width = beautiful.border_width,
                     --border_color = beautiful.border_normal,
                     placement = awful.placement.under_mouse+awful.placement.no_overlap+awful.placement.no_offscreen,
                     focus = awful.client.focus.filter,
                     raise = true,
                     size_hints_honor = false,
                     keys = clientkeys,
                     no_opacity = false,
                     buttons = clientbuttons } },
    { rule = { class = "wmail" },
      properties = { tag = "7" } },
    { rule = { class = "slack" },
      properties = { tag = "7" } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
local _start_time = os.time()

client.connect_signal("manage", function (c, startup)
    -- -- Enable sloppy focus
    -- c:connect_signal("mouse::enter", function(c)
    --     if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
    --         and awful.client.focus.filter(c) then
    --         client.focus = c
    --     end
    -- end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local current_time = os.time()
    if current_time - _start_time > 3 then
        _is_first_run = false
        c:move_to_screen(mouse.screen)
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
    c.opacity = 1
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
    if (not c.no_opacity) then
        c.opacity = 0.95
    end
end)
-- }}}


-- {{{
local timer = require("gears.timer")

local function filter_sticky(c)
    return not c.sticky and awful.client.focus.filter(c)
end

--- Give focus when clients appear/disappear.
--
-- @param obj An object that should have a .screen property.
local function check_focus(obj)
    if not obj.screen.valid then return end
    -- When no visible client has the focus...
    if not client.focus or not client.focus:isvisible() then
        local c = awful.client.focus.history.get(screen[obj.screen], 0, filter_sticky)
        if not c then
            c = awful.client.focus.history.get(screen[obj.screen], 0, awful.client.focus.filter)
        end
        if c then
            c:emit_signal("request::activate", "autofocus.check_focus",
                          {raise=false})
        end
    end
end

--- Check client focus (delayed).
-- @param obj An object that should have a .screen property.
local function check_focus_delayed(obj)
    timer.delayed_call(check_focus, {screen = obj.screen})
end

--- Give focus on tag selection change.
--
-- @param tag A tag object
local function check_focus_tag(t)
    local s = t.screen
    if (not s) or (not s.valid) then return end
    s = screen[s]
    check_focus({ screen = s })
    if client.focus and screen[client.focus.screen] ~= s then
        local c = awful.client.focus.history.get(s, 0, filter_sticky)
        if not c then
            c = awful.client.focus.history.get(s, 0, awful.client.focus.filter)
        end
        if c then
            c:emit_signal("request::activate", "autofocus.check_focus_tag",
                          {raise=false})
        end
    end
end



tag.connect_signal("property::selected", function (t)
    timer.delayed_call(check_focus_tag, t)
end)
client.connect_signal("unmanage",            check_focus_delayed)
client.connect_signal("tagged",              check_focus_delayed)
client.connect_signal("untagged",            check_focus_delayed)
client.connect_signal("property::hidden",    check_focus_delayed)
client.connect_signal("property::minimized", check_focus_delayed)
client.connect_signal("property::sticky",    check_focus_delayed)
-- }}}


focus_home_position()
