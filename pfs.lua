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

RUNSERVICE.Heartbeat:Connect(function()	
	local target = findTarget()
	if target then
		pathFindTo(target.Character:WaitForChild("HumanoidRootPart").Position)
	end
	if not isAlive() then
		humanoid.DisplayDistanceType = "None"
		wait(20)
		zombie:Destroy()
	end
end)
