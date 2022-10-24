version = "1.2.0"
name = "[DST]Xelin "..version
author = "Xelin CretisZ"
description = "---注意：这是我自设的专属私用人物，未经允许请勿使用、盗用、随意上传此模组，感谢配合！\n\nVersion "..version.."(21st Oct. 2022)\n\n\n\n作者&美术部分："..author.."(QQ :2354407596)\n美术支持：是之羽鸭(QQ：1205135061)\n代码部分：Wulmaw(QQ：3029998354)"

forumthread = ""


api_version = 10
priority = 10

dst_compatible = true

dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false

all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {
"Xelin",
"Xelin CretisZ",
"咲灵",
"character",
}

local keys = {"V","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","W","X","Z","0","TAB","MINUS","EQUALS","SPACE","ENTER","ESCAPE","HOME","INSERT","DELETE","END","PAUSE","PRINT","CAPSLOCK","SCROLLOCK","RSHIFT","LSHIFT","RCTRL","LCTRL","RALT","LALT","BACKSPACE","UP","DOWN","RIGHT","LEFT","PAGEUP","PAGEDOWN","F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12","PERIOD","BACKSLASH","SEMICOLON","LEFTBRACKET","RIGHTBRACKET","TILDE","KP_PERIOD","KP_DIVIDE","KP_MULTIPLY","KP_MINUS","KP_PLUS","KP_ENTER","KP_EQUALS","LSUPER","RSUPER"}

local function zhuanyi(key)
    if key == "MINUS" then
        return "-"
    elseif key == "EQUALS" then
        return "="
    elseif key == "SPACE" then
        return "空格"
    elseif key == "ENTER" then
        return "回车"
    elseif key == "ESCAPE" then
        return "Esc"
    elseif key == "CAPSLOCK" then
        return "大写"
    elseif key == "PERIOD" then
        return "."
    elseif key == "BACKSLASH" then
        return "\\"
    elseif key == "SEMICOLON" then
        return ";"
    elseif key == "LEFTBRACKET" then
        return "["
    elseif key == "RIGHTBRACKET" then
        return "]"
    elseif key == "TILDE" then
        return "~"
    elseif key == "KP_PERIOD" then
        return "小键盘 ."
    elseif key == "KP_DIVIDE" then
        return "小键盘 /"
    elseif key == "KP_MULTIPLY" then
        return "小键盘 *"
    elseif key == "KP_MINUS" then
        return "小键盘 -"
    elseif key == "KP_PLUS" then
        return "小键盘 +"
    elseif key == "KP_ENTER" then
        return "小键盘 回车"
    elseif key == "KP_EQUALS" then
        return "小键盘 ="
    elseif key == "LSUPER" then
        return "左 Win"
    elseif key == "RSUPER" then
        return "右 Win"
    elseif key == "LSHIFT" then
        return "左 Shift"
    elseif key == "RSHIFT" then
        return "右 Shift"
    elseif key == "LCTRL" then
        return "左 Ctrl"
    elseif key == "RCTRL" then
        return "右 Ctrl"
    elseif key == "LALT" then
        return "左 Alt"
    elseif key == "RALT" then
        return "右 Alt"
    else
        return key
    end
end

local keylist = {}
for i = 1, #keys do
    keylist[i] = {description = zhuanyi(keys[i]), data = keys[i]}
end

configuration_options =
{
    {
        name = "skill_one",
        label = "不死之躯按键设置",
        options = keylist,
        default = 118,
    },
} 

