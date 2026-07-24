### Drag windows with cmd + ctrl + click
defaults write -g NSWindowShouldDragOnGesture -bool true
defaults write -g NSWindowShouldDragOnGestureFeedback -bool false

### Disable input source popup
defaults write kCFPreferencesAnyApplication TSMLanguageIndicatorEnabled 0

### Speed up key repeat rate and reduce delay (requires macOS logout/reboot)
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 10

### Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1 && killall Dock

### Setup Homebrew shells
echo $(which zsh) | sudo tee -a /etc/shells
echo $(which bash) | sudo tee -a /etc/shells
sudo chsh -s $(which zsh) $USER
