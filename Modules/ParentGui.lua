local HTTPService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

return function(Gui)
	Gui.Name = HTTPService:GenerateGUID(false):gsub("-",""):sub(1,math.random(25,30))

	if ((not is_sirhurt_closure) and (syn and syn.protect_gui)) then
		syn.protect_gui(Gui)
		Gui.Parent = CoreGui
	elseif (get_hidden_gui or gethui) then
		local HiddenUI = get_hidden_gui or gethui
		Gui.Parent = HiddenUI
	elseif (CoreGui:FindFirstChild("RobloxGui")) then
		Gui.Parent = CoreGui.RobloxGui
	else
		Gui.Parent = CoreGui
	end

	return Gui
end
