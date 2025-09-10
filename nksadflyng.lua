-- Services
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local player = game.Players.LocalPlayer

-- Multi-track URLs
local tracksURLs = {
    ["BC - 1"] = "https://raw.githubusercontent.com/fyybisnis4-gif/Fyy/refs/heads/main/CP1.json",
    ["CP 1 - CP 2"] = "https://raw.githubusercontent.com/fyybisnis4-gif/Fyy/refs/heads/main/CP2.json", 
    ["CP 2 - CP 3"] = "https://raw.githubusercontent.com/fyybisnis4-gif/Fyy/refs/heads/main/CP2-2.json",
    ["CP 3 - CP 4"] = "https://raw.githubusercontent.com/fyybisnis4-gif/Fyy/refs/heads/main/CP3.json",
    ["CP 4 - CP 5"] = "https://raw.githubusercontent.com/fyybisnis4-gif/Fyy/refs/heads/main/CP4.json",
    ["CP 5 - SUMMIT"] = "https://raw.githubusercontent.com/fyybisnis4-gif/Fyy/refs/heads/main/CP5.json",
}

local savedTracks = {}

-- Load Tracks
for name, url in pairs(tracksURLs) do
    local success, data = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)

    if success and data and data.points then
        savedTracks[name] = {}
        for _, p in ipairs(data.points) do
            table.insert(savedTracks[name], Vector3.new(p[1], p[2], p[3]))
        end
    else
        savedTracks[name] = {}
    end
end

-- Variabel
local running = false
local speed = 0.01 -- default speed

local function getHRP()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

-- Replay function
-- ✅ daftar CP
local cp1 = {
    Vector3.new(134.11962890625, 141.78271484375, -176.3054656982422)
}
local cp2 = {
    Vector3.new(327.0382385253906, 89.79683685302735, -433.4064636230469)
}
local cp3 = {
    Vector3.new(476.0118103027344, 169.8149871826172, -939.1278686523438)
}
local cp4 = {
    Vector3.new(930.0757446289063, 133.3873748779297, -626.1312866210938)
}
local cp5 = {
    Vector3.new(924.6644287109375, 101.67333221435547, 279.9154968261719)
}
local cp6 = {
    Vector3.new(253.24855041503907, 325.2210998535156, 704.4208374023438)
}

-- gabung semua CP ke list
local tracks = {cp1, cp2, cp3, cp4, cp5, cp6}

-- ⚡ default skip
local defaultSkip = 20
local specialSkip = {
    [5] = 1 -- pas jalur menuju CP5, pakai skip 1
}

-- 🚀 playTrack adaptif
local function playTrack(track, cpIndex)
    if not track or #track < 1 then return end
    local hrp = getHRP()
    local i = 1
    while i <= #track do
        if not running then break end

        local step = defaultSkip
        if specialSkip[cpIndex] then
            step = specialSkip[cpIndex]
        end

        hrp.CFrame = CFrame.new(track[i])
        task.wait(speed) -- pakai speed dari script asli kamu

        i = i + step
    end
end

-- ✅ contoh pemanggilan
-- playTrack(cp1, 1)
-- playTrack(cp2, 2)
-- playTrack(cp3, 3)
-- playTrack(cp4, 4)
-- playTrack(cp5, 5)  --> skip 1
-- playTrack(cp6, 6)

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MT_Arunika"
ScreenGui.Parent = CoreGui

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 300)
Frame.Position = UDim2.new(0.5, -150, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "MT Arunika"
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.TextColor3 = Color3.fromRGB(180, 180, 180)
Title.TextScaled = true

local speedBox = Instance.new("TextBox", Frame)
speedBox.Size = UDim2.new(0.9, 0, 0, 40)
speedBox.Position = UDim2.new(0.05, 0, 0, 40)
speedBox.PlaceholderText = "Speed (default 0.01)"
speedBox.Text = tostring(speed)
speedBox.TextColor3 = Color3.fromRGB(180, 180, 180)
speedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
speedBox.TextScaled = true
speedBox.ClearTextOnFocus = false

speedBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local val = tonumber(speedBox.Text)
        if val and val > 0 then
            speed = val
        else
            speedBox.Text = tostring(speed)
        end
    end
end)

-- Scrollable Button Frame
local Scroll = Instance.new("ScrollingFrame", Frame)
Scroll.Size = UDim2.new(0.9, 0, 0, 180)
Scroll.Position = UDim2.new(0.05, 0, 0, 75)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 6
Scroll.CanvasSize = UDim2.new(0, 0, 0, 240) -- Adjusted CanvasSize
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 5)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- Add Track Buttons in the right order
local orderedTrackNames = {
    "BC - 1", "CP 1 - CP 2", "CP 2 - CP 3", "CP 3 - CP 4", "CP 4 - CP 5", "CP 5 - SUMMIT"
}

for _, name in ipairs(orderedTrackNames) do
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextScaled = true

    btn.MouseButton1Click:Connect(function()
        if running then return end
        running = true
        coroutine.wrap(function()
            playTrack(savedTracks[name])
            running = false
        end)()
    end)
end

-- STOP Button
local stopBtn = Instance.new("TextButton", Frame)
stopBtn.Size = UDim2.new(0.9, 0, 0, 40)
stopBtn.Position = UDim2.new(0.05, 0, 0, 240)
stopBtn.Text = "STOP"
stopBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
stopBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
stopBtn.TextScaled = true

stopBtn.MouseButton1Click:Connect(function()
    running = false
end)

-- Minimize Button (Fox Logo)
local closeBtn = Instance.new("TextButton", Frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
closeBtn.TextScaled = true
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

closeBtn.MouseButton1Click:Connect(function()
    -- Mengubah tombol X menjadi tombol "Fox" berbentuk bulat saat ditekan
    Frame.Visible = false
    local logoBtn = Instance.new("TextButton", ScreenGui)
    logoBtn.Size = UDim2.new(0, 40, 0, 40)
    logoBtn.Position = UDim2.new(0, 50, 0, 50)
    logoBtn.Text = "Fyy"
    logoBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    logoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    logoBtn.TextScaled = true
    Instance.new("UICorner", logoBtn).CornerRadius = UDim.new(1, 0)

    logoBtn.MouseButton1Click:Connect(function()
        -- Show frame again when clicked
        Frame.Visible = true
        logoBtn:Destroy()  -- Remove the logo when the menu is restored
    end)
end)

-- Drag Function (for entire menu including the logo)
local function setupDrag(target)
    local dragging, dragStart, startPos
    target.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    target.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                target.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end
    end)
end
setupDrag(Frame)  -- Dragging enabled for the whole frame
