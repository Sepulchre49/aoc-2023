local Heap = require("heap")
local Hand = require("hand")

local hands = {}
local myHeap = Heap:new()

for line in io.lines("input.txt") do
    local hand = line:match(string.rep("%w", 5))
    local bid = tonumber(line:match("%d+$"))

    local currentHand = Hand:new(hand, bid)
    table.insert(hands, currentHand)
    myHeap:insert(currentHand)
end

local sum = 0
local i = 1
while not myHeap:isEmpty() do
    local hand = myHeap:remove()
    sum = sum + hand.bid * i
    i = i + 1
end

print(sum)
