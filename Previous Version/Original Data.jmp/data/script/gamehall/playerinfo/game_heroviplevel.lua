include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

local current_lv = nil	---当前VIP等级图片
local next_lv = nil		---下个VIP等级图片
local next_lv_money = nil		--还要充值多少可以达到下个VIP等级
local left_money = 10000
local next_lv_num = nil			--下个VIP等级是多少级
local next_level = "VIP10"				--下个VIP等级
--------VIP等级经验条
local exp_red = nil
local exp_length = 0.5*410

--------VIP特权部分
local gift_VIP = nil	------VIP特权礼包图
local intr_VIP = nil	------VIP特权介绍图
local intr_vippic = {}		--VIP特权礼包图片部分
local intr_vipside = {}		--VIP特权礼包图片边框部分
local intr_vipFont = nil	--VIP特权介绍文字部分
local intr_Font = "获得VIP1级的特权礼包\n竞技场奖励的基础金币和经验提升为110%\n单项VIP功能9.5折"	------VIP特权介绍

local VIPN_BTN = {}		-------VIP礼包福利的按钮
local VIPN_POSY = {}	-------VIP礼包福利按钮的Y坐标
local VIPC_index = nil	-------当前选中的按钮
local click_index = 1 	-------当前选中的按钮的index
local Many_VIP = 0 		-------上次滑动按钮停留的位置

--------首次充值部分
local Charge_Font = {}	-------首次充值的文字
local Charge_posY = {}	-------首次充值的文字的文字Y坐标
local Many_Charge = 0 	-------上次滑动按钮停留的位置
local mail_Send = nil 	-------奖励邮件方式自动发送

local Charge_image = {}
local Charge_side = {}
local Charge_num = {}


------------窗口滚动
local updownCount = 0
local maxUpdown = 0
local FirstCharge_ToggleBK = nil
local FirstCharge_ToggleBTN = nil

local GoldOwned = 0
local GoldMaxOwn = {30, 100, 500, 1000, 5000, 0}
local GoldExp = nil
local CurVIPlv = 0
local AddMoneyFont = nil
local NextVipWordPic = nil

local Click_btn,Click_btn1,Click_btn2 = nil

function InitGame_HeroVipLevelUI(wnd, bisopen)
	g_game_heroVipLevel_ui = CreateWindow(wnd.id, 0, 0, 1280, 800)
	InitMainGame_HeroVipLevel(g_game_heroVipLevel_ui)
	g_game_heroVipLevel_ui:SetVisible(bisopen)
end
function InitMainGame_HeroVipLevel(wnd)

	--------左上部分（当前等级）
	AddMoneyFont = wnd:AddFont("您再充值                 钻石，即可成为", 15, 0, 140, 164, 300, 20, 0x7f94cd)
	next_lv_money = wnd:AddFont("0", 15, 0, 220, 164, 200, 20, 0x6ffefc)
	next_lv_num = wnd:AddFont(next_level, 15, 0, 380, 164, 200, 20, 0x6ffefc)
	
	wnd:AddFont("____________", 15, 0, 445, 164, 200, 20, 0x6ffefc)
	wnd:AddFont("前往充值", 15, 0, 450, 164, 200, 0, 0x6ffefc)
	local btn_AddMoney = wnd:AddButton(path_info.."indexnil_vip.png",path_info.."indexnil_vip.png",path_info.."indexnil_vip.png",445,160,128,32)
	
	btn_AddMoney:SetTransparent(0)
	btn_AddMoney.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGameSigninToAddMoney(1)
	end
	
	wnd:AddImage(path_info.."curlv_vip.png",65,215,64,16)
	NextVipWordPic = wnd:AddImage(path_info.."nextlv_vip.png",545,215,64,16)
	wnd:AddImage(path_task.."partition_sign.png",0,240,621,2)
	
	current_lv = wnd:AddImage(path_info.."VIP1.png",43,120,128,128)
	next_lv = wnd:AddImage(path_info.."VIP2.png",523,120,128,128)
	
	wnd:AddImage(path_info.."expall_vip.png",130,192,512,32)
	exp_red = wnd:AddImage(path_info.."expme_vip.png",130,192,512,32)
	XSetAddImageRect(exp_red.id, 0, 0, exp_length, 32, 130 ,192, exp_length, 32)
	GoldExp = wnd:AddFont(GoldOwned.."/"..GoldMaxOwn[1], 15, 0, 290, 192, 200, 20, 0x8296d1)
	
	--------右上（仅此一次充值界面）
	-- wnd:AddImage(path_task.."once_task.png",668,175,128,64)
	Click_btn = wnd:AddImage(path_task.."shouchong.png",635,175,109,46)
	-- Click_btn:AddFont("首充大礼", 15, 8, 0, 0, 130, 64, 0x6ffefc)
	-- Click_btn1 = Click_btn:AddImage(path.."friendMes_hall.png",100,0,19,20)
	Click_btn2 = Click_btn:AddImage(path_task .. "yiwancheng.png", -24, -15, 75, 50)
	
	wnd:AddFont("第一次充值", 15, 0, 775, 175, 200, 20, 0x6ffefc)
	wnd:AddFont("达到对应数额即送豪华礼包", 15, 0, 860, 177, 200, 20, 0x7f94cd)
	wnd:AddFont("充值可获得VIP积分 免费兑换绝版英雄和道具", 15, 0, 777, 201, 350, 20, 0x7f94cd)
	
	--------充值按钮
	local btn_reCharge = wnd:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png",1080,170, 179, 56)
	btn_reCharge:AddFont("充 值", 15, 8, 0, 0, 179, 56, 0xbeb9cf)
	btn_reCharge.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGameSigninToAddMoney(1)
	end
	
	-- 左下VIP等级特权介绍
	-- 介绍底
	wnd:AddImage(path_info.."line_vip.png",50,250,512,64)
	-- wnd:AddImage(path_info.."line_vip.png",50,373,512,64)
	
	-- gift_VIP = wnd:AddImage(path_info.."gift"..click_index.."_vip.png",50,250,512,64)
	intr_VIP = wnd:AddImage(path_info.."intr"..click_index.."_vip.png",50,250,512,64)
	-- wnd:AddFont("奖励邮件自动发送", 11, 0, 295, 280, 100, 11, 0x7f94cd)
	
	intr_vipFont = wnd:AddFont(intr_Font, 15, 0, 50, 440-123, 330, 300, 0x7f94cd)
	
	-------初始位置在第一个
	-- VIPC_index = wnd:AddImage(path.."button1_hall.png",420,267,179,56)
	
	--for i =1,6 do
		--local posx = 58*i
		--intr_vippic[i] = wnd:AddImage(path_equip.."bag_equip.png",posx,320,50,50)
		--intr_vipside[i] = wnd:AddImage(path_shop.."iconside_shop.png",posx-2,318,54,54)
	--end
	
	for i=1,5 do
		local fontA = "VIP"..i.."特权福利"
		local pngB = path_info.."VIP"..i..".png"
		VIPN_POSY[i] = 190+77*i
		VIPN_BTN[i] = wnd:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png",420,VIPN_POSY[i], 179, 56)
		VIPN_BTN[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			XClickPlayerVIPLevelButton(1, i)
			click_index = i
			--local LV,TV = VIPN_BTN[i]:GetPosition()
			--VIPC_index:SetPosition(LV,TV)
			--VIPC_index:SetVisible(1)
			
			----修改图片
			-- gift_VIP.changeimage(path_info.."gift"..click_index.."_vip.png")
			intr_VIP.changeimage(path_info.."intr"..click_index.."_vip.png")
			
			--for index,value in pairs(intr_vippic) do
				--intr_vippic[index].changeimage()
				--intr_vipside[index].changeimage()
			--end
			--for i=1,click_index do
				--intr_vippic[i].changeimage(path_equip.."bag_equip.png")
				--intr_vipside[i].changeimage(path_shop.."iconside_shop.png")
			--end
		
		end
		
		
		VIPN_BTN[i]:AddImage(pngB,-30,-30,128,128)
		VIPN_BTN[i]:AddFont(fontA, 15, 0, 70, 15, 100, 20, 0xbeb5ee)
		
		if VIPN_POSY[i] >700 or VIPN_POSY[i] <250 then
			VIPN_BTN[i]:SetVisible(0)
		else
			VIPN_BTN[i]:SetVisible(1)
		end
	end
	
	---左边滚动条
	-- local GIFT_ToggleBK = wnd:AddImage(path.."toggleBK_main.png",608,280,16,418)
	-- GIFT_ToggleBTN = GIFT_ToggleBK:AddButton(path.."toggleBTN1_main.png",path.."toggleBTN2_main.png",path.."toggleBTN3_main.png",0,0,16,50)
	--local ToggleT = GIFT_ToggleBK:AddImage(path.."TD1_main.png",0,-16,16,16)
	--local ToggleD = GIFT_ToggleBK:AddImage(path.."TD1_main.png",0,418,16,16)
	
	--XSetWindowFlag(GIFT_ToggleBTN.id,1,1,0,368)
	
	-- GIFT_ToggleBTN:ToggleBehaviour(XE_ONUPDATE, 1)
	-- GIFT_ToggleBTN:ToggleEvent(XE_ONUPDATE, 1)
	-- GIFT_ToggleBTN.script[XE_ONUPDATE] = function()
		-- if GIFT_ToggleBTN._T == nil then
			-- GIFT_ToggleBTN._T = 0
		-- end
		-- local L,T,R,B = XGetWindowClientPosition(GIFT_ToggleBTN.id)
		-- if GIFT_ToggleBTN._T ~= T then
			-- local Many = math.floor(T/85)
			
			-- if Many_VIP ~= Many then
				-- for i,value in pairs(VIPN_BTN) do
					-- local Ti = VIPN_POSY[i]
					
					-- VIPN_BTN[i]:SetPosition(420, Ti - Many*77)
					
					-- if Ti - Many*77 >700 or Ti - Many*77 <250 then
						-- VIPN_BTN[i]:SetVisible(0)
					-- else
						-- VIPN_BTN[i]:SetVisible(1)
					-- end
				-- end
				
				-- ----------点击的按钮亮光
				-- VIPC_index:SetPosition(420, VIPN_POSY[click_index] - Many*77)
				-- if (VIPN_POSY[click_index] - Many*77) >700 or (VIPN_POSY[click_index] - Many*77) <250 then
					-- VIPC_index:SetVisible(0)
				-- else
					-- VIPC_index:SetVisible(1)
				-- end
				
				-- Many_VIP = Many
			-- end
			
			-- GIFT_ToggleBTN._T = T
		-- end
	-- end
	
	--------右下首次充值满则送
	wnd:AddImage(path_task.."partition_sign.png",600,240,621,2)
	wnd:AddImage(path_info.."payBack.png",600,242,577,475)
	local Gold_lv = {10,50,100,300,500,1000,2000,0,3000,0,5000,0}
	for i=1,12 do
		Charge_posY[i] = 212+63*i
		
		Charge_Font[i] = wnd:AddImage(path_equip.."bag_equip.png",670,Charge_posY[i],50,50)
		Charge_Font[i]:SetTransparent(0)
		
		if(i~= 8 and i ~= 10 and i ~= 12) then
		    Charge_Font[i]:AddFont("首次充值", 15, 0, 0, 10, 100, 20, 0x7f94cd)
		    Charge_Font[i]:AddFont("单笔满", 15, 0, -20, 35, 100, 20, 0x7f94cd)
		    Charge_Font[i]:AddFont(Gold_lv[i].." 钻石", 15, 0, 25, 35, 100, 20, 0x6ffefc)
		end
		if(i~= 7 and i ~= 9 and i ~= 11) then
		    Charge_Font[i]:AddImage(path_info.."payBackLight.png",-10,56,576,1)
		end
		
		for k=1,7 do
			Charge_image[(i-1)*7+k] = Charge_Font[i]:AddImage(path_equip.."bag_equip.png",61*k+45,0,50,50)
			Charge_image[(i-1)*7+k]:SetVisible(0)
			Charge_side[(i-1)*7+k] = Charge_Font[i]:AddImage(path_shop.."iconside_shop.png",61*k+45-2,-2,54,54)
			Charge_side[(i-1)*7+k]:SetVisible(0)
			Charge_num[(i-1)*7+k] = Charge_image[(i-1)*7+k]:AddFont("0",12,6,-47,-37,100,15,0xFFFFFF)
			Charge_num[(i-1)*7+k]:SetFontBackground()
		end
		
		if Charge_posY[i] >700 or Charge_posY[i] <250 then
			Charge_Font[i]:SetVisible(0)
		else
			Charge_Font[i]:SetVisible(1)
		end
	end
	mail_Send = wnd:AddFont("友情提醒", 15, 0, 1050, 275, 100, 20, 0x7f94cd)
	mail_Send:AddFont("奖励以邮件方式自动发送", 11, 0, 0, 20, 200, 20, 0x7f94cd)
	mail_Send:SetVisible(1)
	
	---右边滚动条
	FirstCharge_ToggleBK = wnd:AddImage(path.."toggleBK_main.png",1226,280,16,418)
	FirstCharge_ToggleBTN = FirstCharge_ToggleBK:AddButton(path.."toggleBTN1_main.png",path.."toggleBTN2_main.png",path.."toggleBTN3_main.png",0,0,16,50)
	local ToggleT = FirstCharge_ToggleBK:AddImage(path.."TD1_main.png",0,-16,16,16)
	local ToggleD = FirstCharge_ToggleBK:AddImage(path.."TD1_main.png",0,418,16,16)
	XSetWindowFlag(FirstCharge_ToggleBTN.id,1,1,0,368)
	
	FirstCharge_ToggleBTN:ToggleBehaviour(XE_ONUPDATE, 1)
	FirstCharge_ToggleBTN:ToggleEvent(XE_ONUPDATE, 1)
	FirstCharge_ToggleBTN.script[XE_ONUPDATE] = function()
		if FirstCharge_ToggleBTN._T == nil then
			FirstCharge_ToggleBTN._T = 0
		end
		local L,T,R,B = XGetWindowClientPosition(FirstCharge_ToggleBTN.id)
		if FirstCharge_ToggleBTN._T ~= T then
			local Many = math.floor(T/76)
			updownCount = Many
			
			if Many_Charge ~= Many then
				for i,value in pairs(Charge_Font) do
					local Ti = Charge_posY[i]-Many*63
					
					Charge_Font[i]:SetPosition(670, Ti)
					
					if Ti >700 or Ti <250 then
						Charge_Font[i]:SetVisible(0)
					else
						Charge_Font[i]:SetVisible(1)
					end
				end
				----------奖励邮件方式自动发送
				local Tk = 275 - Many*63
				mail_Send:SetPosition(1050, Tk)
				if Tk >700 or Tk <250 then
					mail_Send:SetVisible(0)
				else
					mail_Send:SetVisible(1)
				end
				
				Many_Charge = Many
			end
			FirstCharge_ToggleBTN._T = T
		end
	end
	XWindowEnableAlphaTouch(g_game_heroVipLevel_ui.id)
	g_game_heroVipLevel_ui:EnableEvent(XE_MOUSEWHEEL)
	g_game_heroVipLevel_ui.script[XE_MOUSEWHEEL] = function()
		local updown  = XGetMsgParam0()
		local length = 76
		maxUpdown = 5
		if updown>0 then
			updownCount = updownCount-1
			if updownCount<0 then
				updownCount=0
			end
		else
			updownCount = updownCount+1
			if updownCount>maxUpdown then
				updownCount=maxUpdown
			end
		end			
		local btn_pos = length*updownCount

		FirstCharge_ToggleBTN:SetPosition(0,btn_pos)
		FirstCharge_ToggleBTN._T = btn_pos
		
		if updownCount >= 0 and updownCount <= maxUpdown then
			for i,value in pairs(Charge_Font) do
				local Ti = Charge_posY[i]-updownCount*63
				
				Charge_Font[i]:SetPosition(670, Ti)
				
				if Ti >700 or Ti <250 then
					Charge_Font[i]:SetVisible(0)
				else
					Charge_Font[i]:SetVisible(1)
				end
			end
			----------奖励邮件方式自动发送
			local Tk = 275 - updownCount*63
			mail_Send:SetPosition(1050, Tk)
			if Tk >700 or Tk <250 then
				mail_Send:SetVisible(0)
			else
				mail_Send:SetVisible(1)
			end
		end
	end
end

function SetGameHeroVipLevelIsVisible(flag) 
	if g_game_heroVipLevel_ui ~= nil then
		if flag == 1 and g_game_heroVipLevel_ui:IsVisible() == false then
			g_game_heroVipLevel_ui:SetVisible(1)
			SetIsWanChengShouChong()
			XInformCIsVisiblePlayerVipUi(1, 1)			
		elseif flag == 0 and g_game_heroVipLevel_ui:IsVisible() == true then
			g_game_heroVipLevel_ui:SetVisible(0)
			XInformCIsVisiblePlayerVipUi(1, 0)
		end
	end
end

function GetGameHeroVipLevelIsVisible()  
    if(g_game_heroVipLevel_ui:IsVisible()) then
       -- XGameHeroSkinIsOpen(1)
    else
       -- XGameHeroSkinIsOpen(0)
    end
end

function SetPlayerVIPLevel( cLv)
	local TempNum = 0
	CurVIPlv = cLv
	current_lv.changeimage(path_info.."VIP"..cLv..".png")
	TempNum = GoldOwned
	if cLv< 5 then
	    next_lv.changeimage(path_info.."VIP"..cLv+1 ..".png")
	    next_lv_num:SetFontText("VIP" .. (cLv+1), 0x6ffefc)
		GoldExp:SetFontText(TempNum .. "/" .. GoldMaxOwn[cLv+1], 0x8296d1)
		local TempNum2 = GoldMaxOwn[cLv+1]-TempNum
		if TempNum2 < 0 then
			TempNum2 = 0
		end
		next_lv_money:SetFontText("" .. TempNum2, 0x6ffefc)
		exp_length = TempNum / GoldMaxOwn[cLv+1] * 413
		XSetAddImageRect(exp_red.id, 0, 0, exp_length, 32, 130 ,192, exp_length, 32)
		SetAddMoneyFontVisible(1)
	else
        GoldExp:SetFontText("5000", 0x8296d1)
		XSetAddImageRect(exp_red.id, 0, 0, 413, 32, 130 ,192, 413, 32)
		SetAddMoneyFontVisible(0)
	end
end

function SetAddMoneyFontVisible(ibool)
   AddMoneyFont:SetVisible(ibool)
   next_lv:SetVisible(ibool)
   next_lv_num:SetVisible(ibool)
   next_lv_money:SetVisible(ibool)
   NextVipWordPic:SetVisible(ibool)
end

function SetFirstPayItemList_PlayerVIP(strPic,i,k,num,tip)
	if(i == 7 and k> 7) then
	    i = 8
	    k = k-7
	elseif(i == 8 and k <= 7) then
	    i = 9
	elseif(i == 8 and k > 7) then
	    i = 10
	    k = k-7
	elseif(i == 9 and k <= 7) then
	    i = 11
	elseif(i == 9 and k > 7) then
	    i = 12
	    k = k-7
	end	
    Charge_image[(i-1)*7+k].changeimage( "..\\"..strPic)
	Charge_image[(i-1)*7+k]:SetImageTip(tip)
	Charge_num[(i-1)*7+k]:SetFontText(tostring(num))
	Charge_image[(i-1)*7+k]:SetVisible(1)
	Charge_side[(i-1)*7+k]:SetVisible(1)
end

function SetVipLevelInfo( cInfo)
	intr_vipFont:SetFontText(cInfo, 0x7f94cd)
end

function ResetVipCheckButtonStatus()
	click_index = 1
	updownCount = 0
	maxUpdown = 0
	FirstCharge_ToggleBTN:SetPosition(0,0)
	FirstCharge_ToggleBTN._T = 0
	for i,value in pairs(Charge_Font) do
		local Ti = Charge_posY[i]		
		Charge_Font[i]:SetPosition(670, Ti)
		
		if Ti >700 or Ti <250 then
			Charge_Font[i]:SetVisible(0)
		else
			Charge_Font[i]:SetVisible(1)
		end
	end
	
	
	-- local LV,TV = VIPN_BTN[1]:GetPosition()
	-- VIPC_index:SetPosition(LV,TV)
	-- VIPC_index:SetVisible(1)
	
	-- 修改图片
	-- gift_VIP.changeimage(path_info.."gift"..click_index.."_vip.png")
	intr_VIP.changeimage(path_info.."intr"..click_index.."_vip.png")
	
	-- for index,value in pairs(intr_vippic) do
		-- intr_vippic[index].changeimage()
		-- intr_vipside[index].changeimage()
	-- end
	-- for i=1,click_index do
		-- intr_vippic[i].changeimage(path_equip.."bag_equip.png")
		-- intr_vipside[i].changeimage(path_shop.."iconside_shop.png")
	-- end
end

function GetPlayerCurGoldPoint(CurPoint)
	GoldOwned = CurPoint/100
end

function SetIsWanChengShouChong()
	local bType = GetFirstCheckButtonVisible()
	if bType==0 then
		Click_btn2:SetVisible(1)
		-- Click_btn1:SetVisible(0)
	else
		Click_btn2:SetVisible(0)
		-- Click_btn1:SetVisible(1)
	end
end