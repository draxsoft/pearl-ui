-- UI Library Code for Executors

local UILibrary = {}
UILibrary.__index = UILibrary

function UILibrary.new()
    local self = setmetatable({}, UILibrary)
    return self
end

function UILibrary:createElement(type, properties, parent)
    local element = Instance.new(type)
    for key, value in pairs(properties) do
        element[key] = value
    end
    element.Parent = parent
    return element
end

function UILibrary:createWindow(title)
    local ScreenGui = self:createElement("ScreenGui", {Name = "CustomUILib", ResetOnSpawn = false}, game:GetService("StarterGui"))
    local MainFrame = self:createElement("Frame", {Size = UDim2.new(0, 300, 0, 400), Position = UDim2.new(0.5, -150, 0.5, -200), BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, ScreenGui)
    local Title = self:createElement("TextLabel", {Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Color3.fromRGB(40, 40, 40), Text = title or "Window", TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.SourceSansBold, TextSize = 18}, MainFrame)
    local Container = self:createElement("Frame", {Size = UDim2.new(1, -10, 1, -50), Position = UDim2.new(0, 5, 0, 45), BackgroundTransparency = 1}, MainFrame)
    local UIListLayout = self:createElement("UIListLayout", {Padding = UDim.new(0, 10)}, Container)
    
    self.MainFrame = MainFrame
    self.Container = Container
    
    return self
end

function UILibrary:createToggle(name, default, callback)
    local Toggle = self:createElement("TextButton", {Size = UDim2.new(1, 0, 0, 40), Text = "", BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, self.Container)
    local Label = self:createElement("TextLabel", {Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = name, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.SourceSans, TextSize = 16}, Toggle)
    local ToggleButton = self:createElement("Frame", {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -30, 0.5, -10), BackgroundColor3 = default and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(80, 80, 80)}, Toggle)
    
    local Toggled = default
    
    Toggle.MouseButton1Click:Connect(function()
        Toggled = not Toggled
        ToggleButton.BackgroundColor3 = Toggled and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(80, 80, 80)
        if callback then callback(Toggled) end
    end)
end

function UILibrary:createTextbox(placeholder, callback)
    local Textbox = self:createElement("TextBox", {Size = UDim2.new(1, 0, 0, 40), Text = "", PlaceholderText = placeholder or "Enter text...", BackgroundColor3 = Color3.fromRGB(40, 40, 40), TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.SourceSans, TextSize = 16}, self.Container)
    
    Textbox.FocusLost:Connect(function(enterPressed)
        if enterPressed and callback then
            callback(Textbox.Text)
        end
    end)
end

function UILibrary:createSlider(name, min, max, default, callback)
    local SliderFrame = self:createElement("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, self.Container)
    local Label = self:createElement("TextLabel", {Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = name, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.SourceSans, TextSize = 16}, SliderFrame)
    local SliderBar = self:createElement("Frame", {Size = UDim2.new(1, -20, 0, 6), Position = UDim2.new(0, 10, 0.5, 10), BackgroundColor3 = Color3.fromRGB(100, 100, 255)}, SliderFrame)
    local SliderButton = self:createElement("TextButton", {Size = UDim2.new(0, 20, 0, 20), BackgroundColor3 = Color3.fromRGB(100, 100, 255)}, SliderBar)
    
    local SliderValue = default or min
    local Sliding = false
    
    SliderButton.MouseButton1Down:Connect(function()
        Sliding = true
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if Sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
            local scale = (input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
            SliderValue = math.clamp(math.floor(scale * (max - min) + min), min, max)
            SliderButton.Position = UDim2.new(scale, -10, 0, -7)
            if callback then callback(SliderValue) end
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Sliding = false
        end
    end)
end

function UILibrary:createDropdown(name, options, callback)
    local Dropdown = self:createElement("TextButton", {Size = UDim2.new(1, 0, 0, 40), Text = name, BackgroundColor3 = Color3.fromRGB(40, 40, 40), TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.SourceSans, TextSize = 16}, self.Container)
    local DropDownMenu = self:createElement("Frame", {Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(50, 50, 50), Visible = false, ClipsDescendants = true}, Dropdown)
    local UIListLayout = self:createElement("UIListLayout", {}, DropDownMenu)
    
    Dropdown.MouseButton1Click:Connect(function()
        DropDownMenu.Visible = not DropDownMenu.Visible
    end)
    
    for _, option in pairs(options) do
        local OptionButton = self:createElement("TextButton", {Size = UDim2.new(1, 0, 0, 30), Text = option, BackgroundColor3 = Color3.fromRGB(40, 40, 40), TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.SourceSans, TextSize = 16}, DropDownMenu)
        
        OptionButton.MouseButton1Click:Connect(function()
            Dropdown.Text = option
            DropDownMenu.Visible = false
            if callback then callback(option) end
        end)
    end
end

function UILibrary:createKeybind(name, defaultKey, callback)
    local Keybind = self:createElement("TextButton", {Size = UDim2.new(1, 0, 0, 40), Text = name .. " [" .. (defaultKey.Name or "None") .. "]", BackgroundColor3 = Color3.fromRGB(40, 40, 40), TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.SourceSans, TextSize = 16}, self.Container)
    local UserInputService = game:GetService("UserInputService")
    local Key = defaultKey or Enum.KeyCode.Unknown
    
    Keybind.MouseButton1Click:Connect(function()
        Keybind.Text = name .. " [Press a key...]"
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                Key = input.KeyCode
                Keybind.Text = name .. " [" .. Key.Name .. "]"
                if callback then callback(Key) end
            end
        end)
    end)
end

return UILibrary
