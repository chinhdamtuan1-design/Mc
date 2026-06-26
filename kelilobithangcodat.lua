local plrs=game.Players local lp=plrs.LocalPlayer local rs=game:GetService("RunService") local uis=game:GetService("UserInputService") local follow=false local target=nil local offset=Vector3.new(0,0,0) local lerpSpeed=0.07 local flying=false local noclipping=false local bv,bav local flySpeed=50 local keys={W=false,S=false,A=false,D=false,Moving=false}

local sg=Instance.new("ScreenGui") sg.Name="VIPFollowX" sg.ResetOnSpawn=false sg.Parent=(gethui and gethui())or game.CoreGui

local main=Instance.new("Frame",sg) main.Size=UDim2.new(0,220,0,290) main.Position=UDim2.new(0.5,-110,0.12,0) main.BackgroundColor3=Color3.fromRGB(15,15,25) main.BorderSizePixel=0 main.ClipsDescendants=true Instance.new("UICorner",main).CornerRadius=UDim.new(0,14) local stroke=Instance.new("UIStroke",main) stroke.Color=Color3.fromRGB(90,190,255) stroke.Thickness=2.2 stroke.Transparency=0.25

local title=Instance.new("TextLabel",main) title.Size=UDim2.new(1,0,0,50) title.BackgroundTransparency=1 title.Text="VIP Follow Menu - Luân\n@chuatethanthien | TikTok: con.chim.biet.bay0" title.TextColor3=Color3.new(1,1,1) title.TextSize=14 title.Font=Enum.Font.GothamBlack title.RichText=true title.TextStrokeTransparency=0.6 title.TextStrokeColor3=Color3.fromRGB(0,140,255)

local close=Instance.new("TextButton",main) close.Size=UDim2.new(0,32,0,32) close.Position=UDim2.new(1,-37,0,8) close.BackgroundColor3=Color3.fromRGB(200,40,40) close.Text="X" close.TextColor3=Color3.new(1,1,1) close.Font=Enum.Font.GothamBold close.TextSize=16 close.BorderSizePixel=0 Instance.new("UICorner",close).CornerRadius=UDim.new(0,10)

local scroll=Instance.new("ScrollingFrame",main) scroll.Size=UDim2.new(1,-12,1,-60) scroll.Position=UDim2.new(0,6,0,55) scroll.BackgroundTransparency=1 scroll.ScrollBarThickness=3 scroll.ScrollBarImageColor3=Color3.fromRGB(120,180,255) scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y

local uiList=Instance.new("UIListLayout",scroll) uiList.Padding=UDim.new(0,7) uiList.SortOrder=Enum.SortOrder.LayoutOrder

local btns={}

local function createBtn(p)

if p==lp or not p.Character or not p.Character:FindFirstChild("HumanoidRootPart")then return end

local b=Instance.new("TextButton")b.Size=UDim2.new(1,0,0,36)b.BackgroundColor3=Color3.fromRGB(28,28,40)b.BorderSizePixel=0 b.Text="  "..p.Name b.TextColor3=Color3.fromRGB(230,230,230)b.TextSize=14 b.Font=Enum.Font.GothamSemibold b.TextXAlignment=Enum.TextXAlignment.Left b.AutoButtonColor=false

Instance.new("UICorner",b).CornerRadius=UDim.new(0,9)

b.MouseEnter:Connect(function()if not(follow and target==p)then b.BackgroundColor3=Color3.fromRGB(40,40,60)end end)

b.MouseLeave:Connect(function()if not(follow and target==p)then b.BackgroundColor3=Color3.fromRGB(28,28,40)end end)

b.MouseButton1Click:Connect(function()

if follow and target==p then

follow=false target=nil flying=false noclipping=false b.BackgroundColor3=Color3.fromRGB(28,28,40)

if bv then bv:Destroy()bv=nil end if bav then bav:Destroy()bav=nil end

else

for _,bb in btns do bb.BackgroundColor3=Color3.fromRGB(28,28,40)end

follow=true target=p flying=true noclipping=true b.BackgroundColor3=Color3.fromRGB(70,130,230)

end

end)

b.Parent=scroll table.insert(btns,b)

end

local function refresh()for _,b in btns do b:Destroy()end btns={}for _,p in plrs:GetPlayers()do createBtn(p)end end

refresh()plrs.PlayerAdded:Connect(refresh)plrs.PlayerRemoving:Connect(refresh)

close.MouseButton1Click:Connect(function()follow=false flying=false noclipping=false if bv then bv:Destroy()end if bav then bav:Destroy()end sg:Destroy()end)

rs.Stepped:Connect(function()

if noclipping and lp.Character then

for _,part in lp.Character:GetDescendants()do if part:IsA("BasePart")then part.CanCollide=false end end

end

end)

local function startFly()

if flying and lp.Character and lp.Character:FindFirstChild("Humanoid")then

local hum=lp.Character.Humanoid local root=lp.Character.HumanoidRootPart

hum.PlatformStand=true bv=Instance.new("BodyVelocity",root)bv.MaxForce=Vector3.new(1e5,1e5,1e5)bav=Instance.new("BodyAngularVelocity",root)bav.MaxTorque=Vector3.new(1e5,1e5,1e5)bav.P=1e4

uis.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.Keyboard then

if i.KeyCode==Enum.KeyCode.W then keys.W=true keys.Moving=true

elseif i.KeyCode==Enum.KeyCode.S then keys.S=true keys.Moving=true

elseif i.KeyCode==Enum.KeyCode.A then keys.A=true keys.Moving=true

elseif i.KeyCode==Enum.KeyCode.D then keys.D=true keys.Moving=true end

end end)

uis.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.Keyboard then

if i.KeyCode==Enum.KeyCode.W then keys.W=false

elseif i.KeyCode==Enum.KeyCode.S then keys.S=false

elseif i.KeyCode==Enum.KeyCode.A then keys.A=false

elseif i.KeyCode==Enum.KeyCode.D then keys.D=false end

if not(keys.W or keys.S or keys.A or keys.D)then keys.Moving=false end

end end)

end

end

rs.Heartbeat:Connect(function()

if flying and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")then

local root=lp.Character.HumanoidRootPart local cam=workspace.CurrentCamera local moveDir=Vector3.new()

if keys.W then moveDir=moveDir+cam.CFrame.LookVector end

if keys.S then moveDir=moveDir-cam.CFrame.LookVector end

if keys.A then moveDir=moveDir-cam.CFrame.RightVector*-1 end

if keys.D then moveDir=moveDir+cam.CFrame.RightVector end

if keys.Moving then bv.Velocity=moveDir.Unit*flySpeed else bv.Velocity=Vector3.new()end

if follow and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")then

local goal=target.Character.HumanoidRootPart.Position+offset

root.CFrame=root.CFrame:Lerp(CFrame.new(goal),lerpSpeed)

end

else

if bv then bv.Velocity=Vector3.new()end

end

end)

local oldFollow=false

rs.Heartbeat:Connect(function()

if follow~=oldFollow then

oldFollow=follow

if follow then startFly() else

flying=false noclipping=false

if bv then bv:Destroy()bv=nil end

if bav then bav:Destroy()bav=nil end

if lp.Character and lp.Character:FindFirstChild("Humanoid")then lp.Character.Humanoid.PlatformStand=false end

end

end

end)

local drag,dragInp,startP,startPos

main.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true startP=i.Position startPos=main.Position i.Changed:Connect(function()if i.UserInputState==Enum.UserInputState.End then drag=false end end)end end)

main.InputChanged:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then dragInp=i end end)

uis.InputChanged:Connect(function(i)if i==dragInp and drag then local d=i.Position-startP main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)end end)

print("©™Cay vẫn phải hub - tiktok cayvanphaihub2025qa")
