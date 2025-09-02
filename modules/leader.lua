--------------------------------------------------------
-- 双击 Cmd 进入 Leader 模式
--------------------------------------------------------

local menu = require('modules.menu')
local mouseModal = require('modules.leader.mouseModal')
local chromeModal = require('modules.leader.chromeModal')

local lastCmdTime = 0
local doublePressInterval = 0.3 -- 允许的双击时间（秒）


-- 顶层菜单 (Leader)
local leader = hs.hotkey.modal.new()

function leader:entered()
    chromeModal:exit()
    mouseModal:exit()
    menu.show(260, 220, "leader/leader_menu.html")
end

function leader:exited()
    menu.hide()
end

--------------------------------------------------------
-- 监听 Cmd 双击
--------------------------------------------------------
local flagsWatcher = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(e)
    local flags = e:getFlags()
    if flags.cmd then
        local now = hs.timer.secondsSinceEpoch()
        if (now - lastCmdTime) < doublePressInterval then
            -- 双击 Cmd → 打开 Leader
            leader:enter()
        end
        lastCmdTime = now
    end
end)

flagsWatcher:start()

-- q 退出 leader 模式
leader:bind('', 'q', function() leader:exit() end)

leader:bind('', 'm', function()
    leader:exit()
    mouseModal:enter()
end)

leader:bind('', 'c', function()
    -- 打开或切换到chrome app
    local theApp = hs.application.get("Google Chrome")
    if theApp then
        -- Chrome 已运行，切换到它
        theApp:activate()
    else
        -- Chrome 未运行，启动它
        hs.application.open("Google Chrome")
    end
    leader:exit()
end)

leader:bind('', 'i', function()
    -- 打开或切换到chrome app
    local theApp = hs.application.get("Iterm")
    if theApp then
        -- Chrome 已运行，切换到它
        theApp:activate()
    else
        -- Chrome 未运行，启动它
        hs.application.open("Iterm")
    end
    leader:exit()
end)

leader:bind('', 'v', function()
    -- 打开或切换到chrome app
    local theApp = hs.application.get("Visual Studio Code")
    if theApp then
        -- Chrome 已运行，切换到它
        theApp:activate()
    else
        -- Chrome 未运行，启动它
        hs.application.open("Visual Studio Code")
    end
    leader:exit()
end)

return {
    flagsWatcher,
    leader
}