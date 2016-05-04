include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

-------设置主界面
local Font_lock = nil
local Font_safe = nil
local font_list = {"财产未加锁","财产已加锁"}
local flag_lock = 0

local press_index = 0

local posx_move = -240
local posy_move = -150

local checkA = nil
local checkB = nil
local checkC = nil
local checkD = nil
local checkE = nil

local checkF = nil
local checkF_font = nil
local checkF_Type = 0

function InitSetup_UI(wnd, bisopen)
	g_setup_ui = CreateWindow(wnd.id, (1920-1920)/2, (1080-1080)/2, 1920, 1080)
	g_setup_ui:EnableBlackBackgroundTop(1)
	InitMain_Setup(g_setup_ui)
	g_setup_ui:SetVisible(bisopen)
end
function InitMain_Setup(wnd)
	wnd:AddImage(path_setup.."BK_setup.png",0,0,793,486)
	wnd:AddImage(path_setup.."font1_setup.png",592+posx_move,162+posy_move,128,32)
	wnd:AddImage(path_setup.."font2_setup.png",240+posx_move,185+posy_move,746,66)
	wnd:AddImage(path_setup.."font3_setup.png",240+posx_move,330+posy_move,746,66)
	
	checkA = wnd:AddButton(path_setup.."btnBlue1_setup.png",path_setup.."btnBlue2_setup.png",path_setup.."btnBlue3_setup.png",284+posx_move,265+posy_move,256,64)
	checkA:AddFont("画面设置",15, 0, 83, 18, 100, 20, 0xffffff)
	checkA.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		XSetFaceUiVisible_Tab(1,1)
	end
	
	checkB = wnd:AddButton(path_setup.."btnBlue1_setup.png",path_setup.."btnBlue2_setup.png",path_setup.."btnBlue3_setup.png",524+posx_move,265+posy_move,256,64)
	checkB:AddFont("游戏设置",15, 0, 83, 18, 100, 20, 0xffffff)
	checkB.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		Set_SetupGameIsVisible(1)
	end
	checkC = wnd:AddButton(path_setup.."btnBlue1_setup.png",path_setup.."btnBlue2_setup.png",path_setup.."btnBlue3_setup.png",764+posx_move,265+posy_move,256,64)
	checkC:AddFont("按键设置",15, 0, 83, 18, 100, 20, 0xffffff)
	checkC.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		--Set_SetupIsVisible(0)
		Set_SetupKeypressIsVisible(1)
	end
	checkD = wnd:AddButton(path_setup.."btnBlue1_setup.png",path_setup.."btnBlue2_setup.png",path_setup.."btnBlue3_setup.png",284+posx_move,410+posy_move,256,64)
	checkD:AddFont("举报",15, 0, 100, 18, 100, 20, 0xffffff)
	checkD:SetEnabled(0)
	checkD.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Set_SetupAccuseIsVisible(1)
		local BlockX,BlockY = g_setup_ui:GetPosition()		
		MainAccuseSetPosition(BlockX+240,BlockY)
		
	end
	
	checkE = wnd:AddButton(path_setup.."btnBlue1_setup.png",path_setup.."btnBlue2_setup.png",path_setup.."btnBlue3_setup.png",524+posx_move,410+posy_move,256,64)
	checkE:AddFont("账号安全锁",15, 0, 80, 18, 100, 20, 0xffffff)
	checkE.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XLockOnButtonClick_Safe()
	end
	checkF = wnd:AddButton(path_setup.."btnBlue1_setup.png",path_setup.."btnBlue2_setup.png",path_setup.."btnBlue3_setup.png",764+posx_move,410+posy_move,256,64)
	checkF_font = checkF:AddFont("更换账号",15, 8, -40, -18, 150, 20, 0xffffff)
	checkF.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		if checkF_Type == 0 then
			XGameRelogin(1)		-- 更换账号
		elseif checkF_Type == 1 then
			XExitDragon(1)		-- 离开恶龙
		elseif checkF_Type == 2 then
			XExitBattlefield(1)	-- 离开战场
		elseif checkF_Type == 3 then
			XExitSurrender(1)	-- 投降
		end
	end
	local checkG = wnd:AddButton(path_setup.."btnRed1_setup.png",path_setup.."btnRed2_setup.png",path_setup.."btnRed3_setup.png",524+posx_move,550+posy_move,256,64)
	checkG:AddFont("退出游戏",15, 8, -40, -18, 150, 20, 0xffffff)
	checkG.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGameCloseWindow(1)
	end
	-------------关闭界面	
	local btn_close = wnd:AddButton(path_shop.."close1_rec.png",path_shop.."close2_rec.png",path_shop.."close3_rec.png",985+posx_move,160+posy_move,35,35)
	btn_close.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickCloseSetupUi(1)
		Set_SetupIsVisible(0)
	end
	
	Font_lock = wnd:AddImage(path_setup.."unlock_setup.png",528+posx_move,406+posy_move,32,32)
	Font_safe = wnd:AddFont(font_list[1],15, 8, -200, -320, 400, 20, 0xff3d5e)
end

function SetFontSafeData(str)
    Font_safe:SetFontText(str,0xff3d5e)
	SetUpLockChange()
end

function Set_Setupcheck_DEnable(ibool)
	checkD:SetEnabled(ibool)
end

function SetUpLockChange()
    local ibool = XGetifLock()
	if(ibool == 1) then
	    Font_lock.changeimage(path_setup.."lock_setup.png")
	else
	    Font_lock.changeimage(path_setup.."unlock_setup.png")
	end
end

function Set_SetupIsVisible(flag) 
	if g_setup_ui ~= nil then
		if flag == 1 and g_setup_ui:IsVisible() == false then
			g_setup_ui:CreateResource()
			g_setup_ui:SetVisible(1)
			XSetSetupUiIsVisible(1, 1)
			Set_SetupSafeIsVisible(0)
			Set_SetupGameIsVisible(0)
			Set_SetupKeypressIsVisible(0)
			Set_SetupFaceIsVisible(0)
			Set_SetupQuitIsVisible(0)
			Set_SetupImpeachIsVisible(0)
			if(XGetMapId() ~= 1) then
			    SetEquip_InsideIsVisible(0)
				SetShop_InsideIsVisible(0)
				SetGameHeroAchievementIsVisible(0)
			end
		elseif flag == 0 and g_setup_ui:IsVisible() == true then
			g_setup_ui:DeleteResource()
			g_setup_ui:SetVisible(0)
			XSetSetupUiIsVisible(1, 0)
		end
	end
end

function Get_SetupIsVisible()  
    if(g_setup_ui:IsVisible()) then
       --XSetUpIsOpen(1)
    else
       --XSetUpIsOpen(0)
    end
end

function SetGameSetUiIsVisible( cVisible)
	checkA:SetEnabled(cVisible)
	-- if cVisible == 1 then
		-- checkA1:SetVisible(0)
	-- else
		-- checkA1:SetVisible(1)
	-- end
end

function checkSetupIsVisible()
    if(g_setup_ui:IsVisible()) then
	     return true
    else 
	     return false
    end	
end

function SetCurButtonType_Setup( cStr, cType)
	checkF_font:SetFontText( cStr, 0xffffff)
	checkF_Type = cType
end