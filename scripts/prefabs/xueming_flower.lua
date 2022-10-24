
local assets=
{
	Asset("ANIM", "anim/xueming_flower.zip"),
	Asset("IMAGE", "images/inventoryimages/xueming_flower.tex"),
	Asset("ATLAS", "images/inventoryimages/xueming_flower.xml"),
}

local prefabs =
{
}
local function onequiphat(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "xueming_flower", "swap_hat")
        owner.AnimState:Show("HAT")
        owner.AnimState:Hide("HAIR_HAT")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")
        
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAIR")
        
    inst.monster = owner:HasTag("monster")
    owner:RemoveTag("monster")

end

local function onunequiphat(inst, owner)
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")
    
    if inst.monster then			
        inst.monster = nil
        owner:AddTag("monster")
    end

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
    end
end

local function finished(inst)
        inst:Remove()
end

local function OnChosen(inst,owner)
	return owner.prefab == "xelin"
end 

local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("xueming_flower")
    inst.AnimState:SetBuild("xueming_flower")
    inst.AnimState:PlayAnimation("anim")

	inst:AddTag("hat")
	inst:AddTag("hide")
    	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
		
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/xueming_flower.xml"
       
    inst:AddComponent("chosenpeople")
	inst.components.chosenpeople:SetChosenFn(OnChosen)

	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
	inst.components.equippable:SetOnEquip( onequiphat )
    inst.components.equippable:SetOnUnequip( onunequiphat )


    inst:AddComponent("armor")
    inst.components.armor:InitCondition(1250,0.8)

	
	MakeHauntableLaunchAndPerish(inst)
    return inst
end 
    
return Prefab( "xueming_flower", fn, assets, prefabs) 