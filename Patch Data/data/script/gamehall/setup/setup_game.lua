include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

local check_list = {}
local check_pattern = {}
	
local AA = nil	
local BB = nil
local CC = nil
local DD = nil
local EE = nil	
	
local AP = nil	
local BP = nil
local CP = nil
local AP_FONT = 40
local BP_FONT = 60
local CP_FONT = 99

local A1 = nil
local B1 = nil
local C1 = nil
local D1 = nil
local E1 = nil

local posx_move = -240
local posy_move = -150

function InitSetup_GameUI(wnd, bisopen)
	g_setup_game_ui = CreateWindow(wnd.id, (1920-1920)/2, (1080-1080)/2, 1920, 1080)
	InitMainSetup_Game(g_setup_game_ui)
	g_setup_game_ui:SetVisible(bisopen)
end
function InitMainSetup_Game(wnd)
	
	wnd:AddImage(path_setup.."BK_setup.png",0,0,793,486)
	wnd:AddImage(path_setup.."gamefont1_setup.png",592+posx_move,162+posy_move,128,32)
	
	local btn_close = wnd:AddButton(path_shop.."close1_rec.png",path_shop.."close2_rec.png",path_shop.."close3_rec.png",985+posx_move,160+posy_move,35,35)
	btn_close.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Set_SetupIsVisible(0)
		XClickCancelButton_Set(1)
	end
	local btn_back = wnd:AddButton(path_setup.."back1_setup.png",path_setup.."back2_setup.png",path_setup.."back3_setup.png",290+posx_move,560+posy_move,164,49)
	btn_back:AddFont("返回设置",15, 0, 50, 14, 100, 20, 0xffffff)
	btn_back.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Set_SetupGameIsVisible(0)
		XClickCancelButton_Set(1)
		--Set_SetupIsVisible(1)
	end
	local btn_apply = wnd:AddButton(path_setup.."apply1_setup.png",path_setup.."apply2_setup.png",path_setup.."apply3_setup.png",815+posx_move,560+posy_move,164,49)
	btn_apply:AddFont("确认",15, 0, 65, 15, 100, 20, 0xffffff)
	btn_apply.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickConfirmButton_Set(1)
		Set_SetupGameIsVisible(0)
	end
	-- local btn_cancel = wnd:AddButton(path_setup.."apply1_setup.png",path_setup.."apply2_setup.png",path_setup.."apply3_setup.png",815+posx_move,560+posy_move,164,49)
	-- btn_cancel:AddFont("取消",15, 0, 65, 15, 100, 20, 0xffffff)
	-- btn_cancel.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
		-- Set_SetupGameIsVisible(0)
		-- XClickCancelButton_Set(1)
	-- end
	
	wnd:AddImage(path_setup.."gamefont2_setup.png",245+posx_move,340+posy_move,746,66)
	wnd:AddImage(path_setup.."gamefont4_setup.png",635+posx_move,197+posy_move,322,42)
	wnd:AddImage(path_setup.."gamefont3_setup.png",245+posx_move,197+posy_move,322,42)
	
	wnd:AddFont("音效",15, 0, 290+posx_move, 250+posy_move, 100, 20, 0x8f9bd7)
	wnd:AddFont("音乐",15, 0, 290+posx_move, 288+posy_move, 100, 20, 0x8f9bd7)
	wnd:AddFont("声音",15, 0, 290+posx_move, 326+posy_move, 100, 20, 0x8f9bd7)
	wnd:AddFont("小地图",15, 0, 687+posx_move, 250+posy_move, 100, 20, 0x8f9bd7)
	wnd:AddFont("滚屏速度",15, 0, 687+posx_move, 288+posy_move, 100, 20, 0x8f9bd7)
	
	local posx = {327,492,670,843,327,492,670,327,492,670}
	local posy = {429,429,429,429,468,468,468,507,507,507}
	local font_name = {"技能提示","色盲模式","显示伤害飘字","死亡后装备栏自动铸魂","详细血量","战斗记录","小地图快速移动","屏幕震动","小地图左置","显示普通攻击范围"}
	
	for i=1,10 do
		wnd:AddFont(font_name[i],15, 0, posx[i]+posx_move, posy[i]+posy_move, 200, 20, 0x8f9bd7)
	end
	
	
	----15个勾选框	
	local check_posx = {351,351,351,293,459,637,810,293,459,637,293,459,637}
	local check_posy = {249,286,323,426,426,426,426,464,464,464,504,504,504}
	
	for i=1,13 do
		check_list[i] = wnd:AddImage(path_hero.."checkbox_hero.png",check_posx[i]+posx_move,check_posy[i]+posy_move,32,32)
		check_list[i]:SetTouchEnabled(1)
		check_pattern[i] = check_list[i]:AddImage(path_hero.."checkboxYes_hero.png",5,-1,32,32)
		check_pattern[i]:SetTouchEnabled(0)
		check_pattern[i]:SetVisible(1)
		
		check_list[i].script[XE_LBUP] = function()
			if (check_pattern[i]:IsVisible()) then
				check_pattern[i]:SetVisible(0)
				XClickOtherCheckButton_Set(1, i-1, 0)
			else
				check_pattern[i]:SetVisible(1)
				XClickOtherCheckButton_Set(1, i-1, 1)
			end
		end
	end
	
	----滑动条
	wnd:AddImage(path_setup.."dragBK1_setup.png", 390+posx_move, 253+posy_move,256,32)
	wnd:AddImage(path_setup.."dragBK1_setup.png", 390+posx_move, 289+posy_move,256,32)
	wnd:AddImage(path_setup.."dragBK1_setup.png", 390+posx_move, 326+posy_move,256,32)
	wnd:AddImage(path_setup.."dragBK1_setup.png", 784+posx_move, 253+posy_move,256,32)
	wnd:AddImage(path_setup.."dragBK1_setup.png", 784+posx_move, 289+posy_move,256,32)
	
	AA = wnd:AddImage(path_setup.."dragBK2_setup.png", 390+posx_move, 253+posy_move,256,32)
	BB = wnd:AddImage(path_setup.."dragBK2_setup.png", 390+posx_move, 289+posy_move,256,32)
	CC = wnd:AddImage(path_setup.."dragBK2_setup.png", 390+posx_move, 326+posy_move,256,32)
	DD = wnd:AddImage(path_setup.."dragBK2_setup.png", 784+posx_move, 253+posy_move,256,32)
	EE = wnd:AddImage(path_setup.."dragBK2_setup.png", 784+posx_move, 289+posy_move,256,32)
	
	-- 所有的滑动条
	-- 音效
	A1 = AA:AddButton(path_setup.."dragBtn_setup.png",path_setup.."dragBtn_setup.png",path_setup.."dragBtn_setup.png",135,0,8,32)
	XSetWindowFlag(A1.id,1,2,0,135)
	
	A1:ToggleBehaviour(XE_ONUPDATE, 1)	
	A1:ToggleEvent(XE_ONUPDATE, 1)
	
	A1.script[XE_ONUPDATE] = function()
		if A1._L == nil then
			A1._L = 0
		end
		local L,T,R,B = XGetWindowClientPosition(A1.id)
		if A1._L ~= L then
			local tempnum = 0
			if g_setup_game_ui:IsVisible() then
				tempnum = 1
			end
			XUpDateSoundScrollBarPos_Tab( tempnum, L/135*20)
			XSetAddImageRect(AA.id,0,0,L,32,390+posx_move,253+posy_move,L,32)
			AP_FONT = math.floor(100*(L/135))
			AP:SetFontText(AP_FONT.."%",0x83d1e7)
			A1._L = L
		end
	end
	
	-- 音乐
	B1 = BB:AddButton(path_setup.."dragBtn_setup.png",path_setup.."dragBtn_setup.png",path_setup.."dragBtn_setup.png",135,0,8,32)
	XSetWindowFlag(B1.id,1,2,0,135)
	
	B1:ToggleBehaviour(XE_ONUPDATE, 1)	
	B1:ToggleEvent(XE_ONUPDATE, 1)
	
	B1.script[XE_ONUPDATE] = function()
		if B1._L == nil then
			B1._L = 0
		end
		local L,T,R,B = XGetWindowClientPosition(B1.id)
		if B1._L ~= L then
			local tempnum = 0
			if g_setup_game_ui:IsVisible() then
				tempnum = 1
			end
			XUpDateMusicScrollBarPos_Tab( tempnum, L/135*20)
			BB:SetAddImageRect(BB.id,0,0,L,32,390+posx_move,289+posy_move,L,32)
			BP_FONT = math.floor(100*(L/135))
			BP:SetFontText(BP_FONT.."%",0x83d1e7)
			B1._L = L
		end
	end
	------------声音
	C1 = CC:AddButton(path_setup.."dragBtn_setup.png",path_setup.."dragBtn_setup.png",path_setup.."dragBtn_setup.png",135,0,8,32)
	XSetWindowFlag(C1.id,1,2,0,135)
	
	C1:ToggleBehaviour(XE_ONUPDATE, 1)	
	C1:ToggleEvent(XE_ONUPDATE, 1)
	
	C1.script[XE_ONUPDATE] = function()
		if C1._L == nil then
			C1._L = 0
		end
		local L,T,R,B = XGetWindowClientPosition(C1.id)
		if C1._L ~= L then
			local tempnum = 0
			if g_setup_game_ui:IsVisible() then
				tempnum = 1
			end
			XUpDateSaidScrollBarPos_Tab( tempnum, L/135*20)
			CC:SetAddImageRect(CC.id,0,0,L,32,390+posx_move,326+posy_move,L,32)
			CP_FONT = math.floor(100*(L/135))
			CP:SetFontText(CP_FONT.."%",0x83d1e7)
			C1._L = L
		end
	end
	------------小地图
	D1 = DD:AddButton(path_setup.."dragBtn_setup.png",path_setup.."dragBtn_setup.png",path_setup.."dragBtn_setup.png",135,0,8,32)
	XSetWindowFlag(D1.id,1,2,0,135)
	
	--D1:SetTouchEnabled(0)
	
	D1:ToggleBehaviour(XE_ONUPDATE, 1)	
	D1:ToggleEvent(XE_ONUPDATE, 1)
	
	D1.script[XE_ONUPDATE] = function()
		if D1._L == nil then
			D1._L = 0
		end
		local L,T,R,B = XGetWindowClientPosition(D1.id)
		if D1._L ~= L then
			local tempnum = 0
			if g_setup_game_ui:IsVisible() then
				tempnum = 1
			end
			XUpDateMiniMapScrollBarPos_Tab( tempnum, L/135*20)
			DD:SetAddImageRect(DD.id,0,0,L,32,784+posx_move,253+posy_move,L,32)
			D1._L = L
		end
	end
	------------滚屏速度
	E1 = EE:AddButton(path_setup.."dragBtn_setup.png",path_setup.."dragBtn_setup.png",path_setup.."dragBtn_setup.png",135,0,8,32)
	XSetWindowFlag(E1.id,1,2,0,135)
	
	E1:ToggleBehaviour(XE_ONUPDATE, 1)	
	E1:ToggleEvent(XE_ONUPDATE, 1)
	
	E1.script[XE_ONUPDATE] = function()
		if E1._L == nil then
			E1._L = 0
		end
		local L,T,R,B = XGetWindowClientPosition(E1.id)
		if E1._L ~= L then
			local tempnum = 0
			if g_setup_game_ui:IsVisible() then
				tempnum = 1
			end
			XUpDateScreenRollScrollBarPos_Tab( tempnum, L/135*1000)
			EE:SetAddImageRect(EE.id,0,0,L,32,784+posx_move,289+posy_move,L,32)
			E1._L = L
		end
	end
	---------音乐百分比
	AP = wnd:AddFont(AP_FONT.."%",15, 0, 548+posx_move, 253+posy_move, 200, 20, 0x83d1e7)
	BP = wnd:AddFont(BP_FONT.."%",15, 0, 548+posx_move, 290+posy_move, 200, 20, 0x83d1e7)
	CP = wnd:AddFont(CP_FONT.."%",15, 0, 548+posx_move, 328+posy_move, 200, 20, 0x83d1e7)
end

function Set_SetupGameIsVisible(flag) 
	if g_setup_game_ui ~= nil then
		if flag == 1 and g_setup_game_ui:IsVisible() == false then
			g_setup_game_ui:SetVisible(1)
			XSetCustomSetVisible_Tab(1, 1)
		elseif flag == 0 and g_setup_game_ui:IsVisible() == true then
			g_setup_game_ui:SetVisible(0)
			XSetCustomSetVisible_Tab(1, 0)
		end
	end
end

function Get_SetupGameIsVisible()  
    if(g_setup_game_ui:IsVisible()) then
       -- XGameHeroSkinIsOpen(1)
    else
       -- XGameHeroSkinIsOpen(0)
    end
end

function InitGameSetUiCheckButton( cCheck1, cCheck2, cCheck3, cCheck4, cCheck5, cCheck6, cCheck7, cCheck8, cCheck9, cCheck10, cCheck11, cCheck12, cCheck13)
	check_pattern[1]:SetVisible(cCheck1)
	check_pattern[2]:SetVisible(cCheck2)
	check_pattern[3]:SetVisible(cCheck3)
	check_pattern[4]:SetVisible(cCheck4)
	check_pattern[5]:SetVisible(cCheck5)
	check_pattern[6]:SetVisible(cCheck6)
	check_pattern[7]:SetVisible(cCheck7)
	check_pattern[8]:SetVisible(cCheck8)
	check_pattern[9]:SetVisible(cCheck9)
	check_pattern[10]:SetVisible(cCheck10)
	check_pattern[11]:SetVisible(cCheck11)
	check_pattern[12]:SetVisible(cCheck12)
	check_pattern[13]:SetVisible(cCheck13)
end

function InitScrollBar( a, b, c, d, e)
	-- 音效
	if A1._L == nil then
		A1._L = 0
	else
		A1._L = a/20*135
	end
	A1:SetPosition( A1._L, 0)
	XSetAddImageRect( AA.id, 0, 0, A1._L, 32, 390+posx_move, 253+posy_move, A1._L, 32)
	AP_FONT = math.floor(100*(A1._L/135))
	AP:SetFontText(AP_FONT.."%",0x83d1e7)
	
	-- 音乐
	if B1._L == nil then
		B1._L = 0
	else
		B1._L = b/20*135
	end
	B1:SetPosition( B1._L, 0)
	XSetAddImageRect( BB.id, 0, 0, B1._L, 32, 390+posx_move, 289+posy_move, B1._L, 32)
	BP_FONT = math.floor(100*(B1._L/135))
	BP:SetFontText(BP_FONT.."%",0x83d1e7)
	
	-- 声音
	if C1._L == nil then
		C1._L = 0
	else
		C1._L = c/20*135
	end
	C1:SetPosition( C1._L, 0)
	XSetAddImageRect( CC.id, 0, 0, C1._L, 32, 390+posx_move, 326+posy_move, C1._L, 32)
	CP_FONT = math.floor(100*(C1._L/135))
	CP:SetFontText(CP_FONT.."%",0x83d1e7)
	
	
	-- 小地图
	if D1._L == nil then
		D1._L = 0
	else
		D1._L = d/20*135
	end
	D1:SetPosition( D1._L, 0)
	XSetAddImageRect( DD.id, 0, 0, D1._L, 32, 784+posx_move, 253+posy_move, D1._L, 32)
	DP_FONT = math.floor(100*(D1._L/135))
	DP:SetFontText(DP_FONT.."%",0x83d1e7)
	
	
	-- 滚屏速度
	if E1._L == nil then
		E1._L = 0
	else
		E1._L = e/1000*135
	end
	E1:SetPosition( E1._L, 0)
	XSetAddImageRect( EE.id, 0, 0, E1._L, 32, 784+posx_move, 289+posy_move, E1._L, 32)
	EP_FONT = math.floor(100*(E1._L/135))
	EP:SetFontText(EP_FONT.."%",0x83d1e7)
end