include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

-- 灵魂契约界面
local soulchange_bk = nil
local soulchange_posx = {}
local soulchange_posy = {}
local soulchange_side = {}
local soulchange_head = {}
local soulchange_click = nil
local click_index = 0

local soulchange_toggleBK = nil
local soulchange_togglebtn = nil
local Many_soulchangeHead = 0
local check_buyYes = nil
local updownCount = 0
local maxUpdown = 0

-- 通信
local soulchangeInfo = {}
soulchangeInfo.pictureName = {}
soulchangeInfo.Id = {}
soulchangeInfo.Tip = {}


function InitSoulChange_ui(wnd,bisopen)
	n_soulchange_ui = CreateWindow(wnd.id, 0, 800-400, 399, 269)
	InitMain_SoulChange(n_soulchange_ui)
	n_soulchange_ui:SetVisible(bisopen)
end

function InitMain_SoulChange(wnd)

	-- 召唤师头像界面
	wnd:AddImage(path_fight_soulchange.."summoner_bk.png", 0, 0, 399, 269)
	
	for i=1,15 do
		soulchange_posx[i] = 72*((i-1)%5)+10
		soulchange_posy[i] = 72*math.ceil(i/5)-60		
		
		soulchange_head[i] = wnd:AddImage(path_fight_soulchange.."sum_head.png", soulchange_posx[i], soulchange_posy[i], 66, 66)
		
		soulchange_side[i] = soulchange_head[i]:AddButton(path_fight_soulchange.."sum_side.png",path_fight_soulchange.."sum_side_1.png",path_fight_soulchange.."sum_side.png", -4, -4, 74, 74)
		soulchange_side[i]:SetTouchEnabled(0)
		
		soulchange_head[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			click_index = i+updownCount*5
			local L,T = soulchange_head[i]:GetPosition()
			soulchange_click:SetAbsolutePosition(L-4,T-4)
			soulchange_click:SetVisible(1)
		end
		soulchange_head[i].script[XE_LBDBCLICK] = function()
			XClickPlaySound(5)
			click_index = i+updownCount*5
			local L,T = soulchange_head[i]:GetPosition()
			soulchange_click:SetAbsolutePosition(L-4,T-4)
			soulchange_click:SetVisible(1)
			
			XClickSoulChangeHeroId(soulchangeInfo.Id[i+updownCount*5])
		end
	end
	soulchange_click = wnd:AddImage(path_fight_soulchange.."sum_click.png", 0, 0, 74, 74)
	soulchange_click:SetVisible(0)
	
	-- 选中后不再提示
	local check_buyMessage = wnd:AddImage(path_hero.."checkbox_hero.png",10,228,32,32)
	check_buyMessage:SetTouchEnabled(1)
	check_buyYes = check_buyMessage:AddImage(path_hero.."checkboxYes_hero.png",4,-2,32,32)
	check_buyYes:SetTouchEnabled(0)
	check_buyYes:SetVisible(0)
	check_buyMessage.script[XE_LBUP] = function()
		if (check_buyYes:IsVisible()) then
			check_buyYes:SetVisible(0)
			XClickSoulChangeCheckEnabled(0)
		else
			check_buyYes:SetVisible(1)
			XClickSoulChangeCheckEnabled(1)
		end
	end
	
	-- 召唤师头像滚动条
	soulchange_toggleBK = wnd:AddImage(path.."toggleBK_main.png",375,26,16,182)
	soulchange_togglebtn = soulchange_toggleBK:AddButton(path.."toggleBTN1_main.png",path.."toggleBTN2_main.png",path.."toggleBTN3_main.png",0,0,16,50)
	local ToggleT = soulchange_toggleBK:AddImage(path.."TD1_main.png",0,-16,16,16)
	local ToggleD = soulchange_toggleBK:AddImage(path.."TD1_main.png",0,182,16,16)
	
	XSetWindowFlag(soulchange_togglebtn.id,1,1,0,132)
	
	soulchange_togglebtn:ToggleBehaviour(XE_ONUPDATE, 1)
	soulchange_togglebtn:ToggleEvent(XE_ONUPDATE, 1)
	soulchange_togglebtn.script[XE_ONUPDATE] = function()
	
		if soulchange_togglebtn._T == nil then
			soulchange_togglebtn._T = 0
		end
		
		local L,T,R,B = XGetWindowClientPosition(soulchange_togglebtn.id)
		if soulchange_togglebtn._T ~= T then			
			local length = 0
			if #soulchangeInfo.pictureName <=15 then
				length = 132
			else
				length = 132/math.ceil((#soulchangeInfo.pictureName/5)-3)
			end
			local Many = math.floor(T/length)
			updownCount = Many
			
			if Many_soulchangeHead ~= Many then
				for i = 1, #soulchange_head do
					soulchange_head[i]:SetVisible(0)
				end
				for i=updownCount*5+1, #soulchangeInfo.pictureName do
					if i>updownCount*5 and i<updownCount*5+16 then
						soulchange_head[i-updownCount*5].changeimage(soulchangeInfo.pictureName[i])
						soulchange_head[i-updownCount*5]:SetImageTip(soulchangeInfo.Tip[i])
						soulchange_head[i-updownCount*5]:SetVisible(1)
					end
				end
				Many_soulchangeHead = Many
			end
			
			soulchange_click:SetVisible(0)
			soulchange_togglebtn._T = T
		end
	end
	
	XWindowEnableAlphaTouch(n_soulchange_ui.id)
	n_soulchange_ui:EnableEvent(XE_MOUSEWHEEL)
	n_soulchange_ui.script[XE_MOUSEWHEEL] = function()		
		local updown  = XGetMsgParam0()
		local length = 0

		if #soulchangeInfo.pictureName >15 then
			maxUpdown = math.ceil((#soulchangeInfo.pictureName/5)-3)
			length = 132/maxUpdown
		else
			maxUpdown = 0
			length = 132
		end
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
		btn_pos = length*updownCount
		
		soulchange_togglebtn:SetPosition(0,btn_pos)
		soulchange_togglebtn._T = btn_pos
		
		if updownCount >= 0 and updownCount <= maxUpdown then
			for i = 1, #soulchange_head do
				soulchange_head[i]:SetVisible(0)
			end
			for i=updownCount*5+1, #soulchangeInfo.pictureName do
				if i>updownCount*5 and i<updownCount*5+16 then
					soulchange_head[i-updownCount*5].changeimage(soulchangeInfo.pictureName[i])
					soulchange_head[i-updownCount*5]:SetImageTip(soulchangeInfo.Tip[i])
					soulchange_head[i-updownCount*5]:SetVisible(1)
				end
			end
			
			soulchange_click:SetVisible(0)
		end
	end
	
	wnd:AddFont("选中后不再提示", 15, 0, 40, 234, 200, 20, 0x8295cf)
	local Attention = wnd:AddFont("提示：双击购买，满状态替换英雄！", 11, 0, 180, 235, 200, 30, 0x8295cf)
	Attention:SetFontSpace(1,1)
	
end

-- 灵魂契约通信
function SetCheck_SoulChange(Enabled)
	check_buyYes:SetVisible(Enabled)
end

function Clear_SoulChange()
	soulchangeInfo = {}
	soulchangeInfo.pictureName = {}
	soulchangeInfo.Id = {}
	soulchangeInfo.Tip = {}
	for i,v in pairs(soulchange_head) do 
		soulchange_head[i]:SetVisible(0)
	end
	click_index = 0
	soulchange_click:SetVisible(0)
end

function Receive_SoulChange(pictureName,Id,tip)
	local index = #soulchangeInfo.pictureName+1
	soulchangeInfo.pictureName[index] = "..\\"..pictureName
	soulchangeInfo.Id[index] = Id
	soulchangeInfo.Tip[index] = tip
	
	if index>updownCount*5 and index<updownCount*5+16 then
		soulchange_head[index-updownCount*5].changeimage(soulchangeInfo.pictureName[index])
		soulchange_head[index-updownCount*5]:SetImageTip(soulchangeInfo.Tip[index])
		soulchange_head[index-updownCount*5]:SetVisible(1)
	end
end

-- 刷新灵魂契约位置
function Refresh_SoulChange()
	-- 滚动条恢复
	updownCount = 0
	maxUpdown = 0
	soulchange_togglebtn:SetPosition(0,0)
	soulchange_togglebtn._T = 0
	if #soulchangeInfo.Id <=15 then
		soulchange_toggleBK:SetVisible(0)
	else
		soulchange_toggleBK:SetVisible(1)
	end
	click_index = 0
	soulchange_click:SetVisible(0)
end

-- 灵魂契约通信完毕
function SetSoulChangeIsVisible(flag) 
	if n_soulchange_ui ~= nil then
		if flag == 1 and n_soulchange_ui:IsVisible() == false then
			n_soulchange_ui:CreateResource()
			n_soulchange_ui:SetVisible(1)
		elseif flag == 0 and n_soulchange_ui:IsVisible() == true then
			n_soulchange_ui:DeleteResource()
			n_soulchange_ui:SetVisible(0)
		end
	end
end

function GetSoulChangeIsVisible()  
    if(n_soulchange_ui:IsVisible()) then
       -- XSoulChangeIsOpen(1)
    else
       -- XSoulChangeIsOpen(0)
    end
end