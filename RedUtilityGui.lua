--🔴🔧 ROBLOX GUI: Full Utility Panel (Red/White Theme)
-- Features: FullBright, NoFog, Headless, Speed CFrame, Cam Toggle, FreeCam, Persistent GUI

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "RedUtilityGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main draggable frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.BorderSizePixel = 3
frame.BackgroundTransparency = 0.1
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local UICorner = Instance.new("UICorner", frame)
UICorner.CornerRadius = UDim.new(0, 12)

-- Hide button
local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 80, 0, 30)
hideBtn.Position = UDim2.new(1, -90, 0, -35)
hideBtn.Text = "Hide GUI"
hideBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
hideBtn.TextColor3 = Color3.new(1, 1, 1)
hideBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
hideBtn.BorderSizePixel = 2
hideBtn.Draggable = true
hideBtn.Parent = gui

local frameVisible = true
hideBtn.MouseButton1Click:Connect(function()
    frameVisible = not frameVisible
    frame.Visible = frameVisible
    hideBtn.Text = frameVisible and "Hide GUI" or "Show GUI"
end)

-- Function to create toggle buttons
local function createToggleButton(text, order)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 30)
    button.Position = UDim2.new(0, 10, 0, 10 + (order - 1) * 35)
    button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    button.BorderColor3 = Color3.fromRGB(255, 255, 255)
    button.BorderSizePixel = 2
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = text
    button.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button

    return button
end

-- Full Bright
local fullbright = false
local lighting = game:GetService("Lighting")
local fbBtn = createToggleButton("Full Bright", 1)
fbBtn.MouseButton1Click:Connect(function()
    fullbright = not fullbright
    if fullbright then
        lighting.Brightness = 5
        lighting.ClockTime = 14
        lighting.FogEnd = 100000
    end
end)

-- No Fog
local nofog = false
local fogBtn = createToggleButton("No Fog", 2)
fogBtn.MouseButton1Click:Connect(function()
    nofog = not nofog
    if nofog then
        lighting.FogEnd = 100000
    end
end)

-- Headless
local headless = false
local headlessBtn = createToggleButton("Headless", 3)
headlessBtn.MouseButton1Click:Connect(function()
    headless = not headless
    local char = player.Character or player.CharacterAdded:Wait()
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 1
        local face = head:FindFirstChildOfClass("Decal")
        if face then face.Visible = false end
    end
end)

-- Cam Toggle
local cam3rd = false
local camBtn = createToggleButton("Cam: 3", 4)
camBtn.MouseButton1Click:Connect(function()
    cam3rd = not cam3rd
    local cam = workspace.CurrentCamera
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if cam and humanoid then
        if cam3rd then
            player.CameraMode = Enum.CameraMode.Classic
            humanoid.CameraOffset = Vector3.new(0, 0, 0)
            cam.CameraType = Enum.CameraType.Custom
            camBtn.Text = "Cam: 3"
        else
            player.CameraMode = Enum.CameraMode.LockFirstPerson
            camBtn.Text = "Cam: 1"
        end
    end
end)

-- Free Cam
local freeCam = false
local freeCamBtn = createToggleButton("Free Cam: Off", 5)
freeCamBtn.MouseButton1Click:Connect(function()
    freeCam = not freeCam
    if freeCam then
        player.CameraMode = Enum.CameraMode.Classic
        freeCamBtn.Text = "Free Cam: On"
    else
        player.CameraMode = Enum.CameraMode.LockFirstPerson
        freeCamBtn.Text = "Free Cam: Off"
    end
end)

-- Speed via CFrame
local speed = 0
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(1, -20, 0, 30)
speedBox.Position = UDim2.new(0, 10, 0, 10 + 5 * 35)
speedBox.PlaceholderText = "Speed Value (CFrame)"
speedBox.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
speedBox.BorderColor3 = Color3.fromRGB(255, 255, 255)
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.BorderSizePixel = 2
speedBox.ClearTextOnFocus = false
speedBox.Parent = frame
local corner = Instance.new("UICorner", speedBox)
corner.CornerRadius = UDim.new(0, 10)

local speedEnter = createToggleButton("Enter Speed", 7)
speedEnter.MouseButton1Click:Connect(function()
    local val = tonumber(speedBox.Text)
    if val then speed = val end
end)

-- Speed Movement Loop
spawn(function()
    while true do
        task.wait(0.02)
        if speed > 0 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local moveDir = player.Character:FindFirstChildOfClass("Humanoid").MoveDirection
            if moveDir.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + (moveDir * speed * 0.02)
            end
        end
    end
end)"
}
