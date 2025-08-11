--[[ 
      NIGGA TRY TO CRACKING, ASSHOLE
      NIGGA IP SO SICK , LOOK AT MONKEY
      NIGGA NO IDEA TO WRITE SCRIPT
--]]

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local OSTime = os.time()
local Time = os.date('!*t', OSTime)

local Content = '# **🛡️ Discord webhook via | DYHUB**'

local Embed = {
    title = '🔔 DYHUB | Execution Log',
    color = 0xFF0000,
    footer = { text = "🔍 JobId: " .. (game.JobId or "No JobId") },
    author = {
        name = 'Click Link - Subscribe! (DYHUB)',
        url = 'https://youtube.com/@officialdyhub'
    },
    thumbnail = {
        url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
    },
    fields = {
        { name = '🎯 Roblox Username', value = "@" .. player.Name, inline = true },
        { name = '📛 Display Name', value = player.DisplayName, inline = true },
        { name = '🆔 User ID', value = tostring(player.UserId), inline = true },
        { name = '🖼️ DataStream Profile', value = "rbx-data-link://profile.image.access:" .. tostring(player.UserId), inline = false },
        { name = '🎮 Game', value = string.format("Name: %s | ID: %d", game.Name, game.PlaceId), inline = true },
        { name = '🔗 Game Link', value = "https://www.roblox.com/games/" .. tostring(game.PlaceId), inline = true },
        { name = '🔗 Profile Link', value = "https://www.roblox.com/users/" .. tostring(player.UserId), inline = true }
    },
    timestamp = string.format('%d-%02d-%02dT%02d:%02d:%02dZ', Time.year, Time.month, Time.day, Time.hour, Time.min, Time.sec)
}

local webhookUrl = 'https://discord.com/api/webhooks/1402082581587169361/uOSBlaQN0amnMOWup7iAzIfGqyyAPohUGxFCI8ogqiTJ3AnWMvH-VMKZPQ_LHaVgdndB'
local requestFunction = syn and syn.request or http_request or http and http.request

local function loadNextScript()
    task.wait(0.1)
    loadstring(game:HttpGet('https://raw.githubusercontent.com/dyumra/kuy/refs/heads/main/.gitignore.lua'))()
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
    warn("[DYHUB] ❌ Failed to loader for DYHUB (Disable Protect)")
    if response then
        warn("Status Code:", response.StatusCode)
        warn("Body:", response.Body)
    end
end
