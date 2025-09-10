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

-- ====== UI Helper ======
local function styleFrame(frame, radius, color)
    frame.BackgroundColor3 = color
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, radius)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(80,80,80)
end

local function styleButton(btn, color)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,8)
end

local function addShadow(frame)
    local shadow = Instance.new("ImageLabel", frame)
    shadow.ZIndex = 0
    shadow.Size = UDim2.new(1,30,1,30)
    shadow.Position = UDim2.new(0,-15,0,-15)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5028857472"
    shadow.ImageColor3 = Color3.fromRGB(0,0,0)
    shadow.ImageTransparency = 0.5
end

-- ====== Main Frame ======
local guiName = "MountaineerRecorderModern"
local oldGui = playerGui:FindFirstChild(guiName)
if oldGui then oldGui:Destroy() end

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
styleFrame(mainFrame, 12, Color3.fromRGB(35,35,40))
addShadow(mainFrame)

-- ====== Header ======
local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1,0,0,40)
styleFrame(header, 12, Color3.fromRGB(45,45,55))

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,-90,1,0)
title.Position = UDim2.new(0,15,0,0)
title.BackgroundTransparency = 1
title.Text = "🏔 PS SCRIPT AUTO WALK"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0,35,0,35)
closeBtn.Position = UDim2.new(1,-50,0,3)
closeBtn.Text = "✖"
styleButton(closeBtn, Color3.fromRGB(200,70,70))

local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Size = UDim2.new(0,35,0,35)
minimizeBtn.Position = UDim2.new(1,-95,0,3)
minimizeBtn.Text = "—"
styleButton(minimizeBtn, Color3.fromRGB(80,80,80))

-- ====== Content ======
local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1,0,1,-40)
contentFrame.Position = UDim2.new(0,0,0,40)
styleFrame(contentFrame, 12, Color3.fromRGB(45,45,55))

-- Tombol
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

-- ====== Speed Control ======
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

-- Scroll replay
local replayList = Instance.new("ScrollingFrame", contentFrame)
replayList.Size = UDim2.new(1,-30,1,-150)
replayList.Position = UDim2.new(0,15,0,145)
replayList.CanvasSize = UDim2.new(0,0,0,0)
replayList.ScrollBarThickness = 6
styleFrame(replayList, 10, Color3.fromRGB(55,55,65))

local listLayout = Instance.new("UIListLayout", replayList)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0,5)

-- ====== Replay Variables ======
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

-- ====== Record / Playback ======
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

-- ====== Replay List Item ======
function addReplayItem(saved, index)
    local item = Instance.new("Frame", replayList)
    item.Size = UDim2.new(1,-10,0,45)
    styleFrame(item,8,Color3.fromRGB(65,65,75))
    item.LayoutOrder = index
    saved.Selected = false

    local nameBox = Instance.new("TextBox", item)
    nameBox.Size = UDim2.new(0.35,0,1,0)
    nameBox.Text = saved.Name
    nameBox.TextColor3 = Color3.new(1,1,1)
    nameBox.BackgroundColor3 = Color3.fromRGB(90,90,100)
    nameBox.Font = Enum.Font.Gotham
    nameBox.TextSize = 14
    nameBox.ClearTextOnFocus = false
    Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0,6)
    nameBox.FocusLost:Connect(function()
        saved.Name = nameBox.Text
    end)

    local playBtn = Instance.new("TextButton", item)
    playBtn.Size = UDim2.new(0,35,0,30)
    playBtn.Position = UDim2.new(0.4,0,0.5,-15)
    playBtn.Text = "▶"
    styleButton(playBtn, Color3.fromRGB(70,130,180))

    local pauseBtn = Instance.new("TextButton", item)
    pauseBtn.Size = UDim2.new(0,35,0,30)
    pauseBtn.Position = UDim2.new(0.48,0,0.5,-15)
    pauseBtn.Text = "⏸"
    styleButton(pauseBtn, Color3.fromRGB(255,215,0))

    local delBtn = Instance.new("TextButton", item)
    delBtn.Size = UDim2.new(0,35,0,30)
    delBtn.Position = UDim2.new(0.56,0,0.5,-15)
    delBtn.Text = "🗑"
    styleButton(delBtn, Color3.fromRGB(220,20,60))

    local saveToJsonBtn = Instance.new("TextButton", item)
    saveToJsonBtn.Size = UDim2.new(0,35,0,30)
    saveToJsonBtn.Position = UDim2.new(0.64,0,0.5,-15)
    saveToJsonBtn.Text = "💾"
    styleButton(saveToJsonBtn, Color3.fromRGB(34,139,34))

    local selectCheck = Instance.new("TextButton", item)
    selectCheck.Size = UDim2.new(0,25,0,25)
    selectCheck.Position = UDim2.new(0.72,0,0.5,-12)
    selectCheck.Text = "☐"
    styleButton(selectCheck, Color3.fromRGB(100,100,100))

    local upBtn = Instance.new("TextButton", item)
    upBtn.Size = UDim2.new(0,25,0,25)
    upBtn.Position = UDim2.new(0.82,0,0.5,-12)
    upBtn.Text = "⬆"
    styleButton(upBtn, Color3.fromRGB(100,149,237))

    local downBtn = Instance.new("TextButton", item)
    downBtn.Size = UDim2.new(0,25,0,25)
    downBtn.Position = UDim2.new(0.9,0,0.5,-12)
    downBtn.Text = "⬇"
    styleButton(downBtn, Color3.fromRGB(100,149,237))

    selectCheck.MouseButton1Click:Connect(function()
        saved.Selected = not saved.Selected
        selectCheck.Text = saved.Selected and "☑" or "☐"
    end)

    playBtn.MouseButton1Click:Connect(function()
        task.spawn(function() playReplay(saved.Frames) end)
    end)
    pauseBtn.MouseButton1Click:Connect(function() isPaused = not isPaused end)
    delBtn.MouseButton1Click:Connect(function()
        table.remove(savedReplays, index)
        refreshReplayList()
    end)
    saveToJsonBtn.MouseButton1Click:Connect(function()
        safeWrite(savedReplays)
    end)

    upBtn.MouseButton1Click:Connect(function()
        if index > 1 then
            local temp = savedReplays[index]
            savedReplays[index] = savedReplays[index-1]
            savedReplays[index-1] = temp
            refreshReplayList()
        end
    end)

    downBtn.MouseButton1Click:Connect(function()
        if index < #savedReplays then
            local temp = savedReplays[index]
            savedReplays[index] = savedReplays[index+1]
            savedReplays[index+1] = temp
            refreshReplayList()
        end
    end)
end

-- ====== Refresh List ======
function refreshReplayList()
    for _, child in ipairs(replayList:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    for i, r in ipairs(savedReplays) do
        addReplayItem(r, i)
    end
    replayList.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y + 10)
end

refreshReplayList()

-- ====== Button Functions ======
recordBtn.MouseButton1Click:Connect(function()
    if not isRecording then
        recordBtn.Text = "⏹ Stop"
        startRecording()
    else
        recordBtn.Text = "⏺ Record"
        stopRecording()
    end
end)

pauseRecordBtn.MouseButton1Click:Connect(function()
    if isRecording then
        isPausedRecord = not isPausedRecord
        pauseRecordBtn.Text = isPausedRecord and "▶ Resume Rec" or "⏸ Pause Rec"
    end
end)

saveBtn.MouseButton1Click:Connect(function()
    if #recordData > 0 then
        local saved = {Frames=recordData, Name="Replay "..(#savedReplays+1), Selected=false}
        table.insert(savedReplays, saved)
        refreshReplayList()
    end
end)

loadBtn.MouseButton1Click:Connect(function()
    savedReplays = safeRead()
    refreshReplayList()
end)

mergeBtn.MouseButton1Click:Connect(function()
    local mergedFrames = {}
    for _, r in ipairs(savedReplays) do
        if r.Selected then
            for _, frame in ipairs(r.Frames) do
                table.insert(mergedFrames, frame)
            end
        end
    end
    if #mergedFrames > 0 then
        task.spawn(function() playReplay(mergedFrames) end)
    end
end)

minimizeBtn.MouseButton1Click:Connect(function()
    contentFrame.Visible = not contentFrame.Visible
    mainFrame.Size = contentFrame.Visible and UDim2.new(0,400,0,400) or UDim2.new(0,400,0,40)
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

if not hasFileAPI then
    warn("[Mountaineer Recorder] Executor tidak support file API, replay hanya sementara!")
end
