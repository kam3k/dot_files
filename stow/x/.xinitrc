sh ~/.screenlayout/laptop-display.sh &

while xsetroot -name "`bar`"
do
  sleep 1
done &

feh --bg-scale ~/pictures/wallpapers/sunrise.jpg

sxhkd &
dunst &

xset -b # turn off system beep

while :; do
  ssh-agent dwm
done
