--------------------------------------------------------
-- 双击 Cmd 进入 Leader 模式
--------------------------------------------------------

local menu = require('modules.menu')

local lastCmdTime = 0
local doublePressInterval = 0.3 -- 允许的双击时间（秒）


-- 顶层菜单 (Leader)
local leader = hs.hotkey.modal.new() -- Option+Space 作为 leader 键

function leader:entered()
    menu.show(260, 160, "leader/leader_menu.html")
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

local mouseModal = require('modules.leader.mouseModal')

leader:bind('', 'm', function()
    leader:exit()
    mouseModal:enter()
end)

return {
    flagsWatcher,
    leader
}