local Player, game, owner = getfenv(0).owner, game, getfenv(0).owner
local RealPlayer = Player
do
	print("FE Compatibility code V2 by Mokiros")
	local RealPlayer = RealPlayer

	--Fake event to make stuff like Mouse.KeyDown work
	local Disconnect_Function = function(this)
		this[1].Functions[this[2]] = nil
	end
	local Disconnect_Metatable = {
		__index = {
			disconnect = Disconnect_Function,
			Disconnect = Disconnect_Function
		}
	}
	local FakeEvent_Metatable = {
		__index = {
			Connect = function(this, f)
				local i = tostring(math.random(0, 10000))
				while this.Functions[i] do
					i = tostring(math.random(0, 10000))
				end
				this.Functions[i] = f
				return setmetatable({
					this,
					i
				}, Disconnect_Metatable)
			end
		}
	}
	FakeEvent_Metatable.__index.connect = FakeEvent_Metatable.__index.Connect
	local function fakeEvent()
		return setmetatable({
			Functions = {}
		}, FakeEvent_Metatable)
	end

	--Creating fake input objects with fake variables
	local FakeMouse = {
		Hit = CFrame.new(),
		KeyUp = fakeEvent(),
		KeyDown = fakeEvent(),
		Button1Up = fakeEvent(),
		Button1Down = fakeEvent(),
		Button2Up = fakeEvent(),
		Button2Down = fakeEvent()
	}
	FakeMouse.keyUp = FakeMouse.KeyUp
	FakeMouse.keyDown = FakeMouse.KeyDown
	local UIS = {
		InputBegan = fakeEvent(),
		InputEnded = fakeEvent()
	}
	local CAS = {
		Actions = {},
		BindAction = function(self, name, fun, touch, ...)
			CAS.Actions[name] = fun and {
				Name = name,
				Function = fun,
				Keys = {
					...
				}
			} or nil
		end
	}
	--Merged 2 functions into one by checking amount of arguments
	CAS.UnbindAction = CAS.BindAction

	--This function will trigger the events that have been :Connect()'ed
	local function TriggerEvent(self, ev, ...)
		for _, f in pairs(self[ev].Functions) do
			f(...)
		end
	end
	FakeMouse.TriggerEvent = TriggerEvent
	UIS.TriggerEvent = TriggerEvent

	--Client communication
	local Event = Instance.new("RemoteEvent")
	Event.Name = "UserInput_Event"
	Event.OnServerEvent:Connect(function(plr, io)
		if plr ~= RealPlayer then
			return
		end
		FakeMouse.Target = io.Target
		FakeMouse.Hit = io.Hit
		if not io.isMouse then
			local b = io.UserInputState == Enum.UserInputState.Begin
			if io.UserInputType == Enum.UserInputType.MouseButton1 then
				return FakeMouse:TriggerEvent(b and "Button1Down" or "Button1Up")
			end
			if io.UserInputType == Enum.UserInputType.MouseButton2 then
				return FakeMouse:TriggerEvent(b and "Button2Down" or "Button2Up")
			end
			for _, t in pairs(CAS.Actions) do
				for _, k in pairs(t.Keys) do
					if k == io.KeyCode then
						t.Function(t.Name, io.UserInputState, io)
					end
				end
			end
			FakeMouse:TriggerEvent(b and "KeyDown" or "KeyUp", io.KeyCode.Name:lower())
			UIS:TriggerEvent(b and "InputBegan" or "InputEnded", io, false)
		end
	end)
	Event.Parent = getfenv(0).NLS([==[local Event = script:WaitForChild("UserInput_Event")
	local Mouse = owner:GetMouse()
	local UIS = game:GetService("UserInputService")
	local input = function(io,RobloxHandled)
		if RobloxHandled then return end
		--Since InputObject is a client-side instance, we create and pass table instead
		Event:FireServer({KeyCode=io.KeyCode,UserInputType=io.UserInputType,UserInputState=io.UserInputState,Hit=Mouse.Hit,Target=Mouse.Target})
	end
	UIS.InputBegan:Connect(input)
	UIS.InputEnded:Connect(input)

	local h,t
	--Give the server mouse data every second frame, but only if the values changed
	--If player is not moving their mouse, client won't fire events
	local HB = game:GetService("RunService").Heartbeat
	while true do
		if h~=Mouse.Hit or t~=Mouse.Target then
			h,t=Mouse.Hit,Mouse.Target
			Event:FireServer({isMouse=true,Target=t,Hit=h})
		end
		--Wait 2 frames
		for i=1,2 do
			HB:Wait()
		end
	end]==], owner.Backpack)

	----Sandboxed game object that allows the usage of client-side methods and services
	--Real game object
	local RealGame = game

	--Metatable for fake service
	local FakeService_Metatable = {
		__index = function(self, k)
			local s = rawget(self, "_RealService")
			if s then
				return typeof(s[k]) == "function"
					and function(_, ...)
						return s[k](s, ...)
					end or s[k]
			end
		end,
		__newindex = function(self, k, v)
			local s = rawget(self, "_RealService")
			if s then
				s[k] = v
			end
		end
	}
	local function FakeService(t, RealService)
		t._RealService = typeof(RealService) == "string" and RealGame:GetService(RealService) or RealService
		return setmetatable(t, FakeService_Metatable)
	end

	--Fake game object
	local FakeGame = {
		GetService = function(self, s)
			return rawget(self, s) or RealGame:GetService(s)
		end,
		Players = FakeService({
			LocalPlayer = FakeService({
				GetMouse = function(self)
					return FakeMouse
				end
			}, Player)
		}, "Players"),
		UserInputService = FakeService(UIS, "UserInputService"),
		ContextActionService = FakeService(CAS, "ContextActionService"),
		RunService = FakeService({
			_btrs = {},
			RenderStepped = RealGame:GetService("RunService").Heartbeat,
			BindToRenderStep = function(self, name, _, fun)
				self._btrs[name] = self.Heartbeat:Connect(fun)
			end,
			UnbindFromRenderStep = function(self, name)
				self._btrs[name]:Disconnect()
			end,
		}, "RunService")
	}
	rawset(FakeGame.Players, "localPlayer", FakeGame.Players.LocalPlayer)
	FakeGame.service = FakeGame.GetService
	FakeService(FakeGame, game)
	--Changing owner to fake player object to support owner:GetMouse()
	game, owner = FakeGame, FakeGame.Players.LocalPlayer
end

local uiwrapper = {}
local udim2 = UDim2.new
local wrappable = {
	ScreenGui = true,
	Frame = true,
	ScrollingFrame = true,
	ImageButton = true,
	TextBox = true,
	TextButton = true,
	ImageLabel = true,
	TextLabel = true
}
local objects = {}
local wrappers = {}
local newevent = function()
	local funcs = {}
	local function run(...)
		for func in next, funcs, nil do
			func(...)
		end
	end
	local function add(func)
		funcs[func] = true
		local function remove()
			funcs[func] = nil
		end
		return remove
	end
	return run, add
end
local firescalechanged, scalechanged = newevent()
uiwrapper.scalechanged = scalechanged
local scale = 1
local function getscale()
	return scale
end
local function setscale(newscale)
	firescalechanged(newscale, scale)
	scale = newscale
	for wrapper in next, objects, nil do
		wrapper.rescale()
	end
end
setuiscale = setscale
local wrapobject, wrapfunction, wrapevent, getwrapper, getobject
local function scaleudim2(scale, ud)
	local x = ud.X
	local y = ud.Y
	return udim2(x.Scale, scale * x.Offset, y.Scale, scale * y.Offset)
end
function wrapcleanup(func)
	return function(wrappedobject)
		local object = getobject(wrappedobject)
		objects[object] = nil
		wrappers[object] = nil
		func(object)
	end
end
function wrapfunction(func)
	return function(...)
		local ins = {
			...
		}
		for i = 1, #ins do
			ins[i] = getobject(ins[i])
		end
		local outs = {
			func(unpack(ins))
		}
		for i = 1, #outs do
			outs[i] = getwrapper(outs[i])
		end
		return unpack(outs)
	end
end
function wrapevent(event)
	local wrapper = {}
	function wrapper:connect(func)
		return event:connect(function(...)
			local outs = {
				...
			}
			for i = 1, #outs do
				outs[i] = getwrapper(outs[i])
			end
			func(unpack(outs))
		end)
	end
	return wrapper
end
function wrapobject(object)
	if typeof(object) ~= "Instance" or not wrappable[object.ClassName] then
		return object
	end
	local self = {}
	local meta = {}
	self.object = object
	objects[self] = object
	wrappers[object] = self
	local class = object.ClassName
	if class == "ScreenGui" then
		function meta:__index(index)
			local value = object[index]
			local valuetype = typeof(value)
			if index == "Destroy" then
				return wrapcleanup(value)
			elseif valuetype == "function" then
				return wrapfunction(value)
			elseif valuetype == "RBXScriptSignal" then
				return wrapevent(value)
			elseif index == "AbsolutePosition" then
				return value / scale
			elseif index == "AbsoluteSize" then
				return value / scale
			else
				return getwrapper(value)
			end
		end
		function meta:__newindex(index, value)
			value = getobject(value)
			object[index] = value
		end
		function self.rescale()
		end
	elseif class == "Frame" or class == "ImageLabel" then
		do
			local inputposition = scaleudim2(1 / scale, object.Position)
			local inputsize = scaleudim2(1 / scale, object.Size)
			local inputbordersizepixel = 1 / scale * object.BorderSizePixel
			function meta:__index(index)
				local value = object[index]
				local valuetype = typeof(value)
				if index == "Destroy" then
					return wrapcleanup(value)
				elseif valuetype == "function" then
					return wrapfunction(value)
				elseif valuetype == "RBXScriptSignal" then
					return wrapevent(value)
				elseif index == "AbsolutePosition" then
					return value / scale
				elseif index == "AbsoluteSize" then
					return value / scale
				elseif index == "Position" then
					return inputposition
				elseif index == "Size" then
					return inputsize
				elseif index == "BorderSizePixel" then
					return inputbordersizepixel
				else
					return getwrapper(value)
				end
			end
			function meta:__newindex(index, value)
				if index == "Position" then
					inputposition = value
					object[index] = scaleudim2(scale, value)
				elseif index == "Size" then
					inputsize = value
					object[index] = scaleudim2(scale, value)
				elseif index == "BorderSizePixel" then
					inputbordersizepixel = value
					object[index] = scale * value
				else
					object[index] = getobject(value)
				end
			end
			function self.rescale()
				object.Position = scaleudim2(scale, inputposition)
				object.Size = scaleudim2(scale, inputsize)
				object.BorderSizePixel = scale * inputbordersizepixel
			end
		end
	elseif class == "TextLabel" or class == "TextBox" then
		do
			local inputposition = scaleudim2(1 / scale, object.Position)
			local inputsize = scaleudim2(1 / scale, object.Size)
			local inputbordersizepixel = 1 / scale * object.BorderSizePixel
			local inputtextsize = object.TextSize
			object.TextSize = scale * inputtextsize
			function meta:__index(index)
				local value = object[index]
				local valuetype = typeof(value)
				if index == "Destroy" then
					return wrapcleanup(value)
				elseif valuetype == "function" then
					return wrapfunction(value)
				elseif valuetype == "RBXScriptSignal" then
					return wrapevent(value)
				elseif index == "AbsolutePosition" then
					return value / scale
				elseif index == "AbsoluteSize" then
					return value / scale
				elseif index == "TextBounds" then
					return value / scale
				elseif index == "Position" then
					return inputposition
				elseif index == "Size" then
					return inputsize
				elseif index == "BorderSizePixel" then
					return inputbordersizepixel
				elseif index == "TextSize" then
					return inputtextsize
				elseif index == "FontSize" then
					local r = inputtextsize + 0.5
					r = r - r % 1
					return Enum.FontSize["Size"..r]
				else
					return getwrapper(value)
				end
			end
			function meta:__newindex(index, value)
				if index == "Position" then
					inputposition = value
					object[index] = scaleudim2(scale, value)
				elseif index == "Size" then
					inputsize = value
					object[index] = scaleudim2(scale, value)
				elseif index == "BorderSizePixel" then
					inputbordersizepixel = value
					object[index] = scale * value
				elseif index == "TextSize" then
					inputtextsize = value
					object[index] = scale * value
				elseif index == "FontSize" then
					if typeof(value) == "Enum" then
						value = value.Name
					end
					value = tonumber(value:sub(5, -1))
					inputtextsize = value
					object.TextSize = scale * value
				else
					object[index] = getobject(value)
				end
			end
			function self.rescale()
				object.Position = scaleudim2(scale, inputposition)
				object.Size = scaleudim2(scale, inputsize)
				object.BorderSizePixel = scale * inputbordersizepixel
				object.TextSize = scale * inputtextsize
			end
		end
	end
	return setmetatable(self, meta)
end
function getwrapper(object)
	if objects[object] then
		return object
	else
		return wrappers[object] or wrapobject(object)
	end
end
function getobject(wrapper)
	if wrappers[wrapper] then
		return wrapper
	else
		return objects[wrapper] or wrapper
	end
end
local new = Instance.new
local Instance = {}
function Instance.new(class, parent)
	local wrapper = wrapobject(new(class))
	wrapper.Parent = parent
	return wrapper
end
uiwrapper.Instance = Instance
uiwrapper.wrapevent = wrapevent
uiwrapper.wrapobject = wrapobject
uiwrapper.wrapfunction = wrapfunction
uiwrapper.getwrapper = getwrapper
uiwrapper.getobject = getobject
uiwrapper.setscale = setscale
uiwrapper.getscale = getscale



local expander = {}
UIWrapper = uiwrapper
Instance = UIWrapper.Instance
wrapevent = UIWrapper.wrapevent
wrapobject = UIWrapper.wrapobject
wrapfunction = UIWrapper.wrapfunction
getwrapper = UIWrapper.getwrapper
getobject = UIWrapper.getobject

local acceltween = {}
local tick = tick
local setmt = setmetatable
function acceltween.new(maxaccel)
	local self = {}
	local meta = {}
	local accel = maxaccel or 1
	local t0, y0, a0 = 0, 0, 0
	local t1, y1, a1 = 0, 0, 0
	local function getstate(time)
		if time < (t0 + t1) / 2 then
			local t = time - t0
			return y0 + t * t / 2 * a0, t * a0
		elseif time < t1 then
			local t = time - t1
			return y1 + t * t / 2 * a1, t * a1
		else
			return y1, 0
		end
	end
	local function setstate(newpos, newvel, newaccel, newtarg)
		local time = tick()
		local pos, vel = getstate(time)
		pos = newpos or pos
		vel = newvel or vel
		accel = newaccel or accel
		local targ = newtarg or y1
		if accel < 1.0E-4 then
			t0, y0, a0 = 0, pos, 0
			t1, y1, a1 = 1 / 0, targ, 0
		else
			local conda = pos > targ
			local condb = vel < 0
			local condc = targ > pos - vel * vel / (2 * accel)
			local condd = targ > pos + vel * vel / (2 * accel)
			if conda and condb and condc or not conda and (condb or not condb and condd) then
				a0 = accel
				t1 = time + ((2 * vel * vel + 4 * accel * (targ - pos)) ^ 0.5 - vel) / accel
			else
				a0 = -accel
				t1 = time + ((2 * vel * vel - 4 * accel * (targ - pos)) ^ 0.5 + vel) / accel
			end
			t0 = time - vel / a0
			y0 = pos - vel * vel / (2 * a0)
			y1 = targ
			a1 = -a0
		end
	end
	function meta:__index(index)
		if index == "p" then
			local pos, vel = getstate(tick())
			return pos
		elseif index == "v" then
			local pos, vel = getstate(tick())
			return vel
		elseif index == "a" then
			return accel
		elseif index == "t" then
			return y1
		elseif index == "rtime" then
			local time = tick()
			return time < t1 and t1 - time or 0
		end
	end
	function meta:__newindex(index, value)
		if index == "p" then
			setstate(value, nil, nil, nil)
		elseif index == "v" then
			setstate(nil, value, nil, nil)
		elseif index == "a" then
			value = value < 0 and -value or value
			setstate(nil, nil, value, nil)
		elseif index == "t" then
			setstate(nil, nil, nil, value)
		elseif index == "pt" then
			setstate(value, 0, nil, value)
		end
	end
	return setmt(self, meta)
end

local debugon = false
local function debugprint(...)
	if debugon then
		print(...)
	end
end
local clickmanager = {}
UIWrapper = uiwrapper
Instance = UIWrapper.Instance
wrapevent = UIWrapper.wrapevent
wrapobject = UIWrapper.wrapobject
wrapfunction = UIWrapper.wrapfunction
getwrapper = UIWrapper.getwrapper
getobject = UIWrapper.getobject
local uis = game:GetService("UserInputService")
local deg = math.pi / 180
local cos = math.cos
local sin = math.sin
local mousebuttons = {
	MouseButton1 = 1,
	MouseButton2 = 2,
	MouseButton3 = 3
}
local mx, my = 0, 0
clickmanager.mousex = 0
clickmanager.mousey = 0
local mouseover = {}
local clickable, holding
local function mouseoverframe()
	for info in next, mouseover, nil do
		if info.frame.BackgroundTransparency ~= 1 and info.frame.Visible then
			return true
		end
	end
end
clickmanager.mouseoverframe = mouseoverframe
local function sanitycheck()
	for info in next, mouseover, nil do
		local frame = info.frame.object
		local abspos = frame.AbsolutePosition
		local abssize = frame.AbsoluteSize
		local rot = frame.AbsoluteRotation
		local px, py = abspos.x, abspos.y
		local sx, sy = abssize.x / 2, abssize.y / 2
		local cx = px + sx
		local cy = py + sy
		local inside = false
		if rot % 180 == 0 then
			local dx = mx - cx
			local dy = my - cy
			if dx * dx <= sx * sx and dy * dy <= sy * sy then
				inside = true
			end
		else
			local co = cos(rot * deg)
			local si = sin(rot * deg)
			local dx = co * (mx - cx) + si * (my - cy)
			local dy = si * (mx - cx) + co * (my - cy)
			if dx * dx <= sx * sx and dy * dy <= sy * sy then
				inside = true
			end
		end
		if not inside then
			mouseover[info] = nil
			info.mouseover = false
		end
	end
end
local function computeclickables()
	local bestz = 0
	local best
	for info in next, mouseover, nil do
		local frame = info.frame
		local cansee = info.frame.BackgroundTransparency ~= 1 and info.frame.Visible
		if cansee then
			local z = frame.ZIndex
			if bestz == z then
				if best.created < info.created then
					best = info
				end
			elseif bestz < z then
				best = info
				bestz = z
			end
		end
	end
	if best ~= clickable then
		if clickable then
			clickable.clickable = false
			if clickable.mouseleave then
				clickable.mouseleave()
			end
		end
		if best then
			best.clickable = true
			if best.mouseenter then
				best.mouseenter()
			end
		end
		clickable = best
	end
end
uis.InputChanged:connect(function(input)
	local type = input.UserInputType.Name
	if type == "MouseMovement" then
		local p = input.Position
		mx, my = p.x, p.y
		clickmanager.mousex = mx
		clickmanager.mousey = my
		sanitycheck()
	end
end)
uis.InputBegan:connect(function(input)
	local button = mousebuttons[input.UserInputType.Name]
	computeclickables()
	if button and clickable then
		debugprint("click", clickable.frame:GetFullName())
		if clickable.click then
			clickable.click(button, mx, my)
		end
		holding = clickable
	end
end)
uis.InputEnded:connect(function(input)
	local button = mousebuttons[input.UserInputType.Name]
	computeclickables()
	if button and holding then
		debugprint("unclick", holding.frame:GetFullName())
		if holding.unclick then
			holding.unclick(button, mx, my)
		end
	end
	holding = nil
end)
local createcount = 0
function clickmanager.add(frame)
	local self = {}
	self.frame = frame
	self.created = createcount
	createcount = createcount + 1
	self.mouseover = false
	self.clickable = false
	self.click = nil
	self.unclick = nil
	self.mouseenter = nil
	self.mouseleave = nil
	local connections = {}
	function self.remove()
		mouseover[self] = nil
		if clickable == self then
			computeclickables()
		end
		for i = 1, #connections do
			connections[i]:disconnect()
		end
	end
	connections[1] = frame.MouseEnter:connect(function()
		debugprint("mouse enter", frame:GetFullName())
		mouseover[self] = true
		self.mouseover = true
		computeclickables()
	end)
	connections[2] = frame.MouseLeave:connect(function()
		debugprint("mouse leave", frame:GetFullName())
		mouseover[self] = nil
		self.mouseover = false
		computeclickables()
	end)
	connections[3] = frame.Changed:connect(function(prop)
		debugprint("changed", frame:GetFullName())
		if prop == "Parent" then
			if not frame.Parent then
				self.remove()
			end
		elseif prop == "ZIndex" and mouseover[self] then
			computeclickables()
		end
	end)
	return self
end

local updatemanager = {}
local next = next
local updaters = {}
function updatemanager.add(updatefunc, stopfunc, name)
	local updater = {
		update = updatefunc,
		stop = stopfunc,
		name = name
	}
	return function(start)
		if start == false then
			updaters[updater] = nil
		else
			updater.update()
			if updater.stop and updater.stop() then
				updaters[updater] = nil
			else
				updaters[updater] = true
			end
		end
	end
end
game:GetService("RunService").RenderStepped:connect(function()
	debug.profilebegin("main ui")
	for updater in next, updaters, nil do
		debug.profilebegin(updater.name or "ui element")
		updater.update()
		if updater.stop and updater.stop() then
			updaters[updater] = nil
		end
		debug.profileend()
	end
	debug.profileend()
end)

local page = {}
Instance = UIWrapper.Instance
wrapevent = UIWrapper.wrapevent
wrapobject = UIWrapper.wrapobject
wrapfunction = UIWrapper.wrapfunction
getwrapper = UIWrapper.getwrapper
getobject = UIWrapper.getobject
local new = Instance.new
local v2 = Vector2.new
local c3 = Color3.new
local clerp = c3().lerp
local ud2 = UDim2.new
local nud2 = ud2()
local isa = game.IsA
local setmt = setmetatable
local uis = game:GetService("UserInputService")
local controldown = false
uis.InputBegan:connect(function(input)
	local type = input.UserInputType.Name
	if type == "Keyboard" and input.KeyCode.Name == "LeftControl" then
		controldown = true
	end
end)
uis.InputEnded:connect(function(input)
	local type = input.UserInputType.Name
	if type == "Keyboard" and input.KeyCode.Name == "LeftControl" then
		controldown = false
	end
end)
function page.new(parent)
	local self = {}
	local meta = {}
	local main = new("Frame", parent)
	local port = new("Frame", main)
	local back = new("Frame", port)
	local xbar = new("Frame", main)
	local ybar = new("Frame", main)
	main.Active = false
	main.BackgroundColor3 = c3(0.125, 0.125, 0.125)
	main.BorderSizePixel = 0
	main.Size = ud2(0, 256, 0, 256)
	main.ZIndex = 1
	port.Active = false
	port.BackgroundTransparency = 1
	port.BorderSizePixel = 0
	port.ClipsDescendants = true
	port.Size = ud2(1, 0, 1, 0)
	port.ZIndex = 1
	back.Active = false
	back.BackgroundTransparency = 1
	back.BorderSizePixel = 0
	back.Size = ud2(1, 0, 1, 0)
	back.ZIndex = 1
	xbar.BackgroundColor3 = c3(0.875, 0.875, 0.875)
	xbar.BorderSizePixel = 0
	xbar.Size = nud2
	xbar.ZIndex = 2
	ybar.BackgroundColor3 = c3(0.875, 0.875, 0.875)
	ybar.BorderSizePixel = 0
	ybar.Size = nud2
	ybar.ZIndex = 2
	self.main = main
	self.back = back
	self.attach = back
	local scrollable = true
	local mainsize = v2(256, 256)
	local mainpos = v2(0, 0)
	local scrollrate = 48
	local pagesizex = 0
	local pagesizey = 0
	local scrollbarsize = 8
	local xbarsize = acceltween.new(256)
	local ybarsize = acceltween.new(256)
	local scrollx = acceltween.new(16384)
	local scrolly = acceltween.new(16384)
	local xbarholdstate = acceltween.new(256)
	local ybarholdstate = acceltween.new(256)
	local scrollbarcolor0 = c3(0.875, 0.875, 0.875)
	local scrollbarcolor1 = c3(0.25, 0.25, 0.25)
	local zindex = 1
	local barzindex = 1
	local overxbar = false
	local xbarheld = false
	local overybar = false
	local ybarheld = false
	local mousestartx = 0
	local mousestarty = 0
	local scrollstartx = 0
	local scrollstarty = 0
	local xbaroffset = 1
	local ybaroffset = 1
	local mainclick = clickmanager.add(main)
	local xbarclick = clickmanager.add(xbar)
	local ybarclick = clickmanager.add(ybar)
	local updated, xdragged, xbarreleased
	local function update()
		local px, py = mainpos.x, mainpos.y
		local sx, sy = mainsize.x, mainsize.y
		if xbarheld then
			scrollx.pt = scrollstartx + (clickmanager.mousex - (px + mousestartx)) * pagesizex / sx
		end
		if ybarheld then
			scrolly.pt = scrollstarty + (clickmanager.mousey - (py + mousestarty)) * pagesizey / sy
		end
		xbar.BackgroundColor3 = clerp(scrollbarcolor0, scrollbarcolor1, xbarholdstate.p)
		ybar.BackgroundColor3 = clerp(scrollbarcolor0, scrollbarcolor1, ybarholdstate.p)
		if sx < pagesizex then
			local posx = scrollx.p
			local targx = scrollx.t
			if posx < 0 then
				scrollx.pt = 0
			elseif posx > pagesizex - sx then
				scrollx.pt = pagesizex - sx
			end
			if targx < 0 then
				scrollx.t = 0
			elseif targx > pagesizex - sx then
				scrollx.t = pagesizex - sx
			end
		else
			scrollx.pt = 0
		end
		if sx < pagesizex and scrollable then
			xbarsize.t = scrollbarsize
			local size = xbarsize.p
			xbar.Position = ud2(0, scrollx.p * sx / pagesizex, 0, xbaroffset * sy - size / 2)
			xbar.Size = ud2(0, sx * sx / pagesizex, 0, size)
		else
			xbarsize.t = 0
			local size = xbarsize.p
			xbar.Position = ud2(0, 0, 0, xbaroffset * sy - size / 2)
			xbar.Size = ud2(0, pagesizex, 0, size)
		end
		if sy < pagesizey then
			local posy = scrolly.p
			local targy = scrolly.t
			if posy < 0 then
				scrolly.pt = 0
			elseif posy > pagesizey - sy then
				scrolly.pt = pagesizey - sy
			end
			if targy < 0 then
				scrolly.t = 0
			elseif targy > pagesizey - sy then
				scrolly.t = pagesizey - sy
			end
		else
			scrolly.pt = 0
		end
		if sy < pagesizey and scrollable then
			ybarsize.t = scrollbarsize
			local size = ybarsize.p
			ybar.Position = ud2(0, ybaroffset * sx - size / 2, 0, scrolly.p * sy / pagesizey)
			ybar.Size = ud2(0, size, 0, sy * sy / pagesizey)
		else
			ybarsize.t = 0
			local size = ybarsize.p
			ybar.Position = ud2(0, ybaroffset * sx - size / 2, 0, 0)
			ybar.Size = ud2(0, size, 0, pagesizey)
		end
		back.Position = ud2(0, -scrollx.p, 0, -scrolly.p)
		if updated then
			updated()
		end
		if xbarheld and xdragged then
			xdragged()
		end
	end
	local function stopfunc()
		return not xbarheld and not ybarheld and xbarsize.rtime == 0 and ybarsize.rtime == 0 and scrollx.rtime == 0 and scrolly.rtime == 0 and xbarholdstate.rtime == 0 and ybarholdstate.rtime == 0
	end
	local startupdate = updatemanager.add(update, stopfunc)
	function xbarclick.mouseenter()
		overxbar = true
		if not xbarheld then
			xbarholdstate.t = 0.25
			startupdate()
		end
	end
	function xbarclick.mouseleave()
		overxbar = false
		if not xbarheld then
			xbarholdstate.t = 0
			startupdate()
		end
	end
	function xbarclick.click(button, mx, my)
		if not(not scrollable or xbarheld) and button == 1 or button == 2 then
			xbarheld = true
			xbarholdstate.t = 1
			mousestartx = mx - mainpos.x
			scrollstartx = scrollx.p
			startupdate()
		end
	end
	function xbarclick.unclick(button, mx, my)
		if scrollable and xbarheld and button == 1 or button == 2 then
			xbarheld = false
			if overxbar then
				xbarholdstate.t = 0.25
			else
				xbarholdstate.t = 0
			end
			startupdate()
			if xbarreleased then
				xbarreleased()
			end
		end
	end
	function ybarclick.mouseenter()
		overybar = true
		if not ybarheld then
			ybarholdstate.t = 0.25
			startupdate()
		end
	end
	function ybarclick.mouseleave()
		overybar = false
		if not ybarheld then
			ybarholdstate.t = 0
			startupdate()
		end
	end
	function ybarclick.click(button, mx, my)
		if not(not scrollable or ybarheld) and button == 1 or button == 2 then
			ybarheld = true
			ybarholdstate.t = 1
			mousestarty = my - mainpos.y
			scrollstarty = scrolly.p
			startupdate()
		end
	end
	function ybarclick.unclick(button, mx, my)
		if scrollable and ybarheld and button == 1 or button == 2 then
			ybarheld = false
			if overybar then
				ybarholdstate.t = 0.25
			else
				ybarholdstate.t = 0
			end
			startupdate()
		end
	end
	main.MouseWheelBackward:connect(function()
		local sx, sy = mainsize.x, mainsize.y
		if controldown or not(sy < pagesizey) then
			scrollx.t = scrollx.t + scrollrate
		else
			scrolly.t = scrolly.t + scrollrate
		end
		startupdate()
	end)
	main.MouseWheelForward:connect(function()
		local sx, sy = mainsize.x, mainsize.y
		if controldown or not(sy < pagesizey) then
			scrollx.t = scrollx.t - scrollrate
		else
			scrolly.t = scrolly.t - scrollrate
		end
		startupdate()
	end)
	main.Changed:connect(function(prop)
		if prop == "AbsoluteSize" then
			mainsize = main.AbsoluteSize
			startupdate()
		elseif prop == "AbsolutePosition" then
			mainpos = main.AbsolutePosition
			startupdate()
		end
	end)
	function self.remove()
		startupdate(false)
		main:Destroy()
		back:Destroy()
		port:Destroy()
		xbar:Destroy()
		ybar:Destroy()
	end
	function meta:__index(index)
		if index == "pagesize" then
			return v2(pagesizex, pagesizey)
		elseif index == "scrollable" then
			return scrollable
		elseif index == "scrollbarsize" then
			return scrollbarsize
		elseif index == "scrollx" then
			return scrollx.p
		elseif index == "scrolly" then
			return scrolly.p
		elseif index == "xbarholdstate" then
			return xbarheld
		elseif index == "scrollrate" then
			return scrollrate
		elseif index == "ZIndex" then
			return zindex
		elseif index == "barzindex" then
			return barzindex
		elseif index == "scrollbarcolor0" then
			return scrollbarcolor0
		elseif index == "scrollbarcolor1" then
			return scrollbarcolor1
		elseif index == "xdragged" then
			return xdragged
		elseif index == "xbarreleased" then
			return xbarreleased
		elseif index == "updated" then
			return updated
		else
			return main[index]
		end
	end
	function meta:__newindex(index, value)
		if index == "pagesize" then
			pagesizex, pagesizey = value.x, value.y
		elseif index == "scrollable" then
			if not value then
				xbarclick.unclick(1)
				ybarclick.unclick(1)
			end
			scrollable = value
		elseif index == "scrollbarsize" then
			scrollbarsize = value
		elseif index == "scrollx" then
			scrollx.t = value
		elseif index == "scrolly" then
			scrolly.t = value
		elseif index == "scrollrate" then
			scrollrate = value
		elseif index == "ZIndex" then
			zindex = value
			main.ZIndex = zindex
			port.ZIndex = zindex
			back.ZIndex = zindex
			xbar.ZIndex = zindex + barzindex
			ybar.ZIndex = zindex + barzindex
		elseif index == "barzindex" then
			barzindex = value
			main.ZIndex = zindex
			port.ZIndex = zindex
			back.ZIndex = zindex
			xbar.ZIndex = zindex + barzindex
			ybar.ZIndex = zindex + barzindex
		elseif index == "scrollbarcolor0" then
			scrollbarcolor0 = value
		elseif index == "scrollbarcolor1" then
			scrollbarcolor1 = value
		elseif index == "xdragged" then
			xdragged = value
		elseif index == "xbarreleased" then
			xbarreleased = value
		elseif index == "updated" then
			updated = value
		else
			main[index] = value
		end
		startupdate()
	end
	return setmt(self, meta)
end

local toggle = {}
Instance = UIWrapper.Instance
wrapevent = UIWrapper.wrapevent
wrapobject = UIWrapper.wrapobject
wrapfunction = UIWrapper.wrapfunction
getwrapper = UIWrapper.getwrapper
getobject = UIWrapper.getobject
local new = Instance.new
local v2 = Vector2.new
local c3 = Color3.new
local clerp = c3().lerp
local ud2 = UDim2.new
local nud2 = ud2()
local isa = game.IsA
local setmt = setmetatable
function toggle.new(parent)
	local self = {}
	local meta = {}
	local main = new("Frame", parent)
	main.BorderSizePixel = 0
	main.Size = ud2(0, 16, 0, 16)
	local box = new("Frame", main)
	box.BorderSizePixel = 0
	box.Size = ud2(1, -4, 1, -4)
	box.Position = ud2(0, 2, 0, 2)
	self.main = main
	self.box = box
	self.attach = box
	local mainclick = clickmanager.add(main)
	local boxedgewidth = 2
	local presstween = acceltween.new(256)
	local buttoncolor0 = c3(0.875, 0.875, 0.875)
	local buttoncolor1 = c3(0.125, 0.125, 0.125)
	local zindex = 1
	local enabled = true
	local toggled, updated, mouseentered, mouseleft
	local overbutton = false
	local buttonheld = false
	local togglestate = false
	local function update()
		main.BackgroundColor3 = buttoncolor0
		box.BackgroundColor3 = clerp(buttoncolor0, buttoncolor1, presstween.p)
		if updated then
			updated()
		end
	end
	local function stopfunc()
		return presstween.rtime == 0
	end
	local startupdate = updatemanager.add(update, stopfunc)
	function mainclick.mouseenter()
		if enabled then
			overbutton = true
			if buttonheld then
				presstween.t = 1
			elseif togglestate then
				presstween.t = 0.75
			else
				presstween.t = 0.25
			end
			if mouseentered then
				mouseentered()
			end
			startupdate()
		end
	end
	function mainclick.mouseleave()
		if enabled then
			overbutton = false
			if buttonheld then
				presstween.t = 0.5
			elseif togglestate then
				presstween.t = 0.5
			else
				presstween.t = 0
			end
			if mouseleft then
				mouseleft()
			end
			startupdate()
		end
	end
	function mainclick.click(button, mx, my)
		if enabled and not buttonheld and (button == 1 or button == 2) then
			buttonheld = true
			presstween.t = 1
			startupdate()
		end
	end
	function mainclick.unclick(button, mx, my)
		if enabled and buttonheld and (button == 1 or button == 2) then
			buttonheld = false
			if overbutton then
				togglestate = not togglestate
				if togglestate then
					presstween.t = 0.75
				else
					presstween.t = 0.25
				end
				if toggled then
					toggled(togglestate, button, mx, my)
				end
			elseif togglestate then
				presstween.t = 0.5
			else
				presstween.t = 0
			end
			startupdate()
		end
	end
	function self.remove()
		startupdate(false)
		main:Destroy()
		box:Destroy()
	end
	function meta:__index(index)
		if index == "color0" then
			return buttoncolor0
		elseif index == "color1" then
			return buttoncolor1
		elseif index == "boxedgewidth" then
			return boxedgewidth
		elseif index == "enabled" then
			return enabled
		elseif index == "toggled" then
			return toggled
		elseif index == "updated" then
			return updated
		elseif index == "togglestate" then
			return togglestate
		elseif index == "pressingstate" then
			return presstween.p
		elseif index == "ZIndex" then
			return zindex
		elseif index == "mouseentered" then
			return mouseentered
		elseif index == "mouseleft" then
			return mouseleft
		else
			return main[index]
		end
	end
	function meta:__newindex(index, value)
		if index == "color0" then
			buttoncolor0 = value
		elseif index == "color1" then
			buttoncolor1 = value
		elseif index == "boxedgewidth" then
			boxedgewidth = value
			box.Size = ud2(1, -2 * boxedgewidth, 1, -2 * boxedgewidth)
			box.Position = ud2(0, boxedgewidth, 0, boxedgewidth)
		elseif index == "enabled" then
			enabled = value
		elseif index == "toggled" then
			toggled = value
		elseif index == "updated" then
			updated = value
		elseif index == "togglestate" then
			buttonheld = false
			togglestate = value
			if overbutton then
				if togglestate then
					presstween.t = 0.75
				else
					presstween.t = 0.25
				end
			elseif togglestate then
				presstween.t = 0.5
			else
				presstween.t = 0
			end
			if toggled then
				toggled(togglestate, 0)
			end
			startupdate()
		elseif index == "ZIndex" then
			zindex = value
			main.ZIndex = zindex
			box.ZIndex = zindex
		elseif index == "mouseentered" then
			mouseentered = value
		elseif index == "mouseleft" then
			mouseleft = value
		else
			main[index] = value
		end
		startupdate()
	end
	startupdate()
	return setmt(self, meta)
end

local new = Instance.new
local v2 = Vector2.new
local c3 = Color3.new
local clerp = c3().lerp
local ud2 = UDim2.new
local nud2 = ud2()
local isa = game.IsA
local setmt = setmetatable
local camera = workspace.CurrentCamera
local screensize = camera.ViewportSize - v2(0, 36)
local screensizeupdater = {}
camera.Changed:connect(function(prop)
	if prop == "ViewportSize" then
		screensize = camera.ViewportSize - v2(0, 36)
		for startupdate in next, screensizeupdater, nil do
			startupdate()
		end
	end
end)
function expander.new(parent)
	local self = {}
	local meta = {}
	local main = new("Frame", parent)
	main.BackgroundColor3 = c3(0.125, 0.125, 0.125)
	main.BorderSizePixel = 0
	main.ClipsDescendants = true
	self.main = main
	self.attach = main
	local mainclick = clickmanager.add(main)
	local opened = false
	local position = nud2
	local screenbound = true
	local size0 = v2(0, 0)
	local size1 = v2(256, 384)
	local sizextween = acceltween.new(16384)
	local sizeytween = acceltween.new(16384)
	local updated
	local function update()
		local sx, sy = sizextween.p, sizeytween.p
		main.Size = ud2(0, sx, 0, sy)
		main.Position = position
		if screenbound then
			local abspos = main.AbsolutePosition
			local px, py = abspos.x, abspos.y
			local scx, scy = screensize.x, screensize.y
			local ox, oy = 0, 0
			if px < 0 then
				ox = -px
			elseif scx < px + sx then
				ox = scx - (px + sx)
			end
			if py < 0 then
				oy = -py
			elseif scy < py + sy then
				oy = scy - (py + sy)
			end
			if ox ~= 0 or oy ~= 0 then
				local x = position.X
				local y = position.Y
				main.Position = ud2(x.Scale, x.Offset + ox, y.Scale, y.Offset + oy)
			end
		end
		if updated then
			updated()
		end
	end
	local function stopfunc()
		return sizextween.rtime == 0 and sizeytween.rtime == 0
	end
	local startupdate = updatemanager.add(update, stopfunc)
	screensizeupdater[startupdate] = true
	function self.remove()
		screensizeupdater[startupdate] = nil
		startupdate(false)
		main:Destroy()
	end
	function meta:__index(index)
		if index == "size0" then
			return size0
		elseif index == "size1" then
			return size1
		elseif index == "x" then
			return sizextween.p
		elseif index == "y" then
			return sizextween.p
		elseif index == "opened" then
			return opened
		elseif index == "openaccel" then
			return sizextween.a
		elseif index == "Position" then
			return position
		elseif index == "updated" then
			return updated
		elseif index == "screenbound" then
			return screenbound
		else
			return main[index]
		end
	end
	function meta:__newindex(index, value)
		if index == "size0" then
			size0 = value
			if opened then
				sizextween.t = size1.x
				sizeytween.t = size1.y
			else
				sizextween.pt = size0.x
				sizeytween.pt = size0.y
			end
		elseif index == "size1" then
			size1 = value
			if opened then
				sizextween.t = size1.x
				sizeytween.t = size1.y
			else
				sizextween.t = size0.x
				sizeytween.t = size0.y
			end
		elseif index == "opened" then
			opened = value
			if opened then
				sizextween.t = size1.x
				sizeytween.t = size1.y
			else
				sizextween.t = size0.x
				sizeytween.t = size0.y
			end
		elseif index == "openaccel" then
			sizextween.a = value
			sizeytween.a = value
		elseif index == "Position" then
			position = value
		elseif index == "updated" then
			updated = value
		elseif index == "screenbound" then
			screenbound = value
		else
			main[index] = value
		end
		startupdate()
	end
	startupdate()
	return setmt(self, meta)
end

local button = {}
local new = Instance.new
local v2 = Vector2.new
local c3 = Color3.new
local clerp = c3().lerp
local ud2 = UDim2.new
local nud2 = ud2()
local isa = game.IsA
local setmt = setmetatable
function button.new(parent)
	local self = {}
	local meta = {}
	local main = new("Frame", parent)
	main.BorderSizePixel = 0
	main.Size = ud2(0, 16, 0, 16)
	self.main = main
	self.attach = main
	local mainclick = clickmanager.add(main)
	local presstween = acceltween.new(256)
	local buttoncolor0 = c3(0.875, 0.875, 0.875)
	local buttoncolor1 = c3(0.25, 0.25, 0.25)
	local clicked, updated, mouseentered, mouseleft
	local overbutton = false
	local buttonheld = false
	local virtualclick = false
	local function update()
		local pressp = presstween.p
		if virtualclick and pressp == 1 then
			virtualclick = false
			mainclick.unclick(0)
		end
		main.BackgroundColor3 = clerp(buttoncolor0, buttoncolor1, pressp)
		if updated then
			updated()
		end
	end
	local function stopfunc()
		return presstween.rtime == 0
	end
	local startupdate = updatemanager.add(update, stopfunc)
	function mainclick.mouseenter()
		overbutton = true
		if buttonheld then
			presstween.t = 1
		else
			presstween.t = 0.25
		end
		if mouseentered then
			mouseentered()
		end
		startupdate()
	end
	function mainclick.mouseleave()
		overbutton = false
		if buttonheld then
			presstween.t = 0.5
		else
			presstween.t = 0
		end
		if mouseleft then
			mouseleft()
		end
		startupdate()
	end
	function mainclick.click(button, mx, my)
		if not buttonheld and (button == 0 or button == 1 or button == 2) then
			buttonheld = true
			presstween.t = 1
			startupdate()
		end
	end
	function mainclick.unclick(button, mx, my)
		if buttonheld and (button == 0 or button == 1 or button == 2) then
			buttonheld = false
			if overbutton then
				presstween.t = 0.25
				if clicked then
					clicked(button, mx, my)
				end
			else
				presstween.t = 0
			end
			startupdate()
		end
	end
	function self.click()
		virtualclick = true
		mainclick.click(0)
	end
	function self.remove()
		startupdate(false)
		main:Destroy()
	end
	function meta:__index(index)
		if index == "color0" then
			return buttoncolor0
		elseif index == "color1" then
			return buttoncolor1
		elseif index == "clicked" then
			return clicked
		elseif index == "updated" then
			return updated
		elseif index == "pressingstate" then
			return presstween.p
		elseif index == "mouseentered" then
			return mouseentered
		elseif index == "mouseleft" then
			return mouseleft
		else
			return main[index]
		end
	end
	function meta:__newindex(index, value)
		if index == "color0" then
			buttoncolor0 = value
		elseif index == "color1" then
			buttoncolor1 = value
		elseif index == "clicked" then
			clicked = value
		elseif index == "updated" then
			updated = value
		elseif index == "mouseentered" then
			mouseentered = value
		elseif index == "mouseleft" then
			mouseleft = value
		else
			main[index] = value
		end
		startupdate()
	end
	startupdate()
	return setmt(self, meta)
end


local c3 = function(r, g, b)
	r = not r and 0 or r > 1 and r / 255 or r
	g = not g and 0 or g > 1 and g / 255 or g
	b = not b and 0 or b > 1 and b / 255 or b
	return Color3.new(r, g, b)
end
function commavalue(amount)
	local formatted, k = amount, nil
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
		if k == 0 then
			break
		end
	end
	return formatted
end

local colors = {
	black = c3(0.125, 0.125, 0.125),
	white = c3(221, 215, 215),
	grey = c3(0.5, 0.5, 0.5),
	red = c3(0.875, 0.125, 0.125),
	green = c3(0.14285714285714285, 0.875, 0.14285714285714285),
	darkgreen = c3(0.14285714285714285, 0.4, 0),
	gold = c3(255, 216, 61),
	color3 = c3(46, 105, 132),
	color4 = c3(51, 204, 255),
	color5 = c3(0.2, 0.5, 0.2),
	color6 = c3(136, 17, 17),
	color7 = c3(45, 128, 110),
	color8 = c3(76, 61, 61),
	color9 = c3(255, 216, 61),
	color10 = c3(63, 127, 127)
}

local function newtextcore(parent, copysize, text, fontsize, font, textcolor)
	local newtext = new("TextLabel")
	newtext.AutoLocalize = false
	newtext.BackgroundTransparency = 1
	newtext.Position = copysize and ud2(0, 0, 0, 0) or ud2(0, 0, 0, -2)
	newtext.Size = copysize and parent.Size or ud2(0, 0, 0, 0)
	newtext.BorderSizePixel = 0
	newtext.Text = text or ""
	newtext.FontSize = fontsize or "Size18"
	newtext.Font = font or "SourceSans"
	newtext.TextColor3 = textcolor or colors.black
	newtext.Parent = parent
	return newtext
end

local function newtext(parent, copysize, text, fontsize, font, textcolor)
	return newtextcore(parent.attach, copysize, text, fontsize, font, textcolor)
end

local new = Instance.new
local v2 = Vector2.new
local v3 = Vector3.new
local strdist
do
	local byte = string.byte
	local min = math.min
	local d = {}
	function strdist(s, t)
		local m = #s
		local n = #t
		for i = 1, m do
			d[i] = i
		end
		local dist
		for j = 1, n do
			local bytetj = byte(t, j)
			local d11 = j - 1
			local d10 = j
			for i = 1, m do
				local d01 = d[i]
				if byte(s, i) == bytetj then
					dist = d11
				else
					dist = min(d11, d01, d10) + 1
				end
				d11 = d01
				d10 = dist
				d[i] = dist
			end
		end
		return dist
	end
end
local function termdist(s, t)
	local m = #s
	local n = #t
	local totaldist = 0
	for i = 1, m do
		local mindist = 1 / 0
		for j = 1, n do
			local dist = strdist(s[i], t[j]) / (#s[i] + #t[j])
			if mindist > dist then
				mindist = dist
			end
		end
		totaldist = totaldist + mindist
	end
	return totaldist
end
local customsort
do
	local a
	local b = {}
	local lt = function(a, b)
		return a < b
	end
	function sort(table, comp)
		comp = comp or lt
		a = table
		local n = #a
		local c = 1
		while n > c do
			local i = 1
			while i <= n - c do
				local p = i
				local i0 = i
				local j0 = i + c
				local i1 = j0 - 1
				local j1 = n > i1 + c and i1 + c or n
				while i0 <= i1 and j0 <= j1 do
					if comp(a[j0], a[i0]) then
						b[p] = a[j0]
						j0 = j0 + 1
					else
						b[p] = a[i0]
						i0 = i0 + 1
					end
					p = p + 1
				end
				for x = i0, i1 do
					b[p] = a[x]
					p = p + 1
				end
				for y = j0, j1 do
					b[p] = a[y]
					p = p + 1
				end
				i = i + 2 * c
			end
			for j = i, n do
				b[j] = a[j]
			end
			a, b = b, a
			c = 2 * c
		end
		if a ~= table then
			for i = 1, n do
				table[i] = a[i]
			end
		end
		return table
	end
end
local cf = CFrame.new
local clerp = Color3.new().lerp
local ud2 = UDim2.new
local nud2 = ud2()
local bcolor = BrickColor.new
local isa = wrapfunction(game.IsA)
local setmt = setmetatable
local rtype = wrapfunction(game.IsA)
local next = next
local wfc = wrapfunction(game.WaitForChild)
local ffc = wrapfunction(game.FindFirstChild)
local getchildren = wrapfunction(game.GetChildren)
local vtws = CFrame.new().vectorToWorldSpace
local angles = CFrame.Angles
local debris = game.Debris
local guiservice = game:GetService("GuiService")
local ray = Ray.new
local raycast = workspace.FindPartOnRayWithIgnoreList
local tos = cf().toObjectSpace
local assetid = "http://www.roblox.com/asset/?id="
local deg = 180 / math.pi
local floor = math.floor
local atan = math.atan
local ceil = math.ceil
local sort = table.sort


local player = owner
local pgui = wfc(player, "PlayerGui")
local screen = new("ScreenGui", pgui)
screen.IgnoreGuiInset = true
local robloxoffset = ud2()


local function cleanbuttons(list)
	for i, v in next, list, nil do
		if type(i) == "userdata" or type(getobject(i)) == "userdata" then
			i:Destroy()
		elseif i.main then
			i.remove()
		else
			v.self:Destroy()
		end
		if v.text then
			v.text:Destroy()
		end
		list[i] = nil
	end
end
function newdragbar(parent, pos, size, draginterval, startval, pagesize)
	local framebar = page.new(parent)
	framebar.BackgroundColor3 = colors.grey
	framebar.Position = pos
	framebar.Size = size
	local dragbar = page.new(framebar.main)
	dragbar.BackgroundColor3 = colors.grey
	dragbar.Position = ud2(0, 0, 0, 5)
	dragbar.Size = ud2(0, size.X.Offset, 0, 0)
	dragbar.pagesize = pagesize or v2(500, 0)
	local pixels = dragbar.pagesize.x - dragbar.Size.X.Offset
	local scale = 100 / pixels
	local pcenter = pixels / 2
	local mainval = startval or pcenter * scale
	dragbar.scrollx = mainval / scale
	return framebar, dragbar, scale, mainval
end
local function newpopup(frame, instant, poptype, pos, size, prompt, promptc3, promptfs)
	local box = expander.new(frame)
	box.Position = pos
	box.BackgroundColor3 = colors.black
	box.BorderSizePixel = 5
	box.ZIndex = 3
	box.size1 = size
	box.openaccel = 262144
	if instant then
		box.size0 = size
	end
	box.opened = true
	local prompttext = newtext(box, false, prompt, promptfs or "Size18", "SourceSansBold", promptc3 or colors.white)
	prompttext.TextYAlignment = "Top"
	prompttext.ZIndex = box.ZIndex
	if poptype == "yes/no" then
		prompttext.Position = ud2(0.5, 0, 0, 30)
		local yes = button.new(box.main)
		yes.Position = ud2(0.5, -50, 1, -50)
		yes.Size = ud2(0, 100, 0, 30)
		yes.ZIndex = box.ZIndex
		yes.color0 = colors.darkgreen
		local yestext = newtext(yes, true, "YES", "Size18", "SourceSansBold", colors.white)
		yestext.TextStrokeTransparency = 0.8
		yestext.ZIndex = box.ZIndex
		local no = button.new(box.main)
		no.Position = ud2(1, -25, 0, 5)
		no.Size = ud2(0, 20, 0, 20)
		no.ZIndex = box.ZIndex
		no.color0 = c3(0.16666666666666666, 0.16666666666666666, 0.16666666666666666)
		no.color1 = colors.white
		local notext = newtext(no, true, "X", "Size18", "SourceSansBold", colors.red)
		notext.TextStrokeTransparency = 0.8
		notext.ZIndex = box.ZIndex
		return box, yes, no, prompttext, yestext, notext
	elseif poptype == "ok" then
		prompttext.Position = ud2(0.5, 0, 0, 20)
		local ok = button.new(box.main)
		ok.Position = ud2(0.5, -50, 1, -40)
		ok.Size = ud2(0, 100, 0, 30)
		ok.ZIndex = box.ZIndex
		ok.color0 = colors.darkgreen
		local oktext = newtext(ok, true, "OK", "Size18", "SourceSansBold", colors.white)
		oktext.TextStrokeTransparency = 0.8
		oktext.ZIndex = box.ZIndex
		return box, ok
	end
end

local pagetrans = 1
local mainpage = page.new(screen)
mainpage.Position = ud2(0, 0, 0, 0) - robloxoffset
mainpage.Size = ud2(1, 0, 1, 0) + robloxoffset
mainpage.BackgroundTransparency = pagetrans
local loadpage = page.new(screen)
loadpage.Position = ud2(-1, 0, 0, 0) - robloxoffset
loadpage.Size = ud2(1, 0, 1, 0) + robloxoffset
loadpage.BackgroundTransparency = pagetrans
local inventorypage = page.new(screen)
inventorypage.Position = ud2(-1, 0, 0, 0) - robloxoffset
inventorypage.Size = ud2(1, 0, 1, 0) + robloxoffset
inventorypage.BackgroundTransparency = pagetrans
local custpage = page.new(screen)
custpage.Position = ud2(-1, 0, 0, 0) - robloxoffset
custpage.Size = ud2(1, 0, 1, 0) + robloxoffset
custpage.BackgroundTransparency = pagetrans
local setpage = page.new(screen)
setpage.Position = ud2(-1, 0, 0, 0) - robloxoffset
setpage.Size = ud2(1, 0, 1, 0) + robloxoffset
setpage.BackgroundTransparency = pagetrans
local bgpage = page.new(screen)
bgpage.Position = ud2(0, 0, 0, 0) - robloxoffset
bgpage.Size = ud2(1, 0, 1, 0) + robloxoffset
bgpage.BackgroundTransparency = pagetrans
bgpage.ZIndex = 10
local mainfr = {}
local bgfr = {}
local datafr = {}
local selectionfr = {}
local squadfr = {}
local gunstatfr = {}
local cardfr = {}
local loadfr = {}
local inventoryfr = {}
local custfr = {}
local setfr = {}

local subpages = {
	[loadpage] = loadfr,
	[inventorypage] = inventoryfr,
	[custpage] = custfr,
	[setpage] = setfr
}

local function movepage(this, pos, override)
	if override then
		this.main.Position = pos - robloxoffset
	else
		this.main:TweenPosition(pos - robloxoffset, "Out", "Sine", 0.2, true)
	end
end
local function gotopage(here, override)
	if here == mainpage then
		movepage(mainpage, ud2(0, 0, 0, 0), override)
		for i, pages in next, subpages, nil do
			movepage(i, ud2(-1, 0, 0, 0), override)
		end
	else
		for i, v in next, subpages, nil do
			if i ~= here then
				movepage(i, ud2(1, 0, 0, 0), override)
			end
		end
		movepage(here, ud2(0, 0, 0, 0), override)
		movepage(mainpage, ud2(1, 0, 0, 0), override)
		mainfr.prevpage = here
		mainfr.buttons.back.self.Visible = true
	end
end
local function goset()
	setpage.main.Position = ud2(0, 0, 0, 0) - robloxoffset
	mainpage.main.Position = ud2(1, 0, 0, 0) - robloxoffset
end
local mainbuttons = {
	--"Deploy",
	--"Squad Deploy",
	--"",
	--"Weapon Loadout",
	--"Case Inventory",
	--"Customize",
	--"Buy Credits",
	--"Settings"
}
local mainbuttonhints = {
	--["Weapon Loadout"] = {
	--	text = "Customize weapon class loadouts"
	--},
	--["Case Inventory"] = {
	--	text = "View and purchase cases"
	--},
	--["Buy Credits"] = {
	--	text = "Purchase more credits in the shop"
	--},
	--Customize = {
	--	text = "Customization options"
	--},
	--Settings = {
	--	text = "Customize game settings"
	--}
}
mainfr.buttons = {}
do
	local backbutton = button.new(mainpage.attach)
	backbutton.Position = ud2(0, 40, 1, -70)
	backbutton.Size = ud2(0, 150, 0, 30)
	backbutton.color0 = colors.color3
	backbutton.Visible = false
	local backtext = newtext(backbutton, true, "Prev page", "Size18", "SourceSans", colors.white)
	backtext.Position = ud2(0, 10, 0, 0)
	backtext.TextXAlignment = "Left"
	mainfr.buttons.back = {
		self = backbutton,
		text = backtext
	}
	function backbutton.clicked()
		if mainfr.prevpage then
			gotopage(mainfr.prevpage)
		end
	end
end
do
	local function createback(subpage, subfr, pos, override)
		local backbutton = button.new(subpage.attach)
		backbutton.Position = ud2(0, 80, 1, -70)
		backbutton.Size = ud2(0, 150, 0, 30)
		backbutton.color0 = colors.color3
		local backtext = newtext(backbutton, true, "Back to Menu", "Size18", "SourceSans", colors.white)
		backtext.Position = ud2(0, 10, 0, 0)
		backtext.TextXAlignment = "Left"
		if not subfr.buttons.back then
			subfr.buttons.back = {
				self = backbutton,
				text = backtext
			}
		else
		end
		if not override then
			function backbutton.clicked()
				gotopage(mainpage)
			end
		end
		return backbutton, backtext
	end
	local function createbackshort(subpage, subfr, pos, override)
		local backshort = button.new(subpage.attach)
		backshort.Position = ud2(0, 25, 0, 120)
		backshort.Size = ud2(0, 30, 0, 30)
		backshort.color0 = colors.color3
		local shorttext = newtext(backshort, true, "<", "Size18", "SourceSansBold", colors.white)
		if not subfr.buttons.backshort then
			subfr.buttons.backshort = {
				self = backshort,
				text = shorttext
			}
		else
		end
		if not override then
			function backshort.clicked()
				gotopage(mainpage)
			end
		end
		return backshort, shorttext
	end
	for subpage, subfr in next, subpages, nil do
		subfr.buttons = {}
		createback(subpage, subfr)
	end
	mainfr.createback = createback
	mainfr.createbackshort = createbackshort
end

do
	gotopage(mainpage, true)
end

local pcall = pcall
local tick = tick
local rs = game:GetService("RunService")
local ss = game:GetService("Stats")
local lp = owner
local IsA = game.IsA
local getmem = ss.GetMemoryUsageMbForTag
local ignoret = tick()
local usage = getmem(ss, 5)
local notifylist = {}
local function newnotification(notedata)
	do
		local notefr = new("Frame", mainpage.attach)
		notefr.BackgroundColor3 = c3(0.2, 0.2, 0.2)
		notefr.BackgroundTransparency = 0
		notefr.Size = ud2(0, 350, 0, 220)
		notefr.Position = ud2(0.5, -175, 0.5, -110)
		notefr.BorderColor3 = colors.grey
		notefr.BorderSizePixel = 5
		local notetitletext = newtextcore(notefr, false, notedata.title or "Hey", "Size32", "SourceSansBold", colors.white)
		notetitletext.Position = ud2(0, 15, 0, 20)
		notetitletext.TextXAlignment = "Left"
		local notecaptext = newtextcore(notefr, false, notedata.caption, "Size18", "SourceSansBold", colors.white)
		notecaptext.Size = ud2(1, -50, 1, 0)
		notecaptext.Position = ud2(0, 25, 0, 60)
		notecaptext.TextXAlignment = "Left"
		notecaptext.TextYAlignment = "Top"
		notecaptext.TextWrapped = true
		local noteclose = button.new(notefr)
		noteclose.Size = ud2(0, 200, 0, 40)
		noteclose.Position = ud2(0.5, -100, 1, -60)
		noteclose.color0 = colors.darkgreen
		noteclose.color1 = colors.black
		local noteclosetext = newtext(noteclose, true, "Confirm", "Size18", "SourceSansBold", colors.white)
		noteclosetext.TextXAlignment = "Center"
		function noteclose.clicked()
			notefr:Destroy()
		end
	end
end

do
	shared.Noti = newnotification
end
