local yabai = require("yabai_utils")

-- Focus window
Hyper:bind({}, "h", function() yabai.execute("window --focus west") end)
Hyper:bind({}, "j", function() yabai.execute("window --focus south") end)
Hyper:bind({}, "k", function() yabai.execute("window --focus north") end)
Hyper:bind({}, "l", function() yabai.execute("window --focus east") end)

-- Swap window
Hyper:bind({ "cmd" }, "h", function() yabai.execute("window --swap west") end)
Hyper:bind({ "cmd" }, "j", function() yabai.execute("window --swap south") end)
Hyper:bind({ "cmd" }, "k", function() yabai.execute("window --swap north") end)
Hyper:bind({ "cmd" }, "l", function() yabai.execute("window --swap east") end)

-- Cycle windows
Hyper:bind({ "alt" }, "n", function() hs.execute("$HOME/.hammerspoon/yabai/scripts/cycle_clockwise.sh", true) end)
Hyper:bind({ "alt" }, "p", function() hs.execute("$HOME/.hammerspoon/yabai/scripts/cycle_counterclockwise.sh", true) end)

-- Move managed window
Hyper:bind({}, "left", function() yabai.execute("window --warp west") end)
Hyper:bind({}, "down", function() yabai.execute("window --warp south") end)
Hyper:bind({}, "up", function() yabai.execute("window --warp north") end)
Hyper:bind({}, "right", function() yabai.execute("window --warp east") end)

-- Add the active window to the window or stack to the direction
Hyper:bind({ "ctrl" }, "h", function() yabai.execute("window --stack west") end)
Hyper:bind({ "ctrl" }, "j", function() yabai.execute("window --stack south") end)
Hyper:bind({ "ctrl" }, "k", function() yabai.execute("window --stack north") end)
Hyper:bind({ "ctrl" }, "l", function() yabai.execute("window --stack east") end)
Hyper:bind({ "ctrl" }, "m", function() yabai.execute("window --insert stack") end)

Hyper:bind({ "ctrl" }, "n", function() yabai.execute("window --focus stack.next") end)
Hyper:bind({ "ctrl" }, "p", function() yabai.execute("window --focus stack.prev") end)
-- Hyper:bind({ "ctrl" }, "n", function() hs.execute("yabai -m window --focus stack.next || yabai -m window --focus stack.first", true) end)
-- Hyper:bind({ "ctrl" }, "p", function() hs.execute("yabai -m window --focus stack.prev || yabai -m window --focus stack.last", true) end)

-- Move floating window
Hyper:bind({ "shift" }, "h", function() yabai.execute("window --move rel:-25:0") end)
Hyper:bind({ "shift" }, "j", function() yabai.execute("window --move rel:0:25") end)
Hyper:bind({ "shift" }, "k", function() yabai.execute("window --move rel:0:-25") end)
Hyper:bind({ "shift" }, "l", function() yabai.execute("window --move rel:25:0") end)

-- Increase window size
Hyper:bind({}, "y", function() yabai.execute("window --resize left:-25:0") end)
Hyper:bind({}, "u", function() yabai.execute("window --resize bottom:0:25") end)
Hyper:bind({}, "i", function() yabai.execute("window --resize top:0:-25") end)
Hyper:bind({}, "o", function() yabai.execute("window --resize right:25:0") end)

-- Decrease window size
Hyper:bind({ "cmd" }, "y", function() yabai.execute("window --resize left:25:0") end)
Hyper:bind({ "cmd" }, "u", function() yabai.execute("window --resize bottom:0:-25") end)
Hyper:bind({ "cmd" }, "i", function() yabai.execute("window --resize top:0:25") end)
Hyper:bind({ "cmd" }, "o", function() yabai.execute("window --resize right:-25:0") end)

-- Set insertion point in focused container
Hyper:bind({ "alt" }, "y", function() yabai.execute("window --insert west") end)
Hyper:bind({ "alt" }, "u", function() yabai.execute("window --insert south") end)
Hyper:bind({ "alt" }, "i", function() yabai.execute("window --insert north") end)
Hyper:bind({ "alt" }, "o", function() yabai.execute("window --insert east") end)

-- Toggle window zoom
Hyper:bind({}, "'", function() yabai.execute("window --toggle zoom-parent") end)
Hyper:bind({}, ";", function() yabai.execute("window --toggle zoom-fullscreen") end)

-- Float / unfloat window and center on screen
Hyper:bind({}, "p", function() yabai.execute("window --toggle float -m window --grid 8:8:1:1:6:6") end)

-- Change layout
Hyper:bind({ "cmd" }, "'", function() yabai.execute("space --layout stack") end)
Hyper:bind({ "cmd" }, ";", function() yabai.execute("space --layout bsp") end)
Hyper:bind({ "cmd" }, "p", function() yabai.execute("space --layout float") end)

-- Toggle window split type
Hyper:bind({}, "m", function() yabai.execute("window --toggle split") end)

-- Rotate the tree
Hyper:bind({}, "n", function() yabai.execute("space --rotate 270") end)
Hyper:bind({ "shift" }, "n", function() yabai.execute("space --rotate 90") end)

-- Flip the tree
Hyper:bind({}, ",", function() yabai.execute("space --mirror x-axis") end)
Hyper:bind({}, ".", function() yabai.execute("space --mirror y-axis") end)

-- Balance window size
Hyper:bind({}, "b", function() yabai.execute("space --balance") end)

-- Toggle and resize padding and gaps
Hyper:bind({}, "/", function() yabai.execute("space --toggle padding -m space --toggle gap") end)
Hyper:bind({ "alt" }, "/", function() yabai.execute("space --padding rel:5:5:5:5 -m space --gap rel:5") end)
Hyper:bind({ "cmd" }, "/", function() yabai.execute("space --padding abs:10:10:10:10 -m space --gap abs:10") end)
Hyper:bind({ "ctrl" }, "/", function() yabai.execute("space --padding rel:-5:-5:-5:-5 -m space --gap rel:-5") end)
Hyper:bind({ "shift" }, "/", function() yabai.execute("space --padding abs:10:10:10:10 -m space --gap abs:10") end)

-- Focus monitor
Hyper:bind({}, "1", function() yabai.execute("display --focus 1") end)
Hyper:bind({}, "2", function() yabai.execute("display --focus 2") end)
Hyper:bind({}, "3", function() yabai.execute("display --focus 3") end)
Hyper:bind({}, "[", function() yabai.execute("display --focus prev") end)
Hyper:bind({}, "]", function() yabai.execute("display --focus next") end)

-- Hyper:bind({}, "[", function() hs.execute("display --focus prev || display --focus last") end)
-- Hyper:bind({}, "]", function() hs.execute("display --focus next || display --focus first") end)

-- -- Move window to monitor and keep focus
Hyper:bind({ "alt" }, "1", function() yabai.execute("window --display 1 && window --focus") end)
Hyper:bind({ "alt" }, "2", function() yabai.execute("window --display 2 && window --focus") end)
Hyper:bind({ "alt" }, "3", function() yabai.execute("window --display 3 && window --focus") end)
Hyper:bind({ "alt" }, "[", function() yabai.execute("window --display prev && window --focus") end)
Hyper:bind({ "alt" }, "]", function() yabai.execute("window --display next && window --focus") end)
-- Hyper:bind({ "alt" }, "[", function() yabai.execute("$HOME/.hammerspoon/yabai/scripts/moveWinPrev.sh", true) end)
-- Hyper:bind({ "alt" }, "]", function() yabai.execute("$HOME/.hammerspoon/yabai/scripts/moveWinNext.sh", true) end)

-- Move window to monitor without keeping focus
Hyper:bind({ "shift" }, "1", function() yabai.execute("window --display 1") end)
Hyper:bind({ "shift" }, "2", function() yabai.execute("window --display 2") end)
Hyper:bind({ "shift" }, "3", function() yabai.execute("window --display 3") end)
Hyper:bind({ "shift" }, "[", function() yabai.execute("window --display prev") end)
Hyper:bind({ "shift" }, "]", function() yabai.execute("window --display next") end)
-- Hyper:bind({ "shift" }, "[", function() yabai.execute("yabai -m window --display prev || yabai -m window --display last", true) end)
-- Hyper:bind({ "shift" }, "]", function() yabai.execute("yabai -m window --display next || yabai -m window --display first", true) end)

-- Move window to workspace and keep focus
Hyper:bind({ "cmd" }, "1", function() yabai.execute("window --space 1 && window --focus") end)
Hyper:bind({ "cmd" }, "2", function() yabai.execute("window --space 2 && window --focus") end)
Hyper:bind({ "cmd" }, "3", function() yabai.execute("window --space 3 && window --focus") end)
Hyper:bind({ "cmd" }, "4", function() yabai.execute("window --space 4 && window --focus") end)
Hyper:bind({ "cmd" }, "5", function() yabai.execute("window --space 5 && window --focus") end)
Hyper:bind({ "cmd" }, "6", function() yabai.execute("window --space 6 && window --focus") end)
Hyper:bind({ "cmd" }, "7", function() yabai.execute("window --space 7 && window --focus") end)
Hyper:bind({ "cmd" }, "8", function() yabai.execute("window --space 8 && window --focus") end)
Hyper:bind({ "cmd" }, "9", function() yabai.execute("window --space 9 && window --focus") end)
Hyper:bind({ "cmd" }, "0", function() yabai.execute("window --space 10 && window --focus") end)

-- Move window to workspace without keeping focus
Hyper:bind({ "ctrl" }, "1", function() yabai.execute("window --space 1") end)
Hyper:bind({ "ctrl" }, "2", function() yabai.execute("window --space 2") end)
Hyper:bind({ "ctrl" }, "3", function() yabai.execute("window --space 3") end)
Hyper:bind({ "ctrl" }, "4", function() yabai.execute("window --space 4") end)
Hyper:bind({ "ctrl" }, "5", function() yabai.execute("window --space 5") end)
Hyper:bind({ "ctrl" }, "6", function() yabai.execute("window --space 6") end)
Hyper:bind({ "ctrl" }, "7", function() yabai.execute("window --space 7") end)
Hyper:bind({ "ctrl" }, "8", function() yabai.execute("window --space 8") end)
Hyper:bind({ "ctrl" }, "9", function() yabai.execute("window --space 9") end)
Hyper:bind({ "ctrl" }, "0", function() yabai.execute("window --space 10") end)
