include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

--消息界面
local AgreeBtn = nil
local Refusebtn = nil
local message1= nil
local message2 = nil

local Back = nil
local pullPosX = 100
local pullPosY = 100

function InitTalkMessageBox_ui(wnd,bisopen)
	n_talkmessagebox_ui = CreateWindow(wnd.id, (1920-402)/2, (1080-280)/2, 402, 280)
	n_talkmessagebox_ui:EnableBlackBackgroundTop(1)
	InitMain_talkMessageBox(n_talkmessagebox_ui)
	n_talkmessagebox_ui:SetVisible(bisopen)
end

function InitMain_talkMessageBox(wnd)
	Back = wnd:AddImage(path_hero.."message_hero.png",0,0,402,280)
	
	message1 = n_talkmessagebox_ui:AddFont("焊籍荤侩", 15, 8, -42, -75, 315, 90, 0xbeb9cf)
	
	AgreeBtn = wnd:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",68,220,90,40)
	AgreeBtn:AddFont("悼狼",15,0,25,10,100,15,0xbeb5ee)
	
	Refusebtn = wnd:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",244,220,90,40)
	Refusebtn:AddFont("芭何",15,0,25,10,100,15,0xbeb5ee)
	
	AgreeBtn.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickTalkMessageBoxIndex(1)
	end
	Refusebtn.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickTalkMessageBoxIndex(2)
	end
	
	Back.script[XE_LBDOWN] = function()
	    n_talkmessagebox_ui:ToggleEvent(XE_ONUPDATE, 1)	-- 添加消息	
		local L,T = n_talkmessagebox_ui:GetPosition()
		pullPosX = XGetCursorPosX()-L
		pullPosY = XGetCursorPosY()-T
	end
	Back.script[XE_LBUP] = function()
	    n_talkmessagebox_ui:ToggleEvent(XE_ONUPDATE, 0)	-- 添加消息	
	end	
	n_talkmessagebox_ui.script[XE_ONUPDATE] = function()--当鼠标移动时 --响应拖拽
		if(n_talkmessagebox_ui:IsVisible()) then
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
		    n_talkmessagebox_ui:SetAbsolutePosition(PosX,PosY)
		else
	        n_talkmessagebox_ui:ToggleEvent(XE_ONUPDATE, 0)	-- 添加消息	
		end
	end
	
end

function SendDataTotalkMessage1(messageFont)
	message1:SetFontText(messageFont,0xbeb9cf)
end
-----------消息二
------

function SettalkMessageBoxIsVisible(flag) 
	if n_talkmessagebox_ui ~= nil then
		if flag == 1 and n_talkmessagebox_ui:IsVisible() == false then
			n_talkmessagebox_ui:CreateResource()
			n_talkmessagebox_ui:SetVisible(1)
		elseif flag == 0 and n_talkmessagebox_ui:IsVisible() == true then
			n_talkmessagebox_ui:DeleteResource()
			n_talkmessagebox_ui:SetVisible(0)
		end
	end
end

