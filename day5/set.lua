local Interval = require("interval")
local Set = {}

function Set:new(...)
    local o = {
	["elements"] = {...}
    }
    self.__index = self
    self.__sub = Set.difference
    self.__tostring = Set.toString
    setmetatable(o, self)

    o:merge()
    return o
end

function Set:isEmpty()
    return #self.elements == 0
end

function Set:merge()
    if self:isEmpty() then return end

    table.sort(self.elements, function (a,b) return a.lower < b.lower end)

    local merged = {}
    local current = self.elements[1]
    for i=2, #self.elements do
	local next = self.elements[i]
	if next.lower <= current.upper + 1 then
	    current = (current + next)[1]
	else
	    table.insert(merged, current)
	    current = next
	end
    end

    table.insert(merged, current)
    self.elements = merged
end

function Set:difference(other)
    local intervals = {}
    local i, j = 1, 1
    local curr = self.elements[i]

    while i <= #self.elements and j <= #other.elements do
	local B = other.elements[j]
	local diff = curr - B
	
	if curr.upper < B.lower then
		table.insert(intervals, curr)
		i = i + 1
		curr = self.elements[i]
    elseif B.upper < curr.lower then
		j = j + 1
	elseif curr:lOverlap(B) then
	    curr = diff[1]
	    j = j + 1
	elseif curr:rOverlap(B) then
	    table.insert(intervals, diff[1])
	    i = i + 1
	    curr = self.elements[i]
	else
	    table.insert(intervals, diff[1])
	    curr = diff[2]
	    j = j + 1
	end
    end

    table.insert(intervals, curr)

    return Set:new(table.unpack(intervals))
end

function Set:toString()
    if self:isEmpty() then return "{}" end

    local s = "" .. self.elements[1]:toString()
    for i=2, #self.elements do
	s = s .. " U " .. self.elements[i]:toString()
    end

    return s
end
if not pcall(debug.getlocal, 4, 1) then
    local A = Set:new(Interval:new(1, 10), Interval:new(18, 90))
    local B = Set:new(Interval:new(5, 9), Interval:new(12, 15), Interval:new(18, 30))
    local C = A - B
    print(A)
    print(B)
    print(C)

end

return Set
