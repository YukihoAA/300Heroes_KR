include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")


----选择召唤师技能界面
local Assist_BK1 = nil
local Assist_BK2 = nil
local Assist_BK3 = nil
local Font_skill1 = nil
local Font_skill2 = nil
local assist_skillA = nil
local assist_skillB = nil

local assist_icon = {}
local assist_hide = {}
local assist_side = {}
local assist_name = {}

------------------召唤师技能具体信息
local AskillInfo = {}
AskillInfo.strPictureName = {}	----技能图片路径
AskillInfo.strName = {}			----技能名称
AskillInfo.enabled = {}			----技能是否学习
AskillInfo.skillId = {}			----技能ID

function InitSummonerSkill_ui(wnd,bisopen)
	n_summonerskill_ui = CreateWindow(wnd.id, -10,-OffsetY1, 1280, 800)
	n_summonerskill_ui:EnableBlackBackgroundTop(1)
	InitMain_SummonerSkill(n_summonerskill_ui)
	n_summonerskill_ui:SetVisible(bisopen)
end
local movex = -0
local movey = -0
function InitMain_SummonerSkill(wnd)
	---------------------------------辅助技能窗口
	Assist_BK1 = wnd:AddImage(path_start.."BK1_start.png",704+movex,152+movey,346,357)
	Assist_BK2 = wnd:AddImage(path_start.."BK2_start.png",704+movex,152+movey,346,357)
	Assist_BK3 = wnd:AddImage(path_start.."BK3_start.png",704+movex,152+movey,346,306)
	Font_skill1 = wnd:AddImage(path_start.."summonerfont1_start.png",715+movex,135+movey,335,91)
	Font_skill2 = wnd:AddImage(path_start.."summonerfont2_start.png",715+movex,135+movey,335,91)
	
	assist_skillA = Assist_BK1:AddImage(path_equip.."bag_equip.png",119,301,50,50)
	assist_skillB = Assist_BK2:AddImage(path_equip.."bag_equip.png",179,301,50,50)

	for i=1,15 do
		local posx = 63*((i-1)%5+1)+663+movex
		local posy = 80*math.ceil(i/5)+127+movey
		assist_icon[i] = wnd:AddImage(path_equip.."bag_equip.png",posx,posy,50,50)
		assist_side[i] = assist_icon[i]:AddImage(path_start.."summonerSide_start.png",-3,-3,56,56)
		assist_side[i]:SetTouchEnabled(0)
		assist_hide[i] = assist_icon[i]:AddImage(path_start.."summonerEnabled_start.png",-3,-3,56,56)	
				
		--------修改召唤师技能
		assist_icon[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			XSendAssistId(AskillInfo.skillId[i],i-1)	
		end
	end

	local Assist_CLOSE = wnd:AddButton(path_hero.."closesmall1_hero.png",path_hero.."closesmall2_hero.png",path_hero.."closesmall3_hero.png",1015+movex,165+movey,32,32)
	Assist_CLOSE.script[XE_LBUP] = function()
		XClickPlaySound(5)
		SetSummonerSkillIsVisible(0)
	end
	
	for i=1,15 do
		assist_name[i] = assist_side[i]:AddFont("绝对无敌", 12, 8, 0, 0, 56, 130, 0xbeb5ee)
	end
end
-------------处理召唤师技能的通信
function AssistSkill_Clean()
	AskillInfo = {}
	AskillInfo.strPictureName = {}	----技能图片路径
	AskillInfo.strName = {}			----技能名称
	AskillInfo.enabled = {}			----要求召唤师技能等级8级
	AskillInfo.skillId = {}			----技能ID
	
	for i,v in pairs(assist_icon) do
		assist_icon[i]:SetVisible(0)
	end
end
function SendAssistSkillDataToLua(m_strPictureName,m_strName,m_Enabled,m_skillId,tip)
	local size = #AskillInfo.strName+1
		--log("\nFFFFF    "..m_strName.."  |  "..m_strPictureName)
	AskillInfo.strPictureName[size] = "..\\"..m_strPictureName			--log("\nm_strPictureName   "..m_strPictureName)
	AskillInfo.strName[size] = m_strName								--log("\nm_strName   "..m_strName)
	AskillInfo.enabled[size] = m_Enabled								--log("\nm_Enabled   "..m_Enabled)
	AskillInfo.skillId[size] = m_skillId								--log("\nm_skillId   "..m_skillId)
	
	assist_icon[size].changeimage(AskillInfo.strPictureName[size])
	assist_icon[size]:SetImageTip(tip)
	assist_hide[size]:SetImageTip(tip)
	assist_name[size]:SetFontText(AskillInfo.strName[size],0xbeb5ee)
	
	assist_icon[size]:SetVisible(1)
	assist_hide[size]:SetVisible(1-m_Enabled)
end



-----------当前选中的第一个召唤师技能
function Current_summonerskillA(picture1,tip1)
	assist_skillA.changeimage("..\\"..picture1)
	assist_skillA:SetImageTip(tip1)
end
-----------当前选中的第二个召唤师技能
function Current_summonerskillB(picture2,tip2)
	assist_skillB.changeimage("..\\"..picture2)
	assist_skillB:SetImageTip(tip2)
end
-----------选择召唤师的背景图文字修改
function changeSummonerSkillIndex(index)
	if index==1 then
		Assist_BK1:SetVisible(1)
		Assist_BK2:SetVisible(0)
		Assist_BK3:SetVisible(0)
		Font_skill1:SetVisible(1)
		Font_skill2:SetVisible(0)
	elseif index==2 then
		Assist_BK1:SetVisible(0)
		Assist_BK2:SetVisible(1)
		Assist_BK3:SetVisible(0)
		Font_skill1:SetVisible(0)
		Font_skill2:SetVisible(1)
	elseif index==3 then
		Assist_BK1:SetVisible(0)
		Assist_BK2:SetVisible(0)
		Assist_BK3:SetVisible(1)
		Font_skill1:SetVisible(1)
		Font_skill2:SetVisible(0)
	end
end


function SetSummonerSkillIsVisible(flag) 
	if n_summonerskill_ui ~= nil then
		if flag == 1 and n_summonerskill_ui:IsVisible() == false then
			n_summonerskill_ui:SetVisible(1)
		elseif flag == 0 and n_summonerskill_ui:IsVisible() == true then
			n_summonerskill_ui:SetVisible(0)
		end
	end
end