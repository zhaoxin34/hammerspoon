--- 执行task的命令
--- @class MyLeader.taskCommand

local obj = {}
local log = hs.logger.new('MyLeader.taskCommand', 'debug')

local function callback(command, args, rc, out, err)
    local output = "执task命令, 参数: " .. "command: " .. hs.inspect(command) .. ", args: " .. hs.inspect(args)
    output = output .. ", return: " .. rc .. "out: " .. out .. ", err: " .. err
    if rc == "0" then
        log.d(output)
    else
        log.w(output)
    end
end

function obj:execute(params)
    local command = params[1]
    local args = params[2]
    hs.task.new(command, function(exitCode, stdOut, stdErr)
            callback(command, args, exitCode, stdOut, stdErr)
        end,
        args):start()
end

function obj:init(path)
    self.path = path
    return self
end

return obj
