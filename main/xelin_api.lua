GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

------------
AddPrefabPostInit("xelin", function(inst)
      if not TheWorld.ismastersim then
           return inst
      end

      local _getAttacked = inst.components.combat.GetAttacked
      inst.components.combat.GetAttacked = function(self, attacker, damage, weapon, stimuli)
                if damage and damage > 0 then  --受到的所有伤害增加0.35
                      damage = damage * 1.35  
               end   
           return _getAttacked(self, attacker, damage, weapon, stimuli) 
      end

      local _getHealth = inst.components.health.DoDelta
                 inst.components.health.DoDelta = function(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
                         if amount < 0 and amount + self.currenthealth <= 0 and inst._soulcurrent:value() >= 40 and not inst:HasTag("playerghost") and not inst:HasTag("layerghost_false") then
                               amount = 0
                               self.currenthealth = inst.components.health.maxhealth  --回满血
                               inst._soulcurrent:set(inst._soulcurrent:value()-35)
                               inst.components.timer:SetTimeLeft("TransGhost_Cd", 0)
                               inst.SoundEmitter:PlaySound("xelin_sound/xelin_sound/ondeath") 
                               inst:TransGhost()                                            
                       end   
                                                            
               return _getHealth(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb) 
        end 
end)

if TUNING.SKILL_ONE1 then  --按键释放技能相关
local function Skill1(inst)
   local Buff_Cd = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("TransGhost_Cd") or 0) or nil
      if Buff_Cd and Buff_Cd > 0 and inst.components.talker then
           --inst.components.talker:Say("还要等一下下，就快好了...") 
      else
           if inst:HasTag("playerghost_falsee") then
                  inst:TransGhost(inst) 
                  inst.SoundEmitter:PlaySound("xelin_sound/xelin_sound/skillone_end", nil, 1)

           elseif not inst:HasTag("playerghost_falsee") and not inst.components.freezable:IsFrozen() then
                  inst:TransGhost(inst) 
                  inst.SoundEmitter:PlaySound("xelin_sound/xelin_sound/skillone_start", nil, 1) 
           end    
      end   
end 

AddModRPCHandler(modname, "Skill1", Skill1)

local function Talk(inst)
      if inst.components.talker then
             inst.components.talker:Say("已经不行了...")--能量不足触发的对话
      end  
end

AddModRPCHandler(modname, "Talk", Talk)

local KEY1 = _G["KEY_"..GetModConfigData("skill_one")]

TheInput:AddKeyDownHandler(KEY1, function()
local player = ThePlayer
local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
local IsHUDActive = screen and screen.name == "HUD"

        if player and player.prefab == "xelin" and not player:HasTag("playerghost") and player.player_classified and player.player_classified.isfadein:value() == true
            and IsHUDActive then
            if player._soulcurrent:value() and player._soulcurrent:value() > 4 then
                   SendModRPCToServer(MOD_RPC[modname]["Skill1"])

            elseif player._soulcurrent:value() and player._soulcurrent:value() <= 4 then
                   SendModRPCToServer(MOD_RPC[modname]["Talk"])
            end       
       end 
end)
end