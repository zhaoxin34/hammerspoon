------------------------------------------ 锁屏时关闭应用程序 ------------------------------------------------
--- 切换应用的时候强制切换输入法到英文输入法
-- 定义要关闭的应用程序
local appsToQuit = { "Skydimo", "NetEaseMusic" }
-- 定义要打开的应用程序
local appsToOpen = { "Skydimo" }

local isLocked = false

-- 创建一个 watcher，监听系统睡眠/唤醒/锁屏事件
CoffeiWatcher = hs.caffeinate.watcher.new(function(eventType)
	if eventType == hs.caffeinate.watcher.screensDidLock then
		isLocked = true
		for _, app in ipairs(appsToQuit) do
			hs.timer.doAfter(10, function()
				if isLocked then
					local a = hs.application.find(app)
					if a then
						a:kill()
					end
				end
			end)
		end
	elseif eventType == hs.caffeinate.watcher.screensDidUnlock then
		isLocked = false
		for _, app in ipairs(appsToOpen) do
			hs.application.launchOrFocus(app)
		end
	end
	-- 锁屏时关闭 Safari
	-- hs.application.find("Skydimo"):kill()
	-- 也可以用 AppleScript 更保险：
	-- hs.osascript.applescript('tell application "Safari" to quit')
end)

CoffeiWatcher:start()

AppWatcher = hs.application.watcher.new(function(_, eventType)
	if eventType == hs.application.watcher.activated then
		-- 每次切换应用时，强制切换到英文输入法
		hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
	end
end)

AppWatcher:start()
