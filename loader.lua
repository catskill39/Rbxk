--[[
   📦 SYSTEM UI с автоматическим редиректом
   Автор: @qu2ex
--]]

local placeId = game.PlaceId
local allowedPlaces = {
    [142823291] = "MM2",
    [537413528] = "Build A Boat",
    [286090429] = "Arsenal",
    [1962086868] = "Tower of Hell",
    [3101667897] = "Speed Legends",
    [10253248401] = "Elemental Powers TOC",
    [6732694052] = "Fish Game",
    [14184086618] = "Obby On Bike",
    [2551991523] = "Broken Bones IV",
    [2753915549] = "Blox Fruits",
    [3772394625] = "Blade Ball",
    [17625359962] = "Rivals",
    [6403373529] = "Slap Battles",
    [4924922222] = "Brookhaven",
    [126509999114328] = "99 nights",
    [126884695634066] = "Grow a Garden",
    [70876832253163] = "Dead Rails",
    [96342491571673] = "Steal a Brainrot",
    [109983668079237] = "Steal a Brainrot"
}

local Players     = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local player      = Players.LocalPlayer
local gui         = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name         = "SystemUI"
gui.ResetOnSpawn = false

-- Основной фрейм
local frame = Instance.new("Frame", gui)
frame.Size               = UDim2.new(0, 400, 0, 270)
frame.Position           = UDim2.new(0.5, -200, 0.5, -135)
frame.BackgroundColor3   = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel    = 0
frame.BackgroundTransparency = 0.1
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Заголовок и кнопка закрыть
local title = Instance.new("TextLabel", frame)
title.Size               = UDim2.new(1, -40, 0, 40)
title.Position           = UDim2.new(0, 10, 0, 10)
title.Text               = "🔥HUB"
title.Font               = Enum.Font.GothamBold
title.TextSize           = 24
title.TextColor3         = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextXAlignment     = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", frame)
close.Size               = UDim2.new(0, 30, 0, 30)
close.Position           = UDim2.new(1, -40, 0, 10)
close.Text               = "X"
close.Font               = Enum.Font.GothamBold
close.TextSize           = 20
close.TextColor3         = Color3.fromRGB(255, 85, 85)
close.BackgroundTransparency = 1
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Описание
local message = Instance.new("TextLabel", frame)
message.Size               = UDim2.new(1, -20, 0, 100)
message.Position           = UDim2.new(0, 10, 0, 60)
message.Font               = Enum.Font.Gotham
message.TextWrapped        = true
message.TextSize           = 18
message.TextColor3         = Color3.new(1,1,1)
message.BackgroundTransparency = 1
message.TextXAlignment     = Enum.TextXAlignment.Left
message.TextYAlignment     = Enum.TextYAlignment.Top

-- Кнопка действия
local button = Instance.new("TextButton", frame)
button.Size               = UDim2.new(0.6, 0, 0, 40)
button.Position           = UDim2.new(0.2, 0, 1, -50)
button.Font               = Enum.Font.GothamBold
button.TextSize           = 18
button.TextColor3         = Color3.new(1,1,1)
button.BackgroundColor3   = Color3.fromRGB(0, 170, 127)
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

-- Вспомогательная функция для списка игр
local function getGameList()
    local str = ""
    for id, name in pairs(allowedPlaces) do
        str = str .. ("🔹 %s (%d)\n"):format(name, id)
    end
    return str
end

-- Состояние кнопки
local hasOpened = false

-- Показ при неподдерживаемом плейсе
local function showNotSupported()
    message.Text = "😢 Этот плейс не поддерживается.\n\n📌 Поддерживаемые игры:\n" .. getGameList()
    button.Visible = false
end

-- Показ приглашения в Telegram
local function showTelegramPrompt()
    message.Text = "✉️ Подпишись на наш Telegram-канал @hard_fyl\n\nНажми кнопку, чтобы перейти. После подписки — нажми “✅ Я подписался”."
    button.Text = "📎 Перейти в Telegram"
    hasOpened = false
end

-- Логика клика по кнопке
button.MouseButton1Click:Connect(function()
    if not hasOpened then
        -- 1-й клик: редирект в Telegram
        GuiService:OpenBrowserWindow("https://t.me/hard_fyl")
        message.Text = "🔄 Открылось окно браузера. Подпишись и вернись, затем нажми “✅ Я подписался”."
        button.Text = "✅ Я подписался"
        hasOpened = true
    else
        -- 2-й клик: запускаем чит
        message.Text = "✅ Отлично! Загружаем скрипт..."
        wait(1)
        gui:Destroy()
        local url = "https://raw.githubusercontent.com/FOGOTY/scripts/" .. placeId .. "/main.lua"
        loadstring(game:HttpGet(url))()
    end
end)

-- Запуск
if allowedPlaces[placeId] then
    showTelegramPrompt()
else
    showNotSupported()
end
