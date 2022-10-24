local assets =
{
	Asset( "ANIM", "anim/xelin.zip" ),
	Asset( "ANIM", "anim/ghost_xelin_build.zip" ),
}

local skins =
{
	normal_skin = "xelin",
	ghost_skin = "ghost_xelin_build",
}

local base_prefab = "xelin"

local tags = {"xelin", "CHARACTER"}

return CreatePrefabSkin("xelin_none",
{
	base_prefab = base_prefab, 
	skins = skins, 
	assets = assets,
	tags = tags,
	
	skip_item_gen = true,
	skip_giftable_gen = true,
})