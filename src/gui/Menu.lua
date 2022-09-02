--[[
    Menu Class: a menu in a gui panel
    @author Saverton
]]

Menu = Class{}

function Menu:init(def)
    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height
    self.title = def.title or 'Menu'

    self.panel = Panel(self.x, self.y, self.width, self.height)

    self.selections = def.selections
    self.currentSelection = 1
end

function Menu:update(dt)
    if love.keyboard.wasPressed('w') or love.keyboard.wasPressed('up') then
        love.audio.play(gSounds['menu_blip_1'])
        self.currentSelection = ((self.currentSelection - 1) % #self.selections)
    elseif love.keyboard.wasPressed('s') or love.keyboard.wasPressed('down') then
        love.audio.play(gSounds['menu_blip_1'])
        self.currentSelection = ((self.currentSelection) % #self.selections) + 1
    elseif love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self.selections[self.currentSelection]:select()
    end
end

function Menu:render()
    self.panel:render()

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf(self.title, love.math.newTransform(self.x + SELECTION_MARGIN, self.y + SELECTION_MARGIN), (self.width - (2 *SELECTION_MARGIN)), 'center')

    love.graphics.setFont(gFonts['small'])
    for i, selection in ipairs(self.selections) do
        local x, y = self.x + SELECTION_MARGIN, self.y + (SELECTION_MARGIN * i) + (SELECTION_HEIGHT * i) + 20
        love.graphics.printf(selection.name, love.math.newTransform(x, y),
            self.width - (2 * SELECTION_MARGIN), 'left')
        if i == self.currentSelection then
            love.graphics.rectangle('line', x - 1, y - 1, self.width - (SELECTION_MARGIN * 2) + 2, SELECTION_HEIGHT)
        end
    end
end