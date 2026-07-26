# Static equivalent of `eval "$(/opt/homebrew/bin/brew shellenv)"`
# Avoids spawning the brew Ruby process on every login shell (kitty runs --login per tab/split).
# Regenerate with `brew shellenv` if Homebrew ever relocates.

typeset -U path fpath

export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";

fpath=("/opt/homebrew/share/zsh/site-functions" $fpath)

# /etc/zprofile already ran path_helper before this file, so $path holds the macOS
# base PATH. Just prepend Homebrew's bin/sbin.
path=("/opt/homebrew/bin" "/opt/homebrew/sbin" $path)
export PATH

[ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
