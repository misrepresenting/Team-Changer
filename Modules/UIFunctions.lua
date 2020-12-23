local Module = {}
local CantMove = {}

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TextService = game:GetService("TextService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local CoreGui = game:GetService("CoreGui")

function Module.Tween(Object, Style, Direction, Time, Goal)
	local TInfo = TweenInfo.new(Time, Enum.EasingStyle[Style], Enum.EasingDirection[Direction])
	local Tween = TweenService:Create(Object, TInfo, Goal)

	Tween:Play()

	return Tween
end

function Module.MultColor3(Color, Delta)
	return Color3.new(math.clamp(Color.R * Delta, 0, 1), math.clamp(Color.G * Delta, 0, 1), math.clamp(Color.B * Delta, 0, 1))
end

function Module.Click(Object, Goal) -- Module.Click(Object, "BackgroundColor3")
	local Hover = {
		[Goal] = Module.MultColor3(Object[Goal], 0.9)
	}
	
	local Press = {
		[Goal] = Module.MultColor3(Object[Goal], 1.2)
	}
	
	local Origin = {
		[Goal] = Object[Goal]
	}

	Object.MouseEnter:Connect(function()
		Module.Tween(Object, "Sine", "Out", .5, Hover)
	end)
	
	Object.MouseLeave:Connect(function()
		Module.Tween(Object, "Sine", "Out", .5, Origin)
	end)
	
	Object.MouseButton1Down:Connect(function()
		Module.Tween(Object, "Sine", "Out", .3, Press)
	end)
	
	Object.MouseButton1Up:Connect(function()
		Module.Tween(Object, "Sine", "Out", .4, Hover)
	end)
end

function Module.Draggable(Ui, DragUi)
	local UIS = game:GetService("UserInputService")
	local DragSpeed = 0
	local StartPos
	local DragToggle, DragInput, DragStart, DragPos = nil
	
	if not DragUi then DragUi = Ui end
	
	local function UpdateInput(Input)
		local Delta = Input.Position - DragStart
		local Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
		
		Module.Tween(Ui, "Linear", "Out", .25, {
			Position = Position
		})
	end
	
	Ui.InputBegan:Connect(function(Input)
		if ((Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and UIS:GetFocusedTextBox() == nil) then
			DragToggle = true
			DragStart = Input.Position
			StartPos = Ui.Position
			
			local Objects = CoreGui:GetGuiObjectsAtPosition(DragStart.X, DragStart.Y)

			for _, v in ipairs(Objects) do
				if (v == CantMove[v]) then
					DragToggle = false
				end
			end
			
			Input.Changed:Connect(function()
				if (Input.UserInputState == Enum.UserInputState.End) then
					DragToggle = false
				end
			end)
		end
	end)
	
	Ui.InputChanged:Connect(function(Input)
		if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
			DragInput = Input
		end
	end)
	
	UIS.InputChanged:Connect(function(Input)
		if (Input == DragInput and DragToggle) then
			UpdateInput(Input)
		end
	end)
end

function Module.SmoothScroll(content, SmoothingFactor) -- by Elttob
	-- get the 'content' scrolling frame, aka the scrolling frame with all the content inside
	-- if smoothing is enabled, disable scrolling
	content.ScrollingEnabled = false

	-- create the 'input' scrolling frame, aka the scrolling frame which receives user input
	-- if smoothing is enabled, enable scrolling
	local input = content:Clone()

	input:ClearAllChildren()
	input.BackgroundTransparency = 1
	input.ScrollBarImageTransparency = 1
	input.ZIndex = content.ZIndex + 1
	input.Name = "_smoothinputframe"
	input.ScrollingEnabled = true
	input.Parent = content.Parent

	-- keep input frame in sync with content frame
	local function syncProperty(prop)
		content:GetPropertyChangedSignal(prop):Connect(function()
			if prop == "ZIndex" then
				-- keep the input frame on top!
				input[prop] = content[prop] + 1
			else
				input[prop] = content[prop]
			end
		end)
	end

	syncProperty "CanvasSize"
	syncProperty "Position"
	syncProperty "Rotation"
	syncProperty "ScrollingDirection"
	syncProperty "ScrollBarThickness"
	syncProperty "BorderSizePixel"
	syncProperty "ElasticBehavior"
	syncProperty "SizeConstraint"
	syncProperty "ZIndex"
	syncProperty "BorderColor3"
	syncProperty "Size"
	syncProperty "AnchorPoint"
	syncProperty "Visible"

	-- create a render stepped connection to interpolate the content frame position to the input frame position
	local smoothConnection = RunService.RenderStepped:Connect(function()
		local a = content.CanvasPosition
		local b = input.CanvasPosition
		local c = SmoothingFactor
		local d = (b - a) * c + a

		content.CanvasPosition = d
	end)

	-- destroy everything when the frame is destroyed
	content.AncestryChanged:Connect(function()
		if content.Parent == nil then
			input:Destroy()
			smoothConnection:Disconnect()
		end
	end)
end

return Module
