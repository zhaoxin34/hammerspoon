-- 快捷键绑定模块
-- 用于配置全局快捷键绑定

-- hs.keycodes.currentSourceID() 可以获得输入法id
-- 英文输入法 ID
local englishInputSource = "com.apple.keylayout.ABC"
-- 中文输入法 ID (简体拼音)
local chineseInputSource = "im.rime.inputmethod.Squirrel.Hans"

-- 切换到英文输入法
local function switchToEnglish()
	-- 检查当前是否是中文输入法
	local currentSource = hs.keycodes.currentSourceID()
	if currentSource ~= englishInputSource then
		-- 如果当前是中文输入法，先发送 esc 键退出输入状态
		hs.eventtap.keyStroke({}, "Escape", 0)
	end
	-- 切换到英文输入法
	hs.keycodes.currentSourceID(englishInputSource)
	hs.alert("已切换到英文输入法")
end

-- 切换到中文输入法
local function switchToChinese()
	hs.keycodes.currentSourceID(chineseInputSource)
	hs.alert("已切换到中文输入法")
end

-- 绑定快捷键
-- ctrl+option+e -> 切换英文输入法
hs.hotkey.bind({ "ctrl", "option" }, "E", switchToEnglish)

-- ctrl+option+c -> 切换中文输入法
hs.hotkey.bind({ "ctrl", "option" }, "C", switchToChinese)
