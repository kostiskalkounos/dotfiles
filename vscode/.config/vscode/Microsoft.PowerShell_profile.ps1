function Git-Add {
  git add $args
}

function Git-Branch {
  git branch $args
}

function Git-Commit {
  git commit $args
}

function Git-Diff {
  git diff $args
}

function Git-Ammend {
  git commit --amend --no-edit
}

function Git-Log {
  git log --oneline --all
}

function Git-Logs {
  git log --graph --topo-order --abbrev-commit --date=short --decorate --all --boundary --pretty=format:"%Cgreen%ad %C(yellow)%h%Creset%C(red)%d%Creset %s %Cblue[%cn]%Creset"
}

function Git-Rebase {
  git rebase $args
}

function Git-Status {
  git status -sb
}

function Git-Checkout {
  git checkout $args
}

del alias:gc -Force
del alias:gl -Force

Set-Alias ga Git-Add
Set-Alias gb Git-Branch
Set-Alias gc Git-Commit
Set-Alias gd Git-Diff
Set-Alias gf Git-Ammend
Set-Alias gl Git-Log
Set-Alias gll Git-Logs
Set-Alias gr Git-Rebase
Set-Alias gs Git-Status
Set-Alias gt Git-Checkout

Set-Alias vi nvim
Set-Alias vim nvim

if ($host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadLine
    Import-Module PSColor
}

Set-PSReadLineOption -EditMode Emacs
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

$global:PSColor.File.Directory.Color = "Blue"
$global:PSColor.File.Executable.Color = "Green"
$global:PSColor.File.Hidden.Color = "White"

#Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'

$env:FZF_ALT_C_COMMAND="fd -t d --hidden --follow --exclude '.git' --exclude '{node_modules,vendor,.npm,.cache,.venv}' . $HOME"
$env:FZF_CTRL_T_COMMAND='rg --files --hidden --follow --no-ignore -g "!{.git,.cache,.clangd,.venv,.DS_Store,build,node_modules,vendor,package-lock.json,yarn.lock}" 2> /dev/null'
$env:FZF_DEFAULT_COMMAND=$env:FZF_CTRL_T_COMMAND
$env:FZF_DEFAULT_OPTS='--bind=alt-k:up,alt-j:down,alt-p:up,alt-n:down --info=hidden --color=dark --color=fg:-1,bg:-1,hl:#c27fd7,fg+:#ffffff,bg+:-1,hl+:#d658fe --color=info:#68aee8,prompt:#68aee8,pointer:#c27fd7,marker:#68aee8,spinner:#68aee8,header:#68aee8'
$env:RIPGREP_CONFIG_PATH="C:\Users\konstantinos.kalkoun\.ripgreprc"

#oh-my-posh init pwsh --config 'C:\Users\konstantinos.kalkoun\scoop\apps\oh-my-posh\current\themes\kostis.omp.json' | Invoke-Expression

function prompt {
  try {
    $branch = git rev-parse --abbrev-ref HEAD
    if ($branch -eq "HEAD") { $branch = git rev-parse --short HEAD }
  } catch {}
  if ($branch) { $branch = " $branch" }
  $userPrompt = "$('' * ($nestedPromptLevel + 1)) "
  $path = "$($executionContext.SessionState.Path.CurrentLocation)"
  Write-Host "$env:computername ".toLower() -NoNewline -ForegroundColor Magenta
  Write-Host $path -NoNewline -ForegroundColor Blue
  Write-Host "$branch" -NoNewLine -ForegroundColor Green
  return $userPrompt
}
