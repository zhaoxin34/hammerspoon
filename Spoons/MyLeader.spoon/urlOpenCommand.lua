--- 打开url
local obj = {}

function obj:execute(params)
    hs.urlevent.openURL(params)
end

function obj:init(path)
    self.path = path
    return self
end

return obj
