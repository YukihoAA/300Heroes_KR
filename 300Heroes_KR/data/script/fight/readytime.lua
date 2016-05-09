include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")


----准备开始时间界面
local readyBK = nil
local mode_yhjj = nil

local Time = nil
local TimeFont = nil
local ReadyStateFont = nil

function InitReadyTime_ui(wnd,bisopen)
	n_readytime_ui = CreateWindow(wnd.id, 0, 0, 1280, 40)
	InitMain_ReadyTime(n_readytime_ui)
	n_readytime_ui:SetVisible(bisopen)
end

function InitMain_ReadyTime(wnd)
	readyBK = wnd:AddImage(path_start.."readyBK_start.png",405,5,484,53)
	
	Time = wnd:AddImage(path_start.."readyTime_start.png",248,5,256,64)
	
	ReadyStateFont = wnd:AddFontEx("Rq", 18, 0, 492, 18, 200, 20, 0xffffff)
	mode_yhjj = readyBK:AddFontEx( "康盔版扁厘", 18, 0, 200, 13, 300, 20, 0xffffff)
	TimeFont = Time:AddFontEx("60", 18, 8, 0, -23, 150, 20, 0xe4e18b, "HT")
end

function SetReadyTimeIsVisible(flag) 
	if n_readytime_ui ~= nil then
		if flag == 1 and n_readytime_ui:IsVisible() == false then
			n_readytime_ui:SetVisible(1)
		elseif flag == 0 and n_readytime_ui:IsVisible() == true then
			n_readytime_ui:SetVisible(0)
		end
	end
end

function GetReadyTimeIsVisible()  
    if(n_readytime_ui:IsVisible()) then
       -- XReadyTimeIsOpen(1)
    else
       -- XReadyTimeIsOpen(0)
    end
end

function SetTime_ReadyTime( cTime, cColor)
	TimeFont:SetFontText( cTime, cColor)
end

function SetTitleFont_readytime( cTitleInfo)
	mode_yhjj:SetFontText( cTitleInfo, 0xffffff)
end

function SetCurTitleState_teadytime( cState)
	if cState==1 then
		ReadyStateFont:SetFontText("康旷急琶Req", 0xffffff)
	else
		ReadyStateFont:SetFontText("免傈犬牢Req", 0xffffff)
	end
end

function SetReadyTimeTutorialState( cIsEnable)
	Time:EnableImageAnimateEX(cIsEnable, 10, 90, 0, 0, -100, 65)
end