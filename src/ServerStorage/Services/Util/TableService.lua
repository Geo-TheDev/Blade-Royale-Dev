local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local TableService = Knit.CreateService {
    Name = "TableService",
    Client = {},
    TestTable = {"Test", 123, {Test = "Test", Test2 = "Test"}}
}

function TableService:ConvertToText(Data: table)
    for _, value in pairs(Data) do
        if typeof(value) == "number" then
            print(tostring(value))
        elseif typeof (value) == "table" then
            for index2, value2 in pairs(value) do
                print(index2 .. " : " .. value2)
            end
        else
            print(value)
        end
    end
end

return TableService
