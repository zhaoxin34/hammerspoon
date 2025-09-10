--- 窗口操作的命令
local obj = {}

local function moveWindow(direction)
    local win = hs.window.focusedWindow()
    if not win then return end
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    if direction == "left" then
        f.x, f.y, f.w, f.h = max.x, max.y, max.w / 2, max.h
    elseif direction == "right" then
        f.x, f.y, f.w, f.h = max.x + max.w / 2, max.y, max.w / 2, max.h
    elseif direction == "up" then
        f.x, f.y, f.w, f.h = max.x, max.y, max.w, max.h / 2
    elseif direction == "down" then
        f.x, f.y, f.w, f.h = max.x, max.y + max.h / 2, max.w, max.h / 2
    elseif direction == "full" then
        f.x, f.y, f.w, f.h = max.x, max.y, max.w, max.h
    end

    win:setFrame(f)
end

function obj:execute(params)
    moveWindow(params)
end

function obj:init(path)
    self.path = path
    return self
end

return obj
