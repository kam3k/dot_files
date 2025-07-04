#!/usr/bin/sh

printf '[' > compile_commands.json
find ~/Dev/autonomy_ws/build -type f -name 'compile_commands.json' -exec sh -c "cat {} | tail -n+2 | head -n-1 && printf ','" >> ~/Dev/autonomy_ws/compile_commands.json \;
sed -i '$s/.$//' compile_commands.json
printf '\n]\n' >> compile_commands.json
ln -sf ~/Dev/autonomy_ws/compile_commands.json ~/Dev/autonomy_ws/src
