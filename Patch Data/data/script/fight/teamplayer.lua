include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")


----队友信息界面
local Teamplayer = {}
local Teamdead = {}
local Teamdeadtime = {}
local Teamhp = {}
local Teammp = {}
local TeamR = {}
local TeamType = {}
local heroType = {path_fight_teamplayer.."mp.png",path_fight_teamplayer.."dender.png",path_fight_teamplayer.."energy.png"}

function InitTeamplayer_ui(wnd,bisopen)
	n_teamplayer_ui = CreateWindow(wnd.id, 0, 160, 100, 200)
	InitMain_Teamplayer(n_teamplayer_ui)
	n_teamplayer_ui:SetVisible(bisopen)
end

function InitMain_Teamplayer(wnd)

	for i=1,6 do
		local posx = ((i+1)%2)*40
		local posy = math.ceil(i/2)*50-50
		Teamplayer[i] = wnd:AddImage(path_fight_teamplayer.."Teamplayer_bk.png",posx,posy,36,36)
		Teamplayer[i]:SetVisible(0)
		Teamplayer[i]:AddImage(path_fight_teamplayer.."Teamplayer_bk.png",0,0,38,48)
		Teamhp[i] = Teamplayer[i]:AddImage(path_fight_teamplayer.."hp.png",1,38,36,4)
		Teammp[i] = Teamplayer[i]:AddImage(path_fight_teamplayer.."mp.png",1,44,36,4)
		TeamR[i] = Teamplayer[i]:AddImage(path_fight_teamplayer.."R.png",25,25,10,10)			
	end
	
end
-----------通信队友界面
function Teamplayer_Clear(index)
	Teamplayer[index]:SetVisible(0)
end
----------队友头像
function Teamplayer_SendData(head,index)
	Teamplayer[index].changeimage("..\\"..head)
	Teamplayer[index]:SetVisible(1)
end
----------队友复活时间
function Teamdead_SendData(index,ReliveTime,startTime)
	Teamplayer[index]:SetImageColdTimeFontColor(0xffff0000)
	Teamplayer[index]:SetImageColdTimeEx(ReliveTime,startTime,0)
end
----------队友死亡还是复活
function Teamplayer_DeadOrRelive(flag,index)
	if flag ==0 then
		Teamplayer[index]:SetEnabled(0)
	else
		Teamplayer[index]:SetEnabled(1)
	end
end
----------队友血量
function Teamhp_SendData(percent,index)
	Teamhp[index]:SetAddImageRect(Teamhp[index].id,0,0,percent*36,4,1,38,percent*36,4)
	Teamhp[index]:SetVisible(1)
end
function Teamhp_SetVisible(flag,index)
	Teamhp[index]:SetVisible(flag)
end
----------队友魔法值
function Teammp_SendData(percent,index)
	Teammp[index]:SetAddImageRect(Teammp[index].id,0,0,percent*36,4,1,44,percent*36,4)
	Teammp[index]:SetVisible(1)
end
function Teammp_SetVisible(flag,index)
	Teammp[index]:SetVisible(flag)
end
----------队友大招
function TeamR_SendData(flag,index)
	TeamR[index]:SetVisible(flag)
end
----------队友是什么类型
function TeamType_SendData(m_type,index)
	if m_type ==0 then
		Teammp[index]:SetVisible(0)
	elseif m_type ==1 then
		Teammp[index].changeimage(heroType[1])
		Teammp[index]:SetVisible(1)
	elseif m_type ==2 then
		Teammp[index].changeimage(heroType[2])
		Teammp[index]:SetVisible(1)
	elseif m_type ==3 then
		Teammp[index].changeimage(heroType[3])
		Teammp[index]:SetVisible(1)
	end
end

-- 设置显示
function SetTeamplayerIsVisible(flag) 
	if n_teamplayer_ui ~= nil then
		if flag == 1 and n_teamplayer_ui:IsVisible() == false then
			n_teamplayer_ui:CreateResource()
			n_teamplayer_ui:SetVisible(1)
		elseif flag == 0 and n_teamplayer_ui:IsVisible() == true then
			n_teamplayer_ui:DeleteResource()
			n_teamplayer_ui:SetVisible(0)
		end
	end
end

function GetTeamplayerIsVisible()  
    if( n_teamplayer_ui ~= nil and n_teamplayer_ui:IsVisible() ) then
		return 1
    else
		return 0
    end
end