-- 应用程序切换监听示例

local chromeModal = require('modules.leader.chromeModal')
local onChromeFocus = function()
    hs.alert.show("切换到了 Chrome!")
    chromeModal:enter()
end

local onVSCodeFocus = function()
    hs.alert.show("切换到了 VS Code!")
end

-- 监听应用程序切换
local function applicationWatcher(appName, eventType, appObject)
    if eventType == hs.application.watcher.activated then
        -- 在这里添加你想要监听的应用程序名称
        if appName == "Google Chrome" then
            onChromeFocus()
        else
            chromeModal:exit()
        end
    end
end

-- 创建应用程序监听器
local appWatcher = hs.application.watcher.new(applicationWatcher)

-- 启动监听器
appWatcher:start()

-- 返回监听器以便可以在其他地方停止
return appWatcher
