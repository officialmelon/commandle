local crossCommunicationModule = {}

local StudioService = game:GetService("StudioService")
local guiModule = require(script.Parent.gui)
local commandsModule = require(script.Parent.commands)

--[[
Quick Explanation:
This is for developing "plugins" for Commandle
]]

local api_objects = {
    createCommands = nil,
    pushRequest = nil,
    popRequest = nil,
    
    closePalette = nil,
    openPalette = nil,
    
    requestTheme = nil,
}

--[[
API Docs:

StudioService is the service we use for storing our bindable events.
We store the bindables in a folder called commandle_api under StudioService!

To access the API from another plugin, find the folder like so:
    local api = game:GetService("StudioService"):WaitForChild("commandle_api")

---

commandle_api.createCommands | BindableEvent
    Registers command into Commandle's command palette.

    Parameters:
        commandType  :  string - "main" to add the persistent default commands list,
                                 "secondary" to add as a temporary commands (uses addCommands).

    Example:
        api.createCommands:Fire("main", {
            {
                title = "My Command",

                callback = function()
                    print("Hello World!")
                end
            }
        })

---

commandle_api.pushRequest | BindableEvent
    Temporarily pushes a new list of commands onto the palette stack, replacing
    the current view. Use popRequest to return to the previous state.

    Parameters:
        commandsTable: table - Same format as createCommands (array of {title, callback}).

    Example:
        api.pushRequest:Fire({
            { title = "Sub-option A", callback = function() end },
            { title = "Sub-option B", callback = function() end },
        })

---

commandle_api.popRequest | BindableEvent
    Pops the most recently pushed command list off the stack, reverting the
    palette all the way back to the default commands and closing any sub-menus.

    Parameters: none

    Example:
        api.popRequest:Fire()

---

commandle_api.closePalette | BindableEvent
    Closes the command palette.

    Parameters:
        shouldAnimate: boolean - Pass true to animate the close transition,
                                 false to close instantly.

    Note: The argument is inverted internally before being passed to guiModule,
    so true here correctly triggers the animation.

    Example:
        api.closePalette:Fire(true)   -- animated close
        api.closePalette:Fire(false)  -- instant close

---

commandle_api.openPalette | BindableEvent
    Opens the command palette.

    Parameters: none

    Example:
        api.openPalette:Fire()

---

commandle_api.requestTheme | BindableEvent
    Registers a custom colour theme into Commandle's colour palette table,
    making it available for use by the GUI.

    Parameters:
        themeName: string — The key used to identify the theme in guiModule.colorPalette.
                            Convention: "author - ThemeName" (e.g. "melon - Midnight Violet").
        array    : table  - A flat table of named Color3 values. All keys are expected:

                            Surfaces (background layers, darkest to lightest):
                                Surface0 : Color3  - Primary background.
                                Surface1 : Color3  - Secondary background (panels, cards).
                                Surface2 : Color3  - Tertiary background (elevated elements).

                            Text:
                                Text     : Color3  - Primary text colour.
                                Subtext0 : Color3  - Dimmed/secondary text, hints, placeholders.

                            Scroll:
                                Overlay0 : Color3  - Scrollbar or overlay tint.

                            Accent:
                                Blue     : Color3  - Primary accent colour (highlights, selection).
                                                     Named "Blue" by convention but can be any hue.

    Example:
        api.requestTheme:Fire("melon - Midnight Violet", {
            Surface0 = Color3.fromRGB(52, 40, 80),
            Surface1 = Color3.fromRGB(36, 27, 58),
            Surface2 = Color3.fromRGB(22, 16, 38),

            Subtext0 = Color3.fromRGB(148, 120, 200),
            Text     = Color3.fromRGB(225, 210, 255),

            Overlay0 = Color3.fromRGB(14, 10, 26),

            Blue     = Color3.fromRGB(180, 120, 255),
        })

]]

--// This setups up communication for the bindables created by setupCommunication do
    

function setupCommunicationEvents()
    --[[
    commandTypes:
    main is the type that is for menu/defaults,
    secondary is the temporary type.
    ]]

    api_objects.createCommands.Event:Connect(function(commandType : string, commandsTable : {{title : string, callback : () -> ()}})
        if not (commandsTable and commandType) then
            error("Commandle API: No commands table provided!")
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

    -- push runs the push event! to temporarily push commands to the table.
    api_objects.pushRequest.Event:Connect(function(commandsTable : {{title : string, callback : () -> ()}})
        guiModule:pushCommands(commandsTable)
    end)

    -- pop runs the pop event, which pops temporary lists of commands all the way to defaults and exits.
    api_objects.popRequest.Event:Connect(function()
        guiModule:popCommands()
    end)

    -- explanatory, closes the palette! taking in a argument whether we should animate or not
    api_objects.closePalette.Event:Connect(function(shouldAnimate : boolean)
        -- reverse it to make it less unreadable
        guiModule:closePalette(not shouldAnimate)
    end)

    -- opens the palette!
    api_objects.openPalette.Event:Connect(function()
        guiModule:openPalette()
    end)

    api_objects.requestTheme.Event:Connect(function(themeName, array)
        assert(typeof(themeName) == "string" and typeof(array) == "table", "Commandle API: Invalid themeName or table!")
        guiModule.colorPalette[themeName] = array
    end)
end

--// This handles setting up binadable events for plugins to use
function setupCommunication()
    -- If we already exist then remove that API.
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

    -- Request a theme to be added to existing themes!
    local requestTheme = Instance.new("BindableEvent")
    requestTheme.Parent = crossParent
    requestTheme.Name = "requestTheme"

    -- Assign API functions to module table!
    api_objects.createCommands = createCommands
    api_objects.pushRequest = pushRequest
    api_objects.popRequest = popRequest
    api_objects.closePalette = closePalette
    api_objects.openPalette = openPalette
    api_objects.requestTheme = requestTheme
end

--// Runs the setup functions.
function crossCommunicationModule:setupModule()
    setupCommunication()
    setupCommunicationEvents()
end

return crossCommunicationModule