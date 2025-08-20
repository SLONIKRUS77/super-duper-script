-- InstaTeleport v3.1 (актуален на 23.07.2025)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Создаем кастомный RemoteEvent если не существует
local TeleportEvent = ReplicatedStorage:FindFirstChild("InstaTeleportEvent") or Instance.new("RemoteEvent")
TeleportEvent.Name = "InstaTeleportEvent"
TeleportEvent.Parent = ReplicatedStorage

-- Серверная часть (вставляется через Script в ServerScriptService)
if not game:GetService("ServerScriptService"):FindFirstChild("TeleportHandler") then
    local ServerScript = Instance.new("Script")
    ServerScript.Name = "TeleportHandler"
    ServerScript.Source = [[
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local TeleportEvent = ReplicatedStorage:WaitForChild("InstaTeleportEvent")
        
        TeleportEvent.OnServerEvent:Connect(function(player, targetName)
            local targetPlayer = Players:FindFirstChild(targetName)
            if targetPlayer and targetPlayer.Character and player.Character then
                local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                local playerRoot = player.Character:FindFirstChild("HumanoidRootPart")
                
                if targetRoot and playerRoot then
                    playerRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
                    game:GetService("Chat"):Chat(player.Character.Head, "Привет! Я телепортировался к тебе!")
                end
            end
        end)
    ]]
    ServerScript.Parent = game:GetService("ServerScriptService")
end

-- Клиентская часть
LocalPlayer.Chatted:Connect(function(message)
    if message == "1" then
        TeleportEvent:FireServer(LocalPlayer.Name)
    end
end)

-- Визуальное подтверждение
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(0, 200, 0, 50)
TextLabel.Position = UDim2.new(0.5, -100, 0.1, 0)
TextLabel.Text = "InstaTeleport активирован!\nНапиши '1' в чат"
TextLabel.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.Parent = ScreenGui

wait(5)
TextLabel:Destroy()

print("✅ InstaTeleport v3.1 успешно активирован!")