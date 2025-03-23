local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "HitboxToggleGui"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.Parent = ScreenGui

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 180, 0, 50)
ToggleButton.Position = UDim2.new(0.5, -90, 0.5, -25)
ToggleButton.Text = "Hitbox: OFF"
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Parent = Frame

local CreditLabel = Instance.new("TextLabel")
CreditLabel.Size = UDim2.new(0, 400, 0, 100)
CreditLabel.Position = UDim2.new(0.5, -200, 0.1, 0)
CreditLabel.Text = "By dyumra"
CreditLabel.TextSize = 50
CreditLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Transparency = 0.8
CreditLabel.Parent = ScreenGui

local isHitboxEnabled = false
local originalSizes = {}
local originalTransparencies = {}

local function modifyHead(player, sizeMultiplier)
    if player.Character and player.Character:FindFirstChild("Head") then
        local head = player.Character.Head
        if not originalSizes[player] then
            originalSizes[player] = head.Size
            originalTransparencies[player] = head.Transparency
        end
        
        if sizeMultiplier > 1 then
            head.Size = originalSizes[player] * sizeMultiplier
            head.Transparency = 0.5
            if head:FindFirstChild("Mesh") then
                head.Mesh.Scale = Vector3.new(sizeMultiplier, sizeMultiplier, sizeMultiplier)
            end
        else
            head.Size = originalSizes[player]
            head.Transparency = originalTransparencies[player]
            if head:FindFirstChild("Mesh") then
                head.Mesh.Scale = Vector3.new(1, 1, 1)
            end
        end
    end
end

local function updateAllHeads()
    local sizeMultiplier = isHitboxEnabled and 5 or 1
    for _, player in pairs(Players:GetPlayers()) do
        modifyHead(player, sizeMultiplier)
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    isHitboxEnabled = not isHitboxEnabled
    ToggleButton.Text = "Hitbox: " .. (isHitboxEnabled and "ON" or "OFF")
    ToggleButton.BackgroundColor3 = isHitboxEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    updateAllHeads()
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if isHitboxEnabled then
            modifyHead(player, 5)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    originalSizes[player] = nil
    originalTransparencies[player] = nil
end)

RunService.Heartbeat:Connect(function()
    if isHitboxEnabled then
        updateAllHeads()
    end
end)
