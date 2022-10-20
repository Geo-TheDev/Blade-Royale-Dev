local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Config = require(script.Parent.GameConfig)

local GameService = Knit.CreateService {
    Name = "GameService",
    Client = {},
    Round_Length = Config.ROUND_LENGTH,
    Intermission_Length = Config.INTERMISSION_LENGTH,
}

function GameService:CheckForPlayers()
    if #Players:GetPlayers() >= 1 then
        return true
    else
        return false
    end
end

function GameService:KnitStart()
    local UIService = Knit.GetService("UIService")

    while true do
        task.wait(self.Intermission_Length)
        for _, Player: Player in pairs(Players:GetChildren()) do
            UIService:SendNotification(
                Player,
                {
                    Text = "Intermission Ended!";
                }
            )
        end
        task.wait(self.Round_Length)
        for _, Player: Player in pairs(Players:GetChildren()) do
            UIService:SendNotification(
                Player, 
                {
                    Text = "Round Ended!";
                }
            )
        end
    end
end

return GameService