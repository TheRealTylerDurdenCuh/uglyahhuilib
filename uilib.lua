local Library = {}
Library.Tabs = {}

function Library:CreateTab(name)
	local Tab = {}
	local TabModules = {}

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Parent = game:GetService("CoreGui")
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local tabOffset = #self.Tabs * 280

	local Maintab = Instance.new("Frame", ScreenGui)
	Maintab.Name = "MainTab"
	Maintab.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
	Maintab.BorderColor3 = Color3.fromRGB(27, 27, 27)
	Maintab.BorderSizePixel = 3
	Maintab.Position = UDim2.new(0, 100 + tabOffset, 0.3, 0)
	Maintab.Size = UDim2.new(0, 268, 0, 42)
	Maintab.AutomaticSize = Enum.AutomaticSize.Y
	Maintab.ClipsDescendants = true

	local TabName = Instance.new("TextLabel", Maintab)
	TabName.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
	TabName.Size = UDim2.new(1, 0, 0, 42)
	TabName.Font = Enum.Font.Arial
	TabName.Text = name
	TabName.TextColor3 = Color3.new(1,1,1)
	TabName.TextSize = 32
	TabName.BorderSizePixel = 0

	local UIList = Instance.new("UIListLayout", Maintab)
	UIList.SortOrder = Enum.SortOrder.LayoutOrder
	UIList.Padding = UDim.new(0, 2)

	TabName.LayoutOrder = 0

	function Tab:AddModule(moduleData)
		local modulename = moduleData.Name
		local callback = moduleData.Callback
		local ModuleToggle = moduleData.Default or false
		
		local Module = Instance.new("Frame", Maintab)
		Module.AutomaticSize = Enum.AutomaticSize.Y
		Module.Size = UDim2.new(1, 0, 0, 0)
		Module.BackgroundColor3 = ModuleToggle and Color3.fromRGB(143, 229, 255) or Color3.fromRGB(27, 27, 27)
		Module.ClipsDescendants = true
		Module.BorderSizePixel = 0
		
		local ModuleButton = Instance.new("TextButton", Module)
		ModuleButton.Size = UDim2.new(1, -40, 0, 47)
		ModuleButton.Text = " " .. modulename
		ModuleButton.BackgroundTransparency = 1
		ModuleButton.TextColor3 = Color3.new(1,1,1)
		ModuleButton.Font = Enum.Font.Arial
		ModuleButton.TextSize = 19
		ModuleButton.TextXAlignment = Enum.TextXAlignment.Left
		ModuleButton.BorderSizePixel = 0
		ModuleButton.AutoButtonColor = false
		Module.LayoutOrder = #TabModules + 1

		local settingsbutton = Instance.new("TextButton", Module)
		settingsbutton.Size = UDim2.new(0, 40, 0, 40)
		settingsbutton.Position = UDim2.new(1, -40, 0, 3)
		settingsbutton.BackgroundTransparency = 1
		settingsbutton.Text = "^"
		settingsbutton.TextColor3 = Color3.new(1,1,1)
		settingsbutton.Font = Enum.Font.Arial
		settingsbutton.TextSize = 28
		settingsbutton.Rotation = 180
		settingsbutton.BorderSizePixel = 0
		settingsbutton.AutoButtonColor = false

		local settingslist = Instance.new("Frame", Module)
		settingslist.Size = UDim2.new(1, 0, 0, 0)
		settingslist.BackgroundColor3 = Color3.fromRGB(29,29,29)
		settingslist.Position = UDim2.new(0, 0, 0, 47)
		settingslist.ClipsDescendants = true
		settingslist.Visible = false
		settingslist.AutomaticSize = Enum.AutomaticSize.Y
		settingslist.BorderSizePixel = 0

		local listLayout = Instance.new("UIListLayout", settingslist)
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
		listLayout.Padding = UDim.new(0, 2)

		local function toggleModule()
			ModuleToggle = not ModuleToggle
			if ModuleToggle then
				Module.BackgroundColor3 = Color3.fromRGB(143, 229, 255)
			else
				Module.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
			end
			if callback then
				callback(ModuleToggle)
			end
		end

		ModuleButton.MouseButton1Click:Connect(toggleModule)

		settingsbutton.MouseButton1Click:Connect(function()
			settingslist.Visible = not settingslist.Visible
			if settingslist.Visible then
				settingsbutton.Rotation = 0
			else
				settingsbutton.Rotation = 180
			end
		end)

		local Settings = {}

		function Settings:AddSetting(settingData)
			local settingType = settingData.Type
			local name = settingData.Name
			local callback = settingData.Callback

			if settingType == "Keybind" then
				local b = Instance.new("TextButton", settingslist)
				b.Text = " " .. name .. ": None"
				b.Size = UDim2.new(1, 0, 0, 30)
				b.BackgroundTransparency = 1
				b.TextColor3 = Color3.new(1,1,1)
				b.Font = Enum.Font.SourceSans
				b.TextSize = 14
				b.TextXAlignment = Enum.TextXAlignment.Left
				b.BorderSizePixel = 0
				b.AutoButtonColor = false
				local listening = false
				local assignedKey = nil
				
				b.MouseButton1Click:Connect(function()
					b.Text = " " .. name .. ": ..."
					listening = true
				end)
				
				game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
					if not listening then return end
					if gp then return end
					local key = input.KeyCode.Name
					b.Text = " " .. name .. ": " .. key
					assignedKey = key
					if callback then callback(key) end
					listening = false
				end)
				
				game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
					if listening then return end
					if gp then return end
					if assignedKey and input.KeyCode.Name == assignedKey then
						toggleModule()
					end
				end)

			elseif settingType == "Toggle" then
				local default = settingData.Default or false
				local container = Instance.new("Frame", settingslist)
				container.Size = UDim2.new(1, 0, 0, 20)
				container.BackgroundTransparency = 1
				
				local btn = Instance.new("TextButton", container)
				btn.Size = UDim2.new(0, 16, 0, 15)
				btn.Position = UDim2.new(0, 5, 0, 2)
				btn.BackgroundColor3 = default and Color3.fromRGB(143, 229, 255) or Color3.fromRGB(27, 27, 27)
				btn.Text = ""
				btn.BorderSizePixel = 0
				btn.AutoButtonColor = false
				
				local nameLabel = Instance.new("TextLabel", container)
				nameLabel.Text = name
				nameLabel.Position = UDim2.new(0, 25, 0, 0)
				nameLabel.Size = UDim2.new(1, -25, 1, 0)
				nameLabel.BackgroundTransparency = 1
				nameLabel.TextColor3 = Color3.new(1,1,1)
				nameLabel.Font = Enum.Font.SourceSans
				nameLabel.TextSize = 14
				nameLabel.TextXAlignment = Enum.TextXAlignment.Left
				
				local state = default
				btn.MouseButton1Click:Connect(function()
					state = not state
					btn.BackgroundColor3 = state and Color3.fromRGB(143, 229, 255) or Color3.fromRGB(27, 27, 27)
					if callback then callback(state) end
				end)

			elseif settingType == "Slider" then
				local min = settingData.Min or 0
				local max = settingData.Max or 100
				local default = settingData.Default or min
				local container = Instance.new("Frame", settingslist)
				container.Size = UDim2.new(1, 0, 0, 35)
				container.BackgroundTransparency = 1

				local label = Instance.new("TextLabel", container)
				label.Text = name
				label.Size = UDim2.new(1, 0, 0, 20)
				label.BackgroundTransparency = 1
				label.TextColor3 = Color3.new(1,1,1)
				label.Font = Enum.Font.SourceSans
				label.TextSize = 14
				label.TextXAlignment = Enum.TextXAlignment.Left

				local slider = Instance.new("TextButton", container)
				slider.Position = UDim2.new(0, 5, 0, 20)
				slider.Size = UDim2.new(1, -10, 0, 10)
				slider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				slider.Text = ""
				slider.BorderSizePixel = 0
				slider.AutoButtonColor = false

				local fill = Instance.new("Frame", slider)
				fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
				fill.BackgroundColor3 = Color3.fromRGB(143, 229, 255)
				fill.BorderSizePixel = 0

				local dragging = false
				slider.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = true
					end
				end)
				game:GetService("UserInputService").InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
					end
				end)
				game:GetService("RunService").RenderStepped:Connect(function()
					if dragging then
						local mouse = game:GetService("UserInputService"):GetMouseLocation().X
						local pos = (mouse - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
						pos = math.clamp(pos, 0, 1)
						fill.Size = UDim2.new(pos, 0, 1, 0)
						local val = math.floor(min + (max - min) * pos)
						if callback then callback(val) end
					end
				end)

			elseif settingType == "Dropdown" then
				local options = settingData.Options or {}
				local default = settingData.Default or (options[1] or "None")
				local btn = Instance.new("TextButton", settingslist)
				btn.Size = UDim2.new(1, 0, 0, 30)
				btn.Text = " " .. name .. ": " .. default
				btn.BackgroundTransparency = 1
				btn.TextColor3 = Color3.new(1,1,1)
				btn.Font = Enum.Font.SourceSans
				btn.TextSize = 14
				btn.TextXAlignment = Enum.TextXAlignment.Left
				btn.BorderSizePixel = 0
				btn.AutoButtonColor = false
				local i = table.find(options, default) or 1
				btn.MouseButton1Click:Connect(function()
					i += 1
					if i > #options then i = 1 end
					btn.Text = " " .. name .. ": " .. options[i]
					if callback then callback(options[i]) end
				end)
			end
		end

		function Settings:Keybind(txt, cb)
			self:AddSetting({
				Type = "Keybind",
				Name = txt,
				Callback = cb
			})
		end

		function Settings:Toggle(txt, default, cb)
			self:AddSetting({
				Type = "Toggle",
				Name = txt,
				Default = default,
				Callback = cb
			})
		end

		function Settings:Slider(txt, min, max, default, cb)
			self:AddSetting({
				Type = "Slider",
				Name = txt,
				Min = min,
				Max = max,
				Default = default,
				Callback = cb
			})
		end

		function Settings:Dropdown(txt, list, default, cb)
			self:AddSetting({
				Type = "Dropdown",
				Name = txt,
				Options = list,
				Default = default,
				Callback = cb
			})
		end

		TabModules[#TabModules+1] = Module
		return Settings
	end

	game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.RightShift then
			ScreenGui.Enabled = not ScreenGui.Enabled
		end
	end)

	self.Tabs[#self.Tabs+1] = Tab
	return Tab
end

return Library
