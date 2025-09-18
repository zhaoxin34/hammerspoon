--- 九宫格菜单

local obj = {}

local log = hs.logger.new('nineSpace', 'info')
local currentFile = debug.getinfo(1, "S").source:sub(2)
local currentDir = currentFile:match("(.*/)")
local htmlPath = currentDir .. "sample.html"
local height, width = 480, 480
local yabaiPath = "/opt/homebrew/bin/yabai"

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
    local js = "clearAllActive()"
    view:evaluateJavaScript(js)
end

--- 通过yabai加载空间的窗口信息
local function loadSpaceWindows()
    local clearContent = "clearContent()"
    view:evaluateJavaScript(clearContent)

    hs.task.new(yabaiPath, function(exitCode, stdOut, stdErr)
        if exitCode ~= 0 or not stdOut then return end
        log.i("stdOut: " .. stdOut)
        local js = "setContent(" .. stdOut .. ")"
        view:evaluateJavaScript(js)
    end, { "-m", "query", "--windows" }):start()
end

-- 动态加 class
local function setActive(spaceId)
    local js = "setActive(" .. spaceId .. ")"
    view:evaluateJavaScript(js)
end

function obj:show()
    clearAllActive()
    setActive(getSpaceId())
    loadSpaceWindows()
    view:show()
end

function obj:hide()
    view:hide()
end

return obj
