--[[
    Confirm state: player is asked to confirm an action
    @author Saverton
]]

ConfirmState = Class{__includes = MenuState}

function ConfirmState:init(def, inst)
    MenuState.init(self, def, inst)

    self.onConfirm = inst.onConfirm or function() end
    self.onDeny = inst.onDeny or function() end
    self.menu.parent = self
end