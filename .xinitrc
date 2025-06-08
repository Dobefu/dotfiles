#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    # shellcheck source=/dev/null
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Set the QT5 theme
export QT_QPA_PLATFORMTHEME=qt5ct

# disable DPI scaling for QT applications
export QT_AUTO_SCREEN_SCALE_FACTOR=0

# Reload XResources
xrdb -merge /home/dobefu/.Xresources

mpd &
picom &
/usr/libexec/polkit-gnome-authentication-agent-1 &
/home/dobefu/.screenlayout/default.sh

xmodmap ~/.Xmodmap
