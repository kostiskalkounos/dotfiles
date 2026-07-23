# Static equivalent of `eval "$(/opt/homebrew/bin/brew shellenv)"`
# Avoids spawning the brew Ruby process on every login shell (kitty runs --login per tab/split).
# Regenerate with `brew shellenv` if Homebrew ever relocates.

export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";
fpath[1,0]="/opt/homebrew/share/zsh/site-functions";
export FPATH;

if [[ -f $HOME/.cache/path_helper.zsh ]]; then
  source $HOME/.cache/path_helper.zsh
else
  mkdir -p $HOME/.cache
  local out
  out=$(/usr/libexec/path_helper -s)
  eval "$out"
  echo "$out" > $HOME/.cache/path_helper.zsh 2>/dev/null
  zcompile $HOME/.cache/path_helper.zsh 2>/dev/null
fi

[ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
