------------------------------------------ 锁屏时关闭应用程序 ------------------------------------------------
-- 定义要关闭的应用程序
local appsToQuit = { "Skydimo", "NetEaseMusic", "WeChat" }
-- 定义要打开的应用程序
local appsToOpen = { "Iterm2", "Skydimo" }

-- 创建一个 watcher，监听系统睡眠/唤醒/锁屏事件
lockWatcher = hs.caffeinate.watcher.new(function(eventType)
    if eventType == hs.caffeinate.watcher.screensDidLock then
        for _, app in ipairs(appsToQuit) do
            local a = hs.application.find(app)
            if a then a:kill() end
        end
    elseif eventType == hs.caffeinate.watcher.screensDidUnlock then
        for _, app in ipairs(appsToOpen) do
            hs.application.launchOrFocus(app)
        end
    end
        -- 锁屏时关闭 Safari
        -- hs.application.find("Skydimo"):kill()
        -- 也可以用 AppleScript 更保险：
        -- hs.osascript.applescript('tell application "Safari" to quit')
end)

lockWatcher:start()