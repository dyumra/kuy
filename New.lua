-- CONFIG
local requiredKey = "dev" -- รหัสที่ต้องใส่ก่อนใช้ GUI
local maxKeyAttempts = 3
local currentKeyAttempts = 0

-- Services
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui") -- For notifications
local ReplicatedStorage = game:GetService("ReplicatedStorage") -- For item replication (if server needs to handle)

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyScriptGui"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false -- Keep GUI visible after respawn

-- --- Dragging Function ---
local function makeDraggable(guiObject)
    local dragging
    local dragInput
    local dragStart
    local startPos

    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragInput = input
            dragStart = input.Position
            startPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.Ended then
                    dragging = false
                end
            end)
        end
    end)

    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging and input == dragInput then
                local delta = input.Position - dragStart
                guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
end

-- --- Aesthetic Components ---
local function addRoundedCorners(guiObject)
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8) -- Adjust corner radius as needed
    uiCorner.Parent = guiObject
end

local function addWhiteBorder(guiObject)
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(255, 255, 255)
    uiStroke.Thickness = 1
    uiStroke.Parent = guiObject
end

-- --- GUI Creation ---

-- 🔐 Key Frame
local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0, 300, 0, 180) -- Increased height for credit
keyFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
keyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
keyFrame.BorderSizePixel = 0
keyFrame.Parent = ScreenGui
addRoundedCorners(keyFrame)
addWhiteBorder(keyFrame)
makeDraggable(keyFrame) -- Make key frame draggable

local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(1, 0, 0, 40)
keyLabel.Text = "Enter Key"
keyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
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
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.ClearTextOnFocus = false
keyBox.Parent = keyFrame
addRoundedCorners(keyBox)
addWhiteBorder(keyBox)

local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(1, -20, 0, 40)
submitBtn.Position = UDim2.new(0, 10, 0, 100)
submitBtn.Text = "Submit"
submitBtn.Font = Enum.Font.GothamBold -- Bold for submit
submitBtn.TextScaled = true
submitBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- Red color
submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
submitBtn.Parent = keyFrame
addRoundedCorners(submitBtn)
addWhiteBorder(submitBtn)

local creditLabelKeyFrame = Instance.new("TextLabel")
creditLabelKeyFrame.Size = UDim2.new(1, 0, 0, 20)
creditLabelKeyFrame.Position = UDim2.new(0, 0, 0, 150)
creditLabelKeyFrame.Text = "Credit: Dyumra"
creditLabelKeyFrame.TextColor3 = Color3.fromRGB(200, 200, 200)
creditLabelKeyFrame.Font = Enum.Font.Gotham
creditLabelKeyFrame.TextSize = 14
creditLabelKeyFrame.BackgroundTransparency = 1
creditLabelKeyFrame.Parent = keyFrame

-- ✅ Main GUI Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0, 10, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = ScreenGui
addRoundedCorners(mainFrame)
addWhiteBorder(mainFrame)
makeDraggable(mainFrame) -- Make main frame draggable

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "TUNGHUB" -- Script Name
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Parent = mainFrame
addRoundedCorners(title) -- Add rounded corners to the title bar

local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(1, 0, 0, 50)
buttonFrame.Position = UDim2.new(0, 0, 0, 50)
buttonFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
buttonFrame.Parent = mainFrame
addRoundedCorners(buttonFrame) -- Add rounded corners to button frame

local buttonFontSize = 18 -- Smaller font size for category buttons
local buttonFont = Enum.Font.GothamBold

local playerBtn = Instance.new("TextButton")
playerBtn.Size = UDim2.new(1/3, 0, 1, 0)
playerBtn.Text = "Player (OFF)"
playerBtn.Font = buttonFont
playerBtn.TextSize = buttonFontSize
playerBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
playerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
playerBtn.Parent = buttonFrame
addWhiteBorder(playerBtn)

local itemBtn = Instance.new("TextButton")
itemBtn.Size = UDim2.new(1/3, 0, 1, 0)
itemBtn.Position = UDim2.new(1/3, 0, 0, 0)
itemBtn.Text = "Item (OFF)"
itemBtn.Font = buttonFont
itemBtn.TextSize = buttonFontSize
itemBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
itemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
itemBtn.Parent = buttonFrame
addWhiteBorder(itemBtn)

local miscBtn = Instance.new("TextButton")
miscBtn.Size = UDim2.new(1/3, 0, 1, 0)
miscBtn.Position = UDim2.new(2/3, 0, 0, 0)
miscBtn.Text = "Misc (OFF)"
miscBtn.Font = buttonFont
miscBtn.TextSize = buttonFontSize
miscBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
miscBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
miscBtn.Parent = buttonFrame
addWhiteBorder(miscBtn)

local featureFrame = Instance.new("Frame")
featureFrame.Size = UDim2.new(1, 0, 1, -100)
featureFrame.Position = UDim2.new(0, 0, 0, 100)
featureFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
featureFrame.Parent = mainFrame
addRoundedCorners(featureFrame)
addWhiteBorder(featureFrame)

local creditLabelMainFrame = Instance.new("TextLabel")
creditLabelMainFrame.Size = UDim2.new(1, 0, 0, 20)
creditLabelMainFrame.Position = UDim2.new(0, 0, 1, -20)
creditLabelMainFrame.Text = "Credit: Dyumra"
creditLabelMainFrame.TextColor3 = Color3.fromRGB(200, 200, 200)
creditLabelMainFrame.Font = Enum.Font.Gotham
creditLabelMainFrame.TextSize = 14
creditLabelMainFrame.BackgroundTransparency = 1
creditLabelMainFrame.Parent = mainFrame


-- --- Hide/Show Button ---
local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 30, 0, 30)
hideBtn.Position = UDim2.new(1, -40, 0, 10) -- Top right
hideBtn.Text = "-"
hideBtn.Font = Enum.Font.GothamBold
hideBtn.TextScaled = true
hideBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- Red
hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hideBtn.Parent = ScreenGui
addRoundedCorners(hideBtn)
addWhiteBorder(hideBtn)
makeDraggable(hideBtn)
hideBtn.Visible = false -- Hidden until login

hideBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    hideBtn.Text = mainFrame.Visible and "-" or "+"
end)

-- --- Feature Logic ---
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
	highlight.FillColor = Color3.fromRGB(255, 0, 0) -- RED
	highlight.OutlineColor = Color3.fromRGB(255, 0, 0) -- RED
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
		task.wait(0.1) -- small delay to ensure character loaded
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
	speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	speedLabel.BackgroundTransparency = 1
	speedLabel.Font = Enum.Font.Gotham
	speedLabel.TextScaled = true
	speedLabel.Parent = featureFrame

	local speedBox = Instance.new("TextBox")
	speedBox.Size = UDim2.new(1, -20, 0, 40)
	speedBox.Position = UDim2.new(0, 10, 0, 50)
	speedBox.PlaceholderText = "Enter speed (e.g., 0.5)"
	speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	speedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	speedBox.TextScaled = true
	speedBox.Font = Enum.Font.Gotham
	speedBox.Parent = featureFrame
    addRoundedCorners(speedBox)
    addWhiteBorder(speedBox)

	local enterSpeed = Instance.new("TextButton")
	enterSpeed.Size = UDim2.new(1, -20, 0, 40)
	enterSpeed.Position = UDim2.new(0, 10, 0, 100)
	enterSpeed.Text = "Enter Speed"
	enterSpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
	enterSpeed.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
	enterSpeed.Font = Enum.Font.GothamBold
	enterSpeed.TextScaled = true
	enterSpeed.Parent = featureFrame
    addRoundedCorners(enterSpeed)
    addWhiteBorder(enterSpeed)

	enterSpeed.MouseButton1Click:Connect(function()
		if speedConnection then speedConnection:Disconnect() end
		local speed = tonumber(speedBox.Text)
		if speed and player.Character and player.Character:FindFirstChild("Humanoid") then
			speedConnection = RunService.RenderStepped:Connect(function()
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.MoveDirection.Magnitude > 0 then
					local moveDir = player.Character.Humanoid.MoveDirection
					player.Character.HumanoidRootPart.CFrame += moveDir * speed
				end
			end)
            StarterGui:SetCore("SendNotification", {
				Title = "Speed Set";
				Text = "Walk speed set to " .. speed .. ".";
				Duration = 3;
			})
		else
			StarterGui:SetCore("SendNotification", {
				Title = "Speed Error";
				Text = "Please enter a valid number for speed.";
				Duration = 3;
			})
		end
	end)
end

-- Item Features (Teleport & Item Copy)
local currentSelectedItem = nil

local function showItemFeatures()
    clearFeatures()

    local itemLabel = Instance.new("TextLabel")
    itemLabel.Size = UDim2.new(1, 0, 0, 30)
    itemLabel.Text = "Teleport to Player:"
    itemLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    itemLabel.BackgroundTransparency = 1
    itemLabel.Font = Enum.Font.Gotham
    itemLabel.TextScaled = true
    itemLabel.Parent = featureFrame

    local tpBox = Instance.new("TextBox")
    tpBox.Size = UDim2.new(1, -20, 0, 30)
    tpBox.Position = UDim2.new(0, 10, 0, 30)
    tpBox.PlaceholderText = "Enter player name (partial match)"
    tpBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    tpBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tpBox.TextScaled = true
    tpBox.Font = Enum.Font.Gotham
    tpBox.Parent = featureFrame
    addRoundedCorners(tpBox)
    addWhiteBorder(tpBox)

    local tpBtn = Instance.new("TextButton")
    tpBtn.Size = UDim2.new(1, -20, 0, 30)
    tpBtn.Position = UDim2.new(0, 10, 0, 65)
    tpBtn.Text = "Teleport"
    tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tpBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    tpBtn.Font = Enum.Font.GothamBold
    tpBtn.TextScaled = true
    tpBtn.Parent = featureFrame
    addRoundedCorners(tpBtn)
    addWhiteBorder(tpBtn)

    tpBtn.MouseButton1Click:Connect(function()
        local targetName = tpBox.Text:lower()
        local foundPlayer = nil

        if targetName == "" then
            StarterGui:SetCore("SendNotification", {
                Title = "Teleport Error";
                Text = "Please enter a player name to teleport to.";
                Duration = 3;
            })
            return
        end

        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name:lower():find(targetName) then
                foundPlayer = plr
                break
            end
        end

        if foundPlayer and foundPlayer.Character and foundPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = foundPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0) -- Teleport slightly above
                StarterGui:SetCore("SendNotification", {
                    Title = "Teleport Success";
                    Text = "Teleported to " .. foundPlayer.Name .. "!";
                    Duration = 3;
                })
            else
                StarterGui:SetCore("SendNotification", {
                    Title = "Teleport Failed";
                    Text = "Your character is not ready to teleport.";
                    Duration = 3;
                })
            end
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Player Not Found";
                Text = "Could not find player '" .. tpBox.Text .. "' or their character is not loaded.";
                Duration = 3;
            })
        end
    end)

    local itemCopyLabel = Instance.new("TextLabel")
    itemCopyLabel.Size = UDim2.new(1, 0, 0, 30)
    itemCopyLabel.Position = UDim2.new(0, 0, 0, 100)
    itemCopyLabel.Text = "Copy Items from Others:"
    itemCopyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    itemCopyLabel.BackgroundTransparency = 1
    itemCopyLabel.Font = Enum.Font.Gotham
    itemCopyLabel.TextScaled = true
    itemCopyLabel.Parent = featureFrame

    local itemScrollFrame = Instance.new("ScrollingFrame")
    itemScrollFrame.Size = UDim2.new(1, -20, 1, -200) -- Adjust size to fit below teleport and above buttons
    itemScrollFrame.Position = UDim2.new(0, 10, 0, 130)
    itemScrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    itemScrollFrame.BorderSizePixel = 0
    itemScrollFrame.Parent = featureFrame
    addRoundedCorners(itemScrollFrame)
    addWhiteBorder(itemScrollFrame)

    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.FillDirection = Enum.FillDirection.Vertical
    uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uiListLayout.Padding = UDim.new(0, 5)
    uiListLayout.Parent = itemScrollFrame

    local giveBtn = Instance.new("TextButton")
    giveBtn.Size = UDim2.new(0.48, 0, 0, 40)
    giveBtn.Position = UDim2.new(0.01, 0, 1, -50) -- Adjusted position
    giveBtn.Text = "Give"
    giveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    giveBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    giveBtn.Font = Enum.Font.GothamBold
    giveBtn.TextScaled = true
    giveBtn.Parent = featureFrame
    addRoundedCorners(giveBtn)
    addWhiteBorder(giveBtn)

    local giveAllBtn = Instance.new("TextButton")
    giveAllBtn.Size = UDim2.new(0.48, 0, 0, 40)
    giveAllBtn.Position = UDim2.new(0.51, 0, 1, -50) -- Adjusted position
    giveAllBtn.Text = "Give All"
    giveAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    giveAllBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    giveAllBtn.Font = Enum.Font.GothamBold
    giveAllBtn.TextScaled = true
    giveAllBtn.Parent = featureFrame
    addRoundedCorners(giveAllBtn)
    addWhiteBorder(giveAllBtn)

    local itemButtons = {} -- Store references to item buttons for selection

    local function updateItemList()
        for _, btn in pairs(itemButtons) do
            btn:Destroy()
        end
        itemButtons = {}
        currentSelectedItem = nil -- Reset selection

        local allItems = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Backpack then
                for _, item in pairs(plr.Backpack:GetChildren()) do
                    if item:IsA("Tool") or item:IsA("ForceField") then -- You can add more item types here
                        table.insert(allItems, item:Clone()) -- Clone to avoid direct manipulation of original
                    end
                end
            end
        end

        -- Remove duplicates based on name
        local uniqueItems = {}
        local seenNames = {}
        for _, item in pairs(allItems) do
            if not seenNames[item.Name] then
                table.insert(uniqueItems, item)
                seenNames[item.Name] = true
            else
                item:Destroy() -- Destroy duplicate clone
            end
        end

        for _, item in pairs(uniqueItems) do
            local itemBtn = Instance.new("TextButton")
            itemBtn.Size = UDim2.new(1, -10, 0, 30)
            itemBtn.Text = item.Name
            itemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            itemBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            itemBtn.Font = Enum.Font.Gotham
            itemBtn.TextScaled = true
            itemBtn.Parent = itemScrollFrame
            addRoundedCorners(itemBtn)
            addWhiteBorder(itemBtn)

            itemBtn.MouseButton1Click:Connect(function()
                if currentSelectedItem then
                    currentSelectedItem.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Deselect previous
                end
                itemBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0) -- Select current (darker red)
                currentSelectedItem = itemBtn
            end)
            itemButtons[item.Name] = itemBtn -- Store for access
        end
    end

    -- Initial load
    updateItemList()

    -- Connect to player/item changes to update list
    Players.PlayerAdded:Connect(updateItemList)
    Players.PlayerRemoving:Connect(updateItemList)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            if plr.Backpack then
                plr.Backpack.ChildAdded:Connect(updateItemList)
                plr.Backpack.ChildRemoved:Connect(updateItemList)
            end
        end
    end

    giveBtn.MouseButton1Click:Connect(function()
        if currentSelectedItem then
            local itemName = currentSelectedItem.Text
            local itemToGive = nil
            -- Find the actual item object from all players
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= player and plr.Backpack then
                    local found = plr.Backpack:FindFirstChild(itemName)
                    if found and (found:IsA("Tool") or found:IsA("ForceField")) then
                        itemToGive = found
                        break
                    end
                end
            end

            if itemToGive then
                local clonedItem = itemToGive:Clone()
                clonedItem.Parent = player.Backpack
                StarterGui:SetCore("SendNotification", {
                    Title = "Item Acquired";
                    Text = "You received: " .. itemName;
                    Duration = 2;
                })
            else
                StarterGui:SetCore("SendNotification", {
                    Title = "Error";
                    Text = "Item '" .. itemName .. "' not found in any player's backpack anymore.";
                    Duration = 3;
                })
            end
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Error";
                Text = "Please select an item to give.";
                Duration = 3;
            })
        end
    })

    giveAllBtn.MouseButton1Click:Connect(function()
        local itemsGiven = 0
        local allItemsToGive = {}
        
        -- Collect all unique items from all players' backpacks (similar to updateItemList logic)
        local seenNames = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Backpack then
                for _, item in pairs(plr.Backpack:GetChildren()) do
                    if (item:IsA("Tool") or item:IsA("ForceField")) and not seenNames[item.Name] then
                        table.insert(allItemsToGive, item)
                        seenNames[item.Name] = true
                    end
                end
            end
        end

        for _, itemToGive in pairs(allItemsToGive) do
            local clonedItem = itemToGive:Clone()
            clonedItem.Parent = player.Backpack
            itemsGiven = itemsGiven + 1
        end

        if itemsGiven > 0 then
            StarterGui:SetCore("SendNotification", {
                Title = "Items Acquired";
                Text = "You received " .. itemsGiven .. " unique items!";
                Duration = 3;
            })
        else
            StarterGui:SetCore("SendNotification", {
                Title = "No Items";
                Text = "No unique items found to give.";
                Duration = 3;
            })
        end
    end)
end

-- Misc Features
local fogEnabled = false -- Default to OFF, button text is OFF
local fbEnabled = false -- Default to OFF, button text is OFF
local function showMiscFeatures()
	clearFeatures()

	local noFogBtn = Instance.new("TextButton")
	noFogBtn.Size = UDim2.new(1, -20, 0, 40)
	noFogBtn.Position = UDim2.new(0, 10, 0, 10)
	noFogBtn.Text = "Toggle NoFog (OFF)" -- Changed initial text
	noFogBtn.TextScaled = true
	noFogBtn.Font = Enum.Font.GothamBold
	noFogBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	noFogBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	noFogBtn.Parent = featureFrame
    addRoundedCorners(noFogBtn)
    addWhiteBorder(noFogBtn)

	local function toggleFog()
		fogEnabled = not fogEnabled
		if fogEnabled then
			Lighting.FogEnd = 1000000 -- Increased value to ensure no fog
			noFogBtn.Text = "Toggle NoFog (ON)"
            StarterGui:SetCore("SendNotification", {
				Title = "NoFog Activated";
				Text = "Fog has been removed.";
				Duration = 2;
			})
		else
			-- Reset to default for games (or can use a predefined default if known)
            -- A common default for FogEnd is 0, but it can vary. Set to 0 for a clear default.
			Lighting.FogEnd = 0
			noFogBtn.Text = "Toggle NoFog (OFF)"
             StarterGui:SetCore("SendNotification", {
				Title = "NoFog Deactivated";
				Text = "Fog has been restored.";
				Duration = 2;
			})
		end
	end
	noFogBtn.MouseButton1Click:Connect(toggleFog)

	local fbBtn = Instance.new("TextButton")
	fbBtn.Size = UDim2.new(1, -20, 0, 40)
	fbBtn.Position = UDim2.new(0, 10, 0, 60)
	fbBtn.Text = "Toggle FullBright (OFF)"
	fbBtn.TextScaled = true
	fbBtn.Font = Enum.Font.GothamBold
	fbBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	fbBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	fbBtn.Parent = featureFrame
    addRoundedCorners(fbBtn)
    addWhiteBorder(fbBtn)

	local function toggleFullBright()
		fbEnabled = not fbEnabled
		if fbEnabled then
			Lighting.Brightness = 2 -- Example value, adjust as needed for desired brightness
			Lighting.Ambient = Color3.fromRGB(255, 255, 255)
			Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
			fbBtn.Text = "Toggle FullBright (ON)"
            StarterGui:SetCore("SendNotification", {
				Title = "FullBright Activated";
				Text = "Environment is now brighter.";
				Duration = 2;
			})
		else
			-- Reset to default lighting values (these might vary per game, so adjust if necessary)
			Lighting.Brightness = 1 -- Default Roblox brightness
			Lighting.Ambient = Color3.fromRGB(0, 0, 0) -- Default ambient
			Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0) -- Default outdoor ambient
			fbBtn.Text = "Toggle FullBright (OFF)"
            StarterGui:SetCore("SendNotification", {
				Title = "FullBright Deactivated";
				Text = "Environment lighting restored.";
				Duration = 2;
			})
		end
	end
	fbBtn.MouseButton1Click:Connect(toggleFullBright)
end

-- Button Clicks (Category Toggles)
playerBtn.MouseButton1Click:Connect(function()
	local isOn = playerBtn.Text:find("(ON)")
	if not isOn then
		playerBtn.Text = "Player (ON)"
		showPlayerFeatures()
		toggleESP(true)
	else
		playerBtn.Text = "Player (OFF)"
		clearFeatures()
		toggleESP(false)
		if speedConnection then speedConnection:Disconnect() speedConnection = nil end
	end
    -- Reset other buttons to OFF
    itemBtn.Text = "Item (OFF)"
		miscBtn.Text = "Misc (OFF)"
end)

itemBtn.MouseButton1Click:Connect(function()
	local isOn = itemBtn.Text:find("(ON)")
	if not isOn then
		itemBtn.Text = "Item (ON)"
		showItemFeatures()
	else
		itemBtn.Text = "Item (OFF)"
		clearFeatures()
	end
    -- Reset other buttons to OFF
    playerBtn.Text = "Player (OFF)"
    miscBtn.Text = "Misc (OFF)"
    if speedConnection then speedConnection:Disconnect() speedConnection = nil end -- Disconnect speed if player button was ON
    toggleESP(false) -- Disable ESP if player button was ON
end)

miscBtn.MouseButton1Click:Connect(function()
	local isOn = miscBtn.Text:find("(ON)")
	if not isOn then
		miscBtn.Text = "Misc (ON)"
		showMiscFeatures()
	else
		miscBtn.Text = "Misc (OFF)"
		clearFeatures()
	end
    -- Reset other buttons to OFF
    playerBtn.Text = "Player (OFF)"
    itemBtn.Text = "Item (OFF)"
    if speedConnection then speedConnection:Disconnect() speedConnection = nil end -- Disconnect speed if player button was ON
    toggleESP(false) -- Disable ESP if player button was ON
end)

-- Submit Button for Key
submitBtn.MouseButton1Click:Connect(function()
	if keyBox.Text == requiredKey then
		keyFrame:Destroy()
		mainFrame.Visible = true
        hideBtn.Visible = true -- Show hide button after successful login
        currentKeyAttempts = 0 -- Reset attempts on success
	else
		currentKeyAttempts = currentKeyAttempts + 1
		keyBox.Text = ""
		keyBox.PlaceholderText = "Wrong key! (" .. currentKeyAttempts .. "/" .. maxKeyAttempts .. ")"
		StarterGui:SetCore("SendNotification", {
			Title = "Authentication Failed";
			Text = "Incorrect key. Attempts left: " .. (maxKeyAttempts - currentKeyAttempts);
			Duration = 3;
		})

		if currentKeyAttempts >= maxKeyAttempts then
			StarterGui:SetCore("SendNotification", {
				Title = "Access Denied";
				Text = "Banned: 100 Days (Too many failed attempts)";
				Duration = 5;
			})
			task.wait(1) -- Wait briefly for notification to show
			player:Kick("Banned: 100 Days - Too many failed attempts.")
		end
	end
end)
