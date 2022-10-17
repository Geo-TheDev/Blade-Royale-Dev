--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

--// Modules
local Packages = ReplicatedStorage.Packages
local Knit = require(Packages.Knit)
local ProfileService = require(script.Parent.ProfileService)

local ProfileStore = nil

local DataService = Knit.CreateService {
    Name = "DataService",
    Client = {
		GetSignal = Knit.CreateSignal(),
	},
    _DefaultData = {
        ["Wins"] = 0;
        ["Cash"] = 0;
        ["Swords"] = {};
        ["Equiped_Sword"] = "ClassicSword";
    },
    _Profiles = {},
}

function DataService:KnitInit()
    ProfileStore = ProfileService.GetProfileStore("PlayerData", self._DefaultData)

    Players.PlayerAdded:Connect(function(player)
        self:LoadData(player)
		local data = self._Profiles[player].Data
		self.Client.GetSignal:FireAll(data)
    end)

    Players.PlayerRemoving:Connect(function(player)
        self:ReleaseData(player)
    end)
end

function DataService:handleLockedUpdate(globalUpdates, update)
	local id = update[1]
	local data = update[2]
	globalUpdates:ClearLockedUpdate(id)
end

function DataService:LoadData(player: Player)
    local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
	
	if profile then
		profile:Reconcile()
		profile:ListenToRelease(function()
			self._Profiles[player] = nil
			player:Kick()
		end)
		
		if player:IsDescendantOf(Players) then
			self._Profiles[player] = profile
			
			local globalUpdates = profile.GlobalUpdates

			local activeCount = 0
			for index, update in pairs(globalUpdates:GetActiveUpdates()) do
				activeCount += 1
				globalUpdates:LockActiveUpdate(update[1])
			end
			print("Active updates on load: " .. activeCount)

			local lockedCount = 0
			for index, update in pairs(globalUpdates:GetLockedUpdates()) do
				lockedCount += 1
				self:handleLockedUpdate(globalUpdates, update)
			end
			print("Locked updates on load: " .. lockedCount)

			globalUpdates:ListenToNewActiveUpdate(function(id, data)
				print("Got new active update")
				globalUpdates:LockActiveUpdate(id)
			end)

			globalUpdates:ListenToNewLockedUpdate(function(id, data)
				print("Got new locked update")
				self:handleLockedUpdate(globalUpdates, {id, data})
			end)
		else
			profile:Release()
		end
	else
		player:Kick()
	end
end

function DataService:ReleaseData(player: Player)
	local profile = self._Profiles[player]
	if profile then
		profile:Reconcile()
		profile:Release()
	end
end

function DataService:Get(player: Player)
    print("Getting data for player: " .. player.Name)
    local profile = self._Profiles[player]
    if profile then
        return profile.Data
    end
end

function DataService.Client:Get(player: Player)
    print("getting data...")
    return self.Server:Get(player)
end

return DataService