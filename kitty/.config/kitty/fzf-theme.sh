fzf_theme="dark"
if [[ -f "$HOME/.cache/theme" ]]; then
  fzf_theme="$(< "$HOME/.cache/theme")"
  fzf_theme="${fzf_theme//[[:space:]]/}"
fi

FZF_COMMON_OPTS='--bind=alt-k:up,alt-j:down,alt-p:up,alt-n:down --info=hidden --color=fg:-1,bg:-1,hl:magenta,hl+:blue,info:blue,prompt:blue,pointer:magenta,marker:blue,spinner:blue,header:blue'

if [[ "${fzf_theme}" == "light" ]]; then
  export FZF_DEFAULT_OPTS="--color=light ${FZF_COMMON_OPTS} --color=fg+:black,bg+:#ccd0da,gutter:#eff1f5"
else
  export FZF_DEFAULT_OPTS="--color=dark ${FZF_COMMON_OPTS} --color=fg+:white,bg+:#363a4f,gutter:#24273A"
fi
