-- RAYFEILD Hub v1.6 (c00lgui Recreation Edition - No Theme by Bucketnight, Keyless)
-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "RAYFEILD Hub - c00lgui Edition",
    LoadingTitle = "Loading c00lgui Vibes...",
    LoadingSubtitle = "by Bucketnight",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "RayfeildConfig",
        FileName = "RayfeildC00L"
    },
    Discord = {
        Enabled = false,
        Invite = "noinv",
        RememberJoins = true
    },
    KeySystem = false -- Keyless!
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

-- Fly vars
local _fly = false; local _spd = 50; local _bv = nil; local _bp = nil; local _k = {w=false,a=false,s=false,d=false,space=false,ctrl=false};

-- Fly functions
local function _sf() if _fly then return end; _fly=true; _bv=Instance.new("BodyVelocity"); _bv.MaxForce=Vector3.new(4000,0,4000); _bv.Velocity=Vector3.new(0,0,0); _bv.Parent=RootPart; _bp=Instance.new("BodyPosition"); _bp.MaxForce=Vector3.new(0,4000,0); _bp.Position=RootPart.Position; _bp.Parent=RootPart; local _i=function(i,g) if g then return end; if i.KeyCode==Enum.KeyCode.W then _k.w=i.UserInputState==Enum.UserInputState.Begin end; if i.KeyCode==Enum.KeyCode.A then _k.a=i.UserInputState==Enum.UserInputState.Begin end; if i.KeyCode==Enum.KeyCode.S then _k.s=i.UserInputState==Enum.UserInputState.Begin end; if i.KeyCode==Enum.KeyCode.D then _k.d=i.UserInputState==Enum.UserInputState.Begin end; if i.KeyCode==Enum.KeyCode.Space then _k.space=i.UserInputState==Enum.UserInputState.Begin end; if i.KeyCode==Enum.KeyCode.LeftControl then _k.ctrl=i.UserInputState==Enum.UserInputState.Begin end end; UserInputService.InputBegan:Connect(_i); UserInputService.InputEnded:Connect(_i); local _c; _c=RunService.Heartbeat:Connect(function() if not _fly then _c:Disconnect(); return end; local mv=Vector3.new(0,0,0); if _k.w then mv=mv+(workspace.CurrentCamera.CFrame.LookVector*_spd) end; if _k.s then mv=mv-(workspace.CurrentCamera.CFrame.LookVector*_spd) end; if _k.a then mv=mv-(workspace.CurrentCamera.CFrame.RightVector*_spd) end; if _k.d then mv=mv+(workspace.CurrentCamera.CFrame.RightVector*_spd) end; local cam=workspace.CurrentCamera; local vel=Vector3.new(mv.X,0,mv.Z); if _k.space then vel=vel+Vector3.new(0,_spd,0) end; if _k.ctrl then vel=vel-Vector3.new(0,_spd,0) end; _bv.Velocity=vel; _bp.Position=RootPart.Position+Vector3.new(0,0.5,0) end) end

local function _stf() if not _fly then return end; _fly=false; if _bv then _bv:Destroy(); _bv=nil end; if _bp then _bp:Destroy(); _bp=nil end end

UserInputService.InputBegan:Connect(function(i,g) if g then return end; if i.KeyCode==Enum.KeyCode.F then if _fly then _stf() else _sf() end end end)

Player.CharacterAdded:Connect(function(nc) Character=nc; Humanoid=Character:WaitForChild("Humanoid"); RootPart=Character:WaitForChild("HumanoidRootPart"); if _fly then wait(1); _sf() end end)

-- c00lgui Recreation Features
local discoConnection = nil
local stamperSpamConnection = nil
local gearSpamActive = false
local crasherActive = false

local function discoFog()
    Lighting.FogEnd = 50
    Lighting.FogStart = 0
    Lighting.Brightness = 1
    if discoConnection then discoConnection:Disconnect() end
    discoConnection = RunService.Heartbeat:Connect(function()
        Lighting.ColorShift_Bottom = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
        Lighting.ColorShift_Top = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
        Lighting.Ambient = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
        wait(0.5)
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
        local stamper = InsertService:LoadAsset(165378611) -- Roblox Stamper Tool ID
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
            wait(0.1)
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
            for i = 1, 100 do
                local part = Instance.new("Part")
                part.Size = Vector3.new(10,10,10)
                part.Position = Vector3.new(math.random(-500,500), math.random(0,100), math.random(-500,500))
                part.Parent = workspace
            end
            wait(0.01)
        end
    end)
end

local function stopServerCrasher()
    crasherActive = false
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Part") and obj.Name == "" then obj:Destroy() end
    end
end

local function unanchorAll()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name ~= "Baseplate" then
            obj.Anchored = false
        end
    end
    Rayfield:Notify({Title="c00lgui", Content="All parts unanchored! Watch the world crumble.", Duration=3})
end

local function reanchorAll()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name ~= "Baseplate" then
            obj.Anchored = true
        end
    end
    Rayfield:Notify({Title="c00lgui", Content="All parts reanchored. Stability restored... for now.", Duration=3})
end

local function destroyer()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("BasePart") and obj.Name ~= "Baseplate" then
            obj:Destroy()
        end
    end
    Rayfield:Notify({Title="c00lgui", Content="Workspace nuked! Total destruction.", Duration=3})
end

-- Tabs
local FlyTab = Window:CreateTab("Fly Controls", 4483362458)
local FlySection = FlyTab:CreateSection("Flight Settings")
local FlyToggle = FlyTab:CreateToggle({Name="Toggle Fly",CurrentValue=false,Flag="FlyToggle",Callback=function(v) if v then _sf() else _stf() end end})
local SpeedSlider = FlyTab:CreateSlider({Name="Fly Speed",Range={16,200},Increment=1,CurrentValue=50,Flag="FlySpeed",Callback=function(v) _spd=v end})

local C00LTab = Window:CreateTab("c00lgui Recreation", 4483362458)
local C00LSection = C00LTab:CreateSection("Troll Tools")
local DevSection = C00LTab:CreateSection("Dev Credits")
C00LTab:CreateLabel({Name="Bucketnight", Info="Created by Bucketnight, Roblox Dev Extraordinaire"})

C00LTab:CreateButton({
    Name = "Disco Fog",
    Callback = function()
        discoFog()
        Rayfield:Notify({Title="c00lgui", Content="Disco fog activated! Rainbow chaos incoming.", Duration=3})
    end
})

C00LTab:CreateButton({
    Name = "Stop Disco Fog",
    Callback = function()
        stopDiscoFog()
        Rayfield:Notify({Title="c00lgui", Content="Disco stopped. Back to normal(ish).", Duration=3})
    end
})

C00LTab:CreateButton({
    Name = "Stamper Spam",
    Callback = function()
        stamperSpam()
        Rayfield:Notify({Title="c00lgui", Content="Stampers everywhere! Spammin' tools.", Duration=3})
    end
})

C00LTab:CreateButton({
    Name = "Stop Stamper Spam",
    Callback = function()
        stopStamperSpam()
        Rayfield:Notify({Title="c00lgui", Content="Stampers halted.", Duration=3})
    end
})

C00LTab:CreateButton({
    Name = "Gear Dropper",
    Callback = function()
        gearDropper()
        Rayfield:Notify({Title="c00lgui", Content="Gears droppin' like it's 2014!", Duration=3})
    end
})

C00LTab:CreateButton({
    Name = "Stop Gear Dropper",
    Callback = function()
        stopGearDropper()
        Rayfield:Notify({Title="c00lgui", Content="Gear spam stopped.", Duration=3})
    end
})

C00LTab:CreateButton({
    Name = "Server Crasher (Laggy)",
    Callback = function()
        serverCrasher()
        Rayfield:Notify({Title="c00lgui", Content="Crashing server... Use at own risk!", Duration=3})
    end
})

C00LTab:CreateButton({
    Name = "Stop Crasher",
    Callback = function()
        stopServerCrasher()
        Rayfield:Notify({Title="c00lgui", Content="Crasher deactivated.", Duration=3})
    end
})

C00LTab:CreateButton({
    Name = "Unanchor All Parts",
    Callback = unanchorAll
})

C00LTab:CreateButton({
    Name = "Reanchor All Parts",
    Callback = reanchorAll
})

C00LTab:CreateButton({
    Name = "Destroyer (Nuke Workspace)",
    Callback = destroyer
})

-- Notify
Rayfield:Notify({
    Title = "RAYFEILD c00lgui Loaded!",
    Content = "Keyless troll hub ready. Bucketnight’s chaos unleashed! Byfron’s watching.",
    Duration = 5,
    Image = 4483362458
})

Rayfield:LoadConfiguration()
