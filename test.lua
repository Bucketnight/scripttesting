-- 🔑 Key System
local KEY = "Bucket123" -- change this

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Create Key Window
local KeyWindow = Rayfield:CreateWindow({
    Name = "FE Admin Hub | Key System",
    Icon = 0,
    LoadingTitle = "Verification Required",
    LoadingSubtitle = "Enter your access key",
    Theme = "Default",
})

local KeyTab = KeyWindow:CreateTab("Key", 4483362458)

KeyTab:CreateInput({
    Name = "Enter Key",
    PlaceholderText = "Paste your key here...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if Text == KEY then
            -- ✅ Correct key
            Rayfield:Destroy()
            Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

            ------------------------------------------------
            -- MAIN ADMIN HUB
            local Window = Rayfield:CreateWindow({
                Name = "FE Admin Hub",
                Icon = 0,
                LoadingTitle = "Admin Powers",
                LoadingSubtitle = "Access Granted ✅",
                Theme = "Default",
            })

            -- Tabs
            local MainTab = Window:CreateTab("Main", 4483362458)
            local BuildTab = Window:CreateTab("Building", 4483362458)

            ------------------------------------------------
            -- WalkSpeed
            MainTab:CreateSlider({
                Name = "WalkSpeed",
                Range = {16, 200},
                Increment = 1,
                CurrentValue = 16,
                Callback = function(Value)
                    local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                    if hum then hum.WalkSpeed = Value end
                end,
            })

            -- JumpPower
            MainTab:CreateSlider({
                Name = "JumpPower",
                Range = {50, 300},
                Increment = 1,
                CurrentValue = 50,
                Callback = function(Value)
                    local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                    if hum then hum.JumpPower = Value end
                end,
            })

            ------------------------------------------------
            -- Announce
            MainTab:CreateInput({
                Name = "Announce",
                PlaceholderText = "Type a message...",
                RemoveTextAfterFocusLost = true,
                Callback = function(Text)
                    game.StarterGui:SetCore("ChatMakeSystemMessage", {
                        Text = "[ADMIN ANNOUNCE] " .. Text,
                        Color = Color3.fromRGB(255, 50, 50),
                        Font = Enum.Font.SourceSansBold,
                        FontSize = Enum.FontSize.Size48
                    })
                end,
            })

            ------------------------------------------------
            -- Kill Player
            MainTab:CreateInput({
                Name = "Kill Player",
                PlaceholderText = "Enter player name...",
                RemoveTextAfterFocusLost = true,
                Callback = function(Text)
                    local target = game.Players:FindFirstChild(Text)
                    if target and target.Character and target.Character:FindFirstChild("Humanoid") then
                        target.Character.Humanoid.Health = 0
                    end
                end,
            })

            ------------------------------------------------
            -- ForceField
            MainTab:CreateButton({
                Name = "Add ForceField",
                Callback = function()
                    local char = game.Players.LocalPlayer.Character
                    if char and not char:FindFirstChildOfClass("ForceField") then
                        Instance.new("ForceField", char)
                    end
                end,
            })

            ------------------------------------------------
            -- Laser Eyes (kill on look)
            MainTab:CreateToggle({
                Name = "Laser Eyes 🔥",
                CurrentValue = false,
                Callback = function(Value)
                    local player = game.Players.LocalPlayer
                    local mouse = player:GetMouse()
                    local connection
                    if Value then
                        connection = mouse.Move:Connect(function()
                            if mouse.Target and mouse.Target.Parent then
                                local hum = mouse.Target.Parent:FindFirstChild("Humanoid")
                                if hum and hum.Health > 0 then
                                    hum.Health = 0
                                end
                            end
                        end)
                    else
                        if connection then connection:Disconnect() end
                    end
                end,
            })

            ------------------------------------------------
            -- Kill Aura
            MainTab:CreateToggle({
                Name = "Kill Aura ⚔️",
                CurrentValue = false,
                Callback = function(Value)
                    local player = game.Players.LocalPlayer
                    local range = 15
                    local connection
                    if Value then
                        connection = game:GetService("RunService").Heartbeat:Connect(function()
                            local char = player.Character
                            if not char then return end
                            local root = char:FindFirstChild("HumanoidRootPart")
                            if not root then return end

                            for _, plr in pairs(game.Players:GetPlayers()) do
                                if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                                    local targetRoot = plr.Character.HumanoidRootPart
                                    if (targetRoot.Position - root.Position).Magnitude <= range then
                                        local hum = plr.Character:FindFirstChild("Humanoid")
                                        if hum and hum.Health > 0 then
                                            hum.Health = 0
                                        end
                                    end
                                end
                            end
                        end)
                    else
                        if connection then connection:Disconnect() end
                    end
                end,
            })

            ------------------------------------------------
            -- Simple Building Tool
            BuildTab:CreateButton({
                Name = "Give Simple Building Tool",
                Callback = function()
                    local player = game.Players.LocalPlayer
                    local backpack = player:WaitForChild("Backpack")

                    -- Tool
                    local tool = Instance.new("Tool")
                    tool.Name = "BuildingTool"
                    tool.RequiresHandle = false
                    tool.Parent = backpack

                    -- LocalScript inside Tool
                    local scriptSource = [[
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local tool = script.Parent
local selectedPart = nil
local moveIncrement = 1
local rotateIncrement = 15

tool.Activated:Connect(function()
    if mouse.Target and mouse.Target:IsA("Part") then
        selectedPart = mouse.Target
        print("Selected:", selectedPart.Name)
    end
end)

-- Move with keys
mouse.KeyDown:Connect(function(key)
    if not selectedPart then return end

    if key == "w" then
        selectedPart.Position += Vector3.new(0, 0, -moveIncrement)
    elseif key == "s" then
        selectedPart.Position += Vector3.new(0, 0, moveIncrement)
    elseif key == "a" then
        selectedPart.Position += Vector3.new(-moveIncrement, 0, 0)
    elseif key == "d" then
        selectedPart.Position += Vector3.new(moveIncrement, 0, 0)
    elseif key == "q" then
        selectedPart.Position += Vector3.new(0, moveIncrement, 0)
    elseif key == "e" then
        selectedPart.Position += Vector3.new(0, -moveIncrement, 0)
    elseif key == "r" then
        selectedPart.Orientation += Vector3.new(0, rotateIncrement, 0)
    elseif key == "f" then
        selectedPart.Orientation += Vector3.new(0, -rotateIncrement, 0)
    end
end)
                    ]]

                    local localscript = Instance.new("LocalScript")
                    localscript.Source = scriptSource
                    localscript.Parent = tool

                    Rayfield:Notify({
                        Title = "Building Tool Granted",
                        Content = "Use W/A/S/D/Q/E to move, R/F to rotate.",
                        Duration = 7,
                        Image = 4483362458,
                    })
                end,
            })
        else
            Rayfield:Notify({
                Title = "Invalid Key ❌",
                Content = "The key you entered is incorrect.",
                Duration = 5,
                Image = 4483362458,
            })
        end
    end,
})
