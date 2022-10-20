local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Spring = require(script.Parent.Parent.Spring)
local Camera = workspace.CurrentCamera
local Knit = require(ReplicatedStorage.Packages.Knit)

local ConfirmationUI = {}

function ConfirmationUI.Init(UI, Args)
    local UIController = Knit.GetController("UIController")

    local Frame = UI.MainFrame
    local YesButton = Frame.Yes
    local NoButton = Frame.No
    local NoOutline = Frame.NoOutline
    local DescriptionText = Frame.Description

    DescriptionText.Text = Args.Text

    UIController:Blackout()

    Spring.target(Frame, 0.7, 4, { Position = UDim2.fromScale(0.5, 0.5) })
    Spring.target(Camera, 1, 4, { FieldOfView = 60 })

    YesButton.MouseButton1Click:Connect(function()
         UIController:UnloadUI("ConfirmationUI")
        Spring.target(Camera, 1, 4, { FieldOfView = 70 })
         UIController:RemoveBlackout()
         if Args.YesFunction then
            Args.YesFunction()
         else
            print("No YesFunction")
         end
    end)

    NoButton.MouseButton1Click:Connect(function()
         UIController:UnloadUI("ConfirmationUI")
        Spring.target(Camera, 1, 4, { FieldOfView = 70 })
         UIController:RemoveBlackout()
    end)

    local Connection = RunService.Heartbeat:Connect(function()
        NoOutline.Size = NoButton.Size
        NoOutline.Position = NoButton.Position
    end)

    Frame.Destroying:Connect(function()
        Connection:Disconnect()
    end)
end

return ConfirmationUI