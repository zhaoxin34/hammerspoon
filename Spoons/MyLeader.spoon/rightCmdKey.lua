--- 右侧cmd按下的功能

local obj = {}
local log = hs.logger.new('rightCmdKey', 'info')

-- 定义两个方法，分别在按下和抬起时触发
local function onRightCmdDown()
    if obj.onRightCmdDown then
        obj.onRightCmdDown()
    end
end

local function onRightCmdUp()
    if obj.onRightCmdUp then
        obj.onRightCmdUp()
    end
end

-- 用来记录右 Cmd 是否正在按下
local rightCmdPressed = false

-- 监听 flagsChanged 事件（修饰键状态变化）
obj.rightCmdWatcher = hs.eventtap.new(
    { hs.eventtap.event.types.flagsChanged },
    function(event)
        local keyCode = event:getKeyCode()
        local flags = event:getFlags()

        if keyCode == 54 then -- 右 Cmd
            log.d("右 Cmd 状态变化: " .. hs.inspect(flags))
            log.d("当前 rightCmdPressed: " .. tostring(rightCmdPressed))
            if flags.cmd and not (flags.alt or flags.ctrl or flags.shift or flags.fn) then
                -- 进入按下状态（避免重复触发）
                if not rightCmdPressed then
                    rightCmdPressed = true
                    onRightCmdDown()
                end
            else
                -- 松开
                if rightCmdPressed then
                    rightCmdPressed = false
                    onRightCmdUp()
                end
            end
        end
    end
)

obj.rightCmdWatcher:start()

return obj
