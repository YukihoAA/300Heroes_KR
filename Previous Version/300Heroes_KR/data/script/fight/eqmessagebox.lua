include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

--消息界面
local btn_Close = nil
local message1 = nil
local message2 = nil

local btn_yuanbao = nil
local btn_gold = nil
local btn_charge = nil

local Font_yuanbao = nil
local Font_gold = nil
local Font_charge = nil

local EqmessageFont = nil

local AutoBtn = nil

local Back = nil
local pullPosX = 100
local pullPosY = 100

function InitEqMessageBox_ui(wnd,bisopen)
	n_eqmessagebox_ui = CreateWindow(wnd.id, (1920-402)/2, (1080-280)/2, 402, 280)
	n_eqmessagebox_ui:EnableBlackBackgroundTop(1)
	InitMain_EqMessageBox(n_eqmessagebox_ui)
	n_eqmessagebox_ui:SetVisible(bisopen)
end


function InitMain_EqMessageBox(wnd)
	Back = wnd:AddImage(path_hero.."message_hero.png",0,0,402,280)	
	Back:AddImage(path_hero.."messagefont_hero.png",0,0,402,37)
	btn_Close = wnd:AddButton(path_shop.."close1_rec.png",path_shop.."close2_rec.png",path_shop.."close3_rec.png",362,4,35,35)
	btn_Close.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		n_eqmessagebox_ui:SetVisible(0)
	end
		
	btn_yuanbao = wnd:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",30,220,90,40)
	btn_gold = wnd:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",156,220,90,40)
	btn_charge = wnd:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",282,220,90,40)
	AutoBtn = wnd:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",282,170,90,40)
	btn_yuanbao.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickEqMessageBoxIndex(1)
	end
	btn_gold.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickEqMessageBoxIndex(2)
	end
	btn_charge.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGameSigninToAddMoney(1)
	end	
	AutoBtn.script[XE_LBUP] = function()
		XClickPlaySound(5)
        if(n_Autobox_ui:IsVisible()==false) then
		    SetAutoBoxIsVisible(1)
			n_eqmessagebox_ui:SetVisible(0)
        end		
	end
	
	n_eqmessagebox_ui:ToggleBehaviour(XE_ONUPDATE, 1)	-- 添加消息
	
    Back.script[XE_LBDOWN] = function()
	    n_eqmessagebox_ui:ToggleEvent(XE_ONUPDATE, 1)	-- 添加消息	
		local L,T = n_eqmessagebox_ui:GetPosition()
		pullPosX = XGetCursorPosX()-L
		pullPosY = XGetCursorPosY()-T
	end
	Back.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
	    n_eqmessagebox_ui:ToggleEvent(XE_ONUPDATE, 0)	-- 添加消息	
	end	
	n_eqmessagebox_ui.script[XE_ONUPDATE] = function()--当鼠标移动时 --响应拖拽
		if(n_eqmessagebox_ui:IsVisible()) then
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
		    n_eqmessagebox_ui:SetAbsolutePosition(PosX,PosY)
		else
		    n_eqmessagebox_ui:ToggleEvent(XE_ONUPDATE, 0)	-- 添加消息	
		end
	end
	----文字
	message1 = wnd:AddFont("焊籍荤侩", 15, 0, 30, 50, 340, 60, 0xbeb9cf)
	message2 = wnd:AddFont("陛拳荤侩", 15, 0, 30, 100, 340, 60, 0xbeb9cf)
	Font_yuanbao = btn_yuanbao:AddFont("焊籍荤侩",15,0,10,10,100,15,0xbeb5ee)	
	Font_gold = btn_gold:AddFont("陛拳荤侩",15,0,10,10,100,15,0xbeb5ee)	
	Font_charge = btn_charge:AddFont("面傈",15,0,25,10,100,15,0xbeb5ee)
	AutoBtn:AddFont("磊悼碍拳",15,0,10,10,100,15,0xbeb5ee)
	
end
-----------消息一
function SendDataToEqMessage1(messageFont,color)
	message1:SetFontText(messageFont,color)
	if(messageFont~= "") then
	   EqmessageFont = messageFont
	end   
end
function GetDataToEqMessage1()
    return EqmessageFont
end


-- 消息二
function SendDataToEqMessage2(messageFont,color)
	message2:SetFontText(messageFont,color)
end
-- 使用钻石文字
function SendYuanbaoToEqMessage(Font)
	Font_yuanbao:SetFontText(Font,0xbeb5ee)
end
-- 使用金币
function SendGoldToEqMessage(Font)
	Font_gold:SetFontText(Font,0xbeb5ee)
end
-- 三个按钮是否可见
function EqMessageBtnSetVisible(yuanbao,gold,charge)
	btn_yuanbao:SetVisible(yuanbao)
	btn_gold:SetVisible(gold)
	btn_charge:SetVisible(charge)
	if(g_str_Strength_ui:IsVisible() == true) then
	    AutoBtn:SetVisible(1)
	else
	    AutoBtn:SetVisible(0)
	end
end
-- 三个按钮是否可点
function EqMessageBtnSetEnable(yuanbao,gold,charge)
	btn_yuanbao:SetEnabled(yuanbao)
	btn_gold:SetEnabled(gold)
	btn_charge:SetEnabled(charge)
end
function SetEqMessageBoxIsVisible(flag) 
	if n_eqmessagebox_ui ~= nil then
		if flag == 1 and n_eqmessagebox_ui:IsVisible() == false then
			n_eqmessagebox_ui:CreateResource()
			n_eqmessagebox_ui:SetVisible(1)
		elseif flag == 0 and n_eqmessagebox_ui:IsVisible() == true then
			n_eqmessagebox_ui:DeleteResource()
			n_eqmessagebox_ui:SetVisible(0)
		end
	end
end

function GetEqMessageBoxIsVisible()  
    if(n_eqmessagebox_ui ~= nil and n_eqmessagebox_ui:IsVisible()) then
       return 1
    else
       return 0
    end
end