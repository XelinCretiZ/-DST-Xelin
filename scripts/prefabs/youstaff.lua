
local assets=
{
    Asset("ANIM", "anim/youstaff.zip"),
	Asset("ANIM", "anim/swap_youstaff.zip"),
    Asset("ATLAS", "images/inventoryimages/youstaff.xml"),
    Asset("IMAGE", "images/inventoryimages/youstaff.tex"),
}

local prefabs = 
{
	
}

local function onattack(inst, attacker, target)
	if attacker and attacker.components.sanity and attacker.components.health then
        attacker.components.sanity:DoDelta(-1)
        attacker.components.health:DoDelta(-1)
    end
end


local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_youstaff", "swap_youstaff")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function OnChosen(inst,owner)
	return owner.prefab == "xelin"
end 

--主要功能
local function fn()
	
	local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("youstaff")
    inst.AnimState:SetBuild("youstaff")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("sharp")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.entity:SetPristine()


    --用鼠标进行传送
    local function blinkstaff_reticuletargetfn()
        local player = ThePlayer
        local rotation = player.Transform:GetRotation() * DEGREES
        local pos = player:GetPosition()
        for r = 13, 1, -1 do
            local numtries = 2 * PI * r
            local pt = FindWalkableOffset(pos, rotation, r, numtries)
            if pt ~= nil then
                return pt + pos
            end
        end
    end

    --传送者
    local function onblink(staff, pos, caster)
        if caster.components.sanity ~= nil then
            caster.components.sanity:DoDelta(-1)
        end
    end 

    --组件列表
    inst:AddComponent("blinkstaff")
    inst.components.blinkstaff.onblinkfn = onblink

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.keepondeath = true
    inst.components.inventoryitem.imagename = "youstaff"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/youstaff.xml"
	
	inst:AddComponent("chosenpeople")
	inst.components.chosenpeople:SetChosenFn(OnChosen)
	
    inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
	inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(150)
	inst.components.weapon:SetOnAttack(onattack)

    return inst 
end

return  Prefab("common/inventory/youstaff", fn, assets)