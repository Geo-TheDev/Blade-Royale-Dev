local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local PlayerService = Knit.CreateService {
    Name = "PlayerService",
    Client = {},
}


function PlayerService:KnitStart()
    local GameSevice = Knit.GetService("GameService")
    local UIService =  Knit.GetService("UIService")

    Players.PlayerAdded:Connect(function(player)
        player:SetAttribute("InBattle", false)
        player:GetAttributeChangedSignal("InBattle"):Connect(function()
            local att = player:GetAttribute("InBattle")
            if att == false then
                if player.Backpack:FindFirstChildWhichIsA("Tool") then
                    player.Backpack:FindFirstChildWhichIsA("Tool"):Destroy()
                elseif player.Character:FindFirstChildWhichIsA("Tool") then
                    player.Character:FindFirstChildWhichIsA("Tool"):Destroy()
                end
            elseif att == true then
                GameSevice:GivePlayerSword(player)
            end
        end)

        player.CharacterAdded:Connect(function()
            UIService:LoadEssentialUI(player)
        end)
    end)
end

function PlayerService:ChangeBattleState(player, state, SendNotification)
    local UIService = Knit.GetService("UIService")

    player:SetAttribute("InBattle", state)

    if state == true and SendNotification then
        UIService:SendNotification(
            player,
            {
                Text = "PVP Has been turned on!";
            }
        )
    elseif state == false and SendNotification then
        UIService:SendNotification(
            player,
            {
                Text = "PVP Has been turned off!";
            }
        )
    end
end

return PlayerService
