-- 创建日志记录器
local log = hs.logger.new("main", "debug")
hs.logger.historySize(1000)
log.i("Hammerspoon 启动")

hs.ipc.cliInstall("/opt/homebrew/")

package.path = package.path .. ";~/.hammerspoon/modules/?.lua"

-- 切换应用切换到小写，锁屏关闭应用
require("modules.appWatcher")

-- spoon doc
--https://github.com/Hammerspoon/hammerspoon/blob/master/SPOONS.md

hs.loadSpoon("SpoonInstall")

-- -- 使用webview展示所有快捷点
-- spoon.SpoonInstall:andUse("HSKeybindings")
-- spoon.HSKeybindings:show()

-- 使用字典或者notepad打开选中的单词
spoon.SpoonInstall:andUse("LookupSelection")
spoon.LookupSelection:bindHotkeys({
	lexicon = { { "ctrl", "alt", "cmd" }, "l" },
	neue_notiz = { { "ctrl", "alt", "cmd" }, "n" },
	hsdocs = { { "ctrl", "alt", "cmd" }, "h" },
})

-- -- hot-key的modal管理方法
-- spoon.SpoonInstall:andUse("ModalMgr")

hs.loadSpoon("MyLeader")

-- hs.hotkey.bind({ "ctrl", "alt", "cmd" }, "R", function()
--     hs.reload()
-- end)
hs.alert("配置已重新加载")

-- -- hs.task.new("/usr/bin/env", nil, { "open", "https://www.google.com" }):start()

-- hs.eventtap.keyStroke({"cmd", "ctrl" }, "q")
-- hs.eventtap.keyStroke({ "ctrl" }, "tab", 0)
hs.loadSpoon("EmmyLua")

-- 调用这个加载location模块到定位隐私列表，进而可以打开权限
hs.location.get()

hs.hotkey.bind({}, "F15", function()
	hs.application.launchOrFocus("wezterm")
end)
hs.hotkey.bind({}, "F16", function()
	hs.application.launchOrFocus("obsidian")
end)

hs.hotkey.bind({}, "F17", function()
	hs.application.launchOrFocus("Google Chrome")
end)
