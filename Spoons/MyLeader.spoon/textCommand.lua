--- 输出字符串的命令

local obj = {}

function obj:execute(params)
    hs.eventtap.keyStrokes(params)
end

function obj:init(path)
    self.path = path
    return self
end

return obj
