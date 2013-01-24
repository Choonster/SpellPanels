-- Default times. These values will be used if the corresponding times aren't passed to the OnLoad function
local DEFAULT_DELAY = 2.0 -- The number of seconds to wait after showing the frame before fading it out.
local DEFAULT_FADE  = 0.5 -- The number of seconds that the frame is faded out over.

-------------------
-- END OF CONFIG --
-------------------

local CURRENT_PANEL;
local PLAYER_GUID;

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:SetScript("OnEvent", function(self, event, ...)
	self[event](self, ...)
end)

function frame:PLAYER_ENTERING_WORLD()
	PLAYER_GUID = UnitGUID("player")
	
	self:UnreigsterEvent("PLAYER_ENTERING_WORLD")
end

function frame:COMBAT_LOG_EVENT_UNFILTERED(timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
	if event == "SPELL_CAST_START" or event == "SPELL_CAST_SUCCESS" then
		local spellID, spellName, spellSchool = ...
		
		local panel = _G["SpellPanel_" .. spellID] or _G["SpellPanel_" .. spellName] -- Allow SpellPanel-116 or SpellPanel-Frostbolt
		if panel then
			if CURRENT_PANEL then
				CURRENT_PANEL:HideOrFade()
			end
			
			panel:Show()
			CURRENT_PANEL = panel
		end
	end
end

---------------------------
-- Spell Panel Functions --
---------------------------

local SpellPanel = {}

function SpellPanel:HideOrFade()
	self:StopAnimating()
	if self.fade then
		self.fadeOut:Play()
	else
		self:Hide()
	end
end

function SpellPanel:OnShow()
	self.delay:Play()
end

-- function SpellPanel:OnHide()
	-- self:StopAnimating()
-- end

function SpellPanel:Delay_OnFinished()
	self.fadeOut:Play()
end

function SpellPanel:FadeOut_OnFinished()
	self.parent:Hide()
end

function SpellPanel_OnLoad(self, spell, delayTime, fadeTime)
	if self.isSpellPanel then return end
	self.isSpellPanel = true
	
	local spellType = type(spell)
	if spellType ~= "string" and spellType ~= "number" then
		error("invalid argument 'spell' to 'SpellPanel_OnLoad' (spell name or spellID expected, got " .. tostring(spell) .. ")")
	end
	
	-- Starts the fade delayTime seconds after the panel is shown
	local delay = self:CreateAnimationGroup()
	delay:SetScript("OnFinished", SpellPanel_Delay_OnFinished)
	self.delay = delay
	
	local delayAnim = delay:CreateAnimation("Animation")
	delayAnim:SetDuration(delayTime or DEFAULT_DELAY)
	delay.anim = delayAnim
	
	-- Fades the panel out over fadeTime seconds
	local fadeOut = self:CreateAnimationGroup()
	fadeOut:SetScript("OnFinished", SpellPanel_FadeOut_OnFinished)
	self.fadeOut = fadeOut
	
	local fadeOutAnim = fadeOut:CreateAnimation("Alpha")
	fadeOutAnim:SetDuration(fadeTime or DEFAULT_FADE)
	fadeOutAnim:SetChange(-1)
	fadeOut.anim = fadeOutAnim
	
	-- These references make the OnFinished scripts slightly faster by avoiding the need to call :GetRegionParent()
	fadeOut.parent = self
	delay.fadeOut = fadeOut
	
	-- Set the OnShow/OnHide scripts:
	self:SetScript("OnShow", SpellPanel_OnShow)
	-- self:SetScript("OnHide", SpellPanel_OnHide)
	
	_G["SpellPanel_" .. spell] = self
end