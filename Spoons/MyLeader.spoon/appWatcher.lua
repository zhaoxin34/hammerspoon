--- 应用程序切换监听示例
--- @class MyLeader.appWatcher
--- @field activeCallback function 应用活回调

local obj = {}

obj.activeCallback = nil

-- 监听应用程序切换
local function applicationWatcher(appName, eventType)
    if eventType == hs.application.watcher.activated then
        if eventType == hs.application.watcher.activated then
            -- 每次切换应用时，强制切换到英文输入法
            hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
            hs.alert.show("输入法切换到英文")
            if obj.activeCallback then
                obj.activeCallback(appName)
            end
        end
    end
end

-- 创建应用程序监听器
obj._appWatcher = hs.application.watcher.new(applicationWatcher)

-- 启动监听器
obj._appWatcher:start()

-- 返回监听器以便可以在其他地方停止
return obj
