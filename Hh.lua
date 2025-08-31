getgenv().aimbot = getgenv().aimbot or true
getgenv().prediction = getgenv().prediction or 4

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local humanoid, hrp

local aimDuration = 1.7
local aimTargets = { "Jason", "c00lkidd", "JohnDoe", "1x1x1x1", "Noli" }
local trackedAnimations = {
    ["103601716322988"] = true,
    ["133491532453922"] = true,
    ["86371356500204"] = true,
    ["76649505662612"] = true,
    ["81698196845041"] = true
}

local aiming, lastTrigger = false, 0
local ws, jp, autoRotate

local function setupChar(char)
    humanoid = char:WaitForChild("Humanoid")
    hrp = char:WaitForChild("HumanoidRootPart")
end
if lp.Character then setupChar(lp.Character) end
lp.CharacterAdded:Connect(setupChar)

local function getTarget()
    local killers = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
    if killers then
        for _, name in ipairs(aimTargets) do
            local t = killers:FindFirstChild(name)
            if t and t:FindFirstChild("HumanoidRootPart") then
                return t.HumanoidRootPart
            end
        end
    end
end

local function playingAnims()
    local ids = {}
    if humanoid then
        for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
            local id = track.Animation.AnimationId:match("%d+")
            if id then ids[id] = true end
        end
    end
    return ids
end

RunService.RenderStepped:Connect(function()
    if not getgenv().aimbot or not humanoid or not hrp then return end
    local activeAnim = playingAnims()
    for id in pairs(trackedAnimations) do
        if activeAnim[id] then
            lastTrigger = tick()
            aiming = true
            break
        end
    end
    if aiming and tick() - lastTrigger <= aimDuration then
        if not ws then
            ws, jp, autoRotate = humanoid.WalkSpeed, humanoid.JumpPower, humanoid.AutoRotate
        end
        humanoid.AutoRotate = false
        hrp.AssemblyAngularVelocity = Vector3.zero
        local t = getTarget()
        if t then
            local predicted = t.Position + (t.CFrame.LookVector * (getgenv().prediction or 0))
            local dir = (predicted - hrp.Position).Unit
            local yRot = math.atan2(-dir.X, -dir.Z)
            hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, yRot, 0)
        end
    elseif aiming then
        aiming = false
        if ws and jp and autoRotate ~= nil then
            humanoid.WalkSpeed, humanoid.JumpPower, humanoid.AutoRotate = ws, jp, autoRotate
            ws, jp, autoRotate = nil, nil, nil
        end
    end
end)
