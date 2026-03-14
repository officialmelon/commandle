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
    UserInputService.InputBegan:Connect(function(input)

        -- Escape pressed? If so then close.
        if isKeyDown("Escape") then
            gui:closePalette()
        end

        -- Did we click off the frame? If so then close
        if input.UserInputType == Enum.UserInputType.MouseButton1 then

            -- Get the palette frame & check if not nil
            local palette = gui.guiElements.Gui.Palette
            if not palette then 
                return
            end

            -- Get pos, size and mouse pos

            local pos = palette.AbsolutePosition
            local size = palette.AbsoluteSize
            local mouse = input.Position

            -- Are we inside the frame?
            local insideX = mouse.X >= pos.X and mouse.X <= pos.X + size.X
            local insideY = mouse.Y >= pos.Y and mouse.Y <= pos.Y + size.Y

            -- If we aren't then close.
            if not (insideX and insideY) then
                guiModule:closePalette()
            end
        end

        -- Are they down noo-ww?
        if not keybindsDown(SetBinds) then return end

        -- Open palette & register commands
        gui:openPalette()
        commandsModule:setupCommands()
    end)
end

return InputModule