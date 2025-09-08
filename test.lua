-- 🔑 Key System
local KEY = "SubToBucket" -- change this

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
            -- Set Health (Slider 1–10000)
            MainTab:CreateSlider({
                Name = "Set Health",
                Range = {1, 10000},
                Increment = 1,
                CurrentValue = 100,
                Callback = function(Value)
                    local char = game.Players.LocalPlayer.Character
                    if char and char:FindFirstChild("Humanoid") then
                        char.Humanoid.Health = Value
                    end
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
