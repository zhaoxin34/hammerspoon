package.path = package.path .. ";~/.hammerspoon/modules/?.lua;"

require("modules.hello")
require("modules.lockWatcher")

-- spoon doc
--https://github.com/Hammerspoon/hammerspoon/blob/master/SPOONS.md

hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall:andUse("LeftRightHotkey", {
    start = true
})

-- 使用webview展示所有快捷点
spoon.SpoonInstall:andUse("HSKeybindings")

spoon.SpoonInstall:andUse("LookupSelection")

-- hot-key的modal管理方法
spoon.SpoonInstall:andUse("ModalMgr")

-- 使用字典或者notepad打开选中的单词
spoon.LookupSelection:bindHotkeys({
    lexicon = { { "ctrl", "alt", "cmd" }, "l" },
    neue_notiz = { { "ctrl", "alt", "cmd" }, "n" },
    hsdocs = { { "ctrl", "alt", "cmd" }, "h" }
})

-- 自动重新加载配置，暂时注释掉
-- spoon.SpoonInstall:andUse("ReloadConfiguration", {
--     start = true
-- })

hs.loadSpoon("MyLeader")

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "R", function()
    hs.reload()
end)
hs.alert("配置已重新加载")

-- spoon.HSKeybindings:show()

-- hs.task.new("/usr/bin/env", nil, { "open", "https://www.google.com" }):start()

for i,j in pairs(hs.logger.history()) do
    print(i,j)
end

require("hs.ipc")
hs.ipc.cliInstall()