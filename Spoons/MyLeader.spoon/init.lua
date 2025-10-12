package.path = package.path .. ";" .. hs.configdir .. "/Spoons/MyLeader.spoon/?.lua"

local obj = {}
local log = hs.logger.new('LeaderInit', 'info')
obj.__index = obj

obj.name = "MyLeader"
obj.version = "1.0"
obj.author = "Zhaoxin <zhaoxin3456@gmail.com>"
obj.homepage = ""

-- 读取配置
local toml = require("tinytoml")
local config = toml.parse(hs.configdir .. "/leader.toml")
log.d("配置内容: " .. hs.inspect(config))

-- 加载菜单
local menu = require("menu")
menu.position = config["menu_position"] or "bottom_center"
if config["menu_style"] then
    menu.style = config["menu_style"]
end

obj.rootMenu = menu:new({
    name = '',
    id = '',
    father = nil,
})

local rightCmdKey = require("rightCmdKey")

rightCmdKey.onRightCmdUp = function()
    if not menu.shownMenu then
        obj.rootMenu:show()
    else
        if menu.shownMenu:isShown() then
            menu.shownMenu:pin()
        elseif menu.shownMenu:isPinned() then
            menu.shownMenu:hide()
        end
    end
end

-- 添加鼠标模式
local mouseMenu = require("mouseMenu")
local menuItem = require("menuItem")
obj.rootMenu:addItem(menuItem:new({
    key = "m",
    description = "启用鼠标模式",
    type = "MENU",
    menu = mouseMenu
}))

-- 加载菜单
local loadMenu = require("loadMenu")
loadMenu(obj.rootMenu, config["root"])

-- 加载应用focus的监听
-- local appWatcher = require("appWatcher")
-- local modes = require("modes"):load(config["modes"])
-- appWatcher.activeCallback = modes.onAppFocus

-- 设置模式键响应
-- menu.modeKey = config["mode_key"]
-- menu.modeKeyPressCallback = function()
--     local app = hs.application.frontmostApplication()
--     local appName = app:name() or ""
--     modes.onAppFocus(appName)
-- end

-- 加载九宫格菜单
local nineSpace = require("nineSpace.init")

--- 显示九宫格菜单
obj.showNineSpace = function()
    nineSpace:show()
end

--- 隐藏九宫格菜单
obj.hideNineSpace = function()
    nineSpace:hide()
end

-- 打开应用后，使用yabai和appWatch跳转到对应space
-- require("yabaiLaunchAppCallback")
return obj
