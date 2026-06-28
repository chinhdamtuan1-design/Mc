--[[
    Tên Script: cay vẫn phải hub
    Chức năng: Hỗ trợ quản lý di chuyển (Chạy nhanh, Nhảy cao, Bay) và Định vị người chơi khác trong game.
    Phạm vi: Đặt trong StarterPlayerScripts
--]]

local Players = game:Service("Players")
local UserInputService = game:Service("UserInputService")
local RunService = game:Service("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Trạng thái mặc định
local CONFIG = {
	NormalSpeed = 16,
	FastSpeed = 50,      -- Tốc độ khi bật chạy nhanh
	NormalJump = 50,
	HighJump = 120,      -- Lực nhảy khi bật nhảy cao
	FlySpeed = 50        -- Tốc độ bay
}

local States = {
	FastSpeedActive = false,
	HighJumpActive = false,
	FlyActive = false,
	ESPActive = false
}

local flyBodyVelocity, flyBodyGyro
local espFolder = Instance.new("Folder", workspace)
espFolder.Name = "Hub_ESP_Folder"

----------------------------------------
-- 1. CHỨC NĂNG: CHẠY NHANH & NHẢY CAO
----------------------------------------
local function updateCharacterAttributes(character)
	local humanoid = character:WaitForChild("Humanoid") :: Humanoid
	
	-- Cập nhật tốc độ
	humanoid.WalkSpeed = States.FastSpeedActive and CONFIG.FastSpeed or CONFIG.NormalSpeed
	
	-- Cập nhật lực nhảy (Hỗ trợ cả JumpPower và JumpHeight)
	if humanoid.UseJumpPower then
		humanoid.JumpPower = States.HighJumpActive and CONFIG.HighJump or CONFIG.NormalJump
	else
		humanoid.JumpHeight = States.HighJumpActive and 15 or 7.2 -- Quy đổi tương đương
	end
end

-- Lắng nghe khi nhân vật hồi sinh
LocalPlayer.CharacterAdded:Connect(function(character)
	updateCharacterAttributes(character)
end)

local function toggleSpeed()
	States.FastSpeedActive = not States.FastSpeedActive
	if LocalPlayer.Character then updateCharacterAttributes(LocalPlayer.Character) end
	print("Chạy nhanh: " .. (States.FastSpeedActive and "BẬT" or "TẮT"))
end

local function toggleJump()
	States.HighJumpActive = not States.HighJumpActive
	if LocalPlayer.Character then updateCharacterAttributes(LocalPlayer.Character) end
	print("Nhảy cao: " .. (States.HighJumpActive and "BẬT" or "TẮT"))
end

----------------------------------------
-- 2. CHỨC NĂNG: BAY (FLY)
----------------------------------------
local function toggleFly()
	local character = LocalPlayer.Character
	if not character then return end
	local rootPart = character:FindFirstChild("HumanoidRootPart") :: BasePart
	local humanoid = character:FindFirstChild("Humanoid") :: Humanoid
	if not rootPart or not humanoid then return end

	States.FlyActive = not States.FlyActive

	if States.FlyActive then
		-- Khởi tạo lực bay
		flyBodyVelocity = Instance.new("BodyVelocity")
		flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
		flyBodyVelocity.Parent = rootPart

		flyBodyGyro = Instance.new("BodyGyro")
		flyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
		flyBodyGyro.CFrame = rootPart.CFrame
		flyBodyGyro.Parent = rootPart

		humanoid.PlatformStand = true -- Tắt trạng thái vật lý thông thường của nhân vật

		-- Vòng lặp điều khiển bay dựa theo hướng Camera
		task.spawn(function()
			while States.FlyActive and character.Parent do
				RunService.RenderStepped:Wait()
				local moveDirection = humanoid.MoveDirection
				local camCFrame = Camera.CFrame
				
				local velocity = Vector3.new(0,0,0)
				if moveDirection.Magnitude > 0 then
					velocity = camCFrame:VectorToWorldSpace(Vector3.new(moveDirection.X, 0, moveDirection.Z).Unit * CONFIG.FlySpeed)
					-- Thêm điều hướng bay lên/xuống nếu cần nhấn phím đặc biệt (Space/Shift)
				end
				
				flyBodyVelocity.Velocity = velocity
				flyBodyGyro.CFrame = camCFrame
			end
		end)
	else
		-- Xóa bỏ lực bay khi tắt
		if flyBodyVelocity then flyBodyVelocity:Destroy() end
		if flyBodyGyro then flyBodyGyro:Destroy() end
		humanoid.PlatformStand = false
	end
	print("Chế độ bay: " .. (States.FlyActive and "BẬT" or "TẮT"))
end

----------------------------------------
-- 3. CHỨC NĂNG: ĐỊNH VỊ NGƯỜI CHƠI (ESP/Highlight)
----------------------------------------
local function clearESP()
	espFolder:ClearAllChildren()
end

local function applyESP(player)
	if player == LocalPlayer then return end
	
	local function createHighlight(character)
		if not States.ESPActive then return end
		-- Sử dụng Highlight của Roblox để tạo viền sáng xuyên tường
		local highlight = Instance.new("Highlight")
		highlight.Name = player.Name .. "_ESP"
		highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Màu đỏ trong suốt
		highlight.FillTransparency = 0.5
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Viền trắng
		highlight.OutlineTransparency = 0
		highlight.Adornee = character
		highlight.Parent = espFolder
	end

	if player.Character then createHighlight(player.Character) end
	player.CharacterAdded:Connect(createHighlight)
end

local function toggleESP()
	States.ESPActive = not States.ESPActive
	clearESP()

	if States.ESPActive then
		for _, player in ipairs(Players:GetPlayers()) do
			applyESP(player)
		end
		-- Lắng nghe người chơi mới vào phòng
		Players.PlayerAdded:Connect(applyESP)
	end
	print("Định vị người chơi: " .. (States.ESPActive and "BẬT" or "TẮT"))
end

----------------------------------------
-- 4. HỆ THỐNG PHÍM TẮT ĐIỀU KHIỂN (KEYBINDS)
----------------------------------------
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then return end -- Bỏ qua nếu người chơi đang gõ chat

	-- Bạn có thể thay đổi các phím (KeyCode) tùy ý ở đây
	if input.KeyCode == Enum.KeyCode.F2 then
		toggleSpeed()
	elseif input.KeyCode == Enum.KeyCode.F3 then
		toggleJump()
	elseif input.KeyCode == Enum.KeyCode.F4 then
		toggleFly()
	elseif input.KeyCode == Enum.KeyCode.F5 then
		toggleESP()
	end
end)

print("=== [cay vẫn phải hub] đã tải thành công! ===")
print("Phím tắt: F2-Tốc độ | F3-Nhảy cao | F4-Bay | F5-Định vị")

