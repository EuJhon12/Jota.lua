-- =================================================================
-- JHONSCRIPT - VV: ULTIMATUM (Roxo & Preto + Mini UI Personalizada)
-- =================================================================

-- 1. Isolamento de Ambiente e Segurança Básica
local getgenv = getgenv or function() return _G end
local protectgui = protectgui or function(gui) gui.Parent = game:GetService("CoreGui") end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local MarketplaceService = game:GetService("MarketplaceService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local function SafeCall(func, ...)
    local success, err = pcall(func, ...)
    if not success then return nil end
    return err
end

-- Estado das Funções
local Config = {
    AutoFarm = false,
    AutoParry = false,
    ESPPlayers = false,
    ESPNpcs = false,
    ESPQuests = false,
    ESPItems = false,
    UIOpacity = 1,
    Optimization = false
}

-- 2. Criando a Interface Gráfica
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JhonScript_UI_" .. math.random(10000, 99999)
ScreenGui.ResetOnSpawn = false

SafeCall(function() protectgui(ScreenGui) end)
if not ScreenGui.Parent then ScreenGui.Parent = game:GetService("CoreGui") end

-- Janela Principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 340)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Barra Lateral de Abas (Sidebar)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 20, 28)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 10)
SideCorner.Parent = Sidebar

local LogoLabel = Instance.new("TextLabel")
LogoLabel.Size = UDim2.new(1, 0, 0, 50)
LogoLabel.BackgroundTransparency = 1
LogoLabel.Text = "JHON SCRIPT"
LogoLabel.TextColor3 = Color3.fromRGB(170, 85, 255)
LogoLabel.TextSize = 14
LogoLabel.Font = Enum.Font.GothamBold
LogoLabel.Parent = Sidebar

-- Mini UI Flutuante Personalizada (Fundo Preto, J Branco, S Roxo)
local MiniBtn = Instance.new("TextButton")
MiniBtn.Size = UDim2.new(0, 48, 0, 48)
MiniBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
MiniBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Fundo Preto puro
MiniBtn.Text = ""
MiniBtn.Active = true
MiniBtn.Draggable = true
MiniBtn.Visible = false
MiniBtn.Parent = ScreenGui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 12)
MiniCorner.Parent = MiniBtn

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = Color3.fromRGB(120, 40, 200)
MiniStroke.Thickness = 1.5
MiniStroke.Parent = MiniBtn

-- Letra J (Branca)
local LabelJ = Instance.new("TextLabel")
LabelJ.Size = UDim2.new(0.5, 0, 1, 0)
LabelJ.Position = UDim2.new(0, 0, 0, 0)
LabelJ.BackgroundTransparency = 1
LabelJ.Text = "J"
LabelJ.TextColor3 = Color3.fromRGB(255, 255, 255)
LabelJ.TextSize = 16
LabelJ.Font = Enum.Font.GothamBold
LabelJ.Parent = MiniBtn

-- Letra S (Roxa)
local LabelS = Instance.new("TextLabel")
LabelS.Size = UDim2.new(0.5, 0, 1, 0)
LabelS.Position = UDim2.new(0.5, 0, 0, 0)
LabelS.BackgroundTransparency = 1
LabelS.Text = "S"
LabelS.TextColor3 = Color3.fromRGB(170, 85, 255)
LabelS.TextSize = 16
LabelS.Font = Enum.Font.GothamBold
LabelS.Parent = MiniBtn

-- Container de Conteúdo das Abas
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -140, 1, -20)
Container.Position = UDim2.new(0, 135, 0, 10)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

-- Sistema de Abas
local tabs = {}
local function CreateTab(name, posY)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0.9, 0, 0, 36)
    TabBtn.Position = UDim2.new(0.05, 0, 0, posY)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 27, 38)
    TabBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
    TabBtn.TextSize = 13
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.Text = name
    TabBtn.Parent = Sidebar

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = TabBtn

    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.CanvasSize = UDim2.new(0, 0, 1.5, 0)
    TabContent.ScrollBarThickness = 4
    TabContent.Visible = false
    TabContent.Parent = Container

    table.insert(tabs, {btn = TabBtn, content = TabContent})
    return TabContent
end

local function SwitchTab(targetContent)
    for _, tab in ipairs(tabs) do
        if tab.content == targetContent then
            tab.content.Visible = true
            tab.btn.BackgroundColor3 = Color3.fromRGB(120, 40, 200)
            tab.btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            tab.content.Visible = false
            tab.btn.BackgroundColor3 = Color3.fromRGB(30, 27, 38)
            tab.btn.TextColor3 = Color3.fromRGB(180, 180, 190)
        end
    end
end

-- Criando as 4 Abas
local MainTab = CreateTab("Main", 60)
local FuncsTab = CreateTab("Funcs", 105)
local EspTab = CreateTab("ESP", 150)
local ConfigTab = CreateTab("Config", 195)

-- Botão de Minimizar na Sidebar
local MinSideBtn = Instance.new("TextButton")
MinSideBtn.Size = UDim2.new(0.9, 0, 0, 32)
MinSideBtn.Position = UDim2.new(0.05, 0, 1, -75)
MinSideBtn.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
MinSideBtn.TextColor3 = Color3.fromRGB(210, 210, 220)
MinSideBtn.TextSize = 12
MinSideBtn.Font = Enum.Font.GothamBold
MinSideBtn.Text = "Minimizar"
MinSideBtn.Parent = Sidebar
Instance.new("UICorner", MinSideBtn).CornerRadius = UDim.new(0, 6)

MinSideBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniBtn.Visible = true
end)

MiniBtn.MouseButton1Click:Connect(function()
    MiniBtn.Visible = false
    MainFrame.Visible = true
end)

SwitchTab(MainTab)

for _, tab in ipairs(tabs) do
    tab.btn.MouseButton1Click:Connect(function()
        SwitchTab(tab.content)
    end)
end

----------------------------------------------------------------
-- ABA 1: MAIN (Informações da Conta e do Jogo)
----------------------------------------------------------------
local function CreateInfoCard(titleText, valueText, posY)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -10, 0, 45)
    Card.Position = UDim2.new(0, 0, 0, posY)
    Card.BackgroundColor3 = Color3.fromRGB(22, 20, 28)
    Card.Parent = MainTab
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 6)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.4, 0, 1, 0)
    Title.Position = UDim2.new(0.05, 0, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = titleText
    Title.TextColor3 = Color3.fromRGB(150, 140, 170)
    Title.TextSize = 13
    Title.Font = Enum.Font.GothamMedium
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Card

    local Val = Instance.new("TextLabel")
    Val.Size = UDim2.new(0.5, 0, 1, 0)
    Val.Position = UDim2.new(0.45, 0, 0, 0)
    Val.BackgroundTransparency = 1
    Val.Text = valueText
    Val.TextColor3 = Color3.fromRGB(255, 255, 255)
    Val.TextSize = 13
    Val.Font = Enum.Font.GothamBold
    Val.TextXAlignment = Enum.TextXAlignment.Right
    Val.Parent = Card
end

local gameName = "Carregando..."
SafeCall(function()
    local info = MarketplaceService:GetProductInfo(game.PlaceId)
    gameName = info.Name
end)

CreateInfoCard("Nome de Usuário:", LocalPlayer.Name, 10)
CreateInfoCard("ID da Conta:", tostring(LocalPlayer.UserId), 60)
CreateInfoCard("Nome do Jogo:", gameName, 110)
CreateInfoCard("Place ID:", tostring(game.PlaceId), 160)

----------------------------------------------------------------
-- ABA 2: FUNCS (Auto Farm, Auto Parry e Espaço Futuro)
----------------------------------------------------------------
local function CreateToggle(parentTab, name, posY, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 40)
    Btn.Position = UDim2.new(0, 0, 0, posY)
    Btn.BackgroundColor3 = Color3.fromRGB(22, 20, 28)
    Btn.TextColor3 = Color3.fromRGB(200, 190, 220)
    Btn.TextSize = 13
    Btn.Font = Enum.Font.GothamMedium
    Btn.Text = name .. ": [OFF]"
    Btn.Parent = parentTab
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    local active = false
    Btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            Btn.BackgroundColor3 = Color3.fromRGB(120, 40, 200)
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Text = name .. ": [ON]"
        else
            Btn.BackgroundColor3 = Color3.fromRGB(22, 20, 28)
            Btn.TextColor3 = Color3.fromRGB(200, 190, 220)
            Btn.Text = name .. ": [OFF]"
        end
        SafeCall(function() callback(active) end)
    end)
end

-- Auto Farm
CreateToggle(FuncsTab, "Auto Farm", 10, function(state)
    Config.AutoFarm = state
    task.spawn(function()
        while Config.AutoFarm do
            SafeCall(function()
                local character = LocalPlayer.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    for _, obj in ipairs(workspace:GetChildren()) do
                        if not Config.AutoFarm then break end
                        if obj:IsA("Model") and obj ~= character then
                            local hum = obj:FindFirstChildOfClass("Humanoid")
                            local mobRoot = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                            if hum and hum.Health > 0 and mobRoot then
                                rootPart.CFrame = mobRoot.CFrame * CFrame.new(0, 0, 3)
                                task.wait(0.2)
                            end
                        end
                    end
                end
            end)
            task.wait(0.4)
        end
    end)
end)

-- Auto Parry
CreateToggle(FuncsTab, "Auto Parry", 60, function(state)
    Config.AutoParry = state
    task.spawn(function()
        while Config.AutoParry do
            SafeCall(function()
                local character = LocalPlayer.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    for _, obj in ipairs(workspace:GetChildren()) do
                        if obj:IsA("BasePart") and obj ~= rootPart then
                            if (obj.Position - rootPart.Position).Magnitude < 10 then
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                                task.wait(0.02)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end)
            RunService.RenderStepped:Wait()
        end
    end)
end)

local PlaceholderFunc = Instance.new("TextLabel")
PlaceholderFunc.Size = UDim2.new(1, -10, 0, 35)
PlaceholderFunc.Position = UDim2.new(0, 0, 0, 115)
PlaceholderFunc.BackgroundTransparency = 1
PlaceholderFunc.Text = "+ Adicione novas funções aqui..."
PlaceholderFunc.TextColor3 = Color3.fromRGB(100, 90, 120)
PlaceholderFunc.TextSize = 12
PlaceholderFunc.Font = Enum.Font.GothamItalic
PlaceholderFunc.Parent = FuncsTab

----------------------------------------------------------------
-- ABA 3: ESP (Players, NPCs, Quests e Itens)
----------------------------------------------------------------
CreateToggle(EspTab, "ESP Players", 10, function(state)
    Config.ESPPlayers = state
    local function addEsp(player)
        if player == LocalPlayer then return end
        local function apply(char)
            if not char:FindFirstChild("JhonESP_Player") then
                local hl = Instance.new("Highlight")
                hl.Name = "JhonESP_Player"
                hl.Adornee = char
                hl.FillColor = Color3.fromRGB(170, 85, 255)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.Parent = char
            end
        end
        if player.Character then apply(player.Character) end
        player.CharacterAdded:Connect(apply)
    end
    if Config.ESPPlayers then
        for _, p in ipairs(Players:GetPlayers()) do addEsp(p) end
        Players.PlayerAdded:Connect(addEsp)
    else
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("JhonESP_Player") then
                p.Character.JhonESP_Player:Destroy()
            end
        end
    end
end)

CreateToggle(EspTab, "ESP NPCs", 60, function(state)
    Config.ESPNpcs = state
    task.spawn(function()
        while Config.ESPNpcs do
            SafeCall(function()
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if not Config.ESPNpcs then break end
                    if obj:IsA("Model") and obj ~= LocalPlayer.Character then
                        if obj:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                            if not obj:FindFirstChild("JhonESP_NPC") then
                                local hl = Instance.new("Highlight")
                                hl.Name = "JhonESP_NPC"
                                hl.Adornee = obj
                                hl.FillColor = Color3.fromRGB(255, 170, 0)
                                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                                hl.Parent = obj
                            end
                        end
                    end
                end
            end)
            task.wait(2)
        end
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("JhonESP_NPC") then
                obj.JhonESP_NPC:Destroy()
            end
        end
    end)
end)

CreateToggle(EspTab, "ESP Quests", 110, function(state)
    Config.ESPQuests = state
    task.spawn(function()
        while Config.ESPQuests do
            SafeCall(function()
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if not Config.ESPQuests then break end
                    if obj:IsA("ProximityPrompt") or (obj.Name:lower():find("quest") or obj.Name:lower():find("npc")) then
                        local parentModel = obj:IsA("ProximityPrompt") and obj.Parent.Parent or obj
                        if parentModel and parentModel:IsA("Model") and not parentModel:FindFirstChild("JhonESP_Quest") then
                            local hl = Instance.new("Highlight")
                            hl.Name = "JhonESP_Quest"
                            hl.Adornee = parentModel
                            hl.FillColor = Color3.fromRGB(0, 220, 150)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.Parent = parentModel
                        end
                    end
                end
            end)
            task.wait(3)
        end
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("JhonESP_Quest") then
                obj.JhonESP_Quest:Destroy()
            end
        end
    end)
end)

CreateToggle(EspTab, "ESP Items", 160, function(state)
    Config.ESPItems = state
    task.spawn(function()
        while Config.ESPItems do
            SafeCall(function()
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if not Config.ESPItems then break end
                    if obj:IsA("Tool") or obj.Name:lower():find("item") or obj.Name:lower():find("coin") or obj.Name:lower():find("chest") then
                        local target = obj:IsA("Tool") and obj.Handle or obj
                        if target and target:IsA("BasePart") and not target:FindFirstChild("JhonESP_Item") then
                            local hl = Instance.new("Highlight")
                            hl.Name = "JhonESP_Item"
                            hl.Adornee = target.Parent
                            hl.FillColor = Color3.fromRGB(255, 255, 0)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.Parent = target.Parent
                        end
                    end
                end
            end)
            task.wait(3)
        end
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("JhonESP_Item") then
                obj.JhonESP_Item:Destroy()
            end
        end
    end)
end)

----------------------------------------------------------------
-- ABA 4: CONFIG (Opacidade e Otimização do Jogo)
----------------------------------------------------------------
local OpacityLabel = Instance.new("TextLabel")
OpacityLabel.Size = UDim2.new(1, -10, 0, 25)
OpacityLabel.Position = UDim2.new(0, 0, 0, 10)
OpacityLabel.BackgroundTransparency = 1
OpacityLabel.Text = "Opacidade do Painel:"
OpacityLabel.TextColor3 = Color3.fromRGB(180, 170, 200)
OpacityLabel.TextSize = 13
OpacityLabel.Font = Enum.Font.GothamMedium
OpacityLabel.TextXAlignment = Enum.TextXAlignment.Left
OpacityLabel.Parent = ConfigTab

local OpacityBtn1 = Instance.new("TextButton")
OpacityBtn1.Size = UDim2.new(0.48, -5, 0, 35)
OpacityBtn1.Position = UDim2.new(0, 0, 0, 40)
OpacityBtn1.BackgroundColor3 = Color3.fromRGB(120, 40, 200)
OpacityBtn1.TextColor3 = Color3.fromRGB(255, 255, 255)
OpacityBtn1.Text = "100% (Normal)"
OpacityBtn1.TextSize = 12
OpacityBtn1.Font = Enum.Font.GothamMedium
OpacityBtn1.Parent = ConfigTab
Instance.new("UICorner", OpacityBtn1).CornerRadius = UDim.new(0, 6)

local OpacityBtn2 = Instance.new("TextButton")
OpacityBtn2.Size = UDim2.new(0.48, -5, 0, 35)
OpacityBtn2.Position = UDim2.new(0.52, 0, 0, 40)
OpacityBtn2.BackgroundColor3 = Color3.fromRGB(30, 27, 38)
OpacityBtn2.TextColor3 = Color3.fromRGB(180, 180, 190)
OpacityBtn2.Text = "50% (Transparente)"
OpacityBtn2.TextSize = 12
OpacityBtn2.Font = Enum.Font.GothamMedium
OpacityBtn2.Parent = ConfigTab
Instance.new("UICorner", OpacityBtn2).CornerRadius = UDim.new(0, 6)

OpacityBtn1.MouseButton1Click:Connect(function()
    MainFrame.BackgroundTransparency = 0
    Sidebar.BackgroundTransparency = 0
    OpacityBtn1.BackgroundColor3 = Color3.fromRGB(120, 40, 200)
    OpacityBtn1.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpacityBtn2.BackgroundColor3 = Color3.fromRGB(30, 27, 38)
    OpacityBtn2.TextColor3 = Color3.fromRGB(180, 180, 190)
end)

OpacityBtn2.MouseButton1Click:Connect(function()
    MainFrame.BackgroundTransparency =.4
    Sidebar.BackgroundTransparency = 0.4
    OpacityBtn2.BackgroundColor3 = Color3.fromRGB(120, 40, 200)
    OpacityBtn2.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpacityBtn1.BackgroundColor3 = Color3.fromRGB(30, 27, 38)
    OpacityBtn1.TextColor3 = Color3.fromRGB(180, 180, 190)
end)

CreateToggle(ConfigTab, "Otimização (FPS Boost)", 90, function(state)
    Config.Optimization = state
    if Config.Optimization then
        SafeCall(function()
            Lighting.GlobalShadows = false
            Lighting.Brightness = 2
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Smoke") then
                    v.Enabled = false
                end
            end
        end)
    end
end)
