local wibox   = require("wibox")
local awful   = require("awful")
local gears   = require("gears")
local naughty = require("naughty")
local lgi     = require('lgi')

local icon_theme = lgi.Gtk.IconTheme.get_default()

local volume_icon = wibox.widget {
  {
    id = "icon",
    resize = false,
    widget = wibox.widget.imagebox,
  },
  layout = wibox.container.margin(_, 0, 0, 5)
}

local volume_text = wibox.widget {
  {
    id = "text",
    widget = wibox.widget.textbox(),
  },
  layout = wibox.layout.fixed.horizontal
}

local volume = wibox.widget {
  volume_icon,
  volume_text,
  layout = wibox.layout.fixed.horizontal
}

local osd = awful.popup {
  widget = {
    {
      volume_icon,
      volume_text,
      layout = wibox.layout.fixed.horizontal,
    },
    margins = 20,
    widget  = wibox.container.margin
  },
  hide_on_right_click = true,
  input_passthrough   = true,
  ontop         = true,
  opacity       = .95,
  placement     = awful.placement.centered,
  shape         = gears.shape.rounded_rect,
  visible       = false,
}

osd.timer = gears.timer {
  timeout = 1,
  autostart = false,
  call_now = false,
  single_shot = true,
  callback = function(_)
    osd.visible = false
  end
}

local icon_names = {
  ["audio-volume-high"]   = 0,
  ["audio-volume-medium"] = 0,
  ["audio-volume-low"]    = 0,
  ["audio-volume-muted"]  = 0,
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

local function update_icon(vol, mute)
  local icon = icon_names["audio-volume-high"]

  if vol < 70 then
    icon = icon_names["audio-volume-medium"]
  end

  if vol < 30 then
    icon = icon_names["audio-volume-low"]
  end

  if vol <= 0 or mute then
    icon = icon_names["audio-volume-muted"]
  end

  volume_icon.icon.image = icon
end
 
 
function update_volume(silent)
  silent = silent or false
  awful.spawn.easy_async("amixer sget Master", function(stdout, stderr, reason, exit_code)
    local vol = string.match(stdout, "(%d?%d?%d)%%")
    vol = string.format("% 3d", vol)
   
    stdout = string.match(stdout, "%[(o[^%]]*)%]")
    local mute = not string.find(stdout, "on", 1, true)
    update_icon(tonumber(vol), mute)

    if mute then
      -- For the mute button
      vol = "<span alpha=\"50%\">" .. vol .. "%</span>"
    else
      -- For the volume numbers
      vol = vol .. "%"
    end

    volume_text.text:set_markup(vol)

    if not silent then
      osd.visible = true
      osd.timer:again()
      -- naughty.destroy(osd)
      -- osd = naughty.notify({
      --   preset = naughty.config.presets.low,
      --   icon = volume_icon.icon.image,
      --   opacity = .9,
      --   text = vol,
      --   position = "bottom_middle",
      --   timeout = 1
      -- })
    end
  end)
end
 
update_volume(true)

gears.timer {
  timeout = 10,
  call_now = false,
  autostart = true,
  callback = function()
    update_volume(true)
  end
}

return volume
