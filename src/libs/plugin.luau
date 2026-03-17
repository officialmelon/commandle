local PluginModule = {}

--// require our input module
local inputModule = require(script.Parent.input)
local commandsModule = require(script.Parent.commands)
local crossCommsModule = require(script.Parent.cross_communication)
local configModule = require(script.Parent.config)

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
function PluginModule:startPlugin(plugin : Plugin)

    -- Set plugin reference for configModule
    configModule.pluginReference = plugin

    -- Start the config module
    configModule:setupConfig()

	-- Start the input module
    inputModule:startModule(plugin)

    -- Insert all commands from module
    commandsModule:setupCommands()    

    -- Cross communications setup
    crossCommsModule:setupModule()
end

--// Creates the plugin in the toolbar, and runs startPlugin
function PluginModule:createPlugin(plugin : Plugin)
    -- Lets create the stuff!
	local Toolbar = createToolbar(plugin, "Commandle")
	local ToggleButton = createButton(Toolbar, "Commandle Toggle", "Disable/Enable commandle palette", "")

    -- Start the plugin
    PluginModule:startPlugin(plugin)
	
end

return PluginModule