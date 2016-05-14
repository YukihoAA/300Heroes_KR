include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

--消息界面
local btn_Close = nil
local message1 = nil
local message2 = nil

local btn_yuanbao = nil
local btn_gold = nil

local Font_yuanbao = nil
local Font_gold = nil


local Back = nil
local pullPosX = 100
local pullPosY = 100

local Cancel = 0

function InitAutoBox_ui(wnd,bisopen)
	n_Autobox_ui = CreateWindow(wnd.id, (1920-702)/2, (1080-580)/2, 402, 280)
	n_Autobox_ui:EnableBlackBackgroundTop(1)
	InitMain_Autobox(n_Autobox_ui)
	n_Autobox_ui:SetVisible(bisopen)
end


function InitMain_Autobox(wnd)
	Back = wnd:AddImage(path_hero.."message_hero.png",0,0,402,280)
	Back:AddImage(path_hero.."messagefont_hero.png",0,0,402,37)
	btn_Close = wnd:AddButton(path_shop.."close1_rec.png",path_shop.."close2_rec.png",path_shop.."close3_rec.png",362,6,35,35)
	btn_Close.script[XE_LBUP] = function()
		XClickPlaySound(5)
		n_Autobox_ui:SetVisible(0)
		n_eqmessagebox_ui:SetVisible(1)
	end
	
	
	message1 = wnd:AddFont("使用钻石", 15,  0, 30, 50, 340, 90, 0xffffff)
	
	wnd:AddFont("自动强化说明\n强化至下一星级后,自动停止\n强化消耗货币不足时,自动停止\n强化成功时,自动停止\n材料不足时,自动使用货币支付",15, 0, 42, 100, 315, 200, 0xfecf2e)
	
	btn_yuanbao = wnd:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",28,220,90,40)
	Font_yuanbao = btn_yuanbao:AddFont("使用钻石",15,0,10,10,100,15,0xbeb5ee)
	
	btn_gold = wnd:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",278,220,90,40)
	Font_gold = btn_gold:AddFont("使用金币",15,0,10,10,100,15,0xbeb5ee)
	
	
	btn_yuanbao.script[XE_LBUP] = function()
		XClickPlaySound(5)
	    if(Cancel == 0) then
	        XSetAutoStrengthEquip(2) --2为使用钻石--1为使用金币--0为停止使用
		    XClickEqMessageBoxIndex(1)
			Cancel = 1
			btn_gold:SetEnabled(0)
			Font_yuanbao:SetFontText("停止强化",0xbeb5ee)
			btn_Close:SetVisible(0)
	    else	
		    XCancelAutoStrengthEquip()
			SetAutoBoxIsVisible(0)
	    end
	end	 
	btn_gold.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if(Cancel == 0) then
	        XSetAutoStrengthEquip(1) --2为使用钻石--1为使用金币--0为停止使用
		    XClickEqMessageBoxIndex(2)
			Cancel = 1
			btn_yuanbao:SetEnabled(0)
			Font_gold:SetFontText("停止强化",0xbeb5ee)
			btn_Close:SetVisible(0)
		else
            XCancelAutoStrengthEquip()
			SetAutoBoxIsVisible(0)
        end		
	end
	
	
	
	
	
	
	n_Autobox_ui:ToggleBehaviour(XE_ONUPDATE, 1)	-- 添加消息
	
    Back.script[XE_DRAG] = function()
	    n_Autobox_ui:ToggleEvent(XE_ONUPDATE, 1)	-- 添加消息	
		local L,T = n_Autobox_ui:GetPosition()
		pullPosX = XGetCursorPosX()-L
		pullPosY = XGetCursorPosY()-T
	end
	Back.script[XE_LBUP] = function()
	    n_Autobox_ui:ToggleEvent(XE_ONUPDATE, 0)	-- 添加消息	
	end	
	n_Autobox_ui.script[XE_ONUPDATE] = function()--当鼠标移动时 --响应拖拽
		if(n_Autobox_ui:IsVisible()) then
		    local x = XGetCursorPosX()
			local y = XGetCursorPosY()
			local w,h = Back:GetWH()
			local PosX
			local PosY
            PosX = x- pullPosX
			if(PosX < 0) then
			    PosX = 0
			elseif(PosX > windowswidth-w)	then
			    PosX = windowswidth - w
			end
			PosY = y- pullPosY
			if(PosY < 0) then
			    PosY = 0
			elseif(PosY > windowsheight - h)	then
			    PosY = windowsheight - h
			end			
		    n_Autobox_ui:SetAbsolutePosition(PosX,PosY)
		else
	        n_Autobox_ui:ToggleEvent(XE_ONUPDATE, 0)	-- 添加消息	
		end
	end
end

function AutoboxRestorn()
    Font_yuanbao:SetFontText("使用钻石",0xbeb5ee)
    Font_gold:SetFontText("使用金币",0xbeb5ee)
	Cancel = 0
	btn_yuanbao:SetEnabled(1)
	btn_gold:SetEnabled(1)
	btn_Close:SetVisible(1)
end

function CancelAutaStrength()
    if n_Autobox_ui:IsVisible() == true then
        XCancelAutoStrengthEquip()
		SetAutoBoxIsVisible(0)
	end		
end

function CheckAutaStrengthIsvisible()
    if(n_Autobox_ui:IsVisible()) then
	    return true
	else
        return false	
	end
end


function SetAutoBoxIsVisible(flag) 
	if n_Autobox_ui ~= nil then
		if flag == 1 and n_Autobox_ui:IsVisible() == false then
			n_Autobox_ui:CreateResource()
			n_Autobox_ui:SetVisible(1)
			message1:SetFontText(GetDataToEqMessage1(),0xbeb5ee)
		elseif flag == 0 and n_Autobox_ui:IsVisible() == true then
			n_Autobox_ui:DeleteResource()
			n_Autobox_ui:SetVisible(0)
			AutoboxRestorn()
		end
	end
end
