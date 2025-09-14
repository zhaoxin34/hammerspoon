--- 命令对象
--- @class Command
--- @field type string 命令类型, 也是路径
--- @field description string 命令描述
--- @field params table 命令参数

-- 创建一个logger实例
local log = hs.logger.new('MyLeader.command', 'info')

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

local appCommand = require("appCommand"):init("app")
local windowCommand = require("windowCommand"):init("window")
local taskOpenCommand = require("taskOpenCommand"):init("open")
local urlOpenCommand = require("urlOpenCommand"):init("url")
local hotkeyCommand = require("hotkeyCommand"):init("hotkey")
local hsCommand = require("hsCommand"):init("hs")
local textCommand = require("textCommand"):init("text")
local taskCommand = require("taskCommand"):init("task")
local yabaiCommand = require("yabaiCommand"):init("yabai")

obj.commands = {
    [appCommand.path] = appCommand,
    [windowCommand.path] = windowCommand,
    [taskOpenCommand.path] = taskOpenCommand,
    [urlOpenCommand.path] = urlOpenCommand,
    [hotkeyCommand.path] = hotkeyCommand,
    [hsCommand.path] = hsCommand,
    [textCommand.path] = textCommand,
    [taskCommand.path] = taskCommand,
    [yabaiCommand.path] = yabaiCommand,
}

function obj:execute()
    log.d(string.format("执行命令类型: %s", self.type))
    log.d(string.format("命令参数: %s", hs.inspect(self.params)))
    if obj.commands[self.type] then
        obj.commands[self.type]:execute(self.params)
    else
        log.e(string.format("无效的命令类型: %s", self.type))
    end
end

return obj
