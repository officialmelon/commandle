local commands = {}

local guiModule = require(script.Parent.gui)

local Selection = game:GetService("Selection")
local selectionService = game:GetService("Selection")
local reflectionService = game:GetService("ReflectionService")
local runService = game:GetService("RunService")
local stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")

local currentCamHook = nil

--// Default commands created on start/main menu
commands.defaultCommands = {
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
        -- Toggle Archivable
        {
            title = "Instance: Toggle Archivable",
            callback = function()
                for _, sel in selectionService:Get() do 
                    pcall(function() sel.Archivable = not sel.Archivable end)
                end

                guiModule:closePalette()
            end
        },
        -- Print class name of all selected
        {
            title = "Instance: Print ClassName of Selected",

            callback =  function()
                for _, sel in selectionService:Get() do
                    print(sel:GetFullName(), "->", sel.ClassName)
                end

                guiModule:closePalette(false)
            end
        },
        -- Duplicate selected instances
        {
            title = "Instance: Duplicate Selected",

            callback = function()
                local newSels = {}

                for _, sel in selectionService:Get() do
                    pcall(function()
                        local clone = sel:Clone()
                        clone.Parent = sel.Parent
                        table.insert(newSels, clone)
                    end)
                end

                selectionService:Set(newSels)
                guiModule:closePalette(false)
            end
        },
        -- Delete selected instances
        {
            title = "Instance: Delete Selected",

            callback = function()
                for _, sel in selectionService:Get() do
                    pcall(function()
                       sel:Destroy()
                    end)
                end

                selectionService:Set({})
                guiModule:closePalette()
            end
        },
        -- Move selected to workspace root
        {
            title = "Instance: Move Selected to Workspace",

            callback = function()
                for _, sel in selectionService:Get() do
                    pcall(function()
                        sel.Parent = workspace
                    end)
                end

                guiModule:closePalette(false)
            end
        },
        -- Move selected to ServerScriptService
        {
            title = "Instance: Move Selected to ServerScriptService",

            callback = function()
                for _, sel in selectionService:Get() do
                    pcall(function()
                        sel.Parent = game:GetService("ServerScriptService")   
                    end)
                end

                guiModule:closePalette(false)
            end
        },
        -- Move Selected to ReplicatedStorage
        {
            title = "Instance: Move Selected to ReplicatedStorage",

            callback = function()
                for _, sel in selectionService:Get() do
                    pcall(function()
                        sel.Parent = game:GetService("ReplicatedStorage")   
                    end)
                end

                guiModule:closePalette(false)
            end
        },
        -- Reset CFrame of selected BaseParts
        {
            title = "BasePart: Reset CFrame to Origin",

            callback = function()
                for _, sel in selectionService:Get() do
                    if sel:IsA("BasePart") then
                        sel.CFrame = CFrame.new()
                    end
                end

                guiModule:closePalette(false)
            end
        },
        -- Anchor all selected BaseParts
        {
            title = "BasePart: Anchor All Selected",
            
            callback = function()
                for _, sel in selectionService:Get() do
                    if sel:IsA("BasePart") then
                        sel.Anchored = true
                    end
                end

                guiModule:closePalette(false)
            end
        },
        -- Unanchor all selected BaseParts
        {
            title = "BasePart: Unanchor All Selected",
            
            callback = function()
                for _, sel in selectionService:Get() do
                    if sel:IsA("BasePart") then
                        sel.Anchored = false
                    end
                end

                guiModule:closePalette(false)
            end
        },
        -- Make all selected parts CanCollide true
        {
            title = "BasePart: Enable CanCollide",

            callback = function()
                for _, sel in selectionService:Get() do
                    if sel:IsA("BasePart") then
                        sel.CanCollide = true
                    end
                end

                guiModule:closePalette(false)
            end
        },
        -- Disable CanCollide for selected BaseParts
        {
            title = "BasePart: Disable CanCollide",
        
            callback = function()
                for _, sel in selectionService:Get() do
                    if sel:IsA("BasePart") then
                        sel.CanCollide = false
                    end
                end
        
                guiModule:closePalette(false)
            end
        },
        -- Toggle Transparency (0 - 1)
        {
            title = "BasePart: Toggle Visibility",

            callback = function()
                for _, sel in selectionService:Get() do
                    if sel:IsA("BasePart") then
                        sel.Transparency = sel.Transparency == 1 and 0 or 1
                    end
                end

                guiModule:closePalette(false)
            end
        },
        -- Set transparency to 0.5
        {
            title = "BasePart: Set Semi-Transparency",

            callback = function()
                for _, sel in selectionService:Get() do
                    if sel:IsA("BasePart") then
                        sel.Transparency = 0.5
                    end
                end

                guiModule:closePalette(false)
            end
        },
        -- Cast shadow toggle
        {
            title = "BasePart: Toggle CastShadow",

            callback = function()
                for _, sel in selectionService:Get() do
                    if sel:IsA("BasePart") then
                        sel.CastShadow = not sel.CastShadow
                    end
                end

                guiModule:closePalette(false)
            end
        },
        -- Print position of selected parts
        {
            title = "BasePart: Print Positions",
            callback = function()
                for _, sel in selectionService:Get() do
                    if sel:IsA("BasePart") then
                        print(sel:GetFullName(), sel.Position)
                    end
                end

                guiModule:closePalette()
            end
        },
        -- Move part to 0,0,0
        {
            title = "BasePart: Move to World Origin",
            callback = function()
                for _, sel in selectionService:Get() do
                    if sel:IsA("BasePart") then
                        sel.Position = Vector3.new(0, 0, 0)
                    end
                end

                guiModule:closePalette()
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
        -- Count children
        {
            title = "Selection: Print Children Count",
        
            callback = function()
                local toSelect = {}

                for _, selection in selectionService:Get() do
                    for _, child in selection:GetChildren() do
                        table.insert(toSelect, child)
                    end
                end
        
                print(#toSelect)
                
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
        },
        -- Teleport to selection
        {
            title = "Selection: Focus on selection",

            callback = function()
                local selection = Selection:Get()

                -- Selection exists?
                if not selection[1] then
                    return
                end

                -- Is selection a BasePart? (mesh, part, etc)
                if selection[1]:IsA("BasePart") then
                    workspace.CurrentCamera.Focus = selection[1].CFrame
                end

                -- Is selection a model?
                if selection[1]:IsA("Model") then
                    workspace.CurrentCamera.Focus = (selection[1]:GetPivot() or selection[1].PrimaryPart.CFrame)
                end

                guiModule:closePalette(false)
            end
        },
        -- Select theme
        {
            title = "Themes: Select an installed theme",

            callback = function()
                requestTheme(function(themeName : string)
                   guiModule.selectedPalette = themeName
                   guiModule:rebuildTheme()
                end)
            end
        },
        -- Reset Camera,
        {
            title = "Camera: Reset Camera",

            callback = function()
                -- Destroy the camera, Studio restores it.
                workspace.CurrentCamera:Destroy()

                -- Close palette
                guiModule:closePalette(false)
            end
        },
        -- Freeze Camera
        {
            title = "Camera: Freeze Camera",

            callback = function()
                -- Get Original CF
                local camCF = workspace.CurrentCamera.CFrame

                -- Set Cam Enum
                workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable

                -- Disable Hook
                if currentCamHook then
                    currentCamHook:Disconnect()
                end

                -- Enable hook
                currentCamHook = runService.Heartbeat:Connect(function()
                    workspace.CurrentCamera.CFrame = camCF
                end)

                -- Close palette
                guiModule:closePalette(false)
            end
        },
        -- Unfreeze Camera
        {
            title = "Camera: Unfreeze Camera",

            callback = function()
                -- Set Enum to Custom
                workspace.CurrentCamera.CameraType = Enum.CameraType.Custom

                -- If connection then disconnect
                if currentCamHook then
                    currentCamHook:Disconnect()
                end

                -- Close palette
                guiModule:closePalette(false)
            end
        },  
        -- Info
        {
            title = "Info: List Enums",

            callback = function()
                local commands = {}

                for _, enum in Enum:GetEnums() do
                    table.insert(commands, {
                        title = tostring(enum),
                        callback = function()

                            local newCommands = {}
                            for _, enumItem in enum:GetEnumItems() do

                                table.insert(newCommands, {
                                    title = tostring(enumItem),
                                    callback = function()
                                        return
                                    end
                                })
                                
                            end

                            table.insert(commands, 1, {
                                title = "Return",
                                callback = function()
                                    guiModule:popCommands()
                                end
                            })

                            guiModule:pushCommands(newCommands)
                        end
                    })
                end

                table.insert(commands, 1, {
                    title = "Return",
                    callback = function()
                        guiModule:popCommands()
                    end
                })
                    
                guiModule:pushCommands(commands)
            end
        },
        {
            title = "Info: Print Memory Stats",

            callback = function()
                print("Instance Count:", stats.InstanceCount)
                print("Data Receive KB/s:", stats.DataReceiveKbps)
                print("Data Send KB/s:", stats.DataSendKbps)
                print("Heartbeat Time (ms):", stats.HeartbeatTime)

                guiModule:closePalette(false)
            end
        },
        {
            title = "Lighting: Toggle Global Shadows",

            callback = function()
                Lighting.GlobalShadows = not Lighting.GlobalShadows

                guiModule:closePalette(false)
            end
        },
        {
            title = "Lighting: Set Time of Day",

            callback = function()
                local timePresets = {
                    {"Dawn", "06:00:00"},
                    {"Midday", "12:00:00"},
                    {"Dusk", "18:00:00"},
                    {"Midnight", "00:00:00"}
                }

                local timeCmds = {}

                for _, preset in timePresets do
                    local label, timeStr = preset[1], preset[2]
                    table.insert(timeCmds, {
                        title = label .. " (" .. timeStr .. ")",
                        
                        callback = function()
                            Lighting:SetMinutesAfterMidnight(
                                tonumber(timeStr:sub(1, 2)) * 60 + tonumber(timeStr:sub(4, 5))
                            )

                            guiModule:closePalette(false)
                        end
                    })
                end

                table.insert(timeCmds, 1, {
                    title = "Return",
                    callback = function()
                        guiModule:popCommands()
                    end
                })

                guiModule:pushCommands(timeCmds)
            end
        }
}

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

--// Used for requesting a custom theme from installed ones
function requestTheme(callback : (themeName : string) -> ())
    local themeCommands = {}

    for key, theme in guiModule.colorPalette do
        table.insert(themeCommands, {
            title = key,
            callback = function()
                callback(key)
            end
        })
    end

    table.insert(themeCommands, 1, {
        title = "Select a theme:",
        callback = function() end
    })

    table.insert(themeCommands, (#themeCommands + 1), {
        title = "Save & Return",
        callback = function()
            guiModule:popCommands()
        end
    })

    guiModule:pushCommands(themeCommands)
end

--// Setup the commands for our palette
function commands:setupCommands()
    guiModule:addCommands(commands.defaultCommands)
end

return commands