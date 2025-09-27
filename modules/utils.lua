local obj = {}

obj.prevSpaceId = 0
obj.currentSpaceId = 0
local spaces = require("hs.spaces")
local window = require("hs.window")

obj.getSpaceId = function()
	local screen = hs.screen.mainScreen()
	local uuid = screen:getUUID()
	local current = spaces.activeSpaceOnScreen(screen)
	local list = spaces.allSpaces()[uuid]

	local index = hs.fnutils.indexOf(list, current)
	return index
end

-- 获取当前聚焦窗口的标题
obj.getFocusWindowTitle = function()
	local win = window.focusedWindow()
	if win then
		return win:title()
	else
		return ""
	end
end

-- 监听space变化，设置上次的spaceId
-- 监听 Space 切换
obj.spacesWatcher = hs.spaces.watcher.new(function()
	obj.prevSpaceId = obj.currentSpaceId
	obj.currentSpaceId = obj.getSpaceId()
end)

obj.spacesWatcher:start()

return obj
