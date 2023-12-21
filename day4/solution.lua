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
    scores[lineNumber] = wincount
    lineNumber = lineNumber + 1
end

sum = 0
for _, score in ipairs(scores) do
    sum = sum + (1 << (score-1))
end

print(sum)

--[[ 
-- Part 2:
-- Suppose we have n cards each with 10 wins. Let M be the mapping between card numbers and
-- the number of copies of that card we have, initialling with M[i] = 1 for all 1<=i<=n.
-- 
-- First, we have card 1, which has 10 wins. So, we iterate over M[2:11], incrementing the 
-- count for each card in that range.
-- 
-- Next, we have card 2. We have two copies of card two, each with 10 wins. So, we iterate over
-- cards M[i] where 3<=i<=12, and instead of adding one to each M[i], now we add M[2].
--
-- If we continue like this, we perform n iterations, and each iteration requires us to traverse
-- the next 10 elements in the list, which is effectively O(1) time.
--
-- So, we can do this in O(n) time.
--]]

copies = {}
for i=1, #scores do
    copies[i] = 1
end

for cardNo, score in ipairs(scores) do
    for i=1, score do
	local nextCard = cardNo + i
	if nextCard <= #copies then 
	    copies[nextCard] = copies[nextCard] + copies[cardNo]
	end
    end
end

sum = 0
for _, numCopies in ipairs(copies) do
    sum = sum + numCopies
end

print(sum)
