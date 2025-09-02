------------------------------------------ 浏览器 Tab 切换 ------------------------------------------------
-- 辅助函数：检查前台应用是不是 Chrome
local function isChrome()
    local app = hs.application.frontmostApplication()
    return app and app:name() == "Google Chrome"
end

-- Option+H → 下一个 Tab
hs.hotkey.bind({"alt"}, "l", function()
    if isChrome() then
        hs.eventtap.keyStroke({"ctrl"}, "tab")
    end
end)

-- Option+Shift+H → 上一个 Tab
hs.hotkey.bind({"alt"}, "h", function()
    if isChrome() then
        hs.eventtap.keyStroke({"ctrl", "shift"}, "tab")
    end
end)

-- Option+J → 向下滚动（仅限 Chrome）
hs.hotkey.bind({"alt"}, "j",
    function() -- keyDown
        if isChrome() then
            scrollDown = hs.timer.doUntil(
                function() return false end,
                function() hs.eventtap.keyStroke({}, "down", 0) end,
                0.05 -- 每 0.05 秒滚一次
            )
        end
    end,
    function() -- keyUp
        if scrollDown then scrollDown:stop() end
    end
)

-- Option+K → 向上滚动（仅限 Chrome）
hs.hotkey.bind({"alt"}, "k",
    function() -- keyDown
        if isChrome() then
            scrollUp = hs.timer.doUntil(
                function() return false end,
                function() hs.eventtap.keyStroke({}, "up", 0) end,
                0.05
            )
        end
    end,
    function() -- keyUp
        if scrollUp then scrollUp:stop() end
    end
)