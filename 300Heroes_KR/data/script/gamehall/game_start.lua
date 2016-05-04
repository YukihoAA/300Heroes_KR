include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

local chatInput = nil
local chatInputText = nil
local BTN_random = nil
local BTN_go = nil
local BTN_herochose = nil
local BTN_SELL = nil
local BTN_replace = nil
local BTN_change = nil
local BTN_LIST = nil
local LIST_BK = nil

--------英雄框底
local hero_buttom = {}
local hero_controlName = {}
local hero_assistA = {}
local hero_assistB = {}
local hero_head = {} 		--英雄头像
local hero_side = {}
local hero_sideList = {path_start.."icon2_start.png",path_start.."icon1_start.png",path_start.."icon1_start.png",path_start.."icon1_start.png",path_start.."icon1_start.png",path_start.."icon1_start.png",path_start.."icon1_start.png"}
local hero_hide = {}


local BTN_Talent = {}		--天赋专精下列按钮
local BTN_TalentFont = {"天赋页1","天赋页2","天赋页3","天赋页4","天赋页5","天赋页6","天赋页7","天赋页8","天赋页9","天赋页10",}	--天赋页
local SummonerTalentList = {}

------------------英雄具体信息
local HeroInfo = {}
HeroInfo.strPictureName = {}	----英雄头像路径
HeroInfo.strName = {}			----英雄名称
HeroInfo.heroId = {}			
HeroInfo.heroTip = {}
------------------信息结束

---------辅助技能窗口
local BTN_SKILL1 = nil
local BTN_SKILL2 = nil
--local assist_skillA,assist_skillB = nil

local Font_showAll = nil

local CueSelHeroId_gamestart = -1

local bgImg = nil
local bgImg_SkinLv = nil
local iiiimgFont = nil
local img_BubbleBG = nil
local btn_BubbleSure = nil
local img_TFZJ = nil
local img_TYJN = nil

local SelTalentIndex = 0

-----您的队伍UI
local YourTeam_ui = nil
local Talent_ui = nil
local Common_ui = nil

function InitGameStart_ui(wnd, bisopen)
	g_game_start_ui = CreateWindow(wnd.id, 0, -OffsetY1, 1280, 800)
	InitMainGameStart_ui(g_game_start_ui)
	g_game_start_ui:SetVisible(bisopen)
end
function InitMainGameStart_ui(wnd)
	--底图背景
	bgImg = wnd:AddImage(path_hero.."ffffff_hero.png",0,OffsetY1,1280,800)
	bgImg_SkinLv = bgImg:AddImage(path_hero.."skinlv_1.png", 10, 10, 111, 69)
	
	InitGameStartChat(g_game_start_ui)
	
	YourTeam_ui = wnd:AddImage(path_start.."Teamfont_start.png",633,90,493,127)
	YourTeam_ui:AddImage(path_start.."playerName_start.png",-53,85,615,35)
	for i=1,7 do
		--YourTeam_ui:AddImage(path_start.."player_"..i..".png",73*i-49,80,64,32)
		
		hero_buttom[i] = YourTeam_ui:AddImage(path_start.."icon0_start.png",85*i-133,110,86,170)
		--hero_buttom[i]:SetTouchEnabled(0)
		hero_controlName[i] = hero_buttom[i]:AddFont("英雄名字",12,8,7,8,100,0,0x81f5ff)
		hero_controlName[i]:SetVisible(0)
		-------两个辅助技能
		hero_assistA[i] = hero_buttom[i]:AddImage(path_equip.."bag_equip.png",11,165,29,29)
		hero_assistB[i] = hero_buttom[i]:AddImage(path_equip.."bag_equip.png",46,165,29,29)
		
		hero_buttom[i]:AddImage(path_start.."summonerSide_start.png",11-2,165-2,33,33)
		hero_buttom[i]:AddImage(path_start.."summonerSide_start.png",46-2,165-2,33,33)
		
		hero_head[i] = YourTeam_ui:AddImage(path_start.."herohead_start.png",85*i-120,123,64,148)---原来是256，暂时修改成148
		hero_hide[i] = YourTeam_ui:AddImage(path_start.."icon3_start.png",85*i-133,110,86,170)
		hero_hide[i]:SetTouchEnabled(0)
		hero_side[i] = YourTeam_ui:AddImage(hero_sideList[i],85*i-133,110,86,170)
		hero_side[i]:SetTouchEnabled(0)
		
	end

	hero_buttom[1].script[XE_LBUP] = function()
		XClickPlaySound(5)
		BTN_herochose:TriggerBehaviour(XE_LBUP)
	end
	
	---------英雄选择界面
	BTN_herochose = wnd:AddButton(path_start.."herochose1_start.png",path_start.."herochose2_start.png",path_start.."herochose3_start.png",1210,315,74,141)
	iiiimgFont = BTN_herochose:AddImage(path_start.."herochosefont_start.png",25,45,64,64)
	iiiimgFont:SetTransparent(0)
	iiiimgFont:SetTouchEnabled(0)
	BTN_herochose.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if GetTutorailModeIsOpen()==1 then
			XClickOkButtonTutorial()
		end
		SetGameStartIsVisible(0)
		SetGameChoseHeroIsVisible(1)
		SetSkinWindowPos(0)
	end
			
	-- 天赋专精
	Talent_ui = wnd:AddImage(path_start.."talentsummonerbk_start.png",585,410,212,109)
	
	
	BTN_change = Talent_ui:AddButton(path_start.."changeBtn1_start.png",path_start.."changeBtn2_start.png",path_start.."changeBtn3_start.png",137,55,64,32)
	BTN_change:AddFont("荐沥", 15, 0, 7, 3, 50, 15, 0xbeb5ee)
	BTN_change.script[XE_LBUP] = function()
		XClickPlaySound(5)
		-- if SelTalentIndex>0 and SelTalentIndex<=10 then
			XSelSummonerTalent_gamestart(SelTalentIndex)
		-- end
		SetGameSkinFrameIsVisible(0)
		SetTalent_InsideIsVisible(1)
	end
	
	-- 显示全部下拉背景框
	BTN_LIST = Talent_ui:AddTwoButton(path_start.."talentlist1_start.png", path_start.."talentlist2_start.png", path_start.."talentlist1_start.png",7,50,132,40)
	Font_showAll = BTN_LIST:AddFont("天赋页1",12,0,20,10,100,12,0xbeb5ee)
	
	LIST_BK = Talent_ui:AddImage(path_start.."talentlistBK_start.png",10,87,124,288)
	LIST_BK:SetVisible(0)
	
	for dis = 1,10 do
		BTN_Talent[dis] = Talent_ui:AddImage(path_start.."talentlisthover_start.png",10,57+dis*29,128,32)
		SummonerTalentList[dis] = LIST_BK:AddFont(BTN_TalentFont[dis],12,0,18,dis*29-23,128,32,0xbeb5ee)
		BTN_Talent[dis]:SetTransparent(0)
		BTN_Talent[dis]:SetTouchEnabled(0)
		-- 鼠标滑过
		BTN_Talent[dis].script[XE_ONHOVER] = function()
			if LIST_BK:IsVisible() == true then
				BTN_Talent[dis]:SetTransparent(1)
			end
		end
		BTN_Talent[dis].script[XE_ONUNHOVER] = function()
			if LIST_BK:IsVisible() == true then
				BTN_Talent[dis]:SetTransparent(0)
			end
		end
		
		BTN_Talent[dis].script[XE_LBUP] = function()
			SelTalentIndex = dis-1
			XSelSummonerTalent_gamestart(SelTalentIndex)
			Font_showAll:SetFontText(BTN_TalentFont[dis],0xbeb5ee)
			BTN_LIST:SetButtonFrame(0)
			LIST_BK:SetVisible(0)
			for index,value in pairs(BTN_Talent) do
				BTN_Talent[index]:SetTransparent(0)
				BTN_Talent[index]:SetTouchEnabled(0)
			end
		end
	end
	
	BTN_LIST.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if LIST_BK:IsVisible() then
			LIST_BK:SetVisible(0)
			for index,value in pairs(BTN_Talent) do
				BTN_Talent[index]:SetTransparent(0)
				BTN_Talent[index]:SetTouchEnabled(0)
			end
		else
			LIST_BK:SetVisible(1)
			for index,value in pairs(BTN_Talent) do
				BTN_Talent[index]:SetTransparent(0)
				BTN_Talent[index]:SetTouchEnabled(1)
			end
		end
	end

	
	-----------------通用技能
	Common_ui = wnd:AddImage(path_start.."talentsummonerbk_start.png",795,410,212,109)
	
	
	------辅助技能图片
	BTN_SKILL1 = Common_ui:AddImage(path_equip.."bag_equip.png",18,43,50,50)
	BTN_SKILL2 = Common_ui:AddImage(path_equip.."bag_equip.png",78,43,50,50)
	------两个辅助技能
	local SIDE1 = Common_ui:AddImage(path_start.."summonerSide_start.png",15,40,56,56)
	local SIDE2 = Common_ui:AddImage(path_start.."summonerSide_start.png",75,40,56,56)
	SIDE1:SetTouchEnabled(0)
	SIDE2:SetTouchEnabled(0)
	
	BTN_SKILL1.script[XE_LBUP] = function()
		XClickPlaySound(5)		
		XChangeAssistSkill(1)
		changeSummonerSkillIndex(1)
	end
	BTN_SKILL2.script[XE_LBUP] = function()
		XClickPlaySound(5)	
		XChangeAssistSkill(2)
		changeSummonerSkillIndex(2)
	end
	
	BTN_replace = Common_ui:AddButton(path_start.."changeBtn1_start.png",path_start.."changeBtn2_start.png",path_start.."changeBtn3_start.png",140,55,64,32)
	BTN_replace:AddFont("函版", 15, 0, 7, 3, 50, 15, 0xbeb5ee)
	BTN_replace.script[XE_LBUP] = function()
		XClickPlaySound(5)	
		XChangeAssistSkill(3)
		changeSummonerSkillIndex(3)
	end
	
	----随机英雄出击
	BTN_random = wnd:AddButton(path_start.."random1_start.png", path_start.."random2_start.png", path_start.."random3_start.png",1000,410, 179, 56)
	BTN_random.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGameHeroRandom(1)
		------选英雄界面的选中边框去除
		Chose_HeroClick()
		SetCurTitleState_teadytime(0)
	end
	
	BTN_go = wnd:AddButton(path_start.."readyEnter1_start.png", path_start.."readyEnter2_start.png", path_start.."readyEnter3_start.png",1000,460, 179, 56)
	BTN_go:AddFont("免拜", 18, 8, 0, 0, 179, 56, 0xffffff)
	BTN_go.script[XE_LBUP] = function()
		XClickPlaySound(5)
		-- XSetCurSelSkinIndex(GetClientSelSkinIndex_skinframe())
		XGameHeroStart(1)
	end
	
	--wnd:AddImage(path_start.."10_SKIN.png",130,518,128,256)
	--wnd:AddImage(path_hero.."SKIN_SIDE.png",125,513,128,256)
	
	-- BTN_SELL = wnd:AddButton(path_start.."SKINBYE.png",path_start.."SKINBYE_1.png",path_start.."SKINBYE_2.png",129,692,128,32)
	-- BTN_SELL.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
	-- end
	
	img_TFZJ = Talent_ui:AddImage(path_start.."talentfont_start.png",10,5,256,32)
	img_TYJN = Common_ui:AddImage(path_start.."summonerfont_start.png",10,5,256,32)
	
	-- Tutorial
	img_BubbleBG = wnd:AddImage(path_hero.."message_hero.png",0,0,402,280)
	img_BubbleBG:SetVisible(0)
	btn_BubbleSure = img_BubbleBG:AddButton(path_hero.."detail1_hero.png", path_hero.."detail2_hero.png", path_hero.."detail3_hero.png", 156, 120, 90, 40)
end
-----按照ID查找英雄详细信息发给start界面
function FindHeroInfoSendToStart(strPictureName,strName,HeroId,tip,index)

	if index>0 and index<7 then
		SendData_ChoseHeroTeamplayer(strPictureName,strName,HeroId,tip,index)
	end
	
	local size = index+1	
	if size==1 then
		SetClientSelSkinIndex_skinframe(0)
		CueSelHeroId_gamestart = HeroId
		SetWndBgImg_gamestart(path_hero.."ffffff_hero.png", 0)
		SetWndBgImg_choosehero(path_hero.."ffffff_hero.png", 0)
		if FindHeroHeadIcon_ChoseHero(CueSelHeroId_gamestart) then
			SetWndBgImg_gamestart("..\\UI\\hero\\"..CueSelHeroId_gamestart..".png", 0)
			SetWndBgImg_choosehero("..\\UI\\hero\\"..CueSelHeroId_gamestart..".png", 0)
		end
	end
	HeroInfo.strPictureName[size] = "..\\"..strPictureName					--log("\nFindHeroInfoSendToStart   -1")--1

	HeroInfo.strName[size] = strName										--log("\nFindHeroInfoSendToStart   -2")--2
	HeroInfo.heroId[size] = HeroId											--log("\nFindHeroInfoSendToStart   -9")
	HeroInfo.heroTip[size] = tip	
	-----------0------------
	hero_head[size].changeimage(HeroInfo.strPictureName[size])				--log("\nFindHeroInfoSendToStart   -10")
	hero_head[size]:SetImageTip(HeroInfo.heroTip[size])
	hero_head[size]:SetVisible(1)
	
end
----------队友谁出击了
function Teammates_StartGame(index)
	if index >0 and index <8 then
		hero_hide[index]:SetVisible(0)
		
		if index==1 then
			hero_side[index].changeimage(path_start.."icon4_start.png")
		else
			hero_side[index].changeimage(path_start.."icon9_start.png")
			ChoseHeroTeamplayer_StartGame(index-1)
		end
	end
end
function Hero_AssistSkill(assistA,assistB,tip1,tip2,index)
	local size = index+1
	hero_assistA[size].changeimage("..\\"..assistA)
	hero_assistB[size].changeimage("..\\"..assistB)
	hero_assistA[size]:SetImageTip(tip1)
	hero_assistB[size]:SetImageTip(tip2)
	hero_assistA[size]:SetVisible(1)
	hero_assistB[size]:SetVisible(1)
end
------修改第一个召唤师技能summonerSkill.lua
function Start_SummonerSkillA(assistA,tip1)
	Current_summonerskillA(assistA,tip1)			
	BTN_SKILL1.changeimage("..\\"..assistA)
	BTN_SKILL1:SetImageTip(tip1)
end
------修改第二个召唤师技能summonerSkill.lua
function Start_SummonerSkillB(assistB,tip2)
	Current_summonerskillB(assistB,tip2)			
	BTN_SKILL2.changeimage("..\\"..assistB)
	BTN_SKILL2:SetImageTip(tip2)
end

function Init_TeamplayerName(name,index)
	hero_controlName[index+1]:SetFontText(name,0x81f5ff)
	hero_controlName[index+1]:SetVisible(1)
end
---------复原到匹配成功的初始化状态
function RecoverStartList()
	
	for index,value in pairs(hero_head) do
		hero_head[index]:SetVisible(0)
		hero_hide[index]:SetVisible(1)
		hero_controlName[index]:SetVisible(0)
		hero_assistA[index].changeimage(path_equip.."bag_equip.png")
		hero_assistB[index].changeimage(path_equip.."bag_equip.png")
		hero_side[index].changeimage(hero_sideList[index])
	end
			
	BTN_random:SetEnabled(1)
	BTN_go:SetEnabled(1)
	BTN_herochose:SetEnabled(1)
		
	---英雄信息表
	HeroInfo = {}					----清除发送来的信息
	HeroInfo.strPictureName = {}	----英雄头像路径
	HeroInfo.strName = {}			----英雄名称
	HeroInfo.heroId = {}
	HeroInfo.heroTip = {}

end
---------不可以点击界面
function RandomStartDisabled()
	BTN_random:SetEnabled(0)
	BTN_go:SetEnabled(0)
	BTN_herochose:SetEnabled(0)
end

function SetGameStartIsVisible(flag) 
	if g_game_start_ui ~= nil then
		if flag == 1 and g_game_start_ui:IsVisible() == false then
			g_game_start_ui:SetVisible(1)
			
			SetFourpartUIVisiable(0)
			
			-- 设置皮肤框是否显示和位置
			SetSkinWindowPos(1)
			SetGameSkinFrameIsVisible(1)
			
			-- log("\n1111111111111111111")
		elseif flag == 0 and g_game_start_ui:IsVisible() == true then
			g_game_start_ui:SetVisible(0)
			-- log("\n0000000000000000000")
		end
	end
end

function ClearTalentList_gamestart()
	BTN_TalentFont = {}
	Font_showAll:SetFontText("", 0xbeb5ee)
	LIST_BK:SetVisible(0)
	BTN_LIST:SetButtonFrame(0)
	for index,value in pairs(BTN_Talent) do
		BTN_Talent[index]:SetVisible(0)
	end
	for index,value in pairs(SummonerTalentList) do
		SummonerTalentList[index]:SetVisible(0)
	end
end

function SetSummonerTalentListInfor_gamestart( cTalentName)
	local index = #BTN_TalentFont+1
	BTN_TalentFont[index] = cTalentName
	BTN_Talent[index]:SetVisible(1)
	SummonerTalentList[index]:SetFontText(cTalentName, 0xbeb5ee)
	SummonerTalentList[index]:SetVisible(1)
	XSetAddImageRect( LIST_BK.id, 0, 0, 124, index*29, 10, 87, 124, index*29)
end

function SetLastSelTalent_gamestart( cTalentName, cIndex)
	SelTalentIndex = cIndex
	Font_showAll:SetFontText( cTalentName, 0xbeb5ee)
end

function SetWndBgImg_gamestart(cpath, lv)
	bgImg.changeimage(cpath)
	if lv==0 then
		bgImg_SkinLv:SetVisible(0)
	else
		bgImg_SkinLv:SetVisible(1)
		bgImg_SkinLv.changeimage(path_hero.."skinlv_"..lv..".png")
	end
end

function SetWndBgImg_gamestartEx()
	SetWndBgImg_gamestart(path_hero.."ffffff_hero.png", 0)
	SetWndBgImg_choosehero(path_hero.."ffffff_hero.png", 0)
	if FindHeroHeadIcon_ChoseHero(CueSelHeroId_gamestart) then
		SetWndBgImg_gamestart("..\\UI\\hero\\"..CueSelHeroId_gamestart..".png", 0)
		SetWndBgImg_choosehero("..\\UI\\hero\\"..CueSelHeroId_gamestart..".png", 0)
	end
end

function SetGameStartTutorialState( cIsEnable, cId)
	if cId==1 then
		hero_side[1]:EnableImageAnimateEX(cIsEnable, 11, 90, 0, 0, 0, 0)
	elseif cId==2 then
		hero_side[1]:EnableImageAnimateEX(cIsEnable, 11, 90, -90, 0, 510, 0)
	elseif cId==3 then
		hero_side[2]:EnableImageAnimateEX(cIsEnable, 11, 90, -30, -320, 510, 380)
	elseif cId==4 then
		iiiimgFont:EnableImageAnimateEX(cIsEnable, 7, 90, 20, 120, -20, -120)
	elseif cId==5 then
		img_TFZJ:EnableImageAnimateEX(cIsEnable, 11, 90, 10, 5, -55, 70)
	elseif cId==6 then
		img_TYJN:EnableImageAnimateEX(cIsEnable, 11, 90, 10, 5, -55, 70)
	else
	
	end
end

function SetTutorialButtonEnable(IsEnable)
	BTN_herochose:SetEnabled(1)
	BTN_random:SetEnabled(IsEnable)
	BTN_go:SetEnabled(IsEnable)
	BTN_change:SetEnabled(IsEnable)
	BTN_SKILL1:SetTouchEnabled(IsEnable)
	BTN_SKILL2:SetTouchEnabled(IsEnable)
	BTN_replace:SetEnabled(IsEnable)
	BTN_LIST:SetTouchEnabled(IsEnable)
	
	if IsEnable==1 then
		SetGameStartIsVisible(0)
		SetGameChoseHeroIsVisible(1)
		SetSkinWindowPos(0)
	end
end

function SetTutorialAllButtonEnable(IsEnable)
	BTN_random:SetEnabled(IsEnable)
	BTN_go:SetEnabled(IsEnable)
	BTN_change:SetEnabled(IsEnable)
	BTN_herochose:SetEnabled(IsEnable)
	BTN_SKILL1:SetTouchEnabled(IsEnable)
	BTN_SKILL2:SetTouchEnabled(IsEnable)
	BTN_replace:SetEnabled(IsEnable)
	BTN_LIST:SetTouchEnabled(IsEnable)
end

function ColseTalentSelTalent( ccIndex)
	-- log("\ng_game_start_ui:IsVisible() = "..g_game_start_ui:IsVisible())
	if n_readytime_ui:IsVisible() then
		SelTalentIndex = ccIndex-1
		XSelSummonerTalent_gamestart( SelTalentIndex)
		Font_showAll:SetFontText( BTN_TalentFont[ccIndex], 0xbeb5ee)
	end
end