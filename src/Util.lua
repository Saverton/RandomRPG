--[[
    Util class

    Author: Colton Ogden & Saverton
    cogden@cs50.harvard.edu

    Helper functions
]]

--[[
    Given an "atlas" (a texture with multiple sprites), as well as a
    width and a height for the tiles therein, split the texture into
    all of the quads by simply dividing it evenly.
]]
function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

function Collide(a, b)
    return not (a.x > b.x + b.width or a.x + a.width < b.x or
        a.y > b.y + b.height or a.y + a.height < b.y)
end

function Contains(list, element)
    for i, index in pairs(list) do
        if index == element then
            return true
        end
    end
    return false
end

function ContainsName(list, element)
    for i, index in pairs(list) do
        if index.name == element then
            return true
        end
    end
    return false
end

function GetIndex(list, name)
    for i, index in pairs(list) do
        if index.name == name then
            return i
        end
    end
    return -1
end

function GetDistance(a, b)
    return (math.sqrt(math.pow(math.abs(a.x - b.x), 2) + math.pow(math.abs(a.y - b.y), 2)))
end

function LoadWorldList()
    love.filesystem.setIdentity('random_rpg')

    local worlds = love.filesystem.getDirectoryItems('worlds')
    local selections = {}

    for i, world in ipairs(worlds) do
        table.insert(selections, Selection(world, function() 
            gStateStack:pop()
            gStateStack:pop()
            gStateStack:push(LoadState('worlds/' .. world))
        end))
    end

    table.insert(selections, Selection('Back', function() gStateStack:pop() end))

    return selections
end

-- print a message in white with a shadow rendered one pixel to the right and down
function PrintWithShadow(message, x, y)
    love.graphics.setColor({0, 0, 0, 0.5})
    love.graphics.print(message, math.floor(x + 1), math.floor(y + 1)) -- print the shadow in transparent black
    love.graphics.setColor({1, 1, 1, 1})
    love.graphics.print(message, math.floor(x), math.floor(y)) -- print the message in white
end

-- print a message in white with a shadow rendered one pixel to the right and down, allows for printf inputs
function PrintFWithShadow(message, x, y, limit, orientation)
    love.graphics.setColor({0, 0, 0, 0.5})
    love.graphics.printf(message, math.floor(x + 1), math.floor(y + 1), limit, orientation) -- print the shadow in transparent black
    love.graphics.setColor({1, 1, 1, 1})
    love.graphics.printf(message, math.floor(x), math.floor(y), limit, orientation) -- print the message in white
end

-- return the product of all boosts in a table
function ProductOfBoosts(boostTable)
    local totalBoost = 1
    for i, boost in ipairs(boostTable) do
        totalBoost = totalBoost * boost.multiplier
    end
    return totalBoost
end