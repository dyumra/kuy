repeat task.wait() until game:IsLoaded()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualInput = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")

local function KeepEsp(Char, Parent)
    if Char then
        local highlight = Char:FindFirstChildOfClass("Highlight")
        if highlight then
            highlight:Destroy()
        end
    end
    if Parent then
        local billboard = Parent:FindFirstChildOfClass("BillboardGui")
        if billboard then
            billboard:Destroy()
        end
    end
end

local function CreateEsp(Char, Color, Text, Parent, numberOffset)
    if not Char or not Char:IsA("Model") then return end
    if not Char:FindFirstChild("HumanoidRootPart") then return end
    if not Parent or not Parent:IsA("BasePart") then return end

    KeepEsp(Char, Parent)

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = Char
    highlight.FillColor = Color
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = true
    highlight.Parent = Char

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Size = UDim2.new(0, 50, 0, 25)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, numberOffset or 3, 0)
    billboard.Adornee = Parent
    billboard.Enabled = true
    billboard.Parent = Parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = Text
    label.TextColor3 = Color
    label.TextScaled = true
    label.Parent = billboard

    task.spawn(function()
        while highlight and billboard and Parent and Parent.Parent do
            local cameraPosition = Camera and Camera.CFrame.Position
            if cameraPosition and Parent:IsA("BasePart") then
                local distance = (cameraPosition - Parent.Position).Magnitude
                if ActiveDistanceEsp then
                    label.Text = Text .. " (" .. math.floor(distance + 0.5) .. " stud)"
                else
                    label.Text = Text
                end
            end
            RunService.Heartbeat:Wait()
        end
    end)
end

local function bringItemsByName(name)
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, item in ipairs(workspace.Items:GetChildren()) do
        if item.Name:lower():find(name:lower()) then
            local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item)
            if part then
                part.CFrame = root.CFrame + Vector3.new(0, 3, 0) + root.CFrame.LookVector * 5
            end
        end
    end
end


local Confirmed = false
WindUI:Popup({
    Title = "DYHUB Loaded! - 99 Night in the Forest",
    Icon = "star",
    IconThemed = true,
    Content = "DYHUB'S TEAM | Join our (dsc.gg/dyhub)",
    Buttons = {
        { Title = "Cancel", Variant = "Secondary", Callback = function() end },
        { Title = "Continue", Icon = "arrow-right", Callback = function() Confirmed = true end, Variant = "Primary" }
    }
})
repeat task.wait() until Confirmed

local Window = WindUI:CreateWindow({
    Folder = "DYHUB Config | 99NitF | V5",
    Title = "DYHUB - 99 Night in the Forest @ In-game (Beta)",
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Size = UDim2.fromOffset(520, 300),
    Transparent = true,
    Theme = "Dark",
})

Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

local Tabs = {
    Main = Window:Tab({ Title = "Main", Icon = "rocket" }),
    Teleport = Window:Tab({ Title = "Teleport", Icon = "map-pin" }),
    Player = Window:Tab({ Title = "Player", Icon = "user" }),
    Esp = Window:Tab({ Title = "Esp", Icon = "eye" }),
    Auto = Window:Tab({ Title = "Auto", Icon = "crown" }),
    Teleport = Window:Tab({ Title = "Teleport", Icon = "zap" }),
    Bring = Window:Tab({ Title = "Bring All", Icon = "atom" }),
    BringGeneral = Window:Tab({ Title = "General", Icon = "badge-plus" }),
    BringWeapon = Window:Tab({ Title = "Weapon", Icon = "swords" }),
    BringItem = Window:Tab({ Title = "Items", Icon = "package" }),
    BringFood = Window:Tab({ Title = "Food", Icon = "apple" }),
    Hitbox = Window:Tab({ Title = "Hitbox", Icon = "target" }),
    Misc = Window:Tab({ Title = "Misc", Icon = "file-cog" }),
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local TeleportList = {}  -- List of items to teleport to

local selectedTeleportItem = nil -- Default selection is none

-- Function to update TeleportList from workspace.Items
local function updateTeleportList()
    TeleportList = {}
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item:IsA("Model") or item:IsA("BasePart") then
            table.insert(TeleportList, item.Name)
        end
    end
end

-- Initial update
updateTeleportList()

-- Create Dropdown to select teleport item
Tabs.Teleport:Dropdown({
    Title = "Select Teleport Item",  -- Dropdown title
    Values = TeleportList,
    Multi = false,
    Callback = function(value)
        selectedTeleportItem = value
        print("[DYHUB] Selected Teleport Item:", value)
    end,
})

-- Update Dropdown values every 3 seconds (if your UI library supports it)
task.spawn(function()
    while true do
        updateTeleportList()
        if Tabs.Auto and Tabs.Auto.UpdateValues then
            Tabs.Auto:UpdateValues("Select Teleport Item", TeleportList)
        end
        task.wait(3)
    end
end)

-- Button to teleport player to selected item
Tabs.Teleport:Button({
    Title = "Teleport to Selected Item",
    Callback = function()
        if not selectedTeleportItem then
            print("[DYHUB] Please select an item to teleport to first.")
            return
        end

        for _, item in pairs(workspace.Items:GetChildren()) do
            if item.Name == selectedTeleportItem then
                local part = item:FindFirstChildWhichIsA("BasePart") or item
                if part then
                    local character = LocalPlayer.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        character.HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 3, 0)
                        print("[DYHUB] Teleported to", selectedTeleportItem)
                        break
                    else
                        print("[DYHUB] Character not found.")
                    end
                end
            end
        end
    end
})

getgenv().Lowhp = false
getgenv().AutoCampAtNight = false

Tabs.Auto:Toggle({
    Title = "Auto to Campfire (Low HP)",
    Default = false,
    Callback = function(state)
        getgenv().Lowhp = state
        if state then
            task.spawn(function()
                local campPosition = Vector3.new(0, 8, 0)
                while getgenv().Lowhp do
                    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if humanoid and hrp then
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        local distance = (hrp.Position - campPosition).Magnitude

                        if healthPercent <= 0.4 and distance > 33 then
                            -- ถ้าเลือดต่ำกว่า 40% และอยู่ไกล camp เกิน 33 stud ให้วาร์ปกลับ
                            hrp.CFrame = CFrame.new(campPosition)
                            task.wait(3)  -- รอ 3 วิ ก่อนเช็คใหม่
                        else
                            -- กรณีอื่นๆ รอเช็คใหม่
                            task.wait(1)
                        end
                    else
                        task.wait(1)
                    end
                end
            end)
        end
    end
})


Tabs.Auto:Toggle({
    Title = "Auto to Campfire (At Night - Once per Night)",
    Default = false,
    Callback = function(state)
        getgenv().AutoCampAtNight = state
        if state then
            task.spawn(function()
                local didTeleportTonight = false
                while getgenv().AutoCampAtNight do
                    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    local lighting = game:GetService("Lighting")

                    if hrp and lighting then
                        local hour = tonumber(string.split(lighting.TimeOfDay, ":")[1])
                        if hour then
                            if not didTeleportTonight and hour >= 0 and hour < 5 then
                                hrp.CFrame = CFrame.new(Vector3.new(0, 8, 0))
                                didTeleportTonight = true
                            end
                            if hour >= 5 then
                                didTeleportTonight = false
                            end
                        end
                    end

                    task.wait(1)
                end
            end)
        end
    end
})

local autoBreakActive = false
local autoBreakSpeed = 1
local autoBreakThread

Tabs.Main:Slider({
    Title = "Auto Hit Speed",
    Value = {Min = 0.1, Max = 2, Default = 0.5},
    Step = 1,
    Callback = function(val)
        autoBreakSpeed = val
    end
})

Tabs.Main:Toggle({
    Title = "Auto Hit (Mobile/PC)",
    Default = false,
    Callback = function(state)
        autoBreakActive = state
        if state then
            autoBreakThread = task.spawn(function()
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart")

                while autoBreakActive do
                    -- ฟังก์ชันเช็คอาวุธใน Inventory
                    local function getWeapon()
                        local inv = player:FindFirstChild("Inventory")
                        if not inv then return nil end
                        return inv:FindFirstChild("Spear")
                            or inv:FindFirstChild("Strong Axe")
                            or inv:FindFirstChild("Good Axe")
                            or inv:FindFirstChild("Old Axe")
                    end

                    local weapon = getWeapon()
                    if weapon then
                        -- ใช้ HumanoidRootPart แทน Camera สำหรับมือถือและ PC
                        local direction = hrp.CFrame.LookVector
                        local origin = hrp.Position
                        local raycastParams = RaycastParams.new()
                        raycastParams.FilterDescendantsInstances = {character}
                        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

                        local ray = workspace:Raycast(origin, direction * 15, raycastParams)
                        if ray and ray.Instance and ray.Instance.Name == "Trunk" then
                            game:GetService("ReplicatedStorage").RemoteEvents.ToolDamageObject:InvokeServer(
                                ray.Instance.Parent,
                                weapon,
                                "4_7591937906",
                                CFrame.new(ray.Position)
                            )
                        end
                    end

                    task.wait(autoBreakSpeed)
                end
            end)
        else
            if autoBreakThread then
                task.cancel(autoBreakThread)
                autoBreakThread = nil
            end
        end
    end
})

-- ฟังก์ชันแจ้งเตือน (ตัวอย่าง)
local function createNotif(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 2
    })
end

-- ตัวแปรหลัก
local autoTreeFarmActive = false
local autoFarmEnabled = false
local originalPosition
local clickConnection

-- Services
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- ตัวแปร Click
local lastClickTime = 0
local clickDelay = 0.3

-- ฟังก์ชันจำลองการกดปุ่ม Sprint
local function simulateClick()
    if not autoFarmEnabled then return end
    local currentTime = tick()
    if currentTime - lastClickTime < clickDelay then return end

    local camera = workspace.CurrentCamera
    local viewportSize = camera.ViewportSize
    local clickX = viewportSize.X - 10
    local clickY = viewportSize.Y * 0.75

    VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
    VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)

    lastClickTime = currentTime
end

-- ย้ายตัวละครขึ้นไปลอยแล้ว Anchor
local function teleportToAirAndAnchor()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        originalPosition = character.HumanoidRootPart.CFrame
        local airPosition = character.HumanoidRootPart.Position + Vector3.new(0, 350, 0)
        character.HumanoidRootPart.CFrame = CFrame.new(airPosition)
        task.wait(0.5)
        character.HumanoidRootPart.Anchored = true
        createNotif("AutoFarmLogs", "Please don't do anything or touch", 2)
        return true
    end
    return false
end

-- ปลด Anchor และพากลับตำแหน่งเดิม
local function unanchorPlayer()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.Anchored = false
        if originalPosition then
            character.HumanoidRootPart.CFrame = originalPosition
        end
        createNotif("AutoFarmLogs", "AutoFarm Done", 2)
    end
end

-- เทเลพอร์ตต้นไม้
local function teleportAllTreesToPlayer()
    local character = player.Character
    if not (character and character:FindFirstChild("HumanoidRootPart")) then
        createNotif("AutoFarmLogs", "Player character not found!", 3)
        return false
    end

    local playerPos = character.HumanoidRootPart.Position
    local treesFound = 0
    if not workspace:FindFirstChild("Map") then
        createNotif("AutoFarmLogs", "You're not in the game!", 3)
        return false
    end

    local function teleportTreesFromFolder(folder, folderName)
        if not folder then return 0 end
        local count = 0
        for _, item in pairs(folder:GetChildren()) do
            local isSmallTree = false
            if item.Name == "Small Tree" and item:IsA("Model") then
                isSmallTree = true
            elseif item:IsA("Model") then
                local hasLeaves = item:FindFirstChild("Leaves") ~= nil
                local hasTrunk = item:FindFirstChild("Trunk") ~= nil or item:FindFirstChild("trunk") ~= nil
                local hasWood = item:FindFirstChild("Wood") ~= nil
                if (hasLeaves or hasWood) and not hasTrunk then
                    isSmallTree = true
                end
            end

            if isSmallTree then
                count += 1
                local targetPosition = Vector3.new(
                    playerPos.X + math.random(-3, 3),
                    playerPos.Y - 5,
                    playerPos.Z + math.random(-3, 3)
                )
                pcall(function()
                    if item.PrimaryPart then
                        item:SetPrimaryPartCFrame(CFrame.new(targetPosition))
                    else
                        local mainPart = item:FindFirstChildOfClass("BasePart")
                        if mainPart then
                            local offset = targetPosition - mainPart.Position
                            for _, part in pairs(item:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CFrame = part.CFrame + offset
                                end
                            end
                        end
                    end
                end)
                task.wait(0.05)
            end
        end
        if count > 0 then
            createNotif("AutoFarmLogs", "Wait! " .. count .. " " .. folderName, 1)
        end
        return count
    end

    if workspace.Map:FindFirstChild("Landmarks") then
        treesFound += teleportTreesFromFolder(workspace.Map.Landmarks, "Landmarks")
    end
    if workspace.Map:FindFirstChild("Foliage") then
        treesFound += teleportTreesFromFolder(workspace.Map.Foliage, "Foliage")
    end

    createNotif("AutoFarmLogs", "AutoFarm Start " .. treesFound .. " Equip your Axe", 3)
    return treesFound > 0
end

-- เทเลพอร์ต Logs
local function teleportAllLogsToPlayer()
    createNotif("AutoFarmLogs", "Wait.", 2)
    local character = player.Character
    if not (character and character:FindFirstChild("HumanoidRootPart")) then
        createNotif("AutoFarmLogs", "Player not found!", 3)
        return false
    end

    local playerPos = character.HumanoidRootPart.Position
    local logsFound = 0
    if not workspace:FindFirstChild("Items") then
        createNotif("AutoFarmLogs", "You're not in the game?", 3)
        return false
    end

    for _, item in pairs(workspace.Items:GetChildren()) do
        if item:FindFirstChild("Meshes/log_Cylinder") then
            logsFound += 1
            local logPosition = Vector3.new(
                playerPos.X + math.random(-4, 4),
                playerPos.Y + 1,
                playerPos.Z + math.random(-4, 4)
            )
            pcall(function()
                if item.PrimaryPart then
                    item:SetPrimaryPartCFrame(CFrame.new(logPosition))
                else
                    local mainPart = item:FindFirstChildOfClass("BasePart")
                    if mainPart then
                        local offset = logPosition - mainPart.Position
                        for _, part in pairs(item:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.CFrame = part.CFrame + offset
                            end
                        end
                    end
                end
            end)
            task.wait(0.03)
        end
    end

    createNotif("AutoFarmLogs", "Collected " .. logsFound .. " Logs from AutoLogFarm", 3)
    return logsFound > 0
end

-- Toggle หลัก
Tabs.Main:Toggle({
    Title = "Auto Tree-Farm (Mobile/PC)",
    Default = false,
    Callback = function(state)
        autoTreeFarmActive = state
        autoFarmEnabled = state

        if state then
            createNotif("AutoFarmLogs", "AutoFarm Started", 2)
            if teleportToAirAndAnchor() then
                task.wait(1)
                if teleportAllTreesToPlayer() then
                    task.wait(2)
                    clickConnection = RunService.Heartbeat:Connect(simulateClick)
                end
            end
        else
            createNotif("AutoFarmLogs", "AutoFarm Stopped!", 2)
            if clickConnection then
                clickConnection:Disconnect()
                clickConnection = nil
            end
            unanchorPlayer()
            task.spawn(function()
                task.wait(0.5)
                teleportAllLogsToPlayer()
            end)
        end
    end
})


local infHungerActive = false
local infHungerThread

Tabs.Main:Toggle({
    Title = "Inf Hunger (In Development)",
    Default = false,
    Callback = function(state)
        infHungerActive = state
        if state then
            infHungerThread = task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local RequestConsumeItem = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestConsumeItem")
                while infHungerActive do
                    local args = {
                        Instance.new("Model", nil)
                    }
                    RequestConsumeItem:InvokeServer(unpack(args))
                    task.wait(1)
                end
            end)
        else
            if infHungerThread then
                task.cancel(infHungerThread)
                infHungerThread = nil
            end
        end
    end
})

local RemoteEvents = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents")
local RequestStartDraggingItem = RemoteEvents:FindFirstChild("RequestStartDraggingItem")
local StopDraggingItem = RemoteEvents:FindFirstChild("StopDraggingItem")

Tabs.Main:Button({
    Title = "Auto Cooked (Fixed)",
    Callback = function()
        local campfirePos = Vector3.new(1.87, 4.33, -3.67)
        for _, item in pairs(workspace.Items:GetChildren()) do
            if item:IsA("Model") or item:IsA("BasePart") then
                local name = item.Name:lower()
                if name:find("steak") or name:find("morsel") then
                    local part = item:FindFirstChildWhichIsA("BasePart") or item
                    if part then
                        -- เริ่มดึง
                        if RequestStartDraggingItem then
                            RequestStartDraggingItem:FireServer(part)
                        end

                        task.wait(0.1) -- เว้นให้เซิร์ฟเวอร์รับข้อมูล

                        -- หยุดดึง (วาง)
                        if StopDraggingItem then
                            StopDraggingItem:FireServer(part)
                        end

                        -- ย้ายไปที่กองไฟ
                        part.CFrame = CFrame.new(
                            campfirePos + Vector3.new(math.random(-2, 2), 0.5, math.random(-2, 2))
                        )
                    end
                end
            end
        end
    end
})

Tabs.Main:Button({
    Title = "Auto Fuel-Campfire (Log)",
    Callback = function()
        local campfirePos = Vector3.new(1.87, 4.33, -3.67)

        for _, item in pairs(workspace.Items:GetChildren()) do
            if item:IsA("Model") or item:IsA("BasePart") then
                local name = item.Name:lower()
                if name:find("log") then
                    local part = item:FindFirstChildWhichIsA("BasePart") or item
                    if part then
                        RequestStartDraggingItem:FireServer(part)
                        task.wait(0.1)
                        StopDraggingItem:FireServer(part)
                        part.CFrame = CFrame.new(
                            campfirePos + Vector3.new(math.random(-2, 2), 0.5, math.random(-2, 2))
                        )
                    end
                end
            end
        end
    end
})

-- Auto Fuel-Campfire (Coal)
Tabs.Main:Button({
    Title = "Auto Fuel-Campfire (Coal)",
    Callback = function()
        local campfirePos = Vector3.new(1.87, 4.33, -3.67)
        for _, item in pairs(workspace.Items:GetChildren()) do
            if item:IsA("Model") or item:IsA("BasePart") then
                local name = item.Name:lower()
                if name:find("coal") then
                    local part = item:FindFirstChildWhichIsA("BasePart") or item
                    if part then
                        RequestStartDraggingItem:FireServer(part)
                        task.wait(0.1)
                        StopDraggingItem:FireServer(part)
                        part.CFrame = CFrame.new(
                            campfirePos + Vector3.new(math.random(-2, 2), 0.5, math.random(-2, 2))
                        )
                    end
                end
            end
        end
    end
})

-- Auto Fuel-Campfire (Fuel Canister)
Tabs.Main:Button({
    Title = "Auto Fuel-Campfire (Fuel Canister)",
    Callback = function()
        local campfirePos = Vector3.new(1.87, 4.33, -3.67)
        for _, item in pairs(workspace.Items:GetChildren()) do
            if item:IsA("Model") or item:IsA("BasePart") then
                local name = item.Name:lower()
                if name:find("fuel canister") then
                    local part = item:FindFirstChildWhichIsA("BasePart") or item
                    if part then
                        RequestStartDraggingItem:FireServer(part)
                        task.wait(0.1)
                        StopDraggingItem:FireServer(part)
                        part.CFrame = CFrame.new(
                            campfirePos + Vector3.new(math.random(-2, 2), 0.5, math.random(-2, 2))
                        )
                    end
                end
            end
        end
    end
})

-- ========= Auto Tab
local FuelList = {  
    "Log", "Coal", "Oil Barrel", "Fuel Canister", "Biofuel"
}

local selectedFuel = FuelList[1] -- ค่าเริ่มต้น

Tabs.Auto:Dropdown({
    Title = "Select Fuel", 
    Values = FuelList, 
    Multi = false, -- ถ้าต้องการให้เลือกทีละอัน ปรับเป็น false
    Callback = function(value)
        selectedFuel = value
        print("[DYHUB] Selected Fuel:", value)
    end,
})

Tabs.Auto:Button({
    Title = "Auto Fuel-Campfire",
    Callback = function()
        local campfirePos = Vector3.new(1.87, 4.33, -3.67)
        local lowerSelectedFuel = selectedFuel:lower()

        for _, item in pairs(workspace.Items:GetChildren()) do
            if item:IsA("Model") or item:IsA("BasePart") then
                local name = item.Name:lower()
                -- เช็คว่าชื่อไอเท็มมีคำที่ตรงกับ fuel ที่เลือกหรือไม่
                if name:find(lowerSelectedFuel) then
                    local part = item:FindFirstChildWhichIsA("BasePart") or item
                    if part then
                        -- ดึง
                        RequestStartDraggingItem:FireServer(part)
                        task.wait(0.1)
                        -- วาง
                        StopDraggingItem:FireServer(part)
                        -- ย้ายไปกองไฟ
                        part.CFrame = CFrame.new(
                            campfirePos + Vector3.new(math.random(-2, 2), 0.5, math.random(-2, 2))
                        )
                    end
                end
            end
        end
    end
})

local WorkbrechList = { 
    "tyre", "Old Car Engine", "Washing Machine", "UFO Component", "Cultist Prototype", 
    "sheet metal", "broken fan", "bolt", "old radio", "ufo junk", "ufo scrap", "broken microwave"
}

local selectedWorkbrech = WorkbrechList[1] -- ค่าเริ่มต้น

Tabs.Auto:Dropdown({
    Title = "Select Workbrech", 
    Values = WorkbrechList, 
    Multi = true,
    Callback = function(value)
        selectedWorkbrech = value
        print("[DYHUB] Selected Workbrech:", value)
    end,
})

Tabs.Auto:Button({
    Title = "Auto Workbrech", 
    Callback = function()
        local workbrechPos = CFrame.new(
            20.5397816, 6.25331163, -4.86815262,
            -0.0290346798, 8.43757775e-09, -0.999578416,
            3.91288673e-08, 1, 7.30456273e-09,
            0.999578416, -3.89002821e-08, -0.0290346798
        )
        local lowerSelectedWorkbrech = selectedWorkbrech:lower()

        for _, item in pairs(workspace.Items:GetChildren()) do
            if item:IsA("Model") or item:IsA("BasePart") then
                local name = item.Name:lower()
                if name:find(lowerSelectedWorkbrech) then
                    local part = item:FindFirstChildWhichIsA("BasePart") or item
                    if part then
                        -- ดึงไอเท็ม
                        RequestStartDraggingItem:FireServer(part)
                        task.wait(0.1)
                        -- วางไอเท็ม
                        StopDraggingItem:FireServer(part)
                        -- ย้ายไปที่ Workbench
                        part.CFrame = workbrechPos * CFrame.new(math.random(-2, 2), 0.5, math.random(-2, 2))
                    end
                end
            end
        end
    end
})

-- ========= Esp Tab
local ActiveEspPlayer = false

local ActiveEspItems = false
local ActiveEspEnemy = false
local ActiveEspChildren = false
local ActiveEspPeltTrader = false
local ActiveDistanceEsp = false

Tabs.Esp:Toggle({
    Title = "Esp (Player)",
    Default = false,
    Callback = function(state)
        ActiveEspPlayer = state
        task.spawn(function()
            while ActiveEspPlayer do
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local char = player.Character
                        if not char:FindFirstChildOfClass("Highlight") and not char.HumanoidRootPart:FindFirstChildOfClass("BillboardGui") then
                            CreateEsp(char, Color3.fromRGB(0, 255, 0), player.Name, char.HumanoidRootPart, 2)
                        end
                    end
                end
                task.wait(0.1)
            end
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local char = player.Character
                    KeepEsp(char, char.HumanoidRootPart)
                end
            end
        end)
    end
})

Tabs.Esp:Toggle({
    Title = "Esp (All, Scan Map - first)",
    Default = false,
    Callback = function(state)
        ActiveEspItems = state
        task.spawn(function()
            while ActiveEspItems do
                for _, Obj in pairs(game.Workspace.Items:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and not Obj:FindFirstChildOfClass("Highlight") and not Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                        CreateEsp(Obj, Color3.fromRGB(255, 255, 0), Obj.Name, Obj.PrimaryPart, 2)
                    end
                end
                task.wait(0.1)
            end
            for _, Obj in pairs(game.Workspace.Items:GetChildren()) do
                KeepEsp(Obj, Obj.PrimaryPart)
            end
        end)
    end
})

Tabs.Esp:Toggle({
    Title = "Esp (Tools)",
    Default = false,
    Callback = function(state)
        ActiveEspEnemy = state
        task.spawn(function()
            while ActiveEspEnemy do
                for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and (Obj.Name ~= "Medkit" and Obj.Name ~= "Bandage" and Obj.Name ~= "Alien Armor" and Obj.Name ~= "Riot Shield" and Obj.Name ~= "Leather Body" and Obj.Name ~= "Iron Body" and Obj.Name ~= "Thorn Body" and Obj.Name ~= "Strong Flashlight" and Obj.Name ~= "Old Flashlight" and Obj.Name ~= "Old Sack" and Obj.Name ~= "Good Sack" and Obj.Name ~= "Giant Sack" and Obj.Name ~= "Morningstar" and Obj.Name ~= "Spear" and Obj.Name ~= "Katana" and Obj.Name ~= "Laser Sword" and Obj.Name ~= "Revolver" and Obj.Name ~= "Rifle" and Obj.Name ~= "Laser Sword" and Obj.Name ~= "Tactical Shotgun" and Obj.Name ~= "Kunai" and Obj.Name ~= "Ray Gun" and Obj.Name ~= "Laser Cannon" and Obj.Name ~= "Revolver Ammo" and Obj.Name ~= "Rifle Ammo" and Obj.Name ~= "Shotgun Ammo") and not Obj:FindFirstChildOfClass("Highlight") and not Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                        CreateEsp(Obj, Color3.fromRGB(0, 100, 255), Obj.Name, Obj.PrimaryPart, 2)
                    end
                end
                task.wait(0.1)
            end
            for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                KeepEsp(Obj, Obj.PrimaryPart)
            end
        end)
    end
})

Tabs.Esp:Toggle({
    Title = "Esp (Food)",
    Default = false,
    Callback = function(state)
        ActiveEspEnemy = state
        task.spawn(function()
            while ActiveEspEnemy do
                for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and (Obj.Name ~= "Berry" and Obj.Name ~= "Carrot" and Obj.Name ~= "Apple" and Obj.Name ~= "Morsel" and Obj.Name ~= "Steak" and Obj.Name ~= "Cake" and Obj.Name ~= "Chili" and Obj.Name ~= "Hearty Stew" and Obj.Name ~= "Meat? Sandwich") and not Obj:FindFirstChildOfClass("Highlight") and not Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                        CreateEsp(Obj, Color3.fromRGB(0, 100, 255), Obj.Name, Obj.PrimaryPart, 2)
                    end
                end
                task.wait(0.1)
            end
            for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                KeepEsp(Obj, Obj.PrimaryPart)
            end
        end)
    end
})

Tabs.Esp:Toggle({
    Title = "Esp (Enemies)",
    Default = false,
    Callback = function(state)
        ActiveEspEnemy = state
        task.spawn(function()
            while ActiveEspEnemy do
                for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and (Obj.Name:find("Alien") or Obj.Name:find("Alien Elite") or Obj.Name:find("Bear") or Obj.Name:find("Polar Bear") or Obj.Name:find("Wolf") or Obj.Name:find("Alpha Wolf") or Obj.Name:find("Alpha") or Obj.Name:find("Bunny") or Obj.Name:find("Dragon") or Obj.Name:find("Cultist") or Obj.Name:find("Cross") or Obj.Name:find("Crossbow Cultist")) and not Obj:FindFirstChildOfClass("Highlight") and not Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                        CreateEsp(Obj, Color3.fromRGB(255, 0, 0), Obj.Name, Obj.PrimaryPart, 2)
                    end
                end
                task.wait(0.1)
            end
            for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                KeepEsp(Obj, Obj.PrimaryPart)
            end
        end)
    end
})
Tabs.Esp:Toggle({
    Title = "Esp (Children)",
    Default = false,
    Callback = function(state)
        ActiveEspChildren = state
        task.spawn(function()
            while ActiveEspChildren do
                for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and (Obj.Name == "Lost Child" or Obj.Name == "Lost Child2" or Obj.Name == "Lost Child3" or Obj.Name == "Lost Child4") and not Obj:FindFirstChildOfClass("Highlight") and not Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                        CreateEsp(Obj, Color3.fromRGB(0, 255, 0), Obj.Name, Obj.PrimaryPart, 2)
                    end
                end
                task.wait(0.1)
            end
            for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                KeepEsp(Obj, Obj.PrimaryPart)
            end
        end)
    end
})

Tabs.Esp:Toggle({
    Title = "Esp (Pelt Trader)",
    Default = false,
    Callback = function(state)
        ActiveEspPeltTrader = state
        task.spawn(function()
            while ActiveEspPeltTrader do
                for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and Obj.Name == "Pelt Trader" and not Obj:FindFirstChildOfClass("Highlight") and not Obj:FindFirstChildOfClass("BillboardGui") then
                        CreateEsp(Obj, Color3.fromRGB(0, 255, 255), Obj.Name, Obj.PrimaryPart, 2)
                    end
                end
                task.wait(0.1)
            end
            for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                KeepEsp(Obj, Obj.PrimaryPart)
            end
        end)
    end
})

-----------------------------------------------------------------
-- TELEPORT TAB
-----------------------------------------------------------------
Tabs.Teleport:Toggle({
    Title = "Scan Map (Essential)",
    Default = false,
    Callback = function(state)
        getgenv().scan_map = state

        task.spawn(function()
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart", 3)
            if not hrp then return end

            local map = workspace:FindFirstChild("Map")
            if not map then return end

            local foliage = map:FindFirstChild("Foliage") or map:FindFirstChild("Landmarks")
            if not foliage then return end

            while getgenv().scan_map do
                local trees = {}
                for _, obj in ipairs(foliage:GetChildren()) do
                    if obj.Name == "Small Tree" and obj:IsA("Model") then
                        local trunk = obj:FindFirstChild("Trunk") or obj.PrimaryPart
                        if trunk then
                            table.insert(trees, trunk)
                        end
                    end
                end

                for _, trunk in ipairs(trees) do
                    if not getgenv().scan_map then break end
                    if trunk and trunk.Parent then
                        local treeCFrame = trunk.CFrame
                        local rightVector = treeCFrame.RightVector
                        local targetPosition = treeCFrame.Position + rightVector * 69
                        hrp.CFrame = CFrame.new(targetPosition)
                        task.wait(0.01)
                    end
                end
            end
        end)
    end
})

Tabs.Teleport:Button({
    Title="TP to Campfire",
    Callback=function()
        local pos = Vector3.new(0, 8, -0)
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(pos)
    end
})
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

Tabs.Teleport:Button({
    Title = "TP to Safe Zone",
    Callback = function()
        if not workspace:FindFirstChild("SafeZonePart") then
            local createpart = Instance.new("Part")
            createpart.Name = "SafeZonePart"
            createpart.Size = Vector3.new(100, 100, 100)
            createpart.Position = Vector3.new(0, 109, 0)
            createpart.Anchored = true
            createpart.CanCollide = false
            createpart.Transparency = 0.8
            createpart.Color = Color3.fromRGB(255, 255, 255)
            createpart.Parent = workspace
        end
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(0, 110, 0)
    end
})
Tabs.Teleport:Button({
    Title="TP to NPC Trader",
    Callback=function()
        local pos = Vector3.new(-37.08, 3.98, -16.33)
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(pos)
    end
})

Tabs.Teleport:Button({
    Title = "TP to Small Tree",
    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart", 3)
        if not hrp then return end

        local map = workspace:FindFirstChild("Map")
        if not map then return end

        local foliage = map:FindFirstChild("Foliage") or map:FindFirstChild("Landmarks")
        if not foliage then return end

        local trees = {}
        for _, obj in ipairs(foliage:GetChildren()) do
            if obj.Name == "Small Tree" and obj:IsA("Model") then
                local trunk = obj:FindFirstChild("Trunk") or obj.PrimaryPart
                if trunk then
                    table.insert(trees, trunk)
                end
            end
        end

        if #trees > 0 then
            local trunk = trees[math.random(1, #trees)]
            local treeCFrame = trunk.CFrame
            local rightVector = treeCFrame.RightVector
            local targetPosition = treeCFrame.Position + rightVector * 3
            hrp.CFrame = CFrame.new(targetPosition)
        end
    end
})

local lostChildNames = {
    "Lost Child",
    "Lost Child2",
    "Lost Child3",
    "Lost Child4"
}

for i, name in ipairs(lostChildNames) do
    Tabs.Teleport:Button({
        Title = "TP to Lost Child " .. i,
        Callback = function()
            local workspaceCharacters = game.Workspace.Characters
            local targetLostChild = workspaceCharacters:FindFirstChild(name)

            if targetLostChild and targetLostChild:IsA("Model") and targetLostChild.PrimaryPart then
                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart")
                hrp.CFrame = targetLostChild.PrimaryPart.CFrame
            else
                warn(name .. " not found in Characters or has no PrimaryPart")
            end
        end
    })
end

local Other = {
    "Item Chest",
    "Item Chest2",
    "Item Chest3",
    "Item Chest4",
    "Item Chest5",
    "Item Chest6"
}

for i, name in ipairs(Other) do
    Tabs.Teleport:Button({
        Title = "TP to Chest" .. i,
        Callback = function()
            local workspaceCharacters = game.Workspace.Items
            local targetLostChild = workspaceCharacters:FindFirstChild(name)

            if targetLostChild and targetLostChild:IsA("Model") and targetLostChild.PrimaryPart then
                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart")
                hrp.CFrame = targetLostChild.PrimaryPart.CFrame
            else
                warn(name .. " not found in Characters or has no PrimaryPart")
            end
        end
    })
end

local Other = {
    "Alien Chest"
}

for i, name in ipairs(Other) do
    Tabs.Teleport:Button({
        Title = "TP to Alien Chest" .. i,
        Callback = function()
            local workspaceCharacters = game.Workspace.Items
            local targetLostChild = workspaceCharacters:FindFirstChild(name)

            if targetLostChild and targetLostChild:IsA("Model") and targetLostChild.PrimaryPart then
                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart")
                hrp.CFrame = targetLostChild.PrimaryPart.CFrame
            else
                warn(name .. " not found in Characters or has no PrimaryPart")
            end
        end
    })
end

-----------------------------------------------------------------
-- BRING TAB
-----------------------------------------------------------------
Tabs.Bring:Button({
    Title = "Bring Everything (Up Size)",
    Callback = function()
        local blockedName = "berry"  -- ชื่อไอเท็มที่ไม่ให้ดึง (lowercase)
        for _, item in ipairs(workspace.Items:GetChildren()) do
            local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item)
            if part then
                local name = item.Name:lower()
                if name ~= blockedName then
                    -- ดึงไอเท็ม
                    RequestStartDraggingItem:FireServer(part)
                    task.wait(0.1)
                    -- วางไอเท็ม
                    StopDraggingItem:FireServer(part)
                    -- ย้ายไอเท็มมาใกล้ตัวผู้เล่น (สุ่มระยะ +/-25)
                    part.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(math.random(-25,25), 0, math.random(-25,25))
                end
            end
        end
    end
})

Tabs.Bring:Button({Title="Bring Logs All", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item.Name:lower():find("log") and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                RequestStartDraggingItem:FireServer(main)
                task.wait(0.1)
                StopDraggingItem:FireServer(main)
                main.CFrame = root.CFrame * CFrame.new(math.random(-15,15), 0, math.random(-15,15))
            end
        end
    end
end})

Tabs.Bring:Button({Title="Bring Pelts/Foot All", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, item in pairs(workspace.Items:GetChildren()) do
        local name = item.Name:lower()
        if (name:find("bunny foot") or name:find("wolf pelt") or name:find("alpha wolf pelt") or name:find("bear pelt")) and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                RequestStartDraggingItem:FireServer(main)
                task.wait(0.1)
                StopDraggingItem:FireServer(main)
                main.CFrame = root.CFrame * CFrame.new(math.random(-15,15), 0, math.random(-15,15))
            end
        end
    end
end})

Tabs.Bring:Button({Title="Bring Fuel All", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, item in pairs(workspace.Items:GetChildren()) do
        local name = item.Name:lower()
        if (name:find("fuel canister") or name:find("oil barrel") or name:find("coal") or name:find("biofuel")) and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                RequestStartDraggingItem:FireServer(main)
                task.wait(0.1)
                StopDraggingItem:FireServer(main)
                main.CFrame = root.CFrame * CFrame.new(math.random(-15,15), 0, math.random(-15,15))
            end
        end
    end
end})

Tabs.Bring:Button({ Title = "Bring Scrap All", Callback = function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local scrapNames = {
        ["tyre"] = true, ["old car engine"] = true, ["washing machine"] = true, ["metal chair"] = true, ["ufo component"] = true, ["cultist prototype"] = true, ["sheet metal"] = true, ["broken fan"] = true, ["bolt"] = true, ["old radio"] = true, ["ufo junk"] = true, ["ufo scrap"] = true, ["broken microwave"] = true,
    }
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item:IsA("Model") then
            local itemName = item.Name:lower()
            for scrapName in pairs(scrapNames) do
                if itemName:find(scrapName) then
                    local main = item:FindFirstChildWhichIsA("BasePart")
                    if main then
                        RequestStartDraggingItem:FireServer(main)
                        task.wait(0.1)
                        StopDraggingItem:FireServer(main)
                        main.CFrame = root.CFrame * CFrame.new(math.random(-15,15), 0, math.random(-15,15))
                    end
                    break
                end
            end
        end
    end
end })

Tabs.Bring:Button({Title="Bring Food All", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, item in pairs(workspace.Items:GetChildren()) do
        local name = item.Name:lower()
        if (name:find("steak") or name:find("sandwich") or name:find("morsel") or name:find("cake") or name:find("carrot") or name:find("pumpkin") or name:find("corn") or name:find("cooked") or name:find("berry") or name:find("apple") or name:find("stew") or name:find("hearty stew")) and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                RequestStartDraggingItem:FireServer(main)
                task.wait(0.1)
                StopDraggingItem:FireServer(main)
                main.CFrame = root.CFrame * CFrame.new(math.random(-15,15), 0, math.random(-15,15))
            end
        end
    end
end})

Tabs.Bring:Button({Title="Bring Armor All", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, item in pairs(workspace.Items:GetChildren()) do
        local name = item.Name:lower()
        if (name:find("riot shield") or name:find("alien armor") or name:find("thorn body") or name:find("iron body") or name:find("leather body")) and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                RequestStartDraggingItem:FireServer(main)
                task.wait(0.1)
                StopDraggingItem:FireServer(main)
                main.CFrame = root.CFrame * CFrame.new(math.random(-15,15), 0, math.random(-15,15))
            end
        end
    end
end})

Tabs.Bring:Button({Title="Bring Pelts/Foot All", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, item in pairs(workspace.Items:GetChildren()) do
        local name = item.Name:lower()
        if (name:find("bunny foot") or name:find("wolf pelt") or name:find("alpha wolf pelt") or name:find("bear pelt")) and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                RequestStartDraggingItem:FireServer(main)
                task.wait(0.1)
                StopDraggingItem:FireServer(main)
                main.CFrame = root.CFrame * CFrame.new(math.random(-25,25), 0, math.random(-25,25))
            end
        end
    end
end})

Tabs.Bring:Button({Title="Bring Materials All", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, item in pairs(workspace.Items:GetChildren()) do
        local name = item.Name:lower()
        if (name:find("scrap") or name:find("cultist gem") or name:find("mossy coin")) and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                RequestStartDraggingItem:FireServer(main)
                task.wait(0.1)
                StopDraggingItem:FireServer(main)
                main.CFrame = root.CFrame * CFrame.new(math.random(-25,25), 0, math.random(-25,25))
            end
        end
    end
end})

Tabs.Bring:Button({Title="Bring Healing All", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, item in pairs(workspace.Items:GetChildren()) do
        local name = item.Name:lower()
        if (name:find("medkit") or name:find("bandage")) and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                RequestStartDraggingItem:FireServer(main)
                task.wait(0.1)
                StopDraggingItem:FireServer(main)
                main.CFrame = root.CFrame * CFrame.new(math.random(-15,15), 0, math.random(-15,15))
            end
        end
    end
end})

Tabs.Bring:Button({Title="Bring Lost Children All", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, item in pairs(workspace.Characters:GetChildren()) do
        local name = item.Name:lower()
        if (name:find("lost child") or name:find("lost child2") or name:find("lost child3") or name:find("lost child4")) and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                RequestStartDraggingItem:FireServer(main)
                task.wait(0.1)
                StopDraggingItem:FireServer(main)
                main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
            end
        end
    end
end})

Tabs.Bring:Button({
    Title = "Bring Chest All (Beta)",
    Callback = function()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end

        for _, item in pairs(workspace.Items:GetChildren()) do
            local name = item.Name:lower()
            if item:IsA("Model") and (
                name:find("item chest") or
                name:find("alien chest") or
                name:find("item chest2") or
                name:find("item chest3") or
                name:find("item chest4") or
                name:find("item chest5") or
                name:find("item chest6") or
                name:find("chest") or
                name:find("stronghold diamond chest") or
                name:find("iron chest") or
                name:find("legendary chest") or
                name:find("gold chest") or
                name:find("diamond chest") or
                name:find("ice chest") or
                name:find("cold chest")
            ) then
                -- ตรวจสอบว่ามี PrimaryPart หรือไม่
                if item.PrimaryPart then
                    -- ย้ายทั้ง model โดยย้าย PrimaryPart ไปยังตำแหน่งใกล้ผู้เล่น
                    item:SetPrimaryPartCFrame(root.CFrame * CFrame.new(math.random(-10,10), 0, math.random(-10,10)))
                else
                    -- ถ้าไม่มี PrimaryPart ให้พยายามตั้ง PrimaryPart เป็น BasePart ตัวแรก
                    local basePart = item:FindFirstChildWhichIsA("BasePart")
                    if basePart then
                        item.PrimaryPart = basePart
                        item:SetPrimaryPartCFrame(root.CFrame * CFrame.new(math.random(-10,10), 0, math.random(-10,10)))
                    end
                end
            end
        end
    end
})


-- Weapon
Tabs.BringWeapon:Button({Title="Bring Morningstar", Callback=function() bringItemsByName("Morningstar") end})
Tabs.BringWeapon:Button({Title="Bring Laser Sword", Callback=function() bringItemsByName("Laser Sword") end})
Tabs.BringWeapon:Button({Title="Bring Katana", Callback=function() bringItemsByName("Katana") end})
Tabs.BringWeapon:Button({Title="Bring Spear", Callback=function() bringItemsByName("Spear") end})
Tabs.BringWeapon:Button({Title="Bring Tactical Shotgun", Callback=function() bringItemsByName("Tactical Shotgun") end})
Tabs.BringWeapon:Button({Title="Bring Kunai", Callback=function() bringItemsByName("Kunai") end})
Tabs.BringWeapon:Button({Title="Bring Revolver", Callback=function() bringItemsByName("Revolver") end})
Tabs.BringWeapon:Button({Title="Bring Rifle", Callback=function() bringItemsByName("Rifle") end})
Tabs.BringWeapon:Button({Title="Bring Alien Raygun", Callback=function() bringItemsByName("Ray Gun") end})
Tabs.BringWeapon:Button({Title="Bring Alien Raycannon", Callback=function() bringItemsByName("Laser Cannon") end})
Tabs.BringWeapon:Button({Title="Bring Strong Axe", Callback=function() bringItemsByName("Strong Axe") end})
Tabs.BringWeapon:Button({Title="Bring Good Axe", Callback=function() bringItemsByName("Good Axe") end})
Tabs.BringWeapon:Button({Title="Bring Old Axe", Callback=function() bringItemsByName("Old Axe") end})
Tabs.BringWeapon:Button({Title="Bring Rifle Ammo", Callback=function() bringItemsByName("Rifle Ammo") end})
Tabs.BringWeapon:Button({Title="Bring Revolver Ammo", Callback=function() bringItemsByName("Revolver Ammo") end})
Tabs.BringWeapon:Button({Title="Bring Shotgun Ammo", Callback=function() bringItemsByName("Revolver Ammo") end})
Tabs.BringWeapon:Button({Title="Bring Leather Body", Callback=function() bringItemsByName("Leather Body") end})
Tabs.BringWeapon:Button({Title="Bring Iron Body", Callback=function() bringItemsByName("Iron Body") end})
Tabs.BringWeapon:Button({Title="Bring Thorn Body", Callback=function() bringItemsByName("Thorn Body") end})
Tabs.BringWeapon:Button({Title="Bring Alien Armor", Callback=function() bringItemsByName("Alien Armor") end})
Tabs.BringWeapon:Button({Title="Bring Riot Shield", Callback=function() bringItemsByName("Riot Shield") end})

-- Food
Tabs.BringFood:Button({Title="Bring Steak", Callback=function() bringItemsByName("Steak") end})
Tabs.BringFood:Button({Title="Bring Apple", Callback=function() bringItemsByName("Apple") end})
Tabs.BringFood:Button({Title="Bring Berry", Callback=function() bringItemsByName("Berry") end})
Tabs.BringFood:Button({Title="Bring Hearty Stew", Callback=function() bringItemsByName("Hearty Stew") end})
Tabs.BringFood:Button({Title="Bring Stew", Callback=function() bringItemsByName("Stew") end})
Tabs.BringFood:Button({Title="Bring Chili", Callback=function() bringItemsByName("Chili") end})
Tabs.BringFood:Button({Title="Bring Pumpkin", Callback=function() bringItemsByName("Pumpkin") end})
Tabs.BringFood:Button({Title="Bring Corn", Callback=function() bringItemsByName("Corn") end})
Tabs.BringFood:Button({Title="Bring Carrot", Callback=function() bringItemsByName("Carrot") end})
Tabs.BringFood:Button({Title="Bring Cake", Callback=function() bringItemsByName("Cake") end})
Tabs.BringFood:Button({Title="Bring Morsel", Callback=function() bringItemsByName("Morsel") end})
Tabs.BringFood:Button({Title="Bring Meat? Sandwich", Callback=function() bringItemsByName("Meat? Sandwich") end})

-- Item
Tabs.BringItem:Button({Title="Bring Rope", Callback=function() bringItemsByName("Rope") end})
Tabs.BringItem:Button({Title="Bring Scrap", Callback=function() bringItemsByName("Scrap") end})
Tabs.BringItem:Button({Title="Bring Wood", Callback=function() bringItemsByName("Wood") end})
Tabs.BringItem:Button({Title="Bring Rock", Callback=function() bringItemsByName("Rock") end})
Tabs.BringItem:Button({Title="Bring Bolt", Callback=function() bringItemsByName("Bolt") end})
Tabs.BringItem:Button({Title="Bring Sheet Metal", Callback=function() bringItemsByName("Sheet Metal") end})
Tabs.BringItem:Button({Title="Bring Cloth", Callback=function() bringItemsByName("Cloth") end})
Tabs.BringItem:Button({Title="Bring Tyre", Callback=function() bringItemsByName("Tyre") end})
Tabs.BringItem:Button({Title="Bring Nails", Callback=function() bringItemsByName("Nails") end})
Tabs.BringItem:Button({Title="Bring Stone Pickaxe", Callback=function() bringItemsByName("Stone Pickaxe") end})
Tabs.BringItem:Button({Title="Bring Fan", Callback=function() bringItemsByName("Fan") end})
Tabs.BringItem:Button({Title="Bring Broken Fan", Callback=function() bringItemsByName("Broken Fan") end})
Tabs.BringItem:Button({Title="Bring Broken Microwave", Callback=function() bringItemsByName("Broken Microwave") end})
Tabs.BringItem:Button({Title="Bring UFO Junk", Callback=function() bringItemsByName("UFO Junk") end})
Tabs.BringItem:Button({Title="Bring UFO Scrap", Callback=function() bringItemsByName("UFO Scrap") end})
Tabs.BringItem:Button({Title="Bring Seed Box", Callback=function() bringItemsByName("Seed Box") end})
Tabs.BringItem:Button({Title="Bring Coin Stack", Callback=function() bringItemsByName("Coin Stack") end})
Tabs.BringItem:Button({Title="Bring Old Radio", Callback=function() bringItemsByName("Old Radio") end})
Tabs.BringItem:Button({Title="Bring Chair", Callback=function() bringItemsByName("Chair") end})

-- General
Tabs.BringGeneral:Button({Title="Bring Chili Seeds", Callback=function() bringItemsByName("Chili Seeds") end})
Tabs.BringGeneral:Button({Title="Bring Firefly Seeds", Callback=function() bringItemsByName("Firefly Seeds") end})
Tabs.BringGeneral:Button({Title="Bring Berry Seeds", Callback=function() bringItemsByName("Berry Seeds") end})
Tabs.BringGeneral:Button({Title="Bring Flower Seeds", Callback=function() bringItemsByName("Flower Seeds") end})
Tabs.BringGeneral:Button({Title="Bring Old Sack", Callback=function() bringItemsByName("Old Sack") end})
Tabs.BringGeneral:Button({Title="Bring Good Sack", Callback=function() bringItemsByName("Good Sack") end})
Tabs.BringGeneral:Button({Title="Bring Giant Sack", Callback=function() bringItemsByName("Giant Sack") end})
Tabs.BringGeneral:Button({Title="Bring Flashlight", Callback=function() bringItemsByName("Flashlight") end})
Tabs.BringGeneral:Button({Title="Bring Strong Flashlight", Callback=function() bringItemsByName("Strong Flashlight") end})
Tabs.BringGeneral:Button({Title="Bring Bandage", Callback=function() bringItemsByName("Bandage") end})
Tabs.BringGeneral:Button({Title="Bring MedKit", Callback=function() bringItemsByName("MedKit") end})
Tabs.BringGeneral:Button({Title="Bring Saplings", Callback=function() bringItemsByName("Saplings") end})
Tabs.BringGeneral:Button({Title="Bring Stakes", Callback=function() bringItemsByName("Stakes") end})
Tabs.BringGeneral:Button({Title="Bring Wolf Pelts", Callback=function() bringItemsByName("Wolf Pelts") end})
Tabs.BringGeneral:Button({Title="Bring Bear Pelts", Callback=function() bringItemsByName("Bear Pelts") end})

local hitboxSettings = {All=false, Alien=false, Wolf=false, Bunny=false, Cultist=false, Bear=false, Show=false, Size=10}

local function updateHitboxForModel(model)
    local root = model:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local name = model.Name:lower()
    local shouldResize =
        (hitboxSettings.All and (name:find("alien") or name:find("alien elite") or name:find("bear") or name:find("polar bear") or name:find("wolf") or name:find("alpha") or name:find("bunny") or name:find("dragon") or name:find("cultist") or name:find("cross") or name:find("crossbow cultist"))) or
        (hitboxSettings.Alien and (name:find("alien") or name:find("alien elite"))) or
        (hitboxSettings.Wolf and (name:find("wolf") or name:find("alpha"))) or
        (hitboxSettings.Bunny and name:find("bunny")) or
        (hitboxSettings.Bear and (name:find("bear") or name:find("polar bear"))) or
        (hitboxSettings.Cultist and (name:find("cultist") or name:find("cross") or name:find("crossbow cultist"))) -- <--- ตรงนี้ได้ลบ 'or' ที่เกินออกแล้ว
    if shouldResize then
        root.Size = Vector3.new(hitboxSettings.Size, hitboxSettings.Size, hitboxSettings.Size)
        root.Transparency = hitboxSettings.Show and 0.8 or 1
        root.Color = Color3.fromRGB(255, 0, 0)
        root.Material = Enum.Material.Neon
        root.CanCollide = false
    end
end

task.spawn(function()
    while true do
        for _, model in ipairs(workspace:GetDescendants()) do
            if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") then
                updateHitboxForModel(model)
            end
        end
        task.wait(2)
    end
end)

Tabs.Hitbox:Slider({Title="Hitbox Size", Value={Min=2, Max=200, Default=10}, Step=1, Callback=function(val) hitboxSettings.Size=val end})
Tabs.Hitbox:Toggle({Title="Show Hitbox", Default=false, Callback=function(val) hitboxSettings.Show=val end})
Tabs.Hitbox:Toggle({Title="Expand All Hitbox", Default=false, Callback=function(val) hitboxSettings.All=val end})
Tabs.Hitbox:Toggle({Title="Expand Alien Hitbox", Default=false, Callback=function(val) hitboxSettings.Alien=val end})
Tabs.Hitbox:Toggle({Title="Expand Bear Hitbox", Default=false, Callback=function(val) hitboxSettings.Bear=val end})
Tabs.Hitbox:Toggle({Title="Expand Wolf Hitbox", Default=false, Callback=function(val) hitboxSettings.Wolf=val end})
Tabs.Hitbox:Toggle({Title="Expand Bunny Hitbox", Default=false, Callback=function(val) hitboxSettings.Bunny=val end})
Tabs.Hitbox:Toggle({Title="Expand Cultist Hitbox", Default=false, Callback=function(val) hitboxSettings.Cultist=val end})

getgenv().speedEnabled = false
getgenv().speedValue = 20
Tabs.Player:Toggle({
    Title = "Enable Speed",
    Default = false,
    Callback = function(v)
        getgenv().speedEnabled = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = v and getgenv().speedValue or 16 end
    end
})
Tabs.Player:Slider({
    Title = "Set Speed Value",
    Value = {Min = 16, Max = 600, Default = 20},
    Step = 1,
    Callback = function(val)
        getgenv().speedValue = val
        if getgenv().speedEnabled then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = val end
        end
    end
})

getgenv().jumpEnabled = false
getgenv().jumpValue = 50
Tabs.Player:Toggle({
    Title = "Enable JumpPower",
    Default = false,
    Callback = function(v)
        getgenv().jumpEnabled = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.JumpPower = v and getgenv().jumpValue or 16 end
    end
})
Tabs.Player:Slider({
    Title = "Set Jump Value",
    Value = {Min = 10, Max = 600, Default = 50},
    Step = 1,
    Callback = function(val)
        getgenv().jumpValue = val
        if getgenv().jumpEnabled then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.JumpPower = val end
        end
    end
})

Tabs.Player:Button({
    Title = "No Cooldown (Open Chest)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/DYHUB-Universal-Game/refs/heads/main/nodelay.lua"))()
    end
})


Tabs.Player:Button({
    Title = "Fly (Beta)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/dyumrascript-/refs/heads/main/Flua"))()
    end
})

local noclipConnection

Tabs.Player:Toggle({
    Title = "No Clip",
    Default = false,
    Callback = function(state)
        if state then
            noclipConnection = RunService.Stepped:Connect(function()
                local Character = LocalPlayer.Character
                if Character then
                    for _, part in pairs(Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            local Character = LocalPlayer.Character
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

Tabs.Player:Toggle({
    Title = "Infinity Jump",
    Default = false,
    Callback = function(state)
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            if state then
                Humanoid.JumpPower = math.huge
                -- Using Jump state for continuous jumping
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                -- Connect to keep jumping while state is active and humanoid exists
                local jumpConnection = Humanoid.StateChanged:Connect(function(oldState, newState)
                    if newState == Enum.HumanoidStateType.Landed and Humanoid.JumpPower == math.huge then
                        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
                -- Store connection to disconnect later
                Humanoid:SetAttribute("InfinityJumpConnection", jumpConnection)
            else
                Humanoid.JumpPower = 50 -- Default jump power
                local jumpConnection = Humanoid:GetAttribute("InfinityJumpConnection")
                if jumpConnection then
                    jumpConnection:Disconnect()
                    Humanoid:SetAttribute("InfinityJumpConnection", nil)
                end
            end
        end
    end
})

Tabs.Player:Toggle({
    Title = "No Cooldown (Good Axe Only)",
    Default = false,
    Callback = function(state)
        -- This functionality seems tied to BreakJointsOnDeath, which isn't typical for cooldowns.
        -- If this is meant to disable weapon cooldown, it would require a different approach,
        -- likely by invoking the remote event for weapon usage repeatedly.
        -- For now, keeping the original behavior for BreakJointsOnDeath as it was.
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.BreakJointsOnDeath = not state
        end
    end
})

Tabs.Player:Toggle({
    Title = "God mode (Beta)",
    Default = false,
    Callback = function(state)
        -- God mode typically involves setting Humanoid.Health to math.huge or constantly healing.
        -- The current implementation uses BreakJointsOnDeath which is not god mode.
        -- Leaving the original behavior for now, but noting it's not a true god mode.
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.BreakJointsOnDeath = not state
        end
    end
})

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local oldAmbient = Lighting.Ambient
local oldBrightness = Lighting.Brightness
local oldClockTime = Lighting.ClockTime

local fullBrightConnection

Tabs.Misc:Toggle({
    Title = "FullBright",
    Default = false,
    Callback = function(state)
        if state then
            -- เปิด FullBright
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.Brightness = 10
            Lighting.ClockTime = 14

            -- เริ่มตรวจสอบตลอดเวลา
            fullBrightConnection = RunService.RenderStepped:Connect(function()
                if Lighting.ClockTime ~= 14 then
                    Lighting.ClockTime = 14
                end
                if Lighting.Brightness ~= 10 then
                    Lighting.Brightness = 10
                end
                if Lighting.Ambient ~= Color3.new(1, 1, 1) then
                    Lighting.Ambient = Color3.new(1, 1, 1)
                end
            end)
        else
            -- ปิด FullBright และหยุดตรวจสอบ
            if fullBrightConnection then
                fullBrightConnection:Disconnect()
                fullBrightConnection = nil
            end

            Lighting.Ambient = oldAmbient
            Lighting.Brightness = oldBrightness
            Lighting.ClockTime = oldClockTime
        end
    end
})

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local oldFogStart = Lighting.FogStart
local oldFogEnd = Lighting.FogEnd
local oldFogColor = Lighting.FogColor

local noFogConnection

Tabs.Misc:Toggle({
    Title = "No Fog",
    Default = false,
    Callback = function(state)
        if state then
            -- ปิดหมอก
            Lighting.FogStart = 0
            Lighting.FogEnd = 1e10
            Lighting.FogColor = Color3.fromRGB(255, 255, 255)

            -- ตรวจสอบตลอดว่าไม่มีใครเปลี่ยน
            noFogConnection = RunService.RenderStepped:Connect(function()
                if Lighting.FogStart ~= 0 then
                    Lighting.FogStart = 0
                end
                if Lighting.FogEnd ~= 1e10 then
                    Lighting.FogEnd = 1e10
                end
                if Lighting.FogColor ~= Color3.fromRGB(255, 255, 255) then
                    Lighting.FogColor = Color3.fromRGB(255, 255, 255)
                end
            end)
        else
            -- ปิด toggle และคืนค่าหมอกเดิม
            if noFogConnection then
                noFogConnection:Disconnect()
                noFogConnection = nil
            end
            Lighting.FogStart = oldFogStart
            Lighting.FogEnd = oldFogEnd
            Lighting.FogColor = oldFogColor
        end
    end
})

local Lighting = game:GetService("Lighting")

-- สร้าง ColorCorrectionEffect แค่ครั้งเดียว
local vibrantEffect = Lighting:FindFirstChild("VibrantEffect") or Instance.new("ColorCorrectionEffect")
vibrantEffect.Name = "VibrantEffect"
vibrantEffect.Saturation = 1.5      -- สด 200%
vibrantEffect.Contrast = 0.4        -- เพิ่มคอนทราสต์
vibrantEffect.Brightness = 0.1      -- เพิ่มความสว่างเล็กน้อย
vibrantEffect.Enabled = false
vibrantEffect.Parent = Lighting

Tabs.Misc:Toggle({
    Title = "Vibrant Colors 200%",
    Default = false,
    Callback = function(state)
        if state then
            -- เปิดโหมดสีสด
            Lighting.Ambient = Color3.fromRGB(180, 180, 180)
            Lighting.OutdoorAmbient = Color3.fromRGB(170, 170, 170)
            Lighting.ColorShift_Top = Color3.fromRGB(255, 230, 200)
            Lighting.ColorShift_Bottom = Color3.fromRGB(200, 240, 255)
            vibrantEffect.Enabled = true
        else
            -- ปิดโหมด กลับค่าดั้งเดิม
            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            Lighting.ColorShift_Top = Color3.new(0, 0, 0)
            Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
            vibrantEffect.Enabled = false
        end
    end
})

Tabs.Misc:Button({
    Title = "FPS Boost",
    Callback = function()
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            local lighting = game:GetService("Lighting")
            lighting.Brightness = 0
            lighting.FogEnd = 100
            lighting.GlobalShadows = false
            lighting.EnvironmentDiffuseScale = 0
            lighting.EnvironmentSpecularScale = 0
            lighting.ClockTime = 14
            lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end
            for _, obj in ipairs(lighting:GetDescendants()) do
                if obj:IsA("PostEffect") or obj:IsA("BloomEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") or obj:IsA("BlurEffect") then
                    obj.Enabled = false
                end
            end
            for _, obj in ipairs(game:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                    obj.Enabled = false
                elseif obj:IsA("Texture") or obj:IsA("Decal") then
                    obj.Transparency = 1
                end
            end
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CastShadow = false
                end
            end
        end)
        print("✅ FPS Boost Applied")
    end
})

local showFPS, showPing = true, true
local fpsText, msText = Drawing.new("Text"), Drawing.new("Text")
fpsText.Size, fpsText.Position, fpsText.Color, fpsText.Center, fpsText.Outline, fpsText.Visible =
    16, Vector2.new(Camera.ViewportSize.X-100, 10), Color3.fromRGB(0,255,0), false, true, showFPS
msText.Size, msText.Position, msText.Color, msText.Center, msText.Outline, msText.Visible =
    16, Vector2.new(Camera.ViewportSize.X-100, 30), Color3.fromRGB(0,255,0), false, true, showPing
local fpsCounter, fpsLastUpdate = 0, tick()

RunService.RenderStepped:Connect(function()
    fpsCounter += 1
    if tick() - fpsLastUpdate >= 1 then
        if showFPS then
            fpsText.Text = "FPS: " .. tostring(fpsCounter)
            fpsText.Visible = true
        else
            fpsText.Visible = false
        end
        if showPing then
            local pingStat = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
            local ping = pingStat and math.floor(pingStat:GetValue()) or 0
            msText.Text = "Ping: " .. ping .. " ms"
            if ping <= 60 then
                msText.Color = Color3.fromRGB(0, 255, 0)
            elseif ping <= 120 then
                msText.Color = Color3.fromRGB(255, 165, 0)
            else
                msText.Color = Color3.fromRGB(255, 0, 0)
                msText.Text = "Ew Wifi Ping: " .. ping .. " ms"
            end
            msText.Visible = true
        else
            msText.Visible = false
        end
        fpsCounter = 0
        fpsLastUpdate = tick()
    end
end)
Tabs.Misc:Toggle({Title="Show FPS", Default=true, Callback=function(val) showFPS=val; fpsText.Visible=val end})
Tabs.Misc:Toggle({Title="Show Ping (ms)", Default=true, Callback=function(val) showPing=val; msText.Visible=val end})
