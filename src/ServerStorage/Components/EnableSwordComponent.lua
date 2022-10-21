local Players = game:GetService("Players")
local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Component = require(game:GetService("ReplicatedStorage").Packages.Component)

local EnableSwordComponent =  Component.new {
    Tag = "EnableSword"
}

function EnableSwordComponent:Construct()
    local PlayerService = Knit.GetService("PlayerService")

    self.TouchedFunction = function(hit)
        if hit.Parent:FindFirstChild("Humanoid") then
            local Player = Players:GetPlayerFromCharacter(hit.Parent)
            
            if Player:GetAttribute("InBattle") == false or nil then
                PlayerService:ChangeBattleState(Player, true, false)
            end
        end
    end
end

function EnableSwordComponent:Start()
    self.Instance.Touched:Connect(self.TouchedFunction)
end

return EnableSwordComponent