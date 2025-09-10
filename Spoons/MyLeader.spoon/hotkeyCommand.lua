--- 触发热键的命令
--- @class MyLeader.hotkeyCommand

local obj = {}
local log = hs.logger.new('MyLeader.hotkeyCommand', 'debug')

function obj:execute(params)
    log.d("执行热键命令, 参数: " .. "modifiers: " .. hs.inspect(params[1]) .. ", key: " .. hs.inspect(params[2]))
    hs.eventtap.keyStroke(params[1], params[2])
end

function obj:init(path)
    self.path = path
    return self
end

return obj
