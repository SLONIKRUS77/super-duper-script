-- Подключение библиотек
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Конфигурация (ЗАМЕНИТЕ НА СВОИ ДАННЫЕ)
local BOT_TOKEN = "7851456132:AAFUBpKPx1euSp7wP1oEyNCvFK_1MH5GUKM" -- Ваш токен бота
local CHAT_ID = "-1002789516424" -- ID чата/канала
local MESSAGE_TEXT = "⚠️ Игрок " .. Players.LocalPlayer.Name .. " активировал кнопку в MM2!" -- Текст сообщения

-- Создание интерфейса
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TelegramNotifier"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 150, 0, 50)
Frame.Position = UDim2.new(0.5, -75, 0.95, -25)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BackgroundTransparency = 0.3
Frame.Parent = ScreenGui

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0.9, 0, 0.8, 0)
Button.Position = UDim2.new(0.05, 0, 0.1, 0)
Button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
Button.TextColor3 = Color3.new(1, 1, 1)
Button.Text = "SEND ALERT"
Button.Font = Enum.Font.GothamBold
Button.TextSize = 14
Button.Parent = Frame

-- Анимация кнопки
local function AnimateButton()
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(
        Button,
        tweenInfo,
        {BackgroundColor3 = Color3.fromRGB(0, 80, 160), TextSize = 12}
    )
    tween:Play()
    wait(0.2)
    tween = TweenService:Create(
        Button,
        tweenInfo,
        {BackgroundColor3 = Color3.fromRGB(0, 120, 215), TextSize = 14}
    )
    tween:Play()
end

-- Отправка в Telegram
local function SendToTelegram()
    local url = "https://api.telegram.org/bot" .. BOT_TOKEN .. "/sendMessage"
    local params = {
        chat_id = CHAT_ID,
        text = MESSAGE_TEXT,
        disable_web_page_preview = true
    }
    
    -- Кодировка параметров
    local query = ""
    for k,v in pairs(params) do
        query = query .. k .. "=" .. v .. "&"
    end
    
    -- Отправка запроса
    local success, response = pcall(function()
        return game:HttpGet(url .. "?" .. query, true)
    end)
    
    if success then
        print("✅ Сообщение отправлено: " .. response)
    else
        warn("❌ Ошибка: " .. response)
    end
end

-- Обработчик клика
Button.MouseButton1Click:Connect(function()
    AnimateButton()
    SendToTelegram()
    
    -- Временная блокировка кнопки
    Button.Text = "SENT!"
    Button.Active = false
    wait(2)
    Button.Text = "SEND ALERT"
    Button.Active = true
end)

-- Перетаскивание интерфейса
local dragging = false
local dragInput, dragStart, startPos

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)