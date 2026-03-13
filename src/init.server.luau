--[[
This is the plugin script that handles all initializing.
]]

--// Where we keep our modules/requirements.
local LibsFolder = script.libs

--// Define our modules
local inputModule = require(LibsFolder.input)
local pluginModule = require(LibsFolder.plugin)
local guiModule = require(LibsFolder.gui)

--// Create the plugin & Start our input module
pluginModule:createPlugin(plugin)
inputModule:startModule()
guiModule:openPallete()