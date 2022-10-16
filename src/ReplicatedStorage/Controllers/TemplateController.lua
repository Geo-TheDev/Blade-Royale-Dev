local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local TemplateController = Knit.CreateController { Name = "TemplateController" }


function TemplateController:KnitStart()
    print("Template controller started")
end


function TemplateController:KnitInit()
    print("Template controller initialized")
end

print("initial")

return TemplateController
