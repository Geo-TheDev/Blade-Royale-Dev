local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local TemplateService = Knit.CreateService {
    Name = "TemplateService",
    Client = {},
}


function TemplateService:KnitStart()
    print("Template service started")
end


function TemplateService:KnitInit()
    print("Template service initialized")
end


return TemplateService
