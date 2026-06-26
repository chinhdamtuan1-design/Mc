-- Cay vẫn phải hub Delta 2.0 | Modified with Shadow Mode V99
-- Features: Integrated FlyGuiV3, Dual Freecam Tabs, No Speed Slider, Preserved Original Functions

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local Character, Humanoid, HRP

-- State Variables (PRESERVED FROM ORIGINAL)
Invisible = false
InfiniteJump = false
Flying = false
FlySpeed = 50
NoClip = false
BodyVelocity = nil
BodyGyro = nil
Spectating = false
CurrentSpectate = nil
Aimbot = false
ESP = false

_G.WalkSpeed = 16
_G.JumpPower = 50
_G.ForceJump = true

local originalTransparency = {}
local FlyKeys = {
    W = false,
    A = false,
    S = false,
    D = false,
    Space = false,
    Shift = false
}

local ESPBoxes = {}
local ESPConnections = {}
local CorrectKey = "cayvanphaihub"
local KeyEntered = false

-- ================ UI SYSTEM (ORIGINAL STRUCTURE) ================
local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "Cay_2.0"
ScreenGui.ResetOnSpawn = false

-- Main Menu
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 450)
Main.Position = UDim2.new(0.05, 0, 0.15, 0)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Main.Visible = false
Main.BorderSizePixel = 0

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 6)

local UIStroke = Instance.new("UIStroke", Main)
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Thickness = 2

-- Drag System
local MainDrag = false
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        MainDrag = true
        local startPos = input.Position
        local frameStartPos = Main.Position
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not MainDrag then connection:Disconnect() return end
            local delta = UIS:GetMouseLocation() - startPos
            Main.Position = UDim2.new(
                frameStartStartPos.X.Scale, 
                frameStartPos.X.Offset + delta.X,
                frameStartPos.Y.Scale, 
                frameStartPos.Y.Offset + delta.Y
            )
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                MainDrag = false
            end
        end)
    end
end)

-- Logo Button
local LogoBtn = Instance.new("ImageButton", ScreenGui)
LogoBtn.Size = UDim2.new(0, 50, 0, 50)
LogoBtn.Position = UDim2.new(0.02, 0, 0.02, 0)
LogoBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
LogoBtn.Active = true
LogoBtn.Draggable = true
LogoBtn.Visible = false
LogoBtn.BorderSizePixel = 0

local LogoCorner = Instance.new("UICorner", LogoBtn)
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoBtn.Image = "https://tr.rbxcdn.com/fb2b6c36ab576e78ab0ca753a4036fca/150/150/Image/Png"

-- Logo Drag
local LogoDrag = false
LogoBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        LogoDrag = true
        local startPos = input.Position
        local frameStartPos = LogoBtn.Position
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not LogoDrag then connection:Disconnect() return end
            local delta = UIS:GetMouseLocation() - startPos
            LogoBtn.Position = UDim2.new(
                frameStartPos.X.Scale, 
                frameStartPos.X.Offset + delta.X,
                frameStartPos.Y.Scale, 
                frameStartPos.Y.Offset + delta.Y
            )
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                LogoDrag = false
            end
        end)
    end
end)

local LastMenuPosition = UDim2.new(0.05, 0, 0.15, 0)
LogoBtn.MouseButton1Click:Connect(function()
    if Main.Visible then
        LastMenuPosition = Main.Position
        Main.Visible = false
    else
        Main.Position = LastMenuPosition
        Main.Visible = true
    end
end)

-- ================ KEY SYSTEM ================
local KeyScreen = Instance.new("Frame", ScreenGui)
KeyScreen.Size = UDim2.new(0, 300, 0, 200)
KeyScreen.Position = UDim2.new(0.5, -150, 0.5, -100)
KeyScreen.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyScreen.Visible = true
KeyScreen.BorderSizePixel = 0

local KeyCorner = Instance.new("UICorner", KeyScreen)
KeyCorner.CornerRadius = UDim.new(0, 6)

local KeyUIStroke = Instance.new("UIStroke", KeyScreen)
KeyUIStroke.Color = Color3.fromRGB(0, 170, 255)
KeyUIStroke.Thickness = 2

local KeyTitle = Instance.new("TextLabel", KeyScreen)
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "🌶️ vẫn phải hub 2.0"
KeyTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextScaled = true

local KeyCredit = Instance.new("TextLabel", KeyScreen)
KeyCredit.Position = UDim2.new(0, 0, 0, 40)
KeyCredit.Size = UDim2.new(1, 0, 0, 20)
KeyCredit.BackgroundTransparency = 1
KeyCredit.Text = "@phuoc.thanh1409"
KeyCredit.TextColor3 = Color3.fromRGB(200, 200, 200)
KeyCredit.TextScaled = true

local KeyInput = Instance.new("TextBox", KeyScreen)
KeyInput.Size = UDim2.new(0.8, 0, 0, 40)
KeyInput.Position = UDim2.new(0.1, 0, 0.3, 0)
KeyInput.PlaceholderText = "Nhập key..."
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
KeyInput.TextColor3 = Color3.new(1, 1, 1)
KeyInput.Font = Enum.Font.GothamBold
KeyInput.TextScaled = true
KeyInput.BorderSizePixel = 0

local KeyInputCorner = Instance.new("UICorner", KeyInput)
KeyInputCorner.CornerRadius = UDim.new(0, 6)

local SubmitBtn = Instance.new("TextButton", KeyScreen)
SubmitBtn.Size = UDim2.new(0.8, 0, 0, 40)
SubmitBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
SubmitBtn.Text = "Xác nhận"
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
SubmitBtn.TextColor3 = Color3.new(1, 1, 1)
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextScaled = true
SubmitBtn.BorderSizePixel = 0

local SubmitCorner = Instance.new("UICorner", SubmitBtn)
SubmitCorner.CornerRadius = UDim.new(0, 6)

local ErrorLabel = Instance.new("TextLabel", KeyScreen)
ErrorLabel.Size = UDim2.new(0.8, 0, 0, 20)
ErrorLabel.Position = UDim2.new(0.1, 0, 0.85, 0)
ErrorLabel.BackgroundTransparency = 1
ErrorLabel.Text = ""
ErrorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
ErrorLabel.Font = Enum.Font.Gotham
ErrorLabel.TextSize = 14
ErrorLabel.Visible = false

local function CheckKey()
    local inputKey = KeyInput.Text
    if inputKey == CorrectKey then
        KeyEntered = true
        KeyScreen.Visible = false
        Main.Visible = true
        LogoBtn.Visible = true
    else
        ErrorLabel.Text = "Sai key! Vui lòng thử lại."
        ErrorLabel.Visible = true
        KeyInput.Text = ""
    end
end

SubmitBtn.MouseButton1Click:Connect(CheckKey)
KeyInput.Focused:Connect(function() ErrorLabel.Visible = false end)
KeyInput.FocusLost:Connect(function(enterPressed) if enterPressed then CheckKey() end end)

-- ================ MAIN CONTENT ================
local ScrollFrame = Instance.new("ScrollingFrame", Main)
ScrollFrame.Size = UDim2.new(1, -10, 1, -80)
ScrollFrame.Position = UDim2.new(0, 5, 0, 70)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "🌶️ vẫn phải hub 2.0"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextScaled = false

local Credit = Instance.new("TextLabel", Main)
Credit.Position = UDim2.new(0, 0, 0, 40)
Credit.Size = UDim2.new(1, 0, 0, 30)
Credit.BackgroundTransparency = 1
Credit.Text = "@cayvanphaihub2026"
Credit.TextColor3 = Color3.fromRGB(200, 200, 200)
Credit.Font = Enum.Font.Gotham
Credit.TextSize = 14

local Content = Instance.new("Frame", ScrollFrame)
Content.Size = UDim2.new(1, 0, 0, 0)
Content.BackgroundTransparency = 1
Content.Name = "Content"

local UIListLayout = Instance.new("UIListLayout", Content)
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Content.Size = UDim2.new(1, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end)

-- ================ UTILITY FUNCTIONS ================
local function CreateButton(text)
    local b = Instance.new("TextButton", Content)
    b.Size = UDim2.new(0.95, 0, 0, 32)
    b.Position = UDim2.new(0.025, 0, 0, 0)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.TextScaled = false
    b.LayoutOrder = #Content:GetChildren()
    b.AutoButtonColor = true
    b.BorderSizePixel = 0
    
    local btnCorner = Instance.new("UICorner", b)
    btnCorner.CornerRadius = UDim.new(0, 4)
    
    return b
end

-- ================ SLIDER SYSTEM ================
local function CreateSlider(titleText, min, max, default, callback)
    local container = Instance.new("Frame", Content)
    container.Size = UDim2.new(0.95, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.LayoutOrder = #Content:GetChildren()
    container.Name = "Slider_" .. titleText
    
    local T = Instance.new("TextLabel", container)
    T.Position = UDim2.new(0, 0, 0, 0)
    T.Size = UDim2.new(1, 0, 0, 18)
    T.BackgroundTransparency = 1
    T.Text = titleText .. ": " .. default
    T.TextColor3 = Color3.new(1, 1, 1)
    T.Font = Enum.Font.GothamBold
    T.TextSize = 13
    T.TextXAlignment = Enum.TextXAlignment.Left

    local Bar = Instance.new("Frame", container)
    Bar.Position = UDim2.new(0, 0, 0, 25)
    Bar.Size = UDim2.new(1, 0, 0, 8)
    Bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Bar.BorderSizePixel = 0
    
    local barCorner = Instance.new("UICorner", Bar)
    barCorner.CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    Fill.BorderSizePixel = 0
    Fill.ZIndex = 2
    
    local fillCorner = Instance.new("UICorner", Fill)
    fillCorner.CornerRadius = UDim.new(1, 0)

    local dragging = false
    local isMobile = UIS.TouchEnabled and not UIS.MouseEnabled
    
    local function updateSlider(input)
        local mousePos
        if input then
            mousePos = input.Position
        else
            mousePos = UIS:GetMouseLocation()
        end
        
        local barAbsPos = Bar.AbsolutePosition
        local barAbsSize = Bar.AbsoluteSize
        
        local relativeX = (mousePos.X - barAbsPos.X) / barAbsSize.X
        relativeX = math.clamp(relativeX, 0, 1)
        
        Fill.Size = UDim2.new(relativeX, 0, 1, 0)
        local value = math.floor(min + (max - min) * relativeX)
        T.Text = titleText .. ": " .. value
        callback(value)
    end

    local function startDragging(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end

    Bar.InputBegan:Connect(startDragging)
    
    if isMobile then
        container.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                startDragging(input)
            end
        end)
    end

    local function endDragging(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end

    UIS.InputEnded:Connect(endDragging)

    local connection
    connection = UIS.InputChanged:Connect(function(input)
        if dragging then
            if input.UserInputType == Enum.UserInputType.MouseMovement or 
               input.UserInputType == Enum.UserInputType.Touch then
                updateSlider(input)
            end
        end
    end)

    container.Destroying:Connect(function()
        if connection then
            connection:Disconnect()
        end
    end)
    
    return container
end

-- ================ SLIDERS (WALKSPEED & JUMPPOWER ONLY) ================
local walkSpeedSlider = CreateSlider("🏃 Tốc độ chạy", 10, 150, 16, function(v)
    _G.WalkSpeed = v
    if Humanoid then 
        Humanoid.WalkSpeed = v 
    end
end)

local jumpPowerSlider = CreateSlider("🦘 Sức nhảy", 20, 300, 50, function(v)
    _G.JumpPower = v
    if Humanoid then
        Humanoid.UseJumpPower = true
        Humanoid.JumpPower = v
    end
end)

-- ================ BUTTONS ================
local FlyBtn = CreateButton("🕊️ Bay: Tắt")
local InfJumpBtn = CreateButton("🦘 Nhảy vô hạn: Tắt")
local InvisBtn = CreateButton("👻 Tàng hình: Tắt")
local NoclipBtn = CreateButton("🚪 Xuyên tường: Tắt")
local TpPlayerBtn = CreateButton("🧍 TP đến người chơi")
local AimbotBtn = CreateButton("🎯 Aimbot: Tắt")
local ESPBtn = CreateButton("👁️ ESP: Tắt")
local FreeCamIPhoneBtn = CreateButton("📱 Free Cam (iPhone)")
local FreeCamPCBtn = CreateButton("💻 Free Cam (PC)")
local HelpBtn = CreateButton("❓ Hướng Dẫn")
local ResetBtn = CreateButton("🔄 Xóa tính năng")

-- ================ MODIFIED FLY SYSTEM (FlyGuiV3 INTEGRATION) ================
local FlyGuiV3Loaded = false
local FlyGuiV3Script

FlyBtn.MouseButton1Click:Connect(function()
    if not FlyGuiV3Loaded then
        FlyGuiV3Script = loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
        FlyGuiV3Loaded = true
        Flying = true
        FlyBtn.Text = "🕊️ Bay: Bật"
        
        -- Hide FlyGuiV3's GUI elements
        task.spawn(function()
            wait(0.5)
            for _, obj in pairs(Player.PlayerGui:GetChildren()) do
                if obj:IsA("ScreenGui") and (obj.Name:find("Fly") or obj.Name:find("Gui")) then
                    obj.Enabled = false
                end
            end
        end)
    else
        -- Toggle fly off by re-executing script (FlyGuiV3 toggles on/off with same execution)
        if FlyGuiV3Script then
            pcall(FlyGuiV3Script)
        end
        Flying = false
        FlyGuiV3Loaded = false
        FlyBtn.Text = "🕊️ Bay: Tắt"
    end
end)

-- ================ FREE CAM SYSTEMS ================
FreeCamIPhoneBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FREECAM-script-80365"))()
end)

FreeCamPCBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://pastefy.app/QgYLl0sS/raw"))()
end)

-- ================ CHARACTER LOADING ================
local function LoadCharacter(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HRP = char:WaitForChild("HumanoidRootPart")
    
    Humanoid.UseJumpPower = true
    Humanoid.WalkSpeed = _G.WalkSpeed
    Humanoid.JumpPower = _G.JumpPower
    
    originalTransparency = {}
    for _, v in pairs(Character:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Decal") then
            originalTransparency[v] = v.Transparency
        end
    end
    
    Humanoid.Died:Connect(function()
        Flying = false
        Spectating = false
        FlyGuiV3Loaded = false
        FlyBtn.Text = "🕊️ Bay: Tắt"
        if workspace.CurrentCamera.CameraSubject ~= Humanoid then
            workspace.CurrentCamera.CameraSubject = Humanoid
        end
    end)
end

LoadCharacter(Player.Character or Player.CharacterAdded:Wait())
Player.CharacterAdded:Connect(LoadCharacter)

-- ================ BUTTON FUNCTIONS ================
InfJumpBtn.MouseButton1Click:Connect(function()
    InfiniteJump = not InfiniteJump
    InfJumpBtn.Text = "🦘 Nhảy vô hạn: " .. (InfiniteJump and "Bật" or "Tắt")
end)

UIS.JumpRequest:Connect(function()
    if InfiniteJump and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

InvisBtn.MouseButton1Click:Connect(function()
    Invisible = not Invisible
    for v, t in pairs(originalTransparency) do
        if v and v.Parent then v.Transparency = Invisible and 1 or t end
    end
    InvisBtn.Text = "👻 Tàng hình: " .. (Invisible and "Bật" or "Tắt")
end)

NoclipBtn.MouseButton1Click:Connect(function()
    NoClip = not NoClip
    NoclipBtn.Text = "🚪 Xuyên tường: " .. (NoClip and "Bật" or "Tắt")
end)

-- ================ TP PLAYER MENU ================
local TpPlayerMenu = Instance.new("Frame", ScreenGui)
TpPlayerMenu.Size = UDim2.new(0, 280, 0, 350)
TpPlayerMenu.Position = UDim2.new(0.5, -140, 0.5, -175)
TpPlayerMenu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TpPlayerMenu.Visible = false
TpPlayerMenu.ZIndex = 50
TpPlayerMenu.BorderSizePixel = 0

local TpPlayerCorner = Instance.new("UICorner", TpPlayerMenu)
TpPlayerCorner.CornerRadius = UDim.new(0, 6)

local TpPlayerTitle = Instance.new("TextLabel", TpPlayerMenu)
TpPlayerTitle.Size = UDim2.new(1, 0, 0, 40)
TpPlayerTitle.BackgroundTransparency = 1
TpPlayerTitle.Text = "Chọn người chơi để TP"
TpPlayerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
TpPlayerTitle.Font = Enum.Font.GothamBold
TpPlayerTitle.TextSize = 16

local CloseTpPlayerBtn = Instance.new("TextButton", TpPlayerMenu)
CloseTpPlayerBtn.Size = UDim2.new(0, 30, 0, 30)
CloseTpPlayerBtn.Position = UDim2.new(1, -35, 0, 5)
CloseTpPlayerBtn.Text = "X"
CloseTpPlayerBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseTpPlayerBtn.TextColor3 = Color3.new(1, 1, 1)
CloseTpPlayerBtn.Font = Enum.Font.GothamBold
CloseTpPlayerBtn.TextSize = 14
CloseTpPlayerBtn.AutoButtonColor = true
CloseTpPlayerBtn.BorderSizePixel = 0

local CloseTpCorner = Instance.new("UICorner", CloseTpPlayerBtn)
CloseTpCorner.CornerRadius = UDim.new(1, 0)

local TpPlayerScroll = Instance.new("ScrollingFrame", TpPlayerMenu)
TpPlayerScroll.Size = UDim2.new(1, -10, 1, -50)
TpPlayerScroll.Position = UDim2.new(0, 5, 0, 45)
TpPlayerScroll.BackgroundTransparency = 1
TpPlayerScroll.ScrollBarThickness = 4
TpPlayerScroll.ZIndex = 51

local TpPlayerLayout = Instance.new("UIListLayout", TpPlayerScroll)
TpPlayerLayout.Padding = UDim.new(0, 5)
TpPlayerLayout.SortOrder = Enum.SortOrder.LayoutOrder

TpPlayerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TpPlayerScroll.CanvasSize = UDim2.new(0, 0, 0, TpPlayerLayout.AbsoluteContentSize.Y)
end)

CloseTpPlayerBtn.MouseButton1Click:Connect(function()
    TpPlayerMenu.Visible = false
end)

local function UpdateTpPlayerList()
    for _, child in pairs(TpPlayerScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local playerBtn = Instance.new("TextButton", TpPlayerScroll)
            playerBtn.Size = UDim2.new(1, 0, 0, 30)
            playerBtn.Text = player.Name
            playerBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            playerBtn.TextColor3 = Color3.new(1, 1, 1)
            playerBtn.Font = Enum.Font.Gotham
            playerBtn.TextSize = 14
            playerBtn.AutoButtonColor = true
            playerBtn.ZIndex = 52
            playerBtn.BorderSizePixel = 0
            
            local btnCorner = Instance.new("UICorner", playerBtn)
            btnCorner.CornerRadius = UDim.new(0, 4)
            
