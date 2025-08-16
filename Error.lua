local DYHUBTHEBEST = "(dsc.gg/dyhub)"

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local blur = Instance.new("BlurEffect")
blur.Size = 15
blur.Parent = Lighting

local VALID_KEY = "BUHYD69"

local function notify(text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "DYHUB",
            Text = text,
            Duration = 4
        })
    end)
    print("[Notify]", text)
end

local function clickTween(button)
    local original = button.BackgroundColor3
    local goal = {BackgroundColor3 = original:lerp(Color3.fromRGB(40, 40, 40), 0.5)}
    local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(button, tweenInfo, goal)
    tween:Play()
    tween.Completed:Wait()
    TweenService:Create(button, tweenInfo, {BackgroundColor3 = original}):Play()
end

local function createKeyGui(onCorrectKey)
    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "DYHUB | Key System"
    keyGui.ResetOnSpawn = false
    keyGui.Parent = player:WaitForChild("PlayerGui")

    keyGui.Destroying:Connect(function()
        blur:Destroy()
    end)

    local bg = Instance.new("Frame", keyGui)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    bg.BackgroundTransparency = 0.7
    bg.ZIndex = 1000

    local frame = Instance.new("Frame", keyGui)
    frame.Size = UDim2.new(0, 350, 0, 210)
    frame.Position = UDim2.new(0.5, -175, 0.5, -105)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.ZIndex = 1001
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 20)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 25)
    title.Position = UDim2.new(0, 0, 0, 25)
    title.BackgroundTransparency = 1
    title.Text = "Access Key Required"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true
    title.ZIndex = 1002

    local subtitle = Instance.new("TextLabel", frame)
    subtitle.Size = UDim2.new(1, -40, 0, 30)
    subtitle.Position = UDim2.new(0, 20, 0, 50)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Enter your access key below to continue"
    subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 16
    subtitle.ZIndex = 1002

    local keyBox = Instance.new("TextBox", frame)
    keyBox.Size = UDim2.new(1, -40, 0, 40)
    keyBox.Position = UDim2.new(0, 20, 0, 80)
    keyBox.PlaceholderText = "Enter key here..."
    keyBox.Text = ""
    keyBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyBox.Font = Enum.Font.GothamSemibold
    keyBox.TextSize = 20
    keyBox.ClearTextOnFocus = false
    keyBox.ZIndex = 1002
    Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 15)

    local submitBtn = Instance.new("TextButton", frame)
    submitBtn.Size = UDim2.new(1, -40, 0, 40)
    submitBtn.Position = UDim2.new(0, 20, 0, 122)
    submitBtn.Text = "Submit"
    submitBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.TextSize = 22
    submitBtn.ZIndex = 1002
    Instance.new("UICorner", submitBtn).CornerRadius = UDim.new(0, 15)

    local getKeyBtn = Instance.new("TextButton", frame)
    getKeyBtn.Size = UDim2.new(1, -40, 0, 40)
    getKeyBtn.Position = UDim2.new(0, 20, 0, 165)
    getKeyBtn.Text = "Get Key in Discord"
    getKeyBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
    getKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    getKeyBtn.Font = Enum.Font.GothamBold
    getKeyBtn.TextSize = 18
    getKeyBtn.ZIndex = 1002
    Instance.new("UICorner", getKeyBtn).CornerRadius = UDim.new(0, 15)

    submitBtn.MouseButton1Click:Connect(function()
        clickTween(submitBtn)
        local enteredKey = keyBox.Text:lower():gsub("%s+", "")
        if enteredKey == VALID_KEY:lower() then
            notify("✅ Correct Key! Loading...")
            wait(1)
            notify("🔑 Access Key! Free Version | DYHUB")
            keyGui:Destroy()
            blur:Destroy()
            if onCorrectKey then onCorrectKey() end
        else
            notify("❌ Incorrect Key! Please try again.")
            local flashGoal = {BackgroundColor3 = Color3.fromRGB(255, 70, 70)}
            local normalGoal = {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}
            local flashTween = TweenService:Create(keyBox, TweenInfo.new(0.15), flashGoal)
            local normalTween = TweenService:Create(keyBox, TweenInfo.new(0.15), normalGoal)
            flashTween:Play()
            flashTween.Completed:Wait()
            normalTween:Play()
        end
    end)

    getKeyBtn.MouseButton1Click:Connect(function()
        clickTween(getKeyBtn)
        pcall(function()
            setclipboard("https://www.dsc.gg/dyhub")
        end)
        notify("🔗 Link copied to clipboard!")
    end)

    return keyGui
end

-- ===================== Load Premium Users from URL ==========================

local success, premiumUsers = pcall(function()
    local code = game:HttpGet("https://raw.githubusercontent.com/dyumra/Whitelist/refs/heads/main/DYHUB-PREMIUM.lua")
    local func = loadstring(code)
    return func and func() or {}
end)
if not success then
    notify("❌ Failed to load Premium users!")
    wait(3)
    player:Kick("⚠️ Could not load Premium list.\n💳 Please contact support at " .. DYHUBTHEBEST)
    return
end

-- ===================== Free Version Allowed Games ==========================

local FreeVersionallowedGamesByCreatorId = {
    [9482918] = {name = "The Mimic (DYHUB X RAELHUB)", url = "https://raw.githubusercontent.com/Laelmano24/Rael-Hub/refs/heads/main/main.txt"},
}

local FreeVersionallowedGamesByPlaceId = {
    ["70671905624144"] = {name = "Steal A Baddie", url = "https://raw.githubusercontent.com/dyumra/DYHUB-Universal-Game/refs/heads/main/SABaddie.lua"},
}

-- ===================== Premium Version Allowed Games ==========================

local allowedGamesforPremiumByCreatorId = {
    [3049798] = {name = "Doors", url = "https://raw.githubusercontent.com/KINGHUB01/BlackKing-obf/main/Doors%20Blackking%20And%20BobHub"},
}

local AllowGameforPremiumByPlaceId = {
    ["110239180142623"] = {name = "Tsunami Escape", url = "https://raw.githubusercontent.com/dyumra/DYHUB-Universal-Game/refs/heads/main/TE.lua"},
}

-- ===================== Determine Current Game ==========================

local placeId = tostring(game.PlaceId)
local creatorId = tostring(game.CreatorId)

local isPremiumGame = (AllowGameforPremiumByPlaceId[placeId] ~= nil) or (allowedGamesforPremiumByCreatorId[tonumber(creatorId)] ~= nil)
local gameData = FreeVersionallowedGamesByPlaceId[placeId] or FreeVersionallowedGamesByCreatorId[tonumber(creatorId)] or allowedGamesforPremiumByCreatorId[tonumber(creatorId)] or AllowGameforPremiumByPlaceId[placeId]

if not gameData then
    notify("❌ This script is not supported in this game!")
    wait(4)
    player:Kick("⚠️ Script not supported here.\n📊 Please run the script in supported games.\n🔗 Server: " .. DYHUBTHEBEST)
    return
end

-- ===================== Premium Check ==========================

local function loadScript()
    if gameData.url then
        local success, err = pcall(function()
            loadstring(game:HttpGet(gameData.url))()
        end)
        if success then
            notify("🎮 Game: " .. gameData.name .. " | Script loaded.")
        else
            notify("❌ Failed to load script: " .. tostring(err))
        end
    else
        notify("‼️ No script available for this game!")
    end
end

local playerPremium = premiumUsers[player.Name]
if playerPremium then
    notify("💳 Premium! | @" .. playerPremium.Tag .. " | " .. playerPremium.Time)
    blur:Destroy()
    loadScript()
else
    createKeyGui(loadScript)
end
