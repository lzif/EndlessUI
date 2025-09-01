--[[
    Window.lua
    Handles the creation and management of individual windows.
]]

local Window = {}
Window.__index = Window

local create = require(script.Parent.Parent.Utility.create)

-- Constants
local HEADER_HEIGHT = 32
local MIN_SIZE = UDim2.new(0, 250, 0, 200)

function Window.new(options, parentGui, theme)
    local self = setmetatable({}, Window)

    self.Name = options.Name
    self.Icon = options.Icon
    self.Visible = false
    self.Tabs = {}
    self.ActiveTab = nil

    -- Main Frame
    self.Frame = create "Frame" {
        Name = self.Name,
        Size = UDim2.new(0, 500, 0, 300),
        MinSize = MIN_SIZE,
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = theme.Foreground,
        BorderSizePixel = 1,
        BorderColor3 = theme.Border,
        Visible = self.Visible,
        Parent = parentGui,
        ClipsDescendants = true,
    }
    create "UICorner" { CornerRadius = UDim.new(0, 6), Parent = self.Frame }

    -- Header
    local Header = create "Frame" {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
        BackgroundColor3 = theme.Background,
        Parent = self.Frame
    }

    -- Title
    local Title = create "TextLabel" {
        Name = "Title",
        Size = UDim2.new(1, -HEADER_HEIGHT * 3, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        Text = self.Name,
        TextColor3 = theme.Text,
        Font = Enum.Font.SourceSansBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Parent = Header
    }

    -- Tab Container
    self.TabContainer = create "Frame" {
        Name = "TabContainer",
        Size = UDim2.new(1, 0, 1, -HEADER_HEIGHT),
        Position = UDim2.new(0, 0, 0, HEADER_HEIGHT),
        BackgroundTransparency = 1,
        Parent = self.Frame
    }

    -- Dragging Logic
    local dragging = false
    local dragStart
    local startPos

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.Frame.Position
            self.Frame.ZIndex = self.Frame.ZIndex + 1
        end
    end)

    Header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            self.Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Public Methods
    function self:Toggle()
        self.Visible = not self.Visible
        self.Frame.Visible = self.Visible
        if self.Visible then
            self.Frame.ZIndex = self.Frame.ZIndex + 1
        end
    end

    function self:Show()
        self.Visible = true
        self.Frame.Visible = true
        self.Frame.ZIndex = self.Frame.ZIndex + 1
    end

    function self:Hide()
        self.Visible = false
        self.Frame.Visible = false
    end

    function self:CreateTab(tabName)
        -- Placeholder for Tab creation
        local Tab = create "Frame" {
            Name = tabName,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false, -- Only one tab visible at a time
            Parent = self.TabContainer
        }
        
        local tabObject = { Frame = Tab }
        function tabObject:CreateSection(sectionName)
            -- Placeholder for Section creation
            local Section = create "Frame" {
                Name = sectionName,
                Size = UDim2.new(1, -24, 0, 100), -- Example size
                Position = UDim2.fromOffset(12, 12),
                BackgroundTransparency = 1,
                Parent = Tab
            }
            -- This would return a section object with methods to add elements
            return Section 
        end

        table.insert(self.Tabs, tabObject)
        
        -- Auto-show the first tab
        if not self.ActiveTab then
            self.ActiveTab = tabObject
            tabObject.Frame.Visible = true
        end

        return tabObject
    end

    -- Auto-destroy if parent is removed
    self.Frame.AncestryChanged:Connect(function(_, parent)
        if not parent then
            -- Clean up connections, etc.
            -- For now, just prints
            print(self.Name .. " window cleaned up.")
        end
    end)

    return self
end

return Window
