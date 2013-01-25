-- Default times. These values will be used if the corresponding times aren't passed to the OnLoad function
local DEFAULT_DELAY = 2.0 -- The number of seconds to wait after showing the frame before fading it out.
local DEFAULT_FADE  = 0.5 -- The number of seconds that the frame is faded out over.

-------------------
-- END OF CONFIG --
-------------------

local SPELL_PANELS = {}

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
		
		local panel = SPELL_PANELS[spellID] or SPELL_PANELS[spellName]
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

function SpellPanel_OnLoad(frame, spell, delayTime, fade, fadeTime)
	if frame.isSpellPanel then return end
	frame.isSpellPanel = true
	
	local spellType = type(spell)
	if spellType ~= "string" and spellType ~= "number" then
		error("invalid argument 'spell' to 'SpellPanel_OnLoad' (spell name or spellID expected, got " .. tostring(spell) .. ")")
	end
	
	-- Starts the fade delayTime seconds after the panel is shown
	local delay = frame:CreateAnimationGroup()
	delay:SetScript("OnFinished", SpellPanel.Delay_OnFinished)
	frame.delay = delay
	
	local delayAnim = delay:CreateAnimation("Animation")
	delayAnim:SetDuration(delayTime or DEFAULT_DELAY)
	delay.anim = delayAnim
	
	-- Fades the panel out over fadeTime seconds
	local fadeOut = frame:CreateAnimationGroup()
	fadeOut:SetScript("OnFinished", SpellPanel.FadeOut_OnFinished)
	frame.fadeOut = fadeOut
	
	local fadeOutAnim = fadeOut:CreateAnimation("Alpha")
	fadeOutAnim:SetDuration(fadeTime or DEFAULT_FADE)
	fadeOutAnim:SetChange(-1)
	fadeOut.anim = fadeOutAnim
	
	-- These references make the OnFinished scripts slightly faster by avoiding the need to call :GetRegionParent()
	fadeOut.parent = frame
	delay.fadeOut = fadeOut
	
	frame.HideOrFade = SpellPanel.HideOrFade
	
	-- If the fade paramater wasn't specified, default to true
	frame.fade = (fade == nil) and true or fade
	
	-- Set the OnShow/OnHide scripts:
	frame:HookScript("OnShow", SpellPanel.OnShow)
	-- frame:HookScript("OnHide", SpellPanel.OnHide)
	
	_G["SpellPanel_" .. spell] = frame
	SPELL_PANELS[spell] = frame
end