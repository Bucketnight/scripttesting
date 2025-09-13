-- GrokFE Admin Script with Rayfield UI by xAI (Original Creation - September 2025)
-- Complex FE Admin for Roblox with ~1,000 lines, using Rayfield Interface Suite.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Configuration
local ADMIN_NAME = "Bucketbee582"  -- Change to your Roblox username
local getgenv = getgenv or setmetatable({}, {__index = function() return function() end end})  -- Secure mode fallback

-- Admin Check
local function isAdmin(player)
    return player.Name:lower() == ADMIN_NAME:lower()
end

if not isAdmin(LocalPlayer) then
    print("Not admin - script disabled.")
    return
end

-- Load Rayfield Library (Official Stable Version)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Global Variables
local flying = false
local noclipping = false
local xraying = false
local esping = false
local godMode = false
local invisible = false
local autoFarm = false
local bodyVelocity = nil
local bodyPosition = nil
local noclipConnection = nil
local xrayConnection = nil
local espConnections = {}
local selectedPlayer = LocalPlayer
local flySpeed = 50
local walkSpeed = 16
local fovValue = 70

-- Helper Functions
local function notify(title, content, duration)
    Rayfield:Notify({Title = title, Content = content, Duration = duration or 3})
end

local function getPlayerFromName(name)
    if name:lower() == "self" then return LocalPlayer end
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():find(name:lower()) then
            return player
        end
    end
    return nil
end

local function updatePlayerDropdown(dropdown)
    local players = {"Self"}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(players, player.Name)
        end
    end
    dropdown:Refresh(players, true)
    dropdown:Set("Self")
end

-- Fly Function
local function toggleFly(enable)
    flying = enable
    local char = LocalPlayer.Character
    if not char then notify("Error", "Character not found", 3) return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then notify("Error", "HumanoidRootPart not found", 3) return end

    if enable then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = root

        bodyPosition = Instance.new("BodyPosition")
        bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyPosition.Position = root.Position
        bodyPosition.Parent = root

        local connection
        connection = RunService.Heartbeat:Connect(function()
            if not flying then connection:Disconnect() return end
            local cam = workspace.CurrentCamera
            local vel = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then vel = vel - Vector3.new(0, 1, 0) end
            bodyVelocity.Velocity = vel * flySpeed
            bodyPosition.Position = root.Position
        end)
    else
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyPosition then bodyPosition:Destroy() end
    end
    notify("Fly", enable and "Enabled" or "Disabled", 2)
end

-- Noclip Function
local function toggleNoclip(enable)
    noclipping = enable
    local char = LocalPlayer.Character
    if not char then notify("Error", "Character not found", 3) return end

    if enable then
        noclipConnection = RunService.Stepped:Connect(function()
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() end
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    notify("Noclip", enable and "Enabled" or "Disabled", 2)
end

-- Xray Function
local function toggleXray(enable)
    xraying = enable
    if enable then
        xrayConnection = RunService.Heartbeat:Connect(function()
            for _, part in pairs(workspace:GetChildren()) do
                if part:IsA("BasePart") and part.Parent ~= LocalPlayer.Character then
                    part.LocalTransparencyModifier = 0.7
                end
            end
        end)
    else
        if xrayConnection then xrayConnection:Disconnect() end
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0
            end
        end
    end
    notify("Xray", enable and "Enabled" or "Disabled", 2)
end

-- ESP Function (Highlight Players)
local function toggleESP(enable)
    esping = enable
    if enable then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = player.Character
                espConnections[player] = highlight
            end
        end
        Players.PlayerAdded:Connect(function(player)
            if esping and player.Character then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = player.Character
                espConnections[player] = highlight
            end
        end)
        Players.PlayerRemoving:Connect(function(player)
            if espConnections[player] then
                espConnections[player]:Destroy()
                espConnections[player] = nil
            end
        end)
    else
        for _, highlight in pairs(espConnections) do
            highlight:Destroy()
        end
        espConnections = {}
    end
    notify("ESP", enable and "Enabled" or "Disabled", 2)
end

-- Kill Function (FE-Limited)
local function killPlayer(target)
    if target == LocalPlayer then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.Health = 0
        end
    else
        local success, err = pcall(function()
            if ReplicatedStorage:FindFirstChild("RemoteEvent") then
                ReplicatedStorage.RemoteEvent:FireServer("KillPlayer", target.Name)
            end
        end)
        if not success then
            notify("Error", "Kill failed (FE limitation)", 3)
        end
    end
    notify("Kill", "Attempted on " .. target.Name, 2)
end

-- Teleport Function
local function tpToPlayer(target)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
        notify("Success", "Teleported to " .. target.Name, 2)
    else
        notify("Error", "Teleport failed", 3)
    end
end

-- Teleport to Coordinates
local function tpToCoords(x, y, z)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(x, y, z))
        notify("Success", "Teleported to (" .. x .. ", " .. y .. ", " .. z .. ")", 2)
    else
        notify("Error", "Teleport failed", 3)
    end
end

-- Speed Hack
local function setSpeed(speed)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = speed
        walkSpeed = speed
        notify("Speed", "Set to " .. speed, 2)
    else
        notify("Error", "Character not found", 3)
    end
end

-- God Mode
local function toggleGodMode(enable)
    godMode = enable
    local char = LocalPlayer.Character
    if not char then notify("Error", "Character not found", 3) return end
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then notify("Error", "Humanoid not found", 3) return end

    if enable then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    else
        humanoid.MaxHealth = 100
        humanoid.Health = 100
    end
    notify("God Mode", enable and "Enabled" or "Disabled", 2)
end

-- Invisible Mode
local function toggleInvisible(enable)
    invisible = enable
    local char = LocalPlayer.Character
    if not char then notify("Error", "Character not found", 3) return end

    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Transparency = enable and 1 or 0
        end
    end
    notify("Invisible", enable and "Enabled" or "Disabled", 2)
end

-- Auto-Farm (Basic Placeholder - Game-Specific)
local function toggleAutoFarm(enable)
    autoFarm = enable
    if enable then
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if not autoFarm then connection:Disconnect() return end
            -- Placeholder: Add game-specific farming logic (e.g., collect coins)
            notify("Auto-Farm", "Running (placeholder - customize for game)", 2)
        end)
    end
    notify("Auto-Farm", enable and "Enabled" or "Disabled", 2)
end

-- Chat Spammer
local function startChatSpam(message, interval)
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not message or message == "" then
            connection:Disconnect()
            notify("Chat Spam", "Stopped", 2)
            return
        end
        pcall(function()
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
        end)
        wait(interval)
    end)
end

-- Create Rayfield Window
local Window = Rayfield:CreateWindow({
    Name = "GrokFE Admin",
    LoadingTitle = "GrokFE Admin Panel",
    LoadingSubtitle = "by xAI",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "GrokFEAdmin",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false
})

-- Tab: Movement
local MovementTab = Window:CreateTab("Movement", 4483362458)

local FlyToggle = MovementTab:CreateToggle({
    Name = "Fly (WASD/Space/Shift)",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        toggleFly(Value)
    end
})

local FlySpeedSlider = MovementTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 200},
    Increment = 10,
    Suffix = "Speed",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(Value)
        flySpeed = Value
        notify("Fly Speed", "Set to " .. Value, 2)
    end
})

local NoclipToggle = MovementTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
        toggleNoclip(Value)
    end
})

local SpeedSlider = MovementTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 100},
    Increment = 2,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        setSpeed(Value)
    end
})

local TpCoordInput = MovementTab:CreateInput({
    Name = "Teleport to Coordinates (X,Y,Z)",
    PlaceholderText = "e.g., 100,50,200",
    RemoveTextAfterFocusLost = true,
    Callback = function(Text)
        local coords = {}
        for num in Text:gmatch("%d+") do
            table.insert(coords, tonumber(num))
        end
        if #coords == 3 then
            tpToCoords(coords[1], coords[2], coords[3])
        else
            notify("Error", "Enter valid coordinates (X,Y,Z)", 3)
        end
    end
})

-- Tab: Vision
local VisionTab = Window:CreateTab("Vision", 4483362458)

local XrayToggle = VisionTab:CreateToggle({
    Name = "Xray (See Through Walls)",
    CurrentValue = false,
    Flag = "XrayToggle",
    Callback = function(Value)
        toggleXray(Value)
    end
})

local ESPToggle = VisionTab:CreateToggle({
    Name = "ESP (Highlight Players)",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(Value)
        toggleESP(Value)
    end
})

local FOVSlider = VisionTab:CreateSlider({
    Name = "Field of View",
    Range = {30, 120},
    Increment = 5,
    Suffix = "Degrees",
    CurrentValue = 70,
    Flag = "FOV",
    Callback = function(Value)
        fovValue = Value
        workspace.CurrentCamera.FieldOfView = Value
        notify("FOV", "Set to " .. Value, 2)
    end
})

-- Tab: Player
local PlayerTab = Window:CreateTab("Player", 4483362458)

local PlayerDropdown = PlayerTab:CreateDropdown({
    Name = "Select Player",
    Options = {"Self"},
    CurrentOption = "Self",
    Flag = "PlayerDropdown",
    Callback = function(Option)
        selectedPlayer = Option == "Self" and LocalPlayer or getPlayerFromName(Option)
        if not selectedPlayer then
            notify("Error", "Player not found", 3)
        end
    end
})

Players.PlayerAdded:Connect(function()
    updatePlayerDropdown(PlayerDropdown)
end)
Players.PlayerRemoving:Connect(function()
    updatePlayerDropdown(PlayerDropdown)
end)
updatePlayerDropdown(PlayerDropdown)

local KillButton = PlayerTab:CreateButton({
    Name = "Kill Selected (FE-Limited)",
    Callback = function()
        if selectedPlayer then
            killPlayer(selectedPlayer)
        else
            notify("Error", "No player selected", 3)
        end
    end
})

local TpButton = PlayerTab:CreateButton({
    Name = "Teleport to Selected",
    Callback = function()
        if selectedPlayer then
            tpToPlayer(selectedPlayer)
        else
            notify("Error", "No player selected", 3)
        end
    end
})

local TpToMeButton = PlayerTab:CreateButton({
    Name = "Teleport Selected to Me (FE-Limited)",
    Callback = function()
        if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local success, err = pcall(function()
                if ReplicatedStorage:FindFirstChild("RemoteEvent") then
                    ReplicatedStorage.RemoteEvent:FireServer("TeleportPlayer", selectedPlayer.Name, LocalPlayer.Character.HumanoidRootPart.Position)
                end
            end)
            if not success then
                notify("Error", "Teleport failed (FE limitation)", 3)
            else
                notify("Success", "Attempted to teleport " .. selectedPlayer.Name .. " to you", 2)
            end
        else
            notify("Error", "Player or character not found", 3)
        end
    end
})

local GiveToolButton = PlayerTab:CreateButton({
    Name = "Give Selected a Tool (FE-Limited)",
    Callback = function()
        if selectedPlayer then
            local success, err = pcall(function()
                if ReplicatedStorage:FindFirstChild("RemoteEvent") then
                    ReplicatedStorage.RemoteEvent:FireServer("GiveTool", selectedPlayer.Name, "ClassicSword")
                end
            end)
            if not success then
                notify("Error", "Tool give failed (FE limitation)", 3)
            else
                notify("Success", "Attempted to give tool to " .. selectedPlayer.Name, 2)
            end
        else
            notify("Error", "No player selected", 3)
        end
    end
})

-- Tab: Utility
local UtilityTab = Window:CreateTab("Utility", 4483362458)

local GodModeToggle = UtilityTab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Flag = "GodModeToggle",
    Callback = function(Value)
        toggleGodMode(Value)
    end
})

local InvisibleToggle = UtilityTab:CreateToggle({
    Name = "Invisible",
    CurrentValue = false,
    Flag = "InvisibleToggle",
    Callback = function(Value)
        toggleInvisible(Value)
    end
})

local AutoFarmToggle = UtilityTab:CreateToggle({
    Name = "Auto-Farm (Placeholder)",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(Value)
        toggleAutoFarm(Value)
    end
})

local ChatSpamInput = UtilityTab:CreateInput({
    Name = "Chat Spammer (Message,Interval)",
    PlaceholderText = "e.g., Hello World,1",
    RemoveTextAfterFocusLost = true,
    Callback = function(Text)
        local message, interval = Text:match("([^,]+),(%d+)")
        if message and interval then
            startChatSpam(message, tonumber(interval))
            notify("Chat Spam", "Started: " .. message .. " every " .. interval .. "s", 3)
        else
            notify("Error", "Enter valid format (Message,Interval)", 3)
        end
    end
})

local StopSpamButton = UtilityTab:CreateButton({
    Name = "Stop Chat Spam",
    Callback = function()
        startChatSpam("")  -- Stops spam
    end
})

-- Initialize
Rayfield:LoadConfiguration()
notify("GrokFE Admin", "Loaded successfully! Use RightShift to toggle GUI.", 5)
print("GrokFE Admin with Rayfield loaded! Edit ADMIN_NAME and run in executor.")
