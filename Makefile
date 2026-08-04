stow_dirs = $(filter-out scripts/, $(wildcard */))

bat_cache = $(HOME)/.cache/bat/themes.bin
bat_themes_dir = bat/.config/bat/themes

nvim_state = $(HOME)/.local/state/nvim
nvim_logs = $(addprefix $(nvim_state)/, conform.log dap.log lsp.log mason.log nio.log nvim.log)

.PHONY : stow
stow :
	stow --target $(HOME) --verbose $(stow_dirs)
	@$(MAKE) --no-print-directory bat-cache
	@$(MAKE) --no-print-directory nvim-logs

.PHONY : restow
restow :
	stow --target $(HOME) --verbose --restow $(stow_dirs)
	@$(MAKE) --no-print-directory bat-cache
	@$(MAKE) --no-print-directory nvim-logs

.PHONY : delete
delete :
	stow --target $(HOME) --verbose --delete $(stow_dirs)
	@for log in $(nvim_logs); do \
		if [ "$$(readlink "$$log")" = "/dev/null" ]; then \
			rm -f "$$log"; \
			echo "restored $${log##*/}"; \
		fi; \
	done

.PHONY : bat-cache
bat-cache :
	@command -v bat >/dev/null 2>&1 || { echo "bat not installed, skipping cache build"; exit 0; }
	@if [ ! -f "$(bat_cache)" ] || [ -n "$$(find "$(bat_themes_dir)" -name '*.tmTheme' -newer "$(bat_cache)" 2>/dev/null)" ]; then \
		bat cache --build; \
	else \
		echo "bat theme cache up to date"; \
	fi

.PHONY : macos
macos :
	@./scripts/setup-macos

.PHONY : nvim-logs
nvim-logs :
	@mkdir -p "$(nvim_state)"
	@for log in $(nvim_logs); do \
		if [ -d "$$log" ] && [ ! -L "$$log" ]; then \
			echo "$$log is a directory, refusing to replace it"; \
			exit 1; \
		fi; \
		if [ "$$(readlink "$$log")" = "/dev/null" ]; then \
			echo "$${log##*/} already silenced"; \
		else \
			ln -sfn /dev/null "$$log" && echo "silenced $${log##*/}"; \
		fi; \
	done
