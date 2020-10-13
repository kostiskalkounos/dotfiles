do shell script "open -a 'Mission Control'"
delay 0.2
tell application "System Events" to click (every button whose value of attribute "AXDescription" is "add desktop") of group 2 of group 2 of group 1 of process "Dock"
delay 0.2
tell application "System Events" to key code 53
