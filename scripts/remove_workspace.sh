#!/bin/bash

if [[ ! -a $(which wmctrl) ]]; then
  echo "Error: wmctrl is not installed. Please install wmctrl first."
  exit 1
fi

wmctrl -d | wc -l | xargs expr -1 + | xargs wmctrl -n
