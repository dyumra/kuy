-- CONFIG
local requiredKey = "dev" -- รหัสที่ต้องใส่ก่อนใช้ GUI

-- Services
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyScriptGui"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- 🔐 Key Frame
local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0, 300, 0, 150)
keyFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
keyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
keyFrame.BorderSizePixel = 0
keyFrame.Parent = ScreenGui

local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(1, 0, 0, 40)
keyLabel.Text = "Enter Key"
keyLabel.TextColor3 = Color3.new(1, 1, 1)
keyLabel.Font = Enum.Font.GothamBold
keyLabel.TextScaled = true
keyLabel.BackgroundTransparency = 1
keyLabel.Parent = keyFrame

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, -20, 0, 40)
keyBox.Position = UDim2.new(0, 10, 0, 50)
keyBox.PlaceholderText = "Enter key here"
keyBox.Font = Enum.Font.Gotham
keyBox.TextScaled = true
keyBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
keyBox.TextColor3 = Color3.new(1, 1, 1)
keyBox.ClearTextOnFocus = false
keyBox.Parent = keyFrame

local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(1, -20, 0, 40)
submitBtn.Position = UDim2.new(0, 10, 0, 100)
submitBtn.Text = "Submit"
submitBtn.Font = Enum.Font.Gotham
submitBtn.TextScaled = true
submitBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
submitBtn.TextColor3 = Color3.new(1, 1, 1)
submitBtn.Parent = keyFrame

-- ✅ Main GUI Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0, 10, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = ScreenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "My Menu"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Parent = mainFrame

local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(1, 0, 0, 50)
buttonFrame.Position = UDim2.new(0, 0, 0, 50)
buttonFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
buttonFrame.Parent = mainFrame

local playerBtn = Instance.new("TextButton")
playerBtn.Size = UDim2.new(1/3, 0, 1, 0)
playerBtn.Text = "Player (OFF)"
playerBtn.Font = Enum.Font.Gotham
playerBtn.TextScaled = true
playerBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
playerBtn.TextColor3 = Color3.new(1, 1, 1)
playerBtn.Parent = buttonFrame

local itemBtn = Instance.new("TextButton")
itemBtn.Size = UDim2.new(1/3, 0, 1, 0)
itemBtn.Position = UDim2.new(1/3, 0, 0, 0)
itemBtn.Text = "Item (OFF)"
itemBtn.Font = Enum.Font.Gotham
itemBtn.TextScaled = true
itemBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
itemBtn.TextColor3 = Color3.new(1, 1, 1)
itemBtn.Parent = buttonFrame

local miscBtn = Instance.new("TextButton")
miscBtn.Size = UDim2.new(1/3, 0, 1, 0)
miscBtn.Position = UDim2.new(2/3, 0, 0, 0)
miscBtn.Text = "Misc (OFF)"
miscBtn.Font = Enum.Font.Gotham
miscBtn.TextScaled = true
miscBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
miscBtn.TextColor3 = Color3.new(1, 1, 1)
miscBtn.Parent = buttonFrame

local featureFrame = Instance.new("Frame")
featureFrame.Size = UDim2.new(1, 0, 1, -100)
featureFrame.Position = UDim2.new(0, 0, 0, 100)
featureFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
featureFrame.Parent = mainFrame

local function clearFeatures()
	for _, child in ipairs(featureFrame:GetChildren()) do
		if child:IsA("GuiObject") then
			child:Destroy()
		end
	end
end

-- Table to keep ESP state
local espEnabled = false
local espHighlights = {}

local function createHighlight(targetCharacter)
	if espHighlights[targetCharacter] then return end -- already has

	local highlight = Instance.new("Highlight")
	highlight.Adornee = targetCharacter
	highlight.FillColor = Color3.fromRGB(0, 255, 0)
	highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
	highlight.Parent = targetCharacter
	espHighlights[targetCharacter] = highlight
end

local function removeHighlight(targetCharacter)
	if espHighlights[targetCharacter] then
		espHighlights[targetCharacter]:Destroy()
		espHighlights[targetCharacter] = nil
	end
end

local function toggleESP(state)
	espEnabled = state

	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") then
			if espEnabled then
				createHighlight(plr.Character)
			else
				removeHighlight(plr.Character)
			end
		end
	end
end

-- Handle new players or respawned characters for ESP
local function onCharacterAdded(char)
	if espEnabled then
		wait(0.1) -- small delay to ensure character loaded
		createHighlight(char)
	end
end

local function onPlayerAdded(plr)
	plr.CharacterAdded:Connect(onCharacterAdded)
	if plr.Character then
		onCharacterAdded(plr.Character)
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, plr in pairs(Players:GetPlayers()) do
	if plr ~= player then
		onPlayerAdded(plr)
	end
end

-- Player Features
local speedConnection = nil
local function showPlayerFeatures()
	clearFeatures()

	local speedLabel = Instance.new("TextLabel")
	speedLabel.Size = UDim2.new(1, 0, 0, 40)
	speedLabel.Text = "Set Walk Speed (CFrame)"
	speedLabel.TextColor3 = Color3.new(1, 1, 1)
	speedLabel.BackgroundTransparency = 1
	speedLabel.Font = Enum.Font.Gotham
	speedLabel.TextScaled = true
	speedLabel.Parent = featureFrame

	local speedBox = Instance.new("TextBox")
	speedBox.Size = UDim2.new(1, -20, 0, 40)
	speedBox.Position = UDim2.new(0, 10, 0, 50)
	speedBox.PlaceholderText = "Enter speed (e.g., 0.5)"
	speedBox.TextColor3 = Color3.new(1, 1, 1)
	speedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	speedBox.TextScaled = true
	speedBox.Font = Enum.Font.Gotham
	speedBox.Parent = featureFrame

	local enterSpeed = Instance.new("TextButton")
	enterSpeed.Size = UDim2.new(1, -20, 0, 40)
	enterSpeed.Position = UDim2.new(0, 10, 0, 100)
	enterSpeed.Text = "Enter Speed"
	enterSpeed.TextColor3 = Color3.new(1, 1, 1)
	enterSpeed.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	enterSpeed.Font = Enum.Font.Gotham
	enterSpeed.TextScaled = true
	enterSpeed.Parent = featureFrame

	enterSpeed.MouseButton1Click:Connect(function()
		if speedConnection then speedConnection:Disconnect() end
		local speed = tonumber(speedBox.Text)
		if speed then
			speedConnection = RunService.RenderStepped:Connect(function()
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local moveDir = player.Character.Humanoid.MoveDirection
					player.Character.HumanoidRootPart.CFrame += moveDir * speed
				end
			end)
		end
	end)
end

-- Item Features
local function showItemFeatures()
	clearFeatures()
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 40)
	label.Text = "Item Features Here"
	label.Font = Enum.Font.Gotham
	label.TextScaled = true
	label.TextColor3 = Color3.new(1, 1, 1)
	label.BackgroundTransparency = 1
	label.Parent = featureFrame
end

-- Misc Features
local fogEnabled = true
local fbOn = false
local function showMiscFeatures()
	clearFeatures()

	local noFogBtn = Instance.new("TextButton")
	noFogBtn.Size = UDim2.new(1, -20, 0, 40)
	noFogBtn.Position = UDim2.new(0, 10, 0, 10)
	noFogBtn.Text = "Toggle NoFog (ON)"
	noFogBtn.TextScaled = true
	noFogBtn.Font = Enum.Font.Gotham
	noFogBtn.TextColor3 = Color3.new(1, 1, 1)
	noFogBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	noFogBtn.Parent = featureFrame

	local function toggleFog()
		if fogEnabled then
			Lighting.FogEnd = 100000
			noFogBtn.Text = "Toggle NoFog (OFF)"
		else
			Lighting.FogEnd = 1000
			noFogBtn.Text = "Toggle NoFog (ON)"
		end
		fogEnabled = not fogEnabled
	end
	noFogBtn.MouseButton1Click:Connect(toggleFog)

	local fbBtn = Instance.new("TextButton")
	fbBtn.Size = UDim2.new(1, -20, 0, 40)
	fbBtn.Position = UDim2.new(0, 10, 0, 60)
	fbBtn.Text = "Toggle FB (OFF)"
	fbBtn.TextScaled = true
	fbBtn.Font = Enum.Font.Gotham
	fbBtn.TextColor3 = Color3.new(1, 1, 1)
	fbBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	fbBtn.Parent = featureFrame

	fbBtn.MouseButton1Click:Connect(function()
		fbOn = not fbOn
		if fbOn then
			fbBtn.Text = "Toggle FB (ON)"
			-- ใส่โค้ดเปิด FB ที่นี่
		else
			fbBtn.Text = "Toggle FB (OFF)"
			-- ใส่โค้ดปิด FB ที่นี่
		end
	end)
end

-- Button Clicks
playerBtn.MouseButton1Click:Connect(function()
	playerBtn.Text = (playerBtn.Text:find("(OFF)")) and "Player (ON)" or "Player (OFF)"
	if playerBtn.Text:find("(ON)") then
		showPlayerFeatures()
		toggleESP(true)
	else
		clearFeatures()
		toggleESP(false)
		if speedConnection then speedConnection:Disconnect() speedConnection = nil end
	end
end)

itemBtn.MouseButton1Click:Connect(function()
	itemBtn.Text = (itemBtn.Text:find("(OFF)")) and "Item (ON)" or "Item (OFF)"
	if itemBtn.Text:find("(ON)") then
		showItemFeatures()
	else
		clearFeatures()
	end
end)

miscBtn.MouseButton1Click:Connect(function()
	miscBtn.Text = (miscBtn.Text:find("(OFF)")) and "Misc (ON)" or "Misc (OFF)"
	if miscBtn.Text:find("(ON)") then
		showMiscFeatures()
	else
		clearFeatures()
	end
end)

-- Submit Button for Key
submitBtn.MouseButton1Click:Connect(function()
	if keyBox.Text == requiredKey then
		keyFrame:Destroy()
		mainFrame.Visible = true
	else
		keyBox.Text = ""
		keyBox.PlaceholderText = "Wrong key!"
	end
end)
