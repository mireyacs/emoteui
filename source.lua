if EMOTELOADED then
	return
end

pcall(function() getgenv().EMOTELOADED = true end)

function randomString()
	local length = math.random(10,20)
	local array = {}
	for i = 1, length do
		array[i] = string.char(math.random(32, 126))
	end
	return table.concat(array)
end

local emotes = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://api.infiniteyieldreborn.xyz/fetch-items", true))

function closegui()
	GUIENABLED = false
	task.spawn(function()
		JUSTCLICKEDEXIT = true
		task.wait(0.1)
		JUSTCLICKEDEXIT = false
	end)
	task.wait()
	EMOTEPARENT.Visible = false
end

BACKUP = Instance.new("Folder")
local humanoid = game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
EMOTEPARENT = game:GetService("CoreGui").RobloxGui:WaitForChild("EmotesMenu").Main.EmotesWheel
local isplayingemote = false
function createEmoteButton(emote)
	local button = Instance.new("TextButton")
	button.Text = emote.name
	button.Font = Enum.Font.Arial
	button.BackgroundTransparency = 0.5
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextScaled = true
	button.ZIndex = 2
	button.Parent = SCROLLINGFRAME
	button.MouseButton1Click:Connect(function()	
		if animation then
			animation:Stop()
		end
		for _, v in ipairs(humanoid:GetPlayingAnimationTracks()) do
			v:Stop()
		end
		local emotea = Instance.new("Animation")
		emotea.AnimationId = "rbxassetid://"..emote.id
		animation = humanoid:LoadAnimation(emotea)
		animation:Play()
		isplayingemote = true
		closegui()
	end)
end

function changeemotewheel()
	game.Players.LocalPlayer.Character:FindFirstChild("Animate"):FindFirstChild("PlayEmote").Name = randomString()
	task.wait(.5)
	EMOTEPARENT.Parent.Parent.ErrorMessage:Destroy()
	BACKUP.Name = randomString()
	BACKUP.Parent = game:GetService("CoreGui")
	
	for _,v in pairs(EMOTEPARENT:GetChildren()) do
		v.Parent = BACKUP
	end
	MAIN = Instance.new("Frame")
	MAIN.Size = UDim2.new(1,0,1,0)
	MAIN.BackgroundColor3 = Color3.fromRGB(25,25,25)
	MAIN.ZIndex = 2
	MAIN.Name = randomString()
	MAIN.Parent = EMOTEPARENT
	ROUNDUI = Instance.new("UICorner")
	ROUNDUI.CornerRadius = UDim.new(0.02,0)
	ROUNDUI.Parent = MAIN
	PADDINGUI = Instance.new("UIPadding")
	PADDINGUI.PaddingTop = UDim.new(0,5)
	PADDINGUI.PaddingLeft = UDim.new(0,5)
	PADDINGUI.PaddingRight = UDim.new(0,5)
	PADDINGUI.PaddingBottom = UDim.new(0,5)
	PADDINGUI.Parent = MAIN
	TEXT = Instance.new("TextLabel")
	TEXT.Text = "Emotes"
	TEXT.Font = Enum.Font.Arial
	TEXT.BackgroundTransparency = 1
	TEXT.TextColor3 = Color3.new(1,1,1)
	TEXT.TextScaled = true
	TEXT.TextXAlignment = Enum.TextXAlignment.Left
	TEXT.ZIndex = 2
	TEXT.Size = UDim2.new(0.2,0,0.05,0)
	TEXT.Parent = MAIN
	SCROLLINGFRAME = Instance.new("ScrollingFrame")
	SCROLLINGFRAME.ZIndex = 2
	SCROLLINGFRAME.Size = UDim2.new(1,0,0.94,0)
	SCROLLINGFRAME.Position = UDim2.new(0,0,0.06,0)
	SCROLLINGFRAME.BackgroundColor3 = Color3.fromRGB(40,40,40)
	SCROLLINGFRAME.BorderSizePixel = 0
	SCROLLINGFRAME.CanvasSize = UDim2.new(0, 0, 0, 0)
	SCROLLINGFRAME.Parent = MAIN
	GUIENABLED = false
	JUSTCLICKEDEXIT = false
	EXITBUTTON = Instance.new("TextButton")
	EXITBUTTON.Text = "X"
	EXITBUTTON.Font = Enum.Font.Arial
	EXITBUTTON.BackgroundTransparency = 1
	EXITBUTTON.TextColor3 = Color3.new(1,1,1)
	EXITBUTTON.TextScaled = true
	EXITBUTTON.ZIndex = 2
	EXITBUTTON.Size = UDim2.new(0.05,0,0.05,0)
	EXITBUTTON.Position = UDim2.new(0.95,0,0,0)
	EXITBUTTON.Parent = MAIN
	EXITBUTTON.TouchTap:Connect(function()
		closegui()
	end)
	EXITBUTTON.MouseButton1Click:Connect(function()
		closegui()
	end)
	UIGRID = Instance.new("UIGridLayout")
	UIGRID.CellPadding = UDim2.new(0,5,0,5)
	UIGRID.CellSize = UDim2.new(0,380,0,20)
	UIGRID.Parent = SCROLLINGFRAME
	EMOTEPARENT:GetPropertyChangedSignal("Visible"):Connect(function()
		if JUSTCLICKEDEXIT or GUIENABLED then return end
		GUIENABLED = true
		task.spawn(function()
			while task.wait() do
				if GUIENABLED == false then
					break
				end
				if EMOTEPARENT.Visible == false then
					EMOTEPARENT.Visible = true
				end
			end
		end)
	end)
	for _, emote in pairs(emotes) do
		createEmoteButton(emote)
	end
	SCROLLINGFRAME.CanvasSize = UDim2.new(0,0,0,UIGRID.AbsoluteContentSize.Y)
end
changeemotewheel()
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(character)
	if character:WaitForChild("Animate") then
		EMOTEPARENT = game:GetService("CoreGui").RobloxGui:WaitForChild("EmotesMenu"):WaitForChild("Main"):WaitForChild("EmotesWheel")
		changeemotewheel()
		humanoid = character:FindFirstChild("Humanoid")
	end
end)

task.spawn(function()
	while task.wait() do
		if humanoid.Jump== true and isplayingemote == true then
			isplayingemote = false
			animation:Stop()
		end
		if humanoid.MoveDirection ~= Vector3.new(0,0,0) and isplayingemote == true then
			isplayingemote = false
			animation:Stop()
		end
	end
end)
