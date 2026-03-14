local commands = {}

local guiModule = require(script.Parent.gui)

local selectionService = game:GetService("Selection")
local reflectionService = game:GetService("ReflectionService")

--// Setup the commands for our palette
function commands:setupCommands()

    guiModule:addCommands({
        {
            title = "Create Instance",
            callback = function()
                local instanceCommands = {}

                for _, classInfo in reflectionService:GetClasses({ IsA = "Instance" }) do
                    local requiredCapability = reflectionService:GetClass(classInfo.Name).Permits.New
                    local currentCapability = SecurityCapabilities.fromCurrent()

                    if not requiredCapability then continue end
                    if not currentCapability:Contains(requiredCapability) then continue end

                    table.insert(instanceCommands, {
                        title = classInfo.Name,
                        callback = function()
                            local newInstance
                            local _, out = pcall(function()
                                newInstance = Instance.new(classInfo.Name, selectionService:Get()[1] or workspace)
                            end)

                            if not newInstance then
                                warn(out)
                            else
                                selectionService:Remove(selectionService:Get())
                                selectionService:Add({ newInstance })
                            end

                            guiModule:closePalette()
                        end
                    })
                end

                guiModule.registeredCommands = {}
                guiModule:addCommands(instanceCommands)
            end
        },
        { title = "ReplicatedStorage",  callback = function() end },
        { title = "ServerScriptService", callback = function() end },
        { title = "Gizzy is Gay",        callback = function() end },
        { title = "YouTube",             callback = function() end },
        { title = "Hack Club",           callback = function() end },
    })
end

return commands