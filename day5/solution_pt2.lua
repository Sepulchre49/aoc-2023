local Interval = require("interval")
local Set = require("set")

io.input("input.txt")

local seeds = {}

for begin, size in io.read("l"):gmatch("(%d+) (%d+)") do
    begin, size = tonumber(begin), tonumber(size)
    table.insert(seeds, Interval:new(begin, begin + size - 1))
end

local layers = {}
local layerName
local max = 0
for line in io.lines() do
    if line == "" then goto continue break end
	
    local srcName, destName = line:match("(%a+)%-to%-(%a+) map:")

    if srcName and destName then -- Mapping header
	layerName = srcName .. "-to-" .. destName
	layers[layerName] = {}
    else  -- Mapping data
	local destStart, srcStart, length = line:match(string.rep("(%d+)", 3, " "))
	if srcStart and destStart and length then -- probably not necessary, but a sanity check
	    srcStart, destStart, length = tonumber(srcStart), tonumber(destStart), tonumber(length)
	    if length > max then max = length end 
	    local domain = Interval:new(srcStart, srcStart+length-1)
	    local range = Interval:new(destStart, destStart+length-1)

	    layers[layerName][domain] = range
	end
    end

    ::continue::
end

for layerName, layer in pairs(layers) do
    local remaining = Set:new(Interval:new(0, math.maxinteger))
    for domain, range in pairs(layer) do
	-- Now, the hardest part is to find Z - the union of all the subintervals of the domain
	remaining = remaining - Set:new(domain)
    end

    for _, e in pairs(remaining.elements) do
	layers[layerName][e] = Interval:new(e.lower, e.upper)
    end
end

local mapping = {}
for _, seed in pairs(seeds) do
    mapping[seed] = Interval:new(seed.lower, seed.upper)
end

local utils = require("layer_util")

local currentLayer = "seed"
while currentLayer ~= "location" do
    local tableName = utils.getTableName(currentLayer, layers)

    local layerMap = {}
    for k, v in pairs(mapping) do
	    local delta = v.lower - k.lower
	for d, r in pairs(layers[tableName]) do
	    local intersection = v * d
	    if intersection ~= nil then
            local newDomain = Interval:new(intersection.lower - delta, intersection.upper - delta)
            local deltaB = r.lower - d.lower
		local newRange = Interval:new(intersection.lower + deltaB, intersection.upper + deltaB)
		layerMap[newDomain] = newRange
	    end
	end
    end
    mapping = layerMap
    currentLayer = utils.getSuffix(tableName)
end

local min
for k, v in pairs(mapping) do
    if min == nil or v.lower < min.lower then
	min = v
    end
end

print(min.lower)
