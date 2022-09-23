--[[
    Menu Class: A menu gui has a list of selections and may have selectors that are used to select an option.
    @author Saverton
]]

Menu = Class{}

function Menu:init(definitions, instance)
    self.x, self.y, self.width, self.height = definitions.x, definitions.y, definitions.width, definitions.height -- position of the menu
    self.title = definitions.title or 'Menu' -- title of the menu
    self.subtitle = definitions.subtitle -- the subtitle of the menu, often instructions or info about selections
    self.panel = Panel(self.x, self.y, self.width, self.height) -- panel that holds the menu
    self:getSelections(definitions, instance)
        -- set the selections to the instance of this menu or the defined selections for this menu type in the definitions table
    self.parent = (instance or {}).parent or self -- reference to the parent menu for functions that require outside references
    self.selector = 1 -- the selector that is currently being modified
    self.selectors = definitions.selectors or {{position = 1, onChoose = function(position, menu) self.selections[position].onSelect(menu.parent) end}}
        -- the selectors that will navigate this menu, by default executes the selection's onSelect function.
    self.showSelector = false -- flag to render the selector, only set to true in update function so the only selector rendered is on the top menu
end

-- update the menu each frame
function Menu:update(dt)
    local selector = self.selectors[self.selector] -- reference to the current selector
    if selector ~= nil then
        local numOfSelections = selector.maxIndex or #self.selections
        if love.keyboard.wasPressed('w') or love.keyboard.wasPressed('up') then
            self:setSelectorPosition(selector, (selector.position + numOfSelections - 2) % (numOfSelections) + 1) -- move up one selection
        elseif love.keyboard.wasPressed('s') or love.keyboard.wasPressed('down') then
            self:setSelectorPosition(selector, ((selector.position) % numOfSelections) + 1) -- move down one selection
        elseif love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            love.audio.play(gSounds['gui']['menu_select_1'])
            selector.onChoose(math.max(math.min(selector.position, numOfSelections), 1), self) -- select this selection
        end
    end
    self.showSelector = true
end

-- render this menu
function Menu:render()
    self.panel:render(1, self.x, self.y) -- render the background panel
    self:printTitleAndSubtitle() -- print the title and subtitle of the menu
    self:printSelections() -- print all the selections in the menu
end

-- retrieve the selections for this menu from the definitions or instance data
function Menu:getSelections(definitions, instance)
    if (instance or {}).selections == nil then
        self.selections = definitions.selections
    else
        self.selections = instance.selections
    end
end

-- print the title and subtitle of this menu
function Menu:printTitleAndSubtitle()
    love.graphics.setFont(gFonts['medium']) -- medium font for title
    love.graphics.printf(self.title, love.math.newTransform(self.x + SELECTION_MARGIN, self.y + SELECTION_MARGIN), 
        (self.width - (2 *SELECTION_MARGIN)), 'center') -- print the title
    love.graphics.setFont(gFonts['small']) -- small font for subtitle
    love.graphics.printf(self.subtitle, love.math.newTransform(self.x + SELECTION_MARGIN, self.y + SELECTION_MARGIN + 20), 
        (self.width - (2 *SELECTION_MARGIN)), 'center') -- print the subtitle
end

-- navigate the selector to a new index
function Menu:setSelectorPosition(selector, position)
    selector.position = position
    gSounds['gui']['menu_blip_1']:play() -- play menu blip sound
end

-- print each selection in the menu
function Menu:printSelections()
    for i, selection in ipairs(self.selections) do
        local x, y = self.x + SELECTION_MARGIN, self.y + (SELECTION_MARGIN * i) + (SELECTION_HEIGHT * i) + 30 -- x and y positions of the selection
        selection:render(x, y, self.width - (2 * SELECTION_MARGIN)) -- render the selection
        for k, selector in pairs(self.selectors) do
            if self.showSelector and selector.position == i then
                self:renderSelector(x, y, k) -- render any selectors on this position
            end
        end
    end
    self.showSelector = false
end

-- render a selector at an x and y position
function Menu:renderSelector(x, y, index)
    if self.selector == index then
        love.graphics.setColor(1, 1, 0, 1) -- set color to yellow for current selector
    end
    love.graphics.draw(gTextures['selector'], gFrames['selector'][1], x - 20, y - 4) -- draw left selector
    love.graphics.draw(gTextures['selector'], gFrames['selector'][1], 
        x + self.width + 20 - (2 * SELECTION_MARGIN), y - 4, 0, -1, 1) -- draw right selector
    love.graphics.rectangle('line', math.floor(x), math.floor(y), self.width - (2 * SELECTION_MARGIN), SELECTION_HEIGHT) -- draw selection box
    love.graphics.setColor(1, 1, 1, 1)
end

-- swap two indexes in the selections list
function Menu:switch(index1, index2)
    local temp = self.selections[index1]
    self.selections[index1] = self.selections[index2]
    self.selections[index2] = temp
end