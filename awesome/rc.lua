-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
local lgi = require('lgi')
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
-- Volume management
local volume = require("volume")
-- MPD controls
local mpd = require("mpd")
-- Light widget
local light = require("light")
local calendar = require("calendar")
local quitmenu = require("quitmenu")
-- Power management
-- local power_widget = require("power")
-- power_widget.warning_config = {
--   percentage = 15,
--   message = "The battery is getting low",
--   preset = {
--     shape = gears.shape.rounded_rect,
--     timeout = 12,
--     bg = "#FFFF00",
--     fg = "#000000",
--   },
-- }

-- Startup programs
awful.spawn.with_shell("/home/dobefu/.screenlayout/default.sh")
awful.spawn.with_shell("xmodmap ~/.Xmodmap")
awful.spawn.once("/usr/libexec/polkit-gnome-authentication-agent-1")
-- awful.spawn.once("mpd")
awful.spawn.once("nm-applet &")
awful.spawn.once("blueman-tray")
awful.spawn.once("picom --experimental-backends")
awful.spawn.once("shairport-sync")
awful.spawn.once("parcellite")
-- awful.spawn.once("ckb-next --background")
-- awful.spawn.once("slack")
-- awful.spawn.once("riot")
-- awful.spawn.once("thunderbird")

-- Notification styling
local icon_theme = lgi.Gtk.IconTheme.get_default()

naughty_info_icon = icon_theme:lookup_icon(
  "state-information-symbolic",
  16,
  {lgi.Gtk.IconLookupFlags.GENERIC_FALLBACK}
)

if naughty_info_icon then
  naughty.config.defaults.icon = naughty_info_icon:get_filename()
end

naughty.config.defaults.icon_size = 16
naughty.config.defaults.screen = screen.primary
naughty.config.defaults.margin = beautiful.xresources.apply_dpi(15)
naughty.config.defaults.position = "top_middle"
naughty.config.defaults.border_width = 0
naughty.config.defaults.shape = gears.shape.rounded_rect
naughty.config.defaults.opacity = .9

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors
  })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err)
    })

    in_error = false
  end)
end
-- }}}

local place_centered = function(c)
  return gears.timer.delayed_call(function ()
    awful.placement.centered(c, {honor_padding = true, honor_workarea=true})
  end)
end

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/gtk/theme.lua")
beautiful.init(gears.filesystem.get_themes_dir() .. "gtk/theme.lua")
beautiful.awesome_icon = gears.filesystem.get_configuration_dir() .. "/img/logo.png"

-- This is used later as the default terminal and editor to run.
terminal = "st"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.floating,
  awful.layout.suit.spiral.dwindle,
  -- awful.layout.suit.spiral,
  awful.layout.suit.max,
  -- awful.layout.suit.max.fullscreen,
  -- awful.layout.suit.magnifier,
  -- awful.layout.suit.tile.left,
  -- awful.layout.suit.tile.bottom,
  -- awful.layout.suit.tile.top,
  -- awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
  { "hotkeys",     function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { "manual",      terminal .. " -e man awesome" },
  { "edit config", editor_cmd .. " " .. awesome.conffile },
  { "restart",     awesome.restart },
  { "quit",        function() awesome.quit() end },
}

mymainmenu = awful.menu({
  items = {
    {
      "awesome",
      myawesomemenu,
      beautiful.awesome_icon
    },
    { "open terminal", terminal }
  }
})

mylauncher = awful.widget.launcher({
  image = beautiful.awesome_icon,
  menu = mymainmenu
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- Create a textclock widget
datetime = wibox.widget {
  {
    {
      widget = wibox.widget.textclock(
        " %a %d %b %Y, %H:%M:%S ",
        1 -- Update interval in seconds
      ),
    },
    layout = wibox.container.margin(_, 1, 1, 4, 4)
  },

  shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, 12) end,
  layout = wibox.container.background
}

calendar_widget = calendar({
  fdow = 1,
  empty_sep = '    ',
  week_col = '%V ',
  page_title = '%d %B %Y',
})

calendar_widget:attach(datetime)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button({ }, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
  awful.button({ }, 1, function (c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal(
        "request::activate",
        "tasklist",
        {raise = true}
      )
    end
  end),
  awful.button({ }, 3, function()
                           awful.menu.client_list({ theme = { width = 250 } })
                       end),
  awful.button({ }, 4, function ()
                           awful.client.focus.byidx(1)
                       end),
  awful.button({ }, 5, function ()
                           awful.client.focus.byidx(-1)
                       end))

local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    -- gears.wallpaper.maximized(wallpaper, s, true)
    gears.wallpaper.maximized(gears.filesystem.get_configuration_dir() .. "/img/background.jpg", s, true)
  end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  set_wallpaper(s)

  master_count = 2
  if s.geometry.height > s.geometry.width then
    -- Create a vertical layout for vertical screens.
    master_count = 4
  end

  -- Each screen has its own tag table.
  for i = 1, 9 do
    awful.tag.add(i, {
      layout = awful.layout.layouts[1],
      screen = s,
      master_count = master_count,
      index = i,
      selected = (i == 1),
    })
  end

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
                         awful.button({ }, 1, function () awful.layout.inc( 1) end),
                         awful.button({ }, 3, function () awful.layout.inc(-1) end),
                         awful.button({ }, 4, function () awful.layout.inc( 1) end),
                         awful.button({ }, 5, function () awful.layout.inc(-1) end)))
  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = taglist_buttons,
  }

  -- and apply shape to it
  if beautiful.taglist_shape_container then
    local background_shape_wrapper = wibox.container.background(s.mytaglist)
    background_shape_wrapper._do_taglist_update_now = s.mytaglist._do_taglist_update_now
    background_shape_wrapper._do_taglist_update = s.mytaglist._do_taglist_update
    background_shape_wrapper.shape = beautiful.taglist_shape_container
    background_shape_wrapper.shape_clip = beautiful.taglist_shape_clip_container
    background_shape_wrapper.shape_border_width = beautiful.taglist_shape_border_width_container
    background_shape_wrapper.shape_border_color = beautiful.taglist_shape_border_color_container
    s.mytaglist = background_shape_wrapper
  end

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist {
    screen  = s,
    filter  = awful.widget.tasklist.filter.currenttags,
    widget_template = {
      {
        {
          {
            {
              id     = 'icon_role',
              widget = wibox.widget.imagebox,
            },
            margins = 2,
            widget  = wibox.container.margin,
          },
          {
            id     = 'text_role',
            widget = wibox.widget.textbox,
          },
          layout = wibox.layout.fixed.horizontal,
        },
        left  = 10,
        right = 10,
        widget = wibox.container.margin
      },
      id     = 'background_role',
      widget = wibox.container.background,
    },
    buttons = tasklist_buttons,
  }

  -- Create the wibox
  s.topwibox = awful.wibar({
    position = "top",
    screen = s,
    opacity = 0.8,
    height = 35,
    width = s.width,
    x = 0,
    y = 20,
    visible = true,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 9)
    end,
  })

  local separator = wibox.widget.separator({ orientation = "vertical", forced_width = 10 }),

  -- Add widgets to the wibox
  s.topwibox:setup {
    layout = wibox.container.margin(_, 6, 6, 6, 6),
    {
      layout = wibox.layout.align.horizontal,
      expand = "none",
      { -- Left widgets
        layout = wibox.layout.fixed.horizontal,
        mylauncher,
        s.mytaglist,
        separator,
        s.mypromptbox,
        s.mytasklist,
      },
      wibox.container.place(
        datetime,
        "center",
        "center"
      ),
      { -- Right widgets
        layout = wibox.layout.fixed.horizontal,
        spacing = 10,
        wibox.widget.systray({ base_size = 16, spacing = 4 }),
        light,
        power_widget,
        volume,
        separator,
        mpd,
        s.mylayoutbox,
      },
    },
  }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
  awful.button({ }, 3, function () mymainmenu:toggle() end),
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
  awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
            {description="show help", group="awesome"}),
  awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
            {description = "view previous", group = "tag"}),
  awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
            {description = "view next", group = "tag"}),
  awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
            {description = "go back", group = "tag"}),

  awful.key({ modkey,           }, "j",
      function ()
          awful.client.focus.byidx( 1)
      end,
      {description = "focus next by index", group = "client"}
  ),
  awful.key({ modkey,           }, "k",
      function ()
          awful.client.focus.byidx(-1)
      end,
      {description = "focus previous by index", group = "client"}
  ),
  awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
            {description = "show main menu", group = "awesome"}),

  -- Layout manipulation
  awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
            {description = "swap with next client by index", group = "client"}),
  awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
            {description = "swap with previous client by index", group = "client"}),
  awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
            {description = "focus the next screen", group = "screen"}),
  awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
            {description = "focus the previous screen", group = "screen"}),
  awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
            {description = "jump to urgent client", group = "client"}),
  awful.key({ modkey,           }, "Tab",
      function ()
          awful.client.focus.history.previous()
          if client.focus then
              client.focus:raise()
          end
      end,
      {description = "go back", group = "client"}),

  -- Standard program
  awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
            {description = "open a terminal", group = "launcher"}),
  awful.key({ modkey, "Shift" }, "r", awesome.restart,
            {description = "reload awesome", group = "awesome"}),
  awful.key({ modkey, "Mod1" }, "r", function() menubar.refresh() end,
            {description = "reload awesome", group = "awesome"}),
  awful.key({ modkey, "Shift"   }, "q", awesome.quit,
            {description = "quit awesome", group = "awesome"}),

  awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
            {description = "increase master width factor", group = "layout"}),
  awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
            {description = "decrease master width factor", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
            {description = "increase the number of master clients", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
            {description = "decrease the number of master clients", group = "layout"}),
  awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
            {description = "increase the number of columns", group = "layout"}),
  awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
            {description = "decrease the number of columns", group = "layout"}),
  -- awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
  --           {description = "select next", group = "layout"}),
  -- awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
  --           {description = "select previous", group = "layout"}),

  awful.key({ modkey, "Control" }, "n",
            function ()
                local c = awful.client.restore()
                -- Focus restored client
                if c then
                  c:emit_signal(
                      "request::activate", "key.unminimize", {raise = true}
                  )
                end
            end,
            {description = "restore minimized", group = "client"}),

  -- Prompt
  awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
            {description = "run prompt", group = "launcher"}),

  awful.key({ modkey }, "x",
            function ()
                awful.prompt.run {
                  prompt       = "Run Lua code: ",
                  textbox      = awful.screen.focused().mypromptbox.widget,
                  exe_callback = awful.util.eval,
                  history_path = awful.util.get_cache_dir() .. "/history_eval"
                }
            end,
            {description = "lua execute prompt", group = "awesome"}),
  -- Menubar
  awful.key({ modkey }, "d", function() awful.spawn("rofi -show drun") end,
            {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
  -- Fullscreen
  awful.key({ modkey,           }, "f",
    function (c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    {description = "toggle fullscreen", group = "client"}
  ),
  -- Close window
  awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
            {description = "close", group = "client"}
  ),
  -- Toggle floating
  awful.key({ modkey, "Control" }, "space",  function (c)
    awful.client.floating.toggle()
    place_centered(c)
    c:raise()
    c.ontop = not c.ontop
    awful.titlebar.toggle(c)
  end,
            {description = "toggle floating", group = "client"}
  ),
  -- Move to master window 
  awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
            {description = "move to master", group = "client"}
  ),
  -- Move to another monitor
  awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
            {description = "move to screen", group = "client"}
  ),
  -- Keep on top
  awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
            {description = "toggle keep on top", group = "client"}
  ),
  -- Minimize
  awful.key({ modkey,           }, "n",
    function (c)
      -- The client currently has the input focus, so it cannot be
      -- minimized, since minimized clients can't have the focus.
      c.minimized = true
    end ,
    {description = "minimize", group = "client"}
  ),
  -- Maximize
  awful.key({ modkey,           }, "m",
    function (c)
      c.maximized = not c.maximized
      c:raise()
    end ,
    {description = "(un)maximize", group = "client"}
  ),
  -- Split vertical
  awful.key({ modkey, "Control" }, "m",
    function (c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
    end ,
    {description = "(un)maximize vertically", group = "client"}
  ),
  -- Split horizontal
  awful.key({ modkey, "Shift"   }, "m",
    function (c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
    end ,
    {description = "(un)maximize horizontally", group = "client"}
  ),
  -- Toggle titlebar
  awful.key({ modkey, "Shift" }, "t", awful.titlebar.toggle,
            {description = "Toggle titlebar", group = "client"}
  ),
  -- Web browser
  awful.key({ modkey, altkey }, "f", function () awful.spawn("firefox") end,
            {description = "Launch web browser", group = "shortcuts"}
  ),
  -- Passmenu
  awful.key({ "Control", "Shift" }, "`", function () awful.spawn("passmenu") end,
            {description = "Launch Passmenu", group = "shortcuts"}
  ),
  -- Screenshot utility
  awful.key({                }, "Print", function () awful.spawn("flameshot gui") end,
            {description = "Launch screenshot utility", group = "shortcuts"}
  ),
  -- Special character picker
  awful.key({ "Control", "Shift" }, "e", function () awful.spawn("pickemoji") end,
            {description = "Launch special character picker", group = "shortcuts"}
  ),
  -- Cycle through windows
  awful.key({ altkey,           }, "Tab",
    function ()
      awful.client.focus.byidx(-1)
      if client.focus then
        client.focus:raise()
      end
    end,
    {description = "Cycle through windows", group = "client"}
  ),
  -- Cycle through windows (reverse)
  awful.key({ altkey, "Shift"   }, "Tab",
    function ()
      awful.client.focus.byidx(1)
      if client.focus then
        client.focus:raise()
      end
    end,
    {description = "Cycle through windows (reverse)", group = "client"}
  ),
  -- Volume keys
   awful.key({}, "XF86AudioLowerVolume", function ()
     awful.spawn.easy_async("amixer -q -D pulse sset Master 5%-", function()
       update_volume()
     end)
   end),
   awful.key({}, "XF86AudioRaiseVolume", function ()
     awful.spawn.easy_async("amixer -q -D pulse sset Master 5%+", function()
       update_volume()
     end)
   end),
   awful.key({}, "XF86AudioMute", function ()
     awful.spawn.easy_async("amixer -D pulse set Master 1+ toggle", function()
       update_volume()
     end)
   end),
   -- Media keys
   awful.key({}, "XF86AudioPlay", function()
     awful.util.spawn("playerctl play-pause", false)
     awful.util.spawn("mpc toggle", false)
   end),
   awful.key({}, "XF86AudioNext", function()
     awful.util.spawn("playerctl next", false)
     awful.util.spawn("mpc next", false)
   end),
   awful.key({}, "XF86AudioPrev", function()
     awful.util.spawn("playerctl previous", false)
     awful.util.spawn("mpc prev", false)
   end),
   -- Choose song to play
   awful.key({ "Control", "Shift" }, "m", function()
     awful.util.spawn("playsong", false)
   end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = gears.table.join(globalkeys,
      -- View tag only.
      awful.key({ modkey }, "#" .. i + 9,
                function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         tag:view_only()
                      end
                end,
                {description = "view tag #"..i, group = "tag"}),
      -- Toggle tag display.
      awful.key({ modkey, "Control" }, "#" .. i + 9,
                function ()
                    local screen = awful.screen.focused()
                    local tag = screen.tags[i]
                    if tag then
                       awful.tag.viewtoggle(tag)
                    end
                end,
                {description = "toggle tag #" .. i, group = "tag"}),
      -- Move client to tag.
      awful.key({ modkey, "Shift" }, "#" .. i + 9,
                function ()
                    if client.focus then
                        local tag = client.focus.screen.tags[i]
                        if tag then
                            client.focus:move_to_tag(tag)
                        end
                   end
                end,
                {description = "move focused client to tag #"..i, group = "tag"}),
      -- Toggle tag on focused client.
      awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                function ()
                    if client.focus then
                        local tag = client.focus.screen.tags[i]
                        if tag then
                            client.focus:toggle_tag(tag)
                        end
                    end
                end,
                {description = "toggle focused client on tag #" .. i, group = "tag"})
  )
end

clientbuttons = gears.table.join(
  awful.button({ }, 1, function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
  end),
  awful.button({ modkey }, 1, function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
      awful.mouse.client.move(c)
  end),
  awful.button({ modkey }, 3, function (c)
      c:emit_signal("request::activate", "mouse_click", {raise = true})
      awful.mouse.client.resize(c)
  end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = 1,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap+awful.placement.no_offscreen
    }
  },

  -- Floating clients.
  { rule_any = {
      instance = {
        "DTA",  -- Firefox addon DownThemAll.
        "copyq",  -- Includes session name in class.
        "pinentry",
      },
      class = {
        "Arandr",
        "Blueman-manager",
        "Gpick",
        "Kruler",
        "MessageWin",  -- kalarm.
        "Sxiv",
        "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
        "Wpa_gui",
        "veromix",
        "xtightvncviewer",
        "zoom",
        "Ledger Live",
        "explorer.exe",
        "dolphin-emu",
        "retroarch",
        "polkit-gnome-authentication-agent-1",
        "Cheese",
        "qt5ct",
        "deepin-system-monitor",
        "scrcpy",
        "Gnome-calculator",
        "Gnome-system-monitor",
      },

      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name = {
        "Event Tester",  -- xev.
      },
      role = {
        "AlarmWindow",  -- Thunderbird's calendar.
        "ConfigManager",  -- Thunderbird's about:config.
        "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
      },
    },
    properties = {
      floating = true,
      ontop = true,
      placement = place_centered,
      titlebars_enabled = true,
    }
  },

  -- Remove titlebars from normal clients and dialogs
  {
    rule_any = {
      type = { ",normal", "dialog" }
    },
    properties = { titlebars_enabled = false }
  },
  -- {
  --   rule_any = {
  --     class = {
  --       -- "Slack",
  --       "Riot",
  --       "Thunderbird",
  --     }
  --   },
  --   properties = {
  --     screen = 1,
  --     tag = "3",
  --     urgent = false,
  --   }
  -- },
  {
    rule_any = {
      class = {
        "mpv",
      }
    },
    properties = {
      screen = 2,
      size_hints_honor = false,
    }
  },
  {
    rule_any = {
      class = {
        "Microsoft Teams - Preview",
        "zoom",
      },
      type = {
        ",normal",
      }
    },
    properties = {
      screen = 2,
      floating = true,
      ontop = true,
      placement = place_centered,
      titlebars_enabled = true,
    }
  },
  {
    rule_any = {
      class = {
        "deepin-system-monitor",
      }
    },
    properties = {
      border_width = 0,
      titlebars_enabled = false,
    }
  },
  {
    rule_any = {
      class = {
        "sent",
      }
    },
    properties = {
      fullscreen = true,
    }
  },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup
    and not c.size_hints.user_position
    and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
  end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
  local buttons = gears.table.join(
      awful.button({ }, 1, function()
          c:emit_signal("request::activate", "titlebar", {raise = true})
      end),
      awful.button({ }, 2, function()
          c:emit_signal("request::activate", "titlebar", {raise = true})
          awful.mouse.client.move(c)
      end),
      awful.button({ }, 3, function()
          c:emit_signal("request::activate", "titlebar", {raise = true})
          awful.mouse.client.resize(c)
      end)
  )

  awful.titlebar(c) : setup {
    expand = 'none',
    { -- Left
      awful.titlebar.widget.closebutton    (c),
      buttons = buttons,
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.ontopbutton    (c),
      awful.titlebar.widget.stickybutton   (c),
      awful.titlebar.widget.floatingbutton (c),
      layout = wibox.layout.fixed.horizontal,
    },
    { -- Middle
      { -- Title
        align  = "center",
        widget = awful.titlebar.widget.titlewidget(c)
      },
      buttons = buttons,
      layout  = wibox.layout.flex.horizontal,
    },
    { -- Right
      awful.titlebar.widget.iconwidget(c),
      layout = wibox.layout.fixed.horizontal,
    },
    layout = wibox.layout.align.horizontal,
  }
end)

-- Rounded corners
client.connect_signal("manage", function (c)
  c.shape = function(cr, width, height)
    if not c.fullscreen then
      gears.shape.rounded_rect(cr, width, height, 9)
    else
      -- Don't do rounded corners in fullscreen windows
      gears.shape.rectangle(cr, width, height)
    end
  end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
