function set_wallpaper
  ln -sf $argv ~/.wallpaper
  feh --bg-scale ~/.wallpaper
end
