--[[
This is the plugin script that handles all initializing.
]]

--// Where we keep our modules/requirements.
local LibsFolder = script.libs
local RunService = game:GetService("RunService")

--// Define our modules
local pluginModule = require(LibsFolder.plugin)

--// Runtime check
if not RunService:IsStudio() then
    return
end

--// Create the plugin & Start our input module
pluginModule:createPlugin(plugin)