--- 执行hs脚本

local obj = {}

function obj:execute(params)
    load(params)()
end

function obj:init(path)
    self.path = path
    return self
end

return obj
