local MakePlayerCharacter = require "prefabs/player_common"
local ex_fns = require "prefabs/player_common_extensions"
local cooking = require("cooking")
local cooking_ingredients = cooking.ingredients

local assets = {
  Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
	Asset( "ANIM", "anim/xelin.zip" ),
	Asset( "ANIM", "anim/yousoul.zip" ),
	Asset( "ANIM", "anim/xuanyou_stone.zip" ),
}
local prefabs = {}

----------------------------------------------------------------------

--初始物品
local start_inv = {
	"xuanyou_stone",
}

local function GetHopDistance(inst, speed_mult)
	return speed_mult < 0.8 and TUNING.WILSON_HOP_DISTANCE_SHORT
			or speed_mult >= 1.2 and TUNING.WILSON_HOP_DISTANCE_FAR
			or TUNING.WILSON_HOP_DISTANCE
end

local function ConfigurePlayerLocomotor(inst)
    if inst.components.locomotor == nil then return end

    inst.components.locomotor:Stop()
    inst.components.locomotor:SetSlowMultiplier(0.6)
    inst.components.locomotor.fasteronroad = true
    inst.components.locomotor:SetFasterOnCreep(inst:HasTag("spiderwhisperer"))
    inst.components.locomotor:SetTriggersCreep(not inst:HasTag("spiderwhisperer"))
    inst.components.locomotor:SetAllowPlatformHopping(true)
	  inst.components.locomotor.hop_distance_fn = GetHopDistance
end

local function ConfigureGhostLocomotor(inst)
    if inst.components.locomotor == nil then return end

    inst.components.locomotor:Stop()
    inst.components.locomotor:SetSlowMultiplier(0.6)
    inst.components.locomotor.fasteronroad = false
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor:SetAllowPlatformHopping(false)
end

local function SoulDel(inst)
    if inst._soulcurrent:value() then 
          if inst._soulcurrent:value() < 1 and inst:HasTag("playerghost_falsee") then 
                   inst:TransGhost()
                   if inst.SoulDeltask then inst.SoulDeltask:Cancel() inst.SoulDeltask = nil end
          end 	
     end	
end

--[[不死之躯结束技能时破坏建筑
local function DoDestroy(inst)
   local nottags = {'FX', 'NOCLICK', 'INLIMBO', 'playerghost', 'wall', "abigail", "player"}
   local x, y, z = inst.Transform:GetWorldPosition() 
   local ents = TheSim:FindEntities(x, y, z, 5, nil, nottags) --5的爆炸范围
   for i, ent in ipairs(ents) do
       if ent and ent.components.workable and ent.components.workable:CanBeWorked() 
           and ent.components.workable.action ~= ACTIONS.NET then
           ent.components.workable:Destroy(inst)
       end
   end
end--]]

local function OnBomb(inst)
    --DoDestroy(inst)
    local nottags = {'FX', 'NOCLICK', 'INLIMBO', 'playerghost', 'wall', "abigail", "player"}
    local x, y, z = inst.Transform:GetWorldPosition() 
    local ents = TheSim:FindEntities(x, y, z, 5, { "_combat" }, nottags) --5的爆炸范围

          for i, ent in ipairs(ents) do
              if ent then  --and inst.components.combat:CanTarget(ent)
                    inst:PushEvent("onareaattackother", { target = ent, weapon = nil, stimuli = nil })

                    local base_damage = inst.xelin_level

                    if ent:IsNear(inst, 1) then  --周围怪物距离人物距离小于等于1时
                         ent.components.combat:GetAttacked(inst, 3*base_damage, inst, nil)

                    elseif ent:IsNear(inst, 2) then  --周围怪物距离人物距离小于等于2时
                         ent.components.combat:GetAttacked(inst, 2.5*base_damage, inst, nil)

                    elseif ent:IsNear(inst, 3) then  --周围怪物距离人物距离小于等于3时 
                         ent.components.combat:GetAttacked(inst, 2*base_damage, inst, nil)

                    elseif ent:IsNear(inst, 4) then  --周围怪物距离人物距离小于等于4时 
                         ent.components.combat:GetAttacked(inst, 1.5*base_damage, inst, nil)
                    else
                          ent.components.combat:GetAttacked(inst, base_damage, inst, nil)
                    end      
              end
        end

       local impactfx = SpawnPrefab("explosivehit")
       impactfx.Transform:SetScale(1.2, 1.2, 1.2)
       impactfx.Transform:SetPosition(inst:GetPosition():Get())
end

local function GhostActionFilter(inst, action)
    return action.ghost_valid--(action.ghost_valid and inst._isghosted:value()) or action--or (inst:HasTag("playerghost_falsee") and inst:HasTag("layerghost_false"))
end

local function ConfigureGhostActions(inst)
    if inst.components.playeractionpicker ~= nil then
        inst.components.playeractionpicker:PushActionFilter(GhostActionFilter, 99)
    end
end

local function ConfigurePlayerActions(inst)
    if inst.components.playeractionpicker ~= nil then
        inst.components.playeractionpicker:PopActionFilter(GhostActionFilter)
    end
end

local function NoTarget(inst)
  local nottags = {'FX', 'NOCLICK', 'INLIMBO', 'playerghost', 'wall', "companion", "abigail", "player", "chester", "glommer"}
  local x, y, z = inst.Transform:GetWorldPosition() 
  local ents = TheSim:FindEntities(x, y, z, 40, { "_combat" }, nottags) --5的爆炸范围

        for i, ent in ipairs(ents) do
            if ent and ent.components.combat and ent.components.combat.target and ent.components.combat.target == inst then
                    ent.components.combat:DropTarget()
            end
      end
end

local function OnTransGhost(inst) 
local x, y, z = inst.Transform:GetWorldPosition()
--local Cd = inst.components.timer ~= nil and (inst.components.timer:GetTimeLeft("TransGhost_Cd") or 0) or nil
   inst:Show()
   if not inst:HasTag("playerghost_falsee") and not inst:HasTag("layerghost_false") then  --cd中无法使用该技能  -- and (Cd == nil or (Cd and Cd <= 0))
       NoTarget(inst)
   	   inst:AddTag("layerghost_false")
   	   inst:AddTag("notarget")
       inst:AddTag("playerghost_falsee") 
       --inst:AddTag("playerghost") 
       inst.AnimState:SetBank("ghost")
       inst.AnimState:SetBuild("ghost_xelin_build") 
       inst.AnimState:SetLightOverride(TUNING.GHOST_LIGHT_OVERRIDE)

      if inst:HasTag("groggy") then
            inst:RemoveTag("groggy")
            inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "groggyed")
      end

       MakeGhostPhysics(inst, 1, .5)
       inst.Physics:Teleport(x, y, z)

       --ConfigureGhostLocomotor(inst)
       ex_fns.ConfigureGhostActions(inst)

       inst.SoundEmitter:KillSound("eating")
       inst.SoundEmitter:KillAllSounds()

       if inst.components.inventory then
              inst.components.inventory:Show()
       end       

       if inst.components.playercontroller ~= nil then
              inst.components.playercontroller:EnableMapControls(true)
              inst.components.playercontroller:Enable(true)
       end


       if inst.components.hunger then
             inst.components.hunger:Pause()
       end

       if inst.components.health then
             inst.components.health.invincible = true
             inst.components.health.canheal = false
       end

      --鬼魂状态下加移速
      if inst.components.locomotor then
            local level = inst.xelin_level
            inst.components.locomotor.walkspeed = (5 + level/60)
	      inst.components.locomotor.runspeed = (7 + level/60)
      end

       if inst.components.moisture then 
             inst.components.moisture:SetPercent(0) 
       end

       if inst.components.sheltered then
             inst.components.sheltered:Stop()
       end

       if inst.components.debuffable then
            inst.components.debuffable:Enable(false)
       end

       if inst.components.combat then
             inst.components.combat:SetRange(-1)
       end 

       if inst.components.burnable and inst.components.burnable:IsBurning() then
            inst.components.burnable:Extinguish()
       end	

       if inst.components.temperature then
             inst.components.temperature:SetTemperature(20)
       end            	

       inst.DynamicShadow:Enable(false)
      
       inst.player_classified:SetGhostMode(true)

       inst._isghosted:set(true)

       inst.components.bloomer:PushBloom("playerghostbloom", "shaders/anim_bloom_ghost.ksh", 100)

       inst:SetStateGraph("SGwilsonghost")

       inst.SoulDeltask = inst:DoPeriodicTask(0.5, function() SoulDel(inst) end)

       if inst._soulcurrent:value()-5 >= 0 then inst._soulcurrent:set(inst._soulcurrent:value()-5)--每次使用减5幽魂值
       else inst._soulcurrent:set(0) end

      -- inst.components.health:Kill() 
   elseif inst:HasTag("playerghost_falsee") and inst:HasTag("layerghost_false") then

       inst:RemoveTag("layerghost_false")
       inst:RemoveTag("notarget")
       inst:RemoveTag("playerghost_falsee") 
       inst:SetStateGraph("SGwilson") 

       inst.AnimState:SetBank("wilson")
       inst.AnimState:SetBuild("xelin")
       inst.AnimState:SetLightOverride(0)

       MakeCharacterPhysics(inst, 75, .5)
       inst.Physics:Teleport(x, y, z)

       OnBomb(inst)

       ConfigurePlayerLocomotor(inst)
       ex_fns.ConfigurePlayerActions(inst)

       if inst.components.hunger then
             inst.components.hunger:Resume()
       end	

       if inst.components.health then
             inst.components.health.invincible = false
             inst.components.health.canheal = true
       end

       if inst.components.locomotor then
            inst.components.locomotor.walkspeed = 6
	      inst.components.locomotor.runspeed = 7
      end

       if inst.components.sheltered then
             inst.components.sheltered:Stop()
       end

       if inst.components.debuffable then
            inst.components.debuffable:Enable(false)
       end

       if inst.components.combat then
             inst.components.combat:SetRange(TUNING.DEFAULT_ATTACK_RANGE)
       end 

       inst.components.timer:StartTimer("TransGhost_Cd", 0.2)--cd0.2秒

       inst.DynamicShadow:Enable(true)

       inst.player_classified:SetGhostMode(true)
       inst.player_classified:SetGhostMode(false)
       inst._isghosted:set(false)

       inst.components.bloomer:PopBloom("playerghostbloom") 

       if inst.SoulDeltask then inst.SoulDeltask:Cancel() inst.SoulDeltask = nil end
       --inst:PushEvent("respawnfromghost", { source = inst }) 

   end
end

local function UnEquip(inst, data)
       print(data.eslot)
       if (data.item and data.item:HasTag("backpack")) or (data.eslot and EQUIPSLOTS.BACK and data.eslot == EQUIPSLOTS.BACK) then  --装备背包时
             inst.equipbacktask = inst:DoTaskInTime(0, function()
                  inst.AnimState:ClearOverrideSymbol("swap_body")
                  inst.AnimState:ClearOverrideSymbol("backpack")

                  inst.equipbacktask = nil 
             end)            
       end
end

--鬼魂{
local function onbecamehuman(inst)
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "xelin_speed_mod")
end

local function onbecameghost(inst)
   inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "xelin_speed_mod")
end

local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
end
--鬼魂}


--一天三个时期对san值的影响
local function sanityfn(inst)
	local delta = 0
	if TheWorld.state.phase == "day" then
		delta = (-6*TUNING.DAPPERNESS_SMALL)
	end
	if TheWorld.state.phase == "dusk" then
		delta = (4*TUNING.DAPPERNESS_SMALL)

elseif TheWorld.state.phase == "night" then
		delta = (7.5*TUNING.DAPPERNESS_SMALL)
	
  	end
    
    return delta
end

--满月特殊状态
local function OnIsFullmoon(inst, isfullmoon)
	if isfullmoon then
		inst.components.sanity.dapperness = TUNING.DAPPERNESS_MED*7
		inst.components.health:StartRegen(5, 1)
		inst.components.health:SetAbsorptionAmount(0.75)

	else
		inst.components.sanity.dapperness = 0
		inst.components.health:StartRegen(0, 0)
		inst.components.health:SetAbsorptionAmount(0.0)
	end
end

local function oneat(inst, food) 
	if food and food.components.edible then
		if food.prefab == "monstermeat" then
			inst.components.health:DoDelta(20)--(-20+20)
			inst.components.sanity:DoDelta(15)--(-15+15)

		elseif food.prefab == "cookedmonstermeat" then
			inst.components.health:DoDelta(3)--(-3+3)
			inst.components.sanity:DoDelta(10)--(-10+10)
	
		elseif food.prefab == "monstermeat_dried" then
			inst.components.health:DoDelta(3)--(-3+3)
			inst.components.sanity:DoDelta(2)--(-2+-2)

            else
                  --吃月亮相关的食物加幽魂值
                  local num = -100
                  if food.prefab == "shroomcake" then num=inst._soulcurrent:value()+60
                  elseif (food.prefab == "rock_avocado_fruit_ripe_cooked" or food.prefab == "moon_cap_cooked") then num = inst._soulcurrent:value()+30
                  elseif (food.prefab == "rock_avocado_fruit_ripe" or food.prefab == "moon_tree_blossom" or food.prefab == "moon_cap" or food.prefab == "moonbutterflywings") then num=inst._soulcurrent:value()+10
                  end

                  if num~=-100 then     
                        inst.SoundEmitter:PlaySound("xelin_sound/xelin_sound/oneat", nil, 1)
                        if num < inst._soulmax:value() then inst._soulcurrent:set(num)
                        else inst._soulcurrent:set(inst._soulmax:value()) end
                  end

            end
	end
end

--黄昏/晚上/在洞穴 发光
local function lightsource(inst)
	if TheWorld.state.phase == "day" then
		inst.Light:Enable(false)
		
		
	elseif TheWorld.state.phase == "dusk" then
		inst.Light:Enable(true)
	
	elseif TheWorld.state.phase == "night" then
		inst.entity:AddLight()
		inst.Light:Enable(true)
		inst.Light:SetRadius(1)
		inst.Light:SetFalloff(1)
		inst.Light:SetIntensity(0.3)
		inst.Light:SetColour(120/255,170/255,102/255)
	end
end

local function UpdateStatus(inst)
	local level = inst.xelin_level
	local hunger_percent = inst.components.hunger:GetPercent()
	local health_percent = inst.components.health:GetPercent()

      inst._soulmax:set(100 + level)
      inst._soulcurrent:set(inst._soulcurrent:value()+1)

	if level <= 80 then
	inst.components.hunger.max = (20 + level * 1)
	inst.components.health.maxhealth = (level*0.75)
	
	
	elseif level > 80 and level <= 90 then
	inst.components.hunger.max = 100
	inst.components.health.maxhealth = (level*0.75)
	
	elseif level >= 100 then
	inst.components.hunger.max = 100
	inst.components.health.maxhealth = 75
	
	end

	inst.components.hunger:SetPercent(hunger_percent)
	inst.components.health:SetPercent(health_percent)
		
end

local function LevelupRec(inst)
      if inst.xelin_expcurrent >= inst.xelin_expmax then
            inst.xelin_level = inst.xelin_level + 1
            inst.xelin_expcurrent = inst.xelin_expcurrent - inst.xelin_expmax
            inst.xelin_expmax = 1 + math.floor(inst.xelin_level/20)
            return LevelupRec(inst)
      end
end

local function LevelupTrigger(inst, data)--杀生升级触发器
      local victim = data.victim
      local expdelta

      if victim and victim:HasTag("epic") then expdelta = 40
      elseif victim and victim:HasTag("largecreature") then expdelta = 5
      else expdelta = 1 end
      inst.xelin_expcurrent = inst.xelin_expcurrent + expdelta

      if inst.xelin_expmax and inst.xelin_level ~= 0 then LevelupRec(inst) end


      UpdateStatus(inst)
      inst.components.talker:Say("当前经验："..inst.xelin_expcurrent.."/"..inst.xelin_expmax.."，当前等级："..inst.xelin_level) --触发对话
end



local function onpreload(inst, data)
	if data then
		if data.xelin_level then
			inst.xelin_level = data.xelin_level
			UpdateStatus(inst)
		end

            if data.health and data.health.health then
                  inst.components.health.currenthealth = data.health.health
            end
		if data.hunger and data.hunger.hunger then
                  inst.components.hunger.current = data.hunger.hunger
            end
		inst.components.health:DoDelta(0)
		inst.components.hunger:DoDelta(0)

            if data.expcurrent then
                  inst.xelin_expcurrent = data.expcurrent
            end
            if data.expmax then
                  inst.xelin_expmax = data.expmax
            end

            if data.soulnum then
                  inst.soulnum = data.soulnum
                  inst._soulcurrent:set(inst.soulnum)
            end 
	 end
end

local function onsave(inst, data)
	data.xelin_level = inst.xelin_level
      data.xelin_expcurrent = inst.xelin_expcurrent
      data.xelin_expmax = inst.xelin_expmax
	data.charge_time = inst.charge_time
  data.soulnum = inst.soulnum or inst._soulmax:value()

--[[
  if data.is_ghost and inst:HasTag("layerghost_false") then
        data.is_ghost = false
  end
  ]]   
end

--标签
local common_postinit = function(inst)
  inst:AddTag("ghostbuilder")
  inst:AddTag("monster")
  inst:AddTag("ghost")
  inst:AddTag("noauradamage")
  inst:AddTag("xelin")
	
  inst._soulmax = net_ushortint(inst.GUID, "soul.current", "soulmaxdirty")
  inst._soulmax:set(100)

  inst._soulcurrent = net_ushortint(inst.GUID, "soul.max", "soulcurrentdirty")
  inst._soulcurrent:set(100)

  inst._soulratescale = net_tinybyte(inst.GUID, "soul.ratescale")
  inst._soulratescale:set(1)
	--地图上的标志
  inst.MiniMapEntity:SetIcon( "xelin.tex" )

  inst._isghosted = net_bool(inst.GUID, "isghosted", "isghosteddirty")
  inst._isghosted:set(false)

  inst:ListenForEvent("isghosteddirty", function(inst)  
        if inst._isghosted:value() == false then
             --print("不可以闹鬼")
             --ex_fns.ConfigureGhostActions(inst)
             --ex_fns.ConfigurePlayerActions(inst)
             ConfigurePlayerActions(inst)
             --inst:SetStateGraph("SGwilson_client")
             inst.components.playervision:SetGhostVision(false)
        else 
             --print("闹鬼")
        	   ConfigureGhostActions(inst)

             --inst:SetStateGraph("SGwilsonghost_client")       
             inst.components.playervision:SetGhostVision(true)
        end	
  end)
end

local master_postinit = function(inst)

	inst.soundsname = "wendy"
	--人物参数
	inst:AddComponent("reader")

      inst.xelin_expcurrent = 0
      inst.xelin_expmax = 1
	inst.xelin_level = 1
      inst.soulnum = 100

	inst.components.health:SetMaxHealth(1) --1
	inst.components.hunger:SetMax(20)  --20
	inst.components.sanity:SetMax(200) --200

	inst.components.locomotor.walkspeed = (6)
	inst.components.locomotor.runspeed = (7)
	inst.components.combat.damagemultiplier = 0.5
	inst.components.hunger.hungerrate = 0.7 * TUNING.WILSON_HUNGER_RATE
	inst.components.sanity.dapperness = 0
	inst.components.temperature.overcoldtemp = 50

  inst.TransGhost = OnTransGhost  --变成鬼魂函数  --GetPlayer():TransGhost() GetPlayer():SetGhostMode()
	inst.OnLoad = onload
  inst.OnNewSpawn = onload

	inst.components.sanity.custom_rate_fn = sanityfn

  if inst.components.timer == nil then
        inst:AddComponent("timer")
  end

  inst:ListenForEvent("equip", UnEquip)

	local rft = 1/5
	inst:DoPeriodicTask(rft, function() lightsource(inst, rft) end)--激活黄昏和晚上发光
	inst:WatchWorldState("isfullmoon", OnIsFullmoon)--满月事件
	OnIsFullmoon(inst, TheWorld.state.isfullmoon)--满月事件

	inst:ListenForEvent("killed", LevelupTrigger)

	inst:DoPeriodicTask(0.5, function() 
	     local rate = 0 
         if inst:HasTag("layerghost_false") then  --鬼魂状态下每秒扣除2点
         	    rate = rate - 1
         end     
         
         if inst.sg and inst.sg:HasStateTag("sleeping") and not inst:HasTag("playerghost_falsee") then  --睡觉每秒回复1点
               rate = rate + 1
         end

         --[[
            if (TheWorld.state.phase == "night" or TheWorld:HasTag("cave")) and not inst:HasTag("playerghost_falsee") then  --夜晚或者在洞穴里时每秒回复1点
            rate = rate + 1
            print("夜晚或洞穴+1") 
      end
      ]]

         if (TheWorld.state.isfullmoon or (inst.components.areaaware and inst.components.areaaware:CurrentlyInTag("lunacyarea"))) and not inst:HasTag("playerghost_falsee")  then  --月圆或者在月岛的话每秒恢复3点
               rate = rate + 1.5
         end

         if rate < 0 then  --and rate >= -0.5   
              -- inst._soulratescale:set(RATE_SCALE.DECREASE_LOW)

        -- elseif rate < -0.5 then 
               inst._soulratescale:set(RATE_SCALE.DECREASE_MED)

         elseif rate == 0 then 
               inst._soulratescale:set(0) 
      
         elseif rate >= 1 and rate < 2 then
               inst._soulratescale:set(RATE_SCALE.INCREASE_LOW)

         elseif rate >= 2 and rate < 3.5 then
               inst._soulratescale:set(RATE_SCALE.INCREASE_MED) 

         elseif rate >= 3.5 then
               inst._soulratescale:set(RATE_SCALE.INCREASE_HIGH)                            
         end

         if inst._soulcurrent:value() then
         	   local num = inst._soulcurrent:value()+rate

         	   if num >= inst._soulmax:value() then
                  inst._soulcurrent:set(inst._soulmax:value())
                 -- print("1")

         	   elseif num <= 0 then
         	        inst._soulcurrent:set(0)
                 -- print("2")

         	   else
                  --print(rate)
                  --print(num)	
                 -- inst._soulcurrent:set(inst._soulcurrent:value()+rate)
                  inst._soulcurrent:set(inst._soulcurrent:value()+rate)
             end

             inst.soulnum = inst._soulcurrent:value()      
         end
         
      if (inst:HasTag("playerghost") or (inst.components.hunger:GetPercent() >= 0.25 
           and inst._soulcurrent:value()/inst._soulmax:value() >= 0.25 and inst.components.health:GetPercent() >= 0.25 and inst.components.sanity:GetPercent() >= 0.25)) then

               inst:RemoveTag("groggy")
               inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "groggyed")  
           return 
      end  


      if not inst:HasTag("layerghost_false") and (inst.components.hunger:GetPercent() < 0.25 or inst._soulcurrent:value()/inst._soulmax:value() < 0.25 or inst.components.health:GetPercent() < 0.25 or inst.components.sanity:GetPercent() < 0.25) then  --data.newpercent and 
               if not inst:HasTag("groggy") then
                    inst:AddTag("groggy")
             end
             inst.components.locomotor:SetExternalSpeedMultiplier(inst, "groggyed", 0.6)   
      end
	end)
	inst.components.eater:SetOnEatFn(oneat)--吃东西

	inst.OnSave = onsave
	inst.OnPreLoad = onpreload
end

return MakePlayerCharacter("xelin", prefabs, assets, common_postinit, master_postinit, start_inv)