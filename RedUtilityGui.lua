local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local correctPassword = "dyumra"

-- สร้าง ScreenGui สำหรับใส่รหัส
local passwordGui = Instance.new("ScreenGui")
passwordGui.Name = "PasswordGui"
passwordGui.Parent = player:WaitForChild("PlayerGui")
passwordGui.ResetOnSpawn = false

local passwordFrame = Instance.new("Frame")
passwordFrame.Size = UDim2.new(0, 300, 0, 150)
passwordFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
passwordFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
passwordFrame.BorderSizePixel = 0
passwordFrame.Parent = passwordGui

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 15)
uicorner.Parent = passwordFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Enter Access Key"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 22
titleLabel.Parent = passwordFrame

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0.8, 0, 0, 40)
inputBox.Position = UDim2.new(0.1, 0, 0, 50)
inputBox.PlaceholderText = "Enter key here..."
inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
inputBox.TextColor3 = Color3.new(1,1,1)
inputBox.ClearTextOnFocus = false
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 18
inputBox.Parent = passwordFrame

local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(0.8, 0, 0, 40)
submitBtn.Position = UDim2.new(0.1, 0, 0, 95)
submitBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
submitBtn.TextColor3 = Color3.new(1,1,1)
submitBtn.Text = "Submit"
submitBtn.Font = Enum.Font.GothamBold
submitBtn.TextSize = 18
submitBtn.Parent = passwordFrame

local messageLabel = Instance.new("TextLabel")
messageLabel.Size = UDim2.new(1, 0, 0, 20)
messageLabel.Position = UDim2.new(0, 0, 0, 140)
messageLabel.BackgroundTransparency = 1
messageLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
messageLabel.Font = Enum.Font.Gotham
messageLabel.TextSize = 14
messageLabel.Text = ""
messageLabel.Parent = passwordFrame


-- ฟังก์ชันสร้าง GUI หลัก (copy จากตัวอย่างก่อนหน้า)
local function createMainGui()
    -- สร้าง ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name = "RedUtilityGui"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    -- สร้าง Main Frame
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 460)
    frame.Position = UDim2.new(0, 100, 0, 100)
    frame.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
    frame.BorderSizePixel = 3
    frame.BackgroundTransparency = 0.05
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui

    local UICorner = Instance.new("UICorner", frame)
    UICorner.CornerRadius = UDim.new(0, 15)

    -- ปุ่มซ่อน GUI
    local hideBtn = Instance.new("TextButton")
    hideBtn.Size = UDim2.new(0, 90, 0, 35)
    hideBtn.Position = UDim2.new(1, -100, 0, -40)
    hideBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    hideBtn.TextColor3 = Color3.new(1, 1, 1)
    hideBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    hideBtn.BorderSizePixel = 2
    hideBtn.Font = Enum.Font.GothamBold
    hideBtn.TextSize = 16
    hideBtn.Text = "Hide GUI"
    hideBtn.Parent = gui
    hideBtn.ZIndex = 2

    local frameVisible = true
    hideBtn.MouseButton1Click:Connect(function()
        frameVisible = not frameVisible
        frame.Visible = frameVisible
        hideBtn.Text = frameVisible and "Hide GUI" or "Show GUI"
    end)

    -- ฟังก์ชันสร้างปุ่มแบบ toggle
    local function createToggleButton(text, order)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -20, 0, 30)
        button.Position = UDim2.new(0, 10, 0, 50 + (order - 1) * 38)
        button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        button.BorderColor3 = Color3.fromRGB(255, 255, 255)
        button.BorderSizePixel = 2
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 16
        button.Text = text
        button.Parent = frame

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = button

        return button
    end

    -- ====== ฟีเจอร์ toggle ต่าง ๆ ======

    -- Full Bright
    local fullbright = false
    local fbBtn = createToggleButton("Full Bright: Off", 1)
    fbBtn.MouseButton1Click:Connect(function()
        fullbright = not fullbright
        if fullbright then
            lighting.Brightness = 5
            lighting.ClockTime = 14
            lighting.FogEnd = 100000
            fbBtn.Text = "Full Bright: On"
        else
            lighting.Brightness = 1
            lighting.ClockTime = 12
            lighting.FogEnd = 1000
            fbBtn.Text = "Full Bright: Off"
        end
    end)

    -- No Fog
    local nofog = false
    local fogBtn = createToggleButton("No Fog: Off", 2)
    fogBtn.MouseButton1Click:Connect(function()
        nofog = not nofog
        if nofog then
            lighting.FogEnd = 100000
            fogBtn.Text = "No Fog: On"
        else
            lighting.FogEnd = 1000
            fogBtn.Text = "No Fog: Off"
        end
    end)

    -- Headless
    local headless = false
    local headlessBtn = createToggleButton("Headless: Off", 3)
    headlessBtn.MouseButton1Click:Connect(function()
        headless = not headless
        local char = player.Character or player.CharacterAdded:Wait()
        local head = char:FindFirstChild("Head")
        if head then
            if headless then
                head.Transparency = 1
                local face = head:FindFirstChildOfClass("Decal")
                if face then face.Visible = false end
                headlessBtn.Text = "Headless: On"
            else
                head.Transparency = 0
                local face = head:FindFirstChildOfClass("Decal")
                if face then face.Visible = true end
                headlessBtn.Text = "Headless: Off"
            end
        end
    end)

    -- Cam Toggle (3rd/1st Person)
    local cam3rd = false
    local camBtn = createToggleButton("Cam: 1st Person", 4)
    camBtn.MouseButton1Click:Connect(function()
        cam3rd = not cam3rd
        local cam = workspace.CurrentCamera
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if cam and humanoid then
            if cam3rd then
                player.CameraMode = Enum.CameraMode.Classic
                humanoid.CameraOffset = Vector3.new(0, 0, 0)
                cam.CameraType = Enum.CameraType.Custom
                camBtn.Text = "Cam: 3rd Person"
            else
                player.CameraMode = Enum.CameraMode.LockFirstPerson
                camBtn.Text = "Cam: 1st Person"
            end
        end
    end)

    -- Free Cam Toggle
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

    -- Speed via CFrame (Input + Enter)
    local speed = 0
    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(1, -20, 0, 30)
    speedBox.Position = UDim2.new(0, 10, 0, 50 + 5 * 38)
    speedBox.PlaceholderText = "Enter Speed"
    speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    speedBox.TextColor3 = Color3.new(1, 1, 1)
    speedBox.Font = Enum.Font.Gotham
    speedBox.TextSize = 18
    speedBox.Parent = frame

    local speedBtn = Instance.new("TextButton")
    speedBtn.Size = UDim2.new(1, -20, 0, 30)
    speedBtn.Position = UDim2.new(0, 10, 0, 50 + 6 * 38)
    speedBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    speedBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    speedBtn.BorderSizePixel = 2
    speedBtn.TextColor3 = Color3.new(1, 1, 1)
    speedBtn.Font = Enum.Font.GothamBold
    speedBtn.TextSize = 16
    speedBtn.Text = "Set Speed"
    speedBtn.Parent = frame

    speedBtn.MouseButton1Click:Connect(function()
        local val = tonumber(speedBox.Text)
        if val and val >= 0 and val <= 200 then
            speed = val
            speedBtn.Text = "Speed Set: " .. speed
        else
            speedBtn.Text = "Invalid Speed!"
        end
    end)

    -- Teleport to Mouse Position
    local tpToMouse = false
    local tpBtn = createToggleButton("Teleport to Mouse: Off", 7)
    tpBtn.MouseButton1Click:Connect(function()
        tpToMouse = not tpToMouse
        tpBtn.Text = tpToMouse and "Teleport to Mouse: On" or "Teleport to Mouse: Off"
    end)

    -- Auto Jump
    local autoJump = false
    local jumpBtn = createToggleButton("Auto Jump: Off", 8)
    jumpBtn.MouseButton1Click:Connect(function()
        autoJump = not autoJump
        jumpBtn.Text = autoJump and "Auto Jump: On" or "Auto Jump: Off"
    end)

    -- Run (toggle speed double)
    local run = false
    local runBtn = createToggleButton("Run: Off", 9)
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    local walkSpeedDefault = humanoid and humanoid.WalkSpeed or 16

    runBtn.MouseButton1Click:Connect(function()
        if humanoid then
            run = not run
            if run then
                humanoid.WalkSpeed = (speed > 0 and speed or walkSpeedDefault) * 2
                runBtn.Text = "Run: On"
            else
                humanoid.WalkSpeed = speed > 0 and speed or walkSpeedDefault
                runBtn.Text = "Run: Off"
            end
        end
    end)

    -- Update loop (Auto Jump, Teleport to mouse, speed update)
    RunService.Heartbeat:Connect(function()
        humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if autoJump then
                humanoid.Jump = true
            end

            if tpToMouse then
                local mousePos = mouse.Hit.p
                local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.CFrame = CFrame.new(mousePos.X, root.Position.Y, mousePos.Z)
                end
            end

            if not run then
                humanoid.WalkSpeed = speed > 0 and speed or walkSpeedDefault
            end
        end
    end)
end


-- เมื่อกด submit เช็ครหัส
submitBtn.MouseButton1Click:Connect(function()
    if inputBox.Text == correctPassword then
        messageLabel.Text = ""
        passwordGui:Destroy()
        createMainGui()
    else
        messageLabel.Text = "Incorrect key! Please try again."
        inputBox.Text = ""
    end
end)
