
local menu = {}

local currentFile = debug.getinfo(1, "S").source:sub(2)
local currentDir = currentFile:match("(.*/)")
-- hs.alert.show(currentDir)

function menu.show(width, height, htmlPath)
    local screen = hs.screen.mainScreen():frame()
    -- local width, height = 260, 160
    local x = screen.w - width - 30
    local y = screen.h - height - 50

    menu.view = hs.webview.new({x=x, y=y, w=width, h=height})
        -- :windowStyle{"titled", "closable"}
        :allowTextEntry(false)
        :url("file://" .. currentDir .. htmlPath)
        :level(hs.drawing.windowLevels.status)
        :show()

    -- hs.timer.doAfter(2, function() menu.hide() end)
end

function menu.hide()
    if menu.view then
        menu.view:delete()
        menu.view = nil
    end
end

return menu