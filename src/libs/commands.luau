local commands = {}

local guiModule = require(script.Parent.gui)

local selectionService = game:GetService("Selection")
local reflectionService = game:GetService("ReflectionService")

--// Used for requesting className of instance, then running callback with the chosen name
function requestClassName(callback : (className : string) -> ())
    local instanceCommands = {}

    for _, classInfo in reflectionService:GetClasses({ IsA = "Instance" }) do
        local requiredCapability = reflectionService:GetClass(classInfo.Name).Permits.New
        local currentCapability = SecurityCapabilities.fromCurrent()

        if not requiredCapability then continue end
        if not currentCapability:Contains(requiredCapability) then continue end

        local capturedName = classInfo.Name
        table.insert(instanceCommands, {
            title = capturedName,
            callback = function()
                callback(capturedName)
            end
        })
    end

    table.insert(instanceCommands, 1, {
        title = "Specify an instance type:",
        callback = function() end
    })

    guiModule:pushCommands(instanceCommands)
end

--// Setup the commands for our palette
function commands:setupCommands()

    guiModule:addCommands({
        -- Create instance command
        {
            title = "Instance: Create Instance",

            callback = function()
                requestClassName(function(className)
                    local newInstance
                    local _, out = pcall(function()
                        newInstance = Instance.new(className, selectionService:Get()[1] or workspace)
                    end)

                    if not newInstance then
                        warn(out)
                    else
                        selectionService:Remove(selectionService:Get())
                        selectionService:Add({ newInstance })
                    end

                    guiModule:closePalette()
                end)
            end
        },
        -- Select all children of selections
        {
            title = "Selection: Select All Children",

            callback = function()
                local toSelect = {}

                for _, selection in selectionService:Get() do
                    for _, child in selection:GetChildren() do
                        table.insert(toSelect, child)
                    end
                end

                selectionService:Set(toSelect)
                guiModule:closePalette()
            end
        },
        -- Select all descendants of the selections
        {
            title = "Selection: Select All Descendants",

            callback = function()
                local toSelect = {}

                for _, selection in selectionService:Get() do
                    for _, descendant in selection:GetDescendants() do
                        table.insert(toSelect, descendant)
                    end
                end

                selectionService:Set(toSelect)
                guiModule:closePalette()
            end
        },
        -- Select the siblings of the selected instance
        {
            title = "Selection: Select Siblings",

            callback = function()
                local toSelect = {}

                for _, selection in selectionService:Get() do
                    for _, child in selection.Parent:GetChildren() do
                        if child == selection then continue end
                        table.insert(toSelect, child)
                    end
                end

                selectionService:Set(toSelect)
                guiModule:closePalette()
            end
        },
        -- Select the parent of selected instance
        {
            title = "Selection: Select Parent",

            callback = function()
                local toSelect = {}

                for _, selection in selectionService:Get() do
                    table.insert(toSelect, selection.Parent)
                end

                selectionService:Set(toSelect)
                guiModule:closePalette()
            end
        },
        -- Select descendants by class
        {
            title = "Selection: Select Descendants by Class",

            callback = function()
                requestClassName(function(className)
                    local toSelect = {}

                    for _, selection in selectionService:Get() do
                        for _, descendant in selection:GetDescendants() do
                            if descendant.ClassName == className then
                                table.insert(toSelect, descendant)
                            end
                        end
                    end

                    selectionService:Set(toSelect)
                    guiModule:closePalette()
                end)
            end
        }
    })
end

return commands