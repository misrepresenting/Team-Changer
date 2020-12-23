local Players = game:GetService("Players")
local HTTPService = game:GetService("HttpService")
local TestService = game:GetService("TestService")

local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local function Import(Asset)
	if (type(Asset) == "number") then
		return game:GetObjects("rbxassetid://" .. Asset)[1]
	else
		local Link = string.format("https://raw.githubusercontent.com/misrepresenting/Team-Changer/main/Modules/%s", Asset)
		local Response = game:HttpGetAsync(Link)

		local Function = loadstring(Response)
		local Success, Return = pcall(Function)

		if (Success) then
			return Return
		else
			TestService:Error("[Infusa] (" .. Asset .. ")\n" .. Return)
		end
	end
end

local GUI = Import(6124164029)

local Main = GUI.Main
local Border = Main.Border
local Frame = Border.Frame
local ScrollingFrame = Frame.ScrollingFrame

local Padding = ScrollingFrame.UIListLayout.Padding.Offset

local UIFunctions = Import("UIFunctions.lua")
local TeamFunctions = Import("TeamFunctions.lua")
local ParentGui = Import("ParentGui.lua")
local Assets = GUI.Assets

ParentGui(GUI)
UIFunctions.Draggable(Main)
UIFunctions.SmoothScroll(ScrollingFrame, .14)

for Team, SpawnPoint in pairs(TeamFunctions.FindAvailableTeams()) do
	local TeamButton = Assets.Team:Clone()
	
	TeamButton.Name = Team.Name
	TeamButton.TeamName.Text = Team.Name .. ":"
	TeamButton.Color.BackgroundColor3 = Team.TeamColor.Color
	TeamButton.Visible = true
	TeamButton.Parent = ScrollingFrame
	
	UIFunctions.Click(TeamButton, "BackgroundColor3")
	TeamButton.MouseButton1Click:Connect(function()
		TeamFunctions.ChangeTeam(SpawnPoint)
	end)
	
	ScrollingFrame.CanvasSize = ScrollingFrame.CanvasSize + UDim2.fromOffset(0, TeamButton.Size.Y.Offset + Padding)
end
