-- CONFIG
local requiredKey = "dyumra" -- รหัสที่ต้องใส่ก่อนใช้ GUI
local maxKeyAttempts = 3
local currentKeyAttempts = 0

-- Services
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui") -- For notifications

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TUNGHUB_GUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false -- Keep GUI visible after respawn

-- --- Helper Functions ---
local function makeDraggable(guiObject)
    local dragging, dragInput, dragStart, startPos

    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragInput = input
            dragStart = input.Position
            startPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.Ended then dragging = false end
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

local function addAesthetics(guiObject)
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = guiObject

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(255, 255, 255)
    uiStroke.Thickness = 1
    uiStroke.Parent = guiObject
end

local function createButton(parent, text, position, size, bgColor, font, textColor, textScaled)
    local btn = Instance.new("TextButton")
    btn.Size = size
    btn.Position = position
    btn.Text = text
    btn.Font = font
    btn.TextScaled = textScaled
    btn.BackgroundColor3 = bgColor
    btn.TextColor3 = textColor
    btn.Parent = parent
    addAesthetics(btn)
    return btn
end

local function createLabel(parent, text, position, size, textColor, font, textScaled, backgroundTransparency)
    local label = Instance.new("TextLabel")
    label.Size = size
    label.Position = position
    label.Text = text
    label.TextColor3 = textColor
    label.Font = font
    label.TextScaled = textScaled
    label.BackgroundTransparency = backgroundTransparency or 1
    label.Parent = parent
    return label
end

local function createTextBox(parent, placeholder, position, size, textColor, bgColor, font, textScaled, clearOnFocus)
    local box = Instance.new("TextBox")
    box.Size = size
    box.Position = position
    box.PlaceholderText = placeholder
    box.TextColor3 = textColor
    box.BackgroundColor3 = bgColor
    box.Font = font
    box.TextScaled = textScaled
    box.ClearTextOnFocus = clearOnFocus or false
    box.Parent = parent
    addAesthetics(box)
    return box
end

-- --- Key Frame ---
local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0, 300, 0, 180)
keyFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
keyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
keyFrame.Parent = ScreenGui
addAesthetics(keyFrame)
makeDraggable(keyFrame)

createLabel(keyFrame, "Enter Key", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 40), Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, true)
local keyBox = createTextBox(keyFrame, "Enter key here", UDim2.new(0, 10, 0, 50), UDim2.new(1, -20, 0, 40), Color3.fromRGB(255, 255, 255), Color3.fromRGB(50, 50, 50), Enum.Font.Gotham, true, false)
local submitBtn = createButton(keyFrame, "Submit", UDim2.new(0, 10, 0, 100), UDim2.new(1, -20, 0, 40), Color3.fromRGB(150, 0, 0), Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), true)
createLabel(keyFrame, "Credit: Dyumra", UDim2.new(0, 0, 0, 150), UDim2.new(1, 0, 0, 20), Color3.fromRGB(200, 200, 200), Enum.Font.Gotham, false, 1)

-- --- Main GUI Frame ---
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0, 10, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.Parent = ScreenGui
mainFrame.Visible = false
addAesthetics(mainFrame)
makeDraggable(mainFrame)

createLabel(mainFrame, "TUNGHUB", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 50), Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, true, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Background for title area

local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(1, 0, 0, 50)
buttonFrame.Position = UDim2.new(0, 0, 0, 50)
buttonFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
buttonFrame.Parent = mainFrame
addAesthetics(buttonFrame)

local buttonFont = Enum.Font.GothamBold
local buttonTextColor = Color3.fromRGB(255, 255, 255)
local buttonBgColor = Color3.fromRGB(50, 50, 50)

local playerBtn = createButton(buttonFrame, "Player (OFF)", UDim2.new(0, 0, 0, 0), UDim2.new(1/3, 0, 1, 0), buttonBgColor, buttonFont, buttonTextColor, true)
local itemBtn = createButton(buttonFrame, "Item (OFF)", UDim2.new(1/3, 0, 0, 0), UDim2.new(1/3, 0, 1, 0), buttonBgColor, buttonFont, buttonTextColor, true)
local miscBtn = createButton(buttonFrame, "Misc (OFF)", UDim2.new(2/3, 0, 0, 0), UDim2.new(1/3, 0, 1, 0), buttonBgColor, buttonFont, buttonTextColor, true)

local featureFrame = Instance.new("Frame")
featureFrame.Size = UDim2.new(1, 0, 1, -100)
featureFrame.Position = UDim2.new(0, 0, 0, 100)
featureFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
featureFrame.Parent = mainFrame
addAesthetics(featureFrame)

createLabel(mainFrame, "Credit: Dyumra", UDim2.new(0, 0, 1, -20), UDim2.new(1, 0, 0, 20), Color3.fromRGB(200, 200, 200), Enum.Font.Gotham, false, 1)

-- --- Hide/Show Button ---
local hideBtn = createButton(ScreenGui, "-", UDim2.new(1, -40, 0, 10), UDim2.new(0, 30, 0, 30), Color3.fromRGB(150, 0, 0), Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), true)
makeDraggable(hideBtn)
hideBtn.Visible = false -- Hidden until login

hideBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    hideBtn.Text = mainFrame.Visible and "-" or "+"
end)

-- --- Feature Logic (Mostly unchanged, but using helper functions for UI creation) ---
local function clearFeatures()
    for _, child in ipairs(featureFrame:GetChildren()) do
        if child:IsA("GuiObject") then child:Destroy() end
    end
end

-- ESP
local espEnabled = false
local espHighlights = {}

local function createHighlight(targetCharacter)
    if espHighlights[targetCharacter] then return end
    local highlight = Instance.new("Highlight")
    highlight.Adornee = targetCharacter
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
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
            if espEnabled then createHighlight(plr.Character) else removeHighlight(plr.Character) end
        end
    end
end

local function onCharacterAdded(char)
    if espEnabled then task.wait(0.1); createHighlight(char) end
end

local function onPlayerAdded(plr)
    plr.CharacterAdded:Connect(onCharacterAdded)
    if plr.Character then onCharacterAdded(plr.Character) end
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= player then onPlayerAdded(plr) end
end

-- Player Features
local speedConnection = nil
local function showPlayerFeatures()
    clearFeatures()
    createLabel(featureFrame, "Set Walk Speed (CFrame)", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 40), Color3.fromRGB(255, 255, 255), Enum.Font.Gotham, true)
    local speedBox = createTextBox(featureFrame, "Enter speed (e.g., 0.5)", UDim2.new(0, 10, 0, 50), UDim2.new(1, -20, 0, 40), Color3.fromRGB(255, 255, 255), Color3.fromRGB(40, 40, 40), Enum.Font.Gotham, true)
    local enterSpeed = createButton(featureFrame, "Enter Speed", UDim2.new(0, 10, 0, 100), UDim2.new(1, -20, 0, 40), Color3.fromRGB(150, 0, 0), Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), true)

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
            StarterGui:SetCore("SendNotification", { Title = "Speed Set", Text = "Walk speed set to " .. speed .. ".", Duration = 3 })
        else
            StarterGui:SetCore("SendNotification", { Title = "Speed Error", Text = "Please enter a valid number for speed.", Duration = 3 })
        end
    end)
end

-- Item Features (Teleport & Item Copy)
local currentSelectedItem = nil

local function showItemFeatures()
    clearFeatures()
    createLabel(featureFrame, "Teleport to Player:", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 30), Color3.fromRGB(255, 255, 255), Enum.Font.Gotham, true)
    local tpBox = createTextBox(featureFrame, "Enter player name (partial match)", UDim2.new(0, 10, 0, 30), UDim2.new(1, -20, 0, 30), Color3.fromRGB(255, 255, 255), Color3.fromRGB(40, 40, 40), Enum.Font.Gotham, true)
    local tpBtn = createButton(featureFrame, "Teleport", UDim2.new(0, 10, 0, 65), UDim2.new(1, -20, 0, 30), Color3.fromRGB(150, 0, 0), Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), true)

    tpBtn.MouseButton1Click:Connect(function()
        local targetName = tpBox.Text:lower()
        local foundPlayer = nil
        if targetName == "" then StarterGui:SetCore("SendNotification", { Title = "Teleport Error", Text = "Please enter a player name to teleport to.", Duration = 3 }); return end

        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name:lower():find(targetName) then foundPlayer = plr; break end
        end

        if foundPlayer and foundPlayer.Character and foundPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = foundPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                StarterGui:SetCore("SendNotification", { Title = "Teleport Success", Text = "Teleported to " .. foundPlayer.Name .. "!", Duration = 3 })
            else
                StarterGui:SetCore("SendNotification", { Title = "Teleport Failed", Text = "Your character is not ready to teleport.", Duration = 3 })
            end
        else
            StarterGui:SetCore("SendNotification", { Title = "Player Not Found", Text = "Could not find player '" .. tpBox.Text .. "' or their character is not loaded.", Duration = 3 })
        end
    end)

    createLabel(featureFrame, "Copy Items from Others:", UDim2.new(0, 0, 0, 100), UDim2.new(1, 0, 0, 30), Color3.fromRGB(255, 255, 255), Enum.Font.Gotham, true)

    local itemScrollFrame = Instance.new("ScrollingFrame")
    itemScrollFrame.Size = UDim2.new(1, -20, 1, -200)
    itemScrollFrame.Position = UDim2.new(0, 10, 0, 130)
    itemScrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    itemScrollFrame.Parent = featureFrame
    addAesthetics(itemScrollFrame)

    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.FillDirection = Enum.FillDirection.Vertical
    uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uiListLayout.Padding = UDim.new(0, 5)
    uiListLayout.Parent = itemScrollFrame

    local giveBtn = createButton(featureFrame, "Give", UDim2.new(0.01, 0, 1, -50), UDim2.new(0.48, 0, 0, 40), Color3.fromRGB(150, 0, 0), Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), true)
    local giveAllBtn = createButton(featureFrame, "Give All", UDim2.new(0.51, 0, 1, -50), UDim2.new(0.48, 0, 0, 40), Color3.fromRGB(150, 0, 0), Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), true)

    local itemButtons = {} -- Store references to item buttons for selection

    local function updateItemList()
        for _, btn in pairs(itemButtons) do btn:Destroy() end
        itemButtons = {}
        currentSelectedItem = nil -- Reset selection

        local allItems = {}
        local seenNames = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Backpack then
                for _, item in pairs(plr.Backpack:GetChildren()) do
                    if (item:IsA("Tool") or item:IsA("ForceField")) and not seenNames[item.Name] then
                        table.insert(allItems, item:Clone())
                        seenNames[item.Name] = true
                    end
                end
            end
        end

        for _, item in pairs(allItems) do
            local itemBtn = createButton(itemScrollFrame, item.Name, UDim2.new(0, 0, 0, 0), UDim2.new(1, -10, 0, 30), Color3.fromRGB(50, 50, 50), Enum.Font.Gotham, Color3.fromRGB(255, 255, 255), true)
            itemBtn.MouseButton1Click:Connect(function()
                if currentSelectedItem then currentSelectedItem.BackgroundColor3 = Color3.fromRGB(50, 50, 50) end
                itemBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
                currentSelectedItem = itemBtn
            end)
            itemButtons[item.Name] = itemBtn
            item:Destroy() -- Clean up cloned item after use
        end
    end

    updateItemList()
    Players.PlayerAdded:Connect(updateItemList)
    Players.PlayerRemoving:Connect(updateItemList)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Backpack then
            plr.Backpack.ChildAdded:Connect(updateItemList)
            plr.Backpack.ChildRemoved:Connect(updateItemList)
        end
    end

    giveBtn.MouseButton1Click:Connect(function()
        if currentSelectedItem then
            local itemName = currentSelectedItem.Text
            local itemToGive = nil
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= player and plr.Backpack then
                    local found = plr.Backpack:FindFirstChild(itemName)
                    if found and (found:IsA("Tool") or found:IsA("ForceField")) then
                        itemToGive = found; break
                    end
                end
            end
            if itemToGive then
                local clonedItem = itemToGive:Clone()
                clonedItem.Parent = player.Backpack
                StarterGui:SetCore("SendNotification", { Title = "Item Acquired", Text = "You received: " .. itemName, Duration = 2 })
            else
                StarterGui:SetCore("SendNotification", { Title = "Error", Text = "Item '" .. itemName .. "' not found in any player's backpack anymore.", Duration = 3 })
            end
        else
            StarterGui:SetCore("SendNotification", { Title = "Error", Text = "Please select an item to give.", Duration = 3 })
        end
    end)

    giveAllBtn.MouseButton1Click:Connect(function()
        local itemsGiven = 0
        local allItemsToGive = {}
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
            StarterGui:SetCore("SendNotification", { Title = "Items Acquired", Text = "You received " .. itemsGiven .. " unique items!", Duration = 3 })
        else
            StarterGui:SetCore("SendNotification", { Title = "No Items", Text = "No unique items found to give.", Duration = 3 })
        end
    end)
end

-- Misc Features
local fogEnabled = false
local fbEnabled = false
local function showMiscFeatures()
    clearFeatures()
    local noFogBtn = createButton(featureFrame, "Toggle NoFog (OFF)", UDim2.new(0, 10, 0, 10), UDim2.new(1, -20, 0, 40), Color3.fromRGB(60, 60, 60), Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), true)
    noFogBtn.MouseButton1Click:Connect(function()
        fogEnabled = not fogEnabled
        if fogEnabled then
            Lighting.FogEnd = 1000000
            noFogBtn.Text = "Toggle NoFog (ON)"
            StarterGui:SetCore("SendNotification", { Title = "NoFog Activated", Text = "Fog has been removed.", Duration = 2 })
        else
            Lighting.FogEnd = 0
            noFogBtn.Text = "Toggle NoFog (OFF)"
            StarterGui:SetCore("SendNotification", { Title = "NoFog Deactivated", Text = "Fog has been restored.", Duration = 2 })
        end
    end)

    local fbBtn = createButton(featureFrame, "Toggle FullBright (OFF)", UDim2.new(0, 10, 0, 60), UDim2.new(1, -20, 0, 40), Color3.fromRGB(60, 60, 60), Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), true)
    fbBtn.MouseButton1Click:Connect(function()
        fbEnabled = not fbEnabled
        if fbEnabled then
-- CONFIG
local requiredKey = "dev" -- รหัสที่ต้องใส่ก่อนใช้ GUI
local maxKeyAttempts = 3
local currentKeyAttempts = 0

-- Services
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui") -- For notifications
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Camera = Workspace.CurrentCamera

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TUNGHUB_GUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false -- Keep GUI visible after respawn

-- --- Helper Functions ---
local function makeDraggable(guiObject)
    local dragging, dragInput, dragStart, startPos

    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragInput = input
            dragStart = input.Position
            startPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.Ended then dragging = false end
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

local function addAesthetics(guiObject)
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = guiObject

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(255, 255, 255)
    uiStroke.Thickness = 1
    uiStroke.Parent = guiObject
end

local function createButton(parent, text, position, size, bgColor, font, textColor, textScaled)
    local btn = Instance.new("TextButton")
    btn.Size = size
    btn.Position = position
    btn.Text = text
    btn.Font = font
    btn.TextScaled = textScaled
    btn.BackgroundColor3 = bgColor
    btn.TextColor3 = textColor
    btn.Parent = parent
    addAesthetics(btn)
    return btn
}

local function createLabel(parent, text, position, size, textColor, font, textScaled, backgroundTransparency, bgColor)
    local label = Instance.new("TextLabel")
    label.Size = size
    label.Position = position
    label.Text = text
    label.TextColor3 = textColor
    label.Font = font
    label.TextScaled = textScaled
    label.BackgroundTransparency = backgroundTransparency or 1
    if bgColor then label.BackgroundColor3 = bgColor end
    label.Parent = parent
    if backgroundTransparency == 0 then addAesthetics(label) end -- Only add aesthetics if not transparent
    return label
end

local function createTextBox(parent, placeholder, position, size, textColor, bgColor, font, textScaled, clearOnFocus)
    local box = Instance.new("TextBox")
    box.Size = size
    box.Position = position
    box.PlaceholderText = placeholder
    box.TextColor3 = textColor
    box.BackgroundColor3 = bgColor
    box.Font = font
    box.TextScaled = textScaled
    box.ClearTextOnFocus = clearOnFocus or false
    box.Parent = parent
    addAesthetics(box)
    return box
end

-- --- Key Frame ---
local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0, 300, 0, 180)
keyFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
keyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
keyFrame.Parent = ScreenGui
addAesthetics(keyFrame)
makeDraggable(keyFrame)

createLabel(keyFrame, "Enter Key", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 40), Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, true)
local keyBox = createTextBox(keyFrame, "Enter key here", UDim2.new(0, 10, 0, 50), UDim2.new(1, -20, 0, 40), Color3.fromRGB(255, 255, 255), Color3.fromRGB(50, 50, 50), Enum.Font.Gotham, true, false)
local submitBtn = createButton(keyFrame, "Submit", UDim2.new(0, 10, 0, 100), UDim2.new(1, -20, 0, 40), Color3.fromRGB(150, 0, 0), Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), true)
createLabel(keyFrame, "Credit: Dyumra", UDim2.new(0, 0, 0, 150), UDim2.new(1, 0, 0, 20), Color3.fromRGB(200, 200, 200), Enum.Font.Gotham, false, 1)

-- --- Main GUI Frame ---
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0, 10, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.Parent = ScreenGui
mainFrame.Visible = false
addAesthetics(mainFrame)
makeDraggable(mainFrame)

-- "TUNGHUB" Title Label - matching GUI background color and rounded
local titleLabel = createLabel(mainFrame, "TUNGHUB", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 50), Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, true, 0, Color3.fromRGB(30, 30, 30))
addAesthetics(titleLabel) -- Ensure UICorner and UIStroke are applied to the title label as well.

local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(1, 0, 0, 50)
buttonFrame.Position = UDim2.new(0, 0, 0, 50)
buttonFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
buttonFrame.Parent = mainFrame
addAesthetics(buttonFrame)

local buttonFont = Enum.Font.GothamBold
local buttonTextColor = Color3.fromRGB(255, 255, 255)
local buttonBgColor = Color3.fromRGB(50, 50, 50)

local playerBtn = createButton(buttonFrame, "Player (OFF)", UDim2.new(0, 0, 0, 0), UDim2.new(1/3, 0, 1, 0), buttonBgColor, buttonFont, buttonTextColor, true)
local itemBtn = createButton(buttonFrame, "Item (OFF)", UDim2.new(1/3, 0, 0, 0), UDim2.new(1/3, 0, 1, 0), buttonBgColor, buttonFont, buttonTextColor, true)
local miscBtn = createButton(buttonFrame, "Misc (OFF)", UDim2.new(2/3, 0, 0, 0), UDim2.new(1/3, 0, 1, 0), buttonBgColor, buttonFont, buttonTextColor, true)

local featureFrame = Instance.new("Frame")
featureFrame.Size = UDim2.new(1, 0, 1, -100)
featureFrame.Position = UDim2.new(0, 0, 0, 100)
featureFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
featureFrame.Parent = mainFrame
addAesthetics(featureFrame)

createLabel(mainFrame, "Credit: Dyumra", UDim2.new(0, 0, 1, -20), UDim2.new(1, 0, 0, 20), Color3.fromRGB(200, 200, 200), Enum.Font.Gotham, false, 1)

-- --- Hide/Show Button ---
local hideBtn = createButton(ScreenGui, "-", UDim2.new(1, -40, 0, 10), UDim2.new(0, 30, 0, 30), Color3.fromRGB(150, 0, 0), Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), true)
makeDraggable(hideBtn)
hideBtn.Visible = false -- Hidden until login

hideBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    hideBtn.Text = mainFrame.Visible and "-" or "+"
end)

-- --- Feature Logic (Mostly unchanged, but using helper functions for UI creation) ---
local function clearFeatures()
    for _, child in ipairs(featureFrame:GetChildren()) do
        if child:IsA("GuiObject") then child:Destroy() end
    end
end

-- ESP
local espEnabled = false
local espHighlights = {}

local function createHighlight(targetCharacter)
    if espHighlights[targetCharacter] then return end
    local highlight = Instance.new("Highlight")
    highlight.Adornee = targetCharacter
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
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
            if espEnabled then createHighlight(plr.Character) else removeHighlight(plr.Character) end
        end
    end
end

local function onCharacterAdded(char)
    if espEnabled then task.wait(0.1); createHighlight(char) end
end

local function onPlayerAdded(plr)
    plr.CharacterAdded:Connect(onCharacterAdded)
    if plr.Character then onCharacterAdded(plr.Character) end
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= player then onPlayerAdded(plr) end
end

-- Player Features
local speedConnection = nil
local noclipEnabled = false
local freecamEnabled = false
local freecamConnection = nil
local originalCameraType = Camera.CameraType
local originalCameraSubject = Camera.CameraSubject

local function toggleNoclip(state)
    noclipEnabled = state
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not state
            end
        end
        if state then
            -- Disable humanoid states that might interfere with noclip
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
            humanoid:ChangeState(Enum.HumanoidStateType.Seated) -- A common trick to prevent unexpected physics
            humanoid.PlatformStand = true
        else
            -- Re-enable humanoid states
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
            humanoid.PlatformStand = false
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
        StarterGui:SetCore("SendNotification", { Title = "Noclip", Text = "Noclip " .. (state and "Enabled" or "Disabled") .. ".", Duration = 2 })
    end
end

local function toggleFreecam(state)
    freecamEnabled = state
    if state then
        originalCameraType = Camera.CameraType
        originalCameraSubject = Camera.CameraSubject

        Camera.CameraType = Enum.CameraType.Scriptable
        Camera.CFrame = humanoidRootPart.CFrame

        if freecamConnection then freecamConnection:Disconnect() end
        freecamConnection = RunService.RenderStepped:Connect(function(dt)
            local moveVector = Vector3.new()
            local camSpeed = 1 -- Adjust freecam speed here

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector += Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector -= Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector -= Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector += Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.C) then moveVector -= Vector3.new(0, 1, 0) end

            Camera.CFrame += moveVector.Unit * camSpeed * dt * 60 -- Multiply by 60 for consistent speed

            UserInputService.InputChanged:Connect(function(input, gameProcessedEvent)
                if input.UserInputType == Enum.UserInputType.MouseMovement and not gameProcessedEvent then
                    local delta = input.Delta
                    local sensitivity = 0.2 -- Adjust mouse sensitivity
                    local rotX = -math.rad(delta.X * sensitivity)
                    local rotY = -math.rad(delta.Y * sensitivity)

                    Camera.CFrame *= CFrame.Angles(0, rotX, 0) -- Yaw (left/right)
                    Camera.CFrame = Camera.CFrame * CFrame.Angles(rotY, 0, 0) -- Pitch (up/down)
                end
            end)
        end)
        StarterGui:SetCore("SendNotification", { Title = "Freecam", Text = "Freecam Enabled.", Duration = 2 })
    else
        if freecamConnection then freecamConnection:Disconnect(); freecamConnection = nil end
        Camera.CameraType = originalCameraType
        Camera.CameraSubject = originalCameraSubject
        StarterGui:SetCore("SendNotification", { Title = "Freecam", Text = "Freecam Disabled.", Duration = 2 })
    end
end


local function showPlayerFeatures()
    clearFeatures()
    createLabel(featureFrame, "Set Walk Speed (CFrame)", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 40), Color3.fromRGB(255, 255, 255), Enum.Font.Gotham, true)
    local speedBox = createTextBox(featureFrame, "Enter speed (e.g., 0.5)", UDim2.new(0, 10, 0, 50), UDim2.new(1, -20, 0, 40), Color3.fromRGB(255, 255, 255), Color3.fromRGB(40, 40, 40), Enum.Font.Gotham, true)
    local enterSpeed = createButton(featureFrame, "Enter Speed", UDim2.new(0, 10, 0, 100), UDim2.new(1, -20, 0, 40), Color3.fromRGB(150, 0, 0), Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), true)

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
            StarterGui:SetCore("SendNotification", { Title = "Speed Set", Text = "Walk speed set to " .. speed .. ".", Duration = 3 })
        else
            StarterGui:SetCore("SendNotification", { Title = "Speed Error", Text = "Please enter a valid number for speed.", Duration = 3 })
        end
    end)

    local noclipBtn = createButton(featureFrame, "Toggle Noclip (OFF)", UDim2.new(0, 10, 0, 150), UDim2.new(1, -20, 0, 40), Color3.fromRGB(60, 60, 60), Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), true)
    noclipBtn.MouseButton1Click:Connect(function()
        noclipEnabled = not noclipEnabled
        toggleNoclip(noclipEnabled)
        noclipBtn.Text = "Toggle Noclip (" .. (noclipEnabled and "ON" or "OFF") .. ")"
    end)

    local freecamBtn = createButton(featureFrame, "Toggle Freecam (OFF)", UDim2.new(0, 10, 0, 200), UDim2.new(1, -20, 0, 40), Color3.fromRGB(60, 60, 60), Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), true)
    freecamBtn.MouseButton1Click:Connect(function()
        freecamEnabled = not freecamEnabled
        toggleFreecam(freecamEnabled)
        freecamBtn.Text = "Toggle Freecam (" .. (freecamEnabled and "ON" or "OFF") .. ")"
    end)
end

-- Item Features (Teleport & Item Copy)
local currentSelectedItem = nil

local function showItemFeatures()
    clearFeatures()
    createLabel(featureFrame, "Teleport to Player:", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 30), Color3.fromRGB(255, 255, 255), Enum.Font.Gotham, true)
    local tpBox = createTextBox(featureFrame, "Enter player name (partial match)", UDim2.new(0, 10, 0, 30), UDim2.new(1, -20, 0, 30), Color3.fromRGB(255, 255, 255), Color3.fromRGB(40, 40, 40), Enum.Font.Gotham, true)
    local tpBtn = createButton(featureFrame, "Teleport", UDim2.new(0, 10, 0, 65), UDim2.new(1, -20, 0, 30), Color3.fromRGB(150, 0, 0), Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), true)

    tpBtn.MouseButton1Click:Connect(function()
        local targetName = tpBox.Text:lower()
        local foundPlayer = nil
        if targetName == "" then StarterGui:SetCore("SendNotification", { Title = "Teleport Error", Text = "Please enter a player name to teleport to.", Duration = 3 }); return end

        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name:lower():find(targetName) then foundPlayer = plr; break end
        end

        if foundPlayer and foundPlayer.Character and foundPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = foundPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                StarterGui:SetCore("SendNotification", { Title = "Teleport Success", Text = "Teleported to " .. foundPlayer.Name .. "!", Duration = 3 })
            else
                StarterGui:SetCore("SendNotification", { Title = "Teleport Failed", Text = "Your character is not ready to teleport.", Duration = 3 })
            end
        else
            StarterGui:SetCore("SendNotification", { Title = "Player Not Found", Text = "Could not find player '" .. tpBox.Text .. "' or their character is not loaded.", Duration = 3 })
        end
    end)

    createLabel(featureFrame, "Copy Items from Others:", UDim2.new(0, 0, 0, 100), UDim2.new(1, 0, 0, 30), Color3.fromRGB(255, 255, 255), Enum.Font.Gotham, true)

    local itemScrollFrame = Instance.new("ScrollingFrame")
    itemScrollFrame.Size = UDim2.new(1, -20, 1, -200)
    itemScrollFrame.Position = UDim2.new(0, 10, 0, 130)
    itemScrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    itemScrollFrame.Parent = featureFrame
    addAesthetics(itemScrollFrame)

    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.FillDirection = Enum.FillDirection.Vertical
    uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uiListLayout.Padding = UDim.new(0, 5)
    uiListLayout.Parent = itemScrollFrame

    local giveBtn = createButton(featureFrame, "Give", UDim2.new(0.01, 0, 1, -50), UDim2.new(0.48, 0, 0, 40), Color3.fromRGB(150, 0, 0), Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), true)
    local giveAllBtn = createButton(featureFrame, "Give All", UDim2.new(0.51, 0, 1, -50), UDim2.new(0.48, 0, 0, 40), Color3.fromRGB(150, 0, 0), Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), true)

    local itemButtons = {} -- Store references to item buttons for selection

    local function updateItemList()
        for _, btn in pairs(itemButtons) do btn:Destroy() end
        itemButtons = {}
        currentSelectedItem = nil -- Reset selection

        local allItems = {}
        local seenNames = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Backpack then
                for _, item in pairs(plr.Backpack:GetChildren()) do
                    if (item:IsA("Tool") or item:IsA("ForceField")) and not seenNames[item.Name] then
                        table.insert(allItems, item:Clone())
                        seenNames[item.Name] = true
                    end
                end
            end
        end

        for _, item in pairs(allItems) do
            local itemBtn = createButton(itemScrollFrame, item.Name, UDim2.new(0, 0, 0, 0), UDim2.new(1, -10, 0, 30), Color3.fromRGB(50, 50, 50), Enum.Font.Gotham, Color3.fromRGB(255, 255, 255), true)
            itemBtn.MouseButton1Click:Connect(function()
                if currentSelectedItem then currentSelectedItem.BackgroundColor3 = Color3.fromRGB(50, 50, 50) end
                itemBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
                currentSelectedItem = itemBtn
            end)
            itemButtons[item.Name] = itemBtn
            item:Destroy() -- Clean up cloned item after use
        end
    end

    updateItemList()
    Players.PlayerAdded:Connect(updateItemList)
    Players.PlayerRemoving:Connect(updateItemList)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Backpack then
            plr.Backpack.ChildAdded:Connect(updateItemList)
            plr.Backpack.ChildRemoved:Connect(updateItemList)
        end
    end

    giveBtn.MouseButton1Click:Connect(function()
        if currentSelectedItem then
            local itemName = currentSelectedItem.Text
            local itemToGive = nil
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= player and plr.Backpack then
                    local found = plr.Backpack:FindFirstChild(itemName)
                    if found and (found:IsA("Tool") or found:IsA("ForceField")) then
                        itemToGive = found; break
                    end
                end
            end
            if itemToGive then
                local clonedItem = itemToGive:Clone()
                clonedItem.Parent = player.Backpack
                StarterGui:SetCore("SendNotification", { Title = "Item Acquired", Text = "You received: " .. itemName, Duration = 2 })
            else
                StarterGui:SetCore("SendNotification", { Title = "Error", Text = "Item '" .. itemName .. "' not found in any player's backpack anymore.", Duration = 3 })
            end
        else
            StarterGui:SetCore("SendNotification", { Title = "Error", Text = "Please select an item to give.", Duration = 3 })
        end
    end)

    giveAllBtn.MouseButton1Click:Connect(function()
        local itemsGiven = 0
        local allItemsToGive = {}
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
            StarterGui:SetCore("SendNotification", { Title = "Items Acquired", Text = "You received " .. itemsGiven .. " unique items!", Duration = 3 })
        else
            StarterGui:SetCore("SendNotification", { Title = "No Items", Text = "No unique items found to give.", Duration = 3 })
        end
    end)
end

-- Misc Features
local fogEnabled = false
local fbEnabled = false
local headlessEnabled = false
local walkOnWaterEnabled = false

local function toggleWalkOnWater(state)
    walkOnWaterEnabled = state
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        if state then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
            humanoid.PlatformStand = true
            humanoid.UseJumpPower = false
            humanoid.JumpPower = 0
            humanoid.WalkSpeed = 16 -- Keep original walk speed
        else
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            humanoid.PlatformStand = false
            humanoid.UseJumpPower = true
            humanoid.JumpPower = 50 -- Default jump power
            humanoid.WalkSpeed = 16 -- Default walk speed
        end
        StarterGui:SetCore("SendNotification", { Title = "Walk on Water", Text = "Walk on Water " .. (state and "Enabled" or "Disabled") .. ".", Duration = 2 })
    end
end

-- Misc Features
local fogEnabled = false
local fbEnabled = false
local headlessEnabled = false
local walkOnWaterEnabled = false

local function toggleWalkOnWater(state)
    walkOnWaterEnabled = state
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        if state then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
            humanoid.PlatformStand = true
            humanoid.UseJumpPower = false
            humanoid.JumpPower = 0
            humanoid.WalkSpeed = 16 -- Keep original walk speed
        else
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            humanoid.PlatformStand = false
            humanoid.UseJumpPower = true
            humanoid.JumpPower = 50 -- Default jump power
            humanoid.WalkSpeed = 16 -- Default walk speed
        end
        StarterGui:SetCore("SendNotification", { Title = "Walk on Water", Text = "Walk on Water " .. (state and "Enabled" or "Disabled") .. ".", Duration = 2 })
    end
end

local function toggleHeadless(state)
    headlessEnabled = state
    if character then
        local head = character:FindFirstChild("Head")
        local face = head and head:FindFirstChildOfClass("Decal") or head and head:FindFirstChildOfClass("Texture")

        if head then
            head.Transparency = state and 1 or 0
        end
        if face then
            face.Transparency = state and 1 or 0
        end
        StarterGui:SetCore("SendNotification", { Title = "Headless", Text = "Headless " .. (state and "Enabled" or "Disabled") .. ".", Duration = 2 })
    end
end

local function showMiscFeatures()
    clearFeatures()
    local noFogBtn = createButton(featureFrame, "Toggle NoFog (OFF)", UDim2.new(0, 10, 0, 10), UDim2.new(1, -20, 0, 40), Color3.fromRGB(60, 60, 60), Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), true)
    noFogBtn.MouseButton1Click:Connect(function()
        fogEnabled = not fogEnabled
        if fogEnabled then
            Lighting.FogEnd = 1000000 -- Max fog distance
            Lighting.FogStart = 0 -- Ensures no fog is visible
            noFogBtn.Text = "Toggle NoFog (ON)"
            StarterGui:SetCore("SendNotification", { Title = "NoFog Activated", Text = "Fog has been removed.", Duration = 2 })
        else
            Lighting.FogEnd = 0 -- Reset to default (or a small value)
            Lighting.FogStart = 0
            noFogBtn.Text = "Toggle NoFog (OFF)"
            StarterGui:SetCore("SendNotification", { Title = "NoFog Deactivated", Text = "Fog has been restored.", Duration = 2 })
        end
    end)

    local fbBtn = createButton(featureFrame, "Toggle FullBright (OFF)", UDim2.new(0, 10, 0, 60), UDim2.new(1, -20, 0, 40), Color3.fromRGB(60, 60, 60), Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), true)
    fbBtn.MouseButton1Click:Connect(function()
        fbEnabled = not fbEnabled
        if fbEnabled then
            Lighting.Brightness = 2
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            fbBtn.Text = "Toggle FullBright (ON)"
            StarterGui:SetCore("SendNotification", { Title = "FullBright Activated", Text = "Environment is now brighter.", Duration = 2 })
        else
            Lighting.Brightness = 1
            Lighting.Ambient = Color3.fromRGB(0, 0, 0)
            Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
            fbBtn.Text = "Toggle FullBright (OFF)"
            StarterGui:SetCore("SendNotification", { Title = "FullBright Deactivated", Text = "Environment lighting restored.", Duration = 2 })
        end
    end)

    local headlessBtn = createButton(featureFrame, "Toggle Headless (OFF)", UDim2.new(0, 10, 0, 110), UDim2.new(1, -20, 0, 40), Color3.fromRGB(60, 60, 60), Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), true)
    headlessBtn.MouseButton1Click:Connect(function()
        headlessEnabled = not headlessEnabled
        toggleHeadless(headlessEnabled)
        headlessBtn.Text = "Toggle Headless (" .. (headlessEnabled and "ON" or "OFF") .. ")"
    end)

    local walkOnWaterBtn = createButton(featureFrame, "Toggle Walk on Water (OFF)", UDim2.new(0, 10, 0, 160), UDim2.new(1, -20, 0, 40), Color3.fromRGB(60, 60, 60), Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), true)
    walkOnWaterBtn.MouseButton1Click:Connect(function()
        walkOnWaterEnabled = not walkOnWaterEnabled
        toggleWalkOnWater(walkOnWaterEnabled)
        walkOnWaterBtn.Text = "Toggle Walk on Water (" .. (walkOnWaterEnabled and "ON" or "OFF") .. ")"
    end)
end

-- --- Category Button Clicks ---
local function resetCategoryButtons(activeButton)
    playerBtn.Text = "Player (OFF)"
    itemBtn.Text = "Item (OFF)"
    miscBtn.Text = "Misc (OFF)"

    if speedConnection then speedConnection:Disconnect(); speedConnection = nil end
    toggleESP(false) -- Always disable ESP if switching categories or turning Player OFF
    toggleNoclip(false) -- Disable noclip when switching categories
    toggleFreecam(false) -- Disable freecam when switching categories
    toggleHeadless(false) -- Disable headless when switching categories
    toggleWalkOnWater(false) -- Disable walk on water when switching categories
    Lighting.FogEnd = 0 -- Reset fog
    Lighting.FogStart = 0
    Lighting.Brightness = 1 -- Reset fullbright
    Lighting.Ambient = Color3.fromRGB(0, 0, 0)
    Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
    clearFeatures()

    if activeButton then
        activeButton.Text = activeButton.Text:gsub("(OFF)", "(ON)") -- Turn on the clicked button
    end
end

playerBtn.MouseButton1Click:Connect(function()
    if playerBtn.Text:find(" (ON)") then -- Check for space before (ON)
        resetCategoryButtons(nil) -- Turn all off
    else
        resetCategoryButtons(playerBtn)
        showPlayerFeatures()
        toggleESP(true)
    end
end)

itemBtn.MouseButton1Click:Connect(function()
    if itemBtn.Text:find(" (ON)") then -- Check for space before (ON)
        resetCategoryButtons(nil)
    else
        resetCategoryButtons(itemBtn)
        showItemFeatures()
    end
end)

miscBtn.MouseButton1Click:Connect(function()
    if miscBtn.Text:find(" (ON)") then -- Check for space before (ON)
        resetCategoryButtons(nil)
    else
        resetCategoryButtons(miscBtn)
        showMiscFeatures()
    end
end)

-- --- Key Submission Logic ---
submitBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == requiredKey then
        keyFrame:Destroy()
        mainFrame.Visible = true
        hideBtn.Visible = true
        currentKeyAttempts = 0
    else
        currentKeyAttempts = currentKeyAttempts + 1
        keyBox.Text = ""
        keyBox.PlaceholderText = "Wrong key! (" .. currentKeyAttempts .. "/" .. maxKeyAttempts .. ")"
        StarterGui:SetCore("SendNotification", { Title = "Authentication Failed", Text = "Incorrect key. Attempts left: " .. (maxKeyAttempts - currentKeyAttempts), Duration = 3 })

        if currentKeyAttempts >= maxKeyAttempts then
            StarterGui:SetCore("SendNotification", { Title = "Access Denied", Text = "Banned: 100 Days (Too many failed attempts)", Duration = 5 })
            task.wait(1)
            player:Kick("Banned: 100 Days - Too many failed attempts.")
        end
    end
end)
