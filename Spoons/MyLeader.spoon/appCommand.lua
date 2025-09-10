--- 打开app的命令

local obj = {}

function obj:execute(params)
    hs.application.launchOrFocus(params)
end

function obj:init(path)
    self.path = path
    return self
end

return obj
