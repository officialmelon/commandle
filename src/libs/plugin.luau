local PluginModule = {}

--[[
These are some utility functions used for easier code!
]]

--// Creates the toolbar using specified name & Plugin
function createToolbar(plugin : Plugin, name : string)
    return plugin:CreateToolbar(name)
end

--// Creates the button using specific name, toolbar, tooltip & icon
function createButton(toolbar : PluginToolbar, name : string, tooltip : string, icon : string)
	return toolbar:CreateButton(name, tooltip, icon)
end

--[[
Handles the plugin creation & start.
]]

--// This starts the plugin itself, registers functions etc
function PluginModule:startPlugin()
    
end

--// Creates the plugin in the toolbar, and runs startPlugin
function PluginModule:createPlugin(plugin : Plugin)
    -- Lets create the stuff!
	local Toolbar = createToolbar(plugin, "Commandle")
	local ToggleButton = createButton(Toolbar, "Commandle Toggle", "Disable/Enable commandle palette", "")

    -- Start the plugin
    PluginModule:startPlugin()
end

return PluginModule