#!/bin/sh

win=$(yabai -m query --windows --window | jq -re ".id")
$(yabai -m window --display 1)
$(yabai -m window --focus "$win")
