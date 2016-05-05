include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

-- 进度条
local SkillName = nil
local CdTime = nil
local skilliconimage = nil
local StrLineBlue = nil
local strLineRed = nil
local back = nil


function InitTimeProgress_ui(wnd,bisopen)
	n_TimeProgress_ui = CreateWindow(wnd.id, 0, 0, 259, 26)
	InitTimeProgress(n_TimeProgress_ui)
	n_TimeProgress_ui:SetVisible(0)
end

function InitTimeProgress(wnd)
   back = wnd:AddImage(path_equip.."progress.png", 0, 0, 259, 26)  
   back:SetTouchEnabled(0)
   strLineRed = wnd:AddImage(path_equip.."progressRed.png",0,40,259,26)
   strLineRed:SetAddImageRect(strLineRed.id, 0,40, 259*(0/1000), 26, 0,40, 259*(0/1000), 26)
   strLineRed:SetTouchEnabled(0)
   
   StrLineBlue = wnd:AddImage(path_equip.."progressBlue.png",0,0,259,26)
   StrLineBlue:SetAddImageRect(StrLineBlue.id, 0, 0, 259*(0/1000), 26, 0 ,0, 259*(0/1000), 26) 
   StrLineBlue:SetTouchEnabled(0)
   SkillName = wnd:AddFont("", 12, 8, 0, 0, 259, 26, 0xc4ffff)
   CdTime = wnd:AddFont("", 12, 6, 0, 0, 245, 26, 0xc4ffff)
   wnd:SetVisible(0) 
end

-- 消息二
function SetTimeProgressSkillName(strText)
    SkillName:SetFontText(strText,0xc4ffff)
end

-- 蓝
function SetTimeProgressStrExp(CurExp)
    if CurExp>1000 or CurExp<0 then
	    return
    end
	if(StrLineBlue:IsVisible()) then
        StrLineBlue:SetAddImageRect(StrLineBlue.id, 0, 0, 259*(CurExp/1000), 26, 0 ,0, 259*(CurExp/1000), 26)	
	end
	if(strLineRed:IsVisible()) then
        strLineRed:SetAddImageRect(strLineRed.id, 0, 0, 259*(CurExp/1000), 26, 0 ,0, 259*(CurExp/1000), 26)	
	end
end

function SetTimeProgressStrExpVisible(ibool)
	if(strLineRed:IsVisible() == true) then
	    strLineRed:SetVisible(0)
	end	
	if(StrLineBlue:IsVisible() == false) then
	    StrLineBlue:SetVisible(1)
	end
	SetTimeProgressIsVisible(1)
end


function SetTimeProgressStrExpRedVisible()
	if(strLineRed:IsVisible() == false) then
	    strLineRed:SetVisible(1)
	end	
	if(StrLineBlue:IsVisible() == true) then
	    StrLineBlue:SetVisible(0)
	end
	SetTimeProgressIsVisible(1)
end


function SetTimeProgressSkillCD(strText)
    CdTime:SetFontText(strText,0xc4ffff)
end

-- 设置显示
function SetTimeProgressIsVisible(flag) 
	if n_TimeProgress_ui ~= nil then
		if flag == 1 and n_TimeProgress_ui:IsVisible() == false then
			n_TimeProgress_ui:CreateResource()
			n_TimeProgress_ui:SetVisible(1)
		elseif flag == 0 and n_TimeProgress_ui:IsVisible() == true then
			n_TimeProgress_ui:DeleteResource()
			n_TimeProgress_ui:SetVisible(0)
		end
	end
end

