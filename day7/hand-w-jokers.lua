local HandWithJokers = {}

local cards = "AKQT98765432J"
local Cards = {}

for i=1, #cards do
    local card = cards:sub(i,i)
    local value = 15 - i
    Cards[card] = value
end

local Types = {
    HIGH_CARD       = 1,
    ONE_PAIR        = 2,
    TWO_PAIR        = 3,
    THREE_OF_A_KIND = 4,
    FULL_HOUSE	    = 5,
    FOUR_OF_A_KIND  = 6,
    FIVE_OF_A_KIND  = 7,
}

function HandWithJokers:new(hand, bid)
    local o = {
	hand = hand,
	bid = bid,
	type = nil
    }
   
    self.__index = self
    self.__eq    = HandWithJokers.equals
    self.__lt    = HandWithJokers.lessThan
    self.__gt    = HandWithJokers.greaterThan
    setmetatable(o, self)

    o:classify()

    return o
end

function HandWithJokers:classify()
    local freq = {}
    for i=1, #cards do
	local card = cards:sub(i,i)
	freq[card] = 0
    end

    for i = 1, 5 do
	local card = self.hand:sub(i,i)
	freq[card] = freq[card] + 1
    end

    local mostFrequentCard
    local max = -1 
    for card, freq in pairs(freq) do
	if freq > max and card ~= "J" then
	    mostFrequentCard = card
	    max = freq
	end
    end

    freq[mostFrequentCard] = max + freq["J"]
    freq["J"] = 0

    local freqList = {}
    for card, freq in pairs(freq) do
        if freq ~= 0 then
            table.insert(freqList, freq)
        end
    end

    table.sort(freqList, function (a,b) return a > b end)

    if freqList[1] == 5 then
        self.type = Types.FIVE_OF_A_KIND
    elseif freqList[1] == 4 then
        self.type = Types.FOUR_OF_A_KIND
    elseif freqList[1] == 3 and freqList[2] == 2 then
        self.type = Types.FULL_HOUSE
    elseif freqList[1] == 3 then
        self.type = Types.THREE_OF_A_KIND
    elseif freqList[1] == 2 and freqList[2] == 2 then
        self.type = Types.TWO_PAIR
    elseif freqList[1] == 2 then
        self.type = Types.ONE_PAIR
    else
        self.type = Types.HIGH_CARD
    end
end

function HandWithJokers:equals(other)
    if self.type ~= other.type then
	return false
    else
	for i=1, 5 do
	    local myCard, otherCard = self.hand:sub(i,i), other.hand:sub(i,i)
	    if Cards[myCard] ~= Cards[otherCard] then
		return false
	    end
	end
	return true
    end
end

function HandWithJokers:lessThan(other)
    if self.type < other.type then
	return true
    elseif self.type > other.type then
	return false
    else
	for i=1, 5 do
	    local myCard, otherCard = self.hand:sub(i,i), other.hand:sub(i,i)
	    if Cards[myCard] < Cards[otherCard] then
		return true
	    elseif Cards[myCard] > Cards[otherCard] then
		return false
	    end
	end
	return false
    end
end

function HandWithJokers:greaterThan(other)
    if self.type < other.type then
	return false
    elseif self.type > other.type then
	return true
    else
	for i=1, 5 do
	    local myCard, otherCard = self.hand:sub(i,i), other.hand:sub(i,i)
	    if Cards[myCard] < Cards[otherCard] then
		return false
	    elseif Cards[myCard] > Cards[otherCard] then
		return true
	    end
	end
	return false
    end
end

return HandWithJokers