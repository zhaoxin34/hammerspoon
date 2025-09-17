--- 九宫格菜单

local obj = {}

local currentFile = debug.getinfo(1, "S").source:sub(2)
local currentDir = currentFile:match("(.*/)")
local htmlPath = currentDir .. "sample.html"
local height, width = 300, 300
print(htmlPath)

local function read_all(path)
    local f, err = io.open(path, "r") -- 文本模式
    if not f then return nil, err end
    local content = f:read("*a")
    f:close()
    return content
end

local html, err = read_all(htmlPath)
if err then
    print(err)
end

--- 计算视图矩形
--- @return table 视图矩形
local function calcViewRect()
    local screen = hs.mouse.getCurrentScreen():fullFrame()
    local x = screen.x + (screen.w / 2) - (width / 2)
    local y = screen.y + (screen.h / 2) - (height / 2)
    return { x = x, y = y, w = width, h = height }
end

local rect = calcViewRect()

local view = hs.webview.new(rect)
    :allowTextEntry(false)
    :html(html)
    :transparent(true)
    :level(hs.drawing.windowLevels.popUpMenu)

function obj:show()
    view:show()
end

function obj:hide()
    view:hide()
end

return obj
