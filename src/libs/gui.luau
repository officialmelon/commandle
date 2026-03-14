local guiModule = {}

local searchModule = require(script.Parent.search)
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local freezeFrame = nil

--// The color palette we use! (Catppuccin Mocha is default)
guiModule.selectedPalette = "Mocha"

guiModule.colorPalette = {
	Latte = {
		-- Bases
		Crust = Color3.fromRGB(220, 224, 232),
		Mantle = Color3.fromRGB(230, 233, 239),
		Base = Color3.fromRGB(239, 241, 245),

		-- Surfaces
		Surface0 = Color3.fromRGB(204, 208, 218),
		Surface1 = Color3.fromRGB(188, 192, 204),
		Surface2 = Color3.fromRGB(172, 176, 190),

		-- Overlays
		Overlay0 = Color3.fromRGB(156, 160, 176),
		Overlay1 = Color3.fromRGB(140, 143, 161),
		Overlay2 = Color3.fromRGB(124, 127, 147),

		-- Text
		Subtext0 = Color3.fromRGB(108, 111, 133),
		Subtext1 = Color3.fromRGB(92, 95, 119),
		Text = Color3.fromRGB(76, 79, 105),

		-- Accents
		Lavender = Color3.fromRGB(114, 135, 253),
		Blue = Color3.fromRGB(30, 102, 245),
		Sapphire = Color3.fromRGB(32, 159, 181),
		Sky = Color3.fromRGB(4, 165, 229),
		Teal = Color3.fromRGB(23, 146, 153),
		Green = Color3.fromRGB(64, 160, 43),
		Yellow = Color3.fromRGB(223, 142, 29),
		Peach = Color3.fromRGB(254, 100, 11),
		Maroon = Color3.fromRGB(230, 69, 83),
		Red = Color3.fromRGB(210, 15, 57),
		Mauve = Color3.fromRGB(136, 57, 239),
		Pink = Color3.fromRGB(234, 118, 203),
		Flamingo = Color3.fromRGB(221, 120, 120),
		Rosewater = Color3.fromRGB(220, 138, 120),
	},

	Frappe = {
		-- Bases
		Crust = Color3.fromRGB(35, 38, 52),
		Mantle = Color3.fromRGB(41, 44, 60),
		Base = Color3.fromRGB(48, 52, 70),

		-- Surfaces
		Surface0 = Color3.fromRGB(65, 69, 89),
		Surface1 = Color3.fromRGB(81, 87, 109),
		Surface2 = Color3.fromRGB(98, 104, 128),

		-- Overlays
		Overlay0 = Color3.fromRGB(115, 121, 148),
		Overlay1 = Color3.fromRGB(131, 139, 167),
		Overlay2 = Color3.fromRGB(148, 156, 187),

		-- Text
		Subtext0 = Color3.fromRGB(165, 173, 206),
		Subtext1 = Color3.fromRGB(181, 191, 226),
		Text = Color3.fromRGB(198, 208, 245),

		-- Accents
		Lavender = Color3.fromRGB(186, 187, 241),
		Blue = Color3.fromRGB(140, 170, 238),
		Sapphire = Color3.fromRGB(133, 193, 220),
		Sky = Color3.fromRGB(153, 209, 219),
		Teal = Color3.fromRGB(129, 200, 190),
		Green = Color3.fromRGB(166, 209, 137),
		Yellow = Color3.fromRGB(229, 200, 144),
		Peach = Color3.fromRGB(239, 159, 118),
		Maroon = Color3.fromRGB(234, 153, 156),
		Red = Color3.fromRGB(231, 130, 132),
		Mauve = Color3.fromRGB(202, 158, 230),
		Pink = Color3.fromRGB(244, 184, 228),
		Flamingo = Color3.fromRGB(238, 190, 190),
		Rosewater = Color3.fromRGB(242, 213, 207),
	},

	Macchiato = {
		-- Bases
		Crust = Color3.fromRGB(24, 25, 38),
		Mantle = Color3.fromRGB(30, 32, 48),
		Base = Color3.fromRGB(36, 39, 58),

		-- Surfaces
		Surface0 = Color3.fromRGB(54, 58, 79),
		Surface1 = Color3.fromRGB(73, 77, 100),
		Surface2 = Color3.fromRGB(91, 96, 120),

		-- Overlays
		Overlay0 = Color3.fromRGB(110, 115, 141),
		Overlay1 = Color3.fromRGB(128, 135, 162),
		Overlay2 = Color3.fromRGB(147, 154, 183),

		-- Text
		Subtext0 = Color3.fromRGB(165, 173, 203),
		Subtext1 = Color3.fromRGB(184, 192, 224),
		Text = Color3.fromRGB(202, 211, 245),

		-- Accents
		Lavender = Color3.fromRGB(183, 189, 248),
		Blue = Color3.fromRGB(138, 173, 244),
		Sapphire = Color3.fromRGB(125, 196, 228),
		Sky = Color3.fromRGB(145, 215, 227),
		Teal = Color3.fromRGB(139, 213, 202),
		Green = Color3.fromRGB(166, 218, 149),
		Yellow = Color3.fromRGB(238, 212, 159),
		Peach = Color3.fromRGB(245, 169, 127),
		Maroon = Color3.fromRGB(238, 153, 160),
		Red = Color3.fromRGB(237, 135, 150),
		Mauve = Color3.fromRGB(198, 160, 246),
		Pink = Color3.fromRGB(245, 189, 230),
		Flamingo = Color3.fromRGB(240, 198, 198),
		Rosewater = Color3.fromRGB(244, 219, 214),
	},

	Mocha = {
		-- Bases
		Crust = Color3.fromRGB(17, 17, 27),
		Mantle = Color3.fromRGB(24, 24, 37),
		Base = Color3.fromRGB(30, 30, 46),

		-- Surfaces
		Surface0 = Color3.fromRGB(49, 50, 68),
		Surface1 = Color3.fromRGB(69, 71, 90),
		Surface2 = Color3.fromRGB(88, 91, 112),

		-- Overlays
		Overlay0 = Color3.fromRGB(108, 112, 134),
		Overlay1 = Color3.fromRGB(127, 132, 156),
		Overlay2 = Color3.fromRGB(147, 153, 178),

		-- Text
		Subtext0 = Color3.fromRGB(166, 173, 200),
		Subtext1 = Color3.fromRGB(186, 194, 222),
		Text = Color3.fromRGB(205, 214, 244),

		-- Accents
		Lavender = Color3.fromRGB(180, 190, 254),
		Blue = Color3.fromRGB(137, 180, 250),
		Sapphire = Color3.fromRGB(116, 199, 236),
		Sky = Color3.fromRGB(137, 220, 235),
		Teal = Color3.fromRGB(148, 226, 213),
		Green = Color3.fromRGB(166, 227, 161),
		Yellow = Color3.fromRGB(249, 226, 175),
		Peach = Color3.fromRGB(250, 179, 135),
		Maroon = Color3.fromRGB(235, 160, 172),
		Red = Color3.fromRGB(243, 139, 168),
		Mauve = Color3.fromRGB(203, 166, 247),
		Pink = Color3.fromRGB(245, 194, 231),
		Flamingo = Color3.fromRGB(242, 205, 205),
		Rosewater = Color3.fromRGB(245, 224, 220),
	},
}

--// The current selected command (via up/down arrow)
guiModule.selectedCommand = nil

--// Holds all registered commands (source of truth for search)
guiModule.registeredCommands = {}

--// Holds all the navigationStack commands (esc)
guiModule.navigationStack = {}

--// Type check

type GuiElements = {
	Palette: Frame?,
	Input: Frame?,
	CommandsScrolling: ScrollingFrame?,
	Commands: {
		{
			title : string?,
			callback: () -> ()?,
			commandFrame: TextButton
		}
	}
}

--// This holds all the GUI elements for both plugin & gui!
guiModule.guiElements = {
	-- This holds the plugin elements
	Plugin = {
		["Toolbar"] = nil,
		["ToggleButton"] = nil,
	},
	-- Holds the actual palette elements
	Gui = {
		-- Plugin, Input are frames & CommandsScrolling are ScrollingFrame
		["Palette"] = nil,
		["Input"] = nil,
		["CommandsScrolling"] = nil,

		-- Holds all commands in the gui
		Commands = {},
	} :: GuiElements,
}

--[[
GUI Creation related stuff
]]

--// create instance based on className and propertyTable
function createInstance(className: string, propertyTable: { [string]: any })
	local createdInstance = Instance.new(className)

	for property, value in propertyTable do
		if property ~= "Parent" then
			createdInstance[property] = value
		end
	end

	createdInstance.Parent = propertyTable.Parent
	return createdInstance
end

--// Create the palette
function createPalette(parent: Instance)
	-- Create the palette frame
	local palette = createInstance("Frame", {
		Name = "Palette",
		Parent = parent,

		BackgroundColor3 = guiModule.colorPalette[guiModule.selectedPalette].Surface0,

		Size = UDim2.new(0, 660, 0, 490),
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 40),

		Active = true,
		ClipsDescendants = true,
	})

	-- Create the UICorner
	createInstance("UICorner", {
		Name = "UICorner",
		Parent = palette,

		CornerRadius = UDim.new(0, 6),
	})

	-- Create the UIStroke
	createInstance("UIStroke", {
		Name = "UIStroke",
		Parent = palette,

		ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
		BorderStrokePosition = Enum.BorderStrokePosition.Outer,
		LineJoinMode = Enum.LineJoinMode.Round,

		Color = guiModule.colorPalette[guiModule.selectedPalette].Surface2,
		Thickness = 1,
	})

	--// Register palette in table
	guiModule.guiElements.Gui.Palette = palette

	return palette
end

--// Create the Input area
function createInputArea(parent: Instance)
	-- Create the Input area frame
	local input = createInstance("Frame", {
		Name = "Input",
		Parent = parent,

		BackgroundColor3 = guiModule.colorPalette[guiModule.selectedPalette].Surface0,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 0, 38),
		Active = true,
	})

	-- Create the UICorner
	createInstance("UICorner", {
		Name = "UICorner",
		Parent = input,

		CornerRadius = UDim.new(0, 6),
	})

	-- Create the search box input
	createInstance("TextBox", {
		Parent = input,
		BackgroundTransparency = 1,

		Position = UDim2.new(0, 10, 0, 0),
		Size = UDim2.new(0.942, 16, 1, 0),

		ZIndex = 4,
		FontFace = Font.fromEnum(Enum.Font.Code),
		TextSize = 15,
		PlaceholderText = "Search...",
		Text = "",
		PlaceholderColor3 = guiModule.colorPalette[guiModule.selectedPalette].Subtext0,
		TextColor3 = guiModule.colorPalette[guiModule.selectedPalette].Subtext0,
		TextXAlignment = Enum.TextXAlignment.Left,

		ClearTextOnFocus = false,
	})

	-- Register the input frame in the table
	guiModule.guiElements.Gui.Input = input

	return input
end

--// Creates the spacer between the Input & Commands.
function createSpacer(parent: Instance)
	-- Create the spacer frame
	return createInstance("Frame", {
		Name = "Spacer",
		Parent = parent,

		ZIndex = 3,
		Position = UDim2.new(0, 0, 0, 38),
		Size = UDim2.new(1, 0, 0, 1),

		BackgroundColor3 = guiModule.colorPalette[guiModule.selectedPalette].Surface2,
	})
end

--// Creates the scrolling frame that holds the commands
function createCommandsScrollingFrame(parent: Instance)
	-- Creates the scrolling frame
	local scrollingFrame = createInstance("ScrollingFrame", {
		Name = "Commands",
		Parent = parent,

		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 39),
		Size = UDim2.new(1, 0, 1, -39),

		ScrollBarThickness = 4,
		ScrollBarImageColor3 = guiModule.colorPalette[guiModule.selectedPalette].Overlay0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,

		ZIndex = 3,
	})

	createInstance("UIListLayout", {
		Name = "UIListLayout",
		Parent = scrollingFrame,
	})

	-- Register our scrollingFrame in the table.
	guiModule.guiElements.Gui.CommandsScrolling = scrollingFrame

	return scrollingFrame
end

--// Create a command preview
function createCommandPreview(parent: Instance, title: string, callback: () -> (), isSelected: boolean)
	-- Create the command button
	local Command = createInstance("TextButton", {
		Name = "Command",
		Parent = parent,

		Text = "",
		BackgroundColor3 = isSelected and guiModule.colorPalette[guiModule.selectedPalette].Surface1 or guiModule.colorPalette[guiModule.selectedPalette].Surface0,
		Size = UDim2.new(1, 0, 0, 26),
		BorderSizePixel = 0,
	})

	-- Create the selected frame
	createInstance("Frame", {
		Name = "Selected",
		Parent = Command,

		BackgroundColor3 = guiModule.colorPalette[guiModule.selectedPalette].Blue,

		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0, 2, 1, 0),
		Visible = isSelected or false,
		BorderSizePixel = 0,
	})

	-- Create the title textlabel
	createInstance("TextLabel", {
		Name = "Title",
		Parent = Command,

		BackgroundTransparency = 1,
		ZIndex = 5,

		Position = UDim2.new(0, 10, 0, 0),
		Size = UDim2.new(0.485, -14, 1, 0),

		FontFace = Font.fromEnum(Enum.Font.Code),
		TextSize = 13,
		TextColor3 = guiModule.colorPalette[guiModule.selectedPalette].Text,
		Text = title,

		TextXAlignment = Enum.TextXAlignment.Left,
	})

	-- Setup the callback
	Command.Activated:Connect(callback)

	-- Register our new command ui in the table
	table.insert(guiModule.guiElements.Gui.Commands, {
		title = title,
		callback = callback,
		commandFrame = Command,
	})

	return Command
end

--// Remove all commands added
function removeAllCommands()
	-- Reset commands table
	guiModule.guiElements.Gui.Commands = {}

	-- Does the commands UI exist?
	if not guiModule.guiElements.Gui.CommandsScrolling then
		return
	end

	-- Destroy all commands in the UI
	for _, command in guiModule.guiElements.Gui.CommandsScrolling:GetChildren() do
		-- Is it a button?
		if not command:IsA("TextButton") then
			continue
		end

		-- Bye bye button!
		command:Destroy()
	end
end

--// Return the GUI if its open!
function getOpenGui()
	return game:GetService("CoreGui"):FindFirstChild("cmdle")
end

--// Scroll to the selected button
function scrollToSelected()
	-- Find our scrollingFrame
	local scrolling: ScrollingFrame = guiModule.guiElements.Gui.CommandsScrolling
	if not scrolling then
		return
	end

	-- Get index & return if non-existing
	local idx = guiModule.selectedCommand

	if not idx then
		return
	end

	-- Define our heights
	local itemHeight = 26
	local frameHeight = scrolling.AbsoluteSize.Y

	-- Set itemTop/Bottom
	local itemTop = (idx - 1) * itemHeight
	local itemBottom = itemTop + itemHeight

	-- Get our currentScroll
	local currentScroll = scrolling.CanvasPosition.Y

	-- Start scrolling up/down
	if itemBottom > currentScroll + frameHeight then
		scrolling.CanvasPosition = Vector2.new(0, itemBottom - frameHeight)
	elseif itemTop < currentScroll then
		scrolling.CanvasPosition = Vector2.new(0, itemTop)
	end
end

--// Rebuilds the UI (refreshes commands)
function guiModule:rebuildUI()
	-- Get the textbox from gui.luau!
	local textBox = guiModule.guiElements.Gui.Input and guiModule.guiElements.Gui.Input:FindFirstChild("TextBox")

	-- Search against the master registry
	local filtered
	if textBox and textBox.Text ~= "" then
		filtered = searchModule:search(textBox.Text, guiModule.registeredCommands)
	else
		filtered = guiModule.registeredCommands
	end

	-- Clamp selectedCommand
	local count = #filtered
	if count == 0 then
		guiModule.selectedCommand = nil
	else
		guiModule.selectedCommand = math.clamp(guiModule.selectedCommand or 1, 1, count)
	end

	-- remove all existing commands
	removeAllCommands()

	-- add all commands back w/ selection.
	for i, cmd in filtered do
		local isSelected = (i == guiModule.selectedCommand)
		createCommandPreview(guiModule.guiElements.Gui.CommandsScrolling, cmd.title, cmd.callback, isSelected)
	end

	scrollToSelected()
end

--// Move selection up (-1) or down (+1)
function guiModule:moveSelection(delta: number)
	local count = #guiModule.guiElements.Gui.Commands

	-- Is 0? Return.
	if count == 0 then
		return
	end

	-- Set selection
	local currentCommand = guiModule.selectedCommand or 1
	guiModule.selectedCommand = math.clamp(currentCommand + delta, 1, count)

	-- Refresh UI
	guiModule:rebuildUI()
end

--// Activate our selected command
function guiModule:activateSelected()
	local idx = guiModule.selectedCommand

	-- No index? return
	if not idx then
		return
	end

	-- Fire our entry!
	local entry = guiModule.guiElements.Gui.Commands[idx]
	if entry then
		entry.callback()
	end
end

--// Setup the search feature on the palette
function setupSearch()
	-- Input setup!
	local inputBox: TextBox = guiModule.guiElements.Gui.Input:WaitForChild("TextBox")
	inputBox:GetPropertyChangedSignal("Text"):Connect(function()
		guiModule:rebuildUI()
	end)
end

--// Add singular command
function guiModule:addCommand(title: string, callback: () -> ())
	table.insert(guiModule.registeredCommands, {
		title = title,
		callback = callback,
	})
end

--// Batch add commands (for performance)
function guiModule:addCommands(commands: { { title: string, callback: () -> () } })
	-- Reset
	guiModule.registeredCommands = {}

	-- Insert commands into registered
	for _, cmd in commands do
		table.insert(guiModule.registeredCommands, cmd)
	end

	-- Rebuild at end
	guiModule:rebuildUI()
end

--// Pushes commands on navigation stack
function guiModule:pushCommands(commands)
	-- Insert registered commands into the stack
	table.insert(guiModule.navigationStack, guiModule.registeredCommands)

	-- reset registered commands
	guiModule.registeredCommands = {}

	-- loop through commands
	for _, cmd in commands do
		table.insert(guiModule.registeredCommands, cmd)
	end

	-- get the selected command
	guiModule.selectedCommand = 1

	-- finally, we rebuild
	guiModule:rebuildUI()
end

--// Pops navigation stack commands
function guiModule:popCommands()
	-- previous
	local prev = table.remove(guiModule.navigationStack)

	-- does previous exist?
	if prev then
		guiModule.registeredCommands = prev
		guiModule.selectedCommand = 1
		guiModule:addCommands(prev)
	else
		guiModule:closePalette()
	end
end

function guiModule:rebuildTheme()
	local gui = guiModule.guiElements.Gui

	-- Palette
	if gui.Palette then
		gui.Palette.BackgroundColor3 = guiModule.colorPalette[guiModule.selectedPalette].Surface0
		local stroke : UIStroke = gui.Palette:FindFirstChild("UIStroke")
		if stroke then
			stroke.Color = guiModule.colorPalette[guiModule.selectedPalette].Surface2
		end
	end

	-- Input
	if gui.Input then
		gui.Input.BackgroundColor3 = guiModule.colorPalette[guiModule.selectedPalette].Surface0
		local textBox : TextBox = gui.Input:FindFirstChild("TextBox")
		if textBox then
			textBox.PlaceholderColor3 = guiModule.colorPalette[guiModule.selectedPalette].Subtext0
			textBox.TextColor3 = guiModule.colorPalette[guiModule.selectedPalette].Subtext0
		end
	end

	-- Spacer
	if gui.Palette then
		local spacer : Frame = gui.Palette:FindFirstChild("Spacer")
		if spacer then
			spacer.BackgroundColor3 = guiModule.colorPalette[guiModule.selectedPalette].Surface2
		end
	end

	-- CommandsScrolling
	if gui.CommandsScrolling then 
		gui.CommandsScrolling.ScrollBarImageColor3 = guiModule.colorPalette[guiModule.selectedPalette].Overlay0
	end

	-- Commands (dynamic, re-iterate if already rendered)
	for i, cmd in gui.Commands do
		local frame : TextButton = cmd.commandFrame
		local isSelected = (i == guiModule.selectedCommand)

		frame.BackgroundColor3 = isSelected and guiModule.colorPalette[guiModule.selectedPalette].Surface1 or guiModule.colorPalette[guiModule.selectedPalette].Surface0

		local selectedBar = frame:FindFirstChild("Selected")
		if selectedBar then
			selectedBar.BackgroundColor3 = guiModule.colorPalette[guiModule.selectedPalette].Blue
		end

		local title = frame:FindFirstChild("Title")
		if title then
			title.TextColor3 = guiModule.colorPalette[guiModule.selectedPalette].Text
		end
	end
end

--// Animate opening the palette smoothly!
function guiModule:animateOpen(palette: Frame)

    -- Set defaults
	palette.Position = UDim2.new(0.5, 0, 0, 10)
	palette.BackgroundTransparency = 1
	palette.Size = UDim2.new(0, 660, 0, 0)

    -- Create tween, Quint Out
	local tween = TweenService:Create(palette, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 0, 0, 40),
		BackgroundTransparency = 0,
		Size = UDim2.new(0, 660, 0, 490),
	})

    -- Play tween
	tween:Play()
end

--// Animate closing the palette
function guiModule:animateClose(palette: Frame, onComplete: () -> ())

    -- Create the tween, Quart In
	local tween = TweenService:Create(palette, TweenInfo.new(0.13, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0, 10),
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 660, 0, 0),
	})

    -- Cycle through commands & make transparent for effect.
    for _, cmd in guiModule.guiElements.Gui.Commands do
        local frame = cmd.commandFrame
        frame.BackgroundTransparency = 1
    end

    -- Play the tween
	tween:Play()

    -- Execute callback on completion
	tween.Completed:Connect(onComplete)
end

--// Open the palette gui!
function guiModule:openPalette()
	-- Reset nav stack.
	guiModule.navigationStack = {}

    -- define should animate
    local shouldAnimate = true

	-- Is gui open? if so, close so we can re-open after.
	if getOpenGui() then
		guiModule:closePalette(true)
        shouldAnimate = false
	end

	-- Create our screenGui holder
	local screenGui = createInstance("ScreenGui", {
		Parent = game:GetService("CoreGui"),
		Name = "cmdle",

		DisplayOrder = 9999,
	})

	-- Create the palette & its gui!
	local palette = createPalette(screenGui)
	createInputArea(palette)
	createSpacer(palette)
	createCommandsScrollingFrame(palette)

    -- animateOpen
    if shouldAnimate then
        guiModule:animateOpen(palette)
    end

	-- Finally setup the search
	setupSearch()

	-- Clean selected command
	guiModule.selectedCommand = 1

	-- Temporary way to sink arrow input
	local lockedCF = workspace.CurrentCamera.CFrame
	freezeFrame = RunService.RenderStepped:Connect(function()
		workspace.CurrentCamera.CFrame = CFrame.new(lockedCF.Position) * workspace.CurrentCamera.CFrame.Rotation
	end)
end

--// Close the palette gui (Destroy it)
function guiModule:closePalette(shouldNotAnimate: boolean?)
    local openGui = getOpenGui()
    if not openGui then return end

    if freezeFrame then
        freezeFrame:Disconnect()
        freezeFrame = nil
    end

    if not shouldNotAnimate then
        -- Animated close (user pressed Esc / toggle)
        local palette = openGui:FindFirstChild("Palette")
        if palette then
            guiModule:animateClose(palette, function()
                openGui:Destroy()
            end)
        else
            openGui:Destroy()
        end
    else
        -- Instant close (called internally before re-opening)
        openGui:Destroy()
    end
end

--// Register create command function
guiModule.createCommandPreview = createCommandPreview

--// Reset all commands in module
guiModule.removeAllCommands = removeAllCommands

return guiModule
