while xsetroot -name "`bar`"
do
  sleep 1
done &

feh --bg-scale ~/.wallpaper

sxhkd &
dunst &

xset -b # turn off system beep

setxkbmap -option caps:escape

while :; do
  ssh-agent dwm
done
