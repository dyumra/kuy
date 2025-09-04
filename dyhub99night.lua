if not game:IsLoaded() then game.Loaded:Wait() end
if not game:IsLoaded() then repeat task.wait() until game:IsLoaded() end

if getgenv().RunScript == true then return end
getgenv().RunScript = true

getgenv().WebhookURL = "https://discord.com/api/webhooks/1413180796143013920/9ZOx_ukN2ucZGdQUmkITMUpQPzQgZWruKtDw8ebmYiSWkWjfN7Lp8fQew9_9KBaLYajV"
getgenv().AutoFarm = true
getgenv().hop = "old"
loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/kuy/refs/heads/main/F99D.lua"))()

local queueScript = [[
getgenv().WebhookURL = "https://discord.com/api/webhooks/1413180796143013920/9ZOx_ukN2ucZGdQUmkITMUpQPzQgZWruKtDw8ebmYiSWkWjfN7Lp8fQew9_9KBaLYajV"
getgenv().AutoFarm = true
getgenv().hop = "old"
loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/kuy/refs/heads/main/F99D.lua"))()
]]
queue_on_teleport(queueScript)
