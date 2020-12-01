#!/bin/sh

yabai -m window west --stack $(yabai -m query --windows --window | jq -r '.id')
