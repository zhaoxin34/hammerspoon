--- 目前打开应用后，yabai把app分配到对应的space，但是并没有跳转到对应的桌面，这个代码就是要做这个事
--- 注：这个方法目前尚未生效, 所以注释掉了

local appWatcher = require("appWatcher")

local log = hs.logger.new('yabaiLaunchApp', 'info')

local yabaiPath = "/opt/homebrew/bin/yabai" -- Intel Mac 改成 /usr/local/bin/yabai

local function onAppLaunch(appName)
    log.i(appName .. "启动了")
    hs.timer.doAfter(1, function()
        local task = hs.task.new(yabaiPath,
            function(exitCode, stdOut)
                if exitCode ~= 0 or not stdOut then return end
                local ok, windows = pcall(hs.json.decode, stdOut)
                log.i("yabai返回" .. tostring(ok) .. ", windowsCount: " .. #windows)
                if not ok or not windows then return end

                for _, win in ipairs(windows) do
                    if win.app == appName then
                        local space = tostring(win.space)
                        if space then
                            log.i("准备focus到space: " .. space)
                            hs.execute(string.format("%s -m space --focus %s", yabaiPath, space))
                        end
                        break
                    end
                end
            end,
            { "-m", "query", "--windows" }
        )
        task:start()
    end)
end

appWatcher:addLaunchCallback(onAppLaunch)
