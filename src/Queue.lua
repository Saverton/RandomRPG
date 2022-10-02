--[[
    Queue : Special table class that appends new entries on the end and pulls entries from the first index.
    @author Saverton
]]

Queue = Class{}

function Queue:init(list)
    self.queue = {}
    for i, index in ipairs(list) do
        self:append(index)
    end
end

-- append a new item onto the end of the list
function Queue:append(item)
    table.insert(self.queue, item)
end

-- pull the first index from the list
function Queue:next()
    return table.remove(self.queue, 1)
end

function Queue:getSize()
    return #self.queue
end

function Queue:isEmpty()
    return self:getSize() == 0
end