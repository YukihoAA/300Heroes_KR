include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")


----退出游戏界面
local message = nil
local btn_cancel,Font_cancel = nil

function InitExitWait_ui(wnd,bisopen)
	n_exitwait_ui = CreateWindow(wnd.id, (1920-402)/2, (1080-280)/2, 402, 280)
	n_exitwait_ui:EnableBlackBackgroundTop(1)
	InitMain_ExitWait(n_exitwait_ui)
	n_exitwait_ui:SetVisible(bisopen)
end

function InitMain_ExitWait(wnd)
	wnd:AddImage(path_hero.."message_hero.png",0,0,402,280)
	wnd:AddImage(path_hero.."messagefont_hero.png",0,0,402,37)
	btn_cancel = wnd:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",282,220,90,40)
	btn_cancel.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickExitWaitCancel(1)
	end
	
	message = wnd:AddFont("确认退出倒数计时543210", 15, 0, 42, 35, 315, 180, 0xbeb9cf)
	Font_cancel = btn_cancel:AddFont("取消",15,8,0,0,90,42,0xbeb5ee)
end

function SendDataToExitWait(messageFont)
	message:SetFontText(messageFont)
end

function SetExitWaitIsVisible(flag) 
	if n_exitwait_ui ~= nil then
		if flag == 1 and n_exitwait_ui:IsVisible() == false then
			n_exitwait_ui:CreateResource()
			n_exitwait_ui:SetVisible(1)
		elseif flag == 0 and n_exitwait_ui:IsVisible() == true then
			n_exitwait_ui:DeleteResource()
			n_exitwait_ui:SetVisible(0)
		end
	end
end

function GetExitWaitIsVisible()  
    if(n_exitwait_ui:IsVisible()) then
       -- XGameHeroSkinIsOpen(1)
    else
       -- XGameHeroSkinIsOpen(0)
    end
end