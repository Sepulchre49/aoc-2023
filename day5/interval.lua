local Interval = {}

function Interval:new(lower, upper)
    local o = {
	["lower"] = lower or nil,
	["upper"] = upper or nil,
    }

    self.__index = self
    self.__add = Interval.union
    self.__sub = Interval.difference
    self.__mul = Interval.intersection
    self.__tostring = Interval.toString
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

function Interval:difference(other)
    if self.upper < other.lower or other.upper < self.lower then
	return { Interval:new(self.lower, self.upper) }
    elseif self.lower < other.lower and self.upper > other.upper then
	return { Interval:new(self.lower, other.lower-1), Interval:new(other.upper+1, self.upper) }
    elseif other.lower <= self.upper then
	return { Interval:new(self.lower, other.lower-1) }
    elseif self.lower <= self.upper then
	return { Interval:new(other.lower+1, self.upper) }
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

if not pcall(debug.getlocal, 4, 1) then
    local A = Interval:new(1, 10)
    local B = Interval:new(5, 20)

    print("A: ", A)
    print("B: ", B)
    
    local C = A * B
    print("C = A * B: ", C)

    B = Interval:new(11, 20)
    print("B: ", B)
    C = A - B
    print("C = A - B: ", C[1])
    A.lower = 6
    print("A: ", A)
    print("C: ", C[1])


    A = Interval:new(1, 100)
    B = Interval:new(4, 8)
    C = Interval:new(50, 60)
    --Z = A - B - C

    A = Interval:new(1, 15)
    B = Interval:new(16, 30)
    Z = A + B
    print(Z[1])

    B = Interval:new(15, 30)
    Z = A + B
    print(Z[1])

    B = Interval:new(17, 30)
    Z = A + B
    print(Z[1])
    print(Z[2])

    E = nil
    D = { Interval:new(10, 20), Interval:new(11, 30), Interval:new(31, 40) }
    for _, set in pairs(D) do
	E = set
    end
end

return Interval
