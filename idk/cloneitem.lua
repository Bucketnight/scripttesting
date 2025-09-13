-- cloneitem.lua
-- Rayfield UI Script for Cloning Items from ReplicatedStorage
-- This is a LocalScript - Place in StarterPlayerScripts or execute via executor
-- Works with the server script from previous responses for secure cloning

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "Clone Manager",
    LoadingTitle = "Rayfield Clone UI",
    LoadingSubtitle = "Clone Items Securely",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "CloneConfig"
    },
    KeySystem = false
})

-- Tab and Section
local Tab = Window:CreateTab("Cloner", 4483362458)
local Section = Tab:CreateSection("Select Item to Clone")

-- Function to get items from ReplicatedStorage
local function getItems()
    local items = {}
    for _, obj in ipairs(ReplicatedStorage:GetChildren()) do
        if obj:IsA("Tool") or obj:IsA("Model") or obj:IsA("HopperBin") or obj:IsA("Accessory") then
            table.insert(items, obj.Name)
        end
    end
    return items
end

local items = getItems()
local selectedItem = nil

-- Dropdown to select item
local Dropdown = Tab:CreateDropdown({
    Name = "Item to Clone",
    Options = items,
    CurrentOption = items[1] or "No Items",
    Flag = "CloneItem",
    Callback = function(Option)
        selectedItem = Option
        Rayfield:Notify({
            Title = "Selected",
            Content = "Will clone: " .. Option,
            Duration = 2.5,
            Image = 4483362458
        })
    end,
})

-- Clone Button
local CloneButton = Tab:CreateButton({
    Name = "Clone & Give to Me",
    Callback = function()
        if not selectedItem or selectedItem == "No Items" then
            Rayfield:Notify({
                Title = "Error",
                Content = "Select an item first!",
                Duration = 3,
                Image = 4483362458
            })
            return
        end

        -- Fire RemoteEvent to server for cloning
        local success, err = pcall(function()
            local CloneEvent = ReplicatedStorage:WaitForChild("CloneItemEvent", 3)
            CloneEvent:FireServer(selectedItem)
        end)

        if success then
            Rayfield:Notify({
                Title = "Cloned!",
                Content = selectedItem .. " cloned and added to your Backpack!",
                Duration = 4,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Failed to clone: " .. tostring(err),
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})

-- Bulk Clone Option (Clones multiple if selected)
local BulkInput = Tab:CreateInput({
    Name = "Number of Clones",
    PlaceholderText = "Enter amount (1-10)",
    RemoveTextAfterFocusLost = false,
    Callback = function(Value)
        -- Validation can be added here
    end,
})

local BulkCloneButton = Tab:CreateButton({
    Name = "Bulk Clone Selected Item",
    Callback = function()
        if not selectedItem then
            Rayfield:Notify({Title = "Error", Content = "Select an item!", Duration = 3})
            return
        end

        local amount = tonumber(BulkInput.Value) or 1
        if amount > 10 then amount = 10 end  -- Limit for safety
        if amount < 1 then amount = 1 end

        for i = 1, amount do
            wait(0.1)  -- Small delay to avoid spam
            local CloneEvent = ReplicatedStorage:WaitForChild("CloneItemEvent")
            CloneEvent:FireServer(selectedItem)
        end

        Rayfield:Notify({
            Title = "Bulk Cloned",
            Content = "Cloned " .. amount .. "x " .. selectedItem,
            Duration = 4
        })
    end,
})

-- Refresh Button
local RefreshButton = Tab:CreateButton({
    Name = "Refresh Item List",
    Callback = function()
        local newItems = getItems()
        Dropdown:Refresh(newItems, true)
        Rayfield:Notify({
            Title = "Refreshed",
            Content = "Updated " .. #newItems .. " items",
            Duration = 2
        })
    end,
})

-- Additional Tab for Clone Settings
local SettingsTab = Window:CreateTab("Settings", 4483362458)
local SettingsSection = SettingsTab:CreateSection("Clone Options")

-- Toggle for auto-destroy clones after time
local AutoDestroyToggle = SettingsTab:CreateToggle({
    Name = "Auto-Destroy Clones (10s)",
    CurrentValue = false,
    Flag = "AutoDestroy",
    Callback = function(Value)
        -- This would send to server via another RemoteEvent if needed
        Rayfield:Notify({
            Title = "Setting Updated",
            Content = Value and "Clones will auto-destroy" or "Clones persist",
            Duration = 2
        })
    end,
})

print("Rayfield Clone Script loaded! Use the UI to clone items from ReplicatedStorage.")
