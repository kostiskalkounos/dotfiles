bindkey -e

alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gd='git diff'
alias gf='git commit --amend --no-edit'
alias gl='git log --oneline --all'
alias gll='git log --graph --topo-order --abbrev-commit --date=short --decorate --all --boundary --pretty=format:"%Cgreen%ad %C(yellow)%h%Creset%C(red)%d%Creset %s %Cblue[%cn]%Creset"'
alias gr='git rebase'
alias gs='git status -sb'
alias gt='git checkout'

alias k='kubectl'
alias ka='kubectl apply -f'
alias kd='kubectl describe'
alias ke='kubectl exex -it'
alias kg='kubectl get'
alias kgd='kubectl get deployments'
alias kgp='kubectl get pods'
alias kl='kubectl logs -f'
alias ks='kubens'
alias kx='kubectx'

alias d='docker'
alias dc='docker compose'

alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias drm='docker rm -f'
alias drmi='docker rmi -f'
alias dstop='docker stop'
alias dstart='docker start'
alias drestart='docker restart'

alias dlogs='docker logs -f'
alias dexec='docker exec -it'
alias dsh='docker exec -it $1 sh'
alias dbash='docker exec -it $1 bash'

alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcr='docker compose restart'
alias dcl='docker compose logs -f'

alias dprune='docker system prune -af'
alias dvolrm='docker volume rm $(docker volume ls -q)'
alias dnetrm='docker network rm $(docker network ls -q)'

alias cl='colima'
alias cls='colima start'
alias clst='colima stop'
alias clr='colima restart'
alias clstatus='colima status'

alias c='colima nerdctl'
alias cn='colima nerdctl'
alias cnps='colima nerdctl ps'
alias cnpa='colima nerdctl ps -a'
alias cni='colima nerdctl images'
alias cnrm='colima nerdctl rm -f'
alias cnrmi='colima nerdctl rmi -f'
alias cnstop='colima nerdctl stop'
alias cnstart='colima nerdctl start'
alias cnrestart='colima nerdctl restart'

alias cnlogs='colima nerdctl logs -f'
alias cnexec='colima nerdctl exec -it'
alias cnsh='colima nerdctl exec -it $1 sh'
alias cnbash='colima nerdctl exec -it $1 bash'

alias cnu='colima nerdctl compose up -d'
alias cnd='colima nerdctl compose down'
alias cnr='colima nerdctl compose restart'
alias cnl='colima nerdctl compose logs -f'

alias cnprune='colima nerdctl system prune -af'
alias cnvolrm='colima nerdctl volume rm $(colima nerdctl volume ls -q)'
alias cnnetrm='colima nerdctl network rm $(colima nerdctl network ls -q)'

alias la='ls -lah'
alias ld='lazydocker'
alias lg='lazygit'
alias ll='ls -lh'
alias ls='gls --color=auto --group-directories-first'

alias brewu='brew update && brew upgrade -g && brew cleanup'
alias mvni='mvn clean install -DskipTests -T 1.5C -U'
alias pip=pip3
alias python=python3
alias sudo='sudo '
alias v=vi
alias vi=vim

if command -v nvim &> /dev/null; then
  alias vim=nvim
  alias vimdiff="nvim -d"
  export EDITOR=$(which nvim)
else
  export EDITOR=$(which vim)
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

man() {
  LESS_TERMCAP_md=$'\e[00;34m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[00;32m' \
  command man "$@"
}

j() {
  version=$1
  unset JAVA_HOME;
  export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
  java -version
}

git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /'
}

# Check all available colours: `for code in {000..255}; do print -P -- "$code: %F{$code}Color%f"; done`
PROMPT='%(!.%F{cyan}.%F{blue})${PWD/#$HOME/~}%f %F{green}$(git_branch)%f%(1j.%F{yellow}* %f.)%(0?;;%F{red}%? %f)'
# PROMPT='%(!.%F{cyan}.%F{magenta})%m%f%(1j. %F{yellow}*%f.)%(0?;; %F{red}%?%f)%F{blue} ${PWD/#$HOME/~}%f %F{green}$(git_branch)%f'

export FZF_ALT_C_COMMAND="fd -t d --hidden --follow --exclude '.git' --exclude '{node_modules,vendor,.npm,.cache,.venv}' . $HOME"
export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --no-ignore -g "!{.git,.cache,.clangd,.venv,.DS_Store,build,node_modules,vendor,package-lock.json,yarn.lock}" 2> /dev/null'
export FZF_DEFAULT_COMMAND=$FZF_CTRL_T_COMMAND
export FZF_DEFAULT_OPTS='--bind=alt-k:up,alt-j:down,alt-p:up,alt-n:down --info=hidden --color=dark --color=fg:-1,bg:-1,hl:magenta,fg+:white,bg+:#363a4f,hl+:blue --color=info:blue,prompt:blue,pointer:magenta,marker:blue,spinner:blue,header:blue'
export LS_COLORS="di=34:ln=35:so=35:pi=35:ex=32:bd=36:cd=36:su=31:sg=31:tw=33:ow=33:st=34"

zstyle ':completion:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}' '+m:{_-}={-_}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache yes
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'

export LSCOLORS=exfxfxfxcxgxgxbxbxdxdx

export HOMEBREW_NO_ANALYTICS=1
export JAVA_HOME=$(/usr/libexec/java_home)
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/.ripgreprc"

export CPPFLAGS="-I/usr/local/opt/llvm/include"
export CPPFLAGS="-I/usr/local/opt/openssl/include"
export CPPFLAGS="-I/usr/local/opt/ruby/include"
export CPPFLAGS="-I/usr/local/opt/sqlite/include"

export LDFLAGS="-L/usr/local/opt/llvm/lib"
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export LDFLAGS="-L/usr/local/opt/python/lib"
export LDFLAGS="-L/usr/local/opt/ruby/lib"
export LDFLAGS="-L/usr/local/opt/sqlite/lib"

export PATH="/usr/local/opt/llvm/bin:$PATH"
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="/usr/local/opt/python/bin:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/opt/sqlite/bin:$PATH"

export PKG_CONFIG_PATH="/usr/local/opt/python/lib/pkgconfig"
export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"
export PKG_CONFIG_PATH="/usr/local/opt/sqlite/lib/pkgconfig"

. "$HOME/.cargo/env"

if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
fi

source <(fzf --zsh)
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_HIGHLIGHTERS+=(brackets pattern)
ZSH_HIGHLIGHT_STYLES[arg0]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[autodirectory]='none'
ZSH_HIGHLIGHT_STYLES[path]='none'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green'
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

