--- 命令对象
--- @class Command
--- @field type string 命令类型, 也是路径
--- @field description string 命令描述
--- @field params table 命令参数

-- 创建一个logger实例
local log = hs.logger.new('MyLeader.command', 'debug')

local obj = {}

--- 创建新的命令对象
--- @param params table 命令参数
--- @return table 命令对象
function obj:new(params)
    local commandObj = {}
    setmetatable(commandObj, { __index = self })
    commandObj.type = params.type or "task" -- SHELL, LUA
    commandObj.description = params.description
    commandObj.params = params.params or {}
    return commandObj
end

function obj:execute()
    log.i(string.format("执行命令类型: %s", self.type))
    log.d(string.format("命令参数: %s", hs.inspect(self.params)))

    if self.type == "task" then
        log.d("执行任务类型命令")
    elseif self.type == "hotkey" then
        log.d("执行热键类型命令")
    elseif self.type == "window" then
        log.d("执行窗口类型命令")
    elseif self.type == "app" then
        log.d("执行应用类型命令")
    else
        log.e(string.format("无效的命令类型: %s", self.type))
    end
end

return obj
