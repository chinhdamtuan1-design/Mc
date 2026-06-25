local Players = game:GetService("Players")

local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local playerGui = player:WaitForChild("PlayerGui", 15)

if not playerGui then return end

local savedPosition = nil

local buttonPos = UDim2.new(1, -80, 1, -80)

local screenGui = Instance.new("ScreenGui")

screenGui.Name = "HackMenuCross"

screenGui.ResetOnSpawn = false

screenGui.Enabled = true

screenGui.Parent = playerGui

local openButton = Instance.new("TextButton")

openButton.Name = "OpenMenuBtn"

openButton.Size = UDim2.new(0, 70, 0, 70)

openButton.Position = buttonPos

openButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

openButton.Text = "MENU"

openButton.TextColor3 = Color3.new(1,1,1)

openButton.TextScaled = true

openButton.Font = Enum.Font.GothamBold

openButton.BorderSizePixel = 0

openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")

openCorner.CornerRadius = UDim.new(1, 0)

openCorner.Parent = openButton

local openStroke = Instance.new("UIStroke")

openStroke.Color = Color3.fromRGB(255, 255, 255)

openStroke.Thickness = 2

openStroke.Parent = openButton

local mainFrame = Instance.new("Frame")

mainFrame.Size = UDim2.new(0, 300, 0, 300)  -- tăng chiều cao để thêm nút

mainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)

mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)

mainFrame.Visible = false

mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner", mainFrame)

mainCorner.CornerRadius = UDim.new(0, 12)

local titleBar = Instance.new("Frame")

titleBar.Size = UDim2.new(1, 0, 0, 40)

titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 70)

titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")

titleLabel.Size = UDim2.new(1, -50, 1, 0)

titleLabel.BackgroundTransparency = 1

titleLabel.Text = "cay vẫn phải hub lưu điểm hồi sinh- tiktok:cayvanphaihub2025aq7"

titleLabel.TextColor3 = Color3.new(1,1,1)

titleLabel.TextScaled = true

titleLabel.Font = Enum.Font.GothamBold

titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")

closeBtn.Size = UDim2.new(0, 40, 0, 40)

closeBtn.Position = UDim2.new(1, -42, 0, 0)

closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

closeBtn.Text = "X"

closeBtn.TextColor3 = Color3.new(1,1,1)

closeBtn.TextScaled = true

closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner", closeBtn)

closeCorner.CornerRadius = UDim.new(0, 8)

local saveBtn = Instance.new("TextButton")

saveBtn.Size = UDim2.new(0.8, 0, 0, 50)

saveBtn.Position = UDim2.new(0.1, 0, 0.15, 0)

saveBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)

saveBtn.Text = "💾 Lưu điểm hồi sinh vị tại trí hiện tại"

saveBtn.TextColor3 = Color3.new(1,1,1)

saveBtn.TextScaled = true

saveBtn.Parent = mainFrame

local savedText = Instance.new("TextLabel")

savedText.Size = UDim2.new(0.8, 0, 0.3, 0)

savedText.Position = UDim2.new(0.1, 0, 0.35, 0)

savedText.BackgroundTransparency = 1

savedText.Text = "Chưa lưu vị trí nào!"

savedText.TextColor3 = Color3.fromRGB(200, 200, 200)

savedText.TextScaled = true

savedText.TextWrapped = true

savedText.Parent = mainFrame

local tpBtn = Instance.new("TextButton")

tpBtn.Size = UDim2.new(0.8, 0, 0, 50)

tpBtn.Position = UDim2.new(0.1, 0, 0.55, 0)

tpBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)

tpBtn.Text = "⚡ Dịch chuyển về chỗ đã được lưu"

tpBtn.TextColor3 = Color3.new(1,1,1)

tpBtn.TextScaled = true

tpBtn.Parent = mainFrame

local resetBtn = Instance.new("TextButton")

resetBtn.Size = UDim2.new(0.8, 0, 0, 50)

resetBtn.Position = UDim2.new(0.1, 0, 0.75, 0)

resetBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)

resetBtn.Text = "🔄 xóa vị trí lưu trước đó"

resetBtn.TextColor3 = Color3.new(1,1,1)

resetBtn.TextScaled = true

resetBtn.Parent = mainFrame

saveBtn.Activated:Connect(function()

    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then

        savedPosition = player.Character.HumanoidRootPart.CFrame

        savedText.Text = "ĐÃ LƯU: " .. tostring(savedPosition.Position)

        savedText.TextColor3 = Color3.fromRGB(0, 255, 0)

    end

end)

tpBtn.Activated:Connect(function()

    if savedPosition and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then

        player.Character.HumanoidRootPart.CFrame = savedPosition

    end

end)

resetBtn.Activated:Connect(function()

    savedPosition = nil

    savedText.Text = "Chưa lưu vị trí nào!"

    savedText.TextColor3 = Color3.fromRGB(200, 200, 200)

end)

local function onCharAdded(char)

    local hrp = char:WaitForChild("HumanoidRootPart", 5)

    if hrp and savedPosition then

        task.wait(0.3)

        hrp.CFrame = savedPosition

    end

end

player.CharacterAdded:Connect(onCharAdded)

if player.Character then onCharAdded(player.Character) end

local function toggleMenu()

    mainFrame.Visible = not mainFrame.Visible

end

openButton.Activated:Connect(toggleMenu)

closeBtn.Activated:Connect(function()

    mainFrame.Visible = false

end)

local dragging = false

local dragStart = nil

local startPos = nil

openButton.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true

        dragStart = input.Position

        startPos = openButton.Position

    end

end)

openButton.InputEnded:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then

        dragging = false

    end

end)

UserInputService.InputChanged:Connect(function(input)

    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then

        local delta = input.Position - dragStart

        openButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)

    end

end)

UserInputService.InputBegan:Connect(function(input, gpe)

    if gpe then return end

    if input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.Insert then

        toggleMenu()

    end

end)
