--加载菜单
local log = hs.logger.new('MyLeader.loadMenu', 'info')
local command = require("command")
local menu = require("menu")
local menuItem = require("menuItem")
local wifiName = hs.wifi.currentNetwork() or ""
print("当前WiFi: " .. wifiName)

local function loadMenu(_menu, _config)
    _menu.hideTimeout = _config["show_timeout"] or 2
    _menu.name = _config["label"] or "My Leader"
    log.d("加载配置: " .. hs.inspect(_config))

    -- 获取菜单项的键列表，支持显式顺序
    local keys = {}
    local order = _config["order"]

    if order and type(order) == "table" then
        -- 使用显式指定的顺序
        log.d("使用显式顺序: " .. hs.inspect(order))
        for _, key in ipairs(order) do
            if _config[key] then
                table.insert(keys, key)
            end
        end

        -- 添加未在 order 中指定但存在的键
        for key, _ in pairs(_config) do
            if key ~= "show_timeout" and key ~= "label" and key ~= "order" then
                local found = false
                for _, orderedKey in ipairs(order) do
                    if orderedKey == key then
                        found = true
                        break
                    end
                end
                if not found then
                    table.insert(keys, key)
                end
            end
        end
    else
        -- 没有指定顺序，使用默认排序规则
        log.d("使用默认排序")
        for key, _ in pairs(_config) do
            if key ~= "show_timeout" and key ~= "label" and key ~= "order" then
                table.insert(keys, key)
            end
        end

        -- 按键名排序（数字前缀优先）
        table.sort(keys, function(a, b)
            local aNum = tonumber(string.match(a, "^(%d+)"))
            local bNum = tonumber(string.match(b, "^(%d+)"))

            if aNum and bNum then
                return aNum < bNum
            elseif aNum then
                return true
            elseif bNum then
                return false
            else
                return a < b
            end
        end)
    end

    -- 按确定的顺序加载菜单项
    for _, key in ipairs(keys) do
        local item = _config[key]
        log.d("加载菜单项: " .. key .. ":" .. hs.inspect(item))

        if type(item) == "table" and not item.label then
            -- 这是一个命令
            local commandObj = command:new({
                type = item[1],
                params = item[2],
                description = item[3] or item[2],
            })
            local env = item[4] or nil
            if env
                and not string.find(wifiName, "^" .. env) then
                goto continue
            end
            local menuItemObj = menuItem:new({
                key = key,
                description = commandObj.description,
                type = "COMMAND",
                command = commandObj,
                env = env
            })
            _menu:addItem(menuItemObj)
        elseif type(item) == "table" and item.label then
            -- 这是一个子菜单
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
        ::continue::
    end
end

return loadMenu
