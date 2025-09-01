# Example Usage

Contoh penggunaan Roblox UI Library ini, dengan struktur mirip Rayfield.  
Termasuk spesifikasi **Button Group**: bisa di **left/right/top**, posisi **default center** atau **specific**, dan bisa **single** maupun **multiple button**.

---

## ⚙️ Initialize Library
```lua
local Library = loadstring(game:HttpGet("https://yourlib-url.lua"))()

-- (Opsional) Setup tema global, dsb.
Library:Setup({
    Theme = "Dark" -- "Dark" | "Light"
})
````

---

## 🪟 Buat Beberapa Window (multiple windows)

```lua
local Window1 = Library:CreateWindow({
    Name = "Inventory",
    Position = "Center",
    Icon = "box"
})

local Window2 = Library:CreateWindow({
    Name = "Settings",
    Position = "Right",
    Icon = "settings"
})
```

---

## 🗂️ Tab & Section

```lua
local MainTab = Window1:CreateTab("Items")
local MainSection = MainTab:CreateSection("Weapons")
MainSection:CreateLabel("Sword")
MainSection:CreateLabel("Shield")

local ConfigTab = Window2:CreateTab("Config")
local Controls = ConfigTab:CreateSection("Controls")
Controls:CreateToggle({
    Name = "Enable Sprint",
    Default = true,
    Callback = function(state) print("Sprint:", state) end
})
```

---

## 🎛️ Button Groups (sesuai spesifikasi)

**Catatan posisi:**

*   Untuk `Side = "left"` / `"right"` → `Position` mengatur **posisi vertikal** (sumbu Y).
    *   `Position = "center"` (default) atau `UDim.new(0.20, 0)` (20% dari atas).
*   Untuk `Side = "top"` → `Position` mengatur **posisi horizontal** (sumbu X).
    *   `Position = "center"` (default) atau `UDim.new(0.75, 0)` (75% dari kiri).

### 1) Left side, default center, multiple buttons (icon + text)

```lua
local LeftGroup = Library:CreateButtonGroup({
    Side = "left",          -- "left" | "right" | "top"
    Position = "center",    -- default = "center"
    Gap = 8                 -- (opsional) jarak antar tombol
})

LeftGroup:CreateButton({
    Name = "Inventory",
    Icon = "box",           -- Lucide icon name
    Callback = function()
        Window1:Toggle()    -- buka/tutup Window1
    end
})

LeftGroup:CreateButton({
    Name = "Settings",
    Icon = "settings",
    Callback = function()
        Window2:Toggle()    -- buka/tutup Window2
    end
})
```

### 2) Right side, specific position, single button

```lua
local RightGroup = Library:CreateButtonGroup({
    Side = "right",
    Position = UDim.new(0.20, 0) -- 0..1 di sumbu vertikal
})

RightGroup:CreateButton({
    Name = "Help",
    Icon = "help-circle",
    Callback = function()
        Library:Dialog({
            Title = "Help",
            Content = "Butuh bantuan?",
            Buttons = {
                OK = function() print("Help closed") end
            }
        })
    end
})
```

### 3) Top side, specific position, single button

```lua
local TopGroup = Library:CreateButtonGroup({
    Side = "top",
    Position = UDim.new(0.75, 0) -- 0..1 di sumbu horizontal
})

TopGroup:CreateButton({
    Name = "Home",
    Icon = "home",
    Callback = function()
        -- Fokus/restore window utama
        Window1:Show()
    end
})
```

### 4) Mode Lain: Floating, Icon Only, Text Only

```lua
-- Floating (melayang di pojok kanan atas)
local FloatingGroup = Library:CreateButtonGroup({
    Side = "right",
    Floating = true -- Membuat grup melayang
})

-- Icon Only (cukup hilangkan parameter 'Name')
FloatingGroup:CreateButton({
    Icon = "bell",
    Callback = function() Library:Notify({ Title = "Notifikasi!" }) end
})

-- Text Only (cukup hilangkan parameter 'Icon')
FloatingGroup:CreateButton({
    Name = "Logout",
    Callback = function() print("Logout requested") end
})
```

> **Shorthand:** kamu juga bisa pakai bentuk singkat `Library:CreateButtonGroup("left")`
> yang otomatis `Position = "center"`.

---

## 📜 Scrollable Container

Fitur ini aktif secara otomatis jika konten di dalam sebuah `Tab` atau `Section` melebihi ukuran window.

```lua
local ScrollWindow = Library:CreateWindow({ Name = "Scroll Example" })
local ScrollTab = ScrollWindow:CreateTab("Long Content")
local ScrollSection = ScrollTab:CreateSection("Generated Items")

-- Tambahkan banyak elemen untuk memicu scrollbar
for i = 1, 30 do
    ScrollSection:CreateLabel("Generated Label #" .. i)
end

-- Buka window untuk melihat hasilnya
ScrollWindow:Show()
```

---

## 🔘 Elemen Lain (di dalam Window/Section)

```lua
-- Button
MainSection:CreateButton({
    Name = "Use Potion",
    Callback = function() print("Potion used!") end
})

-- Dropdown (single selection)
MainSection:CreateDropdown({
    Name = "Choose Class",
    Options = {"Warrior", "Mage", "Rogue"},
    Multi = false,
    Search = true,
    Callback = function(option) print("Class:", option) end
})

-- Dropdown (multiple selection)
MainSection:CreateDropdown({
    Name = "Select Items",
    Options = {"Potion", "Sword", "Shield", "Armor"},
    Multi = true,
    Search = true,
    Callback = function(selected_items)
        -- Callback menerima tabel berisi pilihan
        print("Items:", table.concat(selected_items, ", "))
    end
})

-- Text Field (normal)
Controls:CreateTextField({
    Name = "Player Name",
    Placeholder = "Enter your name...",
    Callback = function(text) print("Name set to:", text) end
})

-- Text Field (password mode)
Controls:CreateTextField({
    Name = "Secret Code",
    Placeholder = "••••••",
    Password = true,
    Callback = function(text) print("Secret set") end
})

-- Toggle (2-state: On/Off)
Controls:CreateToggle({
    Name = "Enable Music",
    Default = true, -- atau false
    Callback = function(state) print("Music:", state) end
})

-- Toggle (3-state)
Controls:CreateToggle({
    Name = "Auto-Save",
    Default = "indeterminate", -- "on" | "off" | "indeterminate"
    Callback = function(state) print("Auto-Save:", state) end
})

-- Paragraph / Multiline
Controls:CreateParagraph({
    Title = "Notes",
    Content = "Ini contoh paragraf
Bisa multiline."
})
```

---

## 🔔 Notifications / Toast

```lua
Library:Notify({
    Title = "Hello!",
    Content = "This is a notification.",
    Duration = 5
})
```

---

## 📦 Modal / Dialog

```lua
Library:Dialog({
    Title = "Confirmation",
    Content = "Are you sure?",
    Buttons = {
        Yes = function() print("Confirmed!") end,
        No = function() print("Cancelled!") end
    }
})
```

---

## ⌨️ Hotkey (PC)

```lua
Library:Bind({
    Key = Enum.KeyCode.F,
    Callback = function()
        Window2:Toggle()
    end
})
```

---

## 🎬 Progress / Spinner

```lua
local Loading = Library:CreateProgress({
    Title = "Loading Assets",
    Max = 100
})

for i = 1, 100 do
    task.wait(0.02)
    Loading:Set(i)
end

Library:Spinner({
    Title = "Please Wait...",
    Duration = 2
})
```
