local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Config = require(script.Parent.GameConfig)

local GameService = Knit.CreateService {
    Name = "GameService",
    Client = {},
    Round_Length = Config.ROUND_LENGTH,
    Intermission_Length = Config.INTERMISSION_LENGTH,
    Players_To_Start = Config.PLAYERS_TO_START,
    PlayersInGame = {},
    StartedGame = false,
}

function GameService:CheckForPlayers()
    if #Players:GetPlayers() >= self.Players_To_Start then
        return true
    else
        return false
    end
end

function GameService:KnitStart()
    Players.PlayerAdded:Connect(function(Player)
        Player:SetAttribute("InBattle", false)
        if self:CheckForPlayers() == true and self.StartedGame == false then
            self.StartedGame = true
            self:StartGame()
        end
    end)
end

function GameService:StartGame()
    local TimerService = Knit.GetService("TimerService")

    while self:CheckForPlayers() == true do
        for _, Player: Player in pairs(Players:GetChildren()) do
            self:SendNotification(Player, "Intermission Started!")
        end
        TimerService:Stop()
        self.Timer = TimerService:CreateTimer(
            {
                Length = self.Intermission_Length,
                Callback = function()
                    print("Intermission Complete!")
                end,
                ShowGUI = true,
            })
        
        task.wait(self.Intermission_Length)
        for _, Player: Player in pairs(Players:GetChildren()) do
            self:SendNotification(Player, "Intermission Ended!")
        end
        
        self:StartRound()
        
        for _, Player: Player in pairs(Players:GetChildren()) do
            self:SendNotification(Player, "Round Started!")
        end
        
        repeat
            task.wait()
        until #self.PlayersInGame == 1
        
        print(self.PlayersInGame[1])
        self.PlayersInGame = {}
        self:EndRound()
    end
end

function GameService:StartRound()
    local PlayerService = Knit.GetService("PlayerService")

    for _, Player: Player in pairs(Players:GetChildren()) do
        PlayerService:ChangeBattleState(Player, false, true)
        table.insert(self.PlayersInGame, Player)
    end

    print(self.PlayersInGame)

    self.Map = self:GenerateRandomMap()
    self.Map.Parent = workspace

    for _, Player: Player in pairs(Players:GetChildren()) do
        local HumanoidRootPart: Part = Player.Character:FindFirstChild("HumanoidRootPart")
        local Humanoid: Humanoid = Player.Character:FindFirstChild("Humanoid")

        HumanoidRootPart.CFrame = self.Map.Spawn.CFrame
        Humanoid.WalkSpeed = 50

        Player.CharacterRemoving:Connect(function()
            table.remove(self.PlayersInGame, table.find(self.PlayersInGame, Player))
            print(self.PlayersInGame)
        end)

        task.delay(5, function()
            Humanoid.WalkSpeed = 16
            PlayerService:ChangeBattleState(Player, true, true)
        end)
    end
end

function GameService:EndRound()
    local PlayerService = Knit.GetService("PlayerService")

    self.Map:Destroy()

    for _, Player: Player in pairs(Players:GetChildren()) do
        PlayerService:ChangeBattleState(Player, false, true)
        Player.Character.Humanoid.Health = 0
    end
end

function GameService:GenerateRandomMap()
    local Maps = ServerStorage.Maps:GetChildren()
    local Random = Maps[math.random(1,#Maps)]

    return Random:Clone()
end

function GameService:GivePlayerSword(Player: Player)
    local DataService = Knit.GetService("DataService")
    local PlayerData = DataService:Get(Player)

    if PlayerData then
        if not Player.Backpack:FindFirstChildWhichIsA("Tool") or not Player.Character:FindFirstChildWhichIsA("Tool") then
            local Sword = ServerStorage.Items:FindFirstChild(PlayerData.Equiped_Sword):Clone()
            Sword.Parent = Player.Backpack
        else
            warn("Player already has a sword!")
        end
    else
        warn("PlayerData Returned nil")
    end
end

function GameService:SendNotification(Player: Player, Input: string)
    local UIService = Knit.GetService("UIService")

    UIService:SendNotification(
        Player,
        {
            Text = Input;
        }
    )
end

return GameService