bindkey -e

alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gd='git diff'
alias gf='git commit --amend --no-edit'
alias gl='git log'
alias gp='git push'
alias gr='git rebase'
alias gs='git status -sb'
alias gt='git checkout'
alias gu='git pull'
gll() { git log --graph --topo-order --abbrev-commit --date=short --decorate --all --boundary --pretty=format:"%Cgreen%ad %C(yellow)%h%Creset%C(red)%d%Creset %s %Cblue[%cn]%Creset" "$@"; }

alias k='kubecolor'
alias ks='kubens'
alias kx='kubectx'

alias c='colima'
alias cn='colima nerdctl'
alias cc='colima nerdctl compose'
alias cnn='colima nerdctl network rm $(colima nerdctl network ls -q)'
alias cnp='colima nerdctl system prune --volumes -af'
alias cnv='colima nerdctl volume rm $(colima nerdctl volume ls -q)'

alias d='docker'
alias dc='docker compose'
alias dn='docker network rm $(docker network ls -q)'
alias dp='docker system prune --volumes -af'
alias dv='docker volume rm $(docker volume ls -q)'

alias la='ls -lah'
alias ld='lazydocker'
alias lg='lazygit'
alias ll='ls -lh'
alias ls='gls --color=auto --group-directories-first'

alias bu='brew update && brew upgrade -g && brew cleanup'
alias md='mvn dependency:tree'
alias mi='mvn clean install -am -T 0.5C -U -DskipTests'
alias mt='mvn clean test -am -T 0.5C -U'
alias pip=pip3
alias python=python3
alias snykt='snyk test --maven-aggregate-project -- -P Symphony'
alias sudo='sudo '
alias v=vi
alias vi=vim

if type nvim >/dev/null 2>&1; then
  alias vim=nvim
  alias vimdiff="nvim -d"
  export EDITOR=nvim
else
  export EDITOR=vim
fi

autoload -U colors && colors
autoload -U compinit && compinit -u
autoload -U down-line-or-beginning-search && zle -N down-line-or-beginning-search
autoload -U edit-command-line && zle -N edit-command-line
autoload -U up-line-or-beginning-search && zle -N up-line-or-beginning-search
zle_highlight=('paste:none')

bindkey '^N' down-line-or-beginning-search
bindkey '^P' up-line-or-beginning-search
bindkey '^X^E' edit-command-line
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[e' edit-command-line
bindkey '^[h' backward-char
bindkey '^[j' down-line-or-beginning-search
bindkey '^[k' up-line-or-beginning-search
bindkey '^[l' forward-char
bindkey '^[n' down-line-or-beginning-search
bindkey '^[p' up-line-or-beginning-search

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=$HISTSIZE

setopt AUTO_CD
setopt AUTO_PUSHD
setopt EXTENDED_GLOB
setopt GLOBDOTS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt INTERACTIVE_COMMENTS
setopt PROMPT_SUBST
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS
setopt PUSHD_SILENT
setopt SHARE_HISTORY

export FZF_ALT_C_COMMAND="fd -t d --exclude '{.git,.npm,.cache,.venv,node_modules}' . $HOME"
export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --no-ignore -g "!{.git,.cache,.clangd,.venv,.DS_Store,node_modules}" 2> /dev/null'
export FZF_DEFAULT_COMMAND=$FZF_CTRL_T_COMMAND
export LSCOLORS=exfxfxfxcxgxgxbxbxdxdx
export LS_COLORS="di=34:ln=35:so=35:pi=35:ex=32:bd=36:cd=36:su=31:sg=31:tw=33:ow=33:st=34"

DARK_FZF_OPTS='--bind=alt-k:up,alt-j:down,alt-p:up,alt-n:down --info=hidden --color=dark --color=fg:-1,bg:-1,hl:magenta,fg+:white,bg+:#363a4f,hl+:blue --color=info:blue,prompt:blue,pointer:magenta,marker:blue,spinner:blue,header:blue,gutter:"#24273A"'
LIGHT_FZF_OPTS='--bind=alt-k:up,alt-j:down,alt-p:up,alt-n:down --info=hidden --color=light --color=fg:-1,bg:-1,hl:magenta,fg+:black,bg+:#ccd0da,hl+:blue --color=info:blue,prompt:blue,pointer:magenta,marker:blue,spinner:blue,header:blue,gutter:"#eff1f5"'

BTOP_DARK_THEME="tokyo-storm"
BTOP_LIGHT_THEME="kanagawa-lotus"

BTOP_CONFIG_FILE="$HOME/.config/btop/btop.conf"
K9S_CONFIG_FILE="$HOME/Library/Application Support/k9s/config.yaml"

update_btop_theme() {
  local theme=$1
  sed -i '' "s/^color_theme = \".*\"/color_theme = \"$theme\"/" "$BTOP_CONFIG_FILE" 2>/dev/null
  sed -i '' "s/^theme_background = .*/theme_background = False/" "$BTOP_CONFIG_FILE" 2>/dev/null
  sed -i '' "s/^vim_keys = .*/vim_keys = True/" "$BTOP_CONFIG_FILE" 2>/dev/null
}

case "$FZF_THEME" in
  dark) export FZF_DEFAULT_OPTS="$DARK_FZF_OPTS" ;;
  light) export FZF_DEFAULT_OPTS="$LIGHT_FZF_OPTS" ;;
  *)
    if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark; then
      export FZF_DEFAULT_OPTS="$DARK_FZF_OPTS"
      export FZF_THEME=dark
      export K9S_THEME=dark
      export KUBECOLOR_PRESET=dark
      export NVIM_THEME=dark
      update_btop_theme "$BTOP_DARK_THEME"
    else
      export FZF_DEFAULT_OPTS="$LIGHT_FZF_OPTS"
      export FZF_THEME=light
      export K9S_THEME=light
      export KUBECOLOR_PRESET=light
      export NVIM_THEME=light
      update_btop_theme "$BTOP_LIGHT_THEME"
    fi
    ;;
esac

trap 'export FZF_DEFAULT_OPTS="$DARK_FZF_OPTS" FZF_THEME=dark KUBECOLOR_PRESET=dark NVIM_THEME=dark; \
      yq -i ".k9s.ui.skin = \"dark\"" "$K9S_CONFIG_FILE"' USR1

trap ' export FZF_DEFAULT_OPTS="$LIGHT_FZF_OPTS" FZF_THEME=light KUBECOLOR_PRESET=light NVIM_THEME=light; \
      yq -i ".k9s.ui.skin = \"light\"" "$K9S_CONFIG_FILE"' USR2

zstyle ':completion:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}' '+m:{_-}={-_}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache yes
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'

export HOMEBREW_NO_ANALYTICS=1
export JAVA_HOME=$(/usr/libexec/java_home)
export MANPAGER='nvim +Man!'
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/.ripgreprc"

man() {
  LESS_TERMCAP_md=$'\e[00;34m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[00;32m' \
  command man "$@"
}

j() {
  unset JAVA_HOME
  if [ -n "$1" ]; then
    local version="$1"
    if [ "$version" = "8" ]; then
      version="1.8"
    fi
    export JAVA_HOME=$(/usr/libexec/java_home -v "$version")
  else
    export JAVA_HOME=$(/usr/libexec/java_home)
  fi
  java -version
}

git_branch() {
  git branch --no-color 2>/dev/null | sed -E -n "s/^\* (.*)/%F{magenta}%f %F{green}\1%f /p"
}

line=$'\n'
#PROMPT='%(!.%F{cyan}.%F{blue})${PWD/#$HOME/~}%f $(git_branch)%(1j.%F{yellow}* %f.)${line}%(0?;%F{magenta}➜%f;%F{red}➜%f) '
#PROMPT='%(!.%F{cyan}.%F{blue})${PWD/#$HOME/~}%f $(git_branch)%(1j.%F{yellow}* %f.)%(0?;;%F{red}[!] %? %f)${line}'
PROMPT='%(!.%F{cyan}.%F{blue})${PWD/#$HOME/~}%f $(git_branch)%(1j.%F{yellow}* %f.)%(0?;;%F{red} %f)${line}'

eval "$(zoxide init zsh)"

source <(fzf --zsh)
source /opt/homebrew/Cellar/zsh-syntax-highlighting/*/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source <(kubectl completion zsh)
compdef kubecolor=kubectl

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_HIGHLIGHTERS+=(brackets pattern)
ZSH_HIGHLIGHT_STYLES[arg0]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[autodirectory]='none'
ZSH_HIGHLIGHT_STYLES[path]='none'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=green'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=green'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=red'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=red'

if test -n "$KITTY_INSTALLATION_DIR"; then
  export KITTY_SHELL_INTEGRATION="enabled"
  autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
  kitty-integration
  unfunction kitty-integration
fi
