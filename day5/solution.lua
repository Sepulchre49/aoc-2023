io.input("input.txt")

local maps = {
    ["seeds"] = {}
}

for seed in io.read("l"):gmatch("%d+") do
    maps["seeds"][#maps["seeds"]+1] = tonumber(seed)
end

local currentMapping
for line in io.lines() do
    if line == "" then goto continue break end
	
    local srcName, destName = line:match("(%a+)%-to%-(%a+) map:")

    if srcName and destName then -- Mapping header
	currentMapping = srcName .. "-to-" .. destName
	maps[currentMapping] = {}
    else  -- Mapping data
	local destStart, srcStart, length = line:match(string.rep("(%d+)", 3, " "))
	if srcStart and destStart and length then -- probably not necessary, but a sanity check
	    srcStart, destStart, length = tonumber(srcStart), tonumber(destStart), tonumber(length)
	    maps[currentMapping][srcStart] = {
		["dest"] = destStart,
		["len"] = length
	    }
	end
    end

    ::continue::
end

function getNextTable(srcType)
    for tableName in pairs(maps) do
	local match = tableName:match(srcType .. "%-to%-%a+")
	if match then return match end
    end
    return nil
end

function getNextValue(src, tableName)
    for k, v in pairs(maps[tableName]) do
	local srcBegin, srcEnd = k, k + v.len
	if srcBegin <= src and src <= srcEnd then
	    local diff = src - srcBegin
	    return v.dest + diff
	end
    end	
    return src
end

function getSuffix(tableName)
    return tableName:match("%a+$")
end

local min = math.maxinteger
for _, seed in pairs(maps["seeds"]) do
    local value = seed
    local currentType = "seed"

    while currentType ~= "location" do
	local currentTable = getNextTable(currentType)
	value = getNextValue(value, currentTable)
	currentType = getSuffix(currentTable)
    end

    if value < min then min = value end
end
print(min)

