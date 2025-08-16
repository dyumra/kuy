local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer
local OSTime = os.time()
local Time = os.date('!*t', OSTime)

-- ดึงข้อมูลเกมจริง
local gameName, creatorName, maxPlayers = "Unknown", "Unknown", 0
pcall(function()
    local info = MarketplaceService:GetProductInfo(game.PlaceId)
    gameName = info.Name or "Unknown"
    creatorName = info.Creator.Name or "Unknown"
    maxPlayers = info.MaxPlayers or 1 -- fallback 1 เพื่อป้องกัน division by zero
end)

-- จำนวนผู้เล่น
local currentPlayers = #Players:GetPlayers()

-- Progress Bar safe
local function createProgressBar(current, maximum, length)
    length = length or 10
    maximum = (maximum > 0) and maximum or 1        -- ป้องกัน division by zero
    current = math.min(current, maximum)            -- cap current ไม่ให้เกิน maximum
    local filledLength = math.floor(current / maximum * length)
    local bar = string.rep("█", filledLength) .. string.rep("░", length - filledLength)
    return bar .. string.format(" %d/%d", current, maximum)
end
local playerBar = createProgressBar(currentPlayers, maxPlayers, 10)

-- Account Info
local accountAge = tostring(player.AccountAge or 0) .. " days"
local executor = (type(identifyexecutor) == "function" and identifyexecutor()) or "Unknown"
local isPremium = (player.MembershipType == Enum.MembershipType.Premium) and "Yes 💎" or "No ❌"

local Content = '# **Execution Log Report | DYHUB**'

local Embed = {
    title = '🚨 DYHUB | Advanced Execution Log',
    color = 0xFF0000, -- Red Theme
    footer = { text = "JobId: " .. (game.JobId or "N/A") },
    author = { name = 'Official DYHUB Channel', url = 'https://youtube.com/@officialdyhub' },
    thumbnail = { url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=150&height=150&format=png" },
    image = { url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png" },
    fields = {
        -- Section 1: Account Info
        { name = '🟥 Status', value = '━━━━━━━━━━━━━━', inline = false },
        { name = 'Version', value = "Free ✅", inline = true },
            
        { name = '🟥 Account Information', value = '━━━━━━━━━━━━━━', inline = false },
        { name = 'Username', value = "@" .. (player.Name or "Unknown"), inline = true },
        { name = 'Display Name', value = player.DisplayName or "Unknown", inline = true },
        { name = 'User ID', value = tostring(player.UserId or "Unknown"), inline = true },
        { name = 'Account Age', value = accountAge, inline = true },
        { name = 'Premium Membership', value = isPremium, inline = true },
        { name = 'Executor', value = executor, inline = true },

        -- Section 2: Links
        { name = '🟥 Links', value = '━━━━━━━━━━━━━━', inline = false },
        { name = 'Profile', value = "[View Profile](https://www.roblox.com/users/" .. player.UserId .. ")", inline = true },
        { name = 'Game', value = "[View Game](https://www.roblox.com/games/" .. game.PlaceId .. ")", inline = true },
        { name = 'Join Server', value = "[Click Here to Join](https://www.roblox.com/games/" .. game.PlaceId .. "?privateServerLinkCode=" .. (game.JobId or "" ) .. ")", inline = true },

        -- Section 3: Job Info
        { name = '🟥 Job Information', value = '━━━━━━━━━━━━━━', inline = false },
        { name = 'Job ID', value = game.JobId or "N/A", inline = true },
        { name = 'Copy Job ID', value = "```" .. (game.JobId or "N/A") .. "```", inline = true },

        -- Section 4: Game Info + Progress Bar
        { name = '🟥 Game Information', value = '━━━━━━━━━━━━━━', inline = false },
        { name = 'Game Name', value = gameName, inline = true },
        { name = 'Creator', value = creatorName, inline = true },
        { name = 'Server Population', value = playerBar, inline = false },
    },
    timestamp = string.format('%d-%02d-%02dT%02d:%02d:%02dZ', Time.year, Time.month, Time.day, Time.hour, Time.min, Time.sec)
}

local webhookUrl = 'https://discord.com/api/webhooks/1402082581587169361/uOSBlaQN0amnMOWup7iAzIfGqyyAPohUGxFCI8ogqiTJ3AnWMvH-VMKZPQ_LHaVgdndB'
local requestFunction = (syn and syn.request) or http_request or (http and http.request)

local function loadNextScript()
    task.wait(0.1)
    loadstring(game:HttpGet('https://raw.githubusercontent.com/dyumra/Let-CrackingNigga-ForScript/refs/heads/main/Ygwt52vai15werqc14873ksui'))()
end

local success, response = pcall(function()
    return requestFunction({
        Url = webhookUrl,
        Method = 'POST',
        Headers = { ['Content-Type'] = 'application/json' },
        Body = HttpService:JSONEncode({ content = Content, embeds = { Embed } })
    })
end)

if success and response and (response.StatusCode == 204 or response.StatusCode == 200) then
    print("[DYHUB] Loaded successfully.")
    loadNextScript()
else
    warn("[DYHUB] ❌ Failed to load DYHUB script")
    if response then
        warn("Status Code:", response.StatusCode)
        warn("Body:", response.Body)
    end
end
