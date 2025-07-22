repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Confirmed = false
WindUI:Popup({
    Title = "DYHUB Loaded! - Anime Rails",
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
    Title = "DYHUB - Anime Rails",
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Size = UDim2.fromOffset(720, 500),
    Transparent = true,
    Theme = "Dark",
})

-- Tabs
local MainTab = Window:Tab({ Title = "Main", Icon = "rocket" })
local CashTab = Window:Tab({ Title = "Cash", Icon = "circle-dollar-sign" })
--local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" })
local PartyTab = Window:Tab({ Title = "Auto Join", Icon = "handshake" })
--local SpinTab = Window:Tab({ Title = "Spin", Icon = "ferris-wheel" })
local GUI = Window:Tab({ Title = "Equip", Icon = "flame" })
local GamepassTab = Window:Tab({ Title = "Gamepass", Icon = "cookie" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "cog" })
local ConfigTab = Window:Tab({ Title = "Config", Icon = "file-cog" })

-- Main Tab
local event = ReplicatedStorage:WaitForChild("Events"):WaitForChild("ChangeValue")

local dupeNames = {
    "Infinity", "Solar", "Crimson", "DarkArcher", "PurpleAssasin", "WolfBoss", "Merchant", "SickCurse", "Tank",
    "CrimsonMaster", "Lightning", "SunBreather", "KnightBoss", "Materials", "Baryon", "HeinEra", "Sukuna",
    "Naruto", "SSGoku", "Tanjiro", "Goku", "Shadows", "Kaiser", "Puzzle", "Knight", "Shake", "Hapticss",
    "MuzanAura", "MoonAura", "YellowAura", "MuzanClass", "KokoshiboClass", "CompassClass", "MuzanMorph",
    "MoonMorph", "HakiPower", "InfinityVoid", "Dismantle", "Restriction", "BlackFlashAura", "ShadowAura",
    "CriticalHit", "Gear4", "BlackFlash", "Toji", "InfinityEyes", "MasteredReflex", "LavaMasterClass",
    "RedeemedWolfBoss", "RedeemedKnight", "LuffyMorph", "DoughMorph", "GravityAura", "DoughAura",
    "LavaAura", "Gear5Class", "MochiClass", "Rinnegan", "Kurama", "Sasuke", "Pain", "EightGates", "Sed",
    "Cid", "Gojo", "Assasin", "AntKing", "BlueFlames", "BloodKnight", "BloodMorph", "BloodMorphS",
    "AntMorph", "AntMorphS", "AssasinMorph", "LightAura", "AlterAura", "Alter", "Saber", "SaberMorph", "AlterMorph",
    "Hakai", "PridfulWarrior", "EarthWarrior", "GreatApe", "BeerusMorph", "VegetaMorph", "BeerusBoss", "Mahoraga"
}

local morphInputValue = ""
local classInputValue = ""
local auraInputValue = ""

MainTab:Button({
    Title = "Dupe All (Click me for All)",
    Icon = "atom",
    Callback = function()
        for _, name in ipairs(dupeNames) do
            event:FireServer("SetMorphBuy", name, 0)
            wait(0.05)
        end
        print("[DYHUB] All Morphs, Classes and Auras unlocked!")
    end,
})

MainTab:Dropdown({
    Title = "Index List",
    Values = dupeNames,
    Multi = false,
    Callback = function(value)
        print("[DYHUB] Selected index:", value)
    end,
})

MainTab:Input({
    Title = "Dupe Morph",
    Placeholder = "Use the name from Npc Morph",
    Callback = function(text)
        morphInputValue = text
    end,
})

MainTab:Button({
    Title = "Unlock Morph",
    Icon = "crown",
    Callback = function()
        local found = false
        for _, name in ipairs(dupeNames) do
            if name:lower() == morphInputValue:lower() then
                event:FireServer("SetMorphBuy", name, 0)
                print("[DYHUB] Morph unlocked:", name)
                found = true
                break
            end
        end
        if not found then
            print("[DYHUB] Invalid Morph:", morphInputValue)
        end
    end,
})

MainTab:Input({
    Title = "Dupe Class",
    Placeholder = "Use the name from Npc Class",
    Callback = function(text)
        classInputValue = text
    end,
})

MainTab:Button({
    Title = "Unlock Class",
    Icon = "swords",
    Callback = function()
        local found = false
        for _, name in ipairs(dupeNames) do
            if name:lower() == classInputValue:lower() then
                event:FireServer("SetMorphBuy", name, 0)
                print("[DYHUB] Class unlocked:", name)
                found = true
                break
            end
        end
        if not found then
            print("[DYHUB] Invalid Class:", classInputValue)
        end
    end,
})

MainTab:Input({
    Title = "Dupe Aura",
    Placeholder = "Use the name from Npc Aura",
    Callback = function(text)
        auraInputValue = text
    end,
})

MainTab:Button({
    Title = "Unlock Aura",
    Icon = "flame",
    Callback = function()
        local found = false
        for _, name in ipairs(dupeNames) do
            if name:lower() == auraInputValue:lower() then
                event:FireServer("SetMorphBuy", name, 0)
                print("[DYHUB] Aura unlocked:", name)
                found = true
                break
            end
        end
        if not found then
            print("[DYHUB] Invalid Aura:", auraInputValue)
        end
    end,
})

-- Gamepass Tab
local selectedGamepass = "All"
GamepassTab:Dropdown({
    Title = "Select Gamepass",
    Values = { "All", "DoubleCash", "AlrBoughtSkipSpin", "SecClass", "Emote", "CriticalHit", "SkipSpin" },
    Multi = false,
    Callback = function(selected)
        selectedGamepass = selected
        print("[DYHUB] Selected Gamepass:", selectedGamepass)
    end,
})

GamepassTab:Button({
    Title = "Enter Unlock",
    Icon = "check",
    Callback = function()
        local player = LocalPlayer
        local data = player:FindFirstChild("Data")
        if not data then
            warn("[DYHUB] Data not found!")
            return
        end

        if selectedGamepass == "All" then
            local gamepasses = { "DoubleCash", "AlrBoughtSkipSpin", "SecClass", "Emote", "CriticalHit", "SkipSpin" }
            for _, gpName in ipairs(gamepasses) do
                local gp = data:FindFirstChild(gpName)
                if gp then
                    gp.Value = true
                    print("[DYHUB] Unlocked Gamepass:", gpName)
                end
            end
        else
            local gp = data:FindFirstChild(selectedGamepass)
            if gp then
                gp.Value = true
                print("[DYHUB] Unlocked Gamepass:", selectedGamepass)
            else
                warn("[DYHUB] Gamepass not found:", selectedGamepass)
            end
        end

        if selectedGamepass == "Emote" or selectedGamepass == "All" then
            local emotes = player:FindFirstChild("PlayerGui"):FindFirstChild("HUD")
            if emotes and emotes:FindFirstChild("Emotes") then
                emotes.Emotes.Visible = true
            end
        end
    end,
})

-- Cash Tab
local cashInputValue = ""

CashTab:Input({
    Title = "Enter Dupe Cash Amount",
    Placeholder = "100 ~ 10000",
    Callback = function(text)
        cashInputValue = text
    end,
})

CashTab:Button({
    Title = "Dupe Cash",
    Icon = "dollar-sign",
    Callback = function()
        local input = tonumber(cashInputValue)
        if input and input >= 100 and input <= 10000 then
            local args = {
                [1] = "Wins",
                [2] = input,
                [3] = "DYHUB"
            }
            ReplicatedStorage:WaitForChild("CodeEvent"):FireServer(unpack(args))
            print("[DYHUB] Dupe Cash:", input)
        else
            print("[DYHUB] Invalid amount:", cashInputValue)
        end
    end,
})

CashTab:Button({
    Title = "Infinite Dupe Cash",
    Icon = "infinity",
    Callback = function()
        local totalAmount = 999000000
        local perFire = 999999
        local times = math.floor(totalAmount / perFire)
        task.spawn(function()
            for i = 1, times do
                local args = {
                    [1] = "Wins",
                    [2] = perFire,
                    [3] = "DYHUB"
                }
                ReplicatedStorage:WaitForChild("CodeEvent"):FireServer(unpack(args))
                task.wait(0.1)
            end
            print("[DYHUB] Completed Infinite Cash")
        end)
    end,
})

CashTab:Button({
    Title = "Infinite Dupe Spin",
    Icon = "rotate-ccw",
    Callback = function()
        local totalAmount = 9999
        local perFire = 1
        local times = math.floor(totalAmount / perFire)
        task.spawn(function()
            for i = 1, times do
                local args = {
                    [1] = "Wins",
                    [2] = 0,
                    [3] = "DYHUB"
                }
                ReplicatedStorage:WaitForChild("CodeEvent"):FireServer(unpack(args))
                task.wait(0.05)
            end
            print("[DYHUB] Completed Infinite Dupe Spin +10 Spin")
        end)
    end,
})

-- Player Tab

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local espEnabled = false
local espUpdateConnection
local espOptions = {
    ShowName = false,
    ShowHealth = false,
    ShowDistance = false,
    ShowMorph = false,
    ShowClass = false,
    ShowAura = false,
    HighlightColor = Color3.fromRGB(0, 255, 0),
    Rainbow = false,
}

local function updateESP()
    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= LocalPlayer then
            local success, err = pcall(function()
                local character = target.Character
                local head = character and character:FindFirstChild("Head")
                if not head then return end

                local gui = head:FindFirstChild("DYESP")
                if not gui then
                    gui = Instance.new("BillboardGui")
                    gui.Name = "DYESP"
                    gui.Size = UDim2.new(0, 200, 0, 100)
                    gui.StudsOffset = Vector3.new(0, 2.5, 0)
                    gui.AlwaysOnTop = true
                    gui.Parent = head
                end

                -- Clear old labels
                for _, child in ipairs(gui:GetChildren()) do
                    if child:IsA("TextLabel") then
                        child:Destroy()
                    end
                end

                local function addLine(text, yOffset)
                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 0, 20)
                    label.Position = UDim2.new(0, 0, 0, yOffset)
                    label.BackgroundTransparency = 1
                    label.TextColor3 = espOptions.Rainbow and Color3.fromHSV((tick() % 5) / 5, 1, 1) or espOptions.HighlightColor
                    label.TextStrokeTransparency = 0
                    label.TextScaled = true
                    label.Font = Enum.Font.SourceSansBold
                    label.Text = text
                    label.Parent = gui
                end

                local data = target:FindFirstChild("Data")
                local y = 0

                if espOptions.ShowName then
                    addLine(target.Name, y)
                    y += 20
                end

                if espOptions.ShowHealth and character:FindFirstChild("Humanoid") then
                    addLine("HP: " .. math.floor(character.Humanoid.Health), y)
                    y += 20
                end

                if espOptions.ShowDistance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("HumanoidRootPart") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                    addLine("Dist: " .. math.floor(dist), y)
                    y += 20
                end

                if espOptions.ShowMorph and data and data:FindFirstChild("CurrMorph") and data.CurrMorph:IsA("StringValue") then
                    addLine("Morph: " .. data.CurrMorph.Value, y)
                    y += 20
                end

                if espOptions.ShowClass and data and data:FindFirstChild("CurrClass") and data.CurrClass:IsA("StringValue") then
                    addLine("Class: " .. data.CurrClass.Value, y)
                    y += 20
                end

                if data and data:FindFirstChild("CurrClassSec") and data.CurrClassSec:IsA("StringValue") then
                    addLine("Class Stol-2: " .. data.CurrClassSec.Value, y)
                    y += 20
                end

                if data and data:FindFirstChild("CurrTitle") and data.CurrTitle:IsA("StringValue") then
                    addLine("Title: " .. data.CurrTitle.Value, y)
                    y += 20
                end

                if espOptions.ShowAura and data and data:FindFirstChild("CurrSelect") and data.CurrSelect:IsA("StringValue") then
                    addLine("Aura: " .. data.CurrSelect.Value, y)
                    y += 20
                end
            end)

            if not success then
                warn("[ESP ERROR]:", err)
            end
        end
    end
end

local function clearESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Head") then
            local gui = player.Character.Head:FindFirstChild("DYESP")
            if gui then
                gui:Destroy()
            end
        end
    end
end

local function toggleESP(state)
    espEnabled = state
    if espEnabled then
        updateESP()
        espUpdateConnection = RunService.Heartbeat:Connect(updateESP)
    else
        clearESP()
        if espUpdateConnection then
            espUpdateConnection:Disconnect()
            espUpdateConnection = nil
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    if espEnabled then
        player.CharacterAdded:Wait()
        updateESP()
    end
end)

-- UI Integration (WindUI / Rayfield / etc.)
PlayerTab:Toggle({
    Title = "Enable ESP",
    Value = false,
    Callback = function(state)
        toggleESP(state)
    end,
})

PlayerTab:Dropdown({
    Title = "ESP Color",
    Default = "Green",
    Options = {
        "Red", "Green", "Blue", "Yellow", "Purple", "Cyan", "White", "Black", "Rainbow"
    },
    Callback = function(colorName)
        espOptions.Rainbow = false
        local colors = {
            Red = Color3.fromRGB(255, 0, 0),
            Green = Color3.fromRGB(0, 255, 0),
            Blue = Color3.fromRGB(0, 0, 255),
            Yellow = Color3.fromRGB(255, 255, 0),
            Purple = Color3.fromRGB(128, 0, 128),
            Cyan = Color3.fromRGB(0, 255, 255),
            White = Color3.fromRGB(255, 255, 255),
            Black = Color3.fromRGB(0, 0, 0),
            Rainbow = nil,
        }
        if colorName == "Rainbow" then
            espOptions.Rainbow = true
        else
            espOptions.HighlightColor = colors[colorName] or Color3.fromRGB(0, 255, 0)
        end
    end,
})

PlayerTab:Toggle({
    Title = "Show Player Name",
    Value = false,
    Callback = function(state)
        espOptions.ShowName = state
    end,
})

PlayerTab:Toggle({
    Title = "Show Health",
    Value = false,
    Callback = function(state)
        espOptions.ShowHealth = state
    end,
})

PlayerTab:Toggle({
    Title = "Show Distance",
    Value = false,
    Callback = function(state)
        espOptions.ShowDistance = state
    end,
})

PlayerTab:Toggle({
    Title = "Show Morph",
    Value = false,
    Callback = function(state)
        espOptions.ShowMorph = state
    end,
})

PlayerTab:Toggle({
    Title = "Show Class",
    Value = false,
    Callback = function(state)
        espOptions.ShowClass = state
    end,
})

PlayerTab:Toggle({
    Title = "Show Aura",
    Value = false,
    Callback = function(state)
        espOptions.ShowAura = state
    end,
})


-- Misc Tab
local antiAfkEnabled = false
local antiAdminEnabled = false
local fakeBypassEnabled = false

-- 🌌 Bypass Anti-Cheat (ปลอม)
MiscTab:Toggle({
    Title = "Bypass Anti-Cheat (By rhy)",
    Value = true,
    Callback = function(state)
        fakeBypassEnabled = state
        if fakeBypassEnabled then
            print("[DYHUB] Bypassing Anti-Cheat... ✅(DYHUB'S TEAM)")
            Notify({
                Title = "Bypass Enabled",
                Description = "Finished: bypass enabled. Just for looks 😉",
                Duration = 3
            })
        else
            print("[DYHUB] Bypass Anti-Cheat disabled.")
        end
    end,
})

-- 💤 Anti AFK
MiscTab:Toggle({
    Title = "Anti AFK",
    Value = false,
    Callback = function(state)
        antiAfkEnabled = state
        if antiAfkEnabled then
            task.spawn(function()
                while antiAfkEnabled do
                    VirtualUser:Button2Down(Vector2.new(0,0))
                    task.wait(60)
                end
            end)
            print("[DYHUB] Anti AFK enabled")
        else
            print("[DYHUB] Anti AFK disabled")
        end
    end,
})

-- 👮 Anti Admin (Auto ServerHop ถ้าเจอ Roblox123)
MiscTab:Toggle({
    Title = "Anti Admin (Auto Hop)",
    Value = false,
    Callback = function(state)
        antiAdminEnabled = state
        if antiAdminEnabled then
            print("[DYHUB] Anti Admin enabled - Scanning players... (every: 15 sec)")
            task.spawn(function()
                while antiAdminEnabled do
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player.Name == "Roblox123" then
                            print("[DYHUB] Detected admin: Roblox123, hopping server...")
                            Notify({
                                Title = "Anti Admin",
                                Description = "Detected admin 'Roblox123'. Hopping server...",
                                Duration = 3
                            })
                            task.wait(1)
                            TeleportService:Teleport(game.PlaceId, LocalPlayer)
                            return
                        end
                    end
                    task.wait(15) -- ตรวจสอบทุก 5 วินาที
                end
            end)
        else
            print("[DYHUB] Anti Admin disabled")
        end
    end,
})

local indexList = {
    "Infinity", "Solar", "Crimson", "DarkArcher", "PurpleAssasin", "WolfBoss", "Merchant", "SickCurse", "Tank",
    "CrimsonMaster", "Lightning", "SunBreather", "KnightBoss", "Materials", "Baryon", "HeinEra", "Sukuna",
    "Naruto", "SSGoku", "Tanjiro", "Goku", "Shadows", "Kaiser", "Puzzle", "Knight", "Shake", "Hapticss",
    "MuzanAura", "MoonAura", "YellowAura", "MuzanClass", "KokoshiboClass", "CompassClass", "MuzanMorph",
    "MoonMorph", "HakiPower", "InfinityVoid", "Dismantle", "Restriction", "BlackFlashAura", "ShadowAura",
    "CriticalHit", "Gear4", "BlackFlash", "Toji", "InfinityEyes", "MasteredReflex", "LavaMasterClass",
    "RedeemedWolfBoss", "RedeemedKnight", "LuffyMorph", "DoughMorph", "GravityAura", "DoughAura",
    "LavaAura", "Gear5Class", "MochiClass", "Rinnegan", "Kurama", "Sasuke", "Pain", "EightGates", "Sed",
    "Cid", "Gojo", "Assasin", "AntKing", "BlueFlames", "BloodKnight", "BloodMorph", "BloodMorphS",
    "AntMorph", "AntMorphS", "AssasinMorph", "LightAura", "AlterAura", "Alter", "Saber", "SaberMorph", "AlterMorph",
    "Hakai", "PridfulWarrior", "EarthWarrior", "GreatApe", "BeerusMorph", "VegetaMorph", "BeerusBoss", "Mahoraga"
}

-- Dropdown สำหรับดู index ทั้งหมด
GUI:Dropdown({
    Title = "Index List",
    Values = indexList,
    Multi = false,
    Callback = function(value)
        print("[DYHUB] Selected index:", value)
    end,
})

-- ฟังก์ชันกลางสำหรับปุ่ม FireServer
local function fireChangeValue(key, value)
    local args = { key, value }
    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ChangeValue"):FireServer(unpack(args))
    print("[DYHUB] Sent", key, value)
end

-- Input: SetCurrChar
GUI:Input({
    Title = "Set Character",
    Placeholder = "Type character name...",
    Callback = function(value)
        fireChangeValue("SetCurrChar", value)
    end,
})

-- Input: SetCurClass
GUI:Input({
    Title = "Set Class (Slot 1)",
    Placeholder = "Type class name...",
    Callback = function(value)
        fireChangeValue("SetCurClass", value)
    end,
})

-- Input: SetCurClass2 (Gamepass Slot 2)
GUI:Input({
    Title = "Set Class (Slot 2)",
    Placeholder = "Type class2 name...",
    Callback = function(value)
        fireChangeValue("SetCurClass2", value)
    end,
})

-- Input: SetCurAura
GUI:Input({
    Title = "Set Aura",
    Placeholder = "Type aura name...",
    Callback = function(value)
        fireChangeValue("SetCurAura", value)
    end,
})

-- auto join
-- ตัวแปรเริ่มต้น
local maxPlayers = 1
local allowFriend = true
local nightmareMode = false

-- Input สำหรับ Max Players
PartyTab:Input({
    Title = "Max Players",
    Placeholder = "Enter 1 ~ 8",
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 1 and num <= 8 then
            maxPlayers = num
            print("[DYHUB] Max Players set to:", maxPlayers)
        else
            warn("[DYHUB] Invalid max players input, must be between 1 and 8")
            -- หาก WindUI มี notify: WindUI:Notify("Invalid input", "Please enter a number from 1 to 8")
        end
    end,
})

-- Toggle สำหรับ Allow Friend Join
PartyTab:Toggle({
    Title = "Allow Friend Join",
    Default = true,
    Callback = function(state)
        allowFriend = state
        print("[DYHUB] Allow Friend Join:", state)
    end,
})

-- Toggle สำหรับ Nightmare Mode
PartyTab:Toggle({
    Title = "Nightmare Mode",
    Default = false,
    Callback = function(state)
        nightmareMode = state
        print("[DYHUB] Nightmare Mode:", state)
    end,
})

-- ปุ่ม Auto Join
PartyTab:Button({
    Title = "Auto Join",
    Callback = function()
        local args = {
            allowFriend,
            maxPlayers,
            nightmareMode
        }
        game:GetService("ReplicatedStorage"):WaitForChild("ApplyTP"):FireServer(unpack(args))
        print("[DYHUB] Auto Join sent:", allowFriend, maxPlayers, nightmareMode)
    end,
})

--- spin
local GotValue = "N/A"
local CurrSpin = 0

-- ป้ายบอกจำนวน spin และสิ่งที่ได้
local SpinInfoLabel = SpinTab:Label("Spin: Loading...\nGot: " .. GotValue)

-- ดึงค่าจาก player.Data.Spin และ CurrClass.Value
local function updateSpinLabel()
    local player = game:GetService("Players").LocalPlayer
    local dataFolder = player:FindFirstChild("Data")
    local currClass = player:FindFirstChild("CurrClass")
    
    if dataFolder and dataFolder:FindFirstChild("Spin") then
        CurrSpin = dataFolder.Spin.Value
    end

    if currClass then
        GotValue = currClass.Value
    end

    SpinInfoLabel:Set("Spin: " .. CurrSpin .. "\nGot: " .. GotValue)
end

-- ติดตามการเปลี่ยนแปลงของค่าแบบอัตโนมัติ
task.spawn(function()
    while task.wait(0.5) do
        updateSpinLabel()
    end
end)

-- ปุ่มสุ่ม
local autoSpinEnabled = false

SpinTab:Toggle({
    Title = "Auto Spin",
    Value = false,
    Callback = function(state)
        autoSpinEnabled = state
        if autoSpinEnabled then
            task.spawn(function()
                while autoSpinEnabled do
                    local args = { "Spin" }
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ChangeValue"):FireServer(unpack(args))
                    task.wait(1) -- ปรับความถี่การสุ่มได้ (หน่วย: วินาที)
                end
            end)
        end
    end,
})

SpinTab:Button({
    Title = "Spin Class",
    Callback = function()
        local args = { "Spin" }
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ChangeValue"):FireServer(unpack(args))
    end,
})

-- teleport 
TeleportTab:Button({
    Title = "Teleport to Aura Shop",
    Callback = function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(-5.7536335, 188.169067, -131.537506, -0.10051205, 8.16659522e-08, 0.99493587, -3.84045897e-08, 1, -8.59613962e-08, -0.99493587, -4.68502606e-08, -0.10051205)
            print("[DYHUB] Teleported to Aura Shop")
        end
    end,
})

TeleportTab:Button({
    Title = "Teleport to Class Shop",
    Callback = function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(-3.96356249, 188.169052, -99.7206345, 0.217696652, 4.36522107e-08, 0.976016462, 1.9954145e-08, 1, -4.9175565e-08, -0.976016462, 3.0180928e-08, 0.217696652)
            print("[DYHUB] Teleported to Class Shop")
        end
    end,
})

TeleportTab:Button({
    Title = "Teleport to Morph Shop",
    Callback = function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(8.6613245, 188.169067, -97.1435318, 0.779245794, -3.30689467e-08, -0.626718462, -1.24927118e-08, 1, -6.82983554e-08, 0.626718462, 6.10506206e-08, 0.779245794)
            print("[DYHUB] Teleported to Morph Shop")
        end
    end,
})

TeleportTab:Button({
    Title = "Teleport to Npc Spin",
    Callback = function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(8.35407925, 188.169067, -132.966141, -0.510008216, -1.13285189e-07, -0.86016953, 1.64339864e-09, 1, -1.32675396e-07, 0.86016953, -6.90791424e-08, -0.510008216)
            print("[DYHUB] Teleported to Spin")
        end
    end,
})

TeleportTab:Button({
    Title = "Teleport to Title Shop",
    Callback = function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(-14.3617506, 188.169052, -27.776825, -0.999740958, 5.87875304e-09, -0.0227609444, 5.73739145e-09, 1, 6.27602681e-09, 0.0227609444, 6.14381257e-09, -0.999740958)
            print("[DYHUB] Teleported to Title Shop")
        end
    end,
})

TeleportTab:Button({
    Title = "Teleport to Tutorial",
    Callback = function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(1.71302092, 188.169052, -60.757412, -0.999253094, 9.66736309e-08, 0.0386431366, 9.36806828e-08, 1, -7.92618096e-08, -0.0386431366, -7.55824914e-08, -0.999253094)
            print("[DYHUB] Teleported to Tutorial")
        end
    end,
})

TeleportTab:Button({
    Title = "Teleport to AFK World",
    Callback = function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(18.6007061, 188.169052, -24.452446, -0.940061092, -3.15264685e-08, 0.34100607, -2.33052724e-08, 1, 2.82050365e-08, -0.34100607, 1.85672189e-08, -0.940061092)
            print("[DYHUB] Teleported to AFK World")
        end
    end,
})

TeleportTab:Button({
    Title = "Teleport to Battle Royale",
    Callback = function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(0.462113261, 188.169067, -142.787186, 0.987219155, 5.76863819e-08, -0.159368694, -5.34411058e-08, 1, 3.09239034e-08, 0.159368694, -2.20118288e-08, 0.987219155)
            print("[DYHUB] Teleported to Battle Royale")
        end
    end,
})

-- Config Tab
local HttpService = game:GetService("HttpService")

local configName = ""
local savedConfigs = {} -- เก็บ configs ไว้ในตัวแปร (ในสถานะจริงต้องใช้ DataStore)

-- ฟังก์ชันเก็บค่าปัจจุบันลงในตาราง config
local function gatherCurrentConfig()
    local currentConfig = {}

    -- เก็บ ESP settings
    currentConfig.ESP = {
        ShowName = espOptions.ShowName,
        ShowHealth = espOptions.ShowHealth,
        ShowDistance = espOptions.ShowDistance,
        ShowMorph = espOptions.ShowMorph,
        ShowClass = espOptions.ShowClass,
        ShowAura = espOptions.ShowAura,
        HighlightColor = {
            r = espOptions.HighlightColor.R * 255,
            g = espOptions.HighlightColor.G * 255,
            b = espOptions.HighlightColor.B * 255
        },
        Rainbow = espOptions.Rainbow,
    }

    -- Auto Join
    currentConfig.AutoJoin = {
        AllowFriend = allowFriend,
        MaxPlayers = maxPlayers,
        NightmareMode = nightmareMode
    }

    -- Gamepass
    currentConfig.Gamepass = selectedGamepass

    -- Auto Spin
    currentConfig.AutoSpin = autoSpinEnabled

    -- Misc toggles
    currentConfig.Misc = {
        AntiAFK = antiAfkEnabled,
        AntiAdmin = antiAdminEnabled,
        FakeBypass = fakeBypassEnabled
    }

    -- Morph/Class/Aura input
    currentConfig.Morph = morphInputValue
    currentConfig.Class = classInputValue
    currentConfig.Aura = auraInputValue

    return currentConfig
end

-- ฟังก์ชันนำ config ที่โหลดมาไปใช้กับ UI และค่าต่าง ๆ
local function applyConfig(config)
    if not config then return end

    -- ESP
    if config.ESP then
        espOptions.ShowName = config.ESP.ShowName or false
        espOptions.ShowHealth = config.ESP.ShowHealth or false
        espOptions.ShowDistance = config.ESP.ShowDistance or false
        espOptions.ShowMorph = config.ESP.ShowMorph or false
        espOptions.ShowClass = config.ESP.ShowClass or false
        espOptions.ShowAura = config.ESP.ShowAura or false
        espOptions.Rainbow = config.ESP.Rainbow or false

        if config.ESP.HighlightColor then
            espOptions.HighlightColor = Color3.fromRGB(
                config.ESP.HighlightColor.r or 0,
                config.ESP.HighlightColor.g or 255,
                config.ESP.HighlightColor.b or 0
            )
        end
    end

    -- Auto Join
    if config.AutoJoin then
        allowFriend = config.AutoJoin.AllowFriend or true
        maxPlayers = config.AutoJoin.MaxPlayers or 1
        nightmareMode = config.AutoJoin.NightmareMode or false
    end

    -- Gamepass
    selectedGamepass = config.Gamepass or "All"

    -- Auto Spin
    autoSpinEnabled = config.AutoSpin or false

    -- Misc toggles
    if config.Misc then
        antiAfkEnabled = config.Misc.AntiAFK or false
        antiAdminEnabled = config.Misc.AntiAdmin or false
        fakeBypassEnabled = config.Misc.FakeBypass or false
    end

    -- Morph/Class/Aura
    morphInputValue = config.Morph or ""
    classInputValue = config.Class or ""
    auraInputValue = config.Aura or ""

    -- อัปเดต UI ตามค่าที่เปลี่ยน (สมมติว่าฟังก์ชันนี้มีอยู่ เช่น toggleESP, ปุ่ม toggle ต่างๆ ต้องเชื่อมกับ UI จริง)
    toggleESP(espOptions.ShowName or false)
    -- อาจจะต้องเพิ่มโค้ดอัปเดต toggle ปุ่มอื่นๆ ด้วย ขึ้นกับ UI ที่ใช้

    print("[DYHUB] Config applied:", configName)
end

-- Config Name input
ConfigTab:Input({
    Title = "Config Name",
    Placeholder = "Enter Name your Config",
    Callback = function(text)
        configName = text
        print("[DYHUB] Config name set to:", configName)
    end,
})

-- Create Config (อาจเหมือน Save)
ConfigTab:Button({
    Title = "Create Config",
    Callback = function()
        if configName == "" then
            print("[DYHUB] Please enter a config name before creating!")
            return
        end
        local configData = gatherCurrentConfig()
        savedConfigs[configName] = configData
        print("[DYHUB] Created config:", configName)
    end,
})

-- Save Config (อัพเดตค่าที่มีอยู่)
ConfigTab:Button({
    Title = "Save Config",
    Callback = function()
        if configName == "" then
            print("[DYHUB] Please enter a config name before saving!")
            return
        end
        if not savedConfigs[configName] then
            print("[DYHUB] No config found with this name, creating new...")
        end
        local configData = gatherCurrentConfig()
        savedConfigs[configName] = configData
        print("[DYHUB] Saved config:", configName)
    end,
})

-- โหลดชื่อ config ที่บันทึกไว้ไปใน dropdown
local function updateConfigDropdown()
    local names = {}
    for name, _ in pairs(savedConfigs) do
        table.insert(names, name)
    end
    -- อัปเดต dropdown options
    ConfigTab:Clear() -- สมมติฟังก์ชันเคลียร์ dropdown ที่เก่าก่อน
    ConfigTab:Dropdown({
        Title = "Load Save-Config",
        Values = names,
        Multi = false,
        Callback = function(value)
            print("[DYHUB] Selected config:", value)
            configName = value
        end,
    })
end

-- เรียกอัปเดตตอนเริ่ม (ถ้ามี)
updateConfigDropdown()

-- Load Config
ConfigTab:Button({
    Title = "Load Config",
    Callback = function()
        if configName == "" then
            print("[DYHUB] Please select a config name to load!")
            return
        end
        local configData = savedConfigs[configName]
        if configData then
            applyConfig(configData)
        else
            print("[DYHUB] Config not found:", configName)
        end
    end,
})

-- Main loop
RunService.Heartbeat:Connect(function()
    if espEnabled then
        updateESP()
    end
end)

print("[DYHUB] Script loaded successfully!")
