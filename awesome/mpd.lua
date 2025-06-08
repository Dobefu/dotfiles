local mpc = require("mpc")
local wibox = require("wibox")
local timer = require("gears.timer")
local awful = require("awful")
local lgi = require('lgi')

local icon_theme = lgi.Gtk.IconTheme.get_default()

local mpd_icon = wibox.widget {
  {
    id = "icon",
    resize = false,
    widget = wibox.widget.imagebox
  },
  layout = wibox.container.margin(_, 0, 4, 5)
}

local mpd_text = wibox.widget {
  {
    id = "text",
    widget = wibox.widget.textbox(),
  },
  layout = wibox.layout.fixed.horizontal
}

local mpd = wibox.widget {
  mpd_icon,
  mpd_text,
  layout = wibox.layout.fixed.horizontal
}

local mpd_icon_names = {
  ["media-playback-start"] = 0,
  ["media-playback-pause"] = 0,
}

for name in pairs(mpd_icon_names) do
  local icon = icon_theme:lookup_icon(
    name,
    16,
    {lgi.Gtk.IconLookupFlags.GENERIC_FALLBACK}
  )

  if icon then
    mpd_icon_names[name] = icon:load_surface()
  end
end

local function update_icon(state)
  icon = mpd_icon_names["media-playback-start"]

  if state == "pause" or state == "stop" then
    icon = mpd_icon_names["media-playback-start"]
  end

  if state == "play" then
    icon = mpd_icon_names["media-playback-pause"]
  end

  mpd_icon.icon.image = icon
end

local state, title, artist, file = "stop", "", "", ""

local function update_widget()
  local text = tostring(artist or "") .. " - " .. tostring(title or "")
  update_icon(state)

  mpd_text.text:set_text(text)
end

local connection

local function error_handler(err)
  mpd_text.text:set_text("Error: " .. tostring(err))
  -- Try a reconnect soon-ish
  timer.start_new(10, function()
    connection:send("ping")
  end)
end

connection = mpc.new(nil, nil, nil, error_handler,
  "status", function(_, result)
    state = result.state
  end,
  "currentsong", function(_, result)
    title, artist, file = result.title, result.artist, result.file
    pcall(update_widget)
  end
)

mpd:buttons(awful.button({}, 1, function() connection:toggle_play() end))

return mpd
