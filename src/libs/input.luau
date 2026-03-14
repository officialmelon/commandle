local InputModule = {}

local RunService = game:GetService("RunService")
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

--// Hold connection for arrow keys
local holdConnection = nil

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

--// Cancel active hold loop
function cancelHold()
    if holdConnection then
        holdConnection:Disconnect()
        holdConnection = nil
    end
end

--// Start holding
function startHold(delta : number)
    -- Cancel hold
    cancelHold()

    -- Default definitions
    local elapsedTime = 0
    local repeating = false

    -- Set the holdConnection on heartbeat
    holdConnection = RunService.Heartbeat:Connect(function(dt)
        elapsedTime += dt

        -- Are we repeating? if not then start.
        if not repeating then
            if elapsedTime >= 0.4 then
                repeating = true
                elapsedTime = 0
            end
        else 
            -- Start repeating!
            if elapsedTime >= 0.07 then
                elapsedTime = 0
                guiModule:moveSelection(delta)
            end
        end
    end)
end

--// This starts the Input module.
function InputModule:startModule()
    -- Input began?
    UserInputService.InputBegan:Connect(function(input)

        -- Escape pressed? If so then close.
        if isKeyDown("Escape") then
            gui:popCommands()
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

        -- Arrow key input!
        if input.KeyCode == Enum.KeyCode.Up then
            -- Move upwards
            guiModule:moveSelection(-1)
            startHold(-1)
        elseif input.KeyCode == Enum.KeyCode.Down then
            -- Move downwards
            guiModule:moveSelection(1)
            startHold(1)
        elseif input.KeyCode == Enum.KeyCode.Return then
            -- Enter/activate callback()
            guiModule:activateSelected()
        end

        -- Are the binds down?
        if keybindsDown(SetBinds) then 
            -- Open palette & register commands
            gui:openPalette()
            commandsModule:setupCommands()
        end
    end)

    -- Handles cancelling the hold function
    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Up or input.KeyCode == Enum.KeyCode.Down then 
            cancelHold() 
        end
    end)
end

return InputModule