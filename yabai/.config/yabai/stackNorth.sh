#!/bin/sh

yabai -m window north --stack $(yabai -m query --windows --window | jq -r '.id')
