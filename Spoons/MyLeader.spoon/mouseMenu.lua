--- 鼠标模式的菜单

local menu = require("menu")
local menuItem = require("menuItem")
local menuObj = menu:new({ id = "mouse", name = "鼠标模式" })
local log = hs.logger.new('MyLeader.mouseMenu', 'debug')

-- 鼠标移动步长（像素）
local step = 20
-- 持续移动计时器
local moveTimer = nil
-- 移动间隔（秒）
local moveInterval = 0.02

-- 辅助函数：移动鼠标
local function moveMouse(dx, dy)
    log.d("moveMouse: " .. dx .. ", " .. dy)
    local pos = hs.mouse.absolutePosition()
    hs.mouse.absolutePosition({ x = pos.x + dx, y = pos.y + dy })
end

-- 开始持续移动
local function startMoving(dx, dy)
    log.d("startMoving: " .. dx .. ", " .. dy)
    if moveTimer then
        moveTimer:stop()
    end
    moveTimer = hs.timer.doWhile(
        function()
            return not menuObj:isHidden()
        end, -- 持续运行直到停止
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

-- 开始鼠标滚动
local function startScrolling(dx, dy)
    if moveTimer then
        moveTimer:stop()
    end
    moveTimer = hs.timer.doWhile(
        function() return not menuObj:isHidden() end, -- 持续运行直到停止
        function()
            hs.eventtap.event.newScrollEvent({ dx, dy }, {}, "line"):post()
        end,
        moveInterval
    )
end

menuObj:addItem(menuItem:new({
    key = "h",
    description = "左移",
    type = "FUNCTION",
    before = function() startMoving(-step, 0) end,
    after = function() stopMoving() end
}))

menuObj:addItem(menuItem:new({
    key = "l",
    description = "右移",
    type = "FUNCTION",
    before = function() startMoving(step, 0) end,
    after = function() stopMoving() end
}))

menuObj:addItem(menuItem:new({
    key = "k",
    description = "上移",
    type = "FUNCTION",
    before = function() startMoving(0, -step) end,
    after = function() stopMoving() end
}))

menuObj:addItem(menuItem:new({
    key = "j",
    description = "下移",
    type = "FUNCTION",
    before = function() startMoving(0, step) end,
    after = function() stopMoving() end
}))

menuObj:addItem(menuItem:new({
    key = "c",
    description = "左键点击",
    type = "FUNCTION",
    before = function()
        local pos = hs.mouse.absolutePosition()
        hs.eventtap.leftClick(pos)
        menuObj:hide()
    end
}))

menuObj:addItem(menuItem:new({
    key = "r",
    description = "右键点击",
    type = "FUNCTION",
    before = function()
        local pos = hs.mouse.absolutePosition()
        hs.eventtap.rightClick(pos)
        menuObj:hide()
    end
}))

-- 鼠标上滚
menuObj:addItem(menuItem:new({
    key = "e",
    description = "上滚",
    type = "FUNCTION",
    before = function() startScrolling(0, 1) end,
    after = function() stopMoving() end
}))

-- 鼠标下滚
menuObj:addItem(menuItem:new({
    key = "d",
    description = "下滚",
    type = "FUNCTION",
    before = function() startScrolling(0, -1) end,
    after = function() stopMoving() end
}))

return menuObj
