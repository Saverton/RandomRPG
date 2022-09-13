--[[
    Confirm state: inherits from menu, player is asked to confirm an action.
    @author Saverton
]]

ConfirmState = Class{__includes = MenuState}

function ConfirmState:init(definitions, instance)
    MenuState.init(self, definitions, instance)
    self.onConfirm = instance.onConfirm or function() end -- executes on selecting 'yes'
    self.onDeny = instance.onDeny or function() end -- executes on selecting 'no'
    self.menu.parent = self -- parent of the menu
end