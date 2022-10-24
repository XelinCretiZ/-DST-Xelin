local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"

local YouSoul = Class(Badge, function(self, owner)
	Badge._ctor(self, "yousoul", owner)

    self.anim:GetAnimState():SetBank("health")
    self.anim:GetAnimState():PlayAnimation("anim", true)

    self.soultz = self.underNumber:AddChild(UIAnim())
    self.soultz:GetAnimState():SetBank("sanity_arrow")
    self.soultz:GetAnimState():SetBuild("sanity_arrow")
    self.soultz:GetAnimState():PlayAnimation("neutral")	
	self.soultz:SetClickable(false)

	self:StartUpdating()
end)

local RATE_SCALE_ANIM =
{
    [RATE_SCALE.INCREASE_HIGH] = "arrow_loop_increase_most",
    [RATE_SCALE.INCREASE_MED] = "arrow_loop_increase_more",
    [RATE_SCALE.INCREASE_LOW] = "arrow_loop_increase",
    [RATE_SCALE.DECREASE_HIGH] = "arrow_loop_decrease_most",
    [RATE_SCALE.DECREASE_MED] = "arrow_loop_decrease_more",
    [RATE_SCALE.DECREASE_LOW] = "arrow_loop_decrease",
}

function YouSoul:OnUpdate(dt)
   -- print(self.owner.prefab)

    local max = self.owner._soulmax:value() or 100
    local newpercent = self.owner._soulcurrent:value()/max or 1
    self:SetPercent(newpercent, max)

    if newpercent == 1 then
         self.soultz:Hide()
    else
         self.soultz:Show()       
    end 

    local anim = "neutral"
    local ratescale = self.owner._soulratescale:value() --GetPlayer()._soulratescale:set(RATE_SCALE.DECREASE_MED)
        if ratescale == RATE_SCALE.INCREASE_LOW or
            ratescale == RATE_SCALE.INCREASE_MED or
            ratescale == RATE_SCALE.INCREASE_HIGH or
            ratescale == RATE_SCALE.DECREASE_LOW or
            ratescale == RATE_SCALE.DECREASE_MED or
            ratescale == RATE_SCALE.DECREASE_HIGH then
            anim = RATE_SCALE_ANIM[ratescale]
        end

    if self.arrowdir ~= anim then
        self.arrowdir = anim
        self.soultz:GetAnimState():PlayAnimation(anim, true)
    end

    if self.owner and self.owner:HasTag("playerghost") then
            self:Hide()
    else
            self:Show()  
    end    
end

return YouSoul