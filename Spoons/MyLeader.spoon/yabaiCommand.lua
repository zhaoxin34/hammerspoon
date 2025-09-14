--- 执行yabai的命令
--- @class yabaiCommandl
local obj = {}
local task = require("taskCommand")

local yabaiPath = "/opt/homebrew/bin/yabai"

function obj:execute(params)
    task:execute({ yabaiPath, params })
end

function obj:init(path)
    self.path = path
    return self
end

return obj
