-- // ANTI AFK TOGGLE (UI Button)
local vu = game:GetService("VirtualUser")
local antiAfkEnabled = false

CreateMenuToggle(miscTab, "Anti AFK", false, function(Value)
    antiAfkEnabled = Value
    if antiAfkEnabled then
        Rayfield:Notify({
            Title = "Anti AFK",
            Content = "✅ Anti AFK Activated",
            Duration = 2
        })

        task.spawn(function()
            while antiAfkEnabled do
                task.wait(60)
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end
        end)
    else
        Rayfield:Notify({
            Title = "Anti AFK",
            Content = "❌ Anti AFK Deactivated",
            Duration = 2
        })
    end
end)
