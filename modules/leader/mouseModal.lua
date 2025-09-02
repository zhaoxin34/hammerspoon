------------------------------------------ 进入鼠标模式的快捷键：Option + M ---------------------------------------------
local mouseMode = hs.hotkey.modal.new()
local menu = require('modules.menu')

-- 进入模式提示
function mouseMode:entered()
    menu.show(260, 300, "leader/mouse_menu.html")
end

-- 退出模式提示
function mouseMode:exited()
    menu.hide()
end

-- 鼠标移动步长（像素）
local step = 32

-- 辅助函数：移动鼠标
local function moveMouse(dx, dy)
    local pos = hs.mouse.getAbsolutePosition()
    hs.mouse.setAbsolutePosition({x = pos.x + dx, y = pos.y + dy})
end

-- 方向控制
mouseMode:bind({}, "h", function() moveMouse(-step, 0) end)   -- 左
mouseMode:bind({}, "l", function() moveMouse(step, 0) end)    -- 右
mouseMode:bind({}, "k", function() moveMouse(0, -step) end)   -- 上
mouseMode:bind({}, "j", function() moveMouse(0, step) end)    -- 下

-- 左键点击
mouseMode:bind({}, "c", function()
    local pos = hs.mouse.getAbsolutePosition()
    hs.eventtap.leftClick(pos)
end)

-- 右键点击
mouseMode:bind({}, "r", function()
    local pos = hs.mouse.getAbsolutePosition()
    hs.eventtap.rightClick(pos)
end)

-- 退出模式
mouseMode:bind({}, "q", function() mouseMode:exit() end)

return mouseMode