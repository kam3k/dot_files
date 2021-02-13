#!/bin/bash

while xsetroot -name "`bar`"
do
  sleep 0.5
done &

feh --bg-scale ~/.wallpaper

sxhkd &
dunst &
udiskie &

xset -b # turn off system beep

setxkbmap -option caps:escape

enact --pos left --watch &

while :; do
  ssh-agent dwm
done
