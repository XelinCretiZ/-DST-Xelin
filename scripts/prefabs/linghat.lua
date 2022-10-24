local assets=
{
	Asset("ANIM", "anim/linghat.zip"),
	Asset("ATLAS", "images/inventoryimages/linghat.xml"),
}

local function onequip(inst, owner, smotherer) 
    owner.AnimState:OverrideSymbol("swap_hat", "linghat", "swap_hat")
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAIR_HAT")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")

    inst.monster = owner:HasTag("monster")
    owner:RemoveTag("monster")

    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAT")
    end

    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_hat")
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

    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
end

local function OnChosen(inst,owner)
	return owner.prefab == "xelin"
end 

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
	inst.entity:AddNetwork()
    
    inst:AddTag("hat")
	
    anim:SetBank("linghat")
    anim:SetBuild("linghat")
    anim:PlayAnimation("anim")    
        
    inst:AddComponent("inspectable")

    if not TheWorld.ismastersim then
        return inst
    end

    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/linghat.xml"
    
	inst:AddComponent("chosenpeople")
	inst.components.chosenpeople:SetChosenFn(OnChosen)
	
    inst:AddComponent("equippable")

    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED*2.4
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )

    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(TUNING.INSULATION_MED)
    
    inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(TUNING.FEATHERHAT_PERISHTIME)
        inst.components.fueled:SetDepletedFn(inst.Remove)

    return inst
end

return Prefab( "linghat", fn, assets) 
