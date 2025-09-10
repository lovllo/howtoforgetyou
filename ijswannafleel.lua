-- // ANTI AFK SCRIPT (Standalone, With Button, Persistent)
-- // ON tetap aktif walau respawn
-- // Dibuat khusus biar ga kena kick AFK

local vu = game:GetService("VirtualUser")
local antiAfkEnabled = false

--== [ UI Setup ] ==--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiAFKGui"
ScreenGui.ResetOnSpawn = false -- biar ga ilang saat respawn
ScreenGui.Parent = game:GetService("CoreGui")

local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "Anti AFK: OFF"
ToggleButton.Size = UDim2.new(0, 120, 0, 40)
ToggleButton.Position = UDim2.new(0, 20, 0, 200)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 18
ToggleButton.Visible = true

--== [ Logic Anti AFK ] ==--
local function startAntiAfk()
    task.spawn(function()
        while antiAfkEnabled do
            task.wait(60) -- setiap 60 detik
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end
    end)
end

ToggleButton.MouseButton1Click:Connect(function()
    antiAfkEnabled = not antiAfkEnabled
    if antiAfkEnabled then
        ToggleButton.Text = "Anti AFK: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        startAntiAfk()
    else
        ToggleButton.Text = "Anti AFK: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    end
end)

--== [ Persist after Respawn ] ==--
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    if antiAfkEnabled then
        startAntiAfk()
    end
end)

print("✅ Anti AFK siap. Tombol tetap ada, dan kalau ON bakal lanjut walau respawn.")
