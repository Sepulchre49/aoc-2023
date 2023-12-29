local lines = {}
for line in io.lines("input.txt") do
    lines[#lines+1] = line
end

local times, distances = {}, {}

for time in string.gmatch(lines[1], "%d+") do
    times[#times+1] = tonumber(time)
end

for distance in string.gmatch(lines[2], "%d+") do
    distances[#distances+1] = tonumber(distance)
end

function race_generator(T, D)
    return function(t)
	return (t * (T - t)) > D
    end
end

function get_num_ways_to_win(T, D)
    local isWinning = race_generator(T, D)

    local l, r = 0, T // 2
    local found = false
    while not found do
	local a = (l + r) // 2
	local x, y = isWinning(a), isWinning(a+1)
	if not x and y then
	    found = true
	    a = a + 1
	    local b = T - a
	    return b - a + 1
	elseif x then
	    r = a - 1
	else
	    l = a + 1
	end
    end
end

local product = 1
for i=1, #times do
    local T, D = times[i], distances[i]
    local n = get_num_ways_to_win(T, D)
    product = product * n
end

print(product)

--- Part 2
local time = ""
for match in string.gmatch(lines[1], "%d+") do
    time = time .. match
end

local distance = ""
for match in string.gmatch(lines[2], "%d+") do
    distance = distance .. match
end

time = tonumber(time)
distance = tonumber(distance)

local n = get_num_ways_to_win(time, distance)
print(n)
