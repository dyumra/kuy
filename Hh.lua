local Players = game:GetService("Players")
local player = Players.LocalPlayer

task.wait(math.random(10, 30))  -- รอแบบสุ่มเวลา 10-30 วินาที เพื่อไม่ให้ดูน่าสงสัย

if player then
    player:Kick("Lost connection to server. (Error Code: 277)")
end
