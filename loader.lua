--[[
   📦 FOGGY SYSTEM UI с ключ-системой
   Автор: ты 😎
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
local player      = Players.LocalPlayer
local gui         = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name         = "FoggySystemUI"
gui.ResetOnSpawn = false

-- Основной фрейм
local frame = Instance.new("Frame", gui)
frame.Size               = UDim2.new(0, 400, 0, 300)
frame.Position           = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3   = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel    = 0
frame.BackgroundTransparency = 0.1
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Заголовок и кнопка закрыть
local title = Instance.new("TextLabel", frame)
title.Size               = UDim2.new(1, -40, 0, 40)
title.Position           = UDim2.new(0, 10, 0, 10)
title.Text               = "🔑 Ввод ключа — FOGGY HUB"
title.Font               = Enum.Font.GothamBold
title.TextSize           = 20
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
message.Size               = UDim2.new(1, -20, 0, 80)
message.Position           = UDim2.new(0, 10, 0, 60)
message.Font               = Enum.Font.Gotham
message.TextWrapped        = true
message.TextSize           = 18
message.TextColor3         = Color3.new(1,1,1)
message.BackgroundTransparency = 1
message.TextXAlignment     = Enum.TextXAlignment.Left
message.TextYAlignment     = Enum.TextYAlignment.Top
message.Text               = "Введите ключ доступа, чтобы продолжить. Для начала ключ — Free"

-- Поле ввода ключа
local textbox = Instance.new("TextBox", frame)
textbox.Size               = UDim2.new(0.8, 0, 0, 40)
textbox.Position           = UDim2.new(0.1, 0, 0, 150)
textbox.PlaceholderText    = "Ваш ключ"
textbox.Font               = Enum.Font.Gotham
textbox.TextSize           = 18
textbox.TextColor3         = Color3.new(0,0,0)
textbox.BackgroundColor3   = Color3.fromRGB(235,235,235)
textbox.ClearTextOnFocus   = false
Instance.new("UICorner", textbox).CornerRadius = UDim.new(0, 8)

-- Кнопка проверки
local button = Instance.new("TextButton", frame)
button.Size               = UDim2.new(0.6, 0, 0, 40)
button.Position           = UDim2.new(0.2, 0, 1, -50)
button.Text               = "🔓 Применить ключ"
button.Font               = Enum.Font.GothamBold
button.TextSize           = 18
button.TextColor3         = Color3.new(1,1,1)
button.BackgroundColor3   = Color3.fromRGB(0, 170, 127)
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

-- Функция «расшифровки» ключа (просто реверс для примера)
local encryptedKey = "eerF"  -- "Free" наоборот
local function decryptKey(enc)
    return string.reverse(enc)
end
local validKey = decryptKey(encryptedKey)

-- Список доступных игр
local function getGameList()
    local str = ""
    for id, name in pairs(allowedPlaces) do
        str = str .. ("%s (%d)\n"):format(name, id)
    end
    return str
end

-- Логика кнопки
button.MouseButton1Click:Connect(function()
    local input = textbox.Text or ""
    if input == validKey then
        message.Text = "✅ Ключ верен! Загружаем скрипт..."
        wait(0.8)
        gui:Destroy()
        -- Загрузка чита
        local url = "https://raw.githubusercontent.com/FOGOTY/scripts/" .. placeId .. "/main.lua"
        loadstring(game:HttpGet(url))()
    else
        message.Text = "❌ Неверный ключ! Попробуй ещё раз."
        -- Можно добавить анимацию ошибки тут
    end
end)

-- Старт: проверяем, поддерживается ли плейс
if not allowedPlaces[placeId] then
    message.Text = "😢 Этот плейс не поддерживается.\n\n📌 Доступные игры:\n" .. getGameList()
    textbox.Visible = false
    button.Visible = false
end
