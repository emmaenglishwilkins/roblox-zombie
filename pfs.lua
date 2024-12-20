local zombie = script.Parent
local humanoid = zombie:WaitForChild("Humanoid")

local animator = zombie:WaitForChild("Humanoid"):FindFirstChildOfClass("Animator")
local anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://616163682"
local track = animator:LoadAnimation(anim)
track.Looped = true
track:Play()

local hd = Instance.new("HumanoidDescription")
hd.Face = 173789114
hd.HeadColor = Color3.new(0, 0.5, 0)
hd.RightArmColor = Color3.new(0, 0.5, 0)
hd.LeftArmColor = Color3.new(0, 0.5, 0)

humanoid:ApplyDescription(hd)

local PFS = game:GetService("PathfindingService")
local RUNSERVICE = game:GetService("RunService")
local players = game:GetService("Players")
-------------------------
local clone = zombie:Clone()
clone.Parent = game.ReplicatedStorage

local function respawn()
	wait(3)
	clone.Parent = zombie.Parent
end
----------------------------
function findTarget()
	local max = 100
	local target = nil
	local currentPlayers = players:GetPlayers()

	for i,player in pairs(currentPlayers) do
		local distance = player:DistanceFromCharacter(zombie.PrimaryPart.Position)
		if distance < max then
			max = distance
			target = player
		end
	end
	return target
end


local function getPath(dest)
	local path = PFS:CreatePath()
	path:ComputeAsync(zombie:WaitForChild("HumanoidRootPart").Position, dest)
	return path
end

local function pathFindTo(dest)
	local path = getPath(dest)
	local target = findTarget()
	if target then
		for i,waypoint in pairs(path:GetWaypoints()) do			
			zombie.Humanoid:MoveTo(waypoint.Position)
			zombie.Humanoid.MoveToFinished:Wait()
		end
	end
end

local function attack(part)
	local player = part.Parent
	local humanoid = player:FindFirstChildWhichIsA("Humanoid")
	
	if humanoid then
		humanoid.Health = humanoid.Health - 1
	end
end

zombie.HumanoidRootPart.Touched:Connect(attack)

RUNSERVICE.Heartbeat:Connect(function()	
	local target = findTarget()
	if target then
		pathFindTo(target.Character:WaitForChild("HumanoidRootPart").Position)
	end
	respawn()
end)