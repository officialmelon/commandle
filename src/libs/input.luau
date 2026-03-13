local InputModule = {}

local UserInputService = game:GetService("UserInputService")

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
    -- Are binds down?
    UserInputService.InputBegan:Connect(function()
        print(keybindsDown(SetBinds))
    end)
end

return InputModule