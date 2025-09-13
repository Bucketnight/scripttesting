-- RAYFEILD Hub v1.5 (c00lgui Recreation OP Keyless Edition by Bucketnight)
-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Apply red theme on load
Rayfield:SetTheme("Dark") -- Base theme for c00lgui red/black vibes

local Window = Rayfield:CreateWindow({
    Name = "RAYFEILD (C00LGUI RECREATION OP KEYLESS)",
    LoadingTitle = "Loading OP c00lgui Red Vibes...",
    LoadingSubtitle = "by Bucketnight",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "RayfeildConfig",
        FileName = "RayfeildC00LOP"
    },
    Discord = {
        Enabled = false,
        Invite = "noinv",
        RememberJoins = true
    },
    KeySystem = false  -- Fully keyless, no holds barred
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InsertService = game:GetService("InsertService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Fly vars (optimized)
local _fly = false; local _spd = 50; local _bv = nil; local _bp = nil; local _k = {w=false,a=false,s=false,d=false,space=false,ctrl=false};

-- Fly functions (unchanged, smooth AF)
local function _sf() if _fly then return end; _fly=true; _bv=Instance.new("BodyVelocity"); _bv.MaxForce=Vector3.new(4000,0,4000); _bv.Velocity=Vector3.new(0,0,0); _bv.Parent=RootPart; _bp=Instance.new("BodyPosition"); _bp.MaxForce=Vector3.new(0,4000,0); _bp.Position=RootPart.Position; _bp.Parent=RootPart; local _i=function(i,g) if g then return end; if i.KeyCode==Enum.KeyCode.W then _k.w=i.UserInputState==Enum.UserInputState.Begin end; if i.KeyCode==Enum.KeyCode.A then _k.a=i.UserInputState==Enum.UserInputState.Begin end; if i.KeyCode==Enum.KeyCode.S then _k.s=i.UserInputState==Enum.UserInputState.Begin end; if i.KeyCode==Enum.KeyCode.D then _k.d=i.UserInputState==Enum.UserInputState.Begin end; if i.KeyCode==Enum.KeyCode.Space then _k.space=i.UserInputState==Enum.UserInputState.Begin end; if i.KeyCode==Enum.KeyCode.LeftControl then _k.ctrl=i.UserInputState==Enum.UserInputState.Begin end end; UserInputService.InputBegan:Connect(_i); UserInputService.InputEnded:Connect(_i); local _c; _c=RunService.Heartbeat:Connect(function() if not _fly then _c:Disconnect(); return end; local mv=Vector3.new(0,0,0); if _k.w then mv=mv+(workspace.CurrentCamera.CFrame.LookVector*_spd) end; if _k.s then mv=mv-(workspace.CurrentCamera.CFrame.LookVector*_spd) end; if _k.a then mv=mv-(workspace.CurrentCamera.CFrame.RightVector*_spd) end; if _k.d then mv=mv+(workspace.CurrentCamera.CFrame.RightVector*_spd) end; local cam=workspace.CurrentCamera; local vel=Vector3.new(mv.X,0,mv.Z); if _k.space then vel=vel+Vector3.new(0,_spd,0) end; if _k.ctrl then vel=vel-Vector3.new(0,_spd,0) end; _bv.Velocity=vel; _bp.Position=RootPart.Position+Vector3.new(0,0.5,0) end) end

local function _stf() if not _fly then return end; _fly=false; if _bv then _bv:Destroy(); _bv=nil end; if _bp then _bp:Destroy(); _bp=nil end end

UserInputService.InputBegan:Connect(function(i,g) if g then return end; if i.KeyCode==Enum.KeyCode.F then if _fly then _stf() else _sf() end end end)

Player.CharacterAdded:Connect(function(nc) Character=nc; Humanoid=Character:WaitForChild("Humanoid"); RootPart=Character:WaitForChild("HumanoidRootPart"); if _fly then wait(1); _sf() end end)

-- c00lgui OP Features (enhanced for max chaos)
local discoConnection = nil
local stamperSpamConnection = nil
local gearSpamActive = false
local crasherActive = false
local dupeActive = false
local redOverlay = nil

local function discoFog()
    Lighting.FogEnd = 50
    Lighting.FogStart = 0
    Lighting.Brightness = 1
    if discoConnection then discoConnection:Disconnect() end
    discoConnection = RunService.Heartbeat:Connect(function()
        Lighting.ColorShift_Bottom = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
        Lighting.ColorShift_Top = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
        Lighting.Ambient = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
        wait(0.1)  -- Faster rainbow for OP vibes
    end)
end

local function stopDiscoFog()
    if discoConnection then discoConnection:Disconnect(); discoConnection = nil end
    Lighting.FogEnd = 100000
    Lighting.FogStart = 0
    Lighting.Brightness = 2
    Lighting.ColorShift_Bottom = Color3.new()
    Lighting.ColorShift_Top = Color3.new()
    Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
end

local function stamperSpam()
    if stamperSpamConnection then return end
    stamperSpamConnection = RunService.Heartbeat:Connect(function()
        local stamper = InsertService:LoadAsset(165378611) -- Stamper Tool ID
        stamper.Parent = workspace
        stamper:MoveTo(Vector3.new(math.random(-100,100), 50, math.random(-100,100)))
    end)
end

local function stopStamperSpam()
    if stamperSpamConnection then stamperSpamConnection:Disconnect(); stamperSpamConnection = nil end
end

local function gearDropper()
    if gearSpamActive then return end
    gearSpamActive = true
    spawn(function()
        while gearSpamActive do
            local gear = Instance.new("Tool")
            gear.Name = "Troll Gear"
            gear.RequiresHandle = true
            local handle = Instance.new("Part")
            handle.Name = "Handle"
            handle.Size = Vector3.new(1,1,1)
            handle.BrickColor = BrickColor.Random()
            handle.Parent = gear
            gear.Parent = Player.Backpack
            if ReplicatedStorage:FindFirstChild("DefaultStore") and ReplicatedStorage.DefaultStore:FindFirstChild("GiveTool") then
                ReplicatedStorage.DefaultStore.GiveTool:FireServer(gear)
            end
            wait(0.05)  -- Faster spam for OP
        end
    end)
end

local function stopGearDropper()
    gearSpamActive = false
end

local function serverCrasher()
    if crasherActive then return end
    crasherActive = true
    spawn(function()
        while crasherActive do
            for i = 1, 200 do  -- Doubled for OP lag
                local part = Instance.new("Part")
                part.Size = Vector3.new(10,10,10)
                part.Position = Vector3.new(math.random(-500,500), math.random(0,100), math.random(-500,500))
                part.Parent = workspace
            end
            wait(0.005)  -- Tighter loop
        end
    end)
end

local function stopServerCrasher()
    crasherActive = false
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Part") and obj.Name == "" then obj:Destroy() end
    end
end

local function infiniteDupe()  -- New OP: Duplicate parts endlessly
    if dupeActive then return end
    dupeActive = true
    spawn(function()
        while dupeActive do
            for _, obj in pairs(workspace:GetChildren()) do
                if obj:IsA("BasePart") and obj.Name ~= "Baseplate" then
                    local clone = obj:Clone()
                    clone.Parent = workspace
                    clone.Position = obj.Position + Vector3.new(math.random(-10,10), 0, math.random(-10,10))
                end
            end
            wait(0.5)
        end
    end)
end

local function stopInfiniteDupe()
    dupeActive = false
end

local function redOverlayToggle()  -- New OP: Full-screen blood red wash
    if redOverlay then
        redOverlay:Destroy()
        redOverlay = nil
    else
        redOverlay = Instance.new("ScreenGui", Player.PlayerGui)
        local overlayFrame = Instance.new("Frame", redOverlay)
        overlayFrame.Size = UDim2.new(1, 0, 1, 0)
        overlayFrame.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        overlayFrame.BackgroundTransparency = 0.3
        overlayFrame.ZIndex = -1
    end
end

local function unanchorAll()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name ~= "Baseplate" then
            obj.Anchored = false
        end
    end
end

local function reanchorAll()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name ~= "Baseplate" then
            obj.Anchored = true
        end
    end
end

local function destroyer()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("BasePart") and obj.Name ~= "Baseplate" then
            obj:Destroy()
        end
    end
end

local function apply666Theme()
    Rayfield:SetTheme("Dark")
    local ui = game:GetService("CoreGui"):FindFirstChild("Rayfield") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Rayfield")
    if ui then
        for _, v in pairs(ui:GetDescendants()) do
            if v:IsA("Frame") then
                v.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
                v.BorderColor3 = Color3.fromRGB(50, 0, 0)
            elseif v:IsA("TextLabel") or v:IsA("TextButton") then
                v.TextColor3 = Color3.fromRGB(255, 255, 255)
                v.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            end
        end
    end
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://131961136"
    sound.Volume = 0.5
    sound.Looped = true
    sound.Parent = Lighting
    sound:Play()
end

-- Apply red theme on startup
apply666Theme()

-- Tabs
local FlyTab = Window:CreateTab("Fly Controls", 4483362458)
local FlySection = FlyTab:CreateSection("Flight Settings")
local FlyToggle = FlyTab:CreateToggle({Name="Toggle Fly",CurrentValue=false,Flag="FlyToggle",Callback=function(v) if v then _sf() else _stf() end end})
local SpeedSlider = FlyTab:CreateSlider({Name="Fly Speed",Range={16,200},Increment=1,CurrentValue=50,Flag="FlySpeed",Callback=function(v) _spd=v end})

local C00LTab = Window:CreateTab("c00lgui OP Recreation", 4483362458)
local C00LSection = C00LTab:CreateSection("Troll Tools (2014 Red OP Vibes)")
local DevSection = C00LTab:CreateSection("Dev Credits")
C00LTab:CreateLabel({Name="Bucketnight", Info="Created by Bucketnight, Roblox Dev Extraordinaire"})

C00LTab:CreateButton({
    Name = "Disco Fog (OP Fast)",
    Callback = function()
        discoFog()
        Rayfield:Notify({Title="c00lgui OP", Content="Rainbow chaos at warp speed!", Duration=3})
    end
})

C00LTab:CreateButton({
    Name = "Stop Disco Fog",
    Callback = function()
        stopDiscoFog()
        Rayfield:Notify({Title="c00lgui OP", Content="Disco halted.", Duration=3})
    end
})

C00LTab:CreateButton({
    Name = "Stamper Spam",
    Callback = function()
        stamperSpam()
        Rayfield:Notify({Title="c00lgui OP", Content="Stampers flooding the map!", Duration=3})
    end
})

C00LTab:CreateButton({
    Name = "Stop Stamper Spam",
    Callback = function()
        stopStamperSpam()
        Rayfield:Notify({Title="c00lgui OP", Content="Stampers cleared.", Duration=3})
    end
})

C00LTab:CreateButton({
    Name = "Gear Dropper (OP Fast)",
    Callback = function()
        gearDropper()
        Rayfield:Notify({Title="c00lgui OP", Content="Gears raining like 2014 apocalypse!", Duration=3})
    end
})

C00LTab:CreateButton({
    Name = "Stop Gear Dropper",
    Callback = function()
        stopGearDropper()
        Rayfield:Notify({Title="c00lgui OP", Content="Gear storm stopped.", Duration=3})
    end
})

C00LTab:CreateButton({
    Name = "Server Crasher (OP Heavy)",
    Callback = function()
        serverCrasher()
        Rayfield:Notify({Title="c00lgui OP", Content="Nuking server—evacuate now!", Duration=3})
    end
})

C00LTab:CreateButton({
    Name = "Stop Crasher",
    Callback = function()
        stopServerCrasher()
        Rayfield:Notify({Title="c00lgui OP", Content="Crasher offline.", Duration=3})
    end
})

C00LTab:CreateButton({
    Name = "Infinite Dupe (OP Lag)",
    Callback = function()
        infiniteDupe()
        Rayfield:Notify({Title="c00lgui OP", Content="Duplicating everything—pure madness!", Duration=3})
    end
})

C00LTab:CreateButton({
    Name = "Stop Infinite Dupe",
    Callback = function()
        stopInfiniteDupe()
        Rayfield:Notify({Title="c00lgui OP", Content="Dupe frenzy ended.", Duration=3})
    end
})

C00LTab:CreateButton({
    Name = "Red Overlay Toggle (666 OP)",
    Callback = function()
        redOverlayToggle()
        Rayfield:Notify({Title="c00lgui OP", Content="Blood red screen wash activated/deactivated.", Duration=3})
    end
})

C00LTab:CreateButton({
    Name = "Unanchor All Parts",
    Callback = function()
        unanchorAll()
        Rayfield:Notify({Title="c00lgui OP", Content="World crumbling—gravity wins!", Duration=3})
    end
})

C00LTab:CreateButton({
    Name = "Reanchor All Parts",
    Callback = function()
        reanchorAll()
        Rayfield:Notify({Title="c00lgui OP", Content="Stability restored (kinda).", Duration=3})
    end
})

C00LTab:CreateButton({
    Name = "Destroyer (Nuke Workspace)",
    Callback = function()
        destroyer()
        Rayfield:Notify({Title="c00lgui OP", Content="Total annihilation complete.", Duration=3})
    end
})

C00LTab:CreateButton({
    Name = "666 Theme (Reapply Red)",
    Callback = function()
        apply666Theme()
        Rayfield:Notify({Title="c00lgui OP", Content="Spooky red overload—Muahaha!", Duration=3})
    end
})

-- Notify
Rayfield:Notify({
    Title = "RAYFEILD c00lgui OP Keyless Loaded!",
    Content = "No keys, all chaos. Bucketnight’s OP troll hub is live—Byfron can try.",
    Duration = 5,
    Image = 4483362458
})

Rayfield:LoadConfiguration()
