stow_dirs = $(filter-out scripts/, $(wildcard */))

bat_themes_dir = bat/.config/bat/themes
bat_cache = $(HOME)/.cache/bat/themes.bin

.PHONY : stow
stow :
	stow --target $(HOME) --verbose $(stow_dirs)
	@$(MAKE) --no-print-directory bat-cache

.PHONY : restow
restow :
	stow --target $(HOME) --verbose --restow $(stow_dirs)
	@$(MAKE) --no-print-directory bat-cache

.PHONY : delete
delete :
	stow --target $(HOME) --verbose --delete $(stow_dirs)

.PHONY : bat-cache
bat-cache :
	@command -v bat >/dev/null 2>&1 || { echo "bat not installed, skipping cache build"; exit 0; }
	@if [ ! -f "$(bat_cache)" ] || [ -n "$$(find "$(bat_themes_dir)" -name '*.tmTheme' -newer "$(bat_cache)" 2>/dev/null)" ]; then \
		bat cache --build; \
	else \
		echo "bat theme cache up to date"; \
	fi
