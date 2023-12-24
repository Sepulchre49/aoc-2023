local Interval = {}

function Interval:new(lower, upper)
    local o = {
	["lower"] = lower or nil,
	["upper"] = upper or nil,
    }

    self.__index = self
    self.__mul = Interval.intersection
    setmetatable(o, self)
    return o
end

function Interval:isEmpty()
    return not (self.lower and self.upper)
end

function Interval:size()
    if self:isEmpty() then return nil end
    return self.upper - self.lower
end

function Interval:intersection(other)
    if self.upper < other.lower or other.upper < self.lower then 
	return Interval:new()
    end

    local lower = self.lower > other.lower and self.lower or other.lower
    local upper = self.upper < other.upper and self.upper or other.upper
    return self:new(lower, upper)
end

local A = Interval:new(1, 10)
local B = Interval:new(5, 20)
local C = A * B
print(C.lower, C.upper)

return Interval
