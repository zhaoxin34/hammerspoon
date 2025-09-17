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

local function getSpaceId()
    local spaces = require("hs.spaces")

    local screen = hs.screen.mainScreen()
    local uuid = screen:getUUID()
    local current = spaces.activeSpaceOnScreen(screen)
    local list = spaces.allSpaces()[uuid]

    local index = hs.fnutils.indexOf(list, current)
    return index
end

local rect = calcViewRect()

local view = hs.webview.new(rect)
    :allowTextEntry(false)
    :html(html)
    :transparent(true)
    :level(hs.drawing.windowLevels.popUpMenu)

-- 请所有class为cell的元素
local function clearAllActive()
    local js = [[
    var els = document.getElementsByClassName('cell');
    for (var i = 0; i < els.length; i++) {
      els[i].classList.remove('active');
    }
    ]]
    view:evaluateJavaScript(js)
end

-- 动态加 class
local function setActive(spaceId)
    local js = [[
    var el = document.getElementById('space-]] .. spaceId .. [[');
    if (el) {
      el.classList.add('active');
    }
    ]]
    view:evaluateJavaScript(js)
end

function obj:show()
    clearAllActive()
    setActive(getSpaceId())
    view:show()
end

function obj:hide()
    view:hide()
end

return obj
