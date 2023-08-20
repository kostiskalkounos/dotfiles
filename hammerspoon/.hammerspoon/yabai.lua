local function execute(args)
  hs.task.new("/usr/local/bin/yabai", nil, function(_, ...)
    print("stream", hs.inspect(table.pack(...)))
    return true
  end, args):start()
end

-- Restart Yabai
Hyper:bind({ "cmd", "ctrl" }, "r", function() execute({ "--restart-service" }) end)

-- Focus window
Hyper:bind({}, "h", function() execute({ "-m", "window", "--focus", "west" }) end)
Hyper:bind({}, "j", function() execute({ "-m", "window", "--focus", "south" }) end)
Hyper:bind({}, "k", function() execute({ "-m", "window", "--focus", "north" }) end)
Hyper:bind({}, "l", function() execute({ "-m", "window", "--focus", "east" }) end)

-- Swap window
Hyper:bind({ "cmd" }, "h", function() execute({ "-m", "window", "--swap", "west" }) end)
Hyper:bind({ "cmd" }, "j", function() execute({ "-m", "window", "--swap", "south" }) end)
Hyper:bind({ "cmd" }, "k", function() execute({ "-m", "window", "--swap", "north" }) end)
Hyper:bind({ "cmd" }, "l", function() execute({ "-m", "window", "--swap", "east" }) end)

-- Cycle windows
Hyper:bind({ "alt" }, "n", function() hs.execute("$HOME/.hammerspoon/scripts/cycle_clockwise.sh", true) end)
Hyper:bind({ "alt" }, "p", function() hs.execute("$HOME/.hammerspoon/scripts/cycle_counterclockwise.sh", true) end)

-- Move managed window
Hyper:bind({}, "left", function() execute({ "-m", "window", "--warp", "west" }) end)
Hyper:bind({}, "down", function() execute({ "-m", "window", "--warp", "south" }) end)
Hyper:bind({}, "up", function() execute({ "-m", "window", "--warp", "north" }) end)
Hyper:bind({}, "right", function() execute({ "-m", "window", "--warp", "east" }) end)

-- Add the active window to the window or stack to the direction
Hyper:bind({ "ctrl" }, "h", function() execute({ "-m", "window", "--stack", "west" }) end)
Hyper:bind({ "ctrl" }, "j", function() execute({ "-m", "window", "--stack", "south" }) end)
Hyper:bind({ "ctrl" }, "k", function() execute({ "-m", "window", "--stack", "north" }) end)
Hyper:bind({ "ctrl" }, "l", function() execute({ "-m", "window", "--stack", "east" }) end)
Hyper:bind({ "ctrl" }, "m", function() execute({ "-m", "window", "--insert", "stack" }) end)

Hyper:bind({ "ctrl" }, "n", function() execute({ "-m", "window", "--focus", "stack.next" }) end)
Hyper:bind({ "ctrl" }, "p", function() execute({ "-m", "window", "--focus", "stack.prev" }) end)

-- Hyper:bind({ "ctrl" }, "n", function() hs.execute("yabai -m window --focus stack.next || yabai -m window --focus stack.first", true) end)
-- Hyper:bind({ "ctrl" }, "p", function() hs.execute("yabai -m window --focus stack.prev || yabai -m window --focus stack.last", true) end)

-- Move floating window
Hyper:bind({ "shift" }, "h", function() execute({ "-m", "window", "--move", "rel:-25:0" }) end)
Hyper:bind({ "shift" }, "j", function() execute({ "-m", "window", "--move", "rel:0:25" }) end)
Hyper:bind({ "shift" }, "k", function() execute({ "-m", "window", "--move", "rel:0:-25" }) end)
Hyper:bind({ "shift" }, "l", function() execute({ "-m", "window", "--move", "rel:25:0" }) end)

-- Increase window size
Hyper:bind({}, "y", function() execute({ "-m", "window", "--resize", "left:-25:0" }) end)
Hyper:bind({}, "u", function() execute({ "-m", "window", "--resize", "bottom:0:25" }) end)
Hyper:bind({}, "i", function() execute({ "-m", "window", "--resize", "top:0:-25" }) end)
Hyper:bind({}, "o", function() execute({ "-m", "window", "--resize", "right:25:0" }) end)

-- Decrease window size
Hyper:bind({ "cmd" }, "y", function() execute({ "-m", "window", "--resize", "left:25:0" }) end)
Hyper:bind({ "cmd" }, "u", function() execute({ "-m", "window", "--resize", "bottom:0:-25" }) end)
Hyper:bind({ "cmd" }, "i", function() execute({ "-m", "window", "--resize", "top:0:25" }) end)
Hyper:bind({ "cmd" }, "o", function() execute({ "-m", "window", "--resize", "right:-25:0" }) end)

-- Set insertion point in focused container
Hyper:bind({ "alt" }, "y", function() execute({ "-m", "window", "--insert", "west" }) end)
Hyper:bind({ "alt" }, "u", function() execute({ "-m", "window", "--insert", "south" }) end)
Hyper:bind({ "alt" }, "i", function() execute({ "-m", "window", "--insert", "north" }) end)
Hyper:bind({ "alt" }, "o", function() execute({ "-m", "window", "--insert", "east" }) end)

-- Toggle window zoom
Hyper:bind({}, "'", function() execute({ "-m", "window", "--toggle", "zoom-parent" }) end)
Hyper:bind({}, ";", function() execute({ "-m", "window", "--toggle", "zoom-fullscreen" }) end)

-- Float / unfloat window and center on screen
Hyper:bind({}, "p", function() execute({ "-m", "window", "--toggle", "float", "-m", "window", "--grid", "8:8:1:1:6:6" }) end)

-- Change layout
Hyper:bind({ "cmd" }, "'", function() execute({ "-m", "space", "--layout", "stack" }) end)
Hyper:bind({ "cmd" }, ";", function() execute({ "-m", "space", "--layout", "bsp" }) end)
Hyper:bind({ "cmd" }, "p", function() execute({ "-m", "space", "--layout", "float" }) end)

-- Toggle window split type
Hyper:bind({}, "m", function() execute({ "-m", "window", "--toggle", "split" }) end)

-- Rotate the tree
Hyper:bind({}, "n", function() execute({ "-m", "space", "--rotate", "270" }) end)
Hyper:bind({ "shift" }, "n", function() execute({ "-m", "space", "--rotate", "90" }) end)

-- Flip the tree
Hyper:bind({}, ",", function() execute({ "-m", "space", "--mirror", "x-axis" }) end)
Hyper:bind({}, ".", function() execute({ "-m", "space", "--mirror", "y-axis" }) end)

-- Balance window size
Hyper:bind({}, "b", function() execute({ "-m", "space", "--balance" }) end)

-- Toggle and resize padding and gaps
Hyper:bind({}, "/", function() execute({ "-m", "space", "--toggle", "padding", "-m", "space", "--toggle", "gap" }) end)
Hyper:bind({ "alt" }, "/", function() execute({ "-m", "space", "--padding", "rel:5:5:5:5", "-m", "space", "--gap", "rel:5" }) end)
Hyper:bind({ "cmd" }, "/", function() execute({ "-m", "space", "--padding", "abs:10:10:10:10", "-m", "space", "--gap", "abs:10" }) end)
Hyper:bind({ "ctrl" }, "/", function() execute({ "-m", "space", "--padding", "rel:-5:-5:-5:-5", "-m", "space", "--gap", "rel:-5" }) end)
Hyper:bind({ "shift" }, "/", function() execute({ "-m", "space", "--padding", "abs:10:10:10:10", "-m", "space", "--gap", "abs:10" }) end)

-- Focus monitor
Hyper:bind({}, "1", function() execute({ "-m", "display", "--focus", "1" }) end)
Hyper:bind({}, "2", function() execute({ "-m", "display", "--focus", "2" }) end)
Hyper:bind({}, "3", function() execute({ "-m", "display", "--focus", "3" }) end)

-- Hyper:bind({}, "[", function() hs.execute("yabai -m display --focus prev || yabai -m display --focus last", true) end)
-- Hyper:bind({}, "]", function() hs.execute("yabai -m display --focus next || yabai -m display --focus first", true) end)

-- -- Move window to monitor and keep focus
-- Hyper:bind({ "alt" }, "1", function() hs.execute("yabai -m window --display 1 && yabai -m display --focus 1", true) end)
-- Hyper:bind({ "alt" }, "2", function() hs.execute("yabai -m window --display 2 && yabai -m display --focus 2", true) end)
-- Hyper:bind({ "alt" }, "3", function() hs.execute("yabai -m window --display 3 && yabai -m display --focus 3", true) end)
-- Hyper:bind({ "alt" }, "[", function() hs.execute("$HOME/.hammerspoon/scripts/moveWinPrev.sh", true) end)
-- Hyper:bind({ "alt" }, "]", function() hs.execute("$HOME/.hammerspoon/scripts/moveWinNext.sh", true) end)

-- -- Move window to monitor without keeping focus
-- Hyper:bind({ "shift" }, "1", function() hs.execute("yabai -m window --display 1 || yabai -m window --display 1", true) end)
-- Hyper:bind({ "shift" }, "2", function() hs.execute("yabai -m window --display 2 || yabai -m window --display 2", true) end)
-- Hyper:bind({ "shift" }, "3", function() hs.execute("yabai -m window --display 3 || yabai -m window --display 3", true) end)
-- Hyper:bind({ "shift" }, "[", function() hs.execute("yabai -m window --display prev || yabai -m window --display last", true) end)
-- Hyper:bind({ "shift" }, "]", function() hs.execute("yabai -m window --display next || yabai -m window --display first", true) end)

-- Move window to workspace
Hyper:bind({ "cmd" }, "1", function() execute({ "-m", "window", "--space", "1" }) end)
Hyper:bind({ "cmd" }, "2", function() execute({ "-m", "window", "--space", "2" }) end)
Hyper:bind({ "cmd" }, "3", function() execute({ "-m", "window", "--space", "3" }) end)
Hyper:bind({ "cmd" }, "4", function() execute({ "-m", "window", "--space", "4" }) end)
Hyper:bind({ "cmd" }, "5", function() execute({ "-m", "window", "--space", "5" }) end)
Hyper:bind({ "cmd" }, "6", function() execute({ "-m", "window", "--space", "6" }) end)
Hyper:bind({ "cmd" }, "7", function() execute({ "-m", "window", "--space", "7" }) end)
Hyper:bind({ "cmd" }, "8", function() execute({ "-m", "window", "--space", "8" }) end)
Hyper:bind({ "cmd" }, "9", function() execute({ "-m", "window", "--space", "9" }) end)
Hyper:bind({ "cmd" }, "0", function() execute({ "-m", "window", "--space", "10" }) end)
