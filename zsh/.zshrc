umask 077
typeset -U path fpath cdpath mailpath
autoload -Uz add-zsh-hook

bindkey -e

FZF_COMMON_OPTS='--bind=alt-k:up,alt-j:down,alt-p:up,alt-n:down --info=hidden --color=fg:-1,bg:-1,hl:magenta,hl+:blue,info:blue,prompt:blue,pointer:magenta,marker:blue,spinner:blue,header:blue'
DARK_FZF_OPTS="--color=dark ${FZF_COMMON_OPTS} --color=fg+:white,bg+:#363a4f,gutter:#24273A"
LIGHT_FZF_OPTS="--color=light ${FZF_COMMON_OPTS} --color=fg+:black,bg+:#ccd0da,gutter:#eff1f5"

_set_dark_theme() {
  export FZF_DEFAULT_OPTS="$DARK_FZF_OPTS"
  export FZF_THEME=dark
  export KUBECOLOR_PRESET=dark
  export NVIM_THEME=dark
  export BAT_THEME="Catppuccin Macchiato"
  export COMPLETION_HIGHLIGHT_COLOR="ma=1;48;2;54;58;79;38;2;255;255;255"
}

_set_light_theme() {
  export FZF_DEFAULT_OPTS="$LIGHT_FZF_OPTS"
  export FZF_THEME=light
  export KUBECOLOR_PRESET=light
  export NVIM_THEME=light
  export BAT_THEME="Catppuccin Latte"
  export COMPLETION_HIGHLIGHT_COLOR="ma=1;48;2;204;208;218;38;2;0;0;0"
}

ZSH_CACHE_DIR="$HOME/.cache/zsh"

if [[ -n "$FZF_THEME" ]]; then
  _theme="$FZF_THEME"
elif [[ -f $ZSH_CACHE_DIR/theme ]]; then
  _theme=$(<$ZSH_CACHE_DIR/theme)
else
  if plutil -extract "AppleInterfaceStyle" raw ~/Library/Preferences/.GlobalPreferences.plist &>/dev/null; then
    _theme="dark"
  else
    _theme="light"
  fi
  mkdir -p "$ZSH_CACHE_DIR"
  echo "$_theme" > "$ZSH_CACHE_DIR/theme"
fi

if [[ "$_theme" == "dark" ]]; then
  _set_dark_theme
else
  _set_light_theme
fi
unset _theme

export MANPAGER='nvim +Man!'
path+=("$HOME/go/bin")
export XDG_CONFIG_HOME="$HOME/.config"
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/.ripgreprc"

export HOMEBREW_BUNDLE_NO_DESCRIBE=1
export HOMEBREW_NO_ANALYTICS=1

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

alias ld='lazydocker'
alias lg='lazygit'

alias la='eza -la --group-directories-first --icons=always'
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
HISTSIZE=100000
SAVEHIST=$HISTSIZE
export HISTORY_IGNORE="(*password*|*passwd*|*secret*|*token*|*api_key*|*apikey*|*auth*|*bearer*)"

setopt AUTO_CD
setopt AUTO_PUSHD
setopt EXTENDED_GLOB
setopt GLOBDOTS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INTERACTIVE_COMMENTS
setopt PROMPT_SUBST
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS
setopt PUSHD_SILENT
setopt SHARE_HISTORY

[[ -d "$ZSH_CACHE_DIR/completions" ]] || mkdir -p "$ZSH_CACHE_DIR/completions"
fpath=("$ZSH_CACHE_DIR/completions" $fpath)

_zwc() {
  emulate -L zsh
  zmodload zsh/files 2>/dev/null
  local src="$1" zwc="$2"
  local lock="${zwc}.lock"

  local -a expired_lock
  expired_lock=( ${lock}(Nms+5) )
  if (( $#expired_lock )); then
    rm -rf "${expired_lock[@]}" 2>/dev/null
  fi

  if [[ -d "$lock" ]]; then
    return 0
  fi

  mkdir "$lock" 2>/dev/null || return 0

  if zcompile "$lock/out.zwc" "$src" 2>/dev/null; then
    mv -f "$lock/out.zwc" "$zwc" 2>/dev/null
  fi
  rm -rf "$lock"
}

_zcache() {
  emulate -L zsh
  local dest="$1"; shift
  local tmp
  tmp=$(mktemp "$ZSH_CACHE_DIR/${dest:t}.XXXXXX") || return 1
  "$@" > "$tmp" 2>/dev/null || { rm -f "$tmp"; return 1 }
  mv -f "$tmp" "$dest" 2>/dev/null || { rm -f "$tmp"; return 1 }
  _zwc "$dest" "$dest.zwc"
}

() {
  autoload -Uz compinit
  local brew_completions="/opt/homebrew/share/zsh/site-functions"
  local custom_completions="$ZSH_CACHE_DIR/completions"
  local _compdump="$ZSH_CACHE_DIR/zcompdump"
  local cached="$ZSH_CACHE_DIR/java_home"
  local cached_path=""

  if [[ -f "$_compdump" && \
        ! "$HOME/.zshrc" -nt "$_compdump" && \
        ! "$HOME/.zprofile" -nt "$_compdump" && \
        ( ! -d "$brew_completions" || ! "$brew_completions" -nt "$_compdump" ) && \
        ( ! -d "$custom_completions" || ! "$custom_completions" -nt "$_compdump" ) ]]; then
    compinit -d "$_compdump" -C
  else
    compinit -d "$_compdump" -i
    touch "$_compdump" 2>/dev/null
    { _zwc "$_compdump" "$_compdump.zwc" } &>/dev/null &!
  fi

  compinit() { : }
  _restore_compinit() {
    unfunction compinit 2>/dev/null
    autoload -Uz compinit
    add-zsh-hook -d precmd _restore_compinit
    unfunction _restore_compinit
  }
  add-zsh-hook precmd _restore_compinit
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
      echo "$real_path" > "$cached" 2>/dev/null
    fi
  fi

  if (( $+commands[zoxide] )); then
    local _zoxide_path=$commands[zoxide]
    if [[ ! -f "$ZSH_CACHE_DIR/zoxide_init.zsh" || "$_zoxide_path" -nt "$ZSH_CACHE_DIR/zoxide_init.zsh" ]]; then
      _zcache "$ZSH_CACHE_DIR/zoxide_init.zsh" zoxide init zsh
    fi
    [[ -r "$ZSH_CACHE_DIR/zoxide_init.zsh" ]] && source "$ZSH_CACHE_DIR/zoxide_init.zsh"
  fi

  if (( $+commands[fzf] )); then
    local _fzf_path=$commands[fzf]
    if [[ ! -f "$ZSH_CACHE_DIR/fzf_init.zsh" || "$_fzf_path" -nt "$ZSH_CACHE_DIR/fzf_init.zsh" ]]; then
      _zcache "$ZSH_CACHE_DIR/fzf_init.zsh" fzf --zsh
    fi
    [[ -r "$ZSH_CACHE_DIR/fzf_init.zsh" ]] && source "$ZSH_CACHE_DIR/fzf_init.zsh"
  fi

  if (( $+commands[kubectl] )); then
    compdef kubecolor=kubectl
  fi
}

autoload -Uz down-line-or-beginning-search && zle -N down-line-or-beginning-search
autoload -Uz edit-command-line && zle -N edit-command-line
autoload -Uz up-line-or-beginning-search && zle -N up-line-or-beginning-search
autoload -Uz zmv
zle_highlight=('paste:none')

bindkey ' ' magic-space
bindkey '^N' down-line-or-beginning-search
bindkey '^P' up-line-or-beginning-search
bindkey '^X^E' edit-command-line
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[[Z' reverse-menu-complete
bindkey '^[e' edit-command-line
bindkey '^[h' backward-char
bindkey '^[j' down-line-or-beginning-search
bindkey '^[k' up-line-or-beginning-search
bindkey '^[l' forward-char
bindkey '^[n' down-line-or-beginning-search
bindkey '^[p' up-line-or-beginning-search

zstyle ':completion:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}' '+m:{_-}={-_}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache yes
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'
zstyle -e ':completion:*' list-colors 'reply=( "$COMPLETION_HIGHLIGHT_COLOR" ${(s.:.)LS_COLORS} )'
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'

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

j() {
  unset JAVA_HOME
  if [[ -n "$1" ]]; then
    local version="$1"
    if [[ "$version" == "8" ]]; then
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

jt() {
  unset -f jt
  source "$HOME/Dotfiles/scripts/jt"
  jt "$@"
}

__CACHED_GITDIR=""
__CACHED_PWD=""
__CURRENT_GIT_BRANCH=""

zmodload -F zsh/stat b:zstat 2>/dev/null
typeset -g -i __HAS_ZSTAT=$(( $+builtins[zstat] ))

_update_git_branch() {
  local gitdir=""
  local -i resolved=0

  if [[ "$PWD" == "$__CACHED_PWD" ]]; then
    gitdir="$__CACHED_GITDIR"
    if [[ -z "$gitdir" && -e ".git" ]]; then
      gitdir=".git"
    else
      resolved=1
    fi
  else
    local dir="${PWD:A}"

    local initial_device
    if (( __HAS_ZSTAT )); then
      local -a stats
      zstat -A stats +device "$dir" 2>/dev/null
      initial_device=$stats[1]
    fi

    local parent_device
    local -a pstats
    local parent_dir
    while [[ "$dir" != "/" && ! -e "$dir/.git" ]]; do
      parent_dir="${dir:h}"

      if (( __HAS_ZSTAT )); then
        pstats=()
        zstat -A pstats +device "$parent_dir" 2>/dev/null
        parent_device=$pstats[1]
        if [[ -n "$parent_device" && "$parent_device" != "$initial_device" ]]; then
          break
        fi
      fi

      dir="$parent_dir"
    done
    if [[ "$dir" != "/" && -e "$dir/.git" ]]; then
      gitdir="$dir/.git"
    elif [[ -e "/.git" ]]; then
      gitdir="/.git"
    fi
  fi

  if (( ! resolved )); then
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

    __CACHED_GITDIR="$gitdir"
    __CACHED_PWD="$PWD"
  fi

  if [[ -z "$gitdir" ]]; then
    __CURRENT_GIT_BRANCH=""
    psvar[1]=""
    return
  fi

  local head_content
  head_content=$(<"$gitdir/HEAD") 2>/dev/null
  if [[ -z "$head_content" ]]; then
    __CURRENT_GIT_BRANCH=""
    psvar[1]=""
    return
  fi
  local branch=""

  local -a states
  states=( "$gitdir"/(rebase-merge|rebase-apply|MERGE_HEAD|CHERRY_PICK_HEAD|REVERT_HEAD|BISECT_LOG)(N:t) )

  if (( $#states )); then
    local rebase_dir=""
    local op=""
    local step=""
    local total=""

    if (( ${states[(I)rebase-merge]} )); then
      rebase_dir="$gitdir/rebase-merge"
      if [[ -f "$rebase_dir/interactive" ]]; then
        op="REBASE-i"
      else
        op="REBASE-m"
      fi
      step=$(<"$rebase_dir/msgnum") 2>/dev/null
      total=$(<"$rebase_dir/end") 2>/dev/null
    elif (( ${states[(I)rebase-apply]} )); then
      rebase_dir="$gitdir/rebase-apply"
      if [[ -f "$rebase_dir/rebasing" ]]; then
        op="REBASE"
      elif [[ -f "$rebase_dir/applying" ]]; then
        op="AM"
      else
        op="AM/REBASE"
      fi
      step=$(<"$rebase_dir/next") 2>/dev/null
      total=$(<"$rebase_dir/last") 2>/dev/null
    fi

    if [[ -n "$rebase_dir" ]]; then
      local head_name
      head_name=$(<"$rebase_dir/head-name") 2>/dev/null
      if [[ "$head_name" = refs/heads/* ]]; then
        branch="${head_name#refs/heads/}"
      fi
    fi
  fi

  if [[ -z "$branch" ]]; then
    if [[ "$head_content" = ref:\ refs/heads/* ]]; then
      branch="${head_content#ref: refs/heads/}"
    elif [[ "$head_content" = ref:\ * ]]; then
      branch="${head_content#ref: }"
    elif [[ -n "$head_content" ]]; then
      branch="$head_content"
    fi
  fi

  if (( $#states )); then
    if [[ -n "$op" ]]; then
      if [[ -n "$step" && -n "$total" ]]; then
        branch="${branch}|${op} ${step}/${total}"
      else
        branch="${branch}|${op}"
      fi
    fi

    if (( ${states[(I)MERGE_HEAD]} )); then
      branch="${branch}|MERGING"
    elif (( ${states[(I)CHERRY_PICK_HEAD]} )); then
      branch="${branch}|CHERRY-PICKING"
    elif (( ${states[(I)REVERT_HEAD]} )); then
      branch="${branch}|REVERTING"
    elif (( ${states[(I)BISECT_LOG]} )); then
      branch="${branch}|BISECTING"
    fi
  fi

  branch="${branch%$'\r'}"
  if [[ -n "$branch" ]]; then
    psvar[1]="$branch"
    __CURRENT_GIT_BRANCH="%F{magenta}%f %F{green}%1v%f "
  else
    psvar[1]=""
    __CURRENT_GIT_BRANCH=""
  fi
}

add-zsh-hook precmd _update_git_branch

PROMPT='%(!.%F{red}root %f.)%F{blue}%~%f ${__CURRENT_GIT_BRANCH}%(1j.%F{yellow}* %f.)
%(?.%F{green}.%F{red})❭%f '

KITTY_CACHE_DIR="$HOME/.cache/kitty"
[[ -d "$KITTY_CACHE_DIR" ]] || mkdir -p "$KITTY_CACHE_DIR"

if [[ -n "$KITTY_INSTALLATION_DIR" ]]; then
  export KITTY_SHELL_INTEGRATION="enabled"
  autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
  kitty-integration
  unfunction kitty-integration
fi

if [[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]]; then
  source "$HOME/google-cloud-sdk/path.zsh.inc"
fi

() {
  local _gcloud_inc="$HOME/google-cloud-sdk/completion.zsh.inc"

  if [[ -f "$_gcloud_inc" ]]; then
    _lazy_gcloud_completion() {
      source "$HOME/google-cloud-sdk/completion.zsh.inc"
      local cmd="${service:-$words[1]}"
      local real_service="$_comps[$cmd]"
      if [[ -n "$real_service" && "$real_service" != "_lazy_gcloud_completion" ]]; then
        eval "$real_service"
      fi
    }
    compdef _lazy_gcloud_completion gcloud bq gsutil
  fi
}

if [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
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
  local f zwc
  for f in "$HOME/.zshrc" "$HOME/.zprofile"; do
    [[ -f "$f" ]] || continue
    zwc="$f.zwc"
    if [[ ! -f "$zwc" || "$f" -nt "$zwc" ]]; then
      { _zwc "$f" "$zwc" } &>/dev/null &!
    fi
  done
}

unfunction _zcache _zwc
