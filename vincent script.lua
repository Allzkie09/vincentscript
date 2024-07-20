--// discord.gg/visualontop

local Stats = game:GetService('Stats')

local Players = game:GetService('Players')

local RunService = game:GetService('RunService')

local ReplicatedStorage = game:GetService('ReplicatedStorage')

local TweenService = game:GetService('TweenService')

local Nurysium_Util = loadstring(game:HttpGet('https://raw.githubusercontent.com/flezzpe/Nurysium/main/nurysium_helper.lua'))()

local local_player = Players.LocalPlayer

local camera = workspace.CurrentCamera

local nurysium_Data = nil

local hit_Sound = nil

local closest_Entity = nil

local parry_remote = nil

getgenv().aura_Enabled = false

getgenv().hit_sound_Enabled = false

getgenv().hit_effect_Enabled = false

getgenv().night_mode_Enabled = false

getgenv().trail_Enabled = false

getgenv().self_effect_Enabled = false

getgenv().kill_effect_Enabled = false

getgenv().shaders_effect_Enabled = false

getgenv().ai_Enabled = false

getgenv().spectate_Enabled = false

local Services = {

	game:GetService('AdService'),

	game:GetService('SocialService')

}

function SwordCrateManual()

game:GetService("ReplicatedStorage").Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalSwordCrate)

end

function ExplosionCrateManual()

game:GetService("ReplicatedStorage").Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalExplosionCrate)

end

function SwordCrateAuto()

while _G.AutoSword do

game:GetService("ReplicatedStorage").Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalSwordCrate)

wait(1)

end

end

function ExplosionCrateAuto()

while _G.AutoBoom do

game:GetService("ReplicatedStorage").Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", workspace.Spawn.Crates.NormalExplosionCrate)

wait(1)

end

end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Triple Hub",
    SubTitle = "by triple",
    TabWidth = 180,
    Size = UDim2.fromOffset(450, 225),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl -- Used when theres no MinimizeKeybind
})

local Tabs = {
    Main = Window:AddTab({ Title = "Parry", Icon = "shield" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "component" }),
    Music = Window:AddTab({ Title = "Music", Icon = "music" }),
    Credits = Window:AddTab({ Title = "Credits", Icon = "copyright" })
}

local Options = Fluent.Options

--functions
function initializate(dataFolder_name: string)

    local nurysium_Data = Instance.new('Folder', game:GetService('CoreGui'))

    nurysium_Data.Name = dataFolder_name

    hit_Sound = Instance.new('Sound', nurysium_Data)

    hit_Sound.SoundId = 'rbxassetid://8632670510'

    hit_Sound.Volume = 5

end

local function get_closest_entity(Object: Part)

    task.spawn(function()

        local closest

        local max_distance = math.huge

        for index, entity in workspace.Alive:GetChildren() do

            if entity.Name ~= Players.LocalPlayer.Name then

                local distance = (Object.Position - entity.HumanoidRootPart.Position).Magnitude

                if distance < max_distance then

                    closest_Entity = entity

                    max_distance = distance

                end

            end

        end

        return closest_Entity

    end)

end

function resolve_parry_Remote()

    for _, value in Services do

        local temp_remote = value:FindFirstChildOfClass('RemoteEvent')

        if not temp_remote then

            continue

        end

        if not temp_remote.Name:find('\n') then

            continue

        end

        parry_remote = temp_remote

    end

end

local aura_table = {

    canParry = true,

    is_Spamming = false,

    parry_Range = 0,

    spam_Range = 0,  

    hit_Count = 0,

    hit_Time = tick(),

    ball_Warping = tick(),

    is_ball_Warping = false

}

ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()

    if getgenv().hit_sound_Enabled then

        hit_Sound:Play()

    end

    if getgenv().hit_effect_Enabled then

        local hit_effect = game:GetObjects("rbxassetid://17407244385")[1]

        hit_effect.Parent = Nurysium_Util.getBall()

        hit_effect:Emit(3)

        

        task.delay(5, function()

            hit_effect:Destroy()

        end)

    end

end)

ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function()

    aura_table.hit_Count += 1

    task.delay(0.15, function()

        aura_table.hit_Count -= 1

    end)

end)

workspace:WaitForChild("Balls").ChildRemoved:Connect(function(child)

    aura_table.hit_Count = 0

    aura_table.is_ball_Warping = false

    aura_table.is_Spamming = false

end)

--start, the real one
local Mainy = Tabs.Main:AddSection("Parry")

Mainy:AddParagraph({
        Title = "NEWS",
        Content = "we fixed it."
    })

local Toggle = Mainy:AddToggle("Ping Based Parry", {Title = "Auto parry ", Default = false })
Toggle:OnChanged(function(toggled)

   resolve_parry_Remote()

    getgenv().aura_Enabled = toggled
    
end)
	
local Toggle = Mainy:AddToggle("Hit Sound", {Title = "Hit sound", Default = false })
Toggle:OnChanged(function(toggled)

    getgenv().hit_sound_Enabled = toggled
    
end)

local Toggle = Mainy:AddToggle("hit effect", {Title = "hit effect", Default = false })
Toggle:OnChanged(function(toggled)

    getgenv().hit_effect_Enabled = toggled
    
end)

local Money = Tabs.Main:AddSection("Features")

Money:AddButton({
        Title = "Open Sword Crate",
        Description = "will open one common sword crate",
        Callback = function()
        
            SwordCrateManual()
            
        end
    })
    
Money:AddButton({
        Title = "Open Explosion Crate",
        Description = "will open one common explosion crate",
        Callback = function()
        
            ExplosionCrateManual()
            
        end
    })
    
--misc
local Misc = Tabs.Misc:AddSection("Misc")

local Toggle = Misc:AddToggle("Night mode", {Title = "night mode ", Default = false })
Toggle:OnChanged(function(toggled)

    getgenv().night_mode_Enabled = toggled
    
end)
   
local Toggle = Misc:AddToggle("Trail", {Title = "Trail ", Default = false })
Toggle:OnChanged(function(toggled)

    getgenv().trail_Enabled = toggled
    
end)

local Toggle = Misc:AddToggle("Spectate Ball", {Title = "Spectate Ball", Default = false })
Toggle:OnChanged(function(toggled)

    getgenv().spectate_Enabled = toggled
    
end)

Misc:AddButton({
        Title = "Mobile Keyboard",
        Description = "launches a GUI that mimics a Keyboard.",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/advxzivhsjjdhxhsidifvsh/mobkeyboard/main/main.txt", true))()
        end
    })

Misc:AddButton({
        Title = "Tracers",
        Description = "Trace people",
        Callback = function()
loadstring(game:HttpGet("https://pastebin.com/raw/vWxn47BC"))()
  print("Hi")
        end
    })

Misc:AddButton({
        Title = "Arrow ESP",
        Description = "Esp",
        Callback = function()
            loadstring(game:HttpGet("https://pastebin.com/raw/C7Gafsbr"))()
  print("Hellow")
        end
    })

Misc:AddButton({
        Title = "Name ESP",
        Description = "Esp",
        Callback = function()
            loadstring(game:HttpGet("https://pastebin.com/raw/SjyEEE92"))()
  print("xd")
        end
    })
Misc:AddButton({
        Title = "Radar+Green circle parry",
        Description = "Combo features",
        Callback = function()
loadstring(game:HttpGet("https//raw.githubusercontent.com/k00pz/Fsploitrady/main/Hi"))()
  print("hi")
end
    })
Misc:AddButton({
        Title = "TP to players",
        Description = "Use this to Teleport to players",
        Callback = function()
            loadstring(game:HttpGet("https://gist.githubusercontent.com/DagerFild/b4776075a0d26ef04394133ee6bd2081/raw/0ed51ac94057d2d9a9f00e1b037b9011c76ca54a/tpGUI", true))()
        end
  })
Misc:AddButton({
        Title = "Rejoin",
        Description = "Use this to Rejoin the server",
        Callback = function()
          local ts = game:GetService("TeleportService")
				local p = game:GetService("Players").LocalPlayer
				ts:Teleport(game.PlaceId, p)
    print("Clicked!")
        end
  })
local Slider = Misc:AddSlider("Slider", {
        Title = "Walk speed",
        Description = "Use this to change your walk speed",
        Default = 21,
        Min = 0,
        Max = 500,
        Rounding = 1,
        Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
print("Hi")
        end
    })
  local Slider = Misc:AddSlider("Slider", {
        Title = "Jump power",
        Description = "Use this to change your jump power",
        Default = 40,
        Min = 0,
        Max = 500,
        Rounding = 1,
        Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
print("Hi")
        end
    })
  local Slider = Misc:AddSlider("Slider", {
        Title = "FOV",
        Description = "Use this to change your FOV",
        Default = 70,
        Min = 0,
        Max = 500,
        Rounding = 1,
        Callback = function(Value)
            local FovNumber = Value
local Camera = workspace.CurrentCamera
Camera.FieldOfView = FovNumber
print("Hi")
        end
    })
  local Slider = Misc:AddSlider("Slider", {
        Title = "Gravity",
        Description = "Use this to change your Gravity",
        Default = 197,
        Min = 0,
        Max = 500,
        Rounding = 1,
        Callback = function(Value)
            workspace.Gravity = Value
print("Hi")
        end
    })
Misc:AddButton({
        Title = "Fly",
        Description = "Use this to Fly",
        Callback = function()
          loadstring(game:HttpGet('https://raw.githubusercontent.com/k00pz/Flying/main/Fly-gui'))()
        end
  })
Misc:AddButton({
        Title = "Infinite jump",
        Description = "Use this to get Infinite jump",
        Callback = function()
          local InfiniteJumpEnabled = true
game:GetService("UserInputService").JumpRequest:connect(function()
    if InfiniteJumpEnabled then
        game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
    end
end)
          print("Hydrogen")
          end
    })
Misc:AddButton({
        Title = "FPS boost",
        Description = "Use this to boost your fps",
        Callback = function()
          loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fps-booster-9504"))()
  print("Fluxus")
        end
  })
  
-- music
Tabs.Music:AddButton({
        Title = "Its Raining tacos",
        Description = "Tacos",
        Callback = function()
          local Sound = Instance.new("Sound",game:GetService("SoundService"))
Sound.SoundId = "rbxassetid://142376088"
Sound:Play()
        end
})
  Tabs.Music:AddButton({
        Title = "Freak",
        Description = "I m just a freak!",
        Callback = function()
          local Sound = Instance.new("Sound",game:GetService("SoundService"))
Sound.SoundId = "rbxassetid://6703926669"
Sound:Play()
        end
})
  Tabs.Music:AddButton({
        Title = "Rave crab",
        Description = "🦀",
        Callback = function()
          local Sound = Instance.new("Sound",game:GetService("SoundService"))
Sound.SoundId = "rbxassetid://5410086218"
Sound:Play()
        end
})
  Tabs.Music:AddButton({
        Title = "Brookenly blood pop",
        Description = "Blood",
        Callback = function()
          local Sound = Instance.new("Sound",game:GetService("SoundService"))
Sound.SoundId = "rbxassetid://6783714255"
Sound:Play()
        end
})
  Tabs.Music:AddButton({
        Title = "Stronger",
        Description = "💪",
        Callback = function()
          local Sound = Instance.new("Sound",game:GetService("SoundService"))
Sound.SoundId = "rbxassetid://136209425"
Sound:Play()
        end
})

--credits
local Credits = Tabs.Credits:AddSection("Credits")

Credits:AddParagraph({
        Title = "Credits",
        Content = "Script was made by triple"
    })

Credits:AddParagraph({
        Title = "triple",
        Content = "Made by Triple or itsborg. on discord"
    })

Credits:AddButton({
        Title = "Discord Server",
        Description = "own server",
        Callback = function()
        
setclipboard("https://discord.com/invite/QydDGkca")  
        end
    })
    
local Showcase = Tabs.Credits:AddSection("Awesome Showcasers")

Showcase:AddParagraph({
        Title = "Youtuber",
        Content = "Đạt Mod, Ley D Murphy, r4mpage and More "
    })
    
    print("Idk©")
    
task.defer(function()

    game:GetService("RunService").Heartbeat:Connect(function()

        if not local_player.Character then

            return

        end

        if getgenv().trail_Enabled then

            local trail = game:GetObjects("rbxassetid://17483658369")[1]

            trail.Name = 'nurysium_fx'

            if local_player.Character.PrimaryPart:FindFirstChild('nurysium_fx') then

                return

            end

            local Attachment0 = Instance.new("Attachment", local_player.Character.PrimaryPart)

            local Attachment1 = Instance.new("Attachment", local_player.Character.PrimaryPart)

            Attachment0.Position = Vector3.new(0, -2.411, 0)

            Attachment1.Position = Vector3.new(0, 2.504, 0)

            trail.Parent = local_player.Character.PrimaryPart

            trail.Attachment0 = Attachment0

            trail.Attachment1 = Attachment1

        else

            

            if local_player.Character.PrimaryPart:FindFirstChild('nurysium_fx') then

                local_player.Character.PrimaryPart['nurysium_fx']:Destroy()

            end

        end

    end)

end)

task.defer(function()

    RunService.RenderStepped:Connect(function()

        if getgenv().spectate_Enabled then

            local self = Nurysium_Util.getBall()

            if not self then

                return

            end

            workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.new(workspace.CurrentCamera.CFrame.Position, self.Position), 1.5)

        end

    end)

end)

task.defer(function()

    while task.wait(1) do

        if getgenv().night_mode_Enabled then

            game:GetService("TweenService"):Create(game:GetService("Lighting"), TweenInfo.new(3), {ClockTime = 3.9}):Play()

        else

            game:GetService("TweenService"):Create(game:GetService("Lighting"), TweenInfo.new(3), {ClockTime = 13.5}):Play()

        end

    end

end)

task.spawn(function()

    RunService.PreRender:Connect(function()

        if not getgenv().aura_Enabled then

            return

        end

        if closest_Entity then

            if workspace.Alive:FindFirstChild(closest_Entity.Name) and workspace.Alive:FindFirstChild(closest_Entity.Name).Humanoid.Health > 0 then

                if aura_table.is_Spamming then

                    if local_player:DistanceFromCharacter(closest_Entity.HumanoidRootPart.Position) <= aura_table.spam_Range then   

                        parry_remote:FireServer(

                            0.5,

                            CFrame.new(camera.CFrame.Position, Vector3.zero),

                            {[closest_Entity.Name] = closest_Entity.HumanoidRootPart.Position},

                            {closest_Entity.HumanoidRootPart.Position.X, closest_Entity.HumanoidRootPart.Position.Y},

                            false

                        )

                    end

                end

            end

        end

    end)

    RunService.Heartbeat:Connect(function()

        if not getgenv().aura_Enabled then

            return

        end

        local ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue() / 10

        local self = Nurysium_Util.getBall()

        if not self then

            return

        end

        self:GetAttributeChangedSignal('target'):Once(function()

            aura_table.canParry = true

        end)

        if self:GetAttribute('target') ~= local_player.Name or not aura_table.canParry then

            return

        end

        get_closest_entity(local_player.Character.PrimaryPart)

        local player_Position = local_player.Character.PrimaryPart.Position

        local ball_Position = self.Position

        local ball_Velocity = self.AssemblyLinearVelocity

        if self:FindFirstChild('zoomies') then

            ball_Velocity = self.zoomies.VectorVelocity

        end

        local ball_Direction = (local_player.Character.PrimaryPart.Position - ball_Position).Unit

        local ball_Distance = local_player:DistanceFromCharacter(ball_Position)

        local ball_Dot = ball_Direction:Dot(ball_Velocity.Unit)

        local ball_Speed = ball_Velocity.Magnitude

        local ball_speed_Limited = math.min(ball_Speed / 1000, 0.1)

        local ball_predicted_Distance = (ball_Distance - ping / 15.5) - (ball_Speed / 3.5)

        local target_Position = closest_Entity.HumanoidRootPart.Position

        local target_Distance = local_player:DistanceFromCharacter(target_Position)

        local target_distance_Limited = math.min(target_Distance / 10000, 0.1)

        local target_Direction = (local_player.Character.PrimaryPart.Position - closest_Entity.HumanoidRootPart.Position).Unit

        local target_Velocity = closest_Entity.HumanoidRootPart.AssemblyLinearVelocity

        local target_isMoving = target_Velocity.Magnitude > 0

        local target_Dot = target_isMoving and math.max(target_Direction:Dot(target_Velocity.Unit), 0)

        aura_table.spam_Range = math.max(ping / 10, 15) + ball_Speed / 7

        aura_table.parry_Range = math.max(math.max(ping, 5) + ball_Speed / 3.5, 9.5)

        aura_table.is_Spamming = aura_table.hit_Count > 1000 or ball_Distance < 10.5
        
        aura_table.is_Spamming = aura_table.hit_Count > 1000 or ball_Distance < 10.5

        aura_table.is_Spamming = aura_table.hit_Count > 1000 or ball_Distance < 10.5

        aura_table.is_Spamming = aura_table.hit_Count > 1000 or ball_Distance < 10.5

        aura_table.is_Spamming = aura_table.hit_Count > 1000 or ball_Distance < 10.5

        aura_table.is_Spamming = aura_table.hit_Count > 1000 or ball_Distance < 10.5

        aura_table.is_Spamming = aura_table.hit_Count > 1000 or ball_Distance < 10.5

        aura_table.is_Spamming = aura_table.hit_Count > 1000 or ball_Distance < 10.5

        aura_table.is_Spamming = aura_table.hit_Count > 1000 or ball_Distance < 10.5

        aura_table.is_Spamming = aura_table.hit_Count > 1000 or ball_Distance < 10.5

        aura_table.is_Spamming = aura_table.hit_Count > 1000 or ball_Distance < 10.5

        aura_table.is_Spamming = aura_table.hit_Count > 1000 or ball_Distance < 10.5

        aura_table.is_Spamming = aura_table.hit_Count > 1000 or ball_Distance < 10.5

        aura_table.is_Spamming = aura_table.hit_Count > 1000 or ball_Distance < 10.5

        aura_table.is_Spamming = aura_table.hit_Count > 1000 or ball_Distance < 10.5

        aura_table.is_Spamming = aura_table.hit_Count > 1000 or ball_Distance < 10.5

        aura_table.is_Spamming = aura_table.hit_Count > 1000 or ball_Distance < 10.5

        aura_table.is_Spamming = aura_table.hit_Count > 1000 or ball_Distance < 10.5

        aura_table.is_Spamming = aura_table.hit_Count > 1000 or ball_Distance < 10.5

        aura_table.is_Spamming = aura_table.hit_Count > 1000 or ball_Distance < 10.5

        aura_table.is_Spamming = aura_table.hit_Count > 1000 or ball_Distance < 10.5

        aura_table.is_Spamming = aura_table.hit_Count > 1000 or ball_Distance < 10.5

        if ball_Dot < -0.2 then

            aura_table.ball_Warping = tick()

        end

				local a = game:GetService("VirtualInputManager")
local b = game:GetService("RunService")
local c = game:GetService("Players").LocalPlayer
local d = loadstring(game:HttpGet("https://raw.githubusercontent.com/DenDenZYT/DenDenZ-s-Open-Source-Collection/main/Component"))() 

local e = false

spawn(function()
    b.PreRender:Connect(function()
        if not getgenv().f then return end

        local g = d.FindTargetBall()
        if not g then return end

        local h = g.AssemblyLinearVelocity
        if g:FindFirstChild('zoomies') then 
            h = g.zoomies.VectorVelocity
        end

        local i = g.Position
        local j = c.Character.PrimaryPart.Position
        local k = (j - i).Unit
        local l = c:DistanceFromCharacter(i)
        local m = k:Dot(h.Unit)
        local n = h.Magnitude

        if m > 0 then
            local o = l - 5
            local p = o / n

            if d.IsPlayerTarget(g) and p <= 0.35 and not e then
                a:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                wait(0.01)
                e = true
            end

        task.spawn(function()

            if (tick() - aura_table.ball_Warping) >= 0.15 + target_distance_Limited - ball_speed_Limited or ball_Distance <= 10 then

                aura_table.is_ball_Warping = false

                return

            end

            aura_table.is_ball_Warping = true

        end)

        if ball_Distance <= aura_table.parry_Range and not aura_table.is_Spamming and not aura_table.is_ball_Warping then

            parry_remote:FireServer(

                0.5,

                CFrame.new(camera.CFrame.Position, Vector3.new(math.random(0, 100), math.random(0, 1000), math.random(100, 1000))),

                {[closest_Entity.Name] = target_Position},

                {target_Position.X, target_Position.Y},

                false

            )

            aura_table.canParry = false

            aura_table.hit_Time = tick()

            aura_table.hit_Count += 1

            task.delay(0.15, function()

                aura_table.hit_Count -= 1

            end)

        end

        task.spawn(function()

            repeat

                RunService.Heartbeat:Wait()

            until (tick() - aura_table.hit_Time) >= 1

                aura_table.canParry = true

        end)

    end)

end)

initializate('nurysium_temp')
