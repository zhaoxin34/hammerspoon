------------------------------------------ 双击大小写切换 发送 esc ------------------------------------------------
local doubleTapThreshold = 0.3
local lastCapslockTime = 0

capsWatcher = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(e)
    local flags = e:getFlags()
    local keyCode = e:getKeyCode()
    if keyCode == 57 then  -- CapsLock 的 keyCode
        local now = hs.timer.secondsSinceEpoch()
        if (now - lastCapslockTime) < doubleTapThreshold then
            hs.eventtap.keyStroke({}, "escape")
        end
        lastCapslockTime = now
    end
end)

capsWatcher:start()
