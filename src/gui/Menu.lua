--[[
    Menu Class: a menu in a gui panel
    @author Saverton
]]

Menu = Class{}

function Menu:init(def, inst)
    if inst == nil then
        inst = {}
    end
    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height
    self.title = def.title or 'Menu'

    self.panel = Panel(self.x, self.y, self.width, self.height)

    if inst.selections == nil then
        self.selections = def.selections
    else
        self.selections = inst.selections
    end

    self.selector = 1
    self.selectors = def.selectors or {
        {pos = 1, selected = false, text = '', onChoose = function(pos) self.selections[pos].onSelect(self.parent) end}
    }

    self.parent = inst.parent or nil
end

function Menu:update(dt)
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
            selector.onChoose(selector.pos)
        end
    end

    if self.selector > #self.selectors then
        self.selector = 1
    end
end

function Menu:render()
    self.panel:render()

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf(self.title, love.math.newTransform(self.x + SELECTION_MARGIN, self.y + SELECTION_MARGIN), (self.width - (2 *SELECTION_MARGIN)), 'center')

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf(self.selectors[self.selector].text, love.math.newTransform(self.x + SELECTION_MARGIN, self.y + SELECTION_MARGIN + 20), (self.width - (2 *SELECTION_MARGIN)), 'center')
    for i, selection in ipairs(self.selections) do
        local x, y = self.x + SELECTION_MARGIN, self.y + (SELECTION_MARGIN * i) + (SELECTION_HEIGHT * i) + 30
        love.graphics.printf(selection.displayName, love.math.newTransform(x, y),
            self.width - (2 * SELECTION_MARGIN), 'left')
        for k, selector in pairs(self.selectors) do
            if (k == self.selector or selector.selected) and selector.pos == i then
                love.graphics.rectangle('line', x - 1, y - 1, self.width - (SELECTION_MARGIN * 2) + 2, SELECTION_HEIGHT)
            end
        end
    end
end

function Menu:switch(index1, index2)
    local temp = self.selections[index1]
    self.selections[index1] = self.selections[index2]
    self.selections[index2] = temp
end