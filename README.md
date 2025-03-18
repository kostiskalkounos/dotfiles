# Dotfiles
Managed with <a href="https://www.gnu.org/software/stow/">GNU Stow</a>.

## Drag windows with cmd + ctrl + click
defaults write -g NSWindowShouldDragOnGesture -bool true
defaults write -g NSWindowShouldDragOnGestureFeedback -bool false

## Disable input source popup
defaults write kCFPreferencesAnyApplication TSMLanguageIndicatorEnabled 0
