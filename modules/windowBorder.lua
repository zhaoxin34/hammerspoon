local obj = {}

-- 配置
obj.borderWidth = 6           -- 边框宽度 (粗)
obj.borderColor = {          -- 边框颜色 (紫色 #8000FF)
    red = 0.5, green = 0, blue = 1.0, alpha = 1
}
obj.autoHideDelay = 1.5     -- 自动隐藏延迟（秒）

obj.canvas = nil
obj.hideTimer = nil

-- 显示边框
function obj:showBorder()
    local win = hs.window.focusedWindow()
    if not win then return end

    -- 隐藏之前的边框
    self:hideBorder()

    local frame = win:frame()
    local screen = win:screen()
    local screenFrame = screen:frame()

    -- 计算相对于屏幕的坐标
    local x = frame.x
    local y = screenFrame.h - frame.y - frame.h

    -- 创建 canvas
    self.canvas = hs.canvas.new({
        x = x - self.borderWidth,
        y = y - self.borderWidth,
        w = frame.w + self.borderWidth * 2,
        h = frame.h + self.borderWidth * 2
    })

    self.canvas:behaviorCanJoinAllSpaces("normal")
    self.canvas:level("floating")

    self.canvas[1] = {
        type = "rectangle",
        strokeColor = self.borderColor,
        strokeWidth = self.borderWidth,
        fillColor = { alpha = 0 }
    }

    self.canvas:show()

    -- 设置自动隐藏定时器
    if self.hideTimer then self.hideTimer:stop() end
    self.hideTimer = hs.timer.doAfter(self.autoHideDelay, function()
        self:hideBorder()
    end)
end

-- 隐藏边框
function obj:hideBorder()
    if self.canvas then
        self.canvas:delete()
        self.canvas = nil
    end
end

-- 初始化
function obj:init()
    -- 监听窗口焦点变化
    hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function()
        self:showBorder()
    end)

    -- 监听窗口移动/调整大小
    hs.window.filter.default:subscribe(hs.window.filter.windowMoved, function()
        self:showBorder()
    end)
end

return obj
