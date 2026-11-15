-- =================================================================
-- JHONSCRIPT - VV: ULTIMATUM (Versão Segura & Completa)
-- =================================================================

-- 1. Isolamento de Ambiente e Segurança Básica
local getgenv = getgenv or function() return _G end
local protectgui = protectgui or function(gui) gui.Parent = game:GetService("CoreGui") end

-- Garante que o jogo foi totalmente carregado
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- Função segura para chamadas (Evita logs de erro no console do jogo)
local function SafeCall(func, ...)
    local success, err = pcall(func, ...)
    if not success then
        return nil
    end
    return err
end

-- Estado das Funções (Toggles)
local Config = {
    AutoFarm = false,
    AutoParry = false,
    ESPEnabled = false
}

-- 2. Criando a Interface Gráfica protegida contra varreduras do jogo
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JhonScript_UI_" .. math.random(10000, 99999)
ScreenGui.ResetOnSpawn = false

SafeCall(function()
    protectgui(ScreenGui)
end)

if not ScreenGui.Parent then
    ScreenGui.Parent = game:GetService("CoreGui")
end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 380)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "JhonScript | VV: Ultimatum"
Title.TextColor3 = Color3.fromRGB(0, 220, 150)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Função auxiliar para criar botões estilizados
local function CreateButton(name, posY, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.9, 0, 0, 40)
    Btn.Position = UDim2.new(0.05, 0, 0, posY)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.TextSize = 14
    Btn.Font = Enum.Font.GothamMedium
    Btn.Text = name .. ": [OFF]"
    Btn.Parent = MainFrame

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Btn

    local active = false
    Btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            Btn.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Text = name .. ": [ON]"
        else
            Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            Btn.Text = name .. ": [OFF]"
        end
        SafeCall(function()
            callback(active)
        end)
    end)
end

----------------------------------------------------------------
-- IMPLEMENTAÇÃO DAS FUNCIONALIDADES DO JOGO
----------------------------------------------------------------

-- 1. Auto Farm
CreateButton("Auto Farm", 55, function(state)
    Config.AutoFarm = state
    task.spawn(function()
        while Config.AutoFarm do
            SafeCall(function()
                local character = LocalPlayer.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                
                local mobs = workspace:FindFirstChild("Mobs") or workspace:FindFirstChild("Enemies")
                if mobs and rootPart then
                    for _, mob in ipairs(mobs:GetChildren()) do
                        if not Config.AutoFarm then break end
                        local mobRoot = mob:FindFirstChild("HumanoidRootPart")
                        if mobRoot then
                            rootPart.CFrame = mobRoot.CFrame * CFrame.new(0, 0, 3)
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end)

-- 2. Auto Parry (Detecção de proximidade com simulação de tecla)
CreateButton("Auto Parry", 105, function(state)
    Config.AutoParry = state
    task.spawn(function()
        while Config.AutoParry do
            SafeCall(function()
                local character = LocalPlayer.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                
                if rootPart then
                    for _, obj in ipairs(workspace:GetChildren()) do
                        if obj:IsA("BasePart") and obj ~= rootPart then
                            local distance = (obj.Position - rootPart.Position).Magnitude
                            if distance < 15 then
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                                task.wait(0.05)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                                task.wait(0.4)
                            end
                        end
                    end
                end
            end)
            RunService.RenderStepped:Wait()
        end
    end)
end)

-- 3. ESP Players (Destaque visual em outros jogadores)
CreateButton("ESP Players", 155, function(state)
    Config.ESPEnabled = state
    
    local function addEsp(player)
        if player == LocalPlayer then return end
        
        local function apply(char)
            if not char:FindFirstChild("JhonESP") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "JhonESP"
                highlight.Adornee = char
                highlight.FillColor = Color3.fromRGB(0, 150, 255)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = char
            end
        end
        
        if player.Character then apply(player.Character) end
        player.CharacterAdded:Connect(apply)
    end

    if Config.ESPEnabled then
        for _, p in ipairs(Players:GetPlayers()) do addEsp(p) end
        Players.PlayerAdded:Connect(addEsp)
    else
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("JhonESP") then
                p.Character.JhonESP:Destroy()
            end
        end
    end
end)

-- 4. Teleporte Frontal Rápido
CreateButton("Teleport Forward", 205, function(state)
    SafeCall(function()
        local character = LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            rootPart.CFrame = rootPart.CFrame + (rootPart.CFrame.LookVector * 25)
        end
    end)
end)

-- Botão de Fechar Interface / Descarregar Script
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0.9, 0, 0, 35)
CloseBtn.Position = UDim2.new(0.05, 0, 0, 320)
CloseBtn.BackgroundColor3 = Color3.fromRGB(160, 35, 35)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "Fechar JhonScript"
CloseBtn.Parent = MainFrame

local CornerClose = Instance.new("UICorner")
CornerClose.CornerRadius = UDim.new(0, 6)
CornerClose.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
