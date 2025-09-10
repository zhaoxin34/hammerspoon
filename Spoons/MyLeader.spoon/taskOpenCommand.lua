--- 执行open任务的命令

local obj = {}

function obj:execute(params)
    hs.task.new("/usr/bin/env", nil, { "open", params }):start()
end

function obj:init(path)
    self.path = path
    return self
end

return obj
