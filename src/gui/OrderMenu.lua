--[[
    Order Menu: menu derived class that creates a menu which switches indexes between one another.
    @author Saverton
]]

OrderMenu = Class{__includes = Menu}

function OrderMenu:init(def, selections)
    Menu.init(self, def)

    if selections ~= nil then
        self.selections = selections
    end

    for i, selection in ipairs(self.selections) do
        selection.oldPos = i
    end

    self.selector = 1
    self.selectors = {
        {pos = 1, selected = false, text = 'select an index'},
        {pos = 1, selected = false, text = 'select index to switch'}
    }
end

function OrderMenu:update(dt)
    local selector = self.selectors[self.selector]
    if love.keyboard.wasPressed('w') or love.keyboard.wasPressed('up') then
        love.audio.play(gSounds['menu_blip_1'])
        selector.pos = (selector.pos + #self.selections - 2) % (#self.selections) + 1
    elseif love.keyboard.wasPressed('s') or love.keyboard.wasPressed('down') then
        love.audio.play(gSounds['menu_blip_1'])
        selector.pos = (((selector.pos) % #self.selections) + 1)
    end

    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        love.audio.play(gSounds['menu_select_1'])
        selector.selected = true
        if self.selector < #self.selectors then
            self.selector = self.selector + 1
            self.selectors[self.selector].pos = selector.pos
        else
            self:switch()
        end
    end
end

function OrderMenu:switch()
    local temp = self.selections[self.selectors[1].pos]
    self.selections[self.selectors[1].pos] = self.selections[self.selectors[2].pos]
    self.selections[self.selectors[2].pos] = temp

    for i, selector in pairs(self.selectors) do
        selector.selected = false
        selector.pos = 1
    end
    self.selector = 1
end

function OrderMenu:getOrderChange()
    local order = {}

    for i, selection in ipairs(self.selections) do
        table.insert(order, {oldPos = selection.oldPos, newPos = i})
    end

    return order
end

function OrderMenu:render()
    self.panel:render()

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf(self.title, love.math.newTransform(self.x + SELECTION_MARGIN, self.y + SELECTION_MARGIN), (self.width - (2 *SELECTION_MARGIN)), 'center')

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf(self.selectors[self.selector].text, love.math.newTransform(self.x + SELECTION_MARGIN, self.y + SELECTION_MARGIN + 20), (self.width - (2 *SELECTION_MARGIN)), 'center')
    for i, selection in ipairs(self.selections) do
        local x, y = self.x + SELECTION_MARGIN, self.y + (SELECTION_MARGIN * i) + (SELECTION_HEIGHT * i) + 30
        love.graphics.printf(selection.name, love.math.newTransform(x, y),
            self.width - (2 * SELECTION_MARGIN), 'left')
        for k, selector in pairs(self.selectors) do
            if (k == self.selector or selector.selected) and selector.pos == i then
                love.graphics.rectangle('line', x - 1, y - 1, self.width - (SELECTION_MARGIN * 2) + 2, SELECTION_HEIGHT)
            end
        end
    end
end