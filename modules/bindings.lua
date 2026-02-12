local screen = hs.screen.mainScreen() -- 获取主屏幕
local screenFrame = screen:frame() -- 获取屏幕的尺寸

-- 计算右下角的位置
local rightBottom = hs.geometry(
	screenFrame.x + screenFrame.w - 150, -- 右边位置（可调节宽度）
	screenFrame.y + screenFrame.h - 50 -- 下边位置（可调节高度）
)

hs.keycodes.inputSourceChanged(function()
	local inputMethod = hs.keycodes.currentMethod()
	hs.alert.show("输入法：" .. (inputMethod or "ABC"), 1, rightBottom)
end)
