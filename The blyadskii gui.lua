-- ============================================================
-- ADMIN PANEL — full combined script
-- ============================================================
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

_G.ADMIN = _G.ADMIN or {}

-- LANG
_G.ADMIN.lang = "en"
local L = {
    en = {
        open="OPEN ADMIN PANEL",close="CLOSE ADMIN PANEL",title="ADMIN PANEL",
        enterKey="ENTER ACCESS KEY",pasteKey="Paste key here",confirm="CONFIRM",cancel="CANCEL",
        wrongKey="Wrong key",player="Player",visual="Visual",tools="Tools",esp="ESP",aimbot="Aimbot",
        settings="Settings",playerName="Player name",tpAll="Teleport everyone to me",
        walkSpeed="WalkSpeed",jumpPower="JumpPower",health="Health",infJump="Infinite Jump",
        respawn="Respawn",fullbright="Fullbright",brightness="Brightness",nightMode="Night Mode",
        execLua="Execute Lua",showFps="Show FPS",espEnabled="ESP Enabled",
        showNameDist="Show Name and Distance",clearEsp="Clear ESP",aimbotEnabled="Aimbot Enabled",
        fov="FOV",smoothness="Smoothness",mobileMode="Mobile Mode",targetHead="Target Head",
        targetTorso="Target Torso",language="Language",outlineColor="Outline Color",
        rainbow="Rainbow",red="Red",green="Green",blue="Blue",purple="Purple",orange="Orange",
        white="White",custom="Custom"
    },
    ru = {
        open="ОТКРЫТЬ АДМИН ПАНЕЛЬ",close="ЗАКРЫТЬ АДМИН ПАНЕЛЬ",title="АДМИН ПАНЕЛЬ",
        enterKey="ВВЕДИТЕ КЛЮЧ",pasteKey="Вставь ключ сюда",confirm="ПОДТВЕРДИТЬ",cancel="ОТМЕНА",
        wrongKey="Неверный ключ",player="Игрок",visual="Визуал",tools="Инструменты",esp="ЕСП",
        aimbot="Аимбот",settings="Настройки",playerName="Имя игрока",tpAll="Телепорт всех ко мне",
        walkSpeed="Скорость",jumpPower="Прыжок",health="Здоровье",infJump="Бесконечный прыжок",
        respawn="Респавн",fullbright="Яркий свет",brightness="Яркость",nightMode="Ночь",
        execLua="Выполнить Lua",showFps="Показать FPS",espEnabled="Вкл ЕСП",
        showNameDist="Имя и дистанция",clearEsp="Очистить ЕСП",aimbotEnabled="Вкл Аимбот",
        fov="Радиус",smoothness="Плавность",mobileMode="Моб. режим",targetHead="Цель: Голова",
        targetTorso="Цель: Торс",language="Язык",outlineColor="Цвет обводки",
        rainbow="Радужный",red="Красный",green="Зелёный",blue="Синий",purple="Фиолетовый",
        orange="Оранжевый",white="Белый",custom="Свой"
    }
}
_G.ADMIN.t = function(k) return (L[_G.ADMIN.lang] or L.en)[k] or k end

-- KEY
local function genKey()
    local c = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local k = "KEY-"
    for i = 1, 8 do
        local n = math.random(1, #c)
        k = k .. string.sub(c, n, n)
    end
    return k
end
math.randomseed(os.time() + math.floor(tick() * 1000) % 100000)
local KEY = genKey()
pcall(function()
    if setclipboard then setclipboard(KEY)
    elseif toclipboard then toclipboard(KEY) end
end)

-- RAINBOW BUTTON
local rGui = Instance.new("ScreenGui")
rGui.ResetOnSpawn = false
rGui.Parent = CoreGui

local rBtn = Instance.new("TextButton", rGui)
rBtn.Size = UDim2.new(0, 170, 0, 52)
rBtn.Position = UDim2.new(0, 12, 0.5, -26)
rBtn.Text = _G.ADMIN.t("open")
rBtn.Font = Enum.Font.GothamBold
rBtn.TextSize = 12
rBtn.TextColor3 = Color3.new(1,1,1)
rBtn.BackgroundColor3 = Color3.fromRGB(30,30,40)
rBtn.BorderSizePixel = 0
rBtn.AutoButtonColor = false
Instance.new("UICorner", rBtn).CornerRadius = UDim.new(0,10)
local rStroke = Instance.new("UIStroke", rBtn)
rStroke.Thickness = 3
local rGrad = Instance.new("UIGradient", rBtn)
rGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255,0,0)),
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255,150,0)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255,255,0)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0,255,0)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0,150,255)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(180,0,255)),
})
task.spawn(function()
    local t = 0
    while rGui.Parent do
        t = t + 0.01
        rStroke.Color = Color3.fromHSV(t % 1, 1, 1)
        rGrad.Rotation = (t * 360) % 360
        task.wait(0.03)
    end
end)

-- ADMIN GUI
local aGui = Instance.new("ScreenGui")
aGui.ResetOnSpawn = false
aGui.Enabled = false
aGui.IgnoreGuiInset = true
aGui.Parent = CoreGui

local panelW = math.min(600, workspace.CurrentCamera.ViewportSize.X - 20)
local main = Instance.new("Frame", aGui)
main.Size = UDim2.new(0, panelW, 0, 440)
main.Position = UDim2.new(0.5, -panelW/2, 0.5, -220)
main.BackgroundColor3 = Color3.fromRGB(20,20,30)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)
local mStroke = Instance.new("UIStroke", main)
mStroke.Color = Color3.fromRGB(180,0,255)
mStroke.Thickness = 2

local outlineRainbow = false
local outlineColor = Color3.fromRGB(180,0,255)
_G.ADMIN.setOutline = function(mode, color)
    outlineRainbow = (mode == "rainbow")
    if color then outlineColor = color end
    if not outlineRainbow then mStroke.Color = outlineColor end
end
task.spawn(function()
    local t = 0
    while main.Parent do
        if outlineRainbow then
            t = t + 0.01
            mStroke.Color = Color3.fromHSV(t % 1, 1, 1)
        end
        task.wait(0.03)
    end
end)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,45)
title.BackgroundColor3 = Color3.fromRGB(35,35,55)
title.BorderSizePixel = 0
title.Text = _G.ADMIN.t("title")
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(200,100,255)
Instance.new("UICorner", title).CornerRadius = UDim.new(0,12)

local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0,40,0,40)
closeBtn.Position = UDim2.new(1,-45,0,2)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,8)

-- KEY SCREEN
local kFrame = Instance.new("Frame", main)
kFrame.Size = UDim2.new(1,-20,1,-60)
kFrame.Position = UDim2.new(0,10,0,50)
kFrame.BackgroundColor3 = Color3.fromRGB(25,25,40)
kFrame.BorderSizePixel = 0
kFrame.Visible = false
Instance.new("UICorner", kFrame).CornerRadius = UDim.new(0,10)

local kTitle = Instance.new("TextLabel", kFrame)
kTitle.Size = UDim2.new(1,0,0,45)
kTitle.BackgroundTransparency = 1
kTitle.Text = _G.ADMIN.t("enterKey")
kTitle.Font = Enum.Font.GothamBold
kTitle.TextSize = 18
kTitle.TextColor3 = Color3.fromRGB(255,180,0)

local kBox = Instance.new("TextBox", kFrame)
kBox.Size = UDim2.new(0.9,0,0,50)
kBox.Position = UDim2.new(0.05,0,0,70)
kBox.BackgroundColor3 = Color3.fromRGB(40,40,60)
kBox.BorderSizePixel = 0
kBox.Text = ""
kBox.PlaceholderText = _G.ADMIN.t("pasteKey")
kBox.Font = Enum.Font.Gotham
kBox.TextSize = 16
kBox.TextColor3 = Color3.new(1,1,1)
kBox.PlaceholderColor3 = Color3.fromRGB(120,120,150)
Instance.new("UICorner", kBox).CornerRadius = UDim.new(0,8)

local kConf = Instance.new("TextButton", kFrame)
kConf.Size = UDim2.new(0.9,0,0,50)
kConf.Position = UDim2.new(0.05,0,0,135)
kConf.BackgroundColor3 = Color3.fromRGB(0,180,80)
kConf.Text = _G.ADMIN.t("confirm")
kConf.Font = Enum.Font.GothamBold
kConf.TextSize = 16
kConf.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", kConf).CornerRadius = UDim.new(0,8)

local kCancel = Instance.new("TextButton", kFrame)
kCancel.Size = UDim2.new(0.9,0,0,38)
kCancel.Position = UDim2.new(0.05,0,0,195)
kCancel.BackgroundColor3 = Color3.fromRGB(60,60,80)
kCancel.Text = _G.ADMIN.t("cancel")
kCancel.Font = Enum.Font.GothamBold
kCancel.TextSize = 14
kCancel.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", kCancel).CornerRadius = UDim.new(0,8)

-- CONTENT
local cFrame = Instance.new("Frame", main)
cFrame.Size = UDim2.new(1,-20,1,-60)
cFrame.Position = UDim2.new(0,10,0,50)
cFrame.BackgroundTransparency = 1
cFrame.Visible = false

local tBar = Instance.new("Frame", cFrame)
tBar.Size = UDim2.new(0,130,1,0)
tBar.BackgroundColor3 = Color3.fromRGB(28,28,45)
tBar.BorderSizePixel = 0
Instance.new("UICorner", tBar).CornerRadius = UDim.new(0,8)
local tPad = Instance.new("UIPadding", tBar)
tPad.PaddingTop = UDim.new(0,8)
tPad.PaddingLeft = UDim.new(0,6)
tPad.PaddingRight = UDim.new(0,6)

local tScroll = Instance.new("ScrollingFrame", tBar)
tScroll.Size = UDim2.new(1,0,1,0)
tScroll.BackgroundTransparency = 1
tScroll.BorderSizePixel = 0
tScroll.ScrollBarThickness = 4
tScroll.CanvasSize = UDim2.new(0,0,0,0)
local tList = Instance.new("UIListLayout", tScroll)
tList.Padding = UDim.new(0,4)

local tContent = Instance.new("Frame", cFrame)
tContent.Size = UDim2.new(1,-140,1,0)
tContent.Position = UDim2.new(0,140,0,0)
tContent.BackgroundColor3 = Color3.fromRGB(28,28,45)
tContent.BorderSizePixel = 0
Instance.new("UICorner", tContent).CornerRadius = UDim.new(0,8)

local cScroll = Instance.new("ScrollingFrame", tContent)
cScroll.Size = UDim2.new(1,-16,1,-16)
cScroll.Position = UDim2.new(0,8,0,8)
cScroll.BackgroundTransparency = 1
cScroll.BorderSizePixel = 0
cScroll.ScrollBarThickness = 5
cScroll.CanvasSize = UDim2.new(0,0,0,0) -- UTILS
local function mBtn(parent, text, color, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-10,0,44)
    b.BackgroundColor3 = color or Color3.fromRGB(60,60,100)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.TextColor3 = Color3.new(1,1,1)
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    b.MouseButton1Click:Connect(cb)
    return b
end

local function mInput(parent, ph, cb)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1,-10,0,44)
    f.BackgroundColor3 = Color3.fromRGB(40,40,60)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,6)
    local tb = Instance.new("TextBox", f)
    tb.Size = UDim2.new(1,-70,1,0)
    tb.Position = UDim2.new(0,8,0,0)
    tb.BackgroundTransparency = 1
    tb.PlaceholderText = ph
    tb.Font = Enum.Font.Gotham
    tb.TextSize = 13
    tb.TextColor3 = Color3.new(1,1,1)
    tb.PlaceholderColor3 = Color3.fromRGB(130,130,160)
    tb.Text = ""
    local go = Instance.new("TextButton", f)
    go.Size = UDim2.new(0,55,1,-8)
    go.Position = UDim2.new(1,-60,0,4)
    go.BackgroundColor3 = Color3.fromRGB(0,150,80)
    go.Text = "GO"
    go.Font = Enum.Font.GothamBold
    go.TextSize = 13
    go.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", go).CornerRadius = UDim.new(0,5)
    go.MouseButton1Click:Connect(function() cb(tb.Text) end)
    return tb
end

local function mSlider(parent, label, mn, mx, def, cb)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1,-10,0,62)
    f.BackgroundColor3 = Color3.fromRGB(40,40,60)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,6)
    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1,-20,0,24)
    lbl.Position = UDim2.new(0,10,0,5)
    lbl.BackgroundTransparency = 1
    lbl.Text = label .. ": " .. tostring(def)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local hit = Instance.new("Frame", f)
    hit.Size = UDim2.new(1,-20,0,28)
    hit.Position = UDim2.new(0,10,0,30)
    hit.BackgroundTransparency = 1
    local bar = Instance.new("Frame", hit)
    bar.Size = UDim2.new(1,0,0,8)
    bar.Position = UDim2.new(0,0,0.5,-4)
    bar.BackgroundColor3 = Color3.fromRGB(60,60,90)
    bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new(0,0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(180,0,255)
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)
    local knob = Instance.new("Frame", fill)
    knob.Size = UDim2.new(0,20,0,20)
    knob.Position = UDim2.new(0,-10,0.5,-10)
    knob.BackgroundColor3 = Color3.fromRGB(230,230,255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 3
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)
    local function setV(v)
        v = math.clamp(v, mn, mx)
        local r = (v - mn) / (mx - mn)
        fill.Size = UDim2.new(r,0,1,0)
        knob.Position = UDim2.new(1,-10,0.5,-10)
        lbl.Text = label .. ": " .. math.floor(v)
        cb(v)
    end
    setV(def)
    local dr = false
    local function upd(x)
        local r = (x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
        setV(mn + (mx - mn) * math.clamp(r,0,1))
    end
    hit.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dr = true
            upd(i.Position.X)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dr and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            upd(i.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dr = false
        end
    end)
    return f
end

local function mToggle(parent, label, def, cb)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1,-10,0,46)
    f.BackgroundColor3 = Color3.fromRGB(40,40,60)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,6)
    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1,-80,1,0)
    lbl.Position = UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local tr = Instance.new("Frame", f)
    tr.Size = UDim2.new(0,50,0,26)
    tr.Position = UDim2.new(1,-60,0.5,-13)
    tr.BackgroundColor3 = def and Color3.fromRGB(0,180,80) or Color3.fromRGB(70,70,90)
    tr.BorderSizePixel = 0
    Instance.new("UICorner", tr).CornerRadius = UDim.new(1,0)
    local kn = Instance.new("Frame", tr)
    kn.Size = UDim2.new(0,22,0,22)
    kn.Position = def and UDim2.new(1,-24,0.5,-11) or UDim2.new(0,2,0.5,-11)
    kn.BackgroundColor3 = Color3.new(1,1,1)
    kn.BorderSizePixel = 0
    Instance.new("UICorner", kn).CornerRadius = UDim.new(1,0)
    local st = def
    local cb2 = Instance.new("TextButton", f)
    cb2.Size = UDim2.new(1,0,1,0)
    cb2.BackgroundTransparency = 1
    cb2.Text = ""
    cb2.MouseButton1Click:Connect(function()
        st = not st
        if st then
            tr.BackgroundColor3 = Color3.fromRGB(0,180,80)
            kn.Position = UDim2.new(1,-24,0.5,-11)
        else
            tr.BackgroundColor3 = Color3.fromRGB(70,70,90)
            kn.Position = UDim2.new(0,2,0.5,-11)
        end
        cb(st)
    end)
    return f
end

-- TABS
local pages = {}
local tabBtns = {}
local function addTab(nameKey, order)
    local t = Instance.new("TextButton", tScroll)
    t.Size = UDim2.new(1,0,0,40)
    t.BackgroundColor3 = Color3.fromRGB(45,45,70)
    t.Text = _G.ADMIN.t(nameKey)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 12
    t.TextColor3 = Color3.new(1,1,1)
    t.LayoutOrder = order
    Instance.new("UICorner", t).CornerRadius = UDim.new(0,6)
    local p = Instance.new("Frame", cScroll)
    p.Size = UDim2.new(1,0,1,0)
    p.BackgroundTransparency = 1
    p.Visible = false
    local l = Instance.new("UIListLayout", p)
    l.Padding = UDim.new(0,6)
    pages[#pages+1] = p
    tabBtns[nameKey] = t
    t.MouseButton1Click:Connect(function()
        for _, pg in ipairs(pages) do pg.Visible = false end
        p.Visible = true
        cScroll.CanvasSize = UDim2.new(0,0,0,l.AbsoluteContentSize.Y + 20)
    end)
    return p
end

-- PLAYER TAB
local tP = addTab("player",1)
mInput(tP, _G.ADMIN.t("playerName"), function(n)
    local tg = Players:FindFirstChild(n)
    if tg and tg.Character and LP.Character then
        LP.Character:PivotTo(tg.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3))
    end
end)
mBtn(tP, _G.ADMIN.t("tpAll"), Color3.fromRGB(80,80,180), function()
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LP and pl.Character and LP.Character then
            pl.Character:PivotTo(LP.Character.HumanoidRootPart.CFrame)
        end
    end
end)
mSlider(tP, _G.ADMIN.t("walkSpeed"), 0, 500, 16, function(v)
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = v end
end)
mSlider(tP, _G.ADMIN.t("jumpPower"), 0, 500, 50, function(v)
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then h.JumpPower = v end
end)
mSlider(tP, _G.ADMIN.t("health"), 1, 1000, 100, function(v)
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then h.MaxHealth = math.max(h.MaxHealth, v) h.Health = v end
end)
local infJump = false
UIS.JumpRequest:Connect(function()
    if infJump and LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)
mToggle(tP, _G.ADMIN.t("infJump"), false, function(s) infJump = s end)
mBtn(tP, _G.ADMIN.t("respawn"), Color3.fromRGB(200,50,50), function()
    if LP.Character then LP.Character:BreakJoints() end
end)

-- VISUAL TAB
local tV = addTab("visual",2)
mToggle(tV, _G.ADMIN.t("fullbright"), false, function(s)
    if s then
        Lighting.Brightness = 5
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
    else
        Lighting.Brightness = 1
        Lighting.Ambient = Color3.fromRGB(70,70,70)
        Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
    end
end)
mSlider(tV, _G.ADMIN.t("brightness"), 0, 10, 1, function(v) Lighting.Brightness = v end)
mToggle(tV, _G.ADMIN.t("nightMode"), false, function(s)
    if s then
        Lighting.Brightness = 0
        Lighting.Ambient = Color3.fromRGB(30,30,50)
    else
        Lighting.Brightness = 1
        Lighting.Ambient = Color3.fromRGB(70,70,70)
    end
end)

-- TOOLS TAB
local tT = addTab("tools",3)
mInput(tT, _G.ADMIN.t("execLua"), function(c)
    local fn, e = loadstring(c)
    if fn then fn() else warn(e) end
end)
mToggle(tT, _G.ADMIN.t("showFps"), false, function(s)
    local ex = aGui:FindFirstChild("FpsLbl")
    if s then
        if ex then return end
        local f = Instance.new("TextLabel", aGui)
        f.Name = "FpsLbl"
        f.Size = UDim2.new(0,150,0,32)
        f.Position = UDim2.new(1,-160,0,5)
        f.BackgroundColor3 = Color3.fromRGB(0,0,0)
        f.TextColor3 = Color3.new(0,1,0)
        f.Font = Enum.Font.Code
        f.TextSize = 14
        f.Text = "FPS: 60"
        local fr, ls = 0, tick()
        RunService.RenderStepped:Connect(function()
            if not f.Parent then return end
            fr = fr + 1
            if tick() - ls >= 1 then
                f.Text = "FPS: " .. fr
                fr = 0
                ls = tick()
            end
        end)
    else
        if ex then ex:Destroy() end
    end
end) -- ESP TAB
local tESP = addTab("esp",4)
local espOn = false
local function clearESP()
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then
            for _, obj in ipairs(pl.Character:GetDescendants()) do
                if obj.Name == "AdminESP" then obj:Destroy() end
            end
        end
    end
end
local function createESP(pl)
    if pl == LP or not pl.Character then return end
    local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or hrp:FindFirstChild("AdminESP") then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "AdminESP"
    box.Size = Vector3.new(4,5,1)
    box.Adornee = hrp
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Transparency = 0.7
    box.Color3 = Color3.fromRGB(255,0,0)
    box.Parent = hrp
end
local espGui = Instance.new("ScreenGui")
espGui.Name = "ESPOverlay"
espGui.ResetOnSpawn = false
espGui.IgnoreGuiInset = true
espGui.Parent = CoreGui
local function clearLbl()
    for _, v in ipairs(espGui:GetChildren()) do
        if v:IsA("TextLabel") then v:Destroy() end
    end
end
mToggle(tESP, _G.ADMIN.t("espEnabled"), false, function(s)
    espOn = s
    if s then
        for _, pl in ipairs(Players:GetPlayers()) do createESP(pl) end
    else
        clearESP()
        clearLbl()
    end
end)
local showInfo = true
mToggle(tESP, _G.ADMIN.t("showNameDist"), true, function(s) showInfo = s end)
mBtn(tESP, _G.ADMIN.t("clearEsp"), Color3.fromRGB(200,50,50), function()
    espOn = false
    clearESP()
    clearLbl()
end)
RunService.RenderStepped:Connect(function()
    if not espOn then return end
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LP and pl.Character then
            local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
            local hum = pl.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local sp, on = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
                if on then
                    local nm = "E_" .. pl.Name
                    local lbl = espGui:FindFirstChild(nm)
                    if not lbl then
                        lbl = Instance.new("TextLabel", espGui)
                        lbl.Name = nm
                        lbl.BackgroundTransparency = 1
                        lbl.Font = Enum.Font.GothamBold
                        lbl.TextSize = 14
                        lbl.TextColor3 = Color3.fromRGB(255,80,80)
                        lbl.TextStrokeTransparency = 0
                    end
                    local dist = 0
                    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                        dist = math.floor((LP.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                    end
                    lbl.Position = UDim2.new(0,sp.X - 100,0,sp.Y - 60)
                    lbl.Size = UDim2.new(0,200,0,20)
                    if showInfo then
                        lbl.Text = pl.Name .. " [" .. dist .. "m]"
                    else
                        lbl.Text = pl.Name
                    end
                end
            end
        end
    end
end)

-- AIMBOT TAB
local tAim = addTab("aimbot",5)
local aimOn = false
local aimFOV = 150
local aimSmooth = 5
local aimPart = "Head"
local mobileMode = true
local function getClosest()
    local best, short = nil, aimFOV
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LP and pl.Character then
            local part = pl.Character:FindFirstChild(aimPart)
            local hum = pl.Character:FindFirstChildOfClass("Humanoid")
            if part and hum and hum.Health > 0 then
                local sp, on = cam:WorldToViewportPoint(part.Position)
                if on then
                    local d = (Vector2.new(sp.X,sp.Y) - center).Magnitude
                    if d < short then
                        short = d
                        best = part
                    end
                end
            end
        end
    end
    return best
end
mToggle(tAim, _G.ADMIN.t("aimbotEnabled"), false, function(s) aimOn = s end)
mSlider(tAim, _G.ADMIN.t("fov"), 10, 500, 150, function(v) aimFOV = v end)
mSlider(tAim, _G.ADMIN.t("smoothness"), 1, 20, 5, function(v) aimSmooth = v end)
mToggle(tAim, _G.ADMIN.t("mobileMode"), true, function(s) mobileMode = s end)
mBtn(tAim, _G.ADMIN.t("targetHead"), Color3.fromRGB(80,120,200), function() aimPart = "Head" end)
mBtn(tAim, _G.ADMIN.t("targetTorso"), Color3.fromRGB(80,120,200), function() aimPart = "Torso" end)
RunService.RenderStepped:Connect(function()
    if not aimOn then return end
    if not mobileMode then
        if not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
    end
    local target = getClosest()
    if target then
        local cam = workspace.CurrentCamera
        local pos = cam.CFrame.Position
        local alpha = 1 / math.max(aimSmooth, 1)
        cam.CFrame = CFrame.new(pos, pos + (target.Position - pos) * alpha)
    end
end)

-- SETTINGS TAB
local tSet = addTab("settings",6)
local function rebuildLang()
    rBtn.Text = aGui.Enabled and _G.ADMIN.t("close") or _G.ADMIN.t("open")
    title.Text = _G.ADMIN.t("title")
    kTitle.Text = _G.ADMIN.t("enterKey")
    kConf.Text = _G.ADMIN.t("confirm")
    kCancel.Text = _G.ADMIN.t("cancel")
    for key, btn in pairs(tabBtns) do
        btn.Text = _G.ADMIN.t(key)
    end
end
mBtn(tSet, "English", Color3.fromRGB(80,120,200), function()
    _G.ADMIN.lang = "en"
    rebuildLang()
end)
mBtn(tSet, "Русский", Color3.fromRGB(200,80,80), function()
    _G.ADMIN.lang = "ru"
    rebuildLang()
end)
mBtn(tSet, _G.ADMIN.t("rainbow"), Color3.fromRGB(180,0,255), function()
    _G.ADMIN.setOutline("rainbow")
end)
mBtn(tSet, _G.ADMIN.t("red"), Color3.fromRGB(220,50,50), function()
    _G.ADMIN.setOutline("color", Color3.fromRGB(255,50,50))
end)
mBtn(tSet, _G.ADMIN.t("green"), Color3.fromRGB(50,200,50), function()
    _G.ADMIN.setOutline("color", Color3.fromRGB(50,255,50))
end)
mBtn(tSet, _G.ADMIN.t("blue"), Color3.fromRGB(50,100,255), function()
    _G.ADMIN.setOutline("color", Color3.fromRGB(50,150,255))
end)
mBtn(tSet, _G.ADMIN.t("purple"), Color3.fromRGB(180,0,255), function()
    _G.ADMIN.setOutline("color", Color3.fromRGB(180,0,255))
end)
mBtn(tSet, _G.ADMIN.t("orange"), Color3.fromRGB(255,150,0), function()
    _G.ADMIN.setOutline("color", Color3.fromRGB(255,150,0))
end)
mBtn(tSet, _G.ADMIN.t("white"), Color3.fromRGB(230,230,230), function()
    _G.ADMIN.setOutline("color", Color3.new(1,1,1))
end)
mInput(tSet, _G.ADMIN.t("custom") .. " (R,G,B)", function(txt)
    local r, g, b = txt:match("(%d+),(%d+),(%d+)")
    if r and g and b then
        _G.ADMIN.setOutline("color", Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b)))
    end
end)

-- OPEN/CLOSE
local unlocked = false
local function showKey()
    main.Visible = true
    kFrame.Visible = true
    cFrame.Visible = false
    kBox.Text = ""
end
local function showPanel()
    main.Visible = true
    kFrame.Visible = false
    cFrame.Visible = true
    if pages[1] then
        for _, p in ipairs(pages) do p.Visible = false end
        pages[1].Visible = true
        cScroll.CanvasSize = UDim2.new(0,0,0,pages[1].UIListLayout.AbsoluteContentSize.Y + 20)
    end
end
local function closePanel()
    aGui.Enabled = false
    rBtn.Text = _G.ADMIN.t("open")
end
local function openPanel()
    aGui.Enabled = true
    rBtn.Text = _G.ADMIN.t("close")
    if unlocked then showPanel() else showKey() end
end

kConf.MouseButton1Click:Connect(function()
    local e = kBox.Text:gsub("%s", ""):upper()
    if e == "" then return end
    if e == KEY:upper() then
        unlocked = true
        showPanel()
    else
        kBox.Text = ""
        kBox.PlaceholderText = _G.ADMIN.t("wrongKey")
        kBox.PlaceholderColor3 = Color3.fromRGB(255,100,100)
        task.delay(2, function()
            kBox.PlaceholderText = _G.ADMIN.t("pasteKey")
            kBox.PlaceholderColor3 = Color3.fromRGB(120,120,150)
        end)
    end
end)

kCancel.MouseButton1Click:Connect(closePanel)
closeBtn.MouseButton1Click:Connect(closePanel)

rBtn.MouseButton1Click:Connect(function()
    if aGui.Enabled then closePanel() else openPanel() end
end)

-- DRAG
local function drag(f, h)
    local d, ds, sp = false, nil, nil
    h.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            d = true
            ds = i.Position
            sp = f.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local dl = i.Position - ds
            f.Position = UDim2.new(sp.X.Scale, sp.X.Offset + dl.X, sp.Y.Scale, sp.Y.Offset + dl.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            d = false
        end
    end)
end
drag(main, title)
drag(main, kTitle)

print("[ADMIN] Loaded successfully")
