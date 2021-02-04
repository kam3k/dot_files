sh ~/.screenlayout/laptop-display.sh &

while xsetroot -name "`bar`"
do
  sleep 1
done &

feh --bg-scale ~/sunrise.jpg

sxhkd &
dunst &

while :; do
  ssh-agent dwm
done
