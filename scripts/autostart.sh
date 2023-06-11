#!/bin/sh

exec /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

[ -x "$(command -v wl-paste)" ] && [ -x "$(command -v cliphist)" ] && wl-paste --watch cliphist store &
[ -x "$(command -v wl-paste)" ] && [ -x "$(command -v cliphist)" ] && wl-paste --watch pkill -RTMIN+9 waybar &
[ -x "$(command -v workstyle)" ] && pkill workstyle; workstyle > /tmp/workstyle.log &
[ -x "$(command -v playerctl)" ] && pkill playerctl; playerctl -a metadata --format \'{{status}} {{title}}\' --follow | while read line; do pkill -RTMIN+5 waybar; done &

exec systemctl --user import-environment DISPLAY WAYLAND_DISPLAY &
exec hash dbus-update-activation-environment 2>/dev/null && \
    dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY
