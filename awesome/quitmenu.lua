local menubar = require("menubar")
local awful   = require("awful")


quitpopup = awful.menu({
  items = {
    {
      "Suspend",
      "systemctl suspend",
      menubar.utils.lookup_icon("system-suspend")
    },
    {
      "Reboot",
      "systemctl reboot",
      menubar.utils.lookup_icon("system-reboot")
    },
    {
      "Shutdown",
      "poweroff",
      menubar.utils.lookup_icon("system-shutdown")
    },
    {
      "Cancel",
      function() end,
      menubar.utils.lookup_icon("system-log-out")
    },
  },
  theme = {
    border_width=4,
    border_color="#666666",
    height=50,
    width=200,
    font="Helvetica 20"
  },
})

local function quitmenu()
  s = awful.screen.focused()

  quitpopup:show({
    coords = {
      x = (s.geometry.x + s.workarea.width / 2) - (quitpopup.theme.width / 2),
      y = (s.geometry.y + s.workarea.height / 2) - (quitpopup.theme.height / 2),
    }
  })
end

return quitpopup
