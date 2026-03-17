local configModule = {}

--// The plugin instance is set by pluginModule (plugin.luau) on load
configModule.pluginReference = nil
configModule.pluginConfiguration = {
    closeOnFocusLost = true
}

--// Initialization
function configModule:setupConfig()
    configModule.pluginConfiguration = configModule.pluginReference:GetSetting("Preferences") or configModule.pluginConfiguration
end

--// Get the configuration data from plugin table
function configModule:returnConfiguration(optionalName : string)
    assert(configModule.pluginReference, "Configuration: No pluginReference supplied!")

    -- If optionalName then return from preferences
    if optionalName then
        local succ, result = pcall(function()
            return configModule.pluginReference:GetSetting("Preferences")[optionalName]
        end)

        if succ then
            return result or {}
        end

        return {}

    else
        -- Return all preferences
        return configModule.pluginReference:GetSetting("Preferences")
    end
end

--// Set value into the configuration
function configModule:setConfiguration(stringName : string, value : any)
    assert(stringName, "Configuration: No configuration supplied!")

    -- Set in config
    configModule.pluginConfiguration[stringName] = value
end

--// Save the configuration to plugin settings
function configModule:saveConfiguration()
    assert(configModule.pluginReference, "Configuration: No pluginReference supplied!")

    -- Save to settings
    configModule.pluginReference:SetSetting("Preferences", pluginModule.pluginConfiguration)
end

return configModule