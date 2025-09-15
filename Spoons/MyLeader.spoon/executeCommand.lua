--- 执行hs.execute命令

local obj = {}

local log = hs.logger.new('MyLeader.executeCommand', 'debug')

function obj:execute(params)
    local out, success, _, rc = hs.execute(params)
    log.d("执行命令" .. params .. ": " .. tostring(success) .. ", 返回: " .. out .. ", code:" .. rc)
end

function obj:init(path)
    self.path = path
    return self
end

return obj
