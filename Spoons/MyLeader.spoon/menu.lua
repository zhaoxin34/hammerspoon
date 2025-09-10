--- 菜单类，负责展示菜单
--- @class menu
--- @field id string 菜单ID
--- @field name string 菜单名称
--- @field father table? 父菜单（可选）
--- @field items table 菜单项列表
--- @field view hs.webview? 菜单视图（可选）
--- @field status string 菜单状态（"HIDDEN", "SHOWN", "PINNED"）
--- @field show function 展示菜单
--- @field hide function 隐藏菜单

local obj = {}
local log = hs.logger.new('MyLeader.menu', 'debug')

-- 当前正在显示的菜单
obj.shownMenu = nil

local function getMenuHtml(menuObj)
    local html = [[

    <!DOCTYPE html>
    <html lang="zh-CN">
    <head>
        <title>Leader Menu</title>
        <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover"/>
        <meta charset="UTF-8">
        <style>
            body {
                font-family: Menlo, monospace;
                background-color: rgba(40, 44, 52, 0.8);
                color: white;
            }

            .menu-item {
                font-size: 13px;
                padding: 2px 10px;
            }

            .hot-key {
                color: #ffb5f4;
                font-weight: bold;
            }

            .menu-value {
                color: #aad9ff;
            }

            h1 {
                font-size: 14px;
                margin: 2px 10px;
            }
        </style>
    </head>

    <body>
        <h1>]] .. (menuObj.name or "Menu") .. [[</h1>
    ]]

    for _, item in ipairs(menuObj.items) do
        html = html .. '<div class="menu-item"><span class="hot-key">' .. item.key
        html = html .. '</span> → <span class="menu-value">'
        html = html .. item.description .. '</span></div>\n'
    end

    html = html .. [[
    </body>
    </html>
    ]]

    return html
end

---create html view for menu
---@param menuObj menu
---@return hs.webview
local function createView(menuObj)
    local screen = hs.screen.mainScreen():frame()
    local width = 260
    local titleHeight = 28
    local height = #menuObj.items * 23 + titleHeight
    local x = screen.w - width - 30
    local y = screen.h - height - 30

    local view = hs.webview.new({ x = x, y = y, w = width, h = height })
        :allowTextEntry(false)
        :html(getMenuHtml(menuObj))
        :transparent(true)
        :shadow(true)
        :level(hs.drawing.windowLevels.popUpMenu)
    return view
end

---create modal for menu
---@param menuObj menu
---@return hs.hotkey.modal
local function createViewModal(menuObj)
    local modal = hs.hotkey.modal.new()

    modal:bind('', 'escape', function()
        modal:exit()
        menuObj:hide()
    end)

    -- 避免重复绑定相同的键
    local usedKeys = {}
    for _, item in ipairs(menuObj.items) do
        log.d("绑定键: " .. item.key .. " -> " .. hs.inspect(item))
        if not usedKeys[item.key] then
            usedKeys[item.key] = true
            modal:bind('', item.key, function()
                if item.type == "COMMAND" and item.command then
                    item.command:execute()
                    modal:exit()
                    menuObj:hide()
                elseif item.type == "MENU" and item.menu then
                    modal:exit()
                    menuObj:hide()
                    item.menu:show()
                end
            end)
        else
            log.w("键 " .. item.key .. " 已被使用，跳过绑定")
        end
    end

    return modal
end

--- 展示菜单, 创建modal
function obj:show()
    if self:isShown() or self:isPinned() or obj.shownMenu then
        return
    end
    self.view = self.view or createView(self)
    self.modal = self.modal or createViewModal(self)
    self.view:show()
    self.modal:enter()
    self.hideTimer = hs.timer.doAfter(self.hideTimeout, function() self:hide() end)
    self.status = "SHOWN"

    -- 当前展示的菜单
    obj.shownMenu = self
end

--- 是否是展示状态
function obj:isShown()
    return self.status == "SHOWN"
end

--- 是否是固定状态
function obj:isPinned()
    return self.status == "PINNED"
end

function obj:pin()
    if not self:isShown() then
        return
    end
    self.status = "PINNED"
    if self.hideTimer then
        self.hideTimer:stop()
        self.hideTimer = nil
    end
end

--- 隐藏菜单, 如果是固定状态则不隐藏
function obj:hide()
    if self.view then
        self.view:delete()
        self.view = nil
    end
    self.status = "HIDDEN"
    if self.hideTimer then
        self.hideTimer:stop()
        self.hideTimer = nil
    end
    obj.shownMenu = nil
end

--- 初始化菜单
--- params = {
---     name = "菜单名称",
---     id = "菜单ID",
---     fatherId = "父菜单ID",
--- }
function obj:new(params)
    local menuObj = {}
    setmetatable(menuObj, self)
    self.__index = self
    menuObj.id = params.id
    menuObj.name = params.name
    menuObj.father = params.father
    menuObj.items = {}
    menuObj.hideTimeout = 2
    return menuObj
end

--- 添加菜单项
--- @param item menuItem 菜单项
function obj:addItem(item)
    table.insert(self.items, item)
    if item.type == "MENU" and item.menu then
        item.menu.father = self
    end
end

return obj
