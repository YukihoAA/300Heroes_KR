include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")


-----右上角击杀、助攻、死亡、补兵界面
local ping_pic = {path_fight.."ping_1.png",path_fight.."ping_2.png",path_fight.."ping_3.png"}
local ping_icon = nil
local data_info = {0,10,115,0}
local ping_info = {"12:00:00 08/28/15","ping:50","FPS:59fps"}
local kill,assist,killsolder,dead= nil
local xclientTime,ZHEN,FPS = nil


function InitData_ui(wnd,bisopen)
	n_data_ui = CreateWindow(wnd.id, 1920-279, 0, 279, 64)
	InitMain_Data(n_data_ui)
	n_data_ui:SetVisible(bisopen)
end

function InitMain_Data(wnd)

	local Me = wnd:AddImage(path_fight.."data.png",48,0,231,36)
	local data = wnd:AddImage(path_fight.."data_1.png",81,5,130,20)
	local ping_BK = wnd:AddImage(path_fight.."ping.png",0,35,279,28)
	
	--点击可点穿
	DisableRButtonClick(Me.id)
	DisableRButtonClick(data.id)
	DisableRButtonClick(ping_BK.id)
	
	
	ping_icon = wnd:AddImage(ping_pic[1],251,3,15,18)
		
	kill = wnd:AddFont(data_info[1],12,8,0,-5,220,20,0xffffff)
	assist = wnd:AddFont(data_info[2],12,8,0,-5,335,20,0xffffff)
	killsolder = wnd:AddFont(data_info[3],12,8,0,-5,450,20,0xffffff)
	dead = wnd:AddFont(data_info[4],12,8,0,-5,450,20,0xffffff)
	dead:SetVisible(0)
	
	
	xclientTime = wnd:AddFontEx(ping_info[1],12,8,15,-40,200,20,0xffffff)
	ZHEN = wnd:AddFontEx(ping_info[2],12,8,-77,-40,200,20,0xffffff)
	FPS = wnd:AddFontEx(ping_info[3],12,8,-140,-40,200,20,0xffffff)
	
end
function Update_lolData(m_xclientTime,str_zhen,m_zhen,m_fps,m_kill,m_assist,m_killsolder,m_dead)
	xclientTime:SetFontText(m_xclientTime,0xffffff)
	ZHEN:SetFontText(str_zhen .. m_zhen,0xffffff)
	FPS:SetFontText(m_fps,0xffffff)
	
	kill:SetFontText(m_kill,0xffffff)
	assist:SetFontText(m_assist,0xffffff)
	killsolder:SetFontText(m_killsolder,0xffffff)
	dead:SetFontText(m_dead,0xffffff)
	
	if m_zhen > 200 then
		ping_icon.changeimage(ping_pic[3])
	elseif m_zhen >100 then
		ping_icon.changeimage(ping_pic[2])
	else
		ping_icon.changeimage(ping_pic[1])
	end
end

--设置是否显示死亡数据
function SetData_DeadCountShow(deadshow)
	dead:SetVisible(deadshow)
end

----------设置显示
function SetDataIsVisible(flag,deadshow) 
	if n_data_ui ~= nil then
		if flag == 1 and n_data_ui:IsVisible() == false then
			n_data_ui:CreateResource()
			n_data_ui:SetVisible(1)
			SetData_DeadCountShow(deadshow)
		elseif flag == 0 and n_data_ui:IsVisible() == true then
			n_data_ui:DeleteResource()
			n_data_ui:SetVisible(0)
		end
	end
end

function GetDataIsVisible()  
    if n_data_ui~=nil and n_data_ui:IsVisible()==true then
		return 1
    else
		return 0
    end
end