
local assets=
{
    Asset("ANIM", "anim/lingstaff.zip"),
	Asset("ANIM", "anim/swap_lingstaff.zip"),
    Asset("ATLAS", "images/inventoryimages/lingstaff.xml"),
}

local prefabs = 
{
	
}

local function onattack(inst, attacker, target)
	if attacker and attacker.components.health then
        attacker.components.health:DoDelta(-3)
    end
end


local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_lingstaff", "swap_orbstaff")
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
	
    inst.AnimState:SetBank("lingstaff")
    inst.AnimState:SetBuild("lingstaff")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("sharp")

	if not TheWorld.ismastersim then
        return inst
    end

	inst.entity:SetPristine()

    --组件列表

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.keepondeath = true
    inst.components.inventoryitem.imagename = "lingstaff"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/lingstaff.xml"
	
	inst:AddComponent("chosenpeople")
	inst.components.chosenpeople:SetChosenFn(OnChosen)
	
    inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
    inst.components.inventoryitem.keepondeath = true
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(80)
	inst.components.weapon:SetOnAttack(onattack)
	inst.components.weapon:SetRange(13, 20)
    inst.components.weapon:SetProjectile("fire_projectile")

    return inst 
end

return  Prefab("common/inventory/lingstaff", fn, assets)