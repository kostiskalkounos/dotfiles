-- Restart Yabai
hyper:bind({"cmd", "ctrl"}, "r", function() hs.execute("launchctl kickstart -k 'gui/${UID}/homebrew.mxcl.yabai'", true) end)

-- Focus window
hyper:bind({},"h", function() hs.execute("yabai -m window --focus west", true) end)
hyper:bind({},"j", function() hs.execute("yabai -m window --focus south", true) end)
hyper:bind({},"k", function() hs.execute("yabai -m window --focus north", true) end)
hyper:bind({},"l", function() hs.execute("yabai -m window --focus east", true) end)

-- Swap window
hyper:bind({"cmd"}, "h", function() hs.execute("yabai -m window --swap west", true) end)
hyper:bind({"cmd"}, "j", function() hs.execute("yabai -m window --swap south", true) end)
hyper:bind({"cmd"}, "k", function() hs.execute("yabai -m window --swap north", true) end)
hyper:bind({"cmd"}, "l", function() hs.execute("yabai -m window --swap east", true) end)

-- Cycle windows
hyper:bind({"alt"}, "p", function() hs.execute("$HOME/.config/yabai/cycle_counterclockwise.sh", true) end)
hyper:bind({"alt"}, "n", function() hs.execute("$HOME/.config/yabai/cycle_clockwise.sh", true) end)

-- Move managed window
hyper:bind({}, "left",  function() hs.execute("yabai -m window --warp west", true) end)
hyper:bind({}, "down",  function() hs.execute("yabai -m window --warp south", true) end)
hyper:bind({}, "up",    function() hs.execute("yabai -m window --warp north", true) end)
hyper:bind({}, "right", function() hs.execute("yabai -m window --warp east", true) end)

-- Add the active window to the window or stack to the direction
hyper:bind({"ctrl"}, "h", function() hs.execute("yabai -m window --stack west", true) end)
hyper:bind({"ctrl"}, "j", function() hs.execute("yabai -m window --stack south", true) end)
hyper:bind({"ctrl"}, "k", function() hs.execute("yabai -m window --stack north", true) end)
hyper:bind({"ctrl"}, "l", function() hs.execute("yabai -m window --stack east", true) end)
hyper:bind({"ctrl"}, "m", function() hs.execute("yabai -m window --insert stack", true) end)

-- Focus window up/down in stack
hyper:bind({"ctrl"}, "n", function() hs.execute("yabai -m window --focus stack.next || yabai -m window --focus stack.first", true) end)
hyper:bind({"ctrl"}, "p", function() hs.execute("yabai -m window --focus stack.prev || yabai -m window --focus stack.last", true) end)

-- Move floating window
hyper:bind({"shift"}, "h", function() hs.execute("yabai -m window --move rel:-25:0", true) end)
hyper:bind({"shift"}, "j", function() hs.execute("yabai -m window --move rel:0:25", true) end)
hyper:bind({"shift"}, "k", function() hs.execute("yabai -m window --move rel:0:-25", true) end)
hyper:bind({"shift"}, "l", function() hs.execute("yabai -m window --move rel:25:0", true) end)

-- Increase window size
hyper:bind({}, "y", function() hs.execute("yabai -m window --resize left:-25:0", true) end)
hyper:bind({}, "u", function() hs.execute("yabai -m window --resize bottom:0:25", true) end)
hyper:bind({}, "i", function() hs.execute("yabai -m window --resize top:0:-25", true) end)
hyper:bind({}, "o", function() hs.execute("yabai -m window --resize right:25:0", true) end)

-- Decrease window size
hyper:bind({"cmd"}, "y", function() hs.execute("yabai -m window --resize left:25:0", true) end)
hyper:bind({"cmd"}, "u", function() hs.execute("yabai -m window --resize bottom:0:-25", true) end)
hyper:bind({"cmd"}, "i", function() hs.execute("yabai -m window --resize top:0:25", true) end)
hyper:bind({"cmd"}, "o", function() hs.execute("yabai -m window --resize right:-25:0", true) end)

-- Set insertion point in focused container
hyper:bind({"alt"}, "y", function() hs.execute("yabai -m window --insert west", true) end)
hyper:bind({"alt"}, "u", function() hs.execute("yabai -m window --insert south", true) end)
hyper:bind({"alt"}, "i", function() hs.execute("yabai -m window --insert north", true) end)
hyper:bind({"alt"}, "o", function() hs.execute("yabai -m window --insert east", true) end)

-- Toggle window zoom
hyper:bind({}, "'", function() hs.execute("yabai -m window --toggle zoom-parent", true) end)
hyper:bind({}, ";", function() hs.execute("yabai -m window --toggle zoom-fullscreen", true) end)

-- Float / unfloat window and center on screen
hyper:bind({}, "p", function() hs.execute("yabai -m window --toggle float; yabai -m window --grid 8:8:1:1:6:6", true) end)

-- Change layout
hyper:bind({"cmd"}, "'", function() hs.execute("yabai -m space --layout stack", true) end)
hyper:bind({"cmd"}, ";", function() hs.execute("yabai -m space --layout bsp", true) end)
hyper:bind({"cmd"}, "p", function() hs.execute("yabai -m space --layout float", true) end)

-- Toggle window split type
hyper:bind({}, "m", function() hs.execute("yabai -m window --toggle split", true) end)

-- Rotate the tree
hyper:bind({},      "n", function() hs.execute("yabai -m space --rotate 270", true) end)
hyper:bind({"shift"}, "n", function() hs.execute("yabai -m space --rotate 90", true) end)

-- Flip the tree
hyper:bind({}, ",", function() hs.execute("yabai -m space --mirror x-axis", true) end)
hyper:bind({}, ".", function() hs.execute("yabai -m space --mirror y-axis", true) end)

-- Balance window size
hyper:bind({}, "b", function() hs.execute("yabai -m space --balance", true) end)

-- Toggle and resize padding and gaps
hyper:bind({},        "/", function() hs.execute("yabai -m space --toggle padding; yabai -m space --toggle gap", true) end)
hyper:bind({"alt"},   "/", function() hs.execute("yabai -m space --padding rel:5:5:5:5; yabai -m space --gap rel:5", true) end)
hyper:bind({"cmd"},   "/", function() hs.execute("yabai -m space --padding abs:10:10:10:10; yabai -m space --gap abs:10", true) end)
hyper:bind({"ctrl"},  "/", function() hs.execute("yabai -m space --padding rel:-5:-5:-5:-5; yabai -m space --gap rel:-5", true) end)
hyper:bind({"shift"}, "/", function() hs.execute("yabai -m space --padding rel:-5:-5:-5:-5; yabai -m space --gap rel:-5", true) end)

-- Focus monitor
hyper:bind({}, "1", function() hs.execute("yabai -m display --focus 1", true) end)
hyper:bind({}, "2", function() hs.execute("yabai -m display --focus 2", true) end)
hyper:bind({}, "3", function() hs.execute("yabai -m display --focus 3", true) end)
hyper:bind({}, "[", function() hs.execute("yabai -m display --focus prev || yabai -m display --focus last", true) end)
hyper:bind({}, "]", function() hs.execute("yabai -m display --focus next || yabai -m display --focus first", true) end)

-- Move window to monitor and keep focus
hyper:bind({"alt"}, "1", function() hs.execute("yabai -m window --display 1 && yabai -m display --focus 1", true) end)
hyper:bind({"alt"}, "2", function() hs.execute("yabai -m window --display 2 && yabai -m display --focus 2", true) end)
hyper:bind({"alt"}, "3", function() hs.execute("yabai -m window --display 3 && yabai -m display --focus 3", true) end)
hyper:bind({"alt"}, "[", function() hs.execute("$HOME/.config/yabai/moveWinPrev.sh", true) end)
hyper:bind({"alt"}, "]", function() hs.execute("$HOME/.config/yabai/moveWinNext.sh", true) end)

-- Move window to monitor without keeping focus
hyper:bind({"shift"}, "1", function() hs.execute("yabai -m window --display 1 || yabai -m window --display 1", true) end)
hyper:bind({"shift"}, "2", function() hs.execute("yabai -m window --display 2 || yabai -m window --display 2", true) end)
hyper:bind({"shift"}, "3", function() hs.execute("yabai -m window --display 3 || yabai -m window --display 3", true) end)
hyper:bind({"shift"}, "[", function() hs.execute("yabai -m window --display prev || yabai -m window --display last", true) end)
hyper:bind({"shift"}, "]", function() hs.execute("yabai -m window --display next || yabai -m window --display first", true) end)

-- Move window to workspace
hyper:bind({"cmd"}, "1", function() hs.execute("yabai -m window --space 1", true) end)
hyper:bind({"cmd"}, "2", function() hs.execute("yabai -m window --space 2", true) end)
hyper:bind({"cmd"}, "3", function() hs.execute("yabai -m window --space 3", true) end)
hyper:bind({"cmd"}, "4", function() hs.execute("yabai -m window --space 4", true) end)
hyper:bind({"cmd"}, "5", function() hs.execute("yabai -m window --space 5", true) end)
hyper:bind({"cmd"}, "6", function() hs.execute("yabai -m window --space 6", true) end)
hyper:bind({"cmd"}, "7", function() hs.execute("yabai -m window --space 7", true) end)
hyper:bind({"cmd"}, "8", function() hs.execute("yabai -m window --space 8", true) end)
hyper:bind({"cmd"}, "9", function() hs.execute("yabai -m window --space 9", true) end)
hyper:bind({"cmd"}, "0", function() hs.execute("yabai -m window --space 10", true) end)
