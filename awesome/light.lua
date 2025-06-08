local wibox   = require("wibox")
local awful   = require("awful")
local gears   = require("gears")
local naughty = require("naughty")
local lgi     = require("lgi")
local json    = require ("json")

local icon_theme = lgi.Gtk.IconTheme.get_default()

local light_icon = wibox.widget {
  {
    id = "icon",
    resize = false,
    widget = wibox.widget.imagebox,
  },
  layout = wibox.container.margin(_, 0, 0, 5)
}

local hue_url = "http://192.168.2.6"
local hue_api = "/api/YGWGPKxndSftRHl1h9Y4HVbjoaZkkCGqZkcEwfFA"
local hue_state = "false"

local icon_names = {
  ["gpm-brightness-lcd"] = 0,
  ["gpm-brightness-lcd-disabled"] = 0,
}

for name in pairs(icon_names) do
  local icon = icon_theme:lookup_icon(
    name,
    16,
    {lgi.Gtk.IconLookupFlags.GENERIC_FALLBACK}
  )

  if icon then
    icon_names[name] = icon:load_surface()
  end
end

local function update_icon(hue_state)
  local icon = icon_names["gpm-brightness-lcd"]

  if not hue_state then
    icon = icon_names["gpm-brightness-lcd-disabled"]
  end

  light_icon.icon.image = icon
end

local function toggle_light()
    awful.spawn("curl -sX PUT -d '{\"on\":" .. tostring(not hue_state) .. "}' '" .. hue_url .. hue_api .. "/groups/bedroom/action' > /dev/null")
    hue_state = not hue_state
    update_icon(hue_state)
end

local light = wibox.widget {
  light_icon,
  layout = wibox.layout.fixed.horizontal,
  buttons = awful.button({}, 1, function() toggle_light() end)
}
 
function update_light()
  awful.spawn.easy_async_with_shell("curl -X GET '" .. hue_url .. hue_api .. "/groups/bedroom'", function(stdout, stderr, exitreason, exitcode)
    if string.sub(stdout, 1, 1) == '{' then
      hue_state = not not (json.decode(stdout).state.all_on)
    end

    update_icon(hue_state)
  end)
end

gears.timer {
  timeout = 10,
  call_now = true,
  autostart = true,
  callback = function()
    update_light()
  end
}

return light
