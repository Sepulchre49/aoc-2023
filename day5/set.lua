local Set = {}

function Set:new(lower, upper)
    local o = {
	["lower"] = lower or nil,
	["upper"] = upper or nil,
    }

    self.__index = self
    setmetatable(o, self)
    return o
end

function Set:isEmpty()
    return not (self.lower and self.upper)
end

function Set:size()
    if self:isEmpty() then return nil end
    return self.upper - self.lower
end

function Set:intersection(other)
    if self.upper < other.lower or other.upper < self.lower then 
	return Set:new()
    end

    local lower = self.lower < other.lower and self.lower or other.lower
    local upper = self.upper < other.upper and self.upper or other.upper
    return self:new(lower, upper)
end

return Set
