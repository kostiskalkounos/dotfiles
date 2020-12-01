#!/bin/sh

yabai -m window south --stack $(yabai -m query --windows --window | jq -r '.id')
