!#/usr/bin/sh

xrdb -merge ~/.Xresources
udiskie -t &
exec i3
