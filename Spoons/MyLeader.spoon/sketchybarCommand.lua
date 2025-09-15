--- 执行yabai的命令
--- @class sketchybarCommandl
local obj = {}
local task = require("taskCommand")

local sketchybarPath = "/opt/homebrew/bin/sketchybar"

function obj:execute(params)
    task:execute({ sketchybarPath, params })
end

function obj:init(path)
    self.path = path
    return self
end

return obj
