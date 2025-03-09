local Loader = {
	MMID = 16112788132,
	
	RemoveCharacterScript = true,
	TeleportCharacterFar = false,

	GoodUserInputType = {
		"MouseButton1",
		"MouseButton2",
		"MouseButton3"
	}
}

---// services
local Players 				= game:GetService("Players")
local TweenService 			= game:GetService("TweenService")
local Debris 					= game:GetService("Debris")
local SoundService			= game:GetService("SoundService")

---// variables
--// important
local foreach,owner_,LoadA,NewLS_		= table.foreach,owner,LoadAssets,NewLocalScript
local ScriptRunner  				= Players:WaitForChild(owner_.Name)

local Client = {
	Player = ScriptRunner,
	GUI = ScriptRunner.PlayerGui,

	Character = ScriptRunner.Character,

	CharacterHealth  = ScriptRunner.Character:FindFirstChild("Health"),
	CharacterAnimate = ScriptRunner.Character:WaitForChild("Animate"),
	HumanoidAnimator = ScriptRunner.Character:WaitForChild("Humanoid"):WaitForChild("Animator"),

	Name = ScriptRunner.Name,
	UserID = ScriptRunner.UserId
}

local ImportantFunctions = {
	ScriptOutput = function(Text : string | number , Print : boolean)
		if Print == true then
			print(tostring(Client.Name .. "'s DEBUG -> " .. Text))
		else
			warn(tostring(Client.Name .. "'s DEBUG -> " .. Text))
		end
	end,

	ScriptNamer = function(Name : string , Parent, ScriptCreatorUID : number | string ,ScriptName : string)
		local ScriptCreator
		local ScriptParent

		if ScriptCreatorUID ~= "unknown" then
			ScriptCreator = tostring(Players:GetNameFromUserIdAsync(tonumber(ScriptCreatorUID)))	 
		else
			ScriptCreator = "Unknown."
		end

		if Parent.Name == Client.Name then
			ScriptParent = Client.Name .. " - Player Character"
		else
			ScriptParent = Parent.Name
		end

		script.Parent = Parent
		script.Name = tostring(Name)

		warn("<<--------{ " .. tostring(ScriptName) .. " }-------->>")
		warn("Script by : '" .. tostring(ScriptCreator) .. "'!")
		warn("Script ClassName : '" .. script.ClassName .. "'")
		warn("Script Parent : '" .. tostring(ScriptParent) .. "'")
		warn("Convert Version : DEBUG.")
		warn("Convert Finished on : nil/nil/2024.")
		warn("<<----{ converted by rbxlxss }---->>")
	end,
}

------/// SOME SCRIPT

pcall(function()
	ImportantFunctions.ScriptNamer("kdbanisher_ong" , Client.GUI , "2914834497" , "KD's Banisher")

	if Loader.RemoveCharacterScript == true then
		if Client.CharacterHealth then Client.CharacterHealth:Destroy() end
		if Client.CharacterAnimate then Client.CharacterAnimate:Destroy() end
		if Client.HumanoidAnimator then Client.HumanoidAnimator:Destroy() end
	end

	if Loader.TeleportCharacterFar == true then
		Client.Character.PrimaryPart.CFrame = CFrame.new(Random.new():NextNumber(999_999,999_999_999) , Random.new():NextNumber(999_999,999_999_999) , Random.new():NextNumber(999_999,999_999_999))
		Client.Character.PrimaryPart.Anchored = true

		for index , BasePart in pairs(Client.Character:GetChildren()) do
			if BasePart:IsA("Accessory") then
				BasePart:Destroy()
			end

			if BasePart:IsA("BasePart") then
				BasePart.Transparency = 1
				BasePart.Anchored = true
			end
		end
	end
end)

local UserInputRE,MouseInputRE,CameraInputRE = Instance.new("RemoteEvent"),Instance.new("RemoteEvent"),Instance.new("RemoteEvent")
UserInputRE.Name,UserInputRE.Parent = "UserInputRemoteEvent" , script
MouseInputRE.Name,MouseInputRE.Parent = "MouseInputRemoteEvent" , script
CameraInputRE.Name,CameraInputRE.Parent = "CameraInputRemoteEvent" , script

repeat task.wait() until UserInputRE ~= nil and MouseInputRE ~= nil and CameraInputRE ~= nil

local CameraCF

---// KEYBOARD SS
do
	local FakeEvent = function()
		local FE_Table = {
			_FakeEvent = true,

			Connect = function(self , func)
				self.Function = func
			end,

			connect = function(self , func)
				self.Function = func
			end,
		}

		return FE_Table
	end

	local Fake_UserInputService = {
		InputBegan = FakeEvent() , 
		InputEnded = FakeEvent()
	}

	local function TriggerEventFunction(self,ev,...)
		local t = Fake_UserInputService[ev]
		if t and t._FakeEvent and t.Function then
			t.Function(...)
		end
	end

	Fake_UserInputService.TriggerEvent = TriggerEventFunction
	UserInputRE.OnServerEvent:Connect(function(Player , InputObject)
		if Player~=Client.Player then return end

		if InputObject.UserInputState == Enum.UserInputState.Begin then
			Fake_UserInputService:TriggerEvent("InputBegan",InputObject,false)
		else
			Fake_UserInputService:TriggerEvent("InputEnded",InputObject,false)
		end

	end)

	UserInputService = Fake_UserInputService
end
---// KEYBOARD LS
local KeyboardInputNLS = NewLS_([[
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Client = Players.LocalPlayer
local ClientCharacter = Client.Character

local UserInputRE = Client.PlayerGui:WaitForChild("kdbanisher_ong"):WaitForChild("UserInputRemoteEvent")

repeat task.wait() until UserInputRE ~= nil

local InputFunction = function(InputObject,GPE)
	if GPE then return end

	local FakeInputObject = {
		KeyCode=InputObject.KeyCode,
		UserInputType=InputObject.UserInputType,
		UserInputState=InputObject.UserInputState
	}

	UserInputRE:FireServer(FakeInputObject)
end

UserInputService.InputBegan:Connect(InputFunction)
UserInputService.InputEnded:Connect(InputFunction)
]],Client.GUI)
---// MOUSE SS
do
	local Fake_Mouse = {
		Target=nil,
		Hit=CFrame.new()
	}


	MouseInputRE.OnServerEvent:Connect(function(Player , InputObject)
		if Player~=Client.Player then return end

		if InputObject.isMouse then
			Fake_Mouse.Target = InputObject.Target
			Fake_Mouse.Hit = InputObject.Hit
		end
	end)

	Mouse = Fake_Mouse
end
---// MOUSE LS
local MouseInputNLS = NewLS_([[
local Players = game:GetService("Players")

local Client = Players.LocalPlayer

local ClientMouse = Client:GetMouse()
local MouseHit , MouseTarget = ClientMouse.Hit , ClientMouse.Target

local MouseInputRE = Client.PlayerGui:WaitForChild("kdbanisher_ong"):WaitForChild("MouseInputRemoteEvent")

repeat task.wait() until MouseInputRE ~= nil

while task.wait(1/30) do
	if MouseHit~=ClientMouse.Hit or MouseTarget~=ClientMouse.Target then

		local MouseStuff = {
			isMouse = true,
			Target  = ClientMouse.Target,
			Hit = ClientMouse.Hit
		}

		MouseInputRE:FireServer(MouseStuff)

		MouseHit , MouseTarget = ClientMouse.Hit , ClientMouse.Target
	end
end
]],Client.GUI)
---// CAMERA SS
do
	local Fake_Camera = {
		CameraCF=CFrame.new()
	}

	CameraInputRE.OnServerEvent:Connect(function(Player , InputObject)
		if Player~=Client.Player then return end

		Fake_Camera.CameraCF = InputObject.CameraCF
	end)

	CurrentCamera = Fake_Camera
end
---// CAMERA LS
local CameraInputNLS = NewLS_([[
local Players = game:GetService("Players")

local ChangeCameraSubject = false

local Client = Players.LocalPlayer

local ClientCamera = workspace.CurrentCamera
local CameraCF

local CameraInputRE = Client.PlayerGui:WaitForChild("kdbanisher_ong"):WaitForChild("CameraInputRemoteEvent")

repeat task.wait() until CameraInputRE ~= nil

if ChangeCameraSubject == true then
	local CameraSubject = "NOTHING LAWL"
	
	task.spawn(function()
		while task.wait(1/30) do
			ClientCamera.CameraSubject = workspace:FindFirstChild(CameraSubject) and workspace:FindFirstChild(CameraSubject) or Client.Character:FindFirstChild("Humanoid")
		end
	end)
end


while task.wait(1/30) do

	local CameraStuff = {
		CameraCF = ClientCamera.CFrame
	}

	CameraInputRE:FireServer(CameraStuff)

	CameraCF = ClientCamera.CFrame
end
]],Client.GUI)

pcall(function() 
	KeyboardInputNLS.Name = "KeyboardInputScript - LS" 
	MouseInputNLS.Name = "MouseInputScript - LS" 
	CameraInputNLS.Name = "CameraInputScript - LS"
end)
---// INPUT END

task.wait(1/69)

----// SCRIPT START
local MainModule = LoadA(Loader.MMID)
local _SSR = MainModule:Get("Starslayer Railgun")

local StartUpMusic = 9495950488

local BOOMBOX = false
local BILLBOARD = true


mode = 1
atk = false

IT = Instance.new
CF = CFrame.new
VT = Vector3.new
RAD = math.rad
C3 = Color3.new
UD2 = UDim2.new
BRICKC = BrickColor.new
ANGLES = CFrame.Angles
EULER = CFrame.fromEulerAnglesXYZ
COS = math.cos
ACOS = math.acos
SIN = math.sin
ASIN = math.asin
ABS = math.abs
MRANDOM = math.random
FLOOR = math.floor

speed = 1
sine = 1
srv = game:GetService('RunService')

reanim = Client.Character
RJ = reanim.HumanoidRootPart.RootJoint
RS = reanim.Torso['Right Shoulder']
LS = reanim.Torso['Left Shoulder']
RH = reanim.Torso['Right Hip']
LH = reanim.Torso['Left Hip']
Root = reanim.HumanoidRootPart
NECK = reanim.Torso.Neck
NECK.C0 = CF(0,1,0)*ANGLES(RAD(0),RAD(0),RAD(0))
NECK.C1 = CF(0,-0.5,0)*ANGLES(RAD(0),RAD(0),RAD(0))
RJ.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
RJ.C0 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
RS.C1 = CF(-0.5,0.5,0)*ANGLES(RAD(0),RAD(0),RAD(0))
LS.C1 = CF(0.5,0.5,0)*ANGLES(RAD(0),RAD(0),RAD(0))
RH.C1 = CF(0,1,0)*ANGLES(RAD(0),RAD(0),RAD(0))
LH.C1 = CF(0,1,0)*ANGLES(RAD(0),RAD(0),RAD(0))
RH.C0 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
LH.C0 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
RS.C0 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
LS.C0 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))

hum = reanim.Humanoid

hum:AddAccessory(_SSR)

for index, value in pairs(reanim["Starslayer Railgun"]:GetDescendants()) do
	print(value.Name , value.ClassName)
end

hum.WalkSpeed = 30
change = 0.7
movement = 13

local BillboardGui = Instance.new("BillboardGui", reanim.Head)
local Form = Instance.new("TextLabel")
local Frame = Instance.new("Frame")
local Bar1 = Instance.new("Frame")
local Bar2 = Instance.new("Frame")
local Bar3 = Instance.new("Frame")
local Bar6 = Instance.new("Frame")
local Bar7 = Instance.new("Frame")
local Bar8 = Instance.new("Frame")
local Title = Instance.new("TextLabel")

BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
BillboardGui.Active = true
BillboardGui.AlwaysOnTop = true
BillboardGui.LightInfluence = 1.000
BillboardGui.Size = UDim2.new(0, 500, 0, 1000)

Form.Name = "Form"
Form.Parent = BillboardGui
Form.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Form.BackgroundTransparency = 1.000
Form.BorderColor3 = Color3.fromRGB(255, 255, 255)
Form.Position = UDim2.new(0.194999993, 0, 0.340000004, 0)
Form.Selectable = true
Form.Size = UDim2.new(0, 285, 0, 50)
Form.Font = Enum.Font.Gotham
Form.TextColor3 = Color3.fromRGB(0, 0, 0)
Form.TextScaled = true
Form.TextSize = 14.000
Form.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
Form.TextStrokeTransparency = 0.000
Form.TextWrapped = true
Form.Text = "Kayden's Banisher"

Frame.Parent = BillboardGui
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.Position = UDim2.new(0.129999995, 0, 0.400000006, 0)
Frame.Size = UDim2.new(0, 350, 0, 0)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

Bar1.Name = "Bar1"
Bar1.Parent = Frame
Bar1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Bar1.BackgroundTransparency = 0.500
Bar1.BorderSizePixel = 0
Bar1.Size = UDim2.new(0, 10, 0, 0)

Bar2.Name = "Bar2"
Bar2.Parent = Frame
Bar2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Bar2.BackgroundTransparency = 0.500
Bar2.BorderSizePixel = 0
Bar2.Position = UDim2.new(0, 10, 0, 0)
Bar2.Size = UDim2.new(0, 10, 0, 0)

Bar3.Name = "Bar3"
Bar3.Parent = Frame
Bar3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Bar3.BackgroundTransparency = 0.500
Bar3.BorderSizePixel = 0
Bar3.Position = UDim2.new(0, 20, 0, 0)
Bar3.Size = UDim2.new(0, 10, 0, 0)

Bar6.Name = "Bar6"
Bar6.Parent = Frame
Bar6.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Bar6.BackgroundTransparency = 0.500
Bar6.BorderSizePixel = 0
Bar6.Position = UDim2.new(0, 340, 0, 0)
Bar6.Size = UDim2.new(0, 10, 0, 0)

Bar7.Name = "Bar7"
Bar7.Parent = Frame
Bar7.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Bar7.BackgroundTransparency = 0.500
Bar7.BorderSizePixel = 0
Bar7.Position = UDim2.new(0, 330, 0, 0)
Bar7.Size = UDim2.new(0, 10, 0, 0)

Bar8.Name = "Bar8"
Bar8.Parent = Frame
Bar8.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Bar8.BackgroundTransparency = 0.500
Bar8.BorderSizePixel = 0
Bar8.Position = UDim2.new(0, 320, 0, 0)
Bar8.Size = UDim2.new(0, 10, 0, 0)

Title.Name = "Title"
Title.Parent = BillboardGui
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.000
Title.BorderColor3 = Color3.fromRGB(255, 255, 255)
Title.Position = UDim2.new(0.180000007, 0, 0.280000001, 0)
Title.Selectable = true
Title.Size = UDim2.new(0, 300, 0, 50)
Title.Font = Enum.Font.Gotham
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.TextScaled = true
Title.TextSize = 40.000
Title.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
Title.TextStrokeTransparency = 0.000
Title.TextWrapped = true

local sound = Instance.new("Sound", reanim.Torso)

local function music(id)
	Title.Text = game:GetService("MarketplaceService"):GetProductInfo(id).Name

	sound.SoundId = "rbxassetid://" .. id
	sound.Volume = 1.5
	sound.Name = "Music"
	sound.Playing = true
	sound.Looped = true
end

local function settext(text,color,stroke,font)
	Form.Text = text
	Form.TextColor3 = color
	Form.TextStrokeColor3 = stroke
	Form.Font = font

	Title.TextColor3 = color
	Title.TextStrokeColor3 = stroke
	Title.Font = font

	Frame.BackgroundColor3 = color
end


game:GetService("RunService").Heartbeat:Connect(function()
	local y = math.floor(sound.PlaybackLoudness)

	Bar1.Size = UDim2.new(0, 10, 0, -math.clamp(y / 600 * 200, 0, 200))
	Bar2.Size = UDim2.new(0, 10, 0, -math.clamp(y / 800 * 200, 0, 200))
	Bar3.Size = UDim2.new(0, 10, 0, -math.clamp(y / 1000 * 200, 0, 200))

	Bar6.Size = UDim2.new(0, 10, 0, -math.clamp(y / 600 * 200, 0, 200))
	Bar7.Size = UDim2.new(0, 10, 0, -math.clamp(y / 800 * 200, 0, 200))
	Bar8.Size = UDim2.new(0, 10, 0, -math.clamp(y / 1000 * 200, 0, 200))
end)

music(StartUpMusic)

---// INPUT
local torsorotY , torsorotY2 , attk
UserInputService.InputBegan:Connect(function(InputObject)
	local Key = string.lower(tostring(InputObject.KeyCode.Name))
	local UPKey = string.upper(tostring(InputObject.KeyCode.Name))

	local UserInputType = InputObject.UserInputType.Name
	if InputObject.KeyCode.Name == "Unknown" and not table.find(Loader.GoodUserInputType , InputObject.UserInputType.Name) then return end
	
	if Key == 'one' then
		if mode ~= 1 then
			if not atk then
				mode = 1
				hum.WalkSpeed = 30
				music(StartUpMusic)
				settext("Kayden's Banisher",Color3.fromRGB(255,255,255),Color3.fromRGB(200,200,200),Enum.Font.Gotham)
			end
		end
	elseif Key == 'two' then
		if mode ~= 2 then
			if not atk then
				mode = 2
				hum.WalkSpeed = 40
				music(9507617655)
				settext("Inferior Beast",Color3.fromRGB(0,0,0),Color3.fromRGB(255,255,255),Enum.Font.Code)
			end
		end
	elseif Key == 'three' then
		if mode ~= 14 then
			if not atk then
				mode = 14
				hum.WalkSpeed = 15
				music(9507614346)
				settext("Superior Beast",Color3.fromRGB(0,0,0),Color3.fromRGB(255,255,255),Enum.Font.Antique)
			end
		end
	elseif Key == 'four' then
		if mode ~= 4 then
			if not atk then
				mode = 4
				hum.WalkSpeed = 30
				music(9491494389)
				settext("Wilderness",Color3.fromRGB(0,0,0),Color3.fromRGB(0,200,0),Enum.Font.Gotham)
			end
		end
	elseif Key == 'five' then
		if mode ~= 8 then
			if not atk then
				mode = 8
				hum.WalkSpeed = 50
				music(9495948671)
				settext("Distinct",Color3.fromRGB(255,255,255),Color3.fromRGB(200,200,200),Enum.Font.Gotham)
			end
		end
	elseif Key == 'six' then
		if mode ~= 9 then
			if not atk then
				mode = 9
				hum.WalkSpeed = 67
				music(9491930319)
				settext("Insanity",Color3.fromRGB(0,0,0),Color3.fromRGB(255,0,0),Enum.Font.Arcade)
			end
		end
	elseif Key == 'seven' then
		if mode ~= 15 then
			if not atk then
				mode = 15
				hum.WalkSpeed = 7
				music(9495155963)
				settext("Lust",Color3.fromRGB(255,255,255),Color3.fromRGB(255,102,204),Enum.Font.Arcade)
			end
		end
	elseif Key == 'eight' then
		if mode ~= 7 then
			if not atk then
				mode = 7
				hum.WalkSpeed = 30
				music(9495256260)
				settext("Sans",Color3.fromRGB(255,255,255),Color3.fromRGB(200,200,200),Enum.Font.Gotham)
			end
		end
	elseif Key == 'nine' then
		if mode ~= 10 then
			if not atk then
				mode = 10
				hum.WalkSpeed = 100
				music(9495219568)
				settext("Sonic",Color3.fromRGB(255,255,255),Color3.fromRGB(200,200,200),Enum.Font.Gotham)
			end
		end
	elseif Key == 'zero' then
		if mode ~= 17 then
			if not atk then
				mode = 17
				hum.WalkSpeed = 18
				music(9495217954)
				settext("oof speed",Color3.fromRGB(0,0,0),Color3.fromRGB(200,200,200),Enum.Font.Cartoon)
			end
		end
	elseif Key == 'z' then
		if mode ~= 11 then
			if not atk then
				mode = 11
				hum.WalkSpeed = 23
				music(9495454714)
				settext("v i b e",Color3.fromRGB(0,0,0),Color3.fromRGB(255,0,255),Enum.Font.SourceSansItalic)
			end
		end
	elseif Key == 'x' then
		if mode ~= 12 then
			if not atk then
				mode = 12
				hum.WalkSpeed = 49
				music(9495553296)
				settext("rollin",Color3.fromRGB(50,50,50),Color3.fromRGB(0,0,0),Enum.Font.Arcade)
			end
		end
	elseif Key == 'c' then
		if mode ~= 16 then
			if not atk then
				mode = 16
				hum.WalkSpeed = 16
				music(9491855839)
				settext("f a v e",Color3.fromRGB(0,0,0),Color3.fromRGB(200,200,200),Enum.Font.Fantasy)
			end
		end
	elseif Key == 'v' then
		if mode ~= 13 then
			if not atk then
				mode = 13
				hum.WalkSpeed = 49
				music(9495954604)
				settext("Hoverboard",Color3.fromRGB(255,255,255),Color3.fromRGB(200,200,200),Enum.Font.Gotham)
			end
		end
	elseif Key == 'b' then
		if mode ~= 3 then
			if not atk then
				mode = 3
				hum.WalkSpeed = 30
				music(9491717811)
				settext("Impostor",Color3.fromRGB(255,255,255),Color3.fromRGB(255,0,0),Enum.Font.Arcade)
			end
		end
	elseif Key == 'n' then
		if mode ~= 5 then
			if not atk then
				mode = 5
				hum.WalkSpeed = 20
				music(9491642076)
				settext(":joy:",BrickColor.new('Institutional white').Color,BrickColor.new('Really black').Color,Enum.Font.Cartoon)
			end
		end
	elseif Key == 'm' then
		if mode ~= 6 then
			if not atk then
				mode = 6
				hum.WalkSpeed = 16
				music(9495023814)
				settext("minecraft",Color3.fromRGB(255,255,255),Color3.fromRGB(200,200,200),Enum.Font.Gotham)
			end
		end
	elseif Key == 'e' then
		if mode == 6 then
			if not atk then
				atk = true
				attk = "sneak"
				hum.WalkSpeed = 5
			elseif attk == "sneak" then
				atk = false
				hum.WalkSpeed = 16
			end
		end
	end
end)


coroutine.wrap(function()
	while true do -- anim changer
		sine = sine + speed
		if Root.RotVelocity.Y / 6 < 0.2 and Root.RotVelocity.Y / 6 > -0.2 then
			torsorotY = Root.RotVelocity.Y / 6
		elseif Root.RotVelocity.Y / 6 < -0.2 then
			torsorotY = -0.2
		elseif Root.RotVelocity.Y / 6 > 0.2 then
			torsorotY = 0.2
		end
		if Root.RotVelocity.Y / 8 < 0.2 and Root.RotVelocity.Y / 8 > -0.2 then
			torsorotY2 = Root.RotVelocity.Y / 8
		elseif Root.RotVelocity.Y / 8 < -0.2 then
			torsorotY2 = -0.2
		elseif Root.RotVelocity.Y / 8 > 0.2 then
			torsorotY2 = 0.2
		end
		local rlegray = Ray.new(reanim["Right Leg"].Position + Vector3.new(0, 0.5, 0), Vector3.new(0, -1.75, 0))
		local rlegpart, rlegendPoint = workspace:FindPartOnRay(rlegray, reanim)
		local llegray = Ray.new(reanim["Left Leg"].Position + Vector3.new(0, 0.5, 0), Vector3.new(0, -1.75, 0))
		local llegpart, llegendPoint = workspace:FindPartOnRay(llegray, reanim)
		local rightvector = (Root.Velocity * Root.CFrame.rightVector).X + (Root.Velocity * Root.CFrame.rightVector).Z
		local lookvector = (Root.Velocity * Root.CFrame.lookVector).X + (Root.Velocity * Root.CFrame.lookVector).Z
		if lookvector > reanim.Humanoid.WalkSpeed then
			lookvector = reanim.Humanoid.WalkSpeed
		end
		if lookvector < -reanim.Humanoid.WalkSpeed then
			lookvector = -reanim.Humanoid.WalkSpeed
		end
		if rightvector > reanim.Humanoid.WalkSpeed then
			rightvector = reanim.Humanoid.WalkSpeed
		end
		if rightvector < -reanim.Humanoid.WalkSpeed then
			rightvector = -reanim.Humanoid.WalkSpeed
		end
		local lookvel = lookvector / reanim.Humanoid.WalkSpeed
		local rightvel = rightvector / reanim.Humanoid.WalkSpeed
		if Root.Velocity.y > 1 and mode == 1 and not atk then -- jump
			--jump clerp here
		elseif Root.Velocity.y < -1 and mode == 1 and not atk then -- fall
			--fall clerp here
		elseif Root.Velocity.Magnitude < 2 and mode == 1 and not atk then -- idle
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Right Arm']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(-2+0*math.cos(sine/13),0.8+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(90+0*math.cos(sine/13)),RAD(-45+0*math.cos(sine/13)),RAD(90+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/15),1+0*math.cos(sine/15),0+0*math.cos(sine/15))*ANGLES(RAD(0+0*math.cos(sine/15)),RAD(0+0*math.cos(sine/15)),RAD(0+0*math.cos(sine/15))),.2)
			RJ.C0 = RJ.C0:Lerp(CF(0+0*math.cos(sine/15),0+0.2*math.cos(sine/15),0+0.2*math.sin(sine/15))*ANGLES(RAD(0+10*math.sin(sine/15)),RAD(0+0*math.cos(sine/15)),RAD(0+0*math.cos(sine/15))),.2)
			RS.C0 = RS.C0:Lerp(CF(1+0*math.cos(sine/15),0.3+0.2*math.sin(sine/15),0+0*math.cos(sine/15))*ANGLES(RAD(157+-10*math.cos(sine/15)),RAD(1+0*math.cos(sine/15)),RAD(12+3*math.cos(sine/15))),.2)
			LS.C0 = LS.C0:Lerp(CF(-1+0*math.cos(sine/15),0+0.2*math.sin(sine/15),0+0*math.cos(sine/15))*ANGLES(RAD(0+0*math.cos(sine/15)),RAD(0+0*math.cos(sine/15)),RAD(-8+8*math.cos(sine/15))),.2)
			RH.C0 = RH.C0:Lerp(CF(0.6+0*math.cos(sine/15),rlegendPoint.Y-reanim["Right Leg"].Position.Y,-0.55+0*math.cos(sine/15))*ANGLES(RAD(3+-10*math.sin(sine/15)),RAD(-40+0*math.cos(sine/15)),RAD(12+0*math.cos(sine/15))),.2)
			LH.C0 = LH.C0:Lerp(CF(-0.6+0*math.cos(sine/15),llegendPoint.Y-reanim["Left Leg"].Position.Y,-0.55+0*math.cos(sine/15))*ANGLES(RAD(3+-10*math.sin(sine/15)),RAD(40+0*math.cos(sine/15)),RAD(-12+0*math.cos(sine/15))),.2)
		elseif Root.Velocity.Magnitude > 15 and mode == 1 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Right Arm']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(-2+0*math.cos(sine/13),0.8+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(90+0*math.cos(sine/13)),RAD(-45+0*math.cos(sine/13)),RAD(90+0*math.cos(sine/13))),1)
			RS.C0 = RS.C0:Lerp(CF(1+0*math.cos(sine/13),0.3+0.1*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(157+-10*math.cos(sine/13)),math.rad(0 - 5 * 2 * math.cos(sine / 5)),RAD(12+3*math.cos(sine/13))),.1)
			LS.C0 = LS.C0:Lerp(CFrame.new(-1, 0.3 + 0.12 * lookvel ^ 1 + movement / 40 * math.cos(sine / 5) / 3, movement / 150 - movement / 40 * math.cos(sine / 5)) * CFrame.Angles((math.rad(-5 + movement * 2 * math.cos(sine / 5)) + 13 / 10 * math.sin(sine / 5)) * lookvel, math.rad(0 - 5 * 2 * math.cos(sine / 5)), -math.rad(-(movement * 1) * 0.2 + movement * 1 * math.cos(sine / 3) * lookvel) + math.rad(-5 * rightvel)), 0.2)
			RJ.C0 = RJ.C0:Lerp(CFrame.new(0, -1.05 / 2 * math.cos(sine / 3), 0) * CFrame.Angles(math.rad(-(change * 20) - movement / 20 * math.cos(sine / 3)) * lookvel, torsorotY2 + math.rad(0 - 4 * math.sin(sine / 7)), math.rad(-(change * 20) - movement / 20 * math.cos(sine / 3)) * rightvel + math.rad(0 - 1 * math.cos(sine / 7))), 0.1)
			LH.C0 = LH.C0:Lerp(CFrame.new(-0.5, -1.1 - 13 / 15 * math.cos(sine / 5) / 2, (-0.2 + 18 / 15 * math.cos(sine / 5)) * (0.5 + 0.5 * lookvel)) * CFrame.Angles((math.rad(-15 * lookvel + change * 15 - 20 * math.cos(sine / 5)) + -(10 / 10) * math.sin(sine / 5)) * lookvel, math.rad(0 + 5 * 2 * math.cos(sine / 5)), (math.rad(change * 1 - movement / 2 * math.cos(sine / 5)) + -(movement / 10) * math.sin(sine / 5)) * (rightvector / (reanim.Humanoid.WalkSpeed * 2))), 0.2)
			RH.C0 = RH.C0:Lerp(CFrame.new(0.5, -1.1 + 13 / 15 * math.cos(sine / 5) / 2, (-0.2 - 18 / 15 * math.cos(sine / 5)) * (0.5 + 0.5 * lookvel)) * CFrame.Angles((math.rad(-15 * lookvel + change * 15 + 20 * math.cos(sine / 5)) + 10 / 10 * math.sin(sine / 5)) * lookvel, math.rad(0 + 5 * 2 * math.cos(sine / 5)), (math.rad(change * 1 + movement / 2* math.cos(sine / 5)) + movement / 10 * math.sin(sine / 5)) * (rightvector / (reanim.Humanoid.WalkSpeed * 2))), 0.2)
		elseif Root.Velocity.magnitude < 2 and mode == 2 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Right Arm']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(-2+0*math.cos(sine/13),0.8+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(90+0*math.cos(sine/13)),RAD(-45+0*math.cos(sine/13)),RAD(90+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/13),1+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
			RJ.C0 = RJ.C0:Lerp(CF(0+0*math.cos(sine/13),1.5+0.5*math.cos(sine/20),0+0*math.cos(sine/13))*ANGLES(RAD(0+10*math.sin(sine/20)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
			RS.C0 = RS.C0:Lerp(CF(1+0*math.cos(sine/15),0.3+0.2*math.sin(sine/20),0+0*math.cos(sine/15))*ANGLES(RAD(157+-10*math.cos(sine/20)),RAD(1+0*math.cos(sine/15)),RAD(12+3*math.cos(sine/20))),.2)
			LS.C0 = LS.C0:Lerp(CF(-1+0*math.cos(sine/13),0+0.2*math.sin(sine/20),0+0*math.cos(sine/13))*ANGLES(RAD(0+5*math.cos(sine/20)),RAD(0+0*math.cos(sine/13)),RAD(1+10*math.cos(sine/20))),.2)
			RH.C0 = RH.C0:Lerp(CF(0.5+0*math.cos(sine/13),-1.1+0.2*math.cos(sine/20),-0.1+0*math.cos(sine/13))*ANGLES(RAD(-19+14*math.cos(sine/20)),RAD(-15+2*math.sin(sine/20)),RAD(5+3*math.sin(sine/20))),.2)
			LH.C0 = LH.C0:Lerp(CF(-0.6+0*math.cos(sine/13),-0.6+0.2*math.cos(sine/20),-0.6+0*math.cos(sine/13))*ANGLES(RAD(-15+5*math.sin(sine/20)),RAD(21-2*math.cos(sine/20)),RAD(-2-3*math.sin(sine/20))),.2)
		elseif Root.Velocity.magnitude > 15 and mode == 2 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Right Arm']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(-2+0*math.cos(sine/13),0.8+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(90+0*math.cos(sine/13)),RAD(-45+0*math.cos(sine/13)),RAD(90+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/13),1+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
			RJ.C0 = RJ.C0:Lerp(CF(0+0*math.cos(sine/20),1.5+0.5*math.cos(sine/20),0+0*math.cos(sine/20))*ANGLES(RAD(-51+7*math.sin(sine/20)),RAD(0+0*math.cos(sine/20)),RAD(0+0*math.cos(sine/20))),.2)
			RS.C0 = RS.C0:Lerp(CF(1+0*math.cos(sine/20),0+0.2*math.sin(sine/20),0+0*math.cos(sine/20))*ANGLES(RAD(148+0*math.cos(sine/20)),RAD(-24+0*math.cos(sine/20)),RAD(12+0*math.cos(sine/20))),.2)
			LS.C0 = LS.C0:Lerp(CF(-1+0*math.cos(sine/20),0+0.2*math.sin(sine/20),0+0*math.cos(sine/20))*ANGLES(RAD(-57+7*math.cos(sine/20)),RAD(22+7*math.sin(sine/20)),RAD(-12+1*math.cos(sine/20))),.2)
			RH.C0 = RH.C0:Lerp(CF(0.5+0*math.cos(sine/20),-1.1+0.2*math.cos(sine/20),-0.1+0*math.cos(sine/20))*ANGLES(RAD(-19+6*math.cos(sine/20)),RAD(3+5*math.sin(sine/20)),RAD(10+1*math.cos(sine/20))),.2)
			LH.C0 = LH.C0:Lerp(CF(-0.5+0*math.cos(sine/20),-0.6+0.2*math.cos(sine/20),-0.6+0*math.cos(sine/20))*ANGLES(RAD(3+6*math.sin(sine/20)),RAD(-5+3*math.cos(sine/20)),RAD(-2+-1*math.sin(sine/20))),.2)
		elseif Root.Velocity.magnitude < 2 and mode == 3 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Torso']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(0+0*math.cos(sine/13),0.2+0*math.cos(sine/13),-0.57+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/13),1+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
			RJ.C0 = RJ.C0:Lerp(CF(0+0*math.cos(sine/13),0+0.2*math.cos(sine/15),0+0.2*math.sin(sine/15))*ANGLES(RAD(0+10*math.sin(sine/15)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
			RS.C0 = RS.C0:Lerp(CF(-0.1+0*math.cos(sine/13),0.4+0*math.cos(sine/13),0.9+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
			LS.C0 = LS.C0:Lerp(CF(0.1+0*math.cos(sine/13),0.4+0*math.cos(sine/13),0.9+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
			RH.C0 = RH.C0:Lerp(CF(0.6+0*math.cos(sine/15),rlegendPoint.Y-reanim["Right Leg"].Position.Y,-0.65+0*math.cos(sine/15))*ANGLES(RAD(3+-10*math.sin(sine/15)),RAD(-40+0*math.cos(sine/15)),RAD(12+0*math.cos(sine/15))),.2)
			LH.C0 = LH.C0:Lerp(CF(-0.6+0*math.cos(sine/15),llegendPoint.Y-reanim["Left Leg"].Position.Y,-0.65+0*math.cos(sine/15))*ANGLES(RAD(3+-10*math.sin(sine/15)),RAD(40+0*math.cos(sine/15)),RAD(-12+0*math.cos(sine/15))),.2)
		elseif Root.Velocity.magnitude > 15 and mode == 3 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Torso']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(0+0*math.cos(sine/13),0.2+0*math.cos(sine/13),-0.57+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/13),1+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
			RS.C0 = RS.C0:Lerp(CF(-0.1+0*math.cos(sine/13),0.4+0*math.cos(sine/13),0.9+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
			LS.C0 = LS.C0:Lerp(CF(0.1+0*math.cos(sine/13),0.4+0*math.cos(sine/13),0.9+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
			RJ.C0 = RJ.C0:Lerp(CFrame.new(0, -1.05 / 2 * math.cos(sine / 3), 0) * CFrame.Angles(math.rad(-(change * 15) - movement / 20 * math.cos(sine / 3)) * lookvel, torsorotY2 + math.rad(0 - 4 * math.sin(sine / 7)), math.rad(-(change * 20) - movement / 20 * math.cos(sine / 3)) * rightvel + math.rad(0 - 1 * math.cos(sine / 7))), 0.1)
			LH.C0 = LH.C0:Lerp(CFrame.new(-0.5, -1.1 - 13 / 15 * math.cos(sine / 5) / 2, (-0.2 + 18 / 15 * math.cos(sine / 5)) * (0.5 + 0.5 * lookvel)) * CFrame.Angles((math.rad(-15 * lookvel + change * 15 - 20 * math.cos(sine / 5)) + -(10 / 10) * math.sin(sine / 5)) * lookvel, math.rad(0 + 5 * 2 * math.cos(sine / 5)), (math.rad(change * 1 - movement / 2 * math.cos(sine / 5)) + -(movement / 10) * math.sin(sine / 5)) * (rightvector / (reanim.Humanoid.WalkSpeed * 2))), 0.2)
			RH.C0 = RH.C0:Lerp(CFrame.new(0.5, -1.1 + 13 / 15 * math.cos(sine / 5) / 2, (-0.2 - 18 / 15 * math.cos(sine / 5)) * (0.5 + 0.5 * lookvel)) * CFrame.Angles((math.rad(-15 * lookvel + change * 15 + 20 * math.cos(sine / 5)) + 10 / 10 * math.sin(sine / 5)) * lookvel, math.rad(0 + 5 * 2 * math.cos(sine / 5)), (math.rad(change * 1 + movement / 2* math.cos(sine / 5)) + movement / 10 * math.sin(sine / 5)) * (rightvector / (reanim.Humanoid.WalkSpeed * 2))), 0.2)
		elseif Root.Velocity.magnitude < 2 and mode == 4 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Right Arm']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(-2+0*math.cos(sine/13),0.8+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(90+0*math.cos(sine/13)),RAD(-45+0*math.cos(sine/13)),RAD(90+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/13),1+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
			RJ.C0 = RJ.C0:Lerp(CF(0+0*math.cos(sine/15),0+0.2*math.cos(sine/15),0+0.2*math.sin(sine/15))*ANGLES(RAD(0+10*math.sin(sine/15)),RAD(0+0*math.cos(sine/15)),RAD(0+0*math.cos(sine/15))),.2)
			RS.C0 = RS.C0:Lerp(CF(0.8+0*math.cos(sine/15),0.3+0.2*math.sin(sine/15),-0.2+0*math.cos(sine/15))*ANGLES(RAD(70+6*math.cos(sine/15)),RAD(-13+2*math.cos(sine/15)),RAD(-84+1*math.cos(sine/15))),.2)
			LS.C0 = LS.C0:Lerp(CF(-0.8+0*math.cos(sine/15),-0.1+0.2*math.sin(sine/15),-0.2+0*math.cos(sine/15))*ANGLES(RAD(79+2*math.cos(sine/15)),RAD(-6+2*math.cos(sine/15)),RAD(79+1*math.cos(sine/15))),.2)
			RH.C0 = RH.C0:Lerp(CF(0.7+0*math.cos(sine/15),rlegendPoint.Y-reanim["Right Leg"].Position.Y,-0.65+0*math.cos(sine/15))*ANGLES(RAD(0+-10*math.sin(sine/15)),RAD(-28+0*math.cos(sine/15)),RAD(12+0*math.cos(sine/15))),.2)
			LH.C0 = LH.C0:Lerp(CF(-0.7+0*math.cos(sine/15),llegendPoint.Y-reanim["Left Leg"].Position.Y,-0.65+0*math.cos(sine/15))*ANGLES(RAD(0+-10*math.sin(sine/15)),RAD(28+0*math.cos(sine/15)),RAD(-12+0*math.cos(sine/15))),.2)
		elseif Root.Velocity.Magnitude > 15 and mode == 4 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Right Arm']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(-2+0*math.cos(sine/13),0.8+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(90+0*math.cos(sine/13)),RAD(-45+0*math.cos(sine/13)),RAD(90+0*math.cos(sine/13))),1)
			RS.C0 = RS.C0:Lerp(CF(1+0*math.cos(sine/13),0.3+0.1*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(157+-10*math.cos(sine/13)),math.rad(0 - 5 * 2 * math.cos(sine / 5)),RAD(12+3*math.cos(sine/13))),.1)
			LS.C0 = LS.C0:Lerp(CFrame.new(-1, 0.3 + 0.12 * lookvel ^ 1 + movement / 40 * math.cos(sine / 5) / 3, movement / 150 - movement / 40 * math.cos(sine / 5)) * CFrame.Angles((math.rad(-5 + movement * 2 * math.cos(sine / 5)) + 13 / 10 * math.sin(sine / 5)) * lookvel, math.rad(0 - 5 * 2 * math.cos(sine / 5)), -math.rad(-(movement * 1) * 0.2 + movement * 1 * math.cos(sine / 3) * lookvel) + math.rad(-5 * rightvel)), 0.2)
			RJ.C0 = RJ.C0:Lerp(CFrame.new(0, -1.05 / 2 * math.cos(sine / 3), 0) * CFrame.Angles(math.rad(-(change * 20) - movement / 20 * math.cos(sine / 3)) * lookvel, torsorotY2 + math.rad(0 - 4 * math.sin(sine / 7)), math.rad(-(change * 20) - movement / 20 * math.cos(sine / 3)) * rightvel + math.rad(0 - 1 * math.cos(sine / 7))), 0.1)
			LH.C0 = LH.C0:Lerp(CFrame.new(-0.5, -1.1 - 13 / 15 * math.cos(sine / 5) / 2, (-0.2 + 18 / 15 * math.cos(sine / 5)) * (0.5 + 0.5 * lookvel)) * CFrame.Angles((math.rad(-15 * lookvel + change * 15 - 20 * math.cos(sine / 5)) + -(10 / 10) * math.sin(sine / 5)) * lookvel, math.rad(0 + 5 * 2 * math.cos(sine / 5)), (math.rad(change * 1 - movement / 2 * math.cos(sine / 5)) + -(movement / 10) * math.sin(sine / 5)) * (rightvector / (reanim.Humanoid.WalkSpeed * 2))), 0.2)
			RH.C0 = RH.C0:Lerp(CFrame.new(0.5, -1.1 + 13 / 15 * math.cos(sine / 5) / 2, (-0.2 - 18 / 15 * math.cos(sine / 5)) * (0.5 + 0.5 * lookvel)) * CFrame.Angles((math.rad(-15 * lookvel + change * 15 + 20 * math.cos(sine / 5)) + 10 / 10 * math.sin(sine / 5)) * lookvel, math.rad(0 + 5 * 2 * math.cos(sine / 5)), (math.rad(change * 1 + movement / 2* math.cos(sine / 5)) + movement / 10 * math.sin(sine / 5)) * (rightvector / (reanim.Humanoid.WalkSpeed * 2))), 0.2)
		elseif Root.Velocity.magnitude < 2 and mode == 5 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Torso']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(0+0*math.cos(sine/13),0.2+0*math.cos(sine/13),-0.57+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/12),1+0*math.cos(sine/12),0+0*math.cos(sine/12))*ANGLES(RAD(0+0*math.cos(sine/12)),RAD(0+0*math.cos(sine/12)),RAD(0+0*math.cos(sine/12))),.2)
			RJ.C0 = RJ.C0:Lerp(CF(0+0*math.cos(sine/12),-0.2+0.3*math.sin(sine/12),0+0.2*math.cos(sine/12))*ANGLES(RAD(10+7*math.cos(sine/12)),RAD(0+0*math.cos(sine/12)),RAD(0+0*math.cos(sine/12))),.2)
			RS.C0 = RS.C0:Lerp(CF(1+0*math.cos(sine/12),0.55+-0.15*math.cos(sine/12),0+0*math.cos(sine/12))*ANGLES(RAD(10+0*math.cos(sine/12)),RAD(0+0*math.cos(sine/12)),RAD(10+-12.5*math.cos(sine/12))),.2)
			LS.C0 = LS.C0:Lerp(CF(-1+0*math.cos(sine/12),0.55+-0.15*math.cos(sine/12),0+0*math.cos(sine/12))*ANGLES(RAD(10+0*math.cos(sine/12)),RAD(0+0*math.cos(sine/12)),RAD(-10+12.5*math.cos(sine/12))),.2)
			RH.C0 = RH.C0:Lerp(CF(0.6+0*math.cos(sine/12),rlegendPoint.Y-reanim["Right Leg"].Position.Y,-1+0*math.cos(sine/12))*ANGLES(RAD(-13+-7*math.cos(sine/12)),RAD(-26+0*math.cos(sine/12)),RAD(10+-7*math.cos(sine/12))),.2)
			LH.C0 = LH.C0:Lerp(CF(-0.6+0*math.cos(sine/12),llegendPoint.Y-reanim["Left Leg"].Position.Y,-1+0*math.cos(sine/12))*ANGLES(RAD(-13+-7*math.cos(sine/12)),RAD(26+0*math.cos(sine/12)),RAD(-10+7*math.cos(sine/12))),.2)
		elseif Root.Velocity.magnitude > 15 and mode == 5 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Torso']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(0+0*math.cos(sine/13),0.2+0*math.cos(sine/13),-0.57+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
			RJ.C0 = RJ.C0:Lerp(CFrame.new(0, -0.73 * math.sin(sine / 3.5) + -math.sin(sine / 3.5) / 1, 0) * CFrame.Angles(math.rad(-3 - 32.5 * math.cos(sine / 3.5)) * lookvel, torsorotY2 + math.rad(0 - 0 * math.sin(sine / 7)), math.rad(-(change * 20) - movement / 20 * math.cos(sine / 3)) * rightvel + math.rad(0 - 1 * math.cos(sine / 7))), 0.1)
			NECK.C0 = NECK.C0:Lerp(CF(0, 1, 0 + ((1* 1) - 1)) * CFrame.Angles(math.rad(30 * math.sin(sine / 3.5)), math.rad(0), math.rad(0 * math.cos(sine / 7)) - reanim.Head.RotVelocity.Y / 15), 0.3)
			RH.C0 = RH.C0:Lerp(CF(0.5* 1, -0.8 - 1 * math.cos(sine / 7) / 2* 1, 0.8 * math.cos(sine / 7) / 0.7* 1 * lookvel)  * CFrame.Angles(math.rad(-10 * lookvel - 25 * math.cos(sine / 7)) - reanim["Right Leg"].RotVelocity.Y / 75 + -math.sin(sine / 7) / 2 * lookvel, math.rad(0 - 15 * math.cos(sine / 7)), math.rad(0)) * CFrame.Angles(math.rad(0 + 2 * math.cos(sine / 7)), math.rad(0),  (math.rad(1 * 1 - 6 / 2 * math.cos(sine / 7)) + -(6 / 10) * math.sin(sine / 7)) * (rightvector / (reanim.Humanoid.WalkSpeed * 2))), 0.3)
			LH.C0 = LH.C0:Lerp(CF(-0.5* 1, -0.8 + 1 * math.cos(sine / 7) / 2* 1, -0.8 * math.cos(sine / 7) / 0.7* 1 * lookvel) * CFrame.Angles(math.rad(-10 * lookvel + 25 * math.cos(sine / 7)) + reanim["Left Leg"].RotVelocity.Y / 75 + math.sin(sine / 7) / 2 * lookvel, math.rad(0 - 15 * math.cos(sine / 7)), math.rad(0)) * CFrame.Angles(math.rad(0 - 2 * math.cos(sine / 7)), math.rad(0),  (math.rad(1 * 1 + 6 / 2* math.cos(sine / 7)) + 6 / 10 * math.sin(sine / 7)) * (rightvector / (reanim.Humanoid.WalkSpeed * 2))), 0.3)
			RS.C0 = RS.C0:Lerp(CF(1* 1, 0.5 + 0.05 * math.sin(sine / 7)* 1, 0* 1 * lookvel) * CFrame.Angles(math.rad(137 * lookvel)  * math.cos(sine / 7) , math.rad(13 * math.cos(sine / 7)), math.rad(0) - reanim["Right Arm"].RotVelocity.Y / 75), 0.1)
			LS.C0 = LS.C0:Lerp(CF(-1* 1, 0.5 + 0.05 * math.sin(sine / 7)* 1, 0* 1 * lookvel) * CFrame.Angles(math.rad(-137 * lookvel)  * math.cos(sine / 7) , math.rad(13 * math.cos(sine / 7)) ,	math.rad(0) + reanim["Left Arm"].RotVelocity.Y / 75), 0.1)
		elseif Root.Velocity.magnitude < 2 and mode == 6 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Torso']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(0+0*math.cos(sine/13),0.2+0*math.cos(sine/13),-0.57+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/13),1+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
			RJ.C0 = RJ.C0:Lerp(CF(0+0*math.cos(sine/13),0+0.1*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0+0.5*math.sin(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
			RS.C0 = RS.C0:Lerp(CF(1+0*math.cos(sine/13),0.5+0.05*math.sin(sine/13),0+0.05*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(1+-1*math.cos(sine/13))),.2)
			LS.C0 = LS.C0:Lerp(CF(-1+0*math.cos(sine/13),0.5+0.05*math.sin(sine/13),0+0.05*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(-1+1*math.cos(sine/13))),.2)
			RH.C0 = RH.C0:Lerp(CF(0.5+0*math.cos(sine/13),-1+-0.1*math.cos(sine/13),-0.1+0*math.cos(sine/13))*ANGLES(RAD(0-0.5*math.sin(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
			LH.C0 = LH.C0:Lerp(CF(-0.5+0*math.cos(sine/13),-1+-0.1*math.cos(sine/13),-0.1+0*math.cos(sine/13))*ANGLES(RAD(0-0.5*math.sin(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
		elseif Root.Velocity.magnitude > 15 and mode == 6 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Torso']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(0+0*math.cos(sine/13),0.2+0*math.cos(sine/13),-0.57+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/13),1+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
			RJ.C0 = RJ.C0:Lerp(CF(0+0*math.cos(sine/13),0+0.1*math.sin(sine/3.5),0+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(-2 * rightvel)),.2)
			RS.C0 = RS.C0:Lerp(CF(1+0*math.cos(sine/8),0.5+0*math.cos(sine/8),0+0*math.cos(sine/8))*ANGLES(RAD(0+-40*math.cos(sine/8) * lookvel),RAD(0+0*math.cos(sine/8)),RAD(0+0*math.cos(sine/8))),.2)
			LS.C0 = LS.C0:Lerp(CF(-1+0*math.cos(sine/8),0.5+0*math.cos(sine/8),0+0*math.cos(sine/8))*ANGLES(RAD(0+40*math.cos(sine/8) * lookvel),RAD(0+0*math.cos(sine/8)),RAD(0+0*math.cos(sine/8))),.2)
			RH.C0 = RH.C0:Lerp(CF(0.5+0*math.cos(sine/8),-1-0.1*math.sin(sine/8) / 2,0+0.1*math.cos(sine/8) /0.7)*ANGLES(RAD(0+40*math.cos(sine/8) * lookvel),RAD(0+0*math.cos(sine/8)),(math.rad(1 * 1 - 5 / 2 * math.cos(sine / 8)) + -(5 / 10) * math.sin(sine / 8)) * (rightvector / (reanim.Humanoid.WalkSpeed * 2))), 0.3)
			LH.C0 = LH.C0:Lerp(CF(-0.5+0*math.cos(sine/8),-1+0.1*math.sin(sine/8) / 2,0-0.1*math.cos(sine/8) / 0.7)*ANGLES(RAD(0+-40*math.cos(sine/8) * lookvel),RAD(0+0*math.cos(sine/8)),(math.rad(1 * 1 + 5 / 2* math.cos(sine / 8)) + 5 / 10 * math.sin(sine / 8)) * (rightvector / (reanim.Humanoid.WalkSpeed * 2))), 0.2)
		elseif Root.Velocity.magnitude < 2 and attk == "sneak" and atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Torso']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(0+0*math.cos(sine/13),0.2+0*math.cos(sine/13),-0.57+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/13),1+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
			RJ.C0 = RJ.C0:Lerp(CF(0+0*math.cos(sine/13),-0.2+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(-35+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
			RS.C0 = RS.C0:Lerp(CF(1+0*math.cos(sine/13),0.5+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
			LS.C0 = LS.C0:Lerp(CF(-1+0*math.cos(sine/13),0.5+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
			RH.C0 = RH.C0:Lerp(CF(0.5+0*math.cos(sine/13),-1+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(35+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
			LH.C0 = LH.C0:Lerp(CF(-0.5+0*math.cos(sine/13),-1+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(35+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
		elseif Root.Velocity.Magnitude < 2 and mode == 7 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Torso']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(0+0*math.cos(sine/13),0.2+0*math.cos(sine/13),-0.57+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/13),1+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
			RJ.C0 = RJ.C0:Lerp(CF(0+0.05*math.sin(sine/30),0+0.2*math.cos(sine/15),0+0.2*math.sin(sine/15))*ANGLES(RAD(0+10*math.sin(sine/15)),RAD(0+0*math.cos(sine/15)),RAD(0+2*math.sin(sine/30))),.2)
			RS.C0 = RS.C0:Lerp(CF(1+0*math.cos(sine/13),0.3+0.2*math.sin(sine/15),-0.1+0*math.cos(sine/13))*ANGLES(RAD(10+0*math.cos(sine/13)),RAD(8+0*math.cos(sine/13)),RAD(-10+0*math.cos(sine/13))),.2)
			LS.C0 = LS.C0:Lerp(CF(-1+0*math.cos(sine/13),0.3+0.2*math.sin(sine/15),-0.1+0*math.cos(sine/13))*ANGLES(RAD(10+0*math.cos(sine/13)),RAD(-8+0*math.cos(sine/13)),RAD(10+0*math.cos(sine/13))),.2)
			RH.C0 = RH.C0:Lerp(CF(0.6-0.05*math.sin(sine/30),rlegendPoint.Y-reanim["Right Leg"].Position.Y,-0.65+0*math.cos(sine/15))*ANGLES(RAD(0+-10*math.sin(sine/15)),RAD(-28+0*math.cos(sine/15)),RAD(12-2*math.sin(sine/30))),.2)
			LH.C0 = LH.C0:Lerp(CF(-0.6-0.05*math.sin(sine/30),llegendPoint.Y-reanim["Left Leg"].Position.Y,-0.65+0*math.cos(sine/15))*ANGLES(RAD(0+-10*math.sin(sine/15)),RAD(28+0*math.cos(sine/15)),RAD(-12-2*math.sin(sine/30))),.2)
		elseif Root.Velocity.magnitude > 15 and mode == 7 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Torso']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(0+0*math.cos(sine/13),0.2+0*math.cos(sine/13),-0.57+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
			RS.C0 = RS.C0:Lerp(CF(1+0*math.cos(sine/13),0.3+0.1*math.sin(sine/3),-0.1+0*math.cos(sine/13))*ANGLES(RAD(10+0*math.cos(sine/13)),RAD(0+10 / 5*math.cos(sine/7)),RAD(-10+0*math.cos(sine/13))),.2)
			LS.C0 = LS.C0:Lerp(CF(-1+0*math.cos(sine/13),0.3+0.1*math.sin(sine/3),-0.1+0*math.cos(sine/13))*ANGLES(RAD(10+0*math.cos(sine/13)),RAD(0+10 / 5*math.cos(sine/7)),RAD(10+0*math.cos(sine/13))),.2)
			RJ.C0 = RJ.C0:Lerp(CFrame.new(0, -1.05 / 2 * math.cos(sine / 3), 0) * CFrame.Angles(math.rad(-(change * 20) - movement / 20 * math.cos(sine / 3)) * lookvel, torsorotY2 + math.rad(0 - 4 * math.sin(sine / 7)), math.rad(-(change * 20) - movement / 20 * math.cos(sine / 3)) * rightvel + math.rad(0 - 1 * math.cos(sine / 7))), 0.1)
			LH.C0 = LH.C0:Lerp(CFrame.new(-0.5, -1.1 - 13 / 15 * math.cos(sine / 5) / 2, (-0.2 + 18 / 15 * math.cos(sine / 5)) * (0.5 + 0.5 * lookvel)) * CFrame.Angles((math.rad(-15 * lookvel + change * 15 - 20 * math.cos(sine / 5)) + -(10 / 10) * math.sin(sine / 5)) * lookvel, math.rad(0 + 5 * 2 * math.cos(sine / 5)), (math.rad(change * 1 - movement / 2 * math.cos(sine / 5)) + -(movement / 10) * math.sin(sine / 5)) * (rightvector / (reanim.Humanoid.WalkSpeed * 2))), 0.2)
			RH.C0 = RH.C0:Lerp(CFrame.new(0.5, -1.1 + 13 / 15 * math.cos(sine / 5) / 2, (-0.2 - 18 / 15 * math.cos(sine / 5)) * (0.5 + 0.5 * lookvel)) * CFrame.Angles((math.rad(-15 * lookvel + change * 15 + 20 * math.cos(sine / 5)) + 10 / 10 * math.sin(sine / 5)) * lookvel, math.rad(0 + 5 * 2 * math.cos(sine / 5)), (math.rad(change * 1 + movement / 2* math.cos(sine / 5)) + movement / 10 * math.sin(sine / 5)) * (rightvector / (reanim.Humanoid.WalkSpeed * 2))), 0.2)
		elseif Root.Velocity.magnitude < 2 and mode == 8 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Right Arm']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(-2+0*math.cos(sine/13),0.8+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(90+0*math.cos(sine/13)),RAD(-45+0*math.cos(sine/13)),RAD(90+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/30),1+0*math.cos(sine/30),0+0*math.cos(sine/30))*ANGLES(RAD(0+0*math.cos(sine/30)),RAD(0+0*math.cos(sine/30)),RAD(0+0*math.cos(sine/30))),.2)
			RJ.C0 = RJ.C0:Lerp(CF(0+0.5*math.sin(sine/30),2+0.5*math.cos(sine/30),0+0*math.cos(sine/30))*ANGLES(RAD(0+10*math.sin(sine/30)),RAD(0+0*math.cos(sine/30)),RAD(0-5*math.sin(sine/30))),.2)
			RS.C0 = RS.C0:Lerp(CF(0.8+0*math.cos(sine/30),0.3+0.2*math.sin(sine/30),-0.2+0*math.cos(sine/30))*ANGLES(RAD(70+6*math.cos(sine/30)),RAD(-13+2*math.cos(sine/30)),RAD(-84+1*math.cos(sine/30))),.2)
			LS.C0 = LS.C0:Lerp(CF(-0.8+0*math.cos(sine/30),-0.1+0.2*math.sin(sine/30),-0.2+0*math.cos(sine/30))*ANGLES(RAD(79+2*math.cos(sine/30)),RAD(-6+2*math.cos(sine/30)),RAD(79+1*math.cos(sine/30))),.2)
			RH.C0 = RH.C0:Lerp(CF(0.5+0*math.cos(sine/30),-0.8+0.2*math.cos(sine/30),-0.6+0*math.cos(sine/30))*ANGLES(RAD(-11+8*math.cos(sine/30)),RAD(-8+5*math.sin(sine/30)),RAD(5+2*math.cos(sine/30))),.2)
			LH.C0 = LH.C0:Lerp(CF(-0.5+0*math.cos(sine/30),-1.1+0.2*math.cos(sine/30),0+0*math.cos(sine/30))*ANGLES(RAD(-11+-7*math.sin(sine/30)),RAD(12-3*math.cos(sine/30)),RAD(-3+-3*math.sin(sine/30))),.2)
		elseif Root.Velocity.Magnitude > 15 and mode == 8 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Right Arm']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(-2+0*math.cos(sine/13),0.8+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(90+0*math.cos(sine/13)),RAD(-45+0*math.cos(sine/13)),RAD(90+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/13),1+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
			RJ.C0 = RJ.C0:Lerp(CF(0+0*math.cos(sine/20),1.5+0.5*math.cos(sine/20),0+0*math.cos(sine/20))*ANGLES(RAD(-51+7*math.sin(sine/20)),RAD(0+0*math.cos(sine/20)),RAD(0+0*math.cos(sine/20))),.2)
			RS.C0 = RS.C0:Lerp(CF(1+0*math.cos(sine/20),0+0.2*math.sin(sine/20),0+0*math.cos(sine/20))*ANGLES(RAD(148+0*math.cos(sine/20)),RAD(-24+0*math.cos(sine/20)),RAD(12+0*math.cos(sine/20))),.2)
			LS.C0 = LS.C0:Lerp(CF(-1+0*math.cos(sine/20),0+0.2*math.sin(sine/20),0+0*math.cos(sine/20))*ANGLES(RAD(-57+7*math.cos(sine/20)),RAD(22+7*math.sin(sine/20)),RAD(-12+1*math.cos(sine/20))),.2)
			RH.C0 = RH.C0:Lerp(CF(0.5+0*math.cos(sine/20),-1.1+0.2*math.cos(sine/20),-0.1+0*math.cos(sine/20))*ANGLES(RAD(-19+6*math.cos(sine/20)),RAD(3+5*math.sin(sine/20)),RAD(10+1*math.cos(sine/20))),.2)
			LH.C0 = LH.C0:Lerp(CF(-0.5+0*math.cos(sine/20),-0.6+0.2*math.cos(sine/20),-0.6+0*math.cos(sine/20))*ANGLES(RAD(3+6*math.sin(sine/20)),RAD(-5+3*math.cos(sine/20)),RAD(-2+-1*math.sin(sine/20))),.2)
		elseif Root.Velocity.Magnitude < 2 and mode == 9 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Right Arm']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(-2+0*math.cos(sine/13),0.8+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(90+0*math.cos(sine/13)),RAD(-45+0*math.cos(sine/13)),RAD(90+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/15),1+0*math.cos(sine/15),0+0*math.cos(sine/15))*ANGLES(RAD(0+0*math.cos(sine/15)),RAD(0+0*math.cos(sine/15)),RAD(0+0*math.cos(sine/15))),.2)
			RJ.C0 = RJ.C0:Lerp(CF(0+0*math.cos(sine/15),-0.5+0.2*math.cos(sine/15),0+0*math.cos(sine/15))*ANGLES(RAD(-62+10*math.sin(sine/15)),RAD(0+0*math.cos(sine/15)),RAD(0+0*math.cos(sine/15))),.2)
			RS.C0 = RS.C0:Lerp(CF(1+0*math.cos(sine/15),0+0*math.cos(sine/15),0.3+0*math.cos(sine/15))*ANGLES(RAD(-40+5*math.sin(sine/15)),RAD(-19+2*math.cos(sine/15)),RAD(25+1*math.cos(sine/15))),.2)
			LS.C0 = LS.C0:Lerp(CF(-0.8+0*math.cos(sine/15),0.4+0*math.cos(sine/15),-0.2+0*math.cos(sine/15))*ANGLES(RAD(154+4*math.cos(sine/15)),RAD(3+1*math.cos(sine/15)),RAD(63+2*math.sin(sine/15))),.2)
			RH.C0 = RH.C0:Lerp(CF(0.5+0*math.cos(sine/15),-0.5+-0.2*math.cos(sine/15),-0.5+0*math.cos(sine/15))*ANGLES(RAD(65+-10*math.sin(sine/15)),RAD(-40+0*math.cos(sine/15)),RAD(14+0*math.cos(sine/15))),.2)
			LH.C0 = LH.C0:Lerp(CF(-0.6+0*math.cos(sine/15),-1+-0.2*math.cos(sine/15),-0.7+0*math.cos(sine/15))*ANGLES(RAD(14+-10*math.sin(sine/15)),RAD(16+0*math.cos(sine/15)),RAD(-11+0*math.cos(sine/15))),.2)
		elseif Root.Velocity.Magnitude > 15 and mode == 9 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Right Arm']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(-2+0*math.cos(sine/13),0.8+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(90+0*math.cos(sine/13)),RAD(-45+0*math.cos(sine/13)),RAD(90+0*math.cos(sine/13))),1)
			RS.C0 = RS.C0:Lerp(CF(1+0*math.cos(sine/13),0.3+0.1*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(157+-10*math.cos(sine/13)),math.rad(0 - 5 * 2 * math.cos(sine / 5)),RAD(12+3*math.cos(sine/13))),.1)
			LS.C0 = LS.C0:Lerp(CFrame.new(-1, 0.3 + 0.12 * lookvel ^ 1 + movement / 40 * math.cos(sine / 5) / 3, movement / 150 - movement / 40 * math.cos(sine / 5)) * CFrame.Angles((math.rad(-5 + movement * 2 * math.cos(sine / 5)) + 13 / 10 * math.sin(sine / 5)) * lookvel, math.rad(0 - 5 * 2 * math.cos(sine / 5)), -math.rad(-(movement * 1) * 0.2 + movement * 1 * math.cos(sine / 3) * lookvel) + math.rad(-5 * rightvel)), 0.2)
			RJ.C0 = RJ.C0:Lerp(CFrame.new(0, -1.05 / 2 * math.cos(sine / 3), 0) * CFrame.Angles(math.rad(-(change * 20) - movement / 20 * math.cos(sine / 3)) * lookvel, torsorotY2 + math.rad(0 - 4 * math.sin(sine / 7)), math.rad(-(change * 20) - movement / 20 * math.cos(sine / 3)) * rightvel + math.rad(0 - 1 * math.cos(sine / 7))), 0.1)
			LH.C0 = LH.C0:Lerp(CFrame.new(-0.5, -1.1 - 13 / 15 * math.cos(sine / 5) / 2, (-0.2 + 18 / 15 * math.cos(sine / 5)) * (0.5 + 0.5 * lookvel)) * CFrame.Angles((math.rad(-15 * lookvel + change * 15 - 20 * math.cos(sine / 5)) + -(10 / 10) * math.sin(sine / 5)) * lookvel, math.rad(0 + 5 * 2 * math.cos(sine / 5)), (math.rad(change * 1 - movement / 2 * math.cos(sine / 5)) + -(movement / 10) * math.sin(sine / 5)) * (rightvector / (reanim.Humanoid.WalkSpeed * 2))), 0.2)
			RH.C0 = RH.C0:Lerp(CFrame.new(0.5, -1.1 + 13 / 15 * math.cos(sine / 5) / 2, (-0.2 - 18 / 15 * math.cos(sine / 5)) * (0.5 + 0.5 * lookvel)) * CFrame.Angles((math.rad(-15 * lookvel + change * 15 + 20 * math.cos(sine / 5)) + 10 / 10 * math.sin(sine / 5)) * lookvel, math.rad(0 + 5 * 2 * math.cos(sine / 5)), (math.rad(change * 1 + movement / 2* math.cos(sine / 5)) + movement / 10 * math.sin(sine / 5)) * (rightvector / (reanim.Humanoid.WalkSpeed * 2))), 0.2)
		elseif Root.Velocity.Y > 1 and mode == 10 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Torso']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(0+0*math.cos(sine/13),0.2+0*math.cos(sine/13),-0.57+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/13),1+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(-46+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
			RJ.C0 = RJ.C0:Lerp(CF(0+0*math.cos(sine/13),0+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(math.rad(0 + 99999 * math.cos(sine / 12)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
			RS.C0 = RS.C0:Lerp(CF(1+0*math.cos(sine/13),0+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(192+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(-57+0*math.cos(sine/13))),1)
			LS.C0 = LS.C0:Lerp(CF(-1+0*math.cos(sine/13),0+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(195+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(57+0*math.cos(sine/13))),1)
			RH.C0 = RH.C0:Lerp(CF(0.5+0*math.cos(sine/13),-0+0*math.cos(sine/13),-0.5+0*math.cos(sine/13))*ANGLES(RAD(-13+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
			LH.C0 = LH.C0:Lerp(CF(-0.5+0*math.cos(sine/13),0+0*math.cos(sine/13),-0.5+0*math.cos(sine/13))*ANGLES(RAD(-19+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
		elseif Root.Velocity.Y < -1 and mode == 10 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Torso']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(0+0*math.cos(sine/13),0.2+0*math.cos(sine/13),-0.57+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/13),1+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(-46+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
			RJ.C0 = RJ.C0:Lerp(CF(0+0*math.cos(sine/13),0+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(math.rad(0 + 99999 * math.cos(sine / 12)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
			RS.C0 = RS.C0:Lerp(CF(1+0*math.cos(sine/13),0+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(192+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(-57+0*math.cos(sine/13))),1)
			LS.C0 = LS.C0:Lerp(CF(-1+0*math.cos(sine/13),0+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(195+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(57+0*math.cos(sine/13))),1)
			RH.C0 = RH.C0:Lerp(CF(0.5+0*math.cos(sine/13),-0+0*math.cos(sine/13),-0.5+0*math.cos(sine/13))*ANGLES(RAD(-13+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
			LH.C0 = LH.C0:Lerp(CF(-0.5+0*math.cos(sine/13),0+0*math.cos(sine/13),-0.5+0*math.cos(sine/13))*ANGLES(RAD(-19+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
		elseif Root.Velocity.Magnitude < 2 and mode == 10 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Torso']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(0+0*math.cos(sine/13),0.2+0*math.cos(sine/13),-0.57+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/13),1+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(-8+0*math.cos(sine/13)),RAD(23+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.1)
			RJ.C0 = RJ.C0:Lerp(CF(0+0*math.cos(sine/15),0+0.2*math.cos(sine/15),0+0.2*math.sin(sine/15))*ANGLES(RAD(0+10*math.sin(sine/15)),RAD(0+0*math.cos(sine/15)),RAD(0+0*math.cos(sine/15))),.2)
			LS.C0 = LS.C0:Lerp(CFrame.new(-1, 0.4 - 0.1 * math.cos(sine / 16) / 3, -0.05 - 0.1 * math.cos(sine / 16)) * CFrame.Angles(math.rad(-2 + 4 * math.sin(sine / 16)), math.rad(0 - 5 * math.sin(sine / 16)), math.rad(-4 + 2 * math.cos(sine / 16))), 0.2)
			RS.C0 = RS.C0:Lerp(CFrame.new(1, 0.4 - 0.1 * math.cos(sine / 16) / 3, -0.05 - 0.1 * math.cos(sine / 16)) * CFrame.Angles(math.rad(-2 + 4 * math.sin(sine / 16)), math.rad(0 + 5 * math.sin(sine / 16)), math.rad(4 - 2 * math.cos(sine / 16))), 0.2)
			RH.C0 = RH.C0:Lerp(CF(0.6+0*math.cos(sine/15),rlegendPoint.Y-reanim["Right Leg"].Position.Y,-0.65+0*math.cos(sine/15))*ANGLES(RAD(3+-10*math.sin(sine/15)),RAD(-40+0*math.cos(sine/15)),RAD(12+0*math.cos(sine/15))),.2)
			LH.C0 = LH.C0:Lerp(CF(-0.6+0*math.cos(sine/15),llegendPoint.Y-reanim["Left Leg"].Position.Y,-0.65+0*math.cos(sine/15))*ANGLES(RAD(3+-10*math.sin(sine/15)),RAD(40+0*math.cos(sine/15)),RAD(-12+0*math.cos(sine/15))),.2)
		elseif Root.Velocity.Magnitude > 15 and mode == 10 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Torso']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(0+0*math.cos(sine/13),0.2+0*math.cos(sine/13),-0.57+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/13),1+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.1)
			RJ.C0 = RJ.C0:Lerp(CFrame.new(0, -1.05 / 2 * math.cos(sine / 2), 0) * CFrame.Angles(math.rad(-(1 * 20) - 20 / 20 * math.cos(sine / 2)) * lookvel, torsorotY2 + math.rad(0 - 4 * math.sin(sine / 4)), math.rad(-(1 * 20) - 20 / 20 * math.cos(sine / 2)) * rightvel + torsorotY2 + math.rad(0 - 1 * math.cos(sine / 4))), 0.1)
			RS.C0 = RS.C0:Lerp(CF(1+0*math.cos(sine/13),0.4+0*math.cos(sine/13),0.5+0*math.cos(sine/13))*ANGLES(RAD(-70+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0)- Root.RotVelocity.Y / 10),.1)
			LS.C0 = LS.C0:Lerp(CF(-1+0*math.cos(sine/13),0.4+0*math.cos(sine/13),0.5+0*math.cos(sine/13))*ANGLES(RAD(-70+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0)- Root.RotVelocity.Y / 10),.1)
			LH.C0 = LH.C0:Lerp(CFrame.new(-0.5, -1.1 - 20 / 15 * math.cos(sine/4) / 2, (-0.2 + 24 / 15 * math.cos(sine/4)) * (0.5 + 0.5 * lookvel)) * CFrame.Angles((math.rad(-15 * lookvel + change * 15 - 25 * math.cos(sine/4)) + -(20 / 10) * math.sin(sine/4)) * lookvel, math.rad(0 + 5 * 2 * math.cos(sine/4)), (math.rad(change * 1 - 20 / 2 * math.cos(sine/4)) + -(20 / 10) * math.sin(sine/4)) * (rightvector / (reanim.Humanoid.WalkSpeed * 2))), 0.2)
			RH.C0 = RH.C0:Lerp(CFrame.new(0.5, -1.1 + 20 / 15 * math.cos(sine/4) / 2, (-0.2 - 24 / 15 * math.cos(sine/4)) * (0.5 + 0.5 * lookvel)) * CFrame.Angles((math.rad(-15 * lookvel + change * 15 + 25 * math.cos(sine/4)) + 20 / 10 * math.sin(sine/4)) * lookvel, math.rad(0 + 5 * 2 * math.cos(sine/4)), (math.rad(change * 1 + 20 / 2* math.cos(sine/4)) + 20 / 10 * math.sin(sine/4)) * (rightvector / (reanim.Humanoid.WalkSpeed * 2))), 0.2)
		elseif Root.Velocity.magnitude < 50 and mode == 11 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Right Arm']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(-2+0*math.cos(sine/13),0.8+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(90+0*math.cos(sine/13)),RAD(-45+0*math.cos(sine/13)),RAD(90+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/13),1+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
			RJ.C0 = RJ.C0:Lerp(CF(0+0*math.cos(sine/20),0+0.4*math.sin(sine/20),0+0*math.cos(sine/20))*ANGLES(RAD(72+10*math.cos(sine/20)),RAD(0+0*math.cos(sine/20)),RAD(0+0*math.cos(sine/20))),.2)
			RS.C0 = RS.C0:Lerp(CF(1+0*math.cos(sine/20),0+0*math.cos(sine/20),0.3+-0.2*math.cos(sine/20))*ANGLES(RAD(-42+6*math.cos(sine/20)),RAD(-31+0*math.cos(sine/20)),RAD(16+0*math.cos(sine/20))),.2)
			LS.C0 = LS.C0:Lerp(CF(-0.7+0*math.cos(sine/20),0.5+0*math.cos(sine/20),0+0*math.cos(sine/20))*ANGLES(RAD(208+0*math.cos(sine/20)),RAD(1+0.2*math.cos(sine/20)),RAD(54+0.1*math.sin(sine/20))),.2)
			RH.C0 = RH.C0:Lerp(CF(0.5+0*math.cos(sine/20),-1+0*math.cos(sine/20),0+0*math.cos(sine/20))*ANGLES(RAD(-38+10*math.sin(sine/20)),RAD(-17+5*math.cos(sine/20)),RAD(5+2*math.sin(sine/20))),.2)
			LH.C0 = LH.C0:Lerp(CF(-0.5+0*math.cos(sine/20),-0.7+0*math.cos(sine/20),-0.2+0*math.cos(sine/20))*ANGLES(RAD(-13+5*math.cos(sine/20)),RAD(5+1*math.cos(sine/20)),RAD(-11-2*math.cos(sine/20))),.2)
		elseif Root.Velocity.magnitude < 50 and mode == 12 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Right Arm']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(-2+0*math.cos(sine/13),0.8+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(90+0*math.cos(sine/13)),RAD(-45+0*math.cos(sine/13)),RAD(90+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/13),1+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),.2)
			RJ.C0 = RJ.C0:Lerp(CF(0+2*math.cos(sine/6),-0.8+0*math.cos(sine/13),0+2*math.sin(sine/6))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(3+0*math.cos(sine/13))),.2)
			RS.C0 = RS.C0:Lerp(CF(1.5+0*math.cos(sine/13),0.5+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(90+0*math.cos(sine/13))),.2)
			LS.C0 = LS.C0:Lerp(CF(-1.5+0*math.cos(sine/13),0.5+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(-90+0*math.cos(sine/13))),.2)
			RH.C0 = RH.C0:Lerp(CF(0.5+0*math.cos(sine/13),-0.4+0*math.cos(sine/13),-0.5+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(-13+0*math.cos(sine/13)),RAD(12+0*math.cos(sine/13))),.2)
			LH.C0 = LH.C0:Lerp(CF(-0.3+0*math.cos(sine/13),-1+0*math.cos(sine/13),-0.1+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(-64+0*math.cos(sine/13))),.2)
		elseif Root.Velocity.magnitude < 50 and mode == 13 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Right Leg']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(0.4+0*math.cos(sine/13),-0.4+0*math.cos(sine/13),1.1+0*math.cos(sine/13))*ANGLES(RAD(90+0*math.cos(sine/13)),RAD(-67+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/25),1+0*math.cos(sine/25),0+0*math.cos(sine/25))*ANGLES(RAD(-8+6*math.cos(sine/25)),RAD(30+3*math.cos(sine/25)),RAD(0+0*math.cos(sine/13))),.2)
			RJ.C0 = RJ.C0:Lerp(CF(0+0.2*math.cos(sine/25),4-0.3*math.cos(sine/25),0-0.1*math.sin(sine/25))*ANGLES(RAD(-10 * lookvel +16*math.sin(sine/25)),RAD(-70+6*math.cos(sine/25)),RAD(-6 * rightvel+3*math.cos(sine/25))),.2)
			RS.C0 = RS.C0:Lerp(CF(1+0*math.cos(sine/25),0+0.2*math.sin(sine/25),0+0*math.cos(sine/25))*ANGLES(RAD(0+5*math.cos(sine/25)),RAD(-8+3*math.cos(sine/25)),RAD(21+7*math.cos(sine/25))),.2)
			LS.C0 = LS.C0:Lerp(CF(-1+0*math.cos(sine/25),0+0.2*math.sin(sine/25),0+0*math.cos(sine/25))*ANGLES(RAD(-4+6*math.cos(sine/25)),RAD(32+0*math.cos(sine/25)),RAD(-17+2*math.cos(sine/25))),.2)
			RH.C0 = RH.C0:Lerp(CF(0.5+0.1*math.cos(sine/25),-0.7-0.2*math.cos(sine/25),-1+0*math.cos(sine/25))*ANGLES(RAD(-8+5*math.cos(sine/25)),RAD(-17+3*math.cos(sine/25)),RAD(14+1*math.sin(sine/25))),.2)
			LH.C0 = LH.C0:Lerp(CF(-0.5+0.1*math.cos(sine/25),-1.15-0.2*math.cos(sine/25),-1+0*math.cos(sine/25))*ANGLES(RAD(-13+5*math.cos(sine/25)),RAD(0+3*math.cos(sine/25)),RAD(4+1*math.cos(sine/25))),.2)
		elseif Root.Velocity.magnitude < 2 and mode == 14 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Right Arm']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(-2+0*math.cos(sine/13),0.8+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(90+0*math.cos(sine/13)),RAD(-45+0*math.cos(sine/13)),RAD(90+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/13),1+0*math.sin(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.sin(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.sin(sine/13))),.2)
			RJ.C0 = RJ.C0:Lerp(CF(0+0*math.cos(sine/20),3+0.3*math.cos(sine/20),0+0*math.cos(sine/20))*ANGLES(RAD(-15+6*math.sin(sine/20)),RAD(0+0*math.cos(sine/20)),RAD(0+5*math.sin(sine/20))),.2)
			RS.C0 = RS.C0:Lerp(CF(1+0*math.cos(sine/20),0+0.2*math.sin(sine/20),0+0*math.cos(sine/20))*ANGLES(RAD(-33+2*math.sin(sine/20)),RAD(-2+3*math.cos(sine/20)),RAD(1+0*math.sin(sine/20))),.2)
			LS.C0 = LS.C0:Lerp(CF(-1+0*math.cos(sine/20),0+0.2*math.sin(sine/20),0+0*math.cos(sine/20))*ANGLES(RAD(0+3*math.sin(sine/20)),RAD(18+2*math.cos(sine/20)),RAD(-10+-10*math.sin(sine/20))),.2)
			RH.C0 = RH.C0:Lerp(CF(0.5+0*math.cos(sine/20),-0.7+0.2*math.cos(sine/20),-0.5+-0.1*math.cos(sine/20))*ANGLES(RAD(3+10*math.sin(sine/20)),RAD(3+0*math.cos(sine/20)),RAD(5+-3*math.cos(sine/20))),.2)
			LH.C0 = LH.C0:Lerp(CF(-0.5+0*math.cos(sine/20),-1+0.1*math.cos(sine/20),-0.1+-0.1*math.cos(sine/20))*ANGLES(RAD(-2+4*math.cos(sine/20)),RAD(14+0*math.cos(sine/20)),RAD(-6+1*math.sin(sine/20))),.2)
		elseif Root.Velocity.magnitude > 13 and mode == 14 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Right Arm']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(-2+0*math.cos(sine/13),0.8+0*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(90+0*math.cos(sine/13)),RAD(-45+0*math.cos(sine/13)),RAD(90+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/13),1+0*math.sin(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.sin(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.sin(sine/13))),.2)
			RJ.C0 = RJ.C0:Lerp(CF(0+0*math.cos(sine/20),3+0.3*math.cos(sine/20),0+0*math.cos(sine/20))*ANGLES(RAD(-24 * lookvel),RAD(0+0*math.cos(sine/20)),RAD(-10 * rightvel)),.2)
			RS.C0 = RS.C0:Lerp(CF(1+0*math.cos(sine/20),0+0.2*math.sin(sine/20),0+0*math.cos(sine/20))*ANGLES(RAD(-33+2*math.sin(sine/20)),RAD(-2+3*math.cos(sine/20)),RAD(1+0*math.sin(sine/20))),.2)
			LS.C0 = LS.C0:Lerp(CF(-1+0*math.cos(sine/20),0+0.2*math.sin(sine/20),0+0*math.cos(sine/20))*ANGLES(RAD(0+3*math.sin(sine/20)),RAD(18+2*math.cos(sine/20)),RAD(-10+-10*math.sin(sine/20))),.2)
			RH.C0 = RH.C0:Lerp(CF(0.5+0*math.cos(sine/20),-0.7+0.2*math.cos(sine/20),-0.5+-0.1*math.cos(sine/20))*ANGLES(RAD(3+10*math.sin(sine/20)),RAD(3+0*math.cos(sine/20)),RAD(5+-3*math.cos(sine/20))),.2)
			LH.C0 = LH.C0:Lerp(CF(-0.5+0*math.cos(sine/20),-1+0.1*math.cos(sine/20),-0.1+-0.1*math.cos(sine/20))*ANGLES(RAD(-2+4*math.cos(sine/20)),RAD(14+0*math.cos(sine/20)),RAD(-6+1*math.sin(sine/20))),.2)
		elseif Root.Velocity.magnitude < 2 and mode == 15 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Torso']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(0+0*math.cos(sine/13),0.2+0*math.cos(sine/13),-0.57+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/13),1+0*math.sin(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.sin(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.sin(sine/13))),.2)
			RJ.C0 = RJ.C0:Lerp(CF(0+0*math.cos(sine/20),0+0.1*math.cos(sine/20),0+0*math.cos(sine/20))*ANGLES(RAD(7+1*math.sin(sine/20)),RAD(0+0*math.cos(sine/20)),RAD(7+2*math.sin(sine/20))),.2)
			RS.C0 = RS.C0:Lerp(CF(0.5+0*math.cos(sine/13),0.5+0.1*math.sin(sine/20),1+0*math.cos(sine/13))*ANGLES(RAD(14+0*math.sin(sine/13)),RAD(16+0*math.cos(sine/13)),RAD(-28+0*math.sin(sine/13))),.2)
			LS.C0 = LS.C0:Lerp(CF(-0.5+0*math.cos(sine/13),0.5+0.1*math.sin(sine/20),1+0*math.cos(sine/13))*ANGLES(RAD(12+0*math.sin(sine/13)),RAD(-24+0*math.cos(sine/13)),RAD(25+0*math.sin(sine/13))),.2)
			RH.C0 = RH.C0:Lerp(CF(0.5+0*math.cos(sine/20),-1.1+-0.1*math.cos(sine/20),-0.2+0*math.cos(sine/20))*ANGLES(RAD(-8+-1*math.sin(sine/20)),RAD(-13+0*math.cos(sine/20)),RAD(-4+-2*math.sin(sine/20))),.2)
			LH.C0 = LH.C0:Lerp(CF(-0.5+0*math.cos(sine/20),-1+-0.1*math.cos(sine/20),-0.2+0*math.cos(sine/20))*ANGLES(RAD(-11+-1*math.sin(sine/20)),RAD(18+0*math.cos(sine/20)),RAD(-4+-2*math.sin(sine/20))),.2)
		elseif Root.Velocity.magnitude > 5 and mode == 15 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Torso']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(0+0*math.cos(sine/13),0.2+0*math.cos(sine/13),-0.57+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/13),1+0*math.sin(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0),RAD(0+0*math.cos(sine/13)),RAD(0)),.2)
			RJ.C0 = RJ.C0:Lerp(CF(0+0*math.cos(sine/3.5),0+0.1*math.cos(sine/3.5),0+0*math.cos(sine/3.5))*ANGLES(RAD(-5*lookvel+2*math.sin(sine/7)),RAD(0+0*math.cos(sine/3)),RAD(-5*rightvel+2*math.sin(sine/7))),.2)
			RS.C0 = RS.C0:Lerp(CF(0.5+0*math.cos(sine/13),0.5+0.1*math.sin(sine/20),1+0*math.cos(sine/13))*ANGLES(RAD(14+0*math.sin(sine/13)),RAD(16+0*math.cos(sine/13)),RAD(-28+0*math.sin(sine/13))),.2)
			LS.C0 = LS.C0:Lerp(CF(-0.5+0*math.cos(sine/13),0.5+0.1*math.sin(sine/20),1+0*math.cos(sine/13))*ANGLES(RAD(12+0*math.sin(sine/13)),RAD(-24+0*math.cos(sine/13)),RAD(25+0*math.sin(sine/13))),.2)
			RH.C0 = RH.C0:Lerp(CF(0.5+0*math.cos(sine/7),-1+-0.2*math.cos(sine/7),-0.1+0.2*math.cos(sine/7))*ANGLES(RAD(-10+-30* lookvel*math.sin(sine/7)),RAD(0+5*math.cos(sine/7)),(math.rad(change * 1 - 7 / 2 * math.cos(sine/7)) + -(7 / 10) * math.sin(sine/7)) * (rightvector / (reanim.Humanoid.WalkSpeed * 2))), 0.2)
			LH.C0 = LH.C0:Lerp(CF(-0.5+0*math.cos(sine/7),-1+0.2*math.cos(sine/7),-0.1+-0.2*math.cos(sine/7))*ANGLES(RAD(-10+30* lookvel*math.sin(sine/7)),RAD(0+5*math.cos(sine/7)),(math.rad(change * 1 + 7 / 2* math.cos(sine/7)) + 7 / 10 * math.sin(sine/7)) * (rightvector / (reanim.Humanoid.WalkSpeed * 2))), 0.2)
		elseif Root.Velocity.magnitude < 50 and mode == 16 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Torso']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(0+0*math.cos(sine/13),0.2+0*math.cos(sine/13),-0.57+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/13),1+0*math.sin(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.sin(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.sin(sine/13))),.2)
			RJ.C0 = RJ.C0:Lerp(CF(0+0*math.cos(sine/13),0+0.1*math.cos(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0+2*math.sin(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.sin(sine/13))),.2)
			RS.C0 = RS.C0:Lerp(CF(1+0*math.cos(sine/13),0.5+0*math.sin(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.sin(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.sin(sine/13))),.2)
			LS.C0 = LS.C0:Lerp(CF(-1+0*math.cos(sine/13),0.4+0.1*math.sin(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(161+2*math.sin(sine/13)),RAD(5+3*math.cos(sine/13)),RAD(-33+1*math.sin(sine/13))),.2)
			RH.C0 = RH.C0:Lerp(CF(0.5+0*math.cos(sine/13),-1+-0.1*math.cos(sine/13),-0.2+0*math.cos(sine/13))*ANGLES(RAD(0+-2*math.sin(sine/13)),RAD(-17+0*math.cos(sine/13)),RAD(12+0*math.sin(sine/13))),.2)
			LH.C0 = LH.C0:Lerp(CF(-0.5+0*math.cos(sine/13),-1+-0.1*math.cos(sine/13),-0.1+0*math.cos(sine/13))*ANGLES(RAD(-6+-2*math.sin(sine/13)),RAD(14+0*math.cos(sine/13)),RAD(-8+0*math.sin(sine/13))),.2)
		elseif Root.Velocity.magnitude < 50 and mode == 17 and not atk then
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.Part1 = reanim['Torso']
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C1 = CF(0,0,0)*ANGLES(RAD(0),RAD(0),RAD(0))
			reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0 = reanim['Starslayer Railgun'].Handle.AccessoryWeld.C0:Lerp(CF(0+0*math.cos(sine/13),0.2+0*math.cos(sine/13),-0.57+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.cos(sine/13))),1)
			NECK.C0 = NECK.C0:Lerp(CF(0+0*math.cos(sine/13),1+0*math.sin(sine/13),0+0*math.cos(sine/13))*ANGLES(RAD(0+0*math.sin(sine/13)),RAD(0+0*math.cos(sine/13)),RAD(0+0*math.sin(sine/13))),.2)
			RJ.C0 = RJ.C0:Lerp(CFrame.new(0,0.2,0) * CFrame.Angles(math.rad(-sine*-6),math.rad(0),math.rad(0)),.25)
			RS.C0 = RS.C0:Lerp(CFrame.new(1,0.5,0) * CFrame.Angles(math.rad(-75*math.sin(sine/5)),math.rad(0),math.rad(0)),.25)
			LS.C0 = LS.C0:Lerp(CFrame.new(-1,0.5,0) * CFrame.Angles(math.rad(75*math.sin(sine/5)),math.rad(0),math.rad(0)),.25)
			RH.C0 = RH.C0:Lerp(CFrame.new(0.5,-1,-0.01) * CFrame.Angles(math.rad(75*math.sin(sine/5)),math.rad(90),math.rad(0)),.25)
			LH.C0 = LH.C0:Lerp(CFrame.new(-0.5,-1,-0.01) * CFrame.Angles(math.rad(-75*math.sin(sine/5)),math.rad(-90),math.rad(0)),.25)
		end
		if Root.Position.Y < workspace.FallenPartsDestroyHeight - 5 then
			Root.CFrame = CF(0,3,0)
		end
		srv.Heartbeat:Wait()
	end
end)()
