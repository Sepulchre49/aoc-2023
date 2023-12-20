io.input("input.txt")

function split (input, delim)
    local i,j = string.find(input, delim)
    local left = string.sub(input, 1, i-1)
    local right = string.sub(input, j+1, #input)

    return left, right
end

scores = {}
lineNumber = 1
for line in io.lines() do
    local winningNums, myNums = split(line, "|")
    _, winningNums = split(winningNums, "Card%s+%d+:%s")

    winningSet = {}
    for n in string.gmatch(winningNums, "%d+") do
	winningSet[tonumber(n)] = true
    end

    local wincount = 0
    for n in string.gmatch(myNums, "%d+") do
	n = tonumber(n)
	if winningSet[n] then wincount = wincount + 1 end
    end
    scores[lineNumber] = 1 << (wincount-1)
    lineNumber = lineNumber + 1
end

sum = 0
for _, score in ipairs(scores) do
    sum = sum + score
end

print(sum)
