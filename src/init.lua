--[[
    Main entry point for the UI Library.
    Handles the main ScreenGui, API, and initialization.
]]

local Library = {
    _windows = {},
    _buttonGroups = {},
    _theme = {
        Name = "Dark",
        Background = Color3.fromRGB(30, 30, 30),
        Foreground = Color3.fromRGB(45, 45, 45),
        Accent = Color3.fromRGB(70, 130, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 180),
        Border = Color3.fromRGB(60, 60, 60),
    }
}
Library.__index = Library

-- Core Modules
local Window = require(script.Core.Window)
local ButtonGroup = require(script.Core.ButtonGroup)

-- Services
local ThemeManager = require(script.Services.ThemeManager)
local HotkeyManager = require(script.Services.HotkeyManager)
local NotificationManager = require(script.Services.NotificationManager)
local ModalManager = require(script.Services.ModalManager)

-- Main UI Container
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "RobloxUILibrary"
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainGui.ResetOnSpawn = false

-- Function to get the main GUI, creating it if it doesn't exist
function Library.GetGui()
    if not MainGui.Parent then
        local coreGui = game:GetService("CoreGui")
        if coreGui then
            MainGui.Parent = coreGui
        else
            MainGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        end
    end
    return MainGui
end

-- Setup the library (optional)
function Library:Setup(config)
    if config and config.Theme then
        ThemeManager:SetTheme(config.Theme)
        self._theme = ThemeManager:GetTheme()
    end
end

-- Create a new Window
function Library:CreateWindow(options)
    assert(type(options) == "table", "Window options must be a table.")
    assert(options.Name, "Window requires a Name.")

    local gui = self.GetGui()
    local windowInstance = Window.new(options, gui, self._theme)
    
    table.insert(self._windows, windowInstance)
    return windowInstance
end

-- Create a new Button Group
function Library:CreateButtonGroup(options)
    if type(options) == "string" then
        options = { Side = options }
    end
    
    assert(type(options) == "table", "ButtonGroup options must be a table.")
    assert(options.Side, "ButtonGroup requires a Side ('left', 'right', or 'top').")

    local gui = self.GetGui()
    local groupInstance = ButtonGroup.new(options, gui, self._theme)

    table.insert(self._buttonGroups, groupInstance)
    return groupInstance
end

-- Bind a hotkey
function Library:Bind(options)
    HotkeyManager:Bind(options.Key, options.Callback)
end

-- Show a notification
function Library:Notify(options)
    local gui = self.GetGui()
    NotificationManager:Show(options, gui, self._theme)
end

-- Show a modal dialog
function Library:Dialog(options)
    local gui = self.GetGui()
    ModalManager:Show(options, gui, self._theme)
end

--[[
    Simple Progress Bar & Spinner (placeholders)
    A more robust implementation would be in its own module.
]]
function Library:CreateProgress(options)
    -- Placeholder for Progress Bar functionality
    warn("CreateProgress is not fully implemented yet.")
    local progress = {}
    function progress:Set(value)
        print(string.format("%s: %d/%d", options.Title or "Progress", value, options.Max or 100))
    end
    return progress
end

function Library:Spinner(options)
    -- Placeholder for Spinner functionality
    warn("Spinner is not fully implemented yet.")
    print(options.Title or "Loading...")
end


-- Initial setup
ThemeManager:SetTheme(Library._theme.Name)
MainGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

return Library
