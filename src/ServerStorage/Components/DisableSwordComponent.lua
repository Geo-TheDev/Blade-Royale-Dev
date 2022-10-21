local Players = game:GetService("Players")
local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Component = require(game:GetService("ReplicatedStorage").Packages.Component)

local DisableSwordComponent =  Component.new {
    Tag = "DisableSword"
}

function DisableSwordComponent:Construct()
    local PlayerService = Knit.GetService("PlayerService")

    self.TouchedFunction = function(hit)
        if hit.Parent:FindFirstChild("Humanoid") then
            local Player = Players:GetPlayerFromCharacter(hit.Parent)
            
            if Player:GetAttribute("InBattle") == true then
                PlayerService:ChangeBattleState(Player, false, false)
            end
        end
    end
end

function DisableSwordComponent:Start()
    self.Instance.Touched:Connect(self.TouchedFunction)
end

return DisableSwordComponent