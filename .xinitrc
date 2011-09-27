#!/bin/sh

#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
#
#feh --bg-center ~/Desktop/td_1024x768.png
xset +fp /usr/share/fonts/local
xset fp rehash
xset r rate 270
#exec xmonad
#exec xcompmgr -fF
exec ck-launch-session startxfce4

#exec gnome-session
# exec startkde
# exec startxfce4
# exec icewm
# exec openbox
# exec blackbox
# exec fluxbox
# exec ratpoison
# exec dwm
# ... or any other WM of your choosing ...
#  exec xterm
