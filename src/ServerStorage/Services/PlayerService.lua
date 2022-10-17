local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local SwordsFolder = ServerStorage:WaitForChild("Items")

local PlayerService = Knit.CreateService {
    Name = "PlayerService",
    Client = {},
}

function PlayerJoined(player: Player)
    local DataService = Knit.GetService("DataService")
    player.CharacterAdded:Connect(CharacterAdded)
end

function CharacterAdded(Character: Model)
    local player = Players:GetPlayerFromCharacter(Character)
    local DataService = Knit.GetService("DataService")
    local PlayerData = DataService:Get(player)
    
    repeat
        PlayerData = DataService:Get(player)
        task.wait()
    until PlayerData ~= nil

    local Sword = SwordsFolder:FindFirstChild(PlayerData.Equiped_Sword):Clone()
    Sword.Parent = player.Backpack
end

function PlayerService:KnitStart()
    Players.PlayerAdded:Connect(PlayerJoined)
end

return PlayerService