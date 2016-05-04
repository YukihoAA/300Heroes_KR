include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

--消息界面
local message = nil
local btn_jieshou = nil
local btn_yes = nil
local btn_skip = nil
local btn_confirm = nil
local btn_cancel = nil
local btn_no = nil
local btn_jujue = nil
local btn_continue = nil

local Font_jieshou = nil
local Font_yes = nil
local Font_skip = nil
local Font_confirm = nil
local Font_cancel = nil
local Font_no = nil
local Font_jujue = nil
local Font_continue = nil

local Back = nil
local pullPosX = 100
local pullPosY = 100

function InitMessageBox_ui(wnd,bisopen)
	n_messagebox_ui = CreateWindow(wnd.id, (1920-402)/2, (1080-280)/2, 402, 280)
	n_messagebox_ui:EnableBlackBackgroundTop(1)
	InitMain_MessageBox(n_messagebox_ui)
	n_messagebox_ui:SetVisible(bisopen)
end

function InitMain_MessageBox(wnd)
	Back = wnd:AddImage(path_hero.."message_hero.png",0,0,402,280)
	Back:AddImage(path_hero.."messagefont_hero.png",0,0,402,37)
	
	
	btn_jieshou = wnd:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",30,220,90,40)	
	btn_yes = wnd:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",30,220,90,40)	
	btn_skip = wnd:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",30,220,90,40)		
	btn_confirm = wnd:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",156,220,90,40)		
	btn_cancel = wnd:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",282,220,90,40)	
	btn_no = wnd:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",282,220,90,40)	
	btn_jujue = wnd:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",282,220,90,40)	
	btn_continue = wnd:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",282,220,90,40)
	
	
	btn_jieshou.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickMessageBoxIndex(1)
	end
	btn_yes.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickMessageBoxIndex(2)
	end
	btn_skip.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickMessageBoxIndex(3)
	end
	btn_confirm.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickMessageBoxIndex(4)
	end
	btn_cancel.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickMessageBoxIndex(5)
	end
	btn_no.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickMessageBoxIndex(6)
	end
	btn_jujue.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickMessageBoxIndex(7)
	end
	btn_continue.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickMessageBoxIndex(8)
	end
	
	n_messagebox_ui:ToggleBehaviour(XE_ONUPDATE, 1)	-- 添加消息
	
    Back.script[XE_LBDOWN] = function()
	    n_messagebox_ui:ToggleEvent(XE_ONUPDATE, 1)	-- 添加消息	
		local L,T = n_messagebox_ui:GetPosition()
		pullPosX = XGetCursorPosX()-L
		pullPosY = XGetCursorPosY()-T
	end
	Back.script[XE_LBUP] = function()
	    n_messagebox_ui:ToggleEvent(XE_ONUPDATE, 0)	-- 添加消息	
	end	
	n_messagebox_ui.script[XE_ONUPDATE] = function()--当鼠标移动时 --响应拖拽
		if(n_messagebox_ui:IsVisible()) then
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
		    n_messagebox_ui:SetAbsolutePosition(PosX,PosY)
		else
	        n_messagebox_ui:ToggleEvent(XE_ONUPDATE, 0)	-- 添加消息	
		end
	end
	
	message = wnd:AddFont("服务器挂了有没有！！！", 15, 0, 40, 60, 330, 150, 0xbeb9cf)
	--message:SetFontSpace(1,0)
	Font_jieshou = btn_jieshou:AddFont("接受",15,8,0,0,90,42,0xbeb5ee)
	Font_yes = btn_yes:AddFont("是",15,8,0,0,90,42,0xbeb5ee)
	Font_skip = btn_skip:AddFont("跳过",15,8,0,0,90,42,0xbeb5ee)
	Font_confirm = btn_confirm:AddFont("确认",15,8,0,0,90,42,0xbeb5ee)
	Font_cancel = btn_cancel:AddFont("取消",15,8,0,0,90,42,0xbeb5ee)
	Font_no = btn_no:AddFont("否",15,8,0,0,90,42,0xbeb5ee)
	Font_jujue = btn_jujue:AddFont("拒绝",15,8,0,0,90,42,0xbeb5ee)
	Font_continue = btn_continue:AddFont("继续",15,8,0,0,90,42,0xbeb5ee)
end

function SendDataToMessage(messageFont,color)
	message:SetFontText(messageFont,color)
end
function SendjieshouMessage(Font)
	Font_jieshou:SetFontText(Font,0xbeb5ee)
end
function SendyesMessage(Font)
	Font_yes:SetFontText(Font,0xbeb5ee)
end
function SendcontinueMessage(Font)
	Font_continue:SetFontText(Font,0xbeb5ee)
end
function SendskipMessage(Font)
	Font_skip:SetFontText(Font,0xbeb5ee)
end
function SendconfirmMessage(Font)
	Font_confirm:SetFontText(Font,0xbeb5ee)
end
function SendcancelMessage(Font)
	Font_cancel:SetFontText(Font,0xbeb5ee)
end
function SendnoMessage(Font)
	Font_no:SetFontText(Font,0xbeb5ee)
end
function SendjujueMessage(Font)
	Font_jujue:SetFontText(Font,0xbeb5ee)
end
function MessageBtnSetVisible(jieshou,yes,skip,confirm,cancel,no,jujue,continue)
	btn_jieshou:SetVisible(jieshou)
	btn_yes:SetVisible(yes)
	btn_skip:SetVisible(skip)
	btn_confirm:SetVisible(confirm)
	btn_cancel:SetVisible(cancel)
	btn_no:SetVisible(no)
	btn_jujue:SetVisible(jujue)
	btn_continue:SetVisible(continue)
end
function SetMessageBoxIsVisible(flag) 
	if n_messagebox_ui ~= nil then
		if flag == 1 and n_messagebox_ui:IsVisible() == false then
			n_messagebox_ui:CreateResource()
			n_messagebox_ui:SetVisible(1)
		elseif flag == 0 and n_messagebox_ui:IsVisible() == true then
			n_messagebox_ui:DeleteResource()
			n_messagebox_ui:SetVisible(0)
		end
	end
end

function GetMessageBoxIsVisible()  
    if(n_messagebox_ui:IsVisible()) then
       XMessageBoxIsOpen(1)
    else
       XMessageBoxIsOpen(0)
    end
end