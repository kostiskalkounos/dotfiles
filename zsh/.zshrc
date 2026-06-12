bindkey -e

export HOMEBREW_NO_ANALYTICS=1
export MANPAGER='nvim +Man!'
export PATH="$PATH:$HOME/go/bin"
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/.ripgreprc"

export XDG_CONFIG_HOME="$HOME/.config"
export ZSH_CACHE_DIR="$HOME/.cache/zsh"
[[ -d "$ZSH_CACHE_DIR" ]] || mkdir -p "$ZSH_CACHE_DIR"

export LSCOLORS=exfxfxfxcxgxgxbxbxdxdx
export LS_COLORS="di=34:ln=35:so=35:pi=35:ex=32:bd=36:cd=36:su=31:sg=31:tw=33:ow=33:st=34"

export FZF_ALT_C_COMMAND="fd -t d --hidden --follow --exclude '{.git,.npm,.cache,.venv,node_modules}' . $HOME"
export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --no-ignore -g "!{.git,.cache,.clangd,.venv,.DS_Store,node_modules}" 2> /dev/null'
export FZF_DEFAULT_COMMAND=$FZF_CTRL_T_COMMAND

if (( $+commands[nvim] )); then
  export EDITOR=nvim
  alias v=nvim
  alias vi=nvim
  alias vim=nvim
  alias vimdiff="nvim -d"
else
  export EDITOR=vim
  alias v=vim
  alias vi=vim
fi

alias ga='git add'
alias gap='git add --patch'
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
alias dl='sudo ln -s ~/.colima/default/docker.sock /var/run/docker.sock'
alias dn='docker network rm $(docker network ls -q)'
alias dp='docker system prune --volumes -af'
alias dv='docker volume rm $(docker volume ls -q)'

alias la='eza -la --group-directories-first --icons=always'
alias ld='lazydocker'
alias lg='lazygit'
alias ll='eza -l --group-directories-first --icons=always'
alias ls='eza --group-directories-first --icons=always'

alias bu='brew update && brew upgrade -g && brew cleanup'
alias f=yazi
alias md='mvn dependency:tree'
alias mi='mvn clean install -am -T 0.5C -U -DskipTests'
alias mt='mvn clean test -am -T 0.5C -U'
alias pip=pip3
alias python=python3
alias snykt='snyk test --maven-aggregate-project -- -P Symphony'
alias sudo='sudo '

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=$HISTSIZE

setopt AUTO_CD
setopt AUTO_PUSHD
setopt EXTENDED_GLOB
setopt GLOBDOTS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt INTERACTIVE_COMMENTS
setopt PROMPT_SUBST
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS
setopt PUSHD_SILENT
setopt SHARE_HISTORY

[[ -d "$ZSH_CACHE_DIR/completions" ]] || mkdir -p "$ZSH_CACHE_DIR/completions"
fpath=("$ZSH_CACHE_DIR/completions" $fpath)

() {
  if (( $+commands[kubectl] )); then
    local _kubectl_path=$commands[kubectl]
    if [[ ! -f "$ZSH_CACHE_DIR/completions/_kubectl" || "$_kubectl_path" -nt "$ZSH_CACHE_DIR/completions/_kubectl" ]]; then
      kubectl completion zsh > "$ZSH_CACHE_DIR/completions/_kubectl" 2>/dev/null
    fi
  fi

  autoload -U compinit
  local mtime
  zmodload -F zsh/stat b:zstat
  zmodload zsh/datetime 2>/dev/null
  if zstat -A mtime +mtime "${ZDOTDIR:-$HOME}/.zcompdump" 2>/dev/null && (( EPOCHSECONDS - mtime < 86400 )); then
    compinit -C -u
  else
    compinit -u
    { zcompile "${ZDOTDIR:-$HOME}/.zcompdump" } &>/dev/null &!
  fi

  local cached="$HOME/.cache/java_home"
  local cached_path=""
  if [[ -f "$cached" ]]; then
    cached_path=$(<"$cached")
  fi

  if [[ -d "$cached_path" ]]; then
    export JAVA_HOME="$cached_path"
  else
    local real_path
    real_path=$(/usr/libexec/java_home 2>/dev/null)
    if [[ -n "$real_path" ]]; then
      export JAVA_HOME="$real_path"
      mkdir -p "$HOME/.cache"
      echo "$real_path" > "$cached" 2>/dev/null
    fi
  fi

  if (( $+commands[zoxide] )); then
    local _zoxide_path=$commands[zoxide]
    if [[ ! -f $HOME/.cache/zoxide_init.zsh || "$_zoxide_path" -nt $HOME/.cache/zoxide_init.zsh ]]; then
      mkdir -p $HOME/.cache
      zoxide init zsh > $HOME/.cache/zoxide_init.zsh 2>/dev/null
      zcompile $HOME/.cache/zoxide_init.zsh 2>/dev/null
    fi
    source $HOME/.cache/zoxide_init.zsh
  fi

  if (( $+commands[fzf] )); then
    local _fzf_path=$commands[fzf]
    if [[ ! -f $HOME/.cache/fzf_init.zsh || "$_fzf_path" -nt $HOME/.cache/fzf_init.zsh ]]; then
      mkdir -p $HOME/.cache
      fzf --zsh > $HOME/.cache/fzf_init.zsh 2>/dev/null
      zcompile $HOME/.cache/fzf_init.zsh 2>/dev/null
    fi
    source $HOME/.cache/fzf_init.zsh
  fi

  if (( $+commands[kubectl] )); then
    compdef kubecolor=kubectl
  fi
}

autoload -U down-line-or-beginning-search && zle -N down-line-or-beginning-search
autoload -U edit-command-line && zle -N edit-command-line
autoload -U up-line-or-beginning-search && zle -N up-line-or-beginning-search
autoload zmv
zle_highlight=('paste:none')

bindkey ' ' magic-space
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

zstyle ':completion:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}' '+m:{_-}={-_}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache yes
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'

FZF_COMMON_OPTS='--bind=alt-k:up,alt-j:down,alt-p:up,alt-n:down --info=hidden --color=fg:-1,bg:-1,hl:magenta,hl+:blue --color=info:blue,prompt:blue,pointer:magenta,marker:blue,spinner:blue,header:blue'
DARK_FZF_OPTS="--color=dark ${FZF_COMMON_OPTS} --color=fg+:white,bg+:#363a4f,gutter:#24273A"
LIGHT_FZF_OPTS="--color=light ${FZF_COMMON_OPTS} --color=fg+:black,bg+:#ccd0da,gutter:#eff1f5"

if [[ -n "$FZF_THEME" ]]; then
  _theme="$FZF_THEME"
elif [[ -f $HOME/.cache/theme ]]; then
  _theme=$(<$HOME/.cache/theme)
else
  if defaults read -g AppleInterfaceStyle &>/dev/null; then
    _theme="dark"
  else
    _theme="light"
  fi
  mkdir -p "$HOME/.cache"
  echo "$_theme" > "$HOME/.cache/theme"
fi

_set_dark_theme() {
  export FZF_DEFAULT_OPTS="$DARK_FZF_OPTS"
  export FZF_THEME=dark
  export KUBECOLOR_PRESET=dark
  export NVIM_THEME=dark
  export BAT_THEME="Catppuccin Macchiato"
}

_set_light_theme() {
  export FZF_DEFAULT_OPTS="$LIGHT_FZF_OPTS"
  export FZF_THEME=light
  export KUBECOLOR_PRESET=light
  export NVIM_THEME=light
  export BAT_THEME="Catppuccin Latte"
}

if [[ "$_theme" == "dark" ]]; then
  _set_dark_theme
else
  _set_light_theme
fi
unset _theme

TRAPUSR1() {
  _set_dark_theme
  if [[ -o interactive ]] && zle; then
    zle -I && zle reset-prompt
  fi
}

TRAPUSR2() {
  _set_light_theme
  if [[ -o interactive ]] && zle; then
    zle -I && zle reset-prompt
  fi
}

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
    local java_path
    java_path=$(/usr/libexec/java_home -v "$version" 2>/dev/null)
    if [[ -n "$java_path" ]]; then
      export JAVA_HOME="$java_path"
    else
      echo "Java version $version not found."
      return 1
    fi
  else
    export JAVA_HOME=$(/usr/libexec/java_home)
  fi
  java -version
}

__CURRENT_GIT_BRANCH=""

_update_git_branch() {
  local gitdir=""
  local dir="$PWD"

  while [[ "$dir" != "/" && ! -e "$dir/.git" ]]; do
    dir="${dir:h}"
  done
  if [[ "$dir" != "/" ]]; then
    gitdir="$dir/.git"
  elif [[ -e "/.git" ]]; then
    gitdir="/.git"
  fi

  if [[ -n "$gitdir" && -f "$gitdir" ]]; then
    local line
    line=$(<"$gitdir") 2>/dev/null
    if [[ "$line" = gitdir:\ * ]]; then
      local rel_gitdir="${line#gitdir: }"
      if [[ "$rel_gitdir" = /* ]]; then
        gitdir="$rel_gitdir"
      else
        gitdir="${gitdir:h}/$rel_gitdir"
      fi
    fi
    if [[ ! -d "$gitdir" ]]; then
      gitdir=""
    fi
  fi

  if [[ -z "$gitdir" ]]; then
    __CURRENT_GIT_BRANCH=""
    return
  fi

  local head_content
  head_content=$(<"$gitdir/HEAD") 2>/dev/null
  local branch=""

  local rebase_dir=""
  if [[ -e "$gitdir/rebase-merge" ]]; then
    rebase_dir="$gitdir/rebase-merge"
  elif [[ -e "$gitdir/rebase-apply" ]]; then
    rebase_dir="$gitdir/rebase-apply"
  fi

  if [[ -n "$rebase_dir" ]]; then
    local op="rebase"
    if [[ "$rebase_dir" = */rebase-apply && -e "$rebase_dir/applying" ]]; then
      op="am"
    fi

    local head_name
    head_name=$(<"$rebase_dir/head-name") 2>/dev/null
    if [[ "$head_name" = refs/heads/* ]]; then
      branch="${op}|${head_name#refs/heads/}"
    else
      if [[ "$head_content" = ref:\ refs/heads/* ]]; then
        branch="${op}|${head_content#ref: refs/heads/}"
      elif [[ -n "$head_content" ]]; then
        branch="${op}|${head_content:0:7}"
      fi
    fi
  else
    if [[ "$head_content" = ref:\ refs/heads/* ]]; then
      branch="${head_content#ref: refs/heads/}"
    elif [[ -n "$head_content" ]]; then
      branch="${head_content:0:7}"
    fi
  fi

  if [[ -e "$gitdir/MERGE_HEAD" ]]; then
    branch="${branch}|MERGING"
  elif [[ -e "$gitdir/CHERRY_PICK_HEAD" ]]; then
    branch="${branch}|CHERRY-PICKING"
  elif [[ -e "$gitdir/REVERT_HEAD" ]]; then
    branch="${branch}|REVERTING"
  elif [[ -e "$gitdir/BISECT_LOG" ]]; then
    branch="${branch}|BISECTING"
  fi

  branch="${branch%$'\r'}"
  if [[ -n "$branch" ]]; then
    __CURRENT_GIT_BRANCH="%F{magenta}%f %F{green}${branch}%f "
  else
    __CURRENT_GIT_BRANCH=""
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _update_git_branch

PROMPT_NL=$'\n'
PROMPT='%(!.%F{cyan}.%F{blue})${PWD/#$HOME/~}%f ${__CURRENT_GIT_BRANCH}%(1j.%F{yellow}* %f.)%(0?;;%F{red} %f)${PROMPT_NL}'

if [[ -n "$KITTY_INSTALLATION_DIR" ]]; then
  export KITTY_SHELL_INTEGRATION="enabled"
  autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
  kitty-integration
  unfunction kitty-integration
fi

if [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

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

() {
  local zrc="${ZDOTDIR:-$HOME}/.zshrc"
  local zwc="$zrc.zwc"
  if [[ ! -f "$zwc" || "$zrc" -nt "$zwc" ]]; then
    { zcompile "$zrc" } &>/dev/null &!
  fi
}
