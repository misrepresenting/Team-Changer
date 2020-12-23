local Teams = game:GetService("Teams")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Module = {}

function Module.FindAvailableTeams()
	local AvailableTeams = {}
	
	for _, Part in ipairs(workspace:GetDescendants()) do
		if (Part:IsA("SpawnLocation") and Part.AllowTeamChangeOnTouch) then -- find team, should we get only one spawn or not
			local Color = Part.TeamColor
			
			for _, Team in ipairs(Teams:GetChildren()) do
				if (Team.TeamColor == Color and not AvailableTeams[Team]) then
					AvailableTeams[Team] = Part
				end
			end
		end
	end
	
	return AvailableTeams
end

function Module.ChangeTeam(SpawnPoint)
	local Decal = SpawnPoint:FindFirstChildOfClass("Decal")
	
	local function MoveSpawn()
		local Clone = SpawnPoint:Clone()
		
		SpawnPoint.CanCollide = false
		SpawnPoint.Transparency = 1
		SpawnPoint.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
		wait()
		SpawnPoint.CFrame = Clone.CFrame
		SpawnPoint.Transparency = Clone.Transparency
		SpawnPoint.CanCollide = Clone.CanCollide
		
		Clone:Destroy()
	end
	
	if (Decal) then
		local DecalTransparency = Decal.Transparency
		
		Decal.Transparency = 1
		MoveSpawn()
		Decal.Transparency = DecalTransparency
	else
		MoveSpawn()
	end
end

return Module
