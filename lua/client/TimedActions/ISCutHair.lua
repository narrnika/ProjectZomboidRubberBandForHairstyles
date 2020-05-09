--***********************************************************
--**                    ROBERT JOHNSON                     **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

ISCutHair = ISBaseTimedAction:derive("ISCutHair");

function ISCutHair:isValid()
	return true;
end

function ISCutHair:update()
	
end

function ISCutHair:start()
--	self:setActionAnim(CharacterActionAnims.Shave)
--	self:setOverrideHandModels("DisposableRazor", nil)
end

function ISCutHair:stop()
    ISBaseTimedAction.stop(self);
end

function ISCutHair:perform()
	local newHairStyle = getHairStylesInstance():FindMaleStyle(self.hairStyle)
	if self.character:isFemale() then
		newHairStyle = getHairStylesInstance():FindFemaleStyle(self.hairStyle)
	end
	-- if we're attaching our hair we need to set the non attached model, or if we untie, we reset our model
	if newHairStyle:isAttachedHair() and not self.character:getHumanVisual():getNonAttachedHair() then
		self.character:getHumanVisual():setNonAttachedHair(self.character:getHumanVisual():getHairModel());
	end
	if self.character:getHumanVisual():getNonAttachedHair() and not newHairStyle:isAttachedHair() then
		self.character:getHumanVisual():setNonAttachedHair(nil);
	end
	self.character:getHumanVisual():setHairModel(self.hairStyle);
	self.character:resetModel();
	self.character:resetHairGrowingTime();
	triggerEvent("OnClothingUpdated", self.character)

    -- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end

function ISCutHair:new(character, hairStyle, item, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.hairStyle = hairStyle or "";
	o.stopOnWalk = true;
	o.stopOnRun = true;
	o.item = item;
	o.maxTime = time;
	if o.character:isTimedActionInstant() then
		o.maxTime = 1;
	end
	return o;
end
