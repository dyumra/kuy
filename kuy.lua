local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function findPartsWithName(parent, partName)
    local parts = {}
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == partName and child:IsA("BasePart") then
            table.insert(parts, child)
        elseif #child:GetChildren() > 0 then
            local foundParts = findPartsWithName(child, partName)
            for _, part in ipairs(foundParts) do
                table.insert(parts, part)
            end
        end
    end
    return parts
end

local function teleportToParts(parts)
    local character = LocalPlayer.Character
    if character then
        local primaryPart = character:FindFirstChild("HumanoidRootPart")
        if primaryPart then
            for _, part in ipairs(parts) do
                primaryPart.CFrame = part.CFrame
                wait(0.5)
            end
        end
    else
        warn("Character not available!")
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -60)
MainFrame.Size = UDim2.new(0, 240, 0, 150)
MainFrame.Visible = false

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
CloseButton.BorderSizePixel = 2
CloseButton.Position = UDim2.new(1, -20, 0, 0)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Parent = ScreenGui
OpenButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
OpenButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
OpenButton.BorderSizePixel = 2
OpenButton.Position = UDim2.new(0, 10, 0, 10)
OpenButton.Size = UDim2.new(0, 20, 0, 20)
OpenButton.Font = Enum.Font.SourceSansBold
OpenButton.Text = ">"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 14

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
end)

local SigmaLabel = Instance.new("TextLabel")
SigmaLabel.Name = "SigmaLabel"
SigmaLabel.Parent = MainFrame
SigmaLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SigmaLabel.BackgroundTransparency = 1
SigmaLabel.Position = UDim2.new(0.5, 0, 0.1, 0)
SigmaLabel.Size = UDim2.new(1, -20, 0, 20)
SigmaLabel.Font = Enum.Font.SourceSansBold
SigmaLabel.Text = "dyumra sigma"
SigmaLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SigmaLabel.TextSize = 14
SigmaLabel.TextScaled = true
SigmaLabel.TextWrapped = true
SigmaLabel.AnchorPoint = Vector2.new(0.5, 0.5)

local PartNameBox = Instance.new("TextBox")
PartNameBox.Name = "PartNameBox"
PartNameBox.Parent = MainFrame
PartNameBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PartNameBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
PartNameBox.BorderSizePixel = 2
PartNameBox.Position = UDim2.new(0.5, 0, 0.3, 0)
PartNameBox.Size = UDim2.new(1, -20, 0, 30)
PartNameBox.Font = Enum.Font.SourceSans
PartNameBox.Text = ""
PartNameBox.PlaceholderText = "Enter Part Name"
PartNameBox.TextColor3 = Color3.fromRGB(0, 0, 0)
PartNameBox.TextSize = 18
PartNameBox.TextScaled = true
PartNameBox.TextWrapped = true
PartNameBox.AnchorPoint = Vector2.new(0.5, 0.5)

local TeleportButton = Instance.new("TextButton")
TeleportButton.Name = "TeleportButton"
TeleportButton.Parent = MainFrame
TeleportButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
TeleportButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TeleportButton.BorderSizePixel = 2
TeleportButton.Position = UDim2.new(0.5, 0, 0.7, 0)
TeleportButton.Size = UDim2.new(1, -20, 0, 30)
TeleportButton.Font = Enum.Font.SourceSansBold
TeleportButton.Text = "Teleport"
TeleportButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TeleportButton.TextSize = 18
TeleportButton.TextScaled = true
TeleportButton.TextWrapped = true
TeleportButton.AnchorPoint = Vector2.new(0.5, 0.5)

local StopTeleportButton = Instance.new("TextButton")
StopTeleportButton.Name = "StopTeleportButton"
StopTeleportButton.Parent = MainFrame
StopTeleportButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
StopTeleportButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
StopTeleportButton.BorderSizePixel = 2
StopTeleportButton.Position = UDim2.new(0.5, 0, 0.7, 0)
StopTeleportButton.Size = UDim2.new(1, -20, 0, 30)
StopTeleportButton.Font = Enum.Font.SourceSansBold
StopTeleportButton.Text = "Stop Teleport"
StopTeleportButton.TextColor3 = Color3.fromRGB(0, 0, 0)
StopTeleportButton.TextSize = 18
StopTeleportButton.TextScaled = true
StopTeleportButton.TextWrapped = true
StopTeleportButton.AnchorPoint = Vector2.new(0.5, 0.5)
StopTeleportButton.Visible = false

local isTeleporting = false

TeleportButton.MouseButton1Click:Connect(function()
    local partName = PartNameBox.Text
    if partName ~= "" then
        local parts = findPartsWithName(workspace, partName)
        if #parts > 0 then
            isTeleporting = true
            teleportToParts(parts)
            TeleportButton.Visible = false
            StopTeleportButton.Visible = true
        else
            warn("No parts found with the name: " .. partName)
        end
    else
        warn("Please enter a valid Part name!")
    end
end)

StopTeleportButton.MouseButton1Click:Connect(function()
    isTeleporting = false
    TeleportButton.Visible = true
    StopTeleportButton.Visible = false
end)

local CreditLabel = Instance.new("TextLabel")
CreditLabel.Name = "CreditLabel"
CreditLabel.Parent = MainFrame
CreditLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Position = UDim2.new(0.5, 0, 0.95, 0)
CreditLabel.Size = UDim2.new(1, -10, 0, 20)
CreditLabel.Font = Enum.Font.SourceSansBold
CreditLabel.Text = "script by dyumra"
CreditLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CreditLabel.TextSize = 14
CreditLabel.TextScaled = true
CreditLabel.TextWrapped = true
CreditLabel.AnchorPoint = Vector2.new(0.5, 0.5)

local HowLabel = Instance.new("TextLabel")
HowLabel.Name = "HowLabel"
HowLabel.Parent = MainFrame
HowLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HowLabel.BackgroundTransparency = 1
HowLabel.Position = UDim2.new(0.5, 0, 0.48, 0)
HowLabel.Size = UDim2.new(1, -10, 0, 20)
HowLabel.Font = Enum.Font.SourceSansBold
HowLabel.Text = "ใช้คู่ dex เพื่อดูชื่อ part"
HowLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HowLabel.TextSize = 14
HowLabel.TextScaled = true
HowLabel.TextWrapped = true
HowLabel.AnchorPoint = Vector2.new(0.5, 0.5)
