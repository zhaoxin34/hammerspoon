--- 菜单类，负责展示菜单
--- @class menu
--- @field id string 菜单ID
--- @field name string 菜单名称
--- @field father table? 父菜单（可选）
--- @field items table 菜单项列表
--- @field view hs.webview? 菜单视图（可选）
--- @field status string 菜单状态（"HIDDEN", "SHOWN", "PINNED"）
--- @field mode string 菜单模式（"FLOAT", "PIN"）
--- @field show function 展示菜单
--- @field hide function 隐藏菜单
--- @field isPinned function 是否处于固定状态
--- @field addItem function 添加菜单项
--- @field isHidden function 是否处于隐藏状态
--- @field shownMenu menu? 当前正在显示的菜单（可选）
--- @field modeKey string? 模式呼出键（可选）
--- @field modeKeyPressCallback function? 模式呼出键按下回调（可选）
--- @field position string 菜单位置（"top_center", "bottom_center", "right_bottom", "left_bottom"）

local obj = {}
local log = hs.logger.new('menu', 'info')
obj.modeKey = nil
obj.modeKeyPressCallback = nil
obj.position = "bottom_center"

-- 当前正在显示的菜单
obj.shownMenu = nil
-- 样式
obj.style = [[
    body {
        font-family: Menlo, monospace, JetBrainsMono Nerd Font;
        background-color: rgba(40, 44, 52, 0.8);
        color: white;
    }

    .menu-container {
        width: 100%;
        height: 100%;
    }

    .menu-item {
        font-size: 13px;
        padding: 2px 10px;
        line-height: 16px;
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
]]

local function getMenuHtml(menuObj)
    local html = [[

    <!DOCTYPE html>
    <html lang="zh-CN">
    <head>
        <title>Leader Menu</title>
        <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover"/>
        <meta charset="UTF-8">
        <style>]] .. obj.style .. [[</style>
    </head>

    <body>
        <div class="menu-container">
        <h1>]] .. (menuObj.name or "Menu") .. [[</h1>
    ]]

    for _, item in ipairs(menuObj.items) do
        html = html .. '<div class="menu-item"><span class="hot-key">' .. item.key
        html = html .. '</span> → <span class="menu-value">'
        html = html .. item.description .. '</span></div>\n'
    end

    html = html .. [[
    </div>
    </body>
    </html>
    ]]

    return html
end

--- 计算视图矩形
--- @param menuObj menu
--- @return table 视图矩形
local function calcViewRect(menuObj)
    local screen = hs.mouse.getCurrentScreen():fullFrame()
    local width = 260
    local titleHeight = 32
    local height = #menuObj.items * 21 + titleHeight
    local x = 0
    local y = 0
    local margintVertical = 32
    if menuObj.position == "top_center" then
        x = screen.x + (screen.w / 2) - (width / 2)
        y = screen.y + margintVertical
    elseif menuObj.position == "bottom_center" then
        x = screen.x + (screen.w / 2) - (width / 2)
        y = screen.y + screen.h - height - margintVertical
    elseif menuObj.position == "right_bottom" then
        x = screen.x + screen.w - width - margintVertical
        y = screen.y + screen.h - height - margintVertical
    elseif menuObj.position == "left_bottom" then
        x = screen.x + margintVertical
        y = screen.y + screen.h - height - margintVertical
    end

    return { x = x, y = y, w = width, h = height }
end

---create html view for menu
---@param menuObj menu
---@return hs.webview
local function createView(menuObj)
    local rect = calcViewRect(menuObj)

    local view = hs.webview.new(rect)
        :allowTextEntry(false)
        :html(getMenuHtml(menuObj))
        :transparent(true)
        :level(hs.drawing.windowLevels.popUpMenu)
    return view
end

---create modal for menu
---@param menuObj menu
---@return hs.hotkey.modal
local function createViewModal(menuObj)
    local modal = hs.hotkey.modal.new()

    modal:bind('', 'escape', function()
        menuObj:hide()
    end)

    -- 绑定模式呼出键
    if obj.modeKey and obj.modeKeyPressCallback then
        modal:bind('', obj.modeKey, function()
            obj.modeKeyPressCallback()
        end)
    end

    -- 避免重复绑定相同的键
    local usedKeys = {}
    for _, item in ipairs(menuObj.items) do
        log.d("绑定键: " .. item.key .. " -> " .. hs.inspect(item))
        if not usedKeys[item.key] then
            usedKeys[item.key] = true
            if item.type == "COMMAND" and item.command then
                modal:bind('', item.key, function()
                    item.command:execute()
                    if not menuObj:isPinned() then
                        menuObj:hide()
                    end
                end)
            elseif item.type == "MENU" and item.menu then
                modal:bind('', item.key, function()
                    menuObj:hide()
                    item.menu:show()
                end)
                -- 自定义方式
            elseif item.type == "FUNCTION" then
                modal:bind('', item.key, item.before, function()
                    item.after()
                    if not menuObj:isPinned() then
                        menuObj:hide()
                    end
                end)
            else
                log.e("未知的菜单项类型: " .. tostring(item.type))
            end
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
    if not self.silent then
        self.view:frame(calcViewRect(self))
        self.view:show()
    end
    self.modal:enter()
    if self.mode == "FLOAT" then
        self.status = "SHOWN"
        self.hideTimer = hs.timer.doAfter(self.showTimeout, function() self:hide() end)
    else
        self.status = "PINNED"
    end

    if self.afterShow then
        self.afterShow()
    end

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

--- 是否是隐藏状态
function obj:isHidden()
    return self.status == "HIDDEN"
end

function obj:pin()
    log.d("pin menu: " .. (self.name))
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
        self.view:hide(0.2)
    end
    if self.modal then
        self.modal:exit()
    end
    self.status = "HIDDEN"
    if self.hideTimer then
        self.hideTimer:stop()
        self.hideTimer = nil
    end
    if self.afterHide then
        self.afterHide()
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
    menuObj.showTimeout = params.showTimeout or 2
    menuObj.mode = params.mode or "FLOAT"
    menuObj.silent = params.silent or false
    menuObj.afterShow = params.afterShow or nil
    menuObj.afterHide = params.afterHide or nil
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
