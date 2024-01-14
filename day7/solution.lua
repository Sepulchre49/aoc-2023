local Heap = require("heap")
local Hand = require("hand")
local HandWithJokers = require("hand-w-jokers")

local hands = {}
local myHeap = Heap:new()
local myJokerHeap = Heap:new()

for line in io.lines("input.txt") do
    local hand = line:match(string.rep("%w", 5))
    local bid = tonumber(line:match("%d+$"))

    local currentHand = Hand:new(hand, bid)
    local currentHandWithJokers = HandWithJokers:new(hand, bid)
    table.insert(hands, currentHand)
    myHeap:insert(currentHand)
    myJokerHeap:insert(currentHandWithJokers)
end

local sum = 0
local i = 1
while not myHeap:isEmpty() do
    local hand = myHeap:remove()
    sum = sum + hand.bid * i
    i = i + 1
end

print(sum)

local sumJoker = 0
i = 1
while not myJokerHeap:isEmpty() do
    local handWithJokers = myJokerHeap:remove()
    sumJoker = sumJoker + handWithJokers.bid * i
    i = i + 1
end
print(sumJoker)

