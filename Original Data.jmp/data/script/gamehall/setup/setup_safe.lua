include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

local ReSet_Safekey_ui = nil
local PasswordInputEdit = nil
local PasswordInput = nil
local PasswordInputText = nil
local PasswordYesInputEdit = nil
local PasswordYesInput = nil
local PasswordYesInputText = nil

local Font_lock = nil
local Font_safe = nil
local font_list = {"财产未加锁","财产已加锁"}
local flag_lock = 0
local font_attention = {"启用安全锁后，消耗货币或者使用道具，","需要使用安全密码，以此保障您财产的安全。","启用安全锁后，可选中部分功能跳过安全锁，使用"}

local posx_move = -240
local posy_move = -150

local check_list = {}
local check_pattern = {}
local SetUP_Repaire = nil
local SetUP_Use = nil

function InitSetup_SafeUI(wnd, bisopen)
	g_setup_safe_ui = CreateWindow(wnd.id, (1920-1920)/2, (1080-1080)/2, 1920, 1080)
	InitMainSetup_Safe(g_setup_safe_ui)
	g_setup_safe_ui:SetVisible(bisopen)
end
function InitMainSetup_Safe(wnd)
	
	wnd:AddImage(path_setup.."BK_setup.png",0,0,793,486)
	wnd:AddImage(path_setup.."safefont1_setup.png",566+posx_move,162+posy_move,256,32)
	
	local btn_close = wnd:AddButton(path_shop.."close1_rec.png",path_shop.."close2_rec.png",path_shop.."close3_rec.png",985+posx_move,160+posy_move,35,35)
	btn_close.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Set_SetupIsVisible(0)
	end
	local btn_back = wnd:AddButton(path_setup.."back1_setup.png",path_setup.."back2_setup.png",path_setup.."back3_setup.png",290+posx_move,560+posy_move,164,49)
	btn_back:AddFont("返回设置",15, 0, 50, 14, 100, 20, 0xffffff)
	btn_back.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Set_SetupSafeIsVisible(0)
	end
	wnd:AddImage(path_setup.."safefont2_setup.png",245+posx_move,198+posy_move,746,66)
	wnd:AddImage(path_setup.."safefont3_setup.png",245+posx_move,360+posy_move,746,66)
	
	
	----两大按钮
	local checkA = wnd:AddButton(path_setup.."btnBlue1_setup.png",path_setup.."btnBlue2_setup.png",path_setup.."btnBlue3_setup.png",320+posx_move,275+posy_move,256,64)
	checkA:AddFont("启用安全锁",15, 0, 80, 18, 100, 20, 0xffffff)
	checkA.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		XUseLockSafe()
	end
	local checkB = wnd:AddButton(path_setup.."btnBlue1_setup.png",path_setup.."btnBlue2_setup.png",path_setup.."btnBlue3_setup.png",700+posx_move,275+posy_move,256,64)
	checkB:AddFont("重置安全密码",15, 0, 72, 18, 100, 20, 0xffffff)
	checkB.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		XRestLockSafe()
	end
	
	----锁
	Font_lock = wnd:AddImage(path_setup.."unlock_setup.png",330+posx_move,271+posy_move,32,32)
	Font_safe = wnd:AddFont(font_list[1],15, 0, 555+posx_move, 292+posy_move, 100, 20, 0xff3d5e)
	
	------黄色提示文字
	wnd:AddFont(font_attention[1],11, 0, 323+posx_move, 340+posy_move, 300, 20, 0xb27936)
	wnd:AddFont(font_attention[2],11, 0, 323+posx_move, 360+posy_move, 300, 20, 0xb27936)
	wnd:AddFont(font_attention[3],11, 0, 323+posx_move, 440+posy_move, 300, 20, 0xb27936)
	
	SetUP_Repaire = wnd:AddFont("修理物品",15, 0, 323+posx_move, 500+posy_move, 100, 20, 0x8f9bd7)
	SetUP_Use = wnd:AddFont("使用道具",15, 0, 450+posx_move, 500+posy_move, 100, 20, 0x8f9bd7)
	
	----2个勾选框	
	local check_posx = {390,518}
	local check_posy = {497,497}
	
	for i=1,2 do
		check_list[i] = wnd:AddImage(path_hero.."checkbox_hero.png",check_posx[i]+posx_move,check_posy[i]+posy_move,32,32)
		check_list[i]:SetTouchEnabled(1)
		check_pattern[i] = check_list[i]:AddImage(path_hero.."checkboxYes_hero.png",5,-1,32,32)
		check_pattern[i]:SetTouchEnabled(0)
		check_pattern[i]:SetVisible(1)
		
		check_list[i].script[XE_LBUP] = function()
		    if(check_pattern[i]:IsVisible() == true) then
		        XReSet_Safekey_Check_List(i,0)
			else
                XReSet_Safekey_Check_List(i,1)
            end				
		end
	end
	
	ReSet_Safekey_ui = CreateWindow(wnd.id, 0+posx_move, 0+posy_move, 355,225)
	ReSet_Safekey_ui:AddImage(path_setup.."safeBK_setup.png",621,346,355,225)
	ReSet_Safekey_ui:AddFont("输入新的安全密码，密码为空可关闭安全锁功能",12, 0, 660, 357, 400, 20, 0x83d1e7)
	ReSet_Safekey_ui:AddFont("输入密码",12, 0, 650, 415, 100, 20, 0x83d1e7)
	ReSet_Safekey_ui:AddFont("确认密码",12, 0, 650, 465, 100, 20, 0x83d1e7)
	
	local BTNA = ReSet_Safekey_ui:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",673,513,83,35)
	BTNA:AddFont("确定", 15, 0, 22, 7, 100, 20, 0xc7bcf6)
	BTNA.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		XSafeLockWordComfirm(PasswordInput:GetEdit(),PasswordYesInput:GetEdit())
		ReSet_Safekey_ui:SetVisible(0)
	end
	local BTNB = ReSet_Safekey_ui:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",850,513,83,35)
	BTNB:AddFont("取消", 15, 0, 22, 7, 100, 20, 0xc7bcf6)
	BTNB.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		ReSet_Safekey_ui:SetVisible(0)
		XPassWordClose()
	end
	
	PasswordInputEdit = CreateWindow(ReSet_Safekey_ui.id, 715,410, 256, 32)
	PasswordInput = PasswordInputEdit:AddEdit(path_setup.."passEdit_setup.png","","onPassword_Enter","",20,0,0,225,30,0xffffffff,0xff000000,1,"")
	XEditSetMaxByteLength(PasswordInput.id,15)
	XEditInclude(PasswordInput.id,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz`1234567890-=;',./~!@#$%^&*()_+{}|:<>?[]\\")
	
	PasswordYesInputEdit = CreateWindow(ReSet_Safekey_ui.id, 715,460, 256, 32)
	PasswordYesInput = PasswordYesInputEdit:AddEdit(path_setup.."passEdit_setup.png","","onPassword_Enter","",20,0,0,225,30,0xffffffff,0xff000000,1,"")
	XEditSetMaxByteLength(PasswordYesInput.id,15)
	XEditInclude(PasswordYesInput.id,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz`1234567890-=;',./~!@#$%^&*()_+{}|:<>?[]\\")
	
	ReSet_Safekey_ui:SetVisible(0)
	
end
function SetSafeLockFuncitonState(flag)
    if(flag == 1) then
	    check_list[1]:SetEnabled(1)
        check_pattern[1]:SetEnabled(1)
	    check_list[2]:SetEnabled(1)
        check_pattern[2]:SetEnabled(1)
        SetUP_Repaire:SetFontText("修理物品",0x8f9bd7)--0x5d5d5d
        SetUP_Use:SetFontText("使用道具",0x8f9bd7)
	else
	    check_list[1]:SetEnabled(0)
        check_pattern[1]:SetEnabled(0)
	    check_list[2]:SetEnabled(0)
        check_pattern[2]:SetEnabled(0)
        SetUP_Repaire:SetFontText("修理物品",0x5d5d5d)--0x5d5d5d
        SetUP_Use:SetFontText("使用道具",0x5d5d5d)
	end
end

function SetSafeLock_Safe()
   local ibool_1,ibool_2 = XGetUpSafeCheck()
   --log("ibool_1"..ibool_1.."  ibool_2"..ibool_2)
   if(ibool_1 == 1) then
       check_pattern[1]:SetVisible(1)
   else
       check_pattern[1]:SetVisible(0)
   end
   if(ibool_2 == 1) then
       check_pattern[2]:SetVisible(1)
   else
       check_pattern[2]:SetVisible(0)
   end
end

function Set_SetupSafeIsVisible(flag) 
	if g_setup_safe_ui ~= nil then
		if flag == 1 and g_setup_safe_ui:IsVisible() == false then
			g_setup_safe_ui:SetVisible(1)
			SetSafeLock_Safe()
		elseif flag == 0 and g_setup_safe_ui:IsVisible() == true then
			g_setup_safe_ui:SetVisible(0)
		end
	end
end

function Set_SetupReSet_SafekeyIsVisible(flag)
	if ReSet_Safekey_ui ~= nil then
		if flag == 1 and ReSet_Safekey_ui:IsVisible() == false then
			ReSet_Safekey_ui:SetVisible(1)
			PasswordInput:SetEdit("")
		    PasswordYesInput:SetEdit("")
			PasswordInput:SetFocus(1)
		elseif flag == 0 and ReSet_Safekey_ui:IsVisible() == true then
			ReSet_Safekey_ui:SetVisible(0)
			PasswordInput:SetEdit("")
		    PasswordYesInput:SetEdit("")
		end
	end
end