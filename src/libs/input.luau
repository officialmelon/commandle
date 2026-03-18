local InputModule = {}

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local commandsModule = require(script.Parent.commands)
local guiModule = require(script.Parent.gui)
local configModule = require(script.Parent.config)

--// Binds that need to be pressed to open up!
local SetBinds = {
    "LeftShift",
    "F"
}

--// Enter guard
local returnHeld = false
local lastReturnTime = 0

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
function InputModule:startModule(plugin : Plugin)

    local openAction = plugin:CreatePluginAction(
        "openCommandPalette",
        "Open Command Palette",
        "Opens the command palette",
        "", -- TODO: Icon
        true
    )

    local closeAction = plugin:CreatePluginAction(
        "closeCommandPalette",
        "Close Command Palette",
        "Closes the command palette",
        "", -- TODO: Icon
        true
    )

    -- Binds down shortcut!
    openAction.Triggered:Connect(function()
       -- Open palette, setup commands
       guiModule:openPalette()
       commandsModule:setupCommands()
    end)

    -- Close action shortcut
    closeAction.Triggered:Connect(function()
        -- Pop that palette!
        guiModule:popCommands()
    end)

    -- Input began?
    UserInputService.InputBegan:Connect(function(input)

        -- Escape pressed? If so then close. (fallback)
        if isKeyDown("Escape") then
            guiModule:popCommands()
        end
        
        -- If user clicks off, should we close?
        if configModule.pluginConfiguration.closeOnFocusLost then
            -- Did we click off the frame? If so then close
            if input.UserInputType == Enum.UserInputType.MouseButton1 then

                -- Get the palette frame & check if not nil
                local palette = guiModule.guiElements.Gui.Palette
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
            if guiModule.inputMode then
                return
            end

            if returnHeld then
                return
            end

            -- Return held checks
            returnHeld = true
            local now = os.clock()
            if now - lastReturnTime < 0.18 then
                return
            end
            lastReturnTime = now

            -- Enter/activate callback()
            guiModule:activateSelected()
        end

        -- Are the binds down? (fallback)
        if keybindsDown(SetBinds) then 
            -- Open palette & register commands
            guiModule:openPalette()
            commandsModule:setupCommands()
        end
    end)

    -- Handles cancelling the hold function
    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Up or input.KeyCode == Enum.KeyCode.Down then 
            cancelHold() 
        elseif input.KeyCode == Enum.KeyCode.Return then
            returnHeld = false
        end
    end)
end

return InputModule