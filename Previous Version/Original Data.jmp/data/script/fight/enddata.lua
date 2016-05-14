include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")


----结算界面
local light_back = {}		-- 玩家发光底

local blueGroup = {}
blueGroup.headpic = {}		-- 头像
blueGroup.ilevel = {}		-- 等级
blueGroup.name = {} 		-- 名字
blueGroup.heroname = {} 	-- 名字
blueGroup.skill_1 = {}		-- 召唤师技能1
blueGroup.skill_2 = {}		-- 召唤师技能2
blueGroup.equip_1 = {}		-- 装备1
blueGroup.equip_2 = {}		-- 装备2
blueGroup.equip_3 = {}		-- 装备3
blueGroup.equip_4 = {}		-- 装备4
blueGroup.equip_5 = {}		-- 装备5
blueGroup.equip_6 = {}		-- 装备6
blueGroup.fightmark = {}	-- 战绩
blueGroup.gold = {}			-- 金币
blueGroup.pTip = {}

blueGroup.addfdButton = {}	-- 加好友按钮
blueGroup.thumb = {}		-- 大拇指按钮
blueGroup.light_back = {}	-- 如果是自己添加一个发亮底

blueGroup.killcount = {}
blueGroup.assistcount = {}
blueGroup.bubing = {}

blueGroup.GameState = {}	-- 剑拳盾

local redGroup = {}
redGroup.headpic = {}		-- 头像
redGroup.ilevel = {}		-- 等级
redGroup.name = {} 			-- 名字
redGroup.heroname = {} 		-- 英雄名字
redGroup.skill_1 = {}		-- 召唤师技能1
redGroup.skill_2 = {}		-- 召唤师技能2
redGroup.equip_1 = {}		-- 装备1
redGroup.equip_2 = {}		-- 装备2
redGroup.equip_3 = {}		-- 装备3
redGroup.equip_4 = {}		-- 装备4
redGroup.equip_5 = {}		-- 装备5
redGroup.equip_6 = {}		-- 装备6
redGroup.fightmark = {}		-- 战绩
redGroup.gold = {}			-- 金币
redGroup.pTip = {}

redGroup.addfdButton = {}

redGroup.killcount = {}
redGroup.assistcount = {}
redGroup.bubing = {}

redGroup.GameState = {}	-- 剑拳盾

local WinOrLost = nil

local bluebest = {}
bluebest.headpic = {}--头像
bluebest.name = {} --名字
bluebest.heroname = {} --英雄名字、
bluebest.buyButton = {}--买按钮
bluebest.heroid = {}

local redbest = {}
redbest.headpic = {}--头像
redbest.name = {} --名字
redbest.heroname = {} --英雄名字、
redbest.buyButton = {}--买按钮
redbest.heroid = {}

local playAgainButton = nil
local playAgainButtonfont = nil
local returnGameHall = nil
local returnGameHallfont = nil

local Score_sideB = {}	--蓝方
local Score_sideR = {}	--红方


local fontlevel = nil
local experienceBack = nil
local experienceOld = nil
local experienceNew = nil
local experienceNum = nil
local experienceAddNum = nil

local fightTime = nil--战斗时间
local jiecaoNum = nil--节操值
local AddMoneyNum = nil
local GetMoeny = nil

local BestHeroTip = {}

-- 结算特效
local Effect_win = nil
local Effect_win_step = {"idle","end"} 

function InitEndData_ui(wnd,bisopen)
	Effect_win = wnd:AddEffect("../Data/Magic/Common/UI/changnei/jiesuan/tx_UI_CN_jiesuang_shengli.x",0,0,1280,800)
	Effect_lose = wnd:AddEffect("../Data/Magic/Common/UI/changnei/jiesuan/tx_UI_CN_jiesuang_shibai.x",0,0,1280,800)
	Effect_win:SetVisible(0)
	Effect_lose:SetVisible(0)
	
	n_endData_ui = CreateWindow(wnd.id, (1920-1024)/2, (1080-640)/2, 1024, 640)
	InitMain_EndData(n_endData_ui)
	n_endData_ui:SetVisible(bisopen)
end

function InitMain_EndData(wnd)	

	WinOrLost = wnd:AddImage(path_fight_end.."win.png",748,0,276,98)	
	wnd:AddImage(path_fight_end.."titleLight.png",764,100,248,53)
	wnd:AddImage(path_fight_end.."titleLight.png",764,225,248,53)

	wnd:AddImage(path_fight_end.."MaxKill.png",850,132,70,17)
	wnd:AddImage(path_fight_end.."MaxHelp.png",850,257,70,17)
	
	GetMoeny = wnd:AddImage(path_shop.."money_shop.png",498,15,64,64)
	
	experienceBack = wnd:AddImage(path_fight_end.."EXP_Back.png",91,27,157,15)
	
	experienceNew = wnd:AddImage(path_fight_end.."EXP_New.png",91,27,155,13)--不换图片只换scale
    experienceOld = wnd:AddImage(path_fight_end.."EXP_Old.png",91,27,155,13)--不换图片只换scale

	n_endData_ui:SetAddImageRect(experienceNew.id, 91, 27, 155, 13, 91, 27, 155, 13)
	n_endData_ui:SetAddImageRect(experienceOld.id, 91, 27, 155, 13, 91, 27, 155, 13)
	
	for i = 1,2 do
	    bluebest[i] = CreateWindow(wnd.id,780,160+(i-1)*125,200,43)
		bluebest[i]:SetVisible(0)
		bluebest.headpic[i] = bluebest[i]:AddImage(path_fight.."Me_equip.png",55,4,36,36)
		bluebest.headpic[i]:AddImage(path_fight_end.."headblock.png",0,0,36,36)
	
		bluebest.buyButton[i] = bluebest[i]:AddButton(path_fight_end.."buy_1.png", path_fight_end.."buy_2.png", path_fight_end.."buy_3.png", 10, 3, 39, 39)--加好友按钮
		bluebest.buyButton[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			XClickBuyHeroButton_herodetail(bluebest.heroid[i])
		end
		
		redbest[i] = CreateWindow(wnd.id,780,200+(i-1)*125,200,43)
		redbest[i]:SetVisible(0)
		redbest.headpic[i] = redbest[i]:AddImage(path_fight.."Me_equip.png",55,4,36,36)
		redbest.headpic[i]:AddImage(path_fight_end.."headblock.png",0,0,36,36)
			
		redbest.buyButton[i] = redbest[i]:AddButton(path_fight_end.."buy_1.png", path_fight_end.."buy_2.png", path_fight_end.."buy_3.png", 10, 3, 39, 39)--加好友按钮
		redbest.buyButton[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			XClickBuyHeroButton_herodetail(redbest.heroid[i])
		end
	end	
	
	playAgainButton = wnd:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png", 800, 504, 179, 56)
	playAgainButton:SetEnabled(0)
	returnGameHall = wnd:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png", 800, 566, 179, 56)
	
	returnGameHall.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickReturnGameHallButton_EndData()
	end
	
	wnd:AddImage(path_fight.."score_vs.png",875,83,22,12)
	
	for i=1,4 do
		local index = 0
		Score_sideB[i] = wnd:AddImage(path.."blue/"..index..".png",845-17*(i-1),75,25,26)	--比分牌背景
		Score_sideR[5-i] = wnd:AddImage(path.."red/"..index..".png",907+17*(i-1),75,25,26)	--比分牌背景
	end
	endData_SetScore(234,879)
	
	
	for i = 1,7 do 
		---底
	    blueGroup[i] = CreateWindow(wnd.id,13,75+(i-1)*39,738,43)
		blueGroup.light_back[i] = blueGroup[i]:AddImage(path_fight_end.."self_Back.png",0,0,738,43)
		blueGroup.light_back[i]:SetVisible(0)

		blueGroup.headpic[i] = blueGroup[i]:AddImage(path_fight.."Me_equip.png",35,4,36,36)
		blueGroup.headpic[i]:AddImage(path_fight_end.."headblock.png",0,0,36,36)
	
	    blueGroup[i]:AddImage(path_fight_end.."skillback.png",241,8,51,26)
	    blueGroup.skill_1[i] = blueGroup[i]:AddImage(path_fight.."Me_equip.png",241,9,24,24)
		blueGroup.skill_2[i] = blueGroup[i]:AddImage(path_fight.."Me_equip.png",266,9,24,24)

		blueGroup[i]:AddImage(path_fight_end.."equipback.png",315,8,151,26)
	    blueGroup.equip_1[i] = blueGroup[i]:AddImage(path_fight.."Me_equip.png",315,9,24,24)
		blueGroup.equip_2[i] = blueGroup[i]:AddImage(path_fight.."Me_equip.png",340,9,24,24)
		blueGroup.equip_3[i] = blueGroup[i]:AddImage(path_fight.."Me_equip.png",365,9,24,24)
		blueGroup.equip_4[i] = blueGroup[i]:AddImage(path_fight.."Me_equip.png",390,9,24,24)
		blueGroup.equip_5[i] = blueGroup[i]:AddImage(path_fight.."Me_equip.png",415,9,24,24)
		blueGroup.equip_6[i] = blueGroup[i]:AddImage(path_fight.."Me_equip.png",440,9,24,24)
		
		blueGroup.addfdButton[i] = blueGroup[i]:AddButton(path_fight_tab.."add1.png", path_fight_tab.."add2.png", path_fight_tab.."add3.png", 665, 12, 22, 22)--加好友按钮
		blueGroup.addfdButton[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			XClickAddFriendButton_Tab(0, i-1)
		end
		
		blueGroup.GameState[i] = blueGroup[i]:AddImage(path_server.."static1_server.png", 2, 7, 32, 32)
		blueGroup.GameState[i]:SetVisible(0)
		
		---底
	    redGroup[i] = CreateWindow(wnd.id,13,353+(i-1)*39,738,43)
		redGroup.headpic[i] = redGroup[i]:AddImage(path_fight.."Me_equip.png",35,4,36,36)
		redGroup.headpic[i]:AddImage(path_fight_end.."headblock.png",0,0,36,36)
		
	    redGroup[i]:AddImage(path_fight_end.."skillback.png",241,8,51,26)
	    redGroup.skill_1[i] = redGroup[i]:AddImage(path_fight.."Me_equip.png",241,9,24,24)
		redGroup.skill_2[i] = redGroup[i]:AddImage(path_fight.."Me_equip.png",266,9,24,24)
	
		redGroup[i]:AddImage(path_fight_end.."equipback.png",315,8,151,26)
	    redGroup.equip_1[i] = redGroup[i]:AddImage(path_fight.."Me_equip.png",315,9,24,24)
		redGroup.equip_2[i] = redGroup[i]:AddImage(path_fight.."Me_equip.png",340,9,24,24)
		redGroup.equip_3[i] = redGroup[i]:AddImage(path_fight.."Me_equip.png",365,9,24,24)
		redGroup.equip_4[i] = redGroup[i]:AddImage(path_fight.."Me_equip.png",390,9,24,24)
		redGroup.equip_5[i] = redGroup[i]:AddImage(path_fight.."Me_equip.png",415,9,24,24)
		redGroup.equip_6[i] = redGroup[i]:AddImage(path_fight.."Me_equip.png",440,9,24,24)
		redGroup.equip_6[i]:SetVisible(0)
				
		redGroup.addfdButton[i] = redGroup[i]:AddButton(path_fight_tab.."add1.png", path_fight_tab.."add2.png", path_fight_tab.."add3.png", 665, 12, 22, 22)--加好友按钮
		redGroup.addfdButton[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			XClickAddFriendButton_Tab(1, (7+i)-1)
		end
		
		redGroup.GameState[i] = redGroup[i]:AddImage(path_server.."static1_server.png", 2, 7, 32, 32)
		redGroup.GameState[i]:SetVisible(0)
	end
	
	
	--固定文字等
	wnd:AddFont("召唤师", 12, 0, 43, 57, 100, 13, 0xffffff)
	wnd:AddFont("等级", 12, 0, 98, 57, 100, 13, 0xffffff)
	wnd:AddFont("名称", 12, 8, -135, -58, 100, 13, 0xffffff)
	wnd:AddFont("技能", 12, 0, 262, 57, 100, 13, 0xffffff)
	wnd:AddFont("装备", 12, 0, 380, 57, 100, 13, 0xffffff)
	wnd:AddFont("击杀/助攻/补兵", 12, 0, 500, 57, 100, 13, 0xffffff)
	wnd:AddFont("金币", 12, 0, 617, 57, 100, 13, 0xffffff)
	fontlevel = wnd:AddFont("等级  40", 12, 0, 26, 24, 100, 14, 0x8295cf)
	experienceAddNum = wnd:AddFont("+188",12, 0, 256, 24, 100, 14,0x8878eb)
    experienceNum = wnd:AddFont("111/290",11, 8, -110, -13, 100, 11,0xffffff)
	
	wnd:AddFont("节操", 12, 0, 373, 24, 100, 14, 0x8295cf)
	jiecaoNum = wnd:AddFont("+188", 12, 0,415, 24, 100, 14, 0x64ccd5)
	AddMoneyNum = wnd:AddFont("+188", 12, 0,536, 24, 100, 14, 0xebf570)
	wnd:AddFont("战斗时间", 12, 0, 600, 24, 100, 14, 0x8295cf)
	fightTime = wnd:AddFont("12:45:41", 12, 0,672, 24, 100, 14, 0xffffff)
	for i = 1,2 do
		bluebest.name[i] =bluebest[i]:AddFont("玩家名字七个字", 12, 8, -100, -7, 100, 13, 0x95f9fd) --名字
        bluebest.heroname[i] =bluebest[i]:AddFont("英雄名字七个字", 12, 8, -100, -23, 100, 13, 0x95f9fd) --名字	
		redbest.name[i] =redbest[i]:AddFont("玩家名字七个字", 12, 8, -100, -7, 100, 13, 0xd87b7f) --名字
        redbest.heroname[i] =redbest[i]:AddFont("英雄名字七个字", 12, 8, -100, -23, 100, 13, 0xd87b7f) --名字	
	end	
	
	playAgainButtonfont = playAgainButton:AddFontEx("再来一局", 15, 0, 50, 15, 150, 16, 0xFFFFFF)
	returnGameHallfont = returnGameHall:AddFontEx("返回大厅(60s)", 15, 0, 50, 15, 150, 16, 0xFFFFFF)
	for i = 1,7 do 
		--等级、自己名字、英雄名字
		blueGroup.ilevel[i] = blueGroup[i]:AddFont("18", 11, 8, -50, -15, 100, 13, 0x95f9fd)
        blueGroup.name[i] =blueGroup[i]:AddFont("玩家名字七个字", 12, 8, -125, -7, 100, 13, 0x95f9fd) --名字
        blueGroup.heroname[i] =blueGroup[i]:AddFont("英雄名字七个字", 12, 8, -125, -23, 100, 13, 0x95f9fd) --名字	
		--战绩、金钱
	    blueGroup.fightmark[i] = blueGroup[i]:AddFont("18/18/18", 11, 8, -480, -15, 100, 13, 0x95f9fd) --战绩
		blueGroup.gold[i] = blueGroup[i]:AddFont("9999", 11, 8, -570, -15, 100, 13, 0x95f9fd) --金钱
		
		--等级、自己名字、英雄名字
		redGroup.ilevel[i] = redGroup[i]:AddFont("18", 11, 8, -50, -15, 100, 13, 0xd87b7f)
        redGroup.name[i] =redGroup[i]:AddFont("玩家名字七个字", 12, 8, -125, -7, 100, 13, 0xd87b7f) --名字
        redGroup.heroname[i] =redGroup[i]:AddFont("英雄名字七个字", 12, 8, -125, -23, 100, 13, 0xd87b7f) --名字	
		--战绩、金钱
	    redGroup.fightmark[i] = redGroup[i]:AddFont("18/18/18", 11, 8, -480, -15, 100, 13, 0xd87b7f) --战绩
		redGroup.gold[i] = redGroup[i]:AddFont("9999", 11, 8, -570, -15, 100, 13, 0xd87b7f) --金钱
	end
	
end

-- 比分
function endData_SetScore(BS,RS)

	for i=1,4 do
		Score_sideB[i]:SetVisible(0)
		Score_sideR[i]:SetVisible(0)
	end
	
	-- 蓝方
	local M = BS
	local B = 0
	if M < 10 then
		Score_sideB[1]:SetVisible(1)
	elseif M < 100 then
		Score_sideB[1]:SetVisible(1)
		Score_sideB[2]:SetVisible(1)
	elseif M < 1000 then
		Score_sideB[1]:SetVisible(1)
		Score_sideB[2]:SetVisible(1)
		Score_sideB[3]:SetVisible(1)
	elseif M < 10000 then
		Score_sideB[1]:SetVisible(1)
		Score_sideB[2]:SetVisible(1)
		Score_sideB[3]:SetVisible(1)
		Score_sideB[4]:SetVisible(1)
	end
	for i=1,4 do
		B = (M%10)
		Score_sideB[i].changeimage(path.."blue/"..B..".png")
		M = math.floor(M/10)
	end
	
	
	-- 红方
	local N = RS
	local R = 0
	if N < 10 then
		Score_sideR[4].changeimage(path.."red/"..N..".png")
		Score_sideR[4]:SetVisible(1)
	elseif RS < 100 then
		for i=1,2 do
			R = N%10
			Score_sideR[i+2].changeimage(path.."red/"..R..".png")
			Score_sideR[i+2]:SetVisible(1)
			N = math.floor(N/10)
		end
	elseif RS < 1000 then
		for i=1,3 do
			R = N%10
			Score_sideR[i+1].changeimage(path.."red/"..R..".png")
			Score_sideR[i+1]:SetVisible(1)
			N = math.floor(N/10)
		end
	elseif RS < 10000 then
		for i=1,4 do
			R = N%10
			Score_sideR[i].changeimage(path.."red/"..R..".png")
			Score_sideR[i]:SetVisible(1)
			N = math.floor(N/10)
		end
	end

end

function SetMatchResult( cResult)
	if cResult == 0 then
		WinOrLost.changeimage( path_fight_end.."win.png")
	else
		WinOrLost.changeimage( path_fight_end.."lost.png")
	end
end

function ClearAllPlayerListInfo()
	if #blueGroup > 0 then
		for i = 1, #blueGroup do
			blueGroup[i]:SetVisible(0)
		end
	end
	if #redGroup > 0 then
		for i = 1, #redGroup do
			redGroup[i]:SetVisible(0)
		end
	end
end

function SetPlayerEndInfoList( cSummonerName, cHeroName, cHeroHeadIconPath, cLevel, cSkill_1Path, cSkill_2Path, cFightTamark, cGold, cIndex, cTeam,herotip,summorskilltip1,summorskilltip2, ckillcount, cassistcount, cbubingcount)
	if cTeam == 0 then
		-- 蓝队
		blueGroup[cIndex+1]:SetVisible(1)
		if cHeroHeadIconPath~="" then
			blueGroup.headpic[cIndex+1].changeimage("..\\"..cHeroHeadIconPath)
		end
		if cSkill_1Path~="" and cSkill_2Path~="" then
			blueGroup.skill_1[cIndex+1].changeimage(".."..cSkill_1Path)
			blueGroup.skill_2[cIndex+1].changeimage(".."..cSkill_2Path)
		end
		if cIndex==0 then
			blueGroup.name[cIndex+1]:SetFontText(cSummonerName, 0x95f9fd)
			blueGroup.heroname[cIndex+1]:SetFontText(cHeroName, 0x95f9fd)
			blueGroup.ilevel[cIndex+1]:SetFontText(cLevel, 0x95f9fd)
			blueGroup.fightmark[cIndex+1]:SetFontText(cFightTamark, 0x95f9fd)
			blueGroup.gold[cIndex+1]:SetFontText(cGold, 0x95f9fd)
		else
			blueGroup.name[cIndex+1]:SetFontText(cSummonerName, 0x8295cf)
			blueGroup.heroname[cIndex+1]:SetFontText(cHeroName, 0x8295cf)
			blueGroup.ilevel[cIndex+1]:SetFontText(cLevel, 0x8295cf)
			blueGroup.fightmark[cIndex+1]:SetFontText(cFightTamark, 0x8295cf)
			blueGroup.gold[cIndex+1]:SetFontText(cGold, 0x8295cf)
		end
		
		if cIndex < 7 then
			blueGroup.headpic[cIndex+1]:SetImageTip(herotip)
			blueGroup.pTip[cIndex+1] = herotip
			-- log("\npTip = " .. blueGroup.pTip[cIndex+1])
			blueGroup.skill_1[cIndex+1]:SetImageTip(summorskilltip1)
			blueGroup.skill_2[cIndex+1]:SetImageTip(summorskilltip2)
		end
		
		blueGroup.killcount[cIndex+1] = ckillcount
		blueGroup.assistcount[cIndex+1] = cassistcount
		blueGroup.bubing[cIndex+1] = cbubingcount
	else
		-- 红队
		redGroup[cIndex+1]:SetVisible(1)
		redGroup.name[cIndex+1]:SetFontText(cSummonerName, 0xd87b7f)
		redGroup.heroname[cIndex+1]:SetFontText(cHeroName, 0xd87b7f)
		if cHeroHeadIconPath~="" then
			redGroup.headpic[cIndex+1].changeimage("..\\"..cHeroHeadIconPath)
		end
		redGroup.ilevel[cIndex+1]:SetFontText(cLevel, 0xd87b7f)
		if cSkill_1Path~="" and cSkill_2Path~="" then
			redGroup.skill_1[cIndex+1].changeimage(".."..cSkill_1Path)
			redGroup.skill_2[cIndex+1].changeimage(".."..cSkill_2Path)
		end
		redGroup.fightmark[cIndex+1]:SetFontText(cFightTamark, 0xd87b7f)
		redGroup.gold[cIndex+1]:SetFontText(cGold, 0xd87b7f)
		
		if cIndex < 7 then
			redGroup.headpic[cIndex+1]:SetImageTip(herotip)
			redGroup.pTip[cIndex+1] = herotip
			redGroup.skill_1[cIndex+1]:SetImageTip(summorskilltip1)
			redGroup.skill_2[cIndex+1]:SetImageTip(summorskilltip2)
		end
		
		redGroup.killcount[cIndex+1] = ckillcount
		redGroup.assistcount[cIndex+1] = cassistcount
		redGroup.bubing[cIndex+1] = cbubingcount
	end
end

function SetMySelfEndInfo( cjiecaoNum, cAddMoneyNum, cfightTime, cAddExp, cCurExp, cMaxExp, cSummonerLv, cTip)
	jiecaoNum:SetFontText(cjiecaoNum, 0x64ccd5)
	AddMoneyNum:SetFontText(cAddMoneyNum, 0xebf570)
	fightTime:SetFontText(cfightTime, 0xffffff)
	fontlevel:SetFontText("等级  "..cSummonerLv, 0x8295cf)
	experienceNum:SetFontText(cCurExp.."/"..cMaxExp, 0xFFFFFF)
	experienceAddNum:SetFontText(cAddExp, 0x8878eb)
	
	XSetTextTipEx(GetMoeny.id, cTip)
	
	local a = tonumber(cAddExp)
	local b = tonumber(cCurExp)
	local c = tonumber(cMaxExp)
	a = a+b
	
	n_endData_ui:SetAddImageRect(experienceNew.id, 91,27, 155*(a/c), 13, 91,27, 155*(a/c), 13)
	n_endData_ui:SetAddImageRect(experienceOld.id, 91,27, 155*(b/c), 13, 91,27, 155*(b/c), 13)
end

function SetPlayerInfoListEquipInfo_EndData( cEquipPath, cIndex, cPos, cTeam,tip,isShinning)
	if cTeam == 0 then
		-- 蓝队
		if cIndex == 0 then
			if cEquipPath == "" then
				blueGroup.equip_1[cPos]:SetVisible(0)
			else
				blueGroup.equip_1[cPos].changeimage("..\\"..cEquipPath)
				blueGroup.equip_1[cPos]:EnableImageAnimate(isShinning,6,10,-2)
				blueGroup.equip_1[cPos]:SetImageTip(tip)
				blueGroup.equip_1[cPos]:SetVisible(1)
			end
		elseif cIndex == 1 then
			if cEquipPath == "" then
				blueGroup.equip_2[cPos]:SetVisible(0)
			else
				blueGroup.equip_2[cPos].changeimage("..\\"..cEquipPath)
				blueGroup.equip_2[cPos]:EnableImageAnimate(isShinning,6,10,-2)
				blueGroup.equip_2[cPos]:SetImageTip(tip)
				blueGroup.equip_2[cPos]:SetVisible(1)
			end
		elseif cIndex == 2 then
			if cEquipPath == "" then
				blueGroup.equip_3[cPos]:SetVisible(0)
			else
				blueGroup.equip_3[cPos].changeimage("..\\"..cEquipPath)
				blueGroup.equip_3[cPos]:EnableImageAnimate(isShinning,6,10,-2)
				blueGroup.equip_3[cPos]:SetImageTip(tip)
				blueGroup.equip_3[cPos]:SetVisible(1)
			end
		elseif cIndex == 3 then
			if cEquipPath == "" then
				blueGroup.equip_4[cPos]:SetVisible(0)
			else
				blueGroup.equip_4[cPos].changeimage("..\\"..cEquipPath)
				blueGroup.equip_4[cPos]:EnableImageAnimate(isShinning,6,10,-2)
				blueGroup.equip_4[cPos]:SetImageTip(tip)
				blueGroup.equip_4[cPos]:SetVisible(1)
			end
		elseif cIndex == 4 then
			if cEquipPath == "" then
				blueGroup.equip_5[cPos]:SetVisible(0)
			else
				blueGroup.equip_5[cPos].changeimage("..\\"..cEquipPath)
				blueGroup.equip_5[cPos]:EnableImageAnimate(isShinning,6,10,-2)
				blueGroup.equip_5[cPos]:SetImageTip(tip)
				blueGroup.equip_5[cPos]:SetVisible(1)
			end
		elseif cIndex == 5 then
			if cEquipPath == "" then
				blueGroup.equip_6[cPos]:SetVisible(0)
			else
				blueGroup.equip_6[cPos].changeimage("..\\"..cEquipPath)
				blueGroup.equip_6[cPos]:EnableImageAnimate(isShinning,6,10,-2)
				blueGroup.equip_6[cPos]:SetImageTip(tip)
				blueGroup.equip_6[cPos]:SetVisible(1)
			end
		end
	else
		-- 红队
		if cIndex == 0 then
			if cEquipPath == "" then
				redGroup.equip_1[cPos]:SetVisible(0)
			else
				redGroup.equip_1[cPos].changeimage("..\\"..cEquipPath)
				redGroup.equip_1[cPos]:EnableImageAnimate(isShinning,6,10,-2)
				redGroup.equip_1[cPos]:SetImageTip(tip)
				redGroup.equip_1[cPos]:SetVisible(1)
			end
		elseif cIndex == 1 then
			if cEquipPath == "" then
				redGroup.equip_2[cPos]:SetVisible(0)
			else
				redGroup.equip_2[cPos].changeimage("..\\"..cEquipPath)
				redGroup.equip_2[cPos]:EnableImageAnimate(isShinning,6,10,-2)
				redGroup.equip_2[cPos]:SetImageTip(tip)
				redGroup.equip_2[cPos]:SetVisible(1)
			end
		elseif cIndex == 2 then
			if cEquipPath == "" then
				redGroup.equip_3[cPos]:SetVisible(0)
			else
				redGroup.equip_3[cPos].changeimage("..\\"..cEquipPath)
				redGroup.equip_3[cPos]:EnableImageAnimate(isShinning,6,10,-2)
				redGroup.equip_3[cPos]:SetImageTip(tip)
				redGroup.equip_3[cPos]:SetVisible(1)
			end
		elseif cIndex == 3 then
			if cEquipPath == "" then
				redGroup.equip_4[cPos]:SetVisible(0)
			else
				redGroup.equip_4[cPos].changeimage("..\\"..cEquipPath)
				redGroup.equip_4[cPos]:EnableImageAnimate(isShinning,6,10,-2)
				redGroup.equip_4[cPos]:SetImageTip(tip)
				redGroup.equip_4[cPos]:SetVisible(1)
			end
		elseif cIndex == 4 then
			if cEquipPath == "" then
				redGroup.equip_5[cPos]:SetVisible(0)
			else
				redGroup.equip_5[cPos].changeimage("..\\"..cEquipPath)
				redGroup.equip_5[cPos]:EnableImageAnimate(isShinning,6,10,-2)
				redGroup.equip_5[cPos]:SetImageTip(tip)
				redGroup.equip_5[cPos]:SetVisible(1)
			end
		elseif cIndex == 5 then
			if cEquipPath == "" then
				redGroup.equip_6[cPos]:SetVisible(0)
			else
				redGroup.equip_6[cPos].changeimage("..\\"..cEquipPath)
				redGroup.equip_6[cPos]:EnableImageAnimate(isShinning,6,10,-2)
				redGroup.equip_6[cPos]:SetImageTip(tip)
				redGroup.equip_6[cPos]:SetVisible(1)
			end
		end
	end
end

function SetReturnGameHallTime_EndData( ctime)
	returnGameHallfont:SetFontText("返回大厅("..ctime.."s)", 0xFFFFFF)
end

function RefeshBestKillInfo_enddata(cpath, csummonername, cheroname, cheroid, cindexpos, cteam, c_index, cIsHavedHero)
	if cteam==0 then
		-- 蓝队
		bluebest[c_index]:SetVisible(1)
		bluebest.name[c_index]:SetFontText( csummonername, 0x8295cf)
		bluebest.heroname[c_index]:SetFontText( cheroname, 0x8295cf)	
		bluebest.heroid[c_index] = cheroid
		if cpath~="" then
			bluebest.headpic[c_index].changeimage(".." .. cpath)
			bluebest.headpic[c_index]:SetImageTip( blueGroup.pTip[cindexpos])
			-- log("\nCurTip = " .. blueGroup.pTip[cindexpos])
		end
		bluebest.buyButton[c_index]:SetEnabled(TakeReverse(cIsHavedHero))
	elseif cteam==1 then
		-- 红队
		redbest[c_index]:SetVisible(1)
		redbest.name[c_index]:SetFontText( csummonername, 0xb66b6f)
		redbest.heroname[c_index]:SetFontText( cheroname, 0xb66b6f)
		redbest.heroid[c_index] = cheroid
		if cpath~="" then
			redbest.headpic[c_index].changeimage(".." .. cpath)
			redbest.headpic[c_index]:SetImageTip( redGroup.pTip[cindexpos])
		end
		redbest.buyButton[c_index]:SetEnabled(TakeReverse(cIsHavedHero))
	end
end

function SetAddFriendVisible_EndData(cTeam, cIndex, cVisible)
	if cTeam==0 then
		if cIndex>0 then
			blueGroup.addfdButton[cIndex+1]:SetVisible(cVisible)
		else
			blueGroup.addfdButton[cIndex+1]:SetVisible(0)
		end
	elseif cteam==1 then
		redGroup.addfdButton[cIndex+1]:SetVisible(cVisible)
	end
end

function ChangeTabGameState_EndData( cTeamIndex, cSummonerIndex, cImagePath, cVisible)
	if cTeamIndex==0 then
		blueGroup.GameState[cSummonerIndex]:SetVisible(cVisible)
		if cVisible==1 then
			blueGroup.GameState[cSummonerIndex].changeimage(cImagePath)
		end
	else
		redGroup.GameState[cSummonerIndex]:SetVisible(cVisible)
		if cVisible==1 then
			redGroup.GameState[cSummonerIndex].changeimage(cImagePath)
		end
	end
end

-- 设置显示与否
function SetEndDataIsVisible(flag,result)
	if n_endData_ui ~= nil then
		if flag == 1 and n_endData_ui:IsVisible() == false then
			n_endData_ui:CreateResource()
		--	n_endData_ui:SetVisible(1)
			SetData_GameResult(result)	
		elseif flag == 0 and n_endData_ui:IsVisible() == true then
			n_endData_ui:DeleteResource()
			n_endData_ui:SetVisible(0)
			Effect_win:SetVisible(0)
			Effect_lose:SetVisible(0)
			for i=1, 2 do
				bluebest[i]:SetVisible(0)
				redbest[i]:SetVisible(0)
			end
			
			for i=1, 7 do
				blueGroup.GameState[i]:SetVisible(0)
				redGroup.GameState[i]:SetVisible(0)
			end
		end
	end
end

function GetEndDataIsVisible()  
    if n_endData_ui ~= nil and n_endData_ui:IsVisible()==true then
		return 1
    else
		return 0
    end
end
function SetData_GameResult(result)
	if result ==1 then
		Effect_win:SetVisible(1)
		XPlayEffectByName(Effect_win.id,Effect_win_step[1],0)
		--n_endData_ui:SetVisible(1)	
		--n_endData_ui:SetPosition(20000, 20000)
		n_endData_ui:SetTimer(0,2000,0,1).Timer = function(timer)
			--n_endData_ui:SetPosition((windowswidth-1024)/2, (windowsheight-640)/2)
			n_endData_ui:SetVisible(1)
		end
	else
		Effect_lose:SetVisible(1)
		XPlayEffectByName(Effect_lose.id,Effect_win_step[1],0)
		--n_endData_ui:SetVisible(1)	
		--n_endData_ui:SetPosition(20000, 20000)
		n_endData_ui:SetTimer(0,2000,0,1).Timer = function(timer)
			--n_endData_ui:SetPosition((windowswidth-1024)/2, (windowsheight-640)/2)
			n_endData_ui:SetVisible(1)			
		end
	end

end
function SetEndData_Position(width,height)
	n_endData_ui:SetPosition((width-1024)/2, (height-640)/2)				--结算界面
	XSetEffectPos(Effect_win.id,(width-1920)/2,(height-1080)/2)
	XSetEffectPos(Effect_lose.id,(width-1920)/2,(height-1080)/2)
end
