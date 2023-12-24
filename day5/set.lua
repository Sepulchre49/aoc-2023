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
    local result = {}
    for _, interval in ipairs(self.elements) do
	for _, otherInterval in ipairs(other.elements) do
	    for _, diffInterval in pairs(interval - otherInterval) do
		table.insert(result, diffInterval)
	    end
	end
    end

    return Set:new(table.unpack(result))
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
    print(A)
    print(B)
    local C = A - B
    print(C)
end

return Set
