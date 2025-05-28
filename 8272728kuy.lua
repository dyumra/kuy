local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

local character = player.Character or player.CharacterAdded:Wait()

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame
local frame = Instance.new("Frame")
frame.Name = "Main"
frame.Size = UDim2.new(0, 300, 0, 210)
frame.Position = UDim2.new(0.5, -150, 0.5, -105)
frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.BorderSizePixel = 3
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- TextBox
local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(0, 280, 0, 30)
nameBox.Position = UDim2.new(0, 10, 0, 10)
nameBox.PlaceholderText = "Name (Shortname or fullname)"
nameBox.Text = ""
nameBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
nameBox.TextColor3 = Color3.fromRGB(0, 0, 0)
nameBox.Parent = frame

-- Enter
local enterBtn = Instance.new("TextButton")
enterBtn.Size = UDim2.new(0, 135, 0, 30)
enterBtn.Position = UDim2.new(0, 10, 0, 50)
enterBtn.Text = "Enter"
enterBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
enterBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
enterBtn.BorderSizePixel = 2
enterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
enterBtn.Parent = frame

-- Loop
local loopBtn = Instance.new("TextButton")
loopBtn.Size = UDim2.new(0, 135, 0, 30)
loopBtn.Position = UDim2.new(0, 155, 0, 50)
loopBtn.Text = "Loop: OFF"
loopBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
loopBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
loopBtn.BorderSizePixel = 2
loopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
loopBtn.Parent = frame

-- Emote
local emoteBtn = Instance.new("TextButton")
emoteBtn.Size = UDim2.new(1, -20, 0, 30)
emoteBtn.Position = UDim2.new(0, 10, 0, 90)
emoteBtn.Text = "Spin Emote: OFF"
emoteBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
emoteBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
emoteBtn.BorderSizePixel = 2
emoteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
emoteBtn.Parent = frame

-- Death counter
local deathLabel = Instance.new("TextLabel")
deathLabel.Size = UDim2.new(1, -20, 0, 20)
deathLabel.Position = UDim2.new(0, 10, 0, 130)
deathLabel.Text = "Deaths: 0"
deathLabel.BackgroundTransparency = 1
deathLabel.TextColor3 = Color3.new(1, 1, 1)
deathLabel.TextScaled = true
deathLabel.Parent = frame

-- Notification
local notificationGui = Instance.new("TextLabel")
notificationGui.Size = UDim2.new(0, 250, 0, 40)
notificationGui.Position = UDim2.new(1, -260, 1, -60)
notificationGui.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
notificationGui.TextColor3 = Color3.fromRGB(255, 255, 255)
notificationGui.TextScaled = true
notificationGui.Text = ""
notificationGui.Visible = false
notificationGui.Parent = screenGui

-- notification 
local function notify(msg)
	notificationGui.Text = msg
	notificationGui.Visible = true
	wait(3)
	notificationGui.Visible = false
end

-- player shortname
local function findName(partialName)
	partialName = partialName:lower()
	for _, p in pairs(game.Players:GetPlayers()) do
		if p.Name:lower():sub(1, #partialName) == partialName then
			return p.Name
		end
	end
	return nil
end

-- smooth
local function smoothTeleportToPlayer(partialName)
	local foundName = findName(partialName)
	local targetPlayer = foundName and game.Players:FindFirstChild(foundName)

	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local targetHRP = targetPlayer.Character.HumanoidRootPart
		local myChar = player.Character or player.CharacterAdded:Wait()
		local myHRP = myChar:WaitForChild("HumanoidRootPart")

		local tween = tweenService:Create(myHRP, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			CFrame = targetHRP.CFrame + Vector3.new(0, 0, 0)
		})
		tween:Play()
	end
end

-- loop and death counter
local looping = false
local emoteSpinning = false
local deathCount = 0

loopBtn.MouseButton1Click:Connect(function()
	looping = not looping
	loopBtn.Text = looping and "Loop: ON" or "Loop: OFF"

	while looping do
		smoothTeleportToPlayer(nameBox.Text)
		wait(0.1)
	end
end)

enterBtn.MouseButton1Click:Connect(function()
	smoothTeleportToPlayer(nameBox.Text)
end)

emoteBtn.MouseButton1Click:Connect(function()
	emoteSpinning = not emoteSpinning
	emoteBtn.Text = emoteSpinning and "Spin Emote: ON" or "Spin Emote: OFF"

	if emoteSpinning then
		task.spawn(function()
			while emoteSpinning do
				local args = { { Goal = "Emote Spin" } }
				local char = player.Character or player.CharacterAdded:Wait()
				local communicate = char:WaitForChild("Communicate", 2)
				if communicate then
					communicate:FireServer(unpack(args))
				end
				task.wait(1)
			end
		end)
	end
end)

player.CharacterAdded:Connect(function(char)
	character = char
	deathCount += 1
	deathLabel.Text = "Deaths: " .. tostring(deathCount)

	if deathCount % 50 == 0 then
		notify("⚠ dead " .. deathCount .. " now!")
	end

	if looping then
		task.wait(1)
		task.spawn(function()
			while looping do
				smoothTeleportToPlayer(nameBox.Text)
				wait(0.1)
			end
		end)
	end

	if emoteSpinning then
		task.spawn(function()
			while emoteSpinning do
				local args = { { Goal = "Emote Spin" } }
				local communicate = char:WaitForChild("Communicate", 2)
				if communicate then
					communicate:FireServer(unpack(args))
				end
				wait(1)
			end
		end)
	end
end)
