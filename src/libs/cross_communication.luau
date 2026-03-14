local crossCommunicationModule = {}

local StudioService = game:GetService("StudioService")
local guiModule = require(script.Parent.gui)
local commandsModule = require(script.Parent.commands)
local gui = require(script.Parent.gui)

--[[
Quick Explanation:
This is for developing "plugins" for Commandle
]]

local api_objects = {
    createCommands = nil,
    pushRequest = nil,
    popRequest = nil,
    
    closePalette = nil,
    openPalette = nil
}

function setupCommunicationEvents()
    --[[
    commandTypes:
    main is the type that is for menu/defaults,
    secondary is the temporary type.
    ]]

    api_objects.createCommands.Event:Connect(function(commandType : string, commandsTable : {{title : string, callback : () -> ()}})
        if not (commandsTable and commandType) then
            error("Commandle API: No commands table provided!")
            return
        end

        -- Fill in our commands table
        if commandType == "main" then
            for _, cmd in commandsTable do
                if type(cmd.title) == "string" and type(cmd.callback) == "function" then
                    table.insert(commandsModule.defaultCommands, cmd)
                end
            end
        elseif commandType == "secondary" then
            guiModule:addCommands(commandsTable)
        end

        -- Rebuild
        guiModule:rebuildUI()
    end)

    api_objects.pushRequest.Event:Connect(function(commandsTable : {{title : string, callback : () -> ()}})
        guiModule:pushCommands(commandsTable)
    end)

    api_objects.popRequest.Event:Connect(function()
        guiModule:popCommands()
    end)

    api_objects.closePalette.Event:Connect(function(shouldAnimate : boolean)
        guiModule:closePalette(not shouldAnimate)
    end)

    api_objects.openPalette.Event:Connect(function()
        guiModule:openPalette()
    end)
end

function setupCommunication()
    if StudioService:FindFirstChild("commandle_api") then
        StudioService:FindFirstChild("commandle_api"):Destroy()
    end

    -- Parent folder for all Bindables
    local crossParent = Instance.new("Folder")
    crossParent.Parent = StudioService
    crossParent.Name = "commandle_api"

    -- This creates the command!
    local createCommands = Instance.new("BindableEvent")
    createCommands.Parent = crossParent
    createCommands.Name = "createCommands"
    
    -- Requests a push
    local pushRequest = Instance.new("BindableEvent")
    pushRequest.Parent = crossParent
    pushRequest.Name = "pushRequest"

    -- Requests a pop
    local popRequest = Instance.new("BindableEvent")
    popRequest.Parent = crossParent
    popRequest.Name = "popRequest"

    -- Close palette
    local closePalette = Instance.new("BindableEvent")
    closePalette.Parent = crossParent
    closePalette.Name = "closePalette"

    -- Open palette
    local openPalette = Instance.new("BindableEvent")
    openPalette.Parent = crossParent
    openPalette.Name = "openPalette"

    -- Assign API functions to module table!
    api_objects.createCommands = createCommands

    api_objects.pushRequest = pushRequest

    api_objects.popRequest = popRequest

    api_objects.closePalette = closePalette

    api_objects.openPalette = openPalette

end

function crossCommunicationModule:setupModule()
    setupCommunication()
    setupCommunicationEvents()
end

return crossCommunicationModule