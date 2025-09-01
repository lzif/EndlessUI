--[[
    ButtonGroup.lua
    Handles creation and management of screen-side button groups.
]]

local ButtonGroup = {}
ButtonGroup.__index = ButtonGroup

local create = require(script.Parent.Parent.Utility.create)
local Lucide = require(script.Parent.Parent.Vendor.Lucide)

-- Constants
local BUTTON_SIZE = 42
local ICON_SIZE = 24

function ButtonGroup.new(options, parentGui, theme)
    local self = setmetatable({}, ButtonGroup)

    self.Side = options.Side
    self.Position = options.Position or "center"
    self.Floating = options.Floating or false
    self.Gap = options.Gap or 8
    self.Buttons = {}

    local isVertical = self.Side == "left" or self.Side == "right"

    -- Main Frame
    self.Frame = create "Frame" {
        Name = "ButtonGroup_" .. self.Side,
        Size = UDim2.new(0, isVertical and BUTTON_SIZE or 0, 0, isVertical and 0 or BUTTON_SIZE),
        Position = self:_calculatePosition(),
        AnchorPoint = self:_calculateAnchorPoint(),
        BackgroundTransparency = 1,
        Parent = parentGui,
    }

    -- Layout
    local layout = create "UIListLayout" {
        FillDirection = isVertical and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, self.Gap),
        Parent = self.Frame
    }

    if self.Floating then
        self.Frame.BackgroundColor3 = theme.Foreground
        self.Frame.BorderSizePixel = 1
        self.Frame.BorderColor3 = theme.Border
        create "UICorner" { CornerRadius = UDim.new(0, 6), Parent = self.Frame }
        create "UIPadding" {
            PaddingTop = UDim.new(0, 4),
            PaddingBottom = UDim.new(0, 4),
            PaddingLeft = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 4),
            Parent = self.Frame
        }
    end

    return self
end

function ButtonGroup:_calculatePosition()
    local pos = self.Position
    if type(pos) == "string" and pos == "center" then
        if self.Side == "left" then return UDim2.fromScale(0, 0.5)
        elseif self.Side == "right" then return UDim2.fromScale(1, 0.5)
        elseif self.Side == "top" then return UDim2.fromScale(0.5, 0)
        end
    end
    
    if self.Side == "left" then return UDim2.new(0, 0, pos.Scale, pos.Offset)
    elseif self.Side == "right" then return UDim2.new(1, 0, pos.Scale, pos.Offset)
    elseif self.Side == "top" then return UDim2.new(pos.Scale, pos.Offset, 0, 0)
    end
    return UDim2.fromScale(0.5, 0.5) -- Fallback
end

function ButtonGroup:_calculateAnchorPoint()
    if self.Side == "left" then return Vector2.new(0, 0.5)
    elseif self.Side == "right" then return Vector2.new(1, 0.5)
    elseif self.Side == "top" then return Vector2.new(0.5, 0)
    end
    return Vector2.new(0.5, 0.5) -- Fallback
end

function ButtonGroup:CreateButton(options)
    assert(options.Callback, "Button requires a Callback function.")
    local hasIcon = options.Icon and true or false
    local hasText = options.Name and true or false

    local button = create "TextButton" {
        Name = options.Name or "Button",
        Text = hasText and not (hasIcon and not hasText) and options.Name or "",
        TextColor3 = theme.Text,
        Font = Enum.Font.SourceSans,
        TextSize = 14,
        BackgroundColor3 = theme.Foreground,
        Size = UDim2.new(0, BUTTON_SIZE, 0, BUTTON_SIZE),
        Parent = self.Frame,
        AutoButtonColor = false,
    }
    create "UICorner" { CornerRadius = UDim.new(0, 5), Parent = button }

    if hasIcon then
        local icon = create "ImageLabel" {
            Name = "Icon",
            Size = UDim2.fromOffset(ICON_SIZE, ICON_SIZE),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Image = Lucide[options.Icon] or "",
            ImageColor3 = theme.TextSecondary,
            Parent = button
        }
    end

    button.MouseButton1Click:Connect(options.Callback)
    table.insert(self.Buttons, button)
    self:_updateGroupLayout()
    return button
end

function ButtonGroup:_updateGroupLayout()
    local count = #self.Buttons
    local isVertical = self.Side == "left" or self.Side == "right"
    local totalSize = (count * BUTTON_SIZE) + ((count - 1) * self.Gap)
    
    if isVertical then
        self.Frame.Size = UDim2.new(0, BUTTON_SIZE, 0, totalSize)
    else
        self.Frame.Size = UDim2.new(0, totalSize, 0, BUTTON_SIZE)
    end
    
    -- Recalculate position to ensure it stays centered if needed
    self.Frame.Position = self:_calculatePosition()
end

return ButtonGroup
