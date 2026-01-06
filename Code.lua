--Made by davedesito.

--!strict

local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local GoodSignal   = require(script.GoodSignal)
local Debug        = require(script.Debug)
local Type         = require(script.Type)
local Utils        = require(script.Utils)

local LerpService = {}

local LerpMeta    = {}
LerpMeta.__index = LerpMeta

local Lerps = {} :: {[any]: any}

export type Lerp = typeof(setmetatable({ }::{
	Completed     : any,
	Stopped       : any,
	Deleted       : any,
	Object        : BasePart,
	Starting      : CFrame,
	DTime         : number,
	Loop          : number,
	Time          : number,
	Playing       : boolean,
	Reverse       : boolean,
	Id            : number,
	Alpha         : number,
	Goal          : CFrame,
	Info     	  : Type.LerpInfo,
	CurrentCFrame : CFrame
}
, LerpMeta))




--[[
Creates a lerp containing information and signals.

<strong>Object</strong> is the BasePart to which the lerp will be applied.
<strong>Cframe</strong> is the CFrame to which the lerp will be applied.
If you provide both, <strong>Object</strong> and <strong>Cframe</strong> then object will be used instead.

<strong>Property</strong> must be a table containing the CFrame {CFrame = CFrame}.
<strong>LerpInfo</strong> must be a lerp info created using the method <code>NewLerpInfo</code>
]]
function LerpService.create(Object: BasePart?,Cframe: CFrame?,Goal : CFrame, LerpInfo: Type.LerpInfo): Lerp
	--local Name: any, Value: any = Utils.GetTableValues(Property)
	if Object and Cframe then Debug.warn("2 cframes have been provided, using Object.") Cframe = nil end
	
	local LerpObject = {}
	setmetatable(LerpObject,LerpMeta)
	
	LerpObject.Completed = GoodSignal.new()
	LerpObject.Stopped   = GoodSignal.new()
	LerpObject.Deleted   = GoodSignal.new()
	LerpObject.DTime     = 0
	LerpObject.Loop      = 0 				:: number
	LerpObject.Time      = 0
	LerpObject.Playing   = false
	LerpObject.Reverse   = false
	LerpObject.Id        = #Lerps + 1
	LerpObject.Alpha     = 0
	LerpObject.Goal      = Goal              :: CFrame
	LerpObject.Info      = LerpInfo or LerpService.NewLerpInfo(1,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0) :: Type.LerpInfo
	Utils.CreationWarnings(LerpObject:: {[any]: any}, LerpObject.Info:: Type.LerpInfo)
	
	if Object and not Cframe then
		LerpObject.Object    = Object 			:: BasePart
		LerpObject.Starting  = Object.CFrame    :: CFrame
	elseif not Object and Cframe then
		LerpObject.Cframe    = Cframe
		LerpObject.Starting  = Cframe    :: CFrame
		LerpObject.CurrentCFrame = Cframe
	end
	
	Debug.print("Lerp ("..LerpObject.Id..") created:",LerpObject)
	return LerpObject :: Lerp
end

--[[
Creates a lerp info containing the values specified those values used in a Lerp.
]]
function LerpService.NewLerpInfo(duration: number, easingStyle: Enum.EasingStyle, easingDirection: Enum.EasingDirection,repeatCount: number,reverses: boolean,delayTime: number): Type.LerpInfo
	return {
		Duration    = duration     	 	or 1						:: number,                       
		Style       = easingStyle  		or Enum.EasingStyle.Linear	:: Enum.EasingStyle,
		Direction   = easingDirection  	or Enum.EasingDirection.Out :: Enum.EasingDirection,
		RepeatCount = repeatCount     	or 0                        :: number,
		Reverses    = reverses     		or false                    :: boolean,
		DelayTime   = delayTime     	or 0	                    :: number
	}
end

--[[
	<strong>alpha</strong> is the fraction of the goal.
]]
function LerpMeta:Play(alpha: number)
	-- Prevent yielding
		local self = self :: Lerp
		if not alpha then Debug.warn("Alpha not provided, using default.") alpha = 1 end
		if not self.Object and not self.Cframe then Debug.warn("No cframe and no object provided.") return end
		local CFrameToLerp: CFrame
		if self.Object then
			CFrameToLerp = self.Object.CFrame
		else
			CFrameToLerp = self.Cframe
		end
		
		--[[
			If duration is greater than 0 and the lerp isnt playing
			then, yield, and insert lerp to table.
			
			Else, yield and complete the lerp instantly.
		]]
		if self.Info.Duration > 0 then
			if self.Playing == false then
				self.Playing = true
				task.wait(self.Info.DelayTime)

				self.Alpha   = alpha
				self.Id      = #Lerps + 1
				table.insert(Lerps,self)
				return
			end
		else
			task.wait(self.Info.DelayTime)
			local loop: number = self.Loop
			self.Loop += 1
			self.Completed:Fire()
		end
		
		local Value: CFrame = self.Goal
		local Starting: CFrame = self.Starting
		--[[
			If reverse then, object starting point is goal, and goal
			is the starting point.
			
			Else, object starting point is the starting point and 
			the goal is the goal.
		
			]]
		if self.Reverse then
			CFrameToLerp = Value:Lerp(self.Starting, alpha)
		else
			CFrameToLerp = Starting:Lerp(self.Goal, alpha)
		end
		if not self.Object and self.CurrentCFrame then
			self.CurrentCFrame = CFrameToLerp
		elseif self.Object and not self.CurrentCFrame then
			self.Object.CFrame = CFrameToLerp
		end
end

--[[
Stops the lerp from playing.
]]
function LerpMeta:Stop()
	self.Stopped:Fire()
	Utils.DeleteLerp(Lerps,self:: any)
end

--[[
Deletes the lerp from LerpService.
]]
function LerpMeta:Delete()
	self.Deleted:Fire()
	Utils.DeleteLerp(Lerps,self)
	setmetatable(self,nil)
	table.clear(self)
end


RunService.PostSimulation:Connect(function(deltaTime: number)
	-- Get all lerps
	for index, self : Lerp in pairs(Lerps) do
		self.Time += deltaTime
		local Duration = self.Info.Duration
		local CFrameToLerp 
		if self.Object then
			CFrameToLerp = self.Object.CFrame
		else
			CFrameToLerp = self.Cframe
		end
		
		-- Add delta to lerp time
		local AlphaGoal = self.Alpha
		local alpha = self.Time / Duration
		
		-- Prevent from yielding
			if alpha >= AlphaGoal then
				-- If alpha goal completed
				if self.Info.DelayTime >= 0 then
					if self.DTime <= 0 then
						self.Completed:Fire()
					end
					if self.DTime < self.Info.DelayTime then
						self.DTime += deltaTime
						return 
					end
				else
					self.Completed:Fire()
				end
				
				-- Reset values
				Utils.ResetLerp(self)
				self.Loop += 1
				
				-- Verify repeat count
				if self.Info.RepeatCount > 0 then
					if self.Loop >= self.Info.RepeatCount then
						table.remove(Lerps,index)
					end
				end
				-- Verify loop
				if self.Info.RepeatCount <= -1 or self.Info.RepeatCount > 0 then
					self.Playing = true
					
					-- If reverses then set reverse to (not reverse)
					if self.Info.Reverses then
						self.Reverse = not self.Reverse
						if not self.Reverse then
							CFrameToLerp = self.Starting
						else
							CFrameToLerp = self.Goal
						end
						
					else
						CFrameToLerp = self.Starting
					end
					if not self.Object and self.CurrentCFrame then
						self.CurrentCFrame = CFrameToLerp
					elseif self.Object and not self.CurrentCFrame then
						self.Object.CFrame = CFrameToLerp
					end
					self:Play(0)
				elseif self.Info.RepeatCount == 0 then
					-- If not looping, and repeat count = 0 then stop
					if not self.Object and self.CurrentCFrame then
						self.CurrentCFrame = self.Goal
					elseif self.Object and not self.CurrentCFrame then
						self.Object.CFrame = self.Goal
					end
					
					self.Alpha = 0
					table.remove(Lerps,index)
				end
			else
				-- If goal hasnt been reached then play
				self:Play(TweenService:GetValue(alpha,self.Info.Style,self.Info.Direction))
				self.DTime = 0
			end
			continue
	end
end)

return LerpService
