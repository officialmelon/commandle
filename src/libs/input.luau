local InputModule = {}

local UserInputService = game:GetService("UserInputService")

local commandsModule = require(script.Parent.commands)
local gui = require(script.Parent.gui)
local guiModule = require(script.Parent.gui)

--// Binds that need to be pressed to open up!
local SetBinds = {
    "LeftControl",
    "LeftShift",
    "C"
}

--// Checks if the passed key is down
function isKeyDown(key : string)
    return UserInputService:IsKeyDown(Enum.KeyCode[key])
end

--// Check if all the passed binds are pressed down
function keybindsDown(binds)
    for _, bind in ipairs(binds) do
        if not isKeyDown(bind) then
            return false
        end
    end

    return true
end

--// This starts the Input module.
function InputModule:startModule()
    -- Input began?
    UserInputService.InputBegan:Connect(function()
        -- Are they down noo-ww?
        if not keybindsDown(SetBinds) then return end

        -- Open palette & register commands
        gui:openPalette(workspace)
        commandsModule:setupCommands()
    end)
end

return InputModule