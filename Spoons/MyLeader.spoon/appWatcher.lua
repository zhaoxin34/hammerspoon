--- 应用程序切换监听示例
--- @class MyLeader.appWatcher
--- @field activeCallback function 应用活回调
--- @field launchCallbacks table[function] 启动监听器回调

local obj = {}

obj.activeCallback = nil
obj.launchCallbacks = {}

-- 监听应用程序切换
local function applicationWatcher(appName, eventType)
    if eventType == hs.application.watcher.activated then
        -- 每次切换应用时，强制切换到英文输入法
        hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
        if obj.activeCallback then
            obj.activeCallback(appName)
        end
    end

    if eventType == hs.application.watcher.launched then
        for _, func in ipairs(obj.launchCallbacks) do
            func(appName)
        end
    end
end

-- 创建应用程序监听器
obj._appWatcher = hs.application.watcher.new(applicationWatcher)

-- 启动监听器
obj._appWatcher:start()

---添加启动的回调
---@param callback function 回调方法
function obj:addLaunchCallback(callback)
    table.insert(obj.launchCallbacks, callback)
end

-- 返回监听器以便可以在其他地方停止
return obj
