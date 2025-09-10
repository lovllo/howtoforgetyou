-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ====== File Replay ======
local SAVE_FILE = "Replays.json"
local hasFileAPI = (writefile and readfile and isfile) and true or false

local function safeWrite(data)
    if hasFileAPI then writefile(SAVE_FILE, HttpService:JSONEncode(data)) end
end

local function safeRead()
    if hasFileAPI and isfile(SAVE_FILE) then
        local ok, decoded = pcall(function()
            return HttpService:JSONDecode(readfile(SAVE_FILE))
        end)
        if ok and decoded then return decoded end
    end
    return {}
end

local savedReplays = safeRead()

-- ====== GUI Helpers ======
local function styleFrame(frame, radius, color)
    frame.BackgroundColor3 = color
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0,radius)
end

local function styleButton(btn, color)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,8)
end

-- ====== Main GUI ======
local guiName = "SafeReplayFull"
if playerGui:FindFirstChild(guiName) then playerGui[guiName]:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,400,0,400)
mainFrame.Position = UDim2.new(0.5,-200,0.2,0)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
styleFrame(mainFrame,12,Color3.fromRGB(35,35,40))

-- Header
local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1,0,0,40)
styleFrame(header,12,Color3.fromRGB(45,45,55))

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,-90,1,0)
title.Position = UDim2.new(0,15,0,0)
title.BackgroundTransparency = 1
title.Text = "🏔 Safe Auto Walk"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0,35,0,35)
closeBtn.Position = UDim2.new(1,-50,0,3)
closeBtn.Text = "✖"
styleButton(closeBtn, Color3.fromRGB(200,70,70))
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- ====== Content ======
local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1,0,1,-40)
contentFrame.Position = UDim2.new(0,0,0,40)
styleFrame(contentFrame,12,Color3.fromRGB(45,45,55))

-- Buttons
local recordBtn = Instance.new("TextButton", contentFrame)
recordBtn.Size = UDim2.new(0,120,0,35)
recordBtn.Position = UDim2.new(0,15,0,15)
recordBtn.Text = "⏺ Record"
styleButton(recordBtn, Color3.fromRGB(70,130,180))

local pauseRecordBtn = Instance.new("TextButton", contentFrame)
pauseRecordBtn.Size = UDim2.new(0,120,0,35)
pauseRecordBtn.Position = UDim2.new(0,150,0,15)
pauseRecordBtn.Text = "⏸ Pause Rec"
styleButton(pauseRecordBtn, Color3.fromRGB(255,215,0))
pauseRecordBtn.Visible = false

local saveBtn = Instance.new("TextButton", contentFrame)
saveBtn.Size = UDim2.new(0,120,0,35)
saveBtn.Position = UDim2.new(0,285,0,15)
saveBtn.Text = "💾 Save Replay"
styleButton(saveBtn, Color3.fromRGB(34,139,34))

local loadBtn = Instance.new("TextButton", contentFrame)
loadBtn.Size = UDim2.new(0,120,0,35)
loadBtn.Position = UDim2.new(0,15,0,60)
loadBtn.Text = "📂 Load Path"
styleButton(loadBtn, Color3.fromRGB(100,149,237))

local mergeBtn = Instance.new("TextButton", contentFrame)
mergeBtn.Size = UDim2.new(0,150,0,35)
mergeBtn.Position = UDim2.new(0,150,0,60)
mergeBtn.Text = "🔗 Merge & Play"
styleButton(mergeBtn, Color3.fromRGB(255,140,0))

-- Speed Control
local speedLabel = Instance.new("TextLabel", contentFrame)
speedLabel.Size = UDim2.new(0,50,0,30)
speedLabel.Position = UDim2.new(0,15,0,105)
speedLabel.Text = "Speed:"
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 14
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedBox = Instance.new("TextBox", contentFrame)
speedBox.Size = UDim2.new(0,50,0,30)
speedBox.Position = UDim2.new(0,70,0,105)
speedBox.Text = "1"
speedBox.ClearTextOnFocus = false
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.BackgroundColor3 = Color3.fromRGB(80,80,90)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 14
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0,6)

-- Replay List
local replayList = Instance.new("ScrollingFrame", contentFrame)
replayList.Size = UDim2.new(1,-30,1,-150)
replayList.Position = UDim2.new(0,15,0,145)
replayList.CanvasSize = UDim2.new(0,0,0,0)
replayList.ScrollBarThickness = 6
styleFrame(replayList, 10, Color3.fromRGB(55,55,65))

local listLayout = Instance.new("UIListLayout", replayList)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0,5)

-- ====== Replay Logic ======
local character, humanoidRootPart
local isRecording, isPaused, isPausedRecord = false, false, false
local recordData = {}
local currentReplayToken = nil

local function onCharacterAdded(char)
    character = char
    humanoidRootPart = char:WaitForChild("HumanoidRootPart",10)
end
player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then onCharacterAdded(player.Character) end

local function startRecording()
    recordData = {}
    isRecording = true
    isPausedRecord = false
    pauseRecordBtn.Visible = true
end

local function stopRecording()
    isRecording = false
    isPausedRecord = false
    pauseRecordBtn.Visible = false
end

RunService.Heartbeat:Connect(function()
    if isRecording and not isPausedRecord and humanoidRootPart and humanoidRootPart.Parent then
        local cf = humanoidRootPart.CFrame
        table.insert(recordData, {
            Position = {cf.Position.X, cf.Position.Y, cf.Position.Z},
            LookVector = {cf.LookVector.X, cf.LookVector.Y, cf.LookVector.Z},
            UpVector = {cf.UpVector.X, cf.UpVector.Y, cf.UpVector.Z}
        })
    end
end)

local function playReplay(data)
    local token = {}
    currentReplayToken = token
    isPaused = false
    local speed = tonumber(speedBox.Text) or 1
    if speed <= 0 then speed = 1 end
    local index = 1
    local totalFrames = #data
    while index <= totalFrames do
        if currentReplayToken ~= token then break end
        while isPaused and currentReplayToken == token do
            RunService.Heartbeat:Wait()
        end
        if humanoidRootPart and humanoidRootPart.Parent and currentReplayToken == token then
            local frame = data[math.floor(index)]
            local pos = frame.Position
            local look = frame.LookVector
            local up = frame.UpVector
            humanoidRootPart.CFrame = CFrame.lookAt(
                Vector3.new(pos[1],pos[2],pos[3]),
                Vector3.new(pos[1]+look[1], pos[2]+look[2], pos[3]+look[3]),
                Vector3.new(up[1], up[2], up[3])
            )
        end
        index = index + speed
        RunService.Heartbeat:Wait()
    end
    if currentReplayToken == token then
        currentReplayToken = nil
    end
end

-- Tambah tombol lain sama persis seperti skrip asli...
-- Save, Load, Merge, Scroll list, dll. (semua aman, hanya akses lokal)

if not hasFileAPI then
    warn("[SafeReplayFull] Executor tidak support file API, replay hanya sementara!")
end
