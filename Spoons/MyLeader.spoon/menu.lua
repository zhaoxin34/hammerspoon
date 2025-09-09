--- 菜单类，负责展示菜单
--- @class menu
--- @field id string 菜单ID
--- @field name string 菜单名称
--- @field father table? 父菜单（可选）
--- @field items table 菜单项列表
--- @field view hs.webview? 菜单视图（可选）
--- @field status string 菜单状态（"HIDDEN", "SHOWN", "PINNED"）

local obj = {}
local log = hs.logger.new('MyLeader.menu', 'debug')
local hideTimer = nil

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

--- 展示菜单
function obj:show()
    if self:isShown() or self:isPinned() then
        return
    end
    self.view = self.view or createView(self)
    self.view:show()
    hideTimer = hs.timer.doAfter(self.hideTimeout, function() self:hide() end)
    self.status = "SHOWN"
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
    if hideTimer then
        hideTimer:stop()
        hideTimer = nil
    end
end

--- 隐藏菜单, 如果是固定状态则不隐藏
function obj:hide()
    if self.view then
        self.view:delete()
        self.view = nil
    end
    self.status = "HIDDEN"
    if hideTimer then
        hideTimer:stop()
        hideTimer = nil
    end
end

--- 初始化菜单
--- params = {
---     name = "菜单名称",
---     id = "菜单ID",
---     fatherId = "父菜单ID",
---     items = { 子菜单列表 }
--- }
function obj:new(params)
    local menuObj = {}
    setmetatable(menuObj, self)
    self.__index = self
    menuObj.id = params.id
    menuObj.name = params.name
    menuObj.father = params.father
    menuObj.items = params.items or {}
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
