local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

for _, v in pairs(ReplicatedStorage.Source:GetDescendants()) do
    if v:IsA("ModuleScript") and v.Name:match("Controller$") then
        require(v)
    end
end

Knit.Start():andThen(function()
    print("Knit Started | Client")
end):catch(warn):await()

for _, component in ipairs(ReplicatedStorage.Source:GetDescendants()) do
    if component:IsA("ModuleScript") and component.Name:match("Component$") then
        require(component)
    end
end