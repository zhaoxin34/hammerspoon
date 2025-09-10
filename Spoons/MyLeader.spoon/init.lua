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
obj.menu = menu:new({
    name = 'test',
    id = 'test_id',
    father = nil,
})

local rightCmdKey = require("rightCmdKey")

rightCmdKey.onRightCmdUp = function()
    if obj.menu:isShown() then
        obj.menu:pin()
    elseif obj.menu:isPinned() then
        obj.menu:hide()
    else
        obj.menu:show()
    end
end


-- 加载菜单
local loadMenu = require("loadMenu")
loadMenu(obj.menu, config["root"])

return obj
