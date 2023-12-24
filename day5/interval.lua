local Interval = {}

function Interval:new(lower, upper)
    if upper < lower then return error("Invalid bounds. Upper bound must be less than lower bound") end
    local o = {
	["lower"] = lower or nil,
	["upper"] = upper or nil,
    }

    self.__index = self
    self.__add = Interval.union
    self.__sub = Interval.difference
    self.__mul = Interval.intersection
    self.__eq  = Interval.equals
    self.__tostring = Interval.toString
    setmetatable(o, self)
    return o
end

function Interval:size()
    return self.upper - self.lower + 1
end

function Interval:equals(other)
    return self.lower == other.lower and self.upper == other.upper
end

function Interval:intersection(other)
    if self.upper < other.lower or other.upper < self.lower then 
	return nil
    end

    local lower = self.lower > other.lower and self.lower or other.lower
    local upper = self.upper < other.upper and self.upper or other.upper
    return self:new(lower, upper)
end

function Interval:difference(other)
    -- If A == B, return nil
    if self.lower == other.lower and self.upper == other.upper then
	return {nil}
    -- If A completely contains B, and A != B, the result will be two 
    -- disjoint intervals.
    elseif self.lower < other.lower and self.upper > other.upper then
	local A = Interval:new(self.lower, other.lower-1)	
	local B = Interval:new(other.upper+1, self.upper)
	return { A, B }
    -- If A and B are completely disjoint, then we return a copy of A
    elseif self.upper < other.lower or other.upper < self.lower then
	local A = Interval:new(self.lower, self.upper)
	return { A }
    -- Otherwise, we overlap on only one side
    -- B overlaps A on the right side of A
    else
	if self.lower < other.lower then
	    local A
	    if self.lower <= other.lower-1 then 
		A = Interval:new(self.lower, other.lower-1)
	    end
	    return { A }
	else -- B overlaps A on the left side of A
	    local A
	    if other.upper+1 <= self.upper then
		A = Interval:new(other.upper+1, self.upper)
	    end
	    return { A }
	end
    end
end

function Interval:union(other)
    if self.upper < other.lower-1 or other.upper < self.lower-1 then
	return { Interval:new(self.lower, self.upper), Interval:new(other.lower, other.upper) }
    else
	local lower = math.min(self.lower, other.lower)
	local upper = math.max(self.upper, other.upper)
	return { Interval:new(lower, upper) }
    end
    
end

function Interval:toString()
    return "[" .. self.lower .. ", " .. self.upper .. "]"
end

function Interval:lOverlap(other)
    return other.lower <= self.lower and other.upper < self.upper
end

function Interval:rOverlap(other)
    return other.lower <= self.upper and self.upper <= other.upper
end

function Interval:contains(other)
    return self.lower < other.lower and other.lower < other.upper
end

if not pcall(debug.getlocal, 4, 1) then
    local A = Interval:new(5, 10)
    local B = Interval:new(15, 20)
    local C = A - B

    for _, v in pairs(C) do
	print(v)
    end
end

return Interval
