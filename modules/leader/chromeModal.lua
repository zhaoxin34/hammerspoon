
local chromeModal = hs.hotkey.modal.new()
local menu = require('modules.menu')

-- 进入模式提示
function chromeModal:entered()
    menu.show(260, 200, "leader/chrome_menu.html")
    hs.timer.doAfter(2, function() chromeModal:exit() end)
end

-- 退出模式提示
function chromeModal:exited()
    menu.hide()
end

-- 绑定 'l' 键发送 Ctrl+Tab
chromeModal:bind({"option"}, 'l', function()
    hs.eventtap.keyStroke({"ctrl"}, "tab")
end)

chromeModal:bind({"option"}, 'h', function()
    hs.eventtap.keyStroke({"ctrl", "shift"}, "tab")
end)

chromeModal:bind({"option"}, 's', function()
    hs.eventtap.keyStroke({"shift", "cmd"}, "a")
end)

-- 退出模式
chromeModal:bind({"option"}, "q", function() chromeModal:exit() end)

return chromeModal