# MacOS settings

## Drag windows with cmd + ctrl + click
defaults write -g NSWindowShouldDragOnGesture -bool true
defaults write -g NSWindowShouldDragOnGestureFeedback -bool false

## Disable input source popup
defaults write kCFPreferencesAnyApplication TSMLanguageIndicatorEnabled 0
