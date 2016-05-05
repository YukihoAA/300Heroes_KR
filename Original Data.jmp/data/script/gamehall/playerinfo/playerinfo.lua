include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")


---菜单栏
local btn_heroInfo = nil
local btn_heroTalent = nil
local btn_heroSkill = nil
local btn_heroAchievement = nil
local btn_heroVipLevel = nil
local btn_heroRankList = nil

local btn_ListBK = nil



function Init_PlayerInfoUI(wnd, bisopen)
	g_PlayerInfo_ui = CreateWindow(wnd.id, 0, 0, 1280, 800)
	InitMain_PlayerInfo(g_PlayerInfo_ui)
	g_PlayerInfo_ui:SetVisible(bisopen)
end

function InitMain_PlayerInfo(wnd)

	--底图背景
	wnd:AddImage(path_shop.."BK_shop.png",0,0,1280,800)
	wnd:AddImage(path.."upBK_hall.png",0,0,1280,54)
	wnd:AddImage(path.."upLine2_hall.png",0,54,1280,35)
	for i=1,4 do
		wnd:AddImage(path.."linecut_hall.png",163+110*i,60,2,32)
	end
	
	btn_ListBK = wnd:AddImage(path_start.."ListBK_start.png",0,0,256,38)
	
	InitGame_HeroInfoUI(g_PlayerInfo_ui, 0)				--个人信息界面
	InitGame_HeroTalentUI(G_login_ui, 0)				--天赋专精界面
	InitGame_HeroSkillUI(g_PlayerInfo_ui, 0)			--战斗技能界面
	InitGame_HeroAchievementUI(G_login_ui, 0)			--成就界面
	InitGame_HeroVipLevelUI(g_PlayerInfo_ui, 0)			--VIP等级界面
	InitGame_HeroRankListUI(g_PlayerInfo_ui, 0)			--排行榜界面
		
	--个人信息
	btn_heroInfo = wnd:AddCheckButton(path_info.."indexA1_info.png",path_info.."indexA2_info.png",path_info.."indexA3_info.png",165,53,110,33)
	XWindowEnableAlphaTouch(btn_heroInfo.id)
	btn_heroInfo.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(135,53)
		
		XGamePlayerInfoIsOpen()
		--SetGameHeroInfoIsVisible(1)
		SetGameHeroTalentIsVisible(0)
		SetGameHeroSkillIsVisible(0)
		SetGameHeroAchievementIsVisible(0)
		SetGameHeroVipLevelIsVisible(0)
		SetGameHeroRankListIsVisible(0)
		
		btn_heroTalent:SetCheckButtonClicked(0)
		btn_heroSkill:SetCheckButtonClicked(0)
		btn_heroAchievement:SetCheckButtonClicked(0)
		btn_heroVipLevel:SetCheckButtonClicked(0)
		btn_heroRankList:SetCheckButtonClicked(0)
	end
	--天赋专精
	btn_heroTalent = wnd:AddCheckButton(path_info.."indexB1_info.png",path_info.."indexB2_info.png",path_info.."indexB3_info.png",275,53,110,33)
	XWindowEnableAlphaTouch(btn_heroTalent.id)
	btn_heroTalent.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(245,53)
		
		SetGameHeroInfoIsVisible(0)
		XIsOpenTatle(1)
		--SetGameHeroTalentIsVisible(1)
		SetGameHeroSkillIsVisible(0)
		SetGameHeroAchievementIsVisible(0)
		SetGameHeroVipLevelIsVisible(0)
		SetGameHeroRankListIsVisible(0)
				
		btn_heroInfo:SetCheckButtonClicked(0)
		btn_heroSkill:SetCheckButtonClicked(0)
		btn_heroAchievement:SetCheckButtonClicked(0)
		btn_heroVipLevel:SetCheckButtonClicked(0)
		btn_heroRankList:SetCheckButtonClicked(0)
	end
	--战斗技能
	btn_heroSkill = wnd:AddCheckButton(path_info.."indexC1_info.png",path_info.."indexC2_info.png",path_info.."indexC3_info.png",385,53,110,33)
	XWindowEnableAlphaTouch(btn_heroSkill.id)
	btn_heroSkill.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(355,53)
		
		SetGameHeroInfoIsVisible(0)
		SetGameHeroTalentIsVisible(0)
		SetGameHeroSkillIsVisible(1)
		SetGameHeroAchievementIsVisible(0)
		SetGameHeroVipLevelIsVisible(0)
		SetGameHeroRankListIsVisible(0)
		
		btn_heroInfo:SetCheckButtonClicked(0)
		btn_heroTalent:SetCheckButtonClicked(0)
		btn_heroAchievement:SetCheckButtonClicked(0)
		btn_heroVipLevel:SetCheckButtonClicked(0)
		btn_heroRankList:SetCheckButtonClicked(0)
	end
	--成就
	btn_heroAchievement = wnd:AddCheckButton(path_info.."indexD1_info.png",path_info.."indexD2_info.png",path_info.."indexD3_info.png",495,53,110,33)
	XWindowEnableAlphaTouch(btn_heroAchievement.id)
	btn_heroAchievement.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(465,53)
		
		SetGameHeroInfoIsVisible(0)
		SetGameHeroTalentIsVisible(0)
		SetGameHeroSkillIsVisible(0)
		SetGameHeroAchievementIsVisible(1)
		SetGameHeroVipLevelIsVisible(0)
		SetGameHeroRankListIsVisible(0)
		
		btn_heroInfo:SetCheckButtonClicked(0)
		btn_heroTalent:SetCheckButtonClicked(0)
		btn_heroSkill:SetCheckButtonClicked(0)
		btn_heroVipLevel:SetCheckButtonClicked(0)
		btn_heroRankList:SetCheckButtonClicked(0)
	end
	--Vip等级
	btn_heroVipLevel = wnd:AddCheckButton(path_info.."indexE1_info.png",path_info.."indexE2_info.png",path_info.."indexE3_info.png",605,53,110,33)
	XWindowEnableAlphaTouch(btn_heroVipLevel.id)
	btn_heroVipLevel.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(575,53)
		
		SetGameHeroInfoIsVisible(0)
		SetGameHeroTalentIsVisible(0)
		SetGameHeroSkillIsVisible(0)
		SetGameHeroAchievementIsVisible(0)
		SetGameHeroVipLevelIsVisible(1)
		SetGameHeroRankListIsVisible(0)
		
		btn_heroInfo:SetCheckButtonClicked(0)
		btn_heroTalent:SetCheckButtonClicked(0)
		btn_heroSkill:SetCheckButtonClicked(0)
		btn_heroAchievement:SetCheckButtonClicked(0)
		btn_heroRankList:SetCheckButtonClicked(0)
	end
	--排行榜
	btn_heroRankList = wnd:AddCheckButton(path_info.."indexF1_info.png",path_info.."indexF2_info.png",path_info.."indexF3_info.png",715,53,110,33)
	XWindowEnableAlphaTouch(btn_heroRankList.id)
	btn_heroRankList:SetVisible(0)
	btn_heroRankList.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(685,53)
		
		SetGameHeroInfoIsVisible(0)
		SetGameHeroTalentIsVisible(0)
		SetGameHeroSkillIsVisible(0)
		SetGameHeroAchievementIsVisible(0)
		SetGameHeroVipLevelIsVisible(0)
		SetGameHeroRankListIsVisible(1)
		RankList_GetFirstRank()
		
		btn_heroInfo:SetCheckButtonClicked(0)
		btn_heroTalent:SetCheckButtonClicked(0)
		btn_heroSkill:SetCheckButtonClicked(0)
		btn_heroAchievement:SetCheckButtonClicked(0)
		btn_heroVipLevel:SetCheckButtonClicked(0)
	end
end

function SetPlayerInfoIsVisible(flag) 
	if g_PlayerInfo_ui ~= nil then
		if flag == 1 then
			g_PlayerInfo_ui:SetVisible(1)
			XShopUiIsClick(1, 0)
			XGamePlayerInfoIsOpen()
			
			SetGameHeroTalentIsVisible(0)
			SetGameHeroSkillIsVisible(0)
			SetGameHeroAchievementIsVisible(0)
			SetGameHeroVipLevelIsVisible(0)
			SetGameHeroRankListIsVisible(0)
		
			SetFourpartUIVisiable(1)
			
			btn_ListBK:SetPosition(135,53)
			btn_ListBK:SetVisible(1)
			btn_heroInfo:SetCheckButtonClicked(1)
			btn_heroTalent:SetCheckButtonClicked(0)
			btn_heroSkill:SetCheckButtonClicked(0)
			btn_heroAchievement:SetCheckButtonClicked(0)
			btn_heroVipLevel:SetCheckButtonClicked(0)
			btn_heroRankList:SetCheckButtonClicked(0)
		elseif flag == 0 and g_PlayerInfo_ui:IsVisible() == true then
			g_PlayerInfo_ui:SetVisible(0)
			
			SetGameHeroInfoIsVisible(0)
			SetGameHeroTalentIsVisible(0)
			SetGameHeroSkillIsVisible(0)
			SetGameHeroAchievementIsVisible(0)
			SetGameHeroVipLevelIsVisible(0)
			SetGameHeroRankListIsVisible(0)
		end
	end
end

function GetPlayerInfoIsVisible()  
    if g_PlayerInfo_ui~=nil and g_PlayerInfo_ui:IsVisible()==true then
       return 1
    else
       return 0
    end
end