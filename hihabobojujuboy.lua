-- 1️⃣ KHAI BÁO KEY & LINK GET KEY
local key = "getkey=50k" -- Key bạn đặt
local keyLink = "https://link4m.net/0cj5WD" -- Link khi ấn "Get Key"

-- 2️⃣ GIAO DIỆN NHẬP KEY
local CoreGui = game:GetService("CoreGui")
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextBox = Instance.new("TextBox")
local CheckButton = Instance.new("TextButton")
local GetKeyButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "KeySystem"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Frame.Size = UDim2.new(0, 300, 0, 160)
Frame.Position = UDim2.new(0.5, -150, 0.5, -80)
UICorner.Parent = Frame

-- 🔴 Nút thoát (dấu X)
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = Frame
CloseButton.Text = "X"
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 5) -- góc phải trên khung
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 18

local closeCorner = Instance.new("UICorner", CloseButton)
closeCorner.CornerRadius = UDim.new(0, 5)

CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy() -- ấn X sẽ tắt giao diện
end)
TextBox.Parent = Frame
TextBox.PlaceholderText = "Nhập key tại đây 🍎"
TextBox.Text = ""
TextBox.Size = UDim2.new(0.9, 0, 0, 35)
TextBox.Position = UDim2.new(0.05, 0, 0.25, 0)
TextBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
UICorner:Clone().Parent = TextBox

CheckButton.Parent = Frame
CheckButton.Text = "Kiểm tra key ✅"
CheckButton.Size = UDim2.new(0.4, 0, 0, 30)
CheckButton.Position = UDim2.new(0.05, 0, 0.65, 0)
CheckButton.BackgroundColor3 = Color3.fromRGB(80, 170, 80)
UICorner:Clone().Parent = CheckButton

GetKeyButton.Parent = Frame
GetKeyButton.Text = "Lấy key 🔑"
GetKeyButton.Size = UDim2.new(0.4, 0, 0, 30)
GetKeyButton.Position = UDim2.new(0.55, 0, 0.65, 0)
GetKeyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
UICorner:Clone().Parent = GetKeyButton

GetKeyButton.MouseButton1Click:Connect(function()
	setclipboard(keyLink)
	game.StarterGui:SetCore("SendNotification", {
		Title = "Đã copy link 🔗";
		Text = "Dán lên trình duyệt để lấy key nhé!";
		Duration = 4;
	})
end)

local keyOk = false
CheckButton.MouseButton1Click:Connect(function()
	if TextBox.Text == key then
		keyOk = true
		ScreenGui:Destroy()
		game.StarterGui:SetCore("SendNotification", {
			Title = "Thành công 🎉";
			Text = "Key đúng! Script sẽ khởi chạy.";
			Duration = 3;
		})
	else
		game.StarterGui:SetCore("SendNotification", {
			Title = "Sai key ❌";
			Text = "Hãy ấn nút 'Lấy key' để lấy key mới.";
			Duration = 3;
		})
	end
end)

-- 3️⃣ CHỜ NHẬP KEY ĐÚNG MỚI CHẠY SCRIPT CHÍNH
repeat task.wait() until keyOk == true

-- 👉 DÁN CODE CHÍNH CỦA BẠN NGAY DƯỚI DÒNG NÀY 👇
------------------------------------------------------
-- ↓ TOÀN BỘ CODE CỦA BẠN (bắt đầu từ dòng: local ScreenGui = Instance.new("ScreenGui"))
repeat task.wait() until game:IsLoaded() and game:GetService("Players") and game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui")

 

loadstring(game:HttpGet("https://raw.githubusercontent.com/Teddyseetink/Haidepzai/refs/heads/main/TEDDYHUB-FREEMIUM"))()
