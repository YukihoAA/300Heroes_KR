include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")


-------安全锁小界面

local PasswordInputEdit = nil
local PasswordInput = nil
local PasswordInputText = nil

local BTNA_font = nil
local font_btn = {"强制开锁","取消开锁"}
local press_index = 0

local posx_move = -240
local posy_move = -150

function InitSetup_PassWord(wnd, bisopen)
	g_PassWord_ui = CreateWindow(wnd.id, 0, 0, 1920, 1080)
	g_PassWord_ui:EnableBlackBackgroundTop(1)
	InitMain_Setup_PassWord(g_PassWord_ui)
	g_PassWord_ui:SetVisible(bisopen)
end

function InitMain_Setup_PassWord(wnd)

		--------账户安全锁小界面
	
	g_PassWord_ui:AddImage(path_setup.."safeBK_setup.png",461,218,363,233)
	g_PassWord_ui:AddFont("请输入安全密码",12, 0, 592, 230, 400, 20, 0x83d1e7)
	g_PassWord_ui:AddFont("输入密码",12, 0, 497, 290, 100, 20, 0x83d1e7)
	g_PassWord_ui:AddFont("※ 密码最多15个字符或数字，不支持中文",11, 0, 560, 345, 300, 20, 0xb27936)
	
	
	local BTNA = g_PassWord_ui:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",505,388,83,35)
	BTNA_font = BTNA:AddFont(font_btn[1], 15, 0, 8, 7, 100, 20, 0xc7bcf6)
	BTNA.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XPassWordBTNABtnClick()
		g_PassWord_ui:SetVisible(0)
	end
	local BTNB = g_PassWord_ui:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",604,388,83,35)
	BTNB:AddFont("确定", 15, 0, 22, 7, 100, 20, 0xc7bcf6)
	BTNB.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XPassWordComfirm(PasswordInput:GetEdit())
		g_PassWord_ui:SetVisible(0)
	end
	local BTNC = g_PassWord_ui:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",700,388,83,35)
	BTNC:AddFont("取消", 15, 0, 22, 7, 100, 20, 0xc7bcf6)
	BTNC.script[XE_LBUP] = function()
		XClickPlaySound(5)
		g_PassWord_ui:SetVisible(0)
		XPassWordClose()
	end
	
	PasswordInputEdit = CreateWindow(g_PassWord_ui.id, 560,285, 256, 32)
	PasswordInput = PasswordInputEdit:AddEdit(path_setup.."passEdit_setup.png","","onReleasePassword_Enter","",20,0,0,225,30,0xffffffff,0xff000000,1,"")
	XEditSetMaxByteLength(PasswordInput.id,15)
	XEditInclude(PasswordInput.id,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz`1234567890-=;',./~!@#$%^&*()_+{}|:<>?[]\\")
	
	g_PassWord_ui:SetVisible(0)
end

function SetPasswordInputBTNA_font()
    local ibool = XGetifSetCancel()
    if(ibool == 1) then
	    BTNA_font:SetFontText(font_btn[1],0xc7bcf6)
	else
	    BTNA_font:SetFontText(font_btn[2],0xc7bcf6)
	end	
end

function check_Setup_PassWordIsVisible()
    if(g_PassWord_ui:IsVisible()) then
	    return true
	else
	    return false
	end
end

function check_Setup_PassWordCallReturn()
     if(g_PassWord_ui:IsVisible()) then
		XClickPlaySound(5)
		XPassWordComfirm(PasswordInput:GetEdit())
		g_PassWord_ui:SetVisible(0)
	 end
end


function Set_Setup_PassWordIsVisible(flag) 
	if g_PassWord_ui ~= nil then
		if flag == 1 and g_PassWord_ui:IsVisible() == false then
			g_PassWord_ui:CreateResource()
            g_PassWord_ui:SetVisible(1)
			PasswordInput:SetEdit("")
			PasswordInput:SetFocus(1)
			SetPasswordInputBTNA_font()
			CancelAutaStrength()--此时需要判断一下 如果在自动强化状态 需要取消
		elseif flag == 0 and g_PassWord_ui:IsVisible() == true then
			g_PassWord_ui:DeleteResource()
		    g_PassWord_ui:SetVisible(0)
			PasswordInput:SetEdit("")
		end
	end
end