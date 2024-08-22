local watchers = {}

-- Function: Set up a watcher for an application to listen for window creation and execute a callback
function watchers.newWindow(app, callback)
	if not app or not app:isRunning() then
		return
	end

	local watcher = app:newWatcher(function(element, event)
		if event == hs.uielement.watcher.windowCreated then
			-- Execute the provided callback function
			callback(app, element)
			-- Optionally stop the watcher if you no longer need to listen for new windows
			-- watcher:stop()
		end
	end)

	-- Start watching for window creation events
	watcher:start({ hs.uielement.watcher.windowCreated })
end


return watchers