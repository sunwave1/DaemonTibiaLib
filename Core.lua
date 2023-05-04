Core = {}
Core.__index = Core

function Core.new()
    local self = setmetatable({}, Core)
    return self
end

return Core