local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Knit = require(ReplicatedStorage.Packages.Knit)

local UI_MODULES = script.Parent.UIModules
local UI_FOLDER = script.Parent.UIFolder
local Spring = require(script.Parent.Spring)

local UIController = Knit.CreateController { Name = "UIController" }
local DataService

function UIController:KnitStart()
    self:LoadEssentialUI()
    DataService = Knit.GetService("DataService")
end

function UIController:LoadUI(UI_NAME: string, AdditionalArgs: table)
    local plrHasUI = self:findUIInPlayer(UI_NAME)

    if not plrHasUI then
        local UI = self:findUI(UI_NAME)
        local newUI = UI:Clone()
    
        newUI.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        local Init

        if AdditionalArgs ~= nil then
            Init = self:InitUI(UI_NAME, newUI, AdditionalArgs)
        else
            Init = self:InitUI(UI_NAME, newUI)
        end
        
        if Init ~= nil then
            print("Initialized " .. UI_NAME)
        end
        
        self:LoadUX(newUI)
        
        UI = nil
        Init = nil
    else
        warn("Player already has " .. UI_NAME .. " loaded.")
        warn(plrHasUI)
    end
end

function UIController:findUIInPlayer(UI_NAME: string)
    for _, v in pairs(Players.LocalPlayer:FindFirstChild("PlayerGui"):GetChildren()) do
        if v:IsA("ScreenGui") and v.Name == UI_NAME then
            return v
        end
    end
end

function UIController:LoadBillboardUI(UI_NAME, ADORNEE, PARENT)
    local UI = self:findBillboardUI(UI_NAME)
    local newUI = UI:Clone()
    newUI.Parent = PARENT
    newUI.Adornee = ADORNEE

    local Init = self:InitUI(UI_NAME, newUI)

    if Init ~= nil then
        print("Initialized " .. UI_NAME)
    end

    UI = nil
    Init = nil
end

function UIController:UnloadUI(UI_NAME)
    local UI = self:findUIInPlayer(UI_NAME)

    if UI ~= false then
        UI:Destroy()
    end
end

function UIController:InitUI(UI_NAME, UI_OBJECT, AdditionalArgs)
    local Modules = {}

    for _, v in pairs(UI_MODULES:GetChildren()) do
        if v:IsA("ModuleScript") and v.Name == UI_NAME then
            table.insert(Modules, v)
        end
    end

    if #Modules ~= 0 then
        for _, v in pairs(UI_MODULES:GetChildren()) do
            if v:IsA("ModuleScript") and v.Name == UI_NAME then
                if AdditionalArgs ~= nil then
                    require(v).Init(UI_OBJECT, AdditionalArgs)
                else
                    require(v).Init(UI_OBJECT)
                end
            end
        end
    end
end

function UIController:findUI(UI_NAME)
    for _, v in pairs(UI_FOLDER:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name == UI_NAME then
            return v
        end
    end
end

function UIController:findBillboardUI(UI_NAME)
    for _, v in pairs(UI_FOLDER:GetChildren()) do
        if v:IsA("BillboardGui") and v.Name == UI_NAME then
            return v
        end
    end
end

function UIController:LoadUIBillboardServer(UI_NAME)
    local UI = self:findBillboardUI(UI_NAME)

    return UI
end

function UIController:SetAdorrne(UI_Name, Adornee)
    local UI = self:findBillboardUI(UI_Name)

    if UI then
        UI.Adornee = Adornee
    end
end

function UIController:Blackout()
    local UI = self:findUIInPlayer("Blackout")

    Spring.target(UI.Frame, 1, 4, {
        Transparency = 0.5
    })
end

function UIController:RemoveBlackout()
    local UI = self:findUIInPlayer("Blackout")

    Spring.target(UI.Frame, 1, 4, {
        Transparency = 1
    })
end

function UIController:InitConfirmation(AdditionalArgs)
    local plrHasUI = self:findUIInPlayer("ConfirmationUI")

    if not plrHasUI then
        local UI = self:findUI("ConfirmationUI")
        local newUI = UI:Clone()
    
        newUI.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

        if AdditionalArgs ~= nil then
            local Init
            Init = self:InitUI("ConfirmationUI", newUI, AdditionalArgs)

            if Init ~= nil then
                print("Initialized " .. "ConfirmationUI")
            end
            
            self:LoadUX(newUI)
            
            UI = nil
            Init = nil
        else
            warn("'AdditionalArgs' has not been passed through.")
        end
    else
        warn("Player already has " .. "ConfirmationUI" .. " loaded.")
        warn(plrHasUI)
    end
end

function UIController:LoadUX(UI_OBJECT)
    for _, obj in pairs(UI_OBJECT:GetDescendants()) do
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            if obj:GetAttribute("UXEnabled") == true then
                obj.MouseEnter:Connect(function()
                    Spring.target(obj, 0.5, 6, { Size = UDim2.fromScale(obj:GetAttribute("Hover").X.Scale, obj:GetAttribute("Hover").Y.Scale) })
                    SoundService.Button_Hover:Play()
                end)

                obj.MouseLeave:Connect(function()
                    Spring.target(obj, 0.5, 6, { Size = UDim2.fromScale(obj:GetAttribute("Origin").X.Scale, obj:GetAttribute("Origin").Y.Scale) })
                end)
    
                obj.MouseButton1Down:Connect(function()
                    Spring.target(obj, 0.5, 7, { Size = UDim2.fromScale(obj:GetAttribute("Min").X.Scale, obj:GetAttribute("Min").Y.Scale) })
                    SoundService.Button_Click:Play()
                end)
    
                obj.MouseButton1Up:Connect(function()
                    Spring.target(obj, 0.5, 7, { Size = UDim2.fromScale(obj:GetAttribute("Hover").X.Scale, obj:GetAttribute("Hover").Y.Scale) })
                end)
            end
        end
    end
end

function UIController:LoadEssentialUI()
    repeat
        task.wait()
    until Players.LocalPlayer.PlayerGui

    self:LoadUI("Blackout")

    -- task.delay(5, function()
    --     print("loading UI")
    --     self:InitConfirmation({
    --         Text = "Welcome to the game! You have",
    --         YesFunction = function()
    --             print("HE PRESSED IT YES!")
    --         end
    --     })
    -- end)
    -- Confirmation Test
end

return UIController