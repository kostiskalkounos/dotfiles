alias di='dirs -v'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gf='git commit --amend --no-edit'
alias gl='git log --oneline'
alias gr='git rebase'
alias gs='git status -sb'
alias gt='git checkout'
alias la='ls -lah'
alias ll='ls -lh'
alias ls='ls -G'
alias vi=vim

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e^N": history-search-forward'
bind '"\e^P": history-search-backward'
bind '"\ej": history-search-backward'
bind '"\ek": history-search-forward'
bind '"\en": history-search-forward'
bind '"\ep": history-search-backward'

HISTFILE="$HOME/.bash_history"
HISTSIZE=10000
SAVEHIST=$HISTSIZE

shopt -s autocd
shopt -s histverify

PS1='\e[0;35m\h\e[m \e[0;34m\w\e[m \e[0;32m$(git_branch)\e[m'

git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /'
}

man() {
  LESS_TERMCAP_md=$'\e[00;34m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[00;32m' \
  command man "$@"
}

if command -v nvim &> /dev/null; then
  alias vim=nvim
  alias vimdiff="nvim -d"
  export EDITOR=$(which nvim)
else
  export EDITOR=$(which vim)
fi

export FZF_ALT_C_COMMAND="fd -t d --hidden --follow --exclude '.git' --exclude '{node_modules,vendor,.npm,.cache}' . $HOME"
export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --no-ignore -g "!{.git,.cache,.clangd,.DS_Store,build,node_modules,vendor,package-lock.json,yarn.lock}" 2> /dev/null'
export FZF_DEFAULT_COMMAND=$FZF_CTRL_T_COMMAND
export FZF_DEFAULT_OPTS='--bind=alt-k:up,alt-j:down,alt-p:up,alt-n:down --info=hidden --color=dark --color=fg:-1,bg:-1,hl:#c678dd,fg+:#ffffff,bg+:-1,hl+:#d858fe --color=info:#e5c07b,prompt:#61afef,pointer:#c678dd,marker:#e5c07b,spinner:#61afef,header:#61afef'
export LS_COLORS="di=34:ln=35:so=35:pi=35:ex=32:bd=36:cd=36:su=31:sg=31:tw=33:ow=33"
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/.ripgreprc"

if [ $(uname) = Darwin ]; then
  alias ls='ls -G'
  alias pip=/usr/local/bin/pip3
  alias python=/usr/local/bin/python3

  export CPPFLAGS="-I/usr/local/opt/llvm/include"
  export CPPFLAGS="-I/usr/local/opt/openjdk/include"
  export CPPFLAGS="-I/usr/local/opt/sqlite/include"
  export LDFLAGS="-L/usr/local/opt/llvm/lib"
  export LDFLAGS="-L/usr/local/opt/python@3.8/lib"
  export LDFLAGS="-L/usr/local/opt/sqlite/lib"
  export LSCOLORS=exfxfxfxcxgxgxbxbxdxdx
  export PATH="/usr/local/opt/llvm/bin:$PATH"
  export PATH="/usr/local/opt/openjdk/bin:$PATH"
  export PATH="/usr/local/opt/python@3.8/bin:$PATH"
  export PATH="/usr/local/opt/sqlite/bin:$PATH"
  export PKG_CONFIG_PATH="/usr/local/opt/python@3.8/lib/pkgconfig"
  export PKG_CONFIG_PATH="/usr/local/opt/sqlite/lib/pkgconfig"

  if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
    export PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
  fi

  [[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.bash" 2> /dev/null

  source "/usr/local/opt/fzf/shell/key-bindings.bash"
else
  alias ls='ls --color=auto --group-directories-first'
  source "/usr/share/fzf/completion.bash"
  source "/usr/share/fzf/key-bindings.bash"
fi
. "$HOME/.cargo/env"
