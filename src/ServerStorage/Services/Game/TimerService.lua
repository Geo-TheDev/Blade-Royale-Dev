local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Knit = require(ReplicatedStorage.Packages.Knit)

local TimerService = Knit.CreateService {
    Name = "TimerService",
    Client = {},
    State = false,
}

function TimerService:CreateTimer(Args)
    local UIService = Knit.GetService("UIService")
    if Args.ShowGUI then
        for _, v: Player in pairs(Players:GetChildren()) do
            UIService:UpdateTimer(v)
        end
    end
    
    -- UIService:UpdateTimer(v, self:ToMinutes(math.floor(Args.Length)))
    self.Connection = RunService.Stepped:Connect(function(_, step)
        if Args.Length > 0 then
            Args.Length -= step
            ReplicatedStorage.TimerValue.Value = self:ToMinutes(math.floor(Args.Length))
        else
            Args.Callback()
            for _, v: Player in pairs(Players:GetChildren()) do
                UIService:StopTimer(v)
            end
            self.Connection:Disconnect()
        end
    end)

end

function TimerService:ToMinutes(num)
    local minutes = tostring(math.floor(num/60))
    local seconds = tostring(math.floor(num%60))
    if #minutes < 2 then
        minutes = "0"..minutes
    end
    if #seconds < 2 then
        seconds = "0"..seconds
    end
    return minutes..":"..seconds
end

function TimerService:Stop()
    if self.Connection then        
        self.Connection:Disconnect()
        print("Stopped Timer!")
    end
end

return TimerService