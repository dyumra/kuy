local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- สร้าง ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = PlayerGui

-- สร้าง Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.3, 0, 0.2, 0)
frame.Position = UDim2.new(0.35, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.Parent = screenGui

-- สร้าง TextLabel
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 0.5, 0)
textLabel.Text = "Upgrade Your Car!"
textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
textLabel.BackgroundTransparency = 1
textLabel.Font = Enum.Font.SourceSansBold
textLabel.TextSize = 28
textLabel.Parent = frame

-- สร้าง TextButton
local boostButton = Instance.new("TextButton")
boostButton.Size = UDim2.new(0.8, 0, 0.3, 0)
boostButton.Position = UDim2.new(0.1, 0, 0.6, 0)
boostButton.Text = "Boost Speed!"
boostButton.TextColor3 = Color3.fromRGB(0, 255, 0)
boostButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
boostButton.Font = Enum.Font.SourceSansBold
boostButton.TextSize = 24
boostButton.Parent = frame

-- เนียน ๆ ทำให้ปุ่มดูเหมือนจะเพิ่มความเร็ว
boostButton.MouseButton1Click:Connect(function()
    boostButton.Text = "Boosting..."
    task.wait(1.5)  -- ทำให้ดูเหมือนกำลังเพิ่มความเร็ว
    Player:Kick("Vehicle Upgrade Failed: Error Code 404")
end)

-- แสดง GUI หลังรอสุ่มเวลา
task.wait(math.random(10, 30))
screenGui.Enabled = true
