#!/usr/bin/env bash

MODE=$1

BTOP_DARK_THEME="tokyo-storm"
BTOP_LIGHT_THEME="kanagawa-lotus"

#GEMINI_SETTINGS="$HOME/.gemini/settings.json"
BTOP_CONFIG_FILE="$HOME/.config/btop/btop.conf"
K9S_CONFIG_FILE="$HOME/Library/Application Support/k9s/config.yaml"

if [ "$MODE" == "dark" ]; then
  #plutil -replace ui.theme -string "Default" "$GEMINI_SETTINGS"
  sed -i '' "s/^color_theme = .*/color_theme = \"$BTOP_DARK_THEME\"/" "$BTOP_CONFIG_FILE" 2>/dev/null
  yq -i '.k9s.ui.skin = "dark"' "$K9S_CONFIG_FILE"
  pkill -USR1 zsh
else
  #plutil -replace ui.theme -string "Default Light" "$GEMINI_SETTINGS"
  sed -i '' "s/^color_theme = .*/color_theme = \"$BTOP_LIGHT_THEME\"/" "$BTOP_CONFIG_FILE" 2>/dev/null
  yq -i '.k9s.ui.skin = "light"' "$K9S_CONFIG_FILE"
  pkill -USR2 zsh
fi

sed -i '' "s/^theme_background = .*/theme_background = False/" "$BTOP_CONFIG_FILE" 2>/dev/null
sed -i '' "s/^vim_keys = .*/vim_keys = True/" "$BTOP_CONFIG_FILE" 2>/dev/null

if pgrep -x "tmux" > /dev/null; then
  tmux source-file "$HOME/.tmux/$MODE.conf" >/dev/null 2>&1
fi
