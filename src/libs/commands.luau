local commands = {}

local guiModule = require(script.Parent.gui)
local utilityModule = require(script.Parent.utilities)

local selectionService = game:GetService("Selection")
local reflectionService = game:GetService("ReflectionService")
local gui = require(script.Parent.gui)

--// Insert a command into the gui
function insertCommand(title, callback)
    
    guiModule.createCommandPreview(
        guiModule.guiElements.Gui.CommandsScrolling, 
        title, 
        callback, 
        false
    )

end

--// Setup the commands for our palette
function commands:setupCommands()

    -- Reset commands
    guiModule.removeAllCommands()

    -- Create a Instance into Workspace
    insertCommand("Create Instance", function()  

        -- Remove all commands
        guiModule.removeAllCommands()

        -- Create all classes as buttons.
        for _, classInfo in reflectionService:GetClasses({
            IsA = "Instance"
        }) do

            local requiredCapability = reflectionService:GetClass(classInfo.Name).Permits.New
            local currentCapability = SecurityCapabilities.fromCurrent()

            -- Does it have capabilities? If not then dont add
            if not requiredCapability then 
                continue
            end

            -- Does it contain our currentCapability? If not then dont add
            if not currentCapability:Contains(requiredCapability) then
                continue
            end

            -- Insert the instance as a command!
            insertCommand(classInfo.Name, function()  
                -- Attempt to create Instance
                local newInstance
                local err, out = pcall(function()  
                    newInstance = Instance.new(classInfo.Name, selectionService:Get()[1] or workspace)
                end)

                -- Instance.new errored!
                if not newInstance then 
                    warn(out)
                else
                    -- Select instance!
                    selectionService:Remove(selectionService:Get())
                    selectionService:Add({
                        newInstance
                    })
                end

                -- Reset
                commands:setupCommands()
            end)
        end

    end)
end

return commands