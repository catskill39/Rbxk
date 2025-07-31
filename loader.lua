local HttpService = game:GetService("HttpService")
local Players     = game:GetService("Players")
local player      = Players.LocalPlayer
local placeId     = game.PlaceId

-- Список поддерживаемых плейсов
local allowedPlaces = {
    [142823291]       = "MM2",
    [537413528]       = "Build A Boat",
    [286090429]       = "Arsenal",
    [1962086868]      = "Tower of Hell",
    [3101667897]      = "Speed Legends",
    [10253248401]     = "Elemental Powers TOC",
    [6732694052]      = "Fish Game",
    [14184086618]     = "Obby On Bike",
    [2551991523]      = "Broken Bones IV",
    [2753915549]      = "Blox Fruits",
    [3772394625]      = "Blade Ball",
    [17625359962]     = "Rivals",
    [6403373529]      = "Slap Battles",
    [4924922222]      = "Brookhaven",
    [126509999114328] = "99 nights",
    [126884695634066] = "Grow a Garden",
    [70876832253163]  = "Dead Rails",
    [96342491571673]  = "Steal a Brainrot",
    [109983668079237] = "Steal a Brainrot"
}

-- Генерация премиум-ключей PREM1…PREM100
local premiumKeys = {}
for i = 1, 100 do
    premiumKeys[i] = "PREM"..i
end

-- Настройка Free-ключа
local encryptedFreeKey = "eerF"  -- "Free" наоборот
local function decryptKey(enc) return string.reverse(enc) end
local validFreeKey = decryptKey(encryptedFreeKey)

-- Файл для хранения времени старта Free
local timeFile = "foggy_free_time.txt"
local maxFreeDuration = 3 * 3600  -- 3 часа в секундах

local function checkFreeKeyUsage()
    if not isfile(timeFile) then
        writefile(timeFile, tostring(os.time()))
        return true
    end
    local stored = tonumber(readfile(timeFile)) or 0
    return (os.time() - stored) <= maxFreeDuration
end

-- UI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FoggySystemUI"; gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size               = UDim2.new(0, 400, 0, 320)
frame.Position           = UDim2.new(0.5, -200, 0.5, -160)
frame.BackgroundColor3   = Color3.fromRGB(20,20,20)
frame.BorderSizePixel    = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)
local frameGrad = Instance.new("UIGradient", frame)
frameGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30,30,30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15,15,15))
}
frameGrad.Rotation = 45

-- Мини-иконка Telegram в левом углу
local icon = Instance.new("ImageLabel", frame)
icon.Size               = UDim2.new(0, 40, 0, 40)
icon.Position           = UDim2.new(0, 10, 0, 10)
icon.BackgroundTransparency = 1
icon.Image              = "http://www.roblox.com/asset/?id=1234567890"

-- Заголовок
local title = Instance.new("TextLabel", frame)
title.Size               = UDim2.new(1, -60, 0, 40)
title.Position           = UDim2.new(0, 60, 0, 10)
title.Text               = "🔑 Ввод ключа — FOGGY HUB"
title.Font               = Enum.Font.GothamBold
title.TextSize           = 20
title.TextColor3         = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextXAlignment     = Enum.TextXAlignment.Left
Instance.new("UIStroke", title).Thickness = 1.5
local titleGrad = Instance.new("UIGradient", title)
titleGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,200,50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,120,80))
}
titleGrad.Rotation = 90

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
message.Text               = "Введите ключ доступа. Free работает 3 часа, премиум — навсегда."

-- Ввод ключа
local textbox = Instance.new("TextBox", frame)
textbox.Size               = UDim2.new(0.8,0,0,40)
textbox.Position           = UDim2.new(0.1,0,0,150)
textbox.PlaceholderText    = "Ваш ключ"
textbox.Font               = Enum.Font.Gotham
textbox.TextSize           = 18
textbox.TextColor3         = Color3.new(0,0,0)
textbox.BackgroundColor3   = Color3.fromRGB(235,235,235)
textbox.ClearTextOnFocus   = false
Instance.new("UICorner", textbox).CornerRadius = UDim.new(0,8)

-- Кнопка применения
local button = Instance.new("TextButton", frame)
button.Size               = UDim2.new(0.6,0,0,40)
button.Position           = UDim2.new(0.2,0,1,-50)
button.Text               = "🔓 Применить ключ"
button.Font               = Enum.Font.GothamBold
button.TextSize           = 18
button.TextColor3         = Color3.new(1,1,1)
button.BackgroundColor3   = Color3.fromRGB(0,170,127)
Instance.new("UICorner", button).CornerRadius = UDim.new(0,8)
local btnGrad = Instance.new("UIGradient", button)
btnGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,200,150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,120,100))
}
btnGrad.Rotation = 90

-- Клик по кнопке
button.MouseButton1Click:Connect(function()
    local key = textbox.Text or ""
    local isPremium = table.find(premiumKeys, key)
    local isFreeOK  = (key == validFreeKey) and checkFreeKeyUsage()

    if isPremium or isFreeOK then
        message.Text = "✅ Ключ принят! Загружаем скрипт..."
        wait(0.8)
        gui:Destroy()

        -- Здесь полный блок if-elseif для каждого плейса:
        if placeId == 142823291 then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FOGOTY/mm2-foggy/main/script"))()
        elseif placeId == 537413528 then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FOGOTY/builtaboataf/main/bab"))()
        elseif placeId == 286090429 then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FOGOTY/arsenal/refs/heads/main/script"))()
        elseif placeId == 1962086868 then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FOGOTY/TOH-Foggy/refs/heads/main/script"))()
        elseif placeId == 3101667897 then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FOGOTY/foggy-speedlegend/refs/heads/main/script"))()
        elseif placeId == 10253248401 then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FOGOTY/foggy-elementalpowtoc/refs/heads/main/script"))()
        elseif placeId == 6732694052 then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FOGOTY/fisch/refs/heads/main/script"))()
        elseif placeId == 14184086618 then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FOGOTY/obbyonbike/refs/heads/main/script"))()
        elseif placeId == 2551991523 then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FOGOTY/foggy-brokenbones4/refs/heads/main/script"))()
        elseif placeId == 2753915549 then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FOGOTY/foggy-bloxfruit/refs/heads/main/script"))()
        elseif placeId == 3772394625 then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FOGOTY/blade-ball/main/BBscript"))()
        elseif placeId == 17625359962 then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FOGOTY/rivals/refs/heads/main/script"))()
        elseif placeId == 6403373529 then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FOGOTY/slap-god/main/script"))()
        elseif placeId == 4924922222 then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FOGOTY/brookhaven/refs/heads/main/script"))()
        elseif placeId == 126509999114328 then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FOGOTY/99nights/refs/heads/main/script"))()
        elseif placeId == 126884695634066 then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FOGOTY/gag/refs/heads/main/script"))()
        elseif placeId == 70876832253163 then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FOGOTY/FoggyHub-deadrails/refs/heads/main/script"))()
        elseif placeId == 96342491571673 or placeId == 109983668079237 then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/FOGOTY/stealabrainrot/refs/heads/main/script"))()
        else
            warn("FoggyHub: ссылка для этого плейса не найдена!")
        end

    else
        message.Text = "❌ Неверный или истёкший ключ!"
    end
end)

-- Если плейс не поддерживается
if not allowedPlaces[placeId] then
    message.Text = "😢 Этот плейс не поддерживается."
    textbox.Visible = false
    button.Visible  = false
end
