include("../Data/Script/Common/include.lua")

local TutorialString = {"您好召唤师，欢迎来到新手训练营，点击“[color=0xffffff00]确定[color=0xffffffff]”开始训练吧。",
"这是[color=0xffffff00]准备大厅[color=0xffffffff]，你需要[color=0xffffff00]选择一个英雄[color=0xffffffff]进入游戏。",
"通常选择英雄是有[color=0xffffff00]时间限制[color=0xffffffff]，请在规定时间内选择你的英雄。",
"当你选择英雄后，这里会显示[color=0xffffff00]你所选英雄[color=0xffffffff]的半身像。",
"当[color=0xffffff00]你的队友[color=0xffffffff]选择英雄后，这里会显示他们的英雄信息。",
"这里是[color=0xffffff00]聊天框[color=0xffffffff]，你可以在这里和队友讨论战术。",
"请点击[color=0xffffff00]英雄选择按钮[color=0xffffffff]，开始选择英雄吧！",
"通过[color=0xffffff00]手动搜索[color=0xffffffff]或[color=0xffffff00]筛选功能[color=0xffffffff]，可以迅速定位你要选择的英雄。",
"下方是可出击[color=0xffffff00]英雄列表[color=0xffffffff]，包括[color=0xffffff00]你已拥有[color=0xffffffff]和[color=0xffffff00]限时免费[color=0xffffffff]的英雄。",
"现在请你选择一个英雄吧，[color=0xffffff00]左键单击[color=0xffffffff]英雄的半身像即可。",
"选中英雄后可[color=0xffffff00]双击英雄[color=0xffffffff]或点击[color=0xffffff00]返回按钮[color=0xffffffff]，返回准备大厅。",
"[color=0xffffff00]天赋专精[color=0xffffffff]能加强你的英雄，你可以在这里查看并修改。",
"你可以选择两个[color=0xffffff00]召唤师技能[color=0xffffffff]辅助你的英雄，点击技能图标可进行选择。",
"最后，点击[color=0xffffff00]出击按钮[color=0xffffffff]确认选择你的英雄，倒计时结束前，你依然可以修改你的天赋和召唤师技能。"}

local IsEnterTutorialMode = 0
local StepIndex = 0
local TutorialBackGroundImage = {}		-- 背景图
local TutorialFont = {}
local TutorialButton_OK = {}
local ImageSizeW = { 322, 324, 322, 339}
local ImageSizeH = { 222, 240, 238, 222}
local KongJianPosX = { -8, -8, -8, -8}
local KongJianPosY = { -5, -23, -5, -5}

function InitTutorial_UI( wnd, bIsOpen)
	g_Tutorial_ui = CreateWindow(wnd.id, 0, 0, 340, 240)
	InitMain_Tutorial(g_Tutorial_ui)
	g_Tutorial_ui:SetVisible(bIsOpen)
end

function InitMain_Tutorial( wnd)
	-- 默认创建一张背景图
	for i=1, 4 do
		TutorialBackGroundImage[i] = wnd:AddImage( path_tutorial.."tutorialbackground_" .. i .. ".png", 0, 0, ImageSizeW[i], ImageSizeH[i])
		TutorialFont[i] = TutorialBackGroundImage[i]:AddChat( 15, 8, KongJianPosX[i], KongJianPosY[i], 306, 160, 0xffbeb5ee)
		TutorialButton_OK[i] = TutorialBackGroundImage[i]:AddButton( path_hero.."detail1_hero.png", path_hero.."detail2_hero.png", path_hero.."detail3_hero.png", -(KongJianPosX[i]-108), -(KongJianPosY[i]-165), 90, 40)
		TutorialButton_OK[i]:AddFont( "确定", 15, 8, 0, 0, 90, 40)
		TutorialBackGroundImage[i]:SetVisible(0)
		
		TutorialButton_OK[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			XNextStepStart()
		end
	end
end

-- Type
-- 无 1
-- 上 2
-- 下 3
-- 右 4
function TutorialChangeBackImage( Type, String)
	for i=1, #TutorialBackGroundImage do
		TutorialBackGroundImage[i]:SetVisible(0)
	end
	TutorialBackGroundImage[Type]:SetVisible(1)
	TutorialFont[Type]:ClearChatText()
	TutorialFont[Type]:AddChatText( String)
end

-- 得到气泡文字
function GetTutorialStringFromLua( CurStep)
	XGetTutorialStringFromLua(TutorialString[CurStep+1])
	StepIndex = CurStep
end

function RunTutorialFromLua( RunStep)
	if RunStep==1 then
		
	elseif RunStep==2 then
		
	elseif RunStep==3 then
		SetReadyTimeTutorialState(1)
	elseif RunStep==4 then
		SetReadyTimeTutorialState(0)
		SetGameStartTutorialState(1, 1)
	elseif RunStep==5 then
		SetGameStartTutorialState(0, 1)
		SetGameStartTutorialState(1, 2)
	elseif RunStep==6 then
		SetGameStartTutorialState(0, 2)
		SetGameStartTutorialState(1, 3)
	elseif RunStep==7 then
		SetGameStartTutorialState(0, 3)
		SetGameStartTutorialState(1, 4)
	elseif RunStep==8 then
		SetGameStartTutorialState(0, 4)
		SetchoseheroTutorialState(1, 1)
	elseif RunStep==9 then
		SetchoseheroTutorialState(0, 1)
		SetchoseheroTutorialState(1, 2)
	elseif RunStep==10 then
		SetchoseheroTutorialState(0, 2)
		SetchoseheroTutorialState(1, 3)
	elseif RunStep==11 then
		SetchoseheroTutorialState(0, 3)
		SetchoseheroTutorialState(1, 4)
	elseif RunStep==12 then
		SetchoseheroTutorialState(0, 4)
		SetGameStartTutorialState(1, 5)
	elseif RunStep==13 then
		SetGameStartTutorialState(0, 5)
		SetGameStartTutorialState(1, 6)
	elseif RunStep==14 then
		SetGameStartTutorialState(0, 6)
	else
	end
end

function SetTutorialButtonTouchStateToLua( StepID, State)
	if IsEnterTutorialMode==1 then
		if StepID==1 then
			SetTutorialAllButtonEnable(State)
		elseif StepID==7 then
			-- "玩家需要点击英雄选择才能进行下一步"
			SetTutorialButtonEnable(State)
		elseif StepID==8 then
			-- 玩家进入英雄选择界面
			SetTutorialButtonEnable(1)
			-- 使英雄删选UI不可使用
			SetChoseHeroTutorialAllButtonEnable(State)
		elseif StepID==9 then
			-- 使英雄列表UI不可使用
			SetChoseHeroTutorialButtonEnable()
			AutoChoseHero_DeBug()
		elseif StepID==10 then
			SetTutorialButtonEnable(0)
		elseif StepID==11 then
			SetTutorialAllButtonEnable(State)
			ReturnGameStartUI()
		elseif StepID==14 then
			SetTutorialAllButtonEnable(State)
			SetChoseHeroTutorialAllButtonEnable(State)
		end
	end
end

function SetLOLGameMode( IsEnterTutorail)
	IsEnterTutorialMode = IsEnterTutorail
	
	if IsEnterTutorialMode==0 then
		SetTutorialAllButtonEnable(1)
		SetChoseHeroTutorialAllButtonEnable(1)
		
		SetReadyTimeTutorialState(0)
		for i=1, 6 do
			SetGameStartTutorialState(0, i)
		end
		for i=1, 4 do
			SetchoseheroTutorialState(0, i)
		end
	end
end

function GetTutorailModeIsOpen()
	return IsEnterTutorialMode
end

function GetStepIndex_Tutorial()
	return StepIndex
end