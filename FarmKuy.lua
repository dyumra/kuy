local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local isRunning = false
local collectedTouchInterests = {}

local function teleportToPart(player, part)
    local character = player.Character
    if character then
        character:SetPrimaryPartCFrame(part.CFrame)
    end
end

local function teleportToTouchInterests(player)
    for _, descendant in ipairs(workspace:GetDescendants()) do
        if not isRunning then break end
        if descendant:IsA("TouchTransmitter") and not collectedTouchInterests[descendant] then
            local parent = descendant.Parent
            if parent and parent:IsA("BasePart") then
                teleportToPart(player, parent)
                collectedTouchInterests[descendant] = true
                wait(0.1)
            end
        end
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
MainFrame.Position = UDim2.new(0.5, -60, 0.5, -30)
MainFrame.Size = UDim2.new(0, 120, 0, 80)
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

local FarmLabel = Instance.new("TextLabel")
FarmLabel.Name = "FarmLabel"
FarmLabel.Parent = MainFrame
FarmLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FarmLabel.BackgroundTransparency = 1
FarmLabel.Position = UDim2.new(0.5, 0, 0.2, 0)
FarmLabel.Size = UDim2.new(1, -10, 0, 20)
FarmLabel.Font = Enum.Font.SourceSansBold
FarmLabel.Text = "dyumra farm"
FarmLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmLabel.TextSize = 18
FarmLabel.TextScaled = true
FarmLabel.TextWrapped = true
FarmLabel.AnchorPoint = Vector2.new(0.5, 0.5)

local FarmButton = Instance.new("TextButton")
FarmButton.Name = "FarmButton"
FarmButton.Parent = MainFrame
FarmButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
FarmButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
FarmButton.BorderSizePixel = 2
FarmButton.Position = UDim2.new(0.5, 0, 0.5, 0)
FarmButton.Size = UDim2.new(1, -10, 0, 20)
FarmButton.Font = Enum.Font.SourceSansBold
FarmButton.Text = "เริ่ม"
FarmButton.TextColor3 = Color3.fromRGB(0, 0, 0)
FarmButton.TextSize = 18
FarmButton.TextScaled = true
FarmButton.TextWrapped = true
FarmButton.AnchorPoint = Vector2.new(0.5, 0.5)

FarmButton.MouseButton1Click:Connect(function()
    if not isRunning then
        isRunning = true
        FarmButton.Text = "หยุด"
        FarmButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
        collectedTouchInterests = {}
        teleportToTouchInterests(LocalPlayer)
    else
        isRunning = false
        FarmButton.Text = "เริ่ม"
        FarmButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    end
end)

local CreditLabel = Instance.new("TextLabel")
CreditLabel.Name = "CreditLabel"
CreditLabel.Parent = MainFrame
CreditLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Position = UDim2.new(0.5, 0, 0.85, 0)
CreditLabel.Size = UDim2.new(1, -10, 0, 20)
CreditLabel.Font = Enum.Font.SourceSansBold
CreditLabel.Text = "script by dyumra"
CreditLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CreditLabel.TextSize = 14
CreditLabel.TextScaled = true
CreditLabel.TextWrapped = true
CreditLabel.AnchorPoint = Vector2.new(0.5, 0.5)
