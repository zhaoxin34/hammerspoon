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

--加载菜单
local command = require("command")
local menuItem = require("menuItem")

local function loadMenu(_menu, _config)
    _menu.hideTimeout = _config["show_timeout"] or 2
    _menu.name = _config["label"] or "My Leader"
    log.d(hs.inspect(_config))
    for key, item in pairs(_config) do
        log.d("加载菜单项: " .. key .. ":" .. hs.inspect(item))
        -- 如果没有label，那么就是一个command
        if type(item) == "table" and not item.label then
            local commandObj = command:new({
                name = item[1],
                params = item[2],
                description = item[3] or item[2],
            })
            local menuItemObj = menuItem:new({
                key = key,
                description = commandObj.description,
                type = "COMMAND",
                command = commandObj,
            })
            _menu:addItem(menuItemObj)
        elseif type(item) == "table" and item.label then
            local subMenu = menu:new({
                name = item.label,
            })
            local menuItemObj = menuItem:new({
                key = key,
                description = item.label,
                type = "MENU",
                menu = subMenu,
            })
            _menu:addItem(menuItemObj)
            loadMenu(subMenu, item)
        end
    end
end

loadMenu(obj.menu, config["root"])

return obj
