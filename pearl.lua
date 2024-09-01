-- UI Library Code for Executors

local UILibrary = {}
UILibrary.__index = UILibrary

function UILibrary.new()
    local self = setmetatable({}, UILibrary)
    return self
end

function UILibrary:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomUILib"
    ScreenGui.ResetOnSpawn = false -- Ensure the GUI persists across respawns
    ScreenGui.Parent = game:GetService("StarterGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.Parent = ScreenGui
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Title.Text = title or "Window"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 18
    Title.Parent = MainFrame
    
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -10, 1, -50)
    Container.Position = UDim2.new(0, 5, 0, 45)
    Container.BackgroundTransparency = 1
    Container.Parent = MainFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = Container
    UIListLayout.Padding = UDim.new(0, 10)
    
    self.MainFrame = MainFrame
    self.Container = Container
    
    return self
end

function UILibrary:CreateToggle(name, default, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, 0, 0, 40)
    Toggle.Text = ""
    Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Toggle.Parent = self.Container
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -40, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 16
    Label.Parent = Toggle
    
    local ToggleButton = Instance.new("Frame")
    ToggleButton.Size = UDim2.new(0, 20, 0, 20)
    ToggleButton.Position = UDim2.new(1, -30, 0.5, -10)
    ToggleButton.BackgroundColor3 = default and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(80, 80, 80)
    ToggleButton.Parent = Toggle
    
    local Toggled = default
    
    Toggle.MouseButton1Click:Connect(function()
        Toggled = not Toggled
        ToggleButton.BackgroundColor3 = Toggled and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(80, 80, 80)
        if callback then callback(Toggled) end
    end)
end

function UILibrary:CreateTextbox(placeholder, callback)
    local Textbox = Instance.new("TextBox")
    Textbox.Size = UDim2.new(1, 0, 0, 40)
    Textbox.Text = ""
    Textbox.PlaceholderText = placeholder or "Enter text..."
    Textbox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
    Textbox.Font = Enum.Font.SourceSans
    Textbox.TextSize = 16
    Textbox.Parent = self.Container
    
    Textbox.FocusLost:Connect(function(enterPressed)
        if enterPressed and callback then
            callback(Textbox.Text)
        end
    end)
end

function UILibrary:CreateSlider(name, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 40)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SliderFrame.Parent = self.Container
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 16
    Label.Parent = SliderFrame
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -20, 0, 6)
    SliderBar.Position = UDim2.new(0, 10, 0.5, 10)
    SliderBar.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    SliderBar.Parent = SliderFrame
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 20, 0, 20)
    SliderButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    SliderButton.Parent = SliderBar
    
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

function UILibrary:CreateDropdown(name, options, callback)
    local Dropdown = Instance.new("TextButton")
    Dropdown.Size = UDim2.new(1, 0, 0, 40)
    Dropdown.Text = name
    Dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    Dropdown.Font = Enum.Font.SourceSans
    Dropdown.TextSize = 16
    Dropdown.Parent = self.Container
    
    local DropDownMenu = Instance.new("Frame")
    DropDownMenu.Size = UDim2.new(1, 0, 0, 0)
    DropDownMenu.Position = UDim2.new(0, 0, 1, 0)
    DropDownMenu.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    DropDownMenu.Visible = false
    DropDownMenu.ClipsDescendants = true
    DropDownMenu.Parent = Dropdown
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = DropDownMenu
    
    Dropdown.MouseButton1Click:Connect(function()
        DropDownMenu.Visible = not DropDownMenu.Visible
    end)
    
    for _, option in pairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, 0, 0, 30)
        OptionButton.Text = option
        OptionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptionButton.Font = Enum.Font.SourceSans
        OptionButton.TextSize = 16
        OptionButton.Parent = DropDownMenu
        
        OptionButton.MouseButton1Click:Connect(function()
            Dropdown.Text = option
            DropDownMenu.Visible = false
            if callback then callback(option) end
        end)
    end
end

function UILibrary:CreateKeybind(name, defaultKey, callback)
    local Keybind = Instance.new("TextButton")
    Keybind.Size = UDim2.new(1, 0, 0, 40)
    Keybind.Text = name .. " [" .. defaultKey.Name .. "]"
    Keybind.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Keybind.TextColor3 = Color3.fromRGB(255, 255, 255)
    Keybind.Font = Enum.Font.SourceSans
    Keybind.TextSize = 16
    Keybind.Parent = self.Container
    
    local UserInputService = game:GetService("UserInputService")
    local Key = defaultKey or Enum.KeyCode.Unknown
    
    Keybind.MouseButton1Click:Connect(function()
        local newKey = nil
        local listening = true
        
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if listening and input.UserInputType == Enum.UserInputType.Keyboard and not gameProcessed then
                newKey = input.KeyCode
                Keybind.Text = name .. " [" .. newKey.Name .. "]"
                listening = false
                if callback then callback(newKey) end
            end
        end)
    end)
end

return UILibrary
