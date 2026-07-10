-- Script dịch chuyển tức thời đến Sea 2 (Vùng New World) cho Roblox Blox Fruits
-- Bỏ qua yêu cầu cấp độ. Chạy với tư cách người thực thi (Executor) cấp độ 8+.
-- Lưu ý: Script này can thiệp trực tiếp vào bộ nhớ game, có nguy cơ bị phát hiện.

local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Hằng số tọa độ Sea 2 (Cảng Thợ Săn - điểm đến an toàn)
local SEA2_COORDINATES = Vector3.new(-1190, 15, 1050)  -- X, Y, Z

-- Hàm dịch chuyển tức thời, bỏ qua kiểm tra vật lý
local function TeleportToSea2()
    if not humanoidRootPart then
        warn("Không tìm thấy HumanoidRootPart, thoát.")
        return
    end
    
    -- Tắt va chạm để tránh bị đẩy ngược hoặc kẹt
    humanoidRootPart.CanCollide = false
    
    -- Dịch chuyển trực tiếp
    humanoidRootPart.CFrame = CFrame.new(SEA2_COORDINATES)
    
    -- Đồng bộ vị trí với server bất chấp kiểm tra
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Teleport", SEA2_COORDINATES)
    
    -- Chờ load vùng mới
    task.wait(0.5)
    
    -- Bật lại va chạm để tương tác với NPC
    humanoidRootPart.CanCollide = true
    
    print("Đã dịch chuyển đến Sea 2 tại: " .. tostring(SEA2_COORDINATES))
end

-- Vòng lặp phòng vệ: Nếu server ép về Sea 1, lập tức dịch chuyển lại
local function AntiRollback()
    spawn(function()
        while true do
            task.wait(1) -- Kiểm tra mỗi giây
            local currentPos = humanoidRootPart.Position
            -- Nếu bị kéo về tọa độ Sea 1 (ví dụ: < 0 trên trục Z)
            if currentPos.Z < 0 and currentPos.X > -500 and currentPos.Y < 50 then
                TeleportToSea2()
            end
        end
    end)
end

-- Thực thi chính
local success, err = pcall(function()
    TeleportToSea2()
    AntiRollback()
end)

if not success then
    warn("Lỗi thực thi: " .. tostring(err))
    -- Phương án dự phòng: Dùng Remote lén lút (ít bị phát hiện hơn)
    local remote = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer
    remote("RequestTeleport", 2) -- Tham số 2 tương ứng với Sea 2
end
