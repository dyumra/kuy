repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function kickIfNoCredit()
    local credit = getgenv().DYHUBTHEBEST
    if type(credit) ~= "string" or credit ~= "Join our (dsc.gg/dyhub)" then
        LocalPlayer:Kick("delete credit DYHUB?")
        return false
    end
    return true
end

if not kickIfNoCredit() then return end

local function applyHeadless(character)
    if getgenv().DYHUB_HEADLESS then
        local head = character:WaitForChild("Head")
        head.Transparency = 1
        spawn(function()
            local startTime = tick()
            while tick() - startTime < 3 do
                for _, v in pairs(head:GetChildren()) do
                    if v:IsA("Decal") then
                        v.Transparency = 1
                    end
                end
                task.wait(0.1)
            end
        end)
        head.ChildAdded:Connect(function(child)
            if child:IsA("Decal") then
                child.Transparency = 1
            end
        end)
    end
end

local function applyKorblox(character)
    if not getgenv().DYHUB_KORBLOX then return end
    local humanoid = character:WaitForChild("Humanoid")
    if humanoid then
        if humanoid.RigType == Enum.HumanoidRigType.R15 then
            local rightLower = character:FindFirstChild("RightLowerLeg")
            local rightUpper = character:FindFirstChild("RightUpperLeg")
            local rightFoot = character:FindFirstChild("RightFoot")
            if rightLower then
                rightLower.MeshId = "http://www.roblox.com/asset/?id=902942093"
                rightLower.Transparency = 1
            end
            if rightUpper then
                rightUpper.MeshId = "http://www.roblox.com/asset/?id=902942096"
                rightUpper.TextureID = "http://roblox.com/asset/?id=902843398"
            end
            if rightFoot then
                rightFoot.MeshId = "http://www.roblox.com/asset/?id=902942089"
                rightFoot.Transparency = 1
            end
        else
            local leg = character:FindFirstChild("Right Leg")
            if leg then
                leg.Transparency = 1
                if character:FindFirstChild("DYHUB_1") then
                    character.DYHUB_1:Destroy()
                end
                local part = Instance.new("Part")
                part.Name = "DYHUB_1"
                part.Size = Vector3.new(1, 2, 1)
                part.Anchored = false
                part.CanCollide = false
                part.Transparency = 0
                part.Position = leg.Position + Vector3.new(0, 0.75, 0)
                part.Parent = character
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = part
                weld.Part1 = leg
                weld.Parent = part
                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = "http://www.roblox.com/asset/?id=902942093"
                mesh.TextureId = "http://roblox.com/asset/?id=902843398"
                mesh.Scale = Vector3.new(0.85, 1.25, 0.85)
                mesh.Parent = part
            end
        end
    end
end

local function onCharacterAdded(character)
    character:WaitForChild("Humanoid")
    character:WaitForChild("Head")
    applyHeadless(character)
    applyKorblox(character)
end

if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
