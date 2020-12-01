#!/bin/sh

yabai -m window east --stack $(yabai -m query --windows --window | jq -r '.id')
