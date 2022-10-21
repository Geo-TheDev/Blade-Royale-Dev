local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local UIService = Knit.CreateService {
    Name = "UIService",
    Client = {
        InitConfirmation = Knit.CreateSignal(),
        SendNotification = Knit.CreateSignal(),
        LoadEssentialUI = Knit.CreateSignal(),
        UpdateTimer = Knit.CreateSignal(),
        StopTimer = Knit.CreateSignal(),
    },
}

function UIService:ConfirmationScreen(Player: Player, Args)
    self.Client.InitConfirmation:Fire(Player, Args)
end

function UIService:SendNotification(Player: Player, Args)
    self.Client.SendNotification:Fire(Player, Args)
end

function UIService:LoadEssentialUI(Player: Player)
    self.Client.LoadEssentialUI:Fire(Player)
end

function UIService:UpdateTimer(Player: Player, Time: number)
    self.Client.UpdateTimer:Fire(Player, {CurrentTime = Time})
end

function UIService:StopTimer(Player: Player, Time: number)
    self.Client.StopTimer:Fire(Player, {CurrentTime = Time})
end

function UIService:KnitStart()
    print("UIService Started")
end

return UIService