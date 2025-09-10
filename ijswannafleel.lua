-- // ANTI AFK SCRIPT (FULL STANDALONE)
-- // By lovllo
-- // Fitur: Toggle ON/OFF biar ga kena kick AFK

--== [ Rayfield Loader ] ==--
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Anti AFK Script",
    LoadingTitle = "Loading Anti AFK...",
    LoadingSubtitle = "by lovllo",
    ConfigurationSaving = {
        Enabled = false
    }
})

local Tab = Window:CreateTab("Main", 4483362458) -- Ikon tab

--== [ Anti AFK Logic ] ==--
local vu = game:GetService("VirtualUser")
local antiAfkEnabled = false

local Toggle = Tab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = false,
    Flag = "AntiAFKToggle",
    Callback = function(Value)
        antiAfkEnabled = Value

        if antiAfkEnabled then
            Rayfield:Notify({
                Title = "Anti AFK",
                Content = "✅ Activated",
                Duration = 3
            })

            task.spawn(function()
                while antiAfkEnabled do
                    task.wait(60) -- setiap 60 detik
                    vu:CaptureController()
                    vu:ClickButton2(Vector2.new())
                end
            end)
        else
            Rayfield:Notify({
                Title = "Anti AFK",
                Content = "❌ Deactivated",
                Duration = 3
            })
        end
    end,
})
