--- 菜单项类，负责定义菜单项
--- @class menuItem
--- @field key string 触发按键
--- @field description string 描述
--- @field type string 菜单项类型
--- @field menu table? 子菜单（可选）
--- @field father table? 父菜单（可选）
--- @field env string? 环境（可选）
local obj = {}

--- 创建菜单项
--- @param params table 参数表
---     params = {
---         key = "快捷键",
---         description = "描述",
---         type = "类型" -- MENU, COMMAND
---         menu = menu, -- type 为 MENU 时需要
---         command = commandObj -- type 为 COMMAND 时需要
---     }
--- @return table
function obj:new(params)
    local menuItemObj = {}
    setmetatable(menuItemObj, { __index = self })
    menuItemObj.key = params.key
    menuItemObj.description = params.description
    menuItemObj.type = params.type or "MENU" -- action, submenu, separator
    menuItemObj.env = params.env or nil
    if (menuItemObj.type ~= "MENU"
            and menuItemObj.type ~= "COMMAND"
            and menuItemObj.type ~= "FUNCTION") then
        error("Invalid menu item type: " .. tostring(menuItemObj.type))
    end

    if menuItemObj.type == "MENU" then
        menuItemObj.menu = params.menu
    elseif menuItemObj.type == "COMMAND" then
        menuItemObj.command = params.command
    elseif menuItemObj.type == "FUNCTION" then
        menuItemObj.before = params.before
        menuItemObj.after = params.after
    end
    return menuItemObj
end

return obj
