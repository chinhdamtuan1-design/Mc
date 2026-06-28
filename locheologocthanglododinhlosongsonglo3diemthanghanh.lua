--// Cay vẫn phải hub blox fruit 
--// Tự động nhặt rương + Đặt lại + Chuyển đổi máy chủ 

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

---------------------------------------------------
-- Cài đặt 
---------------------------------------------------

getgenv().AutoChest = true

local SpecialItems = {
    "God's Chalice",
    "Fist of Darkness",
    "Chén Thánh",
    "Chìa Khóa Râu Đen"
}

local JoinedServers = {}

---------------------------------------------------
-- giao diện người dùng
---------------------------------------------------

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HIRUZ_HUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,370,0,240)
Main.Position = UDim2.new(0.5,-185,0.4,-120)
Main.BackgroundColor3 = Color3.fromRGB(15,15,15)
Main.BackgroundTransparency = 0.1
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

Instance.new("UICorner",Main).CornerRadius = UDim.new(0,14)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0,170,255)
Stroke.Thickness = 2
Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "HIRUZ HUB V3 FIXED"
Title.Font = Enum.Font.Code
Title.TextSize = 18
Title.TextColor3 = Color3.new(1,1,1)
Title.Parent = Main

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1,-20,0,120)
Status.Position = UDim2.new(0,10,0,50)
Status.BackgroundTransparency = 1
Status.TextWrapped = true
Status.Font = Enum.Font.Code
Status.TextColor3 = Color3.fromRGB(0,255,150)
Status.TextSize = 15
Status.Text = "Loading..."
Status.Parent = Main

local CountLabel = Instance.new("TextLabel")
CountLabel.Size = UDim2.new(1,-20,0,30)
CountLabel.Position = UDim2.new(0,10,1,-40)
CountLabel.BackgroundTransparency = 1
CountLabel.Font = Enum.Font.Code
CountLabel.TextColor3 = Color3.fromRGB(0,170,255)
CountLabel.TextSize = 15
CountLabel.Text = "Chest Count: 0"
CountLabel.Parent = Main

---------------------------------------------------
-- TRẠNG THÁI
---------------------------------------------------

local function UpdateStatus(txt)
    Status.Text = "[STATUS]: "..txt
    print("[HIRUZ]:",txt)
end

---------------------------------------------------
-- TÍNH CÁCH
---------------------------------------------------

local function GetCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function GetRoot()
    local Char = GetCharacter()
    return Char:WaitForChild("HumanoidRootPart")
end

---------------------------------------------------
-- Kiểm tra vật phẩm 
---------------------------------------------------

local function CheckSpecialItems()

    local Backpack = LocalPlayer:FindFirstChild("Backpack")
    local Character = GetCharacter()

    for _,item in ipairs(SpecialItems) do

        if Backpack and Backpack:FindFirstChild(item) then
            return true,item
        end

        if Character and Character:FindFirstChild(item) then
            return true,item
        end
    end

    return false,nil
end

---------------------------------------------------
-- LẤY Rương 
---------------------------------------------------

local function GetAllChests()

    local Chests = {}

    for _,obj in ipairs(workspace:GetDescendants()) do

        if obj:IsA("BasePart") then

            local Name = string.lower(obj.Name)

            if string.find(Name,"chest") then

                if obj.Parent then
                    table.insert(Chests,obj)
                end
            end
        end
    end

    table.sort(Chests,function(a,b)

        local Root = GetRoot()

        return (Root.Position - a.Position).Magnitude <
               (Root.Position - b.Position).Magnitude
    end)

    CountLabel.Text = "Chest Count: "..#Chests

    return Chests
end

---------------------------------------------------
-- TP Rương 
---------------------------------------------------

local function TPChest(chest)

    pcall(function()

        local Char = GetCharacter()
        local Root = GetRoot()

        for _,v in ipairs(Char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end

        Root.CFrame = chest.CFrame + Vector3.new(0,3,0)

        task.wait(0.15)

        if firetouchinterest then
            firetouchinterest(Root,chest,0)
            firetouchinterest(Root,chest,1)
        end
    end)
end

---------------------------------------------------
-- Đặt lại 
---------------------------------------------------

local function ResetCharacter()

    local Char = GetCharacter()
    local Humanoid = Char:FindFirstChildOfClass("Humanoid")

    if Humanoid then

        UpdateStatus("Reset character...")

        Humanoid.Health = 0

        LocalPlayer.CharacterAdded:Wait()

        task.wait(3)
    end
end

---------------------------------------------------
-- Chuyển đổi máy chủ 
---------------------------------------------------

local function HopServer()

    UpdateStatus("Searching new server...")

    local URL =
        "https://games.roblox.com/v1/games/"..
        game.PlaceId..
        "/servers/Public?sortOrder=Asc&limit=100"

    local success,response = pcall(function()
        return game:HttpGet(URL)
    end)

    if not success then
        UpdateStatus("HTTP ERROR")
        return
    end

    local data = HttpService:JSONDecode(response)

    for _,server in ipairs(data.data) do

        if server.playing < server.maxPlayers
        and server.playing <= 7
        and server.id ~= game.JobId
        and not JoinedServers[server.id] then

            JoinedServers[server.id] = true

            UpdateStatus("Teleporting...")

            TeleportService:TeleportToPlaceInstance(
                game.PlaceId,
                server.id,
                LocalPlayer
            )

            task.wait(5)
        end
    end
end

---------------------------------------------------
-- Man
---------------------------------------------------

UpdateStatus("Cay")

task.spawn(function()

    while getgenv().AutoChest do

        task.wait(0.2)

        ------------------------------------------------
        -- kiểm tra vật phẩm 
        ------------------------------------------------

        local HasItem,ItemName = CheckSpecialItems()

        if HasItem then

            UpdateStatus("Found "..ItemName)

            getgenv().AutoChest = false

            break
        end

        ------------------------------------------------
        -- Nhặt rương 
        ------------------------------------------------

        local Chests = GetAllChests()

        if #Chests > 0 then

            for _,Chest in ipairs(Chests) do

                if not getgenv().AutoChest then
                    break
                end

                if Chest and Chest.Parent then

                    UpdateStatus("Collecting "..Chest.Name)

                    TPChest(Chest)

                    task.wait(0.25)
                end
            end

        else

            ------------------------------------------------
            -- Đặt lại 
            ------------------------------------------------

            UpdateStatus("Không có rương")

            ResetCharacter()

            task.wait(3)

            ------------------------------------------------
            -- Lỗi
            ------------------------------------------------

            if #GetAllChests() <= 0 then

                UpdateStatus("Server hopping...")

                HopServer()
            end
        end
    end
end)
