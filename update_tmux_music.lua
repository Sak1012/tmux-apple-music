#!/usr/bin/env lua

-- Lua script to get current music track and artist from Apple Music

-- Function to get the current track information from Apple Music
function getCurrentTrackInfo()
	local command = "osascript -e 'tell application \"Music\"' "
		.. "-e 'if it is running then' "
		.. "-e 'set currentTrack to name of current track' "
		.. "-e 'set currentArtist to artist of current track' "
		.. "-e 'set durationInSeconds to duration of current track' "
		.. "-e 'set currentPos to player position' "
		.. "-e 'return currentTrack & \" by \" & currentArtist ' "
		.. "-e 'else' "
		.. "-e 'return \"No music playing\"' "
		.. "-e 'end if' "
		.. "-e 'end tell' "
	local handle = io.popen(command)
	local result = handle:read("*a")
	handle:close()
	return result
end

-- Continuously update tmux status every 10 seconds
while true do
	local trackInfo = getCurrentTrackInfo()
	local tmuxCommand = 'tmux set-option -g status-right "' .. trackInfo .. '"'
	os.execute(tmuxCommand)
	os.execute("sleep 10")
end
