include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")


--游戏、商城、活动、装备

local BTN_RETURN = nil
local bgImg = nil
local btn_webSite = nil
local btn_game = nil
local btn_equip = nil
local btn_hero = nil
local btn_shop = nil

-- 排队等待相关UI
local img_WaitTimeBg = nil	-- 排队等待背景
local btn_CloseWait = nil	-- 取消等待按钮
local img_TimerRRight = nil	-- 时间
local img_TimerRLeft = nil
local img_TimerLRight = nil
local img_TimerLLeft = nil
local count = 0
local second = 0
local secondL = 0
local minute = 0
local minuteL = 0

local btn_BK = nil
local btn_posx = {20,110,200,290}



--目标、活动、邮件、头像、在线人数、金币钻石
local btn_personal = nil
local btn_newserver = nil
local btn_sevenday = nil
local btn_growup = nil
local btn_active = nil
local btn_mail = nil
local btn_firstpay = nil


local btn_headPic = nil
local btn_headPicImg = nil

local show_money = nil
local show_gold = nil
local show_onlinepeople = nil

-----等级、未读邮件、金币钻石、在线人数-----全局变量（便于其他界面操作是否显示）
local player_level = nil
local player_level_bg = nil
local player_mail = nil
local player_friend = nil
local btn_mailNum,btn_friendNum = nil
local friendInfomationPromot = nil
local Money_Img = {}
local Gold_Img = {}
local online_Img = {}
local max_money = 0
local max_gold = 0
local max_online = 0

local forbidden = {}
local forbidden_pic = {path.."punish1_hall.png",path.."punish2_hall.png",path.."punish3_hall.png"}
local forbidden_tip = {}


-----签到任务、首充大礼
local btn_signtask = nil
local btn_firstcharge = nil
local btn_friend = nil

local Btn_min = nil
local Btn_close = nil
local Btn_setup = nil


function InitGame_FourpartUI(wnd,bVisible)
	g_shop_hero_equip_ui = CreateWindow(wnd.id, 0, 0, 1280, 50)
	Init_MenuListpart(g_shop_hero_equip_ui)
	Init_MenuMailpart(g_shop_hero_equip_ui)
	g_shop_hero_equip_ui:SetVisible(bVisible)
end

function Init_MenuListpart(wnd)

	--上边栏
	bgImg = wnd:AddImage(path.."upBK_hall.png",0,0,1280,54)
	
	btn_BK = wnd:AddImage(path.."mainListBK_hall.png",20,0,405,54)

	btn_webSite = wnd:AddButton(path_login.."300logo_login.png",path_login.."300logo1_login.png",path_login.."300logo_login.png",5,1,168,73)
	btn_webSite:SetTextTip("肺厚蓖券")
	btn_webSite.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		ReturnToMenuList(0)
	end
		
	--上面一行
	--游戏
	btn_game = wnd:AddCheckButton(path.."game1_hall.png",path.."game2_hall.png",path.."game3_hall.png",165,0,82,51)
	XWindowEnableAlphaTouch(btn_game.id)
	btn_game.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		
		ReturnToMenuList(1)
	end
	--装备
	btn_equip = wnd:AddCheckButton(path.."equip1_hall.png",path.."equip2_hall.png",path.."equip3_hall.png",250,0,82,51)
	XWindowEnableAlphaTouch(btn_equip.id)
	btn_equip.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		
		ReturnToMenuList(2)
	end
	--英雄
	btn_hero = wnd:AddCheckButton(path.."hero1_hall.png",path.."hero2_hall.png",path.."hero3_hall.png",335,0,82,51)
	XWindowEnableAlphaTouch(btn_hero.id)
	btn_hero.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		
		ReturnToMenuList(3)
	end
	--商城
	btn_shop = wnd:AddCheckButton(path.."shangcheng1_hall.png",path.."shangcheng2_hall.png",path.."shangcheng3_hall.png",420,0,82,51)
	XWindowEnableAlphaTouch(btn_shop.id)
	btn_shop.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		
		ReturnToMenuList(4)
	end
	
	-- 等待排队
	img_WaitTimeBg = wnd:AddImage(path.."waitTimeBK_hall.png",430,0,490,120)
	img_WaitTimeBg:SetVisible(0)
	img_WaitTimeBg:SetTouchEnabled(0)
	
	btn_CloseWait = img_WaitTimeBg:AddButton(path.."queuenum/".."clane.png",path.."queuenum/".."clanem.png",path.."queuenum/".."clane.png",320,30,32,16)
	XWindowEnableAlphaTouch(btn_CloseWait.id)
	btn_CloseWait.script[XE_LBUP] = function()
		XCloseWait()
	end
	
	img_WaitTimeBg:AddImage(path.."maohao_hall.png",221,-5,64,64)
	
	img_TimerRRight = img_WaitTimeBg:AddImage(path.."queuenum/0.png", 282,10,32,32)
	img_TimerRLeft = img_WaitTimeBg:AddImage(path.."queuenum/0.png", 254,10,32,32)
	img_TimerLRight = img_WaitTimeBg:AddImage(path.."queuenum/0.png", 210,10,32,32)
	img_TimerLLeft = img_WaitTimeBg:AddImage(path.."queuenum/0.png", 182,10,32,32)
	
	--上边栏	
	BTN_RETURN = wnd:AddButton(path.."return1_hall.png",path.."return2_hall.png",path.."return1_hall.png",12,82,72,54)
	BTN_RETURN:SetTextTip("肺厚蓖券")
	BTN_RETURN.script[XE_LBUP] = function()
		XClickPlaySound(5)
		ReturnToMenuList(0)
	end
	
end

function Init_MenuMailpart(wnd)

	--新服庆典
	-- btn_newserver = wnd:AddButton(path.."newserver1_hall.png",path.."newserver2_hall.png",path.."newserver1_hall.png",880,10,64,64)
	-- btn_newserver.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
		
		-- SetGameHallIsVisible(0)
		-- SetGameFightIsVisible(0)
		-- SetGameEquipIsVisible(0)
		-- SetGameHeroIsVisible(0)
		-- SetGameShopIsVisible(0)
		-- SetTaskIsVisible(1,5)
		-- SetPlayerInfoIsVisible(0)
		
	-- end
	-- --七天目标
	-- btn_sevenday = wnd:AddButton(path.."sevenday1_hall.png",path.."sevenday2_hall.png",path.."sevenday1_hall.png",940,10,64,64)
	-- btn_sevenday.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
		
		-- SetGameHallIsVisible(0)
		-- SetGameFightIsVisible(0)
		-- SetGameEquipIsVisible(0)
		-- SetGameHeroIsVisible(0)
		-- SetGameShopIsVisible(0)
		-- SetTaskIsVisible(1,4)
		-- SetPlayerInfoIsVisible(0)
		
	-- end
	-- --成长福利
	-- btn_growup = wnd:AddButton(path.."growup1_hall.png",path.."growup2_hall.png",path.."growup1_hall.png",1000,10,64,64)
	-- btn_growup.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
		
		-- SetGameHallIsVisible(0)
		-- SetGameFightIsVisible(0)
		-- SetGameEquipIsVisible(0)
		-- SetGameHeroIsVisible(0)
		-- SetGameShopIsVisible(0)
		-- SetTaskIsVisible(1,3)
		-- SetPlayerInfoIsVisible(0)
		
	-- end
	-- --限时活动
	-- btn_active = wnd:AddButton(path.."limittime1_hall.png",path.."limittime2_hall.png",path.."limittime1_hall.png",1060,10,64,64)
	-- btn_active.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
		
		-- SetGameHallIsVisible(0)
		-- SetGameFightIsVisible(0)
		-- SetGameEquipIsVisible(0)
		-- SetGameHeroIsVisible(0)
		-- SetGameShopIsVisible(0)
		-- SetTaskIsVisible(1,2)
		-- SetPlayerInfoIsVisible(0)
		
	-- end
	--首充大礼
	btn_firstcharge = wnd:AddCheckButton(path.."zhuanshi.png",path.."zhuanshi1.png",path.."zhuanshi1.png",880,5,61,53)
	btn_firstcharge.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		
		ReturnToMenuList(10)
	end
	--local btn_firstcharge2 = wnd:AddEffect("../Data/Magic/Common/UI/changwai/gold/firstcharge.x",0,0,1280,800)
	-- btn_firstcharge2.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
		
		-- ReturnToMenuList(10)
	-- end
	
	--个人信息
	btn_personal = wnd:AddCheckButton(path.."personal1_hall.png",path.."personal2_hall.png",path.."personal3_hall.png",940,10,56,56)
	btn_personal.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		ReturnToMenuList(5)	
	end
	--签到任务
	btn_signtask = wnd:AddCheckButton(path.."signtask1_hall.png",path.."signtask2_hall.png",path.."signtask3_hall.png",1000,10,56,56)
	btn_signtask.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		ReturnToMenuList(6)
		RequestTaskData()
	end	
	btn_friend = wnd:AddButton(path.."friend1_hall.png",path.."friend2_hall.png",path.."friend1_hall.png",1060,10,56,56)
	btn_friendNum = btn_friend:AddImage(path.."friend4_hall_big.png",13,46,32,32)
	btn_friend.script[XE_LBUP] = function()
		XClickPlaySound(5)
		ReturnToMenuList(7)
	end
		
	--邮件
	btn_mail = wnd:AddButton(path.."mail1_hall.png",path.."mail2_hall.png",path.."mail1_hall.png",1120,10,56,56)
	btn_mailNum = btn_mail:AddImage(path.."friend4_hall_big.png",13,46,32,32)
	btn_mail.script[XE_LBUP] = function()
		XClickPlaySound(5)
		ReturnToMenuList(8)
	end
	
	--头像边框
	
	btn_headPicImg = wnd:AddImage(path.."summonerhead_hall.png",1185,10,62,62)
	btn_headPicImg:SetTouchEnabled(0)
	
	player_level_bg = btn_headPicImg:AddImage(path.."friend4_hall.png",0,45,32,32)
	btn_headPic = btn_headPicImg:AddButton(path.."headSide1_hall.png",path.."headSide2_hall.png",path.."headSide2_hall.png",-3,-3,68,68)
	btn_headPic:SetTextTip("俺牢沥焊焊扁")
	btn_headPic.script[XE_LBUP] = function()
		XClickPlaySound(5)
		ReturnToMenuList(9)
	end
	for i = 1,3 do
		forbidden[i] = wnd:AddImage(forbidden_pic[i],1225,70-20*i,16,16)
		forbidden_tip[i] = wnd:AddImage(path.."chatBK_hall.png",1225,70-20*i,16,16)
		forbidden_tip[i]:SetTransparent(0)
		forbidden_tip[i]:SetTouchEnabled(0)
		forbidden[i]:SetVisible(0)
	end
	friendInfomationPromot = btn_friend:AddImage(path.."friendMes_hall.png",35,-3,19,20)
	friendInfomationPromot:SetTextTip("模备脚没 档馒!")
	friendInfomationPromot:SetVisible(0)
	
	--金币
	show_money = wnd:AddImage(path_shop.."money_shop.png",1155,90,64,64)
	--钻石
	show_gold = wnd:AddImage(path_shop.."gold_shop.png",1055,90,64,64)
	--在线人数
	show_onlinepeople = wnd:AddImage(path.."online_hall.png",960,90,32,32)
	player_level = player_level_bg:AddFontEx("3", 12, 8, 0, 0, 18, 20, 0xffffff)

	player_mail = btn_mailNum:AddFont("0", 12, 8, 0, 0, 30, 20, 0xffffff)
	player_friend = btn_friendNum:AddFont("0", 12, 8, 0, 0, 30, 20, 0xffffff)
	
	for i=1,8 do
		posX = i*10+1170
		Money_Img[i] = wnd:AddImage(path.."money/0.png",posX,94,32,32)
	
		posX = i*10+1070
		Gold_Img[i] = wnd:AddImage(path.."gold/0.png",posX,94,32,32)
		
		posX = i*10+975
		online_Img[i] = wnd:AddImage(path.."online/0.png",posX,94,32,32)
	end
	
	for index,value in pairs(Money_Img) do
		Money_Img[index]:SetVisible(0)
	end
	for index,value in pairs(Gold_Img) do
		Gold_Img[index]:SetVisible(0)
	end
	for index,value in pairs(online_Img) do
		online_Img[index]:SetVisible(0)
	end
	
	Btn_close = wnd:AddButton(path.."close1_hall.png",path.."close2_hall.png",path.."close3_hall.png",1253,4,23,23)
	Btn_close:SetTextTip("摧扁")
	Btn_close.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGameCloseWindow(1)
	end
	
	Btn_min = wnd:AddButton(path.."min1_hall.png",path.."min2_hall.png",path.."min3_hall.png",1253,28,23,23)
	Btn_min:SetTextTip("弥家拳")
	Btn_min.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGameSmallWindow(1)
	end
	
	Btn_setup = wnd:AddButton(path.."setup1_hall.png",path.."setup2_hall.png",path.."setup3_hall.png",1253,54,23,23)
	Btn_setup:SetTextTip("汲沥")
	Btn_setup.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		Set_SetupIsVisible(1)
	end
end
function SetReturnVisible(flag)
	BTN_RETURN:SetVisible(flag)
end
function ReturnToMenuList(index)
	if index==0 then
		btn_BK:SetVisible(0)
		
		SetGameHallIsVisible(1)
		SetGameFightIsVisible(0)
		SetGameEquipIsVisible(0)
		SetGameHeroIsVisible(0)
		SetGameShopIsVisible(0)
		SetTaskIsVisible(0,0)
		SetPlayerInfoIsVisible(0)
		
		btn_game:SetCheckButtonClicked(0)
		btn_equip:SetCheckButtonClicked(0)
		btn_hero:SetCheckButtonClicked(0)
		btn_shop:SetCheckButtonClicked(0)
		btn_personal:SetCheckButtonClicked(0)
		btn_signtask:SetCheckButtonClicked(0)
		--btn_headPic:SetCheckButtonClicked(0)
		btn_firstcharge:SetCheckButtonClicked(0)
	elseif index==1 then
		btn_BK:SetVisible(1)
		btn_BK:SetPosition(20,0)
		
		SetGameHallIsVisible(0)
		SetGameFightIsVisible(1)
		SetGameEquipIsVisible(0)
		SetGameHeroIsVisible(0)
		SetGameShopIsVisible(0)
		SetTaskIsVisible(0,0)
		SetPlayerInfoIsVisible(0)
		
		btn_game:SetCheckButtonClicked(1)
		btn_equip:SetCheckButtonClicked(0)
		btn_hero:SetCheckButtonClicked(0)
		btn_shop:SetCheckButtonClicked(0)
		btn_personal:SetCheckButtonClicked(0)
		btn_signtask:SetCheckButtonClicked(0)
		--btn_headPic:SetCheckButtonClicked(0)
		btn_firstcharge:SetCheckButtonClicked(0)
	elseif index==2 then
		btn_BK:SetVisible(1)
		btn_BK:SetPosition(110,0)
		
		SetGameHallIsVisible(0)
		SetGameFightIsVisible(0)
		SetGameEquipIsVisible(1)
		SetGameHeroIsVisible(0)
		SetGameShopIsVisible(0)
		SetTaskIsVisible(0,0)
		SetPlayerInfoIsVisible(0)
		
		btn_game:SetCheckButtonClicked(0)
		btn_equip:SetCheckButtonClicked(1)
		btn_hero:SetCheckButtonClicked(0)
		btn_shop:SetCheckButtonClicked(0)
		btn_personal:SetCheckButtonClicked(0)
		btn_signtask:SetCheckButtonClicked(0)
		--btn_headPic:SetCheckButtonClicked(0)
		btn_firstcharge:SetCheckButtonClicked(0)
	elseif index==3 then
		btn_BK:SetVisible(1)									
		btn_BK:SetPosition(200,0)								
		
		SetGameHallIsVisible(0)											
		SetGameFightIsVisible(0)									
		SetGameEquipIsVisible(0)											
		SetGameHeroIsVisible(1)										
		SetGameShopIsVisible(0)								
		SetTaskIsVisible(0,0)									
		SetPlayerInfoIsVisible(0)								
		
		btn_game:SetCheckButtonClicked(0)
		btn_equip:SetCheckButtonClicked(0)
		btn_hero:SetCheckButtonClicked(1)
		btn_shop:SetCheckButtonClicked(0)
		btn_personal:SetCheckButtonClicked(0)
		btn_signtask:SetCheckButtonClicked(0)
		--btn_headPic:SetCheckButtonClicked(0)
		btn_firstcharge:SetCheckButtonClicked(0)
	elseif index==4 then
		btn_BK:SetVisible(1)
		btn_BK:SetPosition(290,0)
		
		SetGameHallIsVisible(0)
		SetGameFightIsVisible(0)
		SetGameEquipIsVisible(0)
		SetGameHeroIsVisible(0)
		SetGameShopIsVisible(1)
		SetTaskIsVisible(0,0)
		SetPlayerInfoIsVisible(0)
		
		btn_game:SetCheckButtonClicked(0)
		btn_equip:SetCheckButtonClicked(0)
		btn_hero:SetCheckButtonClicked(0)
		btn_shop:SetCheckButtonClicked(1)
		btn_personal:SetCheckButtonClicked(0)
		btn_signtask:SetCheckButtonClicked(0)
		--btn_headPic:SetCheckButtonClicked(0)
		btn_firstcharge:SetCheckButtonClicked(0)
	elseif index==5 then
		XClickSummonerHeadIcon_EX()
		SetGameHallIsVisible(0)
		SetGameFightIsVisible(0)
		SetGameEquipIsVisible(0)
		SetGameHeroIsVisible(0)
		SetGameShopIsVisible(0)
		SetTaskIsVisible(0,0)
		SetPlayerInfoIsVisible(1)
		
		btn_game:SetCheckButtonClicked(0)
		btn_equip:SetCheckButtonClicked(0)
		btn_hero:SetCheckButtonClicked(0)
		btn_shop:SetCheckButtonClicked(0)
		btn_personal:SetCheckButtonClicked(1)
		btn_signtask:SetCheckButtonClicked(0)
		--btn_headPic:SetCheckButtonClicked(0)	
		btn_firstcharge:SetCheckButtonClicked(0)		
	elseif index==6 then
		SetGameHallIsVisible(0)			
		SetGameFightIsVisible(0)		
		SetGameEquipIsVisible(0)		
		SetGameHeroIsVisible(0)			
		SetGameShopIsVisible(0)			
		SetTaskIsVisible(1,1)			
		SetPlayerInfoIsVisible(0)
		
		btn_game:SetCheckButtonClicked(0)
		btn_equip:SetCheckButtonClicked(0)
		btn_hero:SetCheckButtonClicked(0)
		btn_shop:SetCheckButtonClicked(0)
		btn_personal:SetCheckButtonClicked(0)
		btn_signtask:SetCheckButtonClicked(1)
		--btn_headPic:SetCheckButtonClicked(0)
		btn_firstcharge:SetCheckButtonClicked(0)
	elseif index==7 then
		XSetuppartUISetTalkIsVisible()
	elseif index==8 then
		SetMailIsVisible(1)
	elseif index==9 then
		XClickSummonerHeadIcon_EX()
		SetGameHallIsVisible(0)
		SetGameFightIsVisible(0)
		SetGameEquipIsVisible(0)
		SetGameHeroIsVisible(0)
		SetGameShopIsVisible(0)
		SetTaskIsVisible(0,0)
		SetPlayerInfoIsVisible(1)
		
		btn_game:SetCheckButtonClicked(0)
		btn_equip:SetCheckButtonClicked(0)
		btn_hero:SetCheckButtonClicked(0)
		btn_shop:SetCheckButtonClicked(0)
		btn_personal:SetCheckButtonClicked(0)
		btn_signtask:SetCheckButtonClicked(0)
		--btn_headPic:SetCheckButtonClicked(1)
		btn_firstcharge:SetCheckButtonClicked(0)
	elseif index==10 then
		SetGameHallIsVisible(0)			
		SetGameFightIsVisible(0)		
		SetGameEquipIsVisible(0)		
		SetGameHeroIsVisible(0)			
		SetGameShopIsVisible(0)			
		SetTaskIsVisible(1,2)
		SetPlayerInfoIsVisible(0)
		
		btn_game:SetCheckButtonClicked(0)
		btn_equip:SetCheckButtonClicked(0)
		btn_hero:SetCheckButtonClicked(0)
		btn_shop:SetCheckButtonClicked(0)
		btn_personal:SetCheckButtonClicked(0)
		btn_signtask:SetCheckButtonClicked(0)
		--btn_headPic:SetCheckButtonClicked(0)
		btn_firstcharge:SetCheckButtonClicked(1)
	end
end


---------设置跳转到装备界面
function Set_JumpToEquip()
		btn_equip:TriggerBehaviour(XE_LBDOWN)
		btn_equip:CancelCapture()
		JumpToEquip = 0		
end
---------设置跳转到英雄集卡书界面
function Set_JumpToHeroAll()
		btn_hero:TriggerBehaviour(XE_LBDOWN)
		btn_hero:CancelCapture()
		JumpToEquip = 1		
end
----------设置跳到商城英雄界面
function Set_JumpToShopHero()
		btn_shop:TriggerBehaviour(XE_LBDOWN)
		btn_shop:CancelCapture()
		Set_JumpToShopSecHero()				
end
----------设置跳到集卡书二级页面
function Set_JumpToHeroDetail()
		btn_hero:TriggerBehaviour(XE_LBDOWN)
		btn_hero:CancelCapture()
		EventToHeroDetail(183)		-- 跳到金刚的集卡书二级页	
end


-- 设置等待排队界面是否显示
function SetWaitTimeUiIsVisible(bVisible)
	img_WaitTimeBg:SetVisible(bVisible)
end

-- 得到时间并显示
function GetWaitTime(index)
	-- -- 判断是否过了过了一秒
	-- if ((index - count) ~= 0) then
		-- second = second + 1
		-- -- 如果秒数个位数大于9，则十位数+1，并且个位数=0
		-- if (second > 9) then
			-- second = 0
			-- secondL = secondL + 1
			-- -- 如果秒数十位数大于9，则分的个位数+1，并且秒的十位数=0
			-- if (secondL == 6) then
				-- secondL = 0
				-- minute = minute + 1
				-- -- 如果分的个位数大于9，则分的十位数+1，并且分的个位数=0
				-- if (minute > 9) then
					-- minute = 0
					-- minuteL = minuteL + 1
					-- if (minuteL == 6) then
						-- minuteL = 0
					-- end
				-- end
			-- end
		-- end
	-- end
	--log("\nindex = "..index)
	local minutes = tonumber(string.format("%d",index/60))	--log("\nminutes = "..minutes)
	local seconds = tonumber(string.format("%d",index%60))  --log("\nseconds = "..seconds)
	
	secondL = tonumber(string.format("%d",seconds/10))
	second  = tonumber(string.format("%d",seconds%10))
	
	minuteL = tonumber(string.format("%d",minutes/10))
	minute  = tonumber(string.format("%d",minutes%10))
	
	img_TimerRRight.changeimage(path .. "queuenum/" .. second .. ".png")
	img_TimerRLeft.changeimage(path .. "queuenum/" .. secondL .. ".png")
	img_TimerLRight.changeimage(path .. "queuenum/" .. minute .. ".png")
	img_TimerLLeft.changeimage(path .. "queuenum/" .. minuteL .. ".png")
	count = index
end

-- 清空上次的时间
function ClearTime()
	count = 0
	second = 0
	secondL = 0
	minute = 0
	minuteL = 0

	img_TimerRRight.changeimage(path .. "queuenum/0.png")
	img_TimerRLeft.changeimage(path .. "queuenum/0.png")
	img_TimerLRight.changeimage(path .. "queuenum/0.png")
	img_TimerLLeft.changeimage(path .. "queuenum/0.png")
end


function Click_M_OpenShop()
	ReturnToMenuList(4)
end

function Click_O_OpenEquip()
	ReturnToMenuList(2)
end

-- 签到、个人信息部分
function ChangeSummoner_head(pictureName)
	btn_headPicImg.changeimage(pictureName)
end
function FirstChangeSummoner_headXYWH(pictureName)

	btn_headPicImg.changeimage("..\\"..pictureName)
	FirstCurrent_SummonerHead(pictureName)
end
function ChangeSummoner_headXYWH(pictureName)

	btn_headPicImg.changeimage(pictureName)

	Current_SummonerHead(pictureName)
end

--清除金币
function ClearMoneyNum(sz)
	max_money = sz
	local flag = 0
	if g_shop_hero_equip_ui:IsVisible()==true then
		flag = 1
	end
	for index,value in pairs(Money_Img) do
		if index <=sz then
			Money_Img[index]:SetVisible(flag)
		else
			Money_Img[index]:SetVisible(0)
		end
	end
end
--清除钻石
function ClearGoldNum(sz)
	max_gold = sz
	local flag = 0
	if g_shop_hero_equip_ui:IsVisible()==true then
		flag = 1
	end
	for index,value in pairs(Gold_Img) do
		if index <=sz then
			Gold_Img[index]:SetVisible(flag)
		else
			Gold_Img[index]:SetVisible(0)
		end
	end
end
--清除在线人数
function ClearOnlineNum(sz)
	max_online = sz
	local flag = 0
	if g_shop_hero_equip_ui:IsVisible()==true then
		flag = 1
	end
	for index,value in pairs(online_Img) do
		if index <=sz then
			online_Img[index]:SetVisible(flag)
		else
			online_Img[index]:SetVisible(0)
		end
	end
end

--设置等级数字
function SendLvNumToLua(Lv)
	player_level:SetFontText(Lv,0xffffff)
end
--设置未读邮件数字
function SendMailNumToLua(mail)
	player_mail:SetFontText(mail,0xffffff)	
end
--设置在线好友数量
function SendOnlineFriendNumToLua(friend)
	player_friend:SetFontText(friend,0xffffff)
end
--设置金币数量
function SendMoneyNumToLua(money,Fth)
	local money_lua = path.."money/"..money..".png"
	Money_Img[Fth].changeimage(money_lua)	
end
--设置钻石数量
function SendGoldNumToLua(gold,Fth)
	local gold_lua = path.."gold/"..gold..".png"
	Gold_Img[Fth].changeimage(gold_lua)
end
--设置在线人数
function SendonlineNumToLua(people,Fth)
	local online_lua = path.."online/"..people..".png"
	online_Img[Fth].changeimage(online_lua)
end

--设置玩家游戏惩罚
function SetPunish(index,style,IsPunish,tip)
	if	index == 0 then	
		for i=1,3 do
			forbidden[i]:SetVisible(0)
			forbidden_tip[i]:SetTouchEnabled(0)	
		end
	else
		if IsPunish == 1 then
			forbidden[index].changeimage(forbidden_pic[style])	
			forbidden[index]:SetVisible(1)
			forbidden_tip[index]:SetTouchEnabled(1)
			forbidden_tip[index]:SetImageTip(tip)
		else	
			forbidden[index]:SetVisible(0)
			forbidden_tip[index]:SetTouchEnabled(0)	
		end	
	end	
end
-- 有好友申请
function SetAddFriendPromotVisible(flag)
	if flag == 1 and friendInfomationPromot:IsVisible()==false then
		friendInfomationPromot:SetVisible(1)
	elseif flag == 0 and friendInfomationPromot:IsVisible()==true then
		friendInfomationPromot:SetVisible(0)
	end
end	
function UpdateOnlineInfoImgVisible()
	for index,value in pairs(Money_Img) do
		if index <=max_money then
			Money_Img[index]:SetVisible(1)
		else
			Money_Img[index]:SetVisible(0)
		end
	end
	for index,value in pairs(Gold_Img) do
		if index <=max_gold then
			Gold_Img[index]:SetVisible(1)
		else
			Gold_Img[index]:SetVisible(0)
		end
	end
	for index,value in pairs(online_Img) do
		if index <=max_online then
			online_Img[index]:SetVisible(1)
		else
			online_Img[index]:SetVisible(0)
		end
	end
end

-- 设置是否显示
function SetFourpartUIVisiable(flag)
	if g_shop_hero_equip_ui ~= nil then
		if flag==1 then
			btn_BK:SetVisible(0)
			btn_game:SetCheckButtonClicked(0)
			btn_equip:SetCheckButtonClicked(0)
			btn_hero:SetCheckButtonClicked(0)
			btn_shop:SetCheckButtonClicked(0)
			btn_personal:SetCheckButtonClicked(0)
			btn_signtask:SetCheckButtonClicked(0)
			--btn_headPic:SetCheckButtonClicked(0)
		end
		if flag > 0 and g_shop_hero_equip_ui:IsVisible()==false then
			g_shop_hero_equip_ui:SetVisible(1)
			UpdateOnlineInfoImgVisible()
		elseif flag == 0 and g_shop_hero_equip_ui:IsVisible()==true then
			g_shop_hero_equip_ui:SetVisible(0)
		end
	end
end

function SetFirstCheckButtonVisible(bVisible)
	btn_firstcharge:SetVisible( bVisible)
end
function GetFirstCheckButtonVisible()
	if btn_firstcharge:IsVisible() then
		return 1
	else
		return 0
	end
end