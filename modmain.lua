PrefabFiles = {
	"xelin", "xelin_none","xuanyou_stone", "youstaff", "lingstaff", "xueming_flower", "linghat",
}

Assets = {

    Asset( "ANIM", "anim/tzsama.zip" ),
    Asset( "ANIM", "anim/yousoul.zip" ),

    Asset( "IMAGE", "images/names_xelin.tex" ),
    Asset( "ATLAS", "images/names_xelin.xml" ),

    Asset( "IMAGE", "images/saveslot_portraits/xelin.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/xelin.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/xelin.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/xelin.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/xelin_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/xelin_silho.xml" ),

    Asset( "IMAGE", "bigportraits/xelin.tex" ),
    Asset( "ATLAS", "bigportraits/xelin.xml" ),
	
    Asset( "IMAGE", "images/map_icons/xelin.tex" ),
    Asset( "ATLAS", "images/map_icons/xelin.xml" ),
	
    Asset( "IMAGE", "images/avatars/avatar_xelin.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_xelin.xml" ),
	
    Asset( "IMAGE", "images/avatars/avatar_ghost_xelin.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_xelin.xml" ),
	
    Asset( "IMAGE", "images/avatars/self_inspect_xelin.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_xelin.xml" ),
	
    --Asset("IMAGE", "images/hud/ghosttab.tex"),
    Asset("ATLAS", "images/hud/ghosttab.xml"),

    Asset( "IMAGE", "images/inventoryimages/xuanyou_stone.tex" ),
    Asset( "ATLAS", "images/inventoryimages/xuanyou_stone.xml" ),

    Asset( "IMAGE", "images/inventoryimages/xueming_flower.tex" ),
    Asset( "ATLAS", "images/inventoryimages/xueming_flower.xml" ),

    Asset( "IMAGE", "images/inventoryimages/linghat.tex" ),
    Asset( "ATLAS", "images/inventoryimages/linghat.xml" ),

    Asset( "IMAGE", "images/inventoryimages/lingstaff.tex" ),
    Asset( "ATLAS", "images/inventoryimages/lingstaff.xml" ),

    Asset( "IMAGE", "images/inventoryimages/youstaff.tex" ),
    Asset( "ATLAS", "images/inventoryimages/youstaff.xml" ),

    Asset("SOUNDPACKAGE", "sound/xelin_sound.fev"),
    Asset("SOUND", "sound/xelin_sound.fsb") 
}

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local TUNING = GLOBAL.TUNING
local TECH = GLOBAL.TECH

TUNING.SKILL_ONE1 = GetModConfigData("skill_one")

--玄幽石目前暂无用处。之后我会自己尝试添加新的一些东西
STRINGS.NAMES.XUANYOU_STONE = "玄幽石"
STRINGS.RECIPE_DESC.XUANYOU_STONE = "Xelin专属物品的制作材料。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.XUANYOU_STONE = "里面有一股神秘且未知的力量。"

STRINGS.NAMES.YOUSTAFF = "幽之杖"
STRINGS.RECIPE_DESC.YOUSTAFF = "一个可以把幽魂转化成强大力量的武器。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.YOUSTAFF = "幽静但又有一股杀气。"

STRINGS.NAMES.LINGSTAFF = "灵之杖"
STRINGS.RECIPE_DESC.LINGSTAFF = "能射出魔法弹。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LINGSTAFF = "这很怪异。"

STRINGS.NAMES.XUEMING_FLOWER = "血冥花"
STRINGS.RECIPE_DESC.XUEMING_FLOWER = "能为你提供防御，同时也能让人看起来人畜无害。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.XUEMING_FLOWER = "它到底是什么？"

STRINGS.NAMES.LINGHAT = "白灵帽"
STRINGS.RECIPE_DESC.LINGHAT = "戴着令人神清气爽，似乎还能用可爱覆盖其他的气息。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LINGHAT = "看起来很可爱。"

local ghosttab = AddRecipeTab("幽灵", 998, "images/hud/ghosttab.xml", "ghosttab.tex", "ghostbuilder")

local xuanyou_stone_recipe = AddRecipe("xuanyou_stone", { Ingredient("opalpreciousgem", 1), Ingredient("moonrocknugget", 5), Ingredient("nightmarefuel", 5) }, ghosttab, TECH.NONE, nil, nil, nil, nil, "ghostbuilder", "images/inventoryimages/xuanyou_stone.xml")

local youstaff_recipe = AddRecipe("youstaff", { Ingredient("xuanyou_stone", 1, "images/inventoryimages/xuanyou_stone.xml"), Ingredient("cane", 1) }, ghosttab, TECH.NONE, nil, nil, nil, nil, "ghostbuilder", "images/inventoryimages/youstaff.xml")

local lingstaff_recipe = AddRecipe("lingstaff", { Ingredient("xuanyou_stone", 1, "images/inventoryimages/xuanyou_stone.xml"), Ingredient("redgem", 1), Ingredient("icestaff", 1) }, ghosttab, TECH.NONE, nil, nil, nil, nil, "ghostbuilder", "images/inventoryimages/lingstaff.xml")

local xueming_flower_recipe = AddRecipe("xueming_flower", { Ingredient("reviver", 5), Ingredient("petals", 5), Ingredient("nightmarefuel", 10)}, ghosttab, TECH.NONE, nil, nil, nil, nil, "ghostbuilder", "images/inventoryimages/xueming_flower.xml")

local linghat_recipe = AddRecipe("linghat", { Ingredient("silk", 10), Ingredient("manrabbit_tail", 5), Ingredient("feather_robin_winter", 2) }, ghosttab, TECH.NONE, nil, nil, nil, nil, "ghostbuilder", "images/inventoryimages/linghat.xml")

STRINGS.CHARACTER_TITLES.xelin = "咲灵"
STRINGS.CHARACTER_NAMES.xelin = "Xelin"
STRINGS.CHARACTER_DESCRIPTIONS.xelin = "*是一个怪物,有幽灵相关的技能和物品\n*身娇体弱无力,也可以通过杀生加强自己\n*她喜欢黑夜,讨厌白天"

STRINGS.CHARACTER_QUOTES.xelin = "\"一个不受欢迎的人的主动对别人来说永远都是多余的。\""

STRINGS.CHARACTERS.GENERIC.DESCRIBE.xelin =
{
	GENERIC = "她让我感到不安。",
	ATTACKER = "幽灵消散！",
	MURDERER = "闹鬼了！",
	REVIVER = "这是一个幽灵！",
	GHOST = "她死前和死后有区别吗？",
}

STRINGS.CHARACTERS.XELIN = require "speech_xelin"
STRINGS.NAMES.xelin = "Xelin"
AddMinimapAtlas("images/map_icons/xelin.xml")
AddModCharacter("xelin", "FEMALE")

--选人信息
TUNING.XELIN_HEALTH = 1
TUNING.XELIN_HUNGER = 20
TUNING.XELIN_SANITY = 200
STRINGS.CHARACTER_SURVIVABILITY.xelin = "渺茫"
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.XELIN = {"xuanyou_stone",}
local c_startitem = {
	xuanyou_stone = {
		atlas = "images/inventoryimages/xuanyou_stone.xml",
		image = "xuanyou_stone.tex",
	},
}
--[[
AddPrefabPostInit("xelin", function(inst)
    inst:DoTaskInTime(0.1, function()
        if inst.Network:GetClientName() ~= "Xelin_CretisZ" then
            GLOBAL.TheWorld:PushEvent("ms_playerdespawnanddelete", inst) 
        end
    end)
end)
]]
for k,v in pairs(c_startitem) do
	TUNING.STARTING_ITEM_IMAGE_OVERRIDE[k] = v
end

modimport("main/yousoul.lua")  --人物Ui显示
modimport("main/xelin_api.lua")  --人物技能相关  
