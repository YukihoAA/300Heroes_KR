include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

local m_pTabBG = nil								-- 底图
local m_vcSummonerInfoList = {}						-- 召唤师信息列表
m_vcSummonerInfoList.Icon = {}						-- 头像, 父节点以下所有控件都继承与此
m_vcSummonerInfoList.Level = {}						-- 等级
m_vcSummonerInfoList.SummonerSkillBG = {}			-- 召唤师技能底图
m_vcSummonerInfoList.SummonerSkill_1 = {}			-- 召唤师技能1
m_vcSummonerInfoList.SummonerSkill_2 = {}      		-- 召唤师技能2
m_vcSummonerInfoList.SummonerName = {}				-- 召唤师名字
m_vcSummonerInfoList.EquipBG = {}					-- 装备底图
m_vcSummonerInfoList.LOLData = {}					-- 击杀/助攻/补兵
m_vcSummonerInfoList.Death = {}						-- 死亡遮罩
m_vcSummonerInfoList.DeathTime = {}					-- 死亡时间
m_vcSummonerInfoList.GameState = {}					-- 剑拳盾
local m_EquipIconList = {}							-- 装备
local m_EquipIconListCount = {}						-- 装备个数
local m_Equipforbidden = {}							-- 专属

local m_vcSummonerAddFriend = {}					-- 添加好友
local m_vcSummonerAddFriendUn = {}
local m_vcSummonerPraise = {}						-- 赞 ~\(≧▽≦)/~
local m_vcSummonerPraiseUn = {}

-- Data
local m_SummonerListInfo = {}						-- 召唤师具体信息
m_SummonerListInfo.IconPath = {}					-- 头像路径
m_SummonerListInfo.Level = {}						-- 等级
m_SummonerListInfo.SummonerSkill_1 = {}				-- 召唤师技能路径1
m_SummonerListInfo.SummonerSkill_2 = {}				-- 召唤师技能路径2
m_SummonerListInfo.SummonerName = {}				-- 召唤师名字
m_SummonerListInfo.HeroName = {}					-- 英雄名字
m_SummonerListInfo.JiSha = {}						-- 击杀
m_SummonerListInfo.ZhuGong = {}						-- 助攻
m_SummonerListInfo.BuBing = {}						-- 补兵
m_SummonerListInfo.Team = {}						-- 所在队伍用1和2表示
m_SummonerListInfo.TabIndex = {}					-- 在Tab界面上的位置
m_SummonerListInfo.IsMe = {}						-- 是不是自己

-- 以下五个表用来判断是否需要调用changeimage或播放帧动画函数
local LastShinState = {}							-- 闪
local LastIconPath = {}								-- 英雄图片
local LastSkill_1 = {}								-- 召唤师技能
local LastSkill_2 = {}
local LastEquipPath = {}							-- 装备图片

function InitTab_ui(wnd,bisopen)
	n_tab_ui = CreateWindow(wnd.id, (1920-872)/2, (1080-408)/2, 872, 408)
	InitMain_Tab(n_tab_ui)
	n_tab_ui:SetVisible(bisopen)
end

function InitMain_Tab(wnd)
	m_pTabBG = wnd:AddImage( path_fight_tab.."TabBg.png", 0, 0, 872, 408)
	local me = m_pTabBG:AddImage(path_fight_tab.."MyInfoBG.png", 13, 52, 423, 50)
	
	for i=1, 84 do
		LastShinState[i] = 0
	end
	
	DisableRButtonClick(m_pTabBG.id)
	DisableRButtonClick(me.id)
	
	-- 创建召唤师信息列表 - Blue
	for i = 1, 7 do
		m_vcSummonerInfoList.Icon[i] = m_pTabBG:AddImage(path_fight.."Me_equip.png", 52, 59+(50*(i-1)), 36, 36)
		DisableRButtonClick(m_vcSummonerInfoList.Icon[i].id)
		
		local frame = m_vcSummonerInfoList.Icon[i]:AddImage(path_fight_tab.."SummonerFrame.png", -2, -2, 44, 40)
		DisableRButtonClick(frame.id)
		
		m_vcSummonerInfoList.GameState[i] = m_vcSummonerInfoList.Icon[i]:AddImage(path_server.."static1_server.png", -35, 5, 32, 32)
		m_vcSummonerInfoList.GameState[i]:SetVisible(0)
		
		m_vcSummonerInfoList.SummonerSkillBG[i] = m_vcSummonerInfoList.Icon[i]:AddImage(path_fight_tab.."SummonerSkillBGBlue.png", 48, -4, 22, 43)
		DisableRButtonClick(m_vcSummonerInfoList.SummonerSkillBG[i].id)
		
		m_vcSummonerInfoList.EquipBG[i] = m_vcSummonerInfoList.Icon[i]:AddImage(path_fight_tab.."EquipBGBlue.png", 84, 11, 151, 26)
		DisableRButtonClick(m_vcSummonerInfoList.EquipBG[i].id)
		
		m_vcSummonerInfoList.SummonerSkill_1[i] = m_vcSummonerInfoList.SummonerSkillBG[i]:AddImage(path_fight.."Me_equip.png", 1, 1, 20, 20)
		m_vcSummonerInfoList.SummonerSkill_2[i] = m_vcSummonerInfoList.SummonerSkillBG[i]:AddImage(path_fight.."Me_equip.png", 1, 21, 20, 20)
		DisableRButtonClick(m_vcSummonerInfoList.SummonerSkill_1[i].id)
		DisableRButtonClick(m_vcSummonerInfoList.SummonerSkill_2[i].id)
		
		for k = 1, 6 do
			m_EquipIconList[k+(i-1)*6] = m_vcSummonerInfoList.EquipBG[i]:AddImage(path_fight.."Me_equip.png", 1+(k-1)*25, 1, 24, 24)
			m_Equipforbidden[k+(i-1)*6] = m_EquipIconList[k+(i-1)*6]:AddImage(path_fight.."notProfession.png",0,0,24,24)
			m_Equipforbidden[k+(i-1)*6]:SetTouchEnabled(0)
			m_EquipIconListCount[k+(i-1)*6] = m_EquipIconList[k+(i-1)*6]:AddFont("1", 11, 8, -9, -9, 20, 20, 0xffffff)
			DisableRButtonClick( m_EquipIconList[k+(i-1)*6].id)
		end	
		
		m_vcSummonerAddFriend[i] = m_vcSummonerInfoList.Icon[i]:AddButton(path_fight_tab.."add1.png", path_fight_tab.."add2.png", path_fight_tab.."add3.png", 326, 7, 22, 22)
		m_vcSummonerAddFriend[i]:SetVisible(0)
		m_vcSummonerAddFriend[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			XClickAddFriendButton_Tab(0, i-1)
		end
		
		m_vcSummonerPraise[i] = m_vcSummonerInfoList.Icon[i]:AddButton(path_fight_tab.."zan1.png", path_fight_tab.."zan2.png", path_fight_tab.."zan3.png", 349, 7, 22, 22)
		m_vcSummonerPraiseUn[i] = m_vcSummonerInfoList.Icon[i]:AddImage(path_fight_tab.."zan4.png", 349, 7, 22, 22)
		DisableRButtonClick(m_vcSummonerPraiseUn[i].id)
		
		m_vcSummonerPraiseUn[i]:SetVisible(0)
		m_vcSummonerPraise[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			XClickFlowerButton_Tab(1, i-1)
		end
		
		m_vcSummonerInfoList.Death[i] = m_vcSummonerInfoList.Icon[i]:AddImage(path_fight_tab.."DeadZheZhao.png", -39, -6, 423, 50)
		m_vcSummonerInfoList.Death[i]:SetTouchEnabled(0)
		DisableRButtonClick(m_vcSummonerInfoList.Death[i].id)
		
	end
	
	-- 创建召唤师信息列表 - Red
	for i = 11, 17 do
		m_vcSummonerInfoList.Icon[i] = m_pTabBG:AddImage(path_fight.."Me_equip.png", 475, 59+(50*(i-11)), 36, 36)
		DisableRButtonClick(m_vcSummonerInfoList.Icon[i].id)
		
		local frame = m_vcSummonerInfoList.Icon[i]:AddImage(path_fight_tab.."SummonerFrame.png", -2, -2, 44, 40)
		DisableRButtonClick(frame.id)
		
		m_vcSummonerInfoList.GameState[i] = m_vcSummonerInfoList.Icon[i]:AddImage(path_server.."static1_server.png", -35, 5, 32, 32)
		m_vcSummonerInfoList.GameState[i]:SetVisible(0)
		
		m_vcSummonerInfoList.SummonerSkillBG[i] = m_vcSummonerInfoList.Icon[i]:AddImage(path_fight_tab.."SummonerSkillBGRed.png", 48, -4, 22, 43)
		DisableRButtonClick(m_vcSummonerInfoList.SummonerSkillBG[i].id)
		
		
		m_vcSummonerInfoList.EquipBG[i] = m_vcSummonerInfoList.Icon[i]:AddImage(path_fight_tab.."EquipBGRed.png", 84, 11, 151, 26)
		DisableRButtonClick(m_vcSummonerInfoList.EquipBG[i].id)
	
		m_vcSummonerInfoList.SummonerSkill_1[i] = m_vcSummonerInfoList.SummonerSkillBG[i]:AddImage(path_fight.."Me_equip.png", 1, 1, 20, 20)
		m_vcSummonerInfoList.SummonerSkill_2[i] = m_vcSummonerInfoList.SummonerSkillBG[i]:AddImage(path_fight.."Me_equip.png", 1, 21, 20, 20)
		DisableRButtonClick(m_vcSummonerInfoList.SummonerSkill_1[i].id)
		DisableRButtonClick(m_vcSummonerInfoList.SummonerSkill_2[i].id)
		
		for k = 1, 6 do
			m_EquipIconList[k+(i-1)*6] = m_vcSummonerInfoList.EquipBG[i]:AddImage(path_fight.."Me_equip.png", 1+(k-1)*25, 1, 24, 24)
			m_Equipforbidden[k+(i-1)*6] = m_EquipIconList[k+(i-1)*6]:AddImage(path_fight.."notProfession.png",0,0,24,24)
			m_Equipforbidden[k+(i-1)*6]:SetTouchEnabled(0)
			m_EquipIconListCount[k+(i-1)*6] = m_EquipIconList[k+(i-1)*6]:AddFont("1", 11, 8, -9, -9, 20, 20, 0xffffff)
			DisableRButtonClick( m_EquipIconList[k+(i-1)*6].id)
		end			
		
		m_vcSummonerInfoList.Death[i] = m_vcSummonerInfoList.Icon[i]:AddImage(path_fight_tab.."DeadZheZhao.png", -39, -6, 423, 50)
		DisableRButtonClick(m_vcSummonerInfoList.Death[i].id)
		m_vcSummonerInfoList.Death[i]:SetTouchEnabled(0)		
		
		m_vcSummonerAddFriend[7+i-10] = m_vcSummonerInfoList.Icon[i]:AddButton(path_fight_tab.."add1.png", path_fight_tab.."add2.png", path_fight_tab.."add3.png", 326, 7, 22, 22)
		m_vcSummonerAddFriend[7+i-10]:SetVisible(0)
		m_vcSummonerAddFriend[7+i-10].script[XE_LBUP] = function()
			XClickPlaySound(5)
			XClickAddFriendButton_Tab(1, (7+i-10)-1)
		end
	end
	
	-- 文字
	m_pTabBG:AddFont("召唤师   技能                        装备                        击杀/助攻/补兵", 12, 0, 44, 22, 431, 15, 0x8c9deb)
	m_pTabBG:AddFont("召唤师   技能                        装备                        击杀/助攻/补兵", 12, 0, 467, 22, 431, 15, 0x804d56)
	for i, v in pairs( m_vcSummonerInfoList.Icon ) do
		m_vcSummonerInfoList.LOLData[i] = m_vcSummonerInfoList.Icon[i]:AddFont("18/18/18", 12, 8, -211, -10, 150, 15, 0x8c9deb)
		m_vcSummonerInfoList.SummonerName[i] = m_vcSummonerInfoList.Icon[i]:AddFont("角色名字七个字/英雄五个字", 12, 0, 82, -5, 231, 15, 0x8c9deb)
		m_vcSummonerInfoList.Level[i] = m_vcSummonerInfoList.Icon[i]:AddFont("18", 11, 8, -23, -23, 20, 15, 0xffffff)
		m_vcSummonerInfoList.DeathTime[i] = m_vcSummonerInfoList.Death[i]:AddFont("0", 18, 8, -32, -14, 50, 20, 0xffffff)
	end
	
end

-- 清空数据
function CleanTabSummonerListInfo()
	if #m_SummonerListInfo.IconPath > 0 then
		m_SummonerListInfo = {}								-- 召唤师具体信息
		m_SummonerListInfo.IconPath = {}					-- 头像路径
		m_SummonerListInfo.Level = {}						-- 等级
		m_SummonerListInfo.SummonerSkill_1 = {}				-- 召唤师技能路径1
		m_SummonerListInfo.SummonerSkill_2 = {}				-- 召唤师技能路径2
		m_SummonerListInfo.SummonerName = {}				-- 召唤师名字
		m_SummonerListInfo.HeroName = {}					-- 英雄名字
		m_SummonerListInfo.JiSha = {}						-- 击杀
		m_SummonerListInfo.ZhuGong = {}						-- 助攻
		m_SummonerListInfo.BuBing = {}						-- 补兵
		m_SummonerListInfo.Team = {}						-- 所在队伍用1和2表示
		m_SummonerListInfo.TabIndex = {}					-- 在Tab界面上的位置
		m_SummonerListInfo.IsMe = {}						-- 是不是自己
	end
end

-- 重置剑拳盾等UI状态
function ReSetTabSummonerListType()
	for i, v in pairs( m_vcSummonerInfoList.Icon ) do
		m_vcSummonerInfoList.Icon[i]:SetVisible(0)
	end
	for i, v in pairs( m_vcSummonerPraise ) do
		m_vcSummonerPraise[i]:SetVisible(0)
		m_vcSummonerPraiseUn[i]:SetVisible(0)
	end
end

-- Blue
-- 设置每个玩家的信息 头像 召唤师技能等 蓝队
function SetSummonerFrightListInfo( cSummonerName, cHeroName, cSkill1, cSkill2, cLevel, cHeadPath, cJiSha, cZhuGong, cBuBing, cTeam, cIsMe, cTabIndex,herotip,summortip1,summortip2)
	m_SummonerListInfo[cTabIndex] = cTabIndex
	m_SummonerListInfo.IconPath[cTabIndex] = cHeadPath
	m_SummonerListInfo.Level[cTabIndex] = cLevel
	m_SummonerListInfo.SummonerSkill_1[cTabIndex] = cSkill1
	m_SummonerListInfo.SummonerSkill_2[cTabIndex] = cSkill2
	m_SummonerListInfo.SummonerName[cTabIndex] = cSummonerName
	m_SummonerListInfo.HeroName[cTabIndex] = cHeroName
	
	m_SummonerListInfo.JiSha[cTabIndex] = cJiSha
	m_SummonerListInfo.ZhuGong[cTabIndex] = cZhuGong
	m_SummonerListInfo.BuBing[cTabIndex] = cBuBing
	m_SummonerListInfo.Team[cTabIndex] = cTeam
	m_SummonerListInfo.TabIndex[cTabIndex] = cTabIndex
	m_SummonerListInfo.IsMe[cTabIndex] = cIsMe
	
	if cTabIndex < 8 then
		m_vcSummonerInfoList.Icon[cTabIndex]:SetImageTip(herotip)
		m_vcSummonerInfoList.SummonerSkill_1[cTabIndex]:SetImageTip(summortip1)
		m_vcSummonerInfoList.SummonerSkill_2[cTabIndex]:SetImageTip(summortip2)
	end
end

-- 渲染每个玩家的装备 6个格子的相关信息 蓝队
function SetSummonerListEquipInfo( cEquip, cindex, cEquipindex, cCount,equiptip,isShinning,bProfession, cTeamType)
	m_EquipIconList[cEquipindex+(cindex-1)*6]:SetImageTip(equiptip)
	if LastShinState[cEquipindex+(cindex-1)*6]~=isShinning then
		-- 是否播放帧动画 金闪闪效果
		m_EquipIconList[cEquipindex+(cindex-1)*6]:EnableImageAnimate(isShinning,6,10,1)
		LastShinState[cEquipindex+(cindex-1)*6] = isShinning
	end
	if cEquip == "" then
		m_EquipIconList[cEquipindex+(cindex-1)*6]:SetVisible(0)
	else
		if LastEquipPath[cEquipindex+(cindex-1)*6] ~= cEquip then
			-- 更换装备图片
			m_EquipIconList[cEquipindex+(cindex-1)*6].changeimage( "..\\" .. cEquip)
			LastEquipPath[cEquipindex+(cindex-1)*6] = cEquip
		end
		m_EquipIconList[cEquipindex+(cindex-1)*6]:SetVisible(1)
		
		if cCount > 1 then
			-- 更改装备个数
			m_EquipIconListCount[cEquipindex+(cindex-1)*6]:SetFontText(cCount, 0xffffff)
			m_EquipIconListCount[cEquipindex+(cindex-1)*6]:SetVisible(1)
		else
			m_EquipIconListCount[cEquipindex+(cindex-1)*6]:SetVisible(0)
		end
		
		-- 是否专属
		if bProfession == 0 then
			m_Equipforbidden[cEquipindex+(cindex-1)*6]:SetVisible(1)
		else 
			m_Equipforbidden[cEquipindex+(cindex-1)*6]:SetVisible(0)
		end	
	end
end

-- 渲染
function ReFreshTabUi()
	for i = 1, 7 do
		if m_SummonerListInfo[i] ~= nil then
			m_vcSummonerInfoList.Icon[i]:SetVisible(1)
			if m_SummonerListInfo.IconPath[i] ~= "" then
				if LastIconPath[i] ~= m_SummonerListInfo.IconPath[i] then
					m_vcSummonerInfoList.Icon[i].changeimage( "..\\" .. m_SummonerListInfo.IconPath[i])
					LastIconPath[i] = m_SummonerListInfo.IconPath[i]
				end
			end
			if m_SummonerListInfo.SummonerSkill_1[i] ~= "" then
				if LastSkill_1[i] ~= m_SummonerListInfo.SummonerSkill_1[i] then
					m_vcSummonerInfoList.SummonerSkill_1[i].changeimage("..\\" .. m_SummonerListInfo.SummonerSkill_1[i])
					LastSkill_1[i] = m_SummonerListInfo.SummonerSkill_1[i]
				end
			end
			if m_SummonerListInfo.SummonerSkill_2[i] ~= nil then
				if LastSkill_2[i] ~= m_SummonerListInfo.SummonerSkill_2[i] then
					m_vcSummonerInfoList.SummonerSkill_2[i].changeimage("..\\" .. m_SummonerListInfo.SummonerSkill_2[i])
					LastSkill_2[i] = m_SummonerListInfo.SummonerSkill_2[i]
				end
			end
			m_vcSummonerInfoList.Level[i]:SetFontText( m_SummonerListInfo.Level[i], 0xffffff)
			
			if i == 1 then
				-- 自己比较特别
				m_vcSummonerInfoList.SummonerName[i]:SetFontText( m_SummonerListInfo.SummonerName[i].."/"..m_SummonerListInfo.HeroName[i], 0x89e0e7)
				m_vcSummonerInfoList.LOLData[i]:SetFontText( m_SummonerListInfo.JiSha[i].."/"..m_SummonerListInfo.ZhuGong[i].."/"..m_SummonerListInfo.BuBing[i], 0x89e0e7)
			else
				m_vcSummonerInfoList.SummonerName[i]:SetFontText( m_SummonerListInfo.SummonerName[i].."/"..m_SummonerListInfo.HeroName[i], 0x8c9deb)
				m_vcSummonerInfoList.LOLData[i]:SetFontText( m_SummonerListInfo.JiSha[i].."/"..m_SummonerListInfo.ZhuGong[i].."/"..m_SummonerListInfo.BuBing[i], 0x8c9deb)
			end
		end
	end
end

-- 设置每个玩家的信息 头像 召唤师技能等 红队
function SetSummonerFrightListInfoRed( cSummonerName, cHeroName, cSkill1, cSkill2, cLevel, cHeadPath, cJiSha, cZhuGong, cBuBing, cTeam, cIsMe, cTabIndex,herotip,summortip1,summortip2)
	m_SummonerListInfo[cTabIndex+10] = cTabIndex
	m_SummonerListInfo.IconPath[cTabIndex+10] = cHeadPath
	m_SummonerListInfo.Level[cTabIndex+10] = cLevel
	m_SummonerListInfo.SummonerSkill_1[cTabIndex+10] = cSkill1
	m_SummonerListInfo.SummonerSkill_2[cTabIndex+10] = cSkill2
	m_SummonerListInfo.SummonerName[cTabIndex+10] = cSummonerName
	m_SummonerListInfo.HeroName[cTabIndex+10] = cHeroName
	
	m_SummonerListInfo.JiSha[cTabIndex+10] = cJiSha
	m_SummonerListInfo.ZhuGong[cTabIndex+10] = cZhuGong
	m_SummonerListInfo.BuBing[cTabIndex+10] = cBuBing
	m_SummonerListInfo.Team[cTabIndex+10] = cTeam
	m_SummonerListInfo.TabIndex[cTabIndex+10] = cTabIndex
	m_SummonerListInfo.IsMe[cTabIndex+10] = cIsMe
	
	if cTabIndex < 8 then
		m_vcSummonerInfoList.Icon[cTabIndex+10]:SetImageTip(herotip)
		m_vcSummonerInfoList.SummonerSkill_1[cTabIndex+10]:SetImageTip(summortip1)
		m_vcSummonerInfoList.SummonerSkill_2[cTabIndex+10]:SetImageTip(summortip2)
	end	
end

-- 渲染每个玩家的装备 6个格子的相关信息 红队
function SetSummonerListEquipInfoRed( cEquip, cindex, cEquipindex, cCount,equiptip,isShinning,bProfession,cTeamType)
	m_EquipIconList[cEquipindex+(cindex-1)*6+60]:SetImageTip(equiptip)
	if LastShinState[cEquipindex+(cindex-1)*6+42]~=isShinning then
		m_EquipIconList[cEquipindex+(cindex-1)*6+60]:EnableImageAnimate(isShinning,6,10,1)
		LastShinState[cEquipindex+(cindex-1)*6+42] = isShinning
	end
	if cEquip == "" then
		m_EquipIconList[cEquipindex+(cindex-1)*6+60]:SetVisible(0)
	else
		if LastEquipPath[cEquipindex+(cindex-1)*6+60] ~= cEquip then
			m_EquipIconList[cEquipindex+(cindex-1)*6+60].changeimage( "..\\" .. cEquip)
			LastEquipPath[cEquipindex+(cindex-1)*6+60] = cEquip
		end
		m_EquipIconList[cEquipindex+(cindex-1)*6+60]:SetVisible(1)
		if cCount > 1 then
			m_EquipIconListCount[cEquipindex+(cindex-1)*6+60]:SetFontText(cCount, 0xffffff)
			m_EquipIconListCount[cEquipindex+(cindex-1)*6+60]:SetVisible(1)
		else
			m_EquipIconListCount[cEquipindex+(cindex-1)*6+60]:SetVisible(0)
		end
		
		if bProfession == 0 then
			m_Equipforbidden[cEquipindex+(cindex-1)*6+60]:SetVisible(1)
		else 
			m_Equipforbidden[cEquipindex+(cindex-1)*6+60]:SetVisible(0)
		end	
	end
end

-- 渲染 红队
function ReFreshTabUiRed()
	for i = 11, 17 do
		if m_SummonerListInfo[i] ~= nil then
			m_vcSummonerInfoList.Icon[i]:SetVisible(1)
			
			if m_SummonerListInfo.IconPath[i] ~= "" then
				if LastIconPath[i] ~= m_SummonerListInfo.IconPath[i] then
					m_vcSummonerInfoList.Icon[i].changeimage( "..\\" .. m_SummonerListInfo.IconPath[i])
					LastIconPath[i] = m_SummonerListInfo.IconPath[i]
				end
			end
			if m_SummonerListInfo.SummonerSkill_1[i] ~= "" then
				if LastSkill_1[i] ~= m_SummonerListInfo.SummonerSkill_1[i] then
					m_vcSummonerInfoList.SummonerSkill_1[i].changeimage("..\\" .. m_SummonerListInfo.SummonerSkill_1[i])
					LastSkill_1[i] = m_SummonerListInfo.SummonerSkill_1[i]
				end
			end
			if m_SummonerListInfo.SummonerSkill_2[i] ~= nil then
				if LastSkill_2[i] ~= m_SummonerListInfo.SummonerSkill_2[i] then
					m_vcSummonerInfoList.SummonerSkill_2[i].changeimage("..\\" .. m_SummonerListInfo.SummonerSkill_2[i])
					LastSkill_2[i] = m_SummonerListInfo.SummonerSkill_2[i]
				end
			end
			
			m_vcSummonerInfoList.Level[i]:SetFontText( m_SummonerListInfo.Level[i], 0xffffff)
			m_vcSummonerInfoList.SummonerName[i]:SetFontText( m_SummonerListInfo.SummonerName[i] .. "/" .. m_SummonerListInfo.HeroName[i], 0x804d56)
			
			if m_SummonerListInfo.JiSha[i] == -222 then
				m_vcSummonerInfoList.LOLData[i]:SetFontText( "?/?/?", 0x804d56)
			else
				m_vcSummonerInfoList.LOLData[i]:SetFontText( m_SummonerListInfo.JiSha[i] .. "/" .. m_SummonerListInfo.ZhuGong[i] .. "/" .. m_SummonerListInfo.BuBing[i], 0x804d56)
			end
		end
	end
end

-- 设置赞~\(≧▽≦)/~可见
function SetFlowerVisible( cIndex, cVisible)
	m_vcSummonerPraise[cIndex+1]:SetVisible(cVisible)
end

-- 设置赞~\(≧▽≦)/~不可见
function SetFlowerUnVisible( cIndex, cVisible)
	m_vcSummonerPraiseUn[cIndex+1]:SetVisible(cVisible)
end

-- 设置死亡遮罩及时间Blue
function SetDeathVisible_TabBlue( cTime, cVisible, cIndex)
	m_vcSummonerInfoList.DeathTime[cIndex+1]:SetFontText(cTime, 0xffffff)
	m_vcSummonerInfoList.Death[cIndex+1]:SetVisible(cVisible)
	m_vcSummonerInfoList.DeathTime[cIndex+1]:SetVisible(cVisible)
end

-- 设置死亡遮罩及时间Red
function SetDeathVisible_TabRed( cTime, cVisible, cIndex)
	m_vcSummonerInfoList.Death[cIndex+11]:SetVisible(cVisible)
	m_vcSummonerInfoList.DeathTime[cIndex+11]:SetVisible(cVisible)
	m_vcSummonerInfoList.DeathTime[cIndex+11]:SetFontText(cTime, 0xffffff)
end

-- 设置添加好友按钮是否显示
function SetAddFriendVisible_Tab( cIndex, cVisible)
	if cIndex>0 then
		m_vcSummonerAddFriend[cIndex+1]:SetVisible(cVisible)
	end
end

-- 改变剑拳盾UI
function ChangeTabGameState_Tab( cTeamIndex, cSummonerIndex, cImagePath, cVisible)
	if cTeamIndex==0 then
		m_vcSummonerInfoList.GameState[cSummonerIndex]:SetVisible(cVisible)
		-- m_vcSummonerInfoList.GameState[cSummonerIndex].changeimage()
		if cVisible==1 then
			m_vcSummonerInfoList.GameState[cSummonerIndex].changeimage(cImagePath)
		end
	else
		m_vcSummonerInfoList.GameState[cSummonerIndex+10]:SetVisible(cVisible)
		-- m_vcSummonerInfoList.GameState[cSummonerIndex+10].changeimage()
		if cVisible==1 then
			m_vcSummonerInfoList.GameState[cSummonerIndex+10].changeimage(cImagePath)
		end
	end
end

-- 设置显示
function SetTabIsVisible(flag)
	if n_tab_ui ~= nil then
		if flag == 1 and n_tab_ui:IsVisible() == false then
			n_tab_ui:CreateResource()
			n_tab_ui:SetVisible(1)
		elseif flag == 0 and n_tab_ui:IsVisible() == true then
			n_tab_ui:DeleteResource()
			n_tab_ui:SetVisible(0)
			for i=1, 7 do
				m_vcSummonerInfoList.GameState[i]:SetVisible(0)
				m_vcSummonerInfoList.GameState[i+10]:SetVisible(0)
			end
		end
	end
end

function GetTabIsVisible()  
    if(n_tab_ui ~= nil and n_tab_ui:IsVisible()) then
		return 1
    else
		return 0
    end
end
