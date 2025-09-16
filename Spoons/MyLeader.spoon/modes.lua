--- 模式菜单管理器
--- @class MyLeader.modes
--- @field menus table 存储所有模式菜单
--- @field onAppFocus function 应用切换回调

local obj = {}
local menu = require("menu")
local loadMenu = require("loadMenu")
local log = hs.logger.new('modes', 'debug')

obj.menus = {}

--- 应用切换回调
--- @param appName string
obj.onAppFocus = function(appName)
    log.d("应用切换到: " .. appName)
    if appName == "Hammerspoon" then
        return
    end
    if menu.shownMenu then
        menu.shownMenu:hide()
    end
    if obj.menus[appName] then
        obj.menus[appName]:show()
    end
end

function obj:load(modeConfig)
    log.d("加载模式配置: " .. hs.inspect(modeConfig))
    -- 这里可以根据配置加载不同的模式菜单
    for _, params in pairs(modeConfig) do
        local modeMenu = menu:new({
            name = params["name"] or "Mode Menu",
            id = params["name"] or "mode_menu",
            father = nil,
        })
        loadMenu(modeMenu, params)
        self.menus[modeMenu.name] = modeMenu
    end
    return obj
end

return obj
