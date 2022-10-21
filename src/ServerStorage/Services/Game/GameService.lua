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
    Players = {},
}

function GameService:CheckForPlayers()
    if #Players:GetPlayers() >= 1 then
        return true
    else
        return false
    end
end

function GameService:KnitStart()
    Players.PlayerAdded:Connect(function(Player)
        Player:SetAttribute("InBattle", false)
        if self:CheckForPlayers() == true then
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

        self.Timer = TimerService:CreateTimer(
            {
                Length = self.Round_Length,
                Callback = function()
                    print("THE TIMER WORKS!")
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

        task.wait(self.Round_Length)
        for _, Player: Player in pairs(Players:GetChildren()) do
            self:SendNotification(Player, "Round Ended!")
        end

        self:EndRound()
    end
end

function GameService:StartRound()
    local PlayerService = Knit.GetService("PlayerService")
    local TimerService = Knit.GetService("TimerService")
    self.Timer = TimerService:CreateTimer(
        {
            Length = self.Round_Length,
            Callback = function()
                print("THE TIMER WORKS!")
            end,
            ShowGUI = true,
        })

    for _, Player: Player in pairs(Players:GetChildren()) do
        PlayerService:ChangeBattleState(Player, false, true)
    end

    self.Map = self:GenerateRandomMap()
    self.Map.Parent = workspace

    for _, Player: Player in pairs(Players:GetChildren()) do
        local HumanoidRootPart: Part = Player.Character:FindFirstChild("HumanoidRootPart")
        local Humanoid: Humanoid = Player.Character:FindFirstChild("Humanoid")

        HumanoidRootPart.CFrame = self.Map.Spawn.CFrame
        Humanoid.WalkSpeed = 50

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