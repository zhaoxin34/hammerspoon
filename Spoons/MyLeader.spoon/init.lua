package.path = package.path .. ";" .. hs.configdir .. "/Spoons/MyLeader.spoon/?.lua"

local obj = {}
local log = hs.logger.new('MyLeader.init', 'debug')
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


-- 加载菜单
local loadMenu = require("loadMenu")
loadMenu(obj.rootMenu, config["root"])

return obj
