local Heap = {}

function Heap:new()
    local o = {
	items = {},
	size = 0,
    }

    self.__index = self
    setmetatable(o, self)

    return o
end

function Heap:insert(item)
    self.items[#self.items+1] = item
    self.size = self.size + 1
    self:upheap(#self.items)
end

function Heap:remove()
    if self:isEmpty() then return nil end
    local removed = self.items[1]
    self.items[1] = self.items[#self.items]
    self.items[#self.items] = nil
    self.size = self.size - 1
    self:downheap(1)
    return removed
end

function Heap:isEmpty()
    return self.size == 0
end

function Heap:upheap(idx)
    local current = self.items[idx]
    local parentIdx = idx // 2
    local parent = self.items[parentIdx]
    local siblingIdx = idx % 2 == 0 and idx + 1 or idx - 1
    local sibling = self.items[siblingIdx]

    if parent and current < parent then
        local smallestChildIdx
        if not sibling then 
            smallestChildIdx = idx
        else 
            smallestChildIdx = current < sibling and idx or siblingIdx
        end
        self:swap(parentIdx, smallestChildIdx)
        self:upheap(parentIdx)
    end
end

function Heap:downheap(idx)
    local current = self.items[idx]
    local l, r = self.items[2*idx], self.items[2*idx+1]
    
    if not l and not r then
	return
    elseif current > l or current > r then
        local smallestChildIdx
        if not l then smallestChildIdx = 2*idx + 1
        elseif not r then smallestChildIdx = 2*idx
        else
	    smallestChildIdx = l < r and 2*idx or 2*idx + 1
        end
	self:swap(idx, smallestChildIdx)
	self:downheap(smallestChildIdx)
    end
end

function Heap:swap(i, j)
    local tmp = self.items[i]
    self.items[i] = self.items[j]
    self.items[j] = tmp
end

return Heap
