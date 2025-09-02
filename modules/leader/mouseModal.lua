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
local step = 20

-- 辅助函数：移动鼠标
local function moveMouse(dx, dy)
    local pos = hs.mouse.getAbsolutePosition()
    hs.mouse.setAbsolutePosition({x = pos.x + dx, y = pos.y + dy})
end

-- 持续移动计时器
local moveTimer = nil
local moveInterval = 0.02  -- 移动间隔（秒）

-- 开始持续移动
local function startMoving(dx, dy)
    if moveTimer then
        moveTimer:stop()
    end
    moveTimer = hs.timer.doWhile(
        function() return true end,  -- 持续运行直到停止
        function() moveMouse(dx, dy) end,
        moveInterval
    )
end

-- 停止移动
local function stopMoving()
    if moveTimer then
        moveTimer:stop()
        moveTimer = nil
    end
end

-- 方向控制（按下开始移动，松开停止）
mouseMode:bind({}, "h", function() startMoving(-step, 0) end, function() stopMoving() end)   -- 左
mouseMode:bind({}, "l", function() startMoving(step, 0) end, function() stopMoving() end)    -- 右
mouseMode:bind({}, "k", function() startMoving(0, -step) end, function() stopMoving() end)   -- 上
mouseMode:bind({}, "j", function() startMoving(0, step) end, function() stopMoving() end)    -- 下

-- 左键点击
mouseMode:bind({}, "c", function()
    local pos = hs.mouse.getAbsolutePosition()
    hs.eventtap.leftClick(pos)
    mouseMode:exit()
end)

-- 右键点击
mouseMode:bind({}, "r", function()
    local pos = hs.mouse.getAbsolutePosition()
    hs.eventtap.rightClick(pos)
    mouseMode:exit()
end)

-- 退出模式
mouseMode:bind({}, "q", function() mouseMode:exit() end)

return mouseMode