include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")
include("../Data/Script/game_hall.lua")
include("../Data/Script/GameHall/game_Fight.lua")


local Team_type = nil
local IsLeader = nil

local img_DownPullFrameLaTiao = nil
local img_DownPullFrameLaTiao1 = nil

-- 组队窗口控件
local img_TeamFight_bg = nil		-- 组对界面大背景
local btn_JieSanDuiWu = nil			-- 解散队伍按钮
local btn_StartGame = nil			-- 开始游戏按钮
local btn_HaoJiaoYaoQing = nil		-- 号角一键YQAN
local btn_YiJianYaoQing = nil		-- 一键YQAN
local LeaderFlag = nil				-- 队长旗帜
local PlayerInfo_TeamFight = {}		-- 组队成员UI
local btn_Team_n = {}				-- ZDAN
local btn_AddFriend_n = {}			-- 添加好友按钮  “+”
local btn_Out_n = {}				-- 踢出按钮 “踢出”
local PlayerName = {}				-- 队员名称
local PlayerNameFont = {}			-- 队员名称可以直接取出字符串
local PlayerInfo_bg = {}			-- 队员背景框
local PlayerHead_bg = {} 			-- 玩家头像框
local PlayerHead = {}				-- 玩家头像

local PlayerName_Info = {}			-- 玩家详细信息，等级和胜场
local MySelfIndex = nil 			-- 玩家自己在C++存放的数据中的索引
local img_FriendsYaoQing = nil 		-- 组队邀请ui
local YaoQingInfo = {}				-- 组队邀请玩家信息从C中得到的全部储存在这里
local SelYaoQingInfo = {}
local YaoQingIconPath = {}			-- 邀请界面召唤师头像
local SelYaoQingIconPath = {}
local YaoQingCount = 0				-- 总共有多少玩家可以邀请
local LeftCount = 0					-- 翻页计数Left
local RightCount = 0				-- 翻页计数Right
local img_YaoQingFriends_bg = {}	-- 邀请好友大背景
local font_Name = {}				-- 玩家名字
local img_HeadFrame = {}			-- 头像底框
local img_Head = {}					-- 头像
local YQAddBtn = {}					-- +按钮
local YQSubBtn = {} 				-- -按钮
local PlayerId = {} 				-- 玩家ID
local curPer1 = nil 				-- 滚动条百分比Left
local curPer2 = nil					-- 滚动条百分比Right
local Many_Equip1 = 0
local Many_Equip2 = 0
local TeamChatBg = nil 				-- 队伍聊天背景框
local chatInputEdit_Team = nil		-- 组队聊天输入栏
local chatInput_Team = nil			-- 队伍聊天框
local chatInputText_Team = nil		-- 队伍聊天框输入提示
local ChatInfo = nil				-- 聊天框中的内容
local ChatString = {}				-- 储存内容的表
local CurChatListCount = 0			-- 储存内容的个数

local Punish = {}					-- 惩罚标记
local Punish_tip = {}				-- 惩罚tip

local TeamTypeName = nil
local SelPlayerId = {}				-- 选中邀请的玩家ID

function InitGameTeamFight_ui(wnd,bisopen)
	if g_GameTeamFight_ui == nil then
		g_GameTeamFight_ui = CreateWindow(wnd.id, 0, 0, 1280, 800)
		g_GameTeamFight_ui:EnableBlackBackgroundTop(1)
		InitMainTeamFight_ui(g_GameTeamFight_ui)
	end
	g_GameTeamFight_ui:SetVisible(bisopen)
end

function InitMainTeamFight_ui(wnd)
	-- 组队战斗背景图，也是所有组队UI的父窗口
	img_TeamFight_bg = wnd:AddImage(path_mode.."TeamFightBK_mode.png",180,85,930,647)
	img_TeamFight_bg:AddImage(path_mode.."TeamFont_mode.png",0,0,890,62)
	TeamTypeName = img_TeamFight_bg:AddFontEx("NULL", 18, 0, 750, 20, 200, 20, 0xffffff)
	
	-- 第一个是队长，从二开始是队员
	PlayerInfo_TeamFight[1] = img_TeamFight_bg:AddImage(path_mode.."TeamPlayer_mode.png",694,58,343,112)
	PlayerInfo_TeamFight[1]:SetTransparent(0)
	PlayerInfo_TeamFight[2] = img_TeamFight_bg:AddImage(path_mode.."TeamPlayer_mode.png",10,58,343,112)
	PlayerInfo_TeamFight[3] = img_TeamFight_bg:AddImage(path_mode.."TeamPlayer_mode.png",345,58,343,112)
	PlayerInfo_TeamFight[4] = img_TeamFight_bg:AddImage(path_mode.."TeamPlayer_mode.png",10,159,343,112)
	PlayerInfo_TeamFight[5] = img_TeamFight_bg:AddImage(path_mode.."TeamPlayer_mode.png",345,159,343,112)
	PlayerInfo_TeamFight[6] = img_TeamFight_bg:AddImage(path_mode.."TeamPlayer_mode.png",10,260,343,112)
	PlayerInfo_TeamFight[7] = img_TeamFight_bg:AddImage(path_mode.."TeamPlayer_mode.png",345,260,343,112)
	
	-- 创建队长的头像底框
	PlayerHead_bg[1] = PlayerInfo_TeamFight[1]:AddImage(path_shop.."iconside_shop.png",38,25,70,70)
	
	-- 添加解散队伍按钮
	btn_JieSanDuiWu = PlayerInfo_TeamFight[1]:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png",8,385, 179, 56)
	BigBtn_Font1 = btn_JieSanDuiWu:AddFont("解散队伍",18,8,0,0,179,56,0xffB5A9D7)
	btn_JieSanDuiWu.script[XE_LBUP] = function()
		g_GameTeamFight_ui:SetVisible(0)
		ClearGameTeamChat()
		XQuitTeam()
		RightCount = 0
		LeftCount = 0
	end
	-- 添加开始游戏
	btn_StartGame = PlayerInfo_TeamFight[1]:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png",8,475, 179, 56)	
	btn_StartGame:AddFont("开始游戏",18,8,0,0,179,56,0xffB5A9D7)
	btn_StartGame.script[XE_LBUP] = function()
		XGameStartGame(Team_type)
		RightCount = 0
		LeftCount = 0
	end
	-- 添加号角YQAN
	btn_HaoJiaoYaoQing = PlayerInfo_TeamFight[1]:AddButton(path_mode.."addAllFriend1_mode.png",path_mode.."addAllFriend2_mode.png",path_mode.."addAllFriend3_mode.png",25,238,144,39)	
	btn_HaoJiaoYaoQing:AddFont("号角组队邀请",15,8,0,0,144,39,0xffB5A9D7)
	-- 添加一建YQAN
	btn_YiJianYaoQing = PlayerInfo_TeamFight[1]:AddButton(path_mode.."addAllFriend1_mode.png",path_mode.."addAllFriend2_mode.png",path_mode.."addAllFriend3_mode.png",25,315,144,39)		
	btn_YiJianYaoQing:AddFont("一键邀请好友",15,8,0,0,144,39,0xffB5A9D7)
	
	-- 下面6个按钮为组队YQAN
	for i =1,6 do
		btn_Team_n[i] = PlayerInfo_TeamFight[i+1]:AddButton(path_setup.."btn1_mail.png",path_setup.."btn2_mail.png",path_setup.."btn3_mail.png",115,37,100,32)
		btn_Team_n[i]:AddFont("组队邀请",15,8,0,0,100,32,0xffffff)
		btn_Team_n[i].script[XE_LBUP] = function()
			XGameIsOpenFriendList()
			chatInputEdit_Team:SetVisible(0)
		end
	end
	
	-- 一建邀请好友
	btn_YiJianYaoQing.script[XE_LBUP] = function()
		XAddAllFriends()
	end
	
	-- 当鼠标点下时，刷新当前所有可以邀请的好友，这句话很重要！不要删！
	btn_YiJianYaoQing.script[XE_LBDOWN] = function()
		XAddAllFriends_D()
	end
	
		
	-- 创建队员背景
	local posx = {10,345,10,345,10,345}
	local posy = {58,58,159,159,260,260}
	
	for k = 1,6 do
		PlayerInfo_bg[k] = img_TeamFight_bg:AddImage(path_mode.."TeamPlayer_mode.png",posx[k],posy[k],343,112)
		PlayerInfo_bg[k]:SetVisible(0)
		PlayerHead_bg[k+1] = PlayerInfo_bg[k]:AddImage(path_shop.."iconside_shop.png",17,19,70,70)
	end
	
	-- 添加好友按钮
	for m = 1,6 do
		btn_AddFriend_n[m] = PlayerInfo_bg[m]:AddButton(path_mode.."addfriend1_hero.png", path_mode.."addfriend2_hero.png", path_mode.."addfriend3_hero.png", 265, 22, 64, 32)
		btn_AddFriend_n[m]:AddFont("+", 18, 0, 20, 0, 20, 20, 0xffffffff)
	end
	
	btn_AddFriend_n[1].script[XE_LBUP] = function()
		if (IsLeader == 1) then
			XAddPlayerFriend(1)
		else
			XAddPlayerFriend(0)
		end
	end
	
	btn_AddFriend_n[2].script[XE_LBUP] = function()
		if (IsLeader == 1) then
			XAddPlayerFriend(2)
		else
			if (MySelfIndex == 1) then
				XAddPlayerFriend(2)
			else
				XAddPlayerFriend(1)
			end
		end
	end
	
	btn_AddFriend_n[3].script[XE_LBUP] = function()
		if (IsLeader == 1) then
			XAddPlayerFriend(3)
		else
			if (MySelfIndex == 3) then
				XAddPlayerFriend(2)
			else
				XAddPlayerFriend(3)
			end
		end
	end
	
	btn_AddFriend_n[4].script[XE_LBUP] = function()
		if (IsLeader == 1) then
			XAddPlayerFriend(4)
		else
			if (MySelfIndex == 4) then
				XAddPlayerFriend(3)
			else
				XAddPlayerFriend(4)
			end
		end
	end
	
	btn_AddFriend_n[5].script[XE_LBUP] = function()
		if (IsLeader == 1) then
			XAddPlayerFriend(5)
		else
			if (MySelfIndex == 5) then
				XAddPlayerFriend(4)
			else
				XAddPlayerFriend(5)
			end
		end
	end
	
	btn_AddFriend_n[6].script[XE_LBUP] = function()
		if (IsLeader == 1) then
			XAddPlayerFriend(6)
		else
			if (MySelfIndex == 6) then
				XAddPlayerFriend(5)
			else
				XAddPlayerFriend(6)
			end
		end
	end
	
	-- Out按钮
	for n = 1,6 do
		btn_Out_n[n] = PlayerInfo_bg[n]:AddButton(path_mode.."addfriend1_hero.png", path_mode.."addfriend2_hero.png", path_mode.."addfriend3_hero.png", 265, 62, 64, 32)
		btn_Out_n[n]:AddFont("踢出", 18, 0, 7, 0, 80, 20, 0xffffffff)
		btn_Out_n[n].script[XE_LBUP] = function()
			XKickPlayer(n)
			PlayerNameFont[n] = nil
		end
	end
	
	
	-- 创建角色名字
	PlayerName[1] = PlayerInfo_TeamFight[1]:AddFont("角色名字七个字",15,0,32,113,200,20,0xffF9F8FE)
	PlayerName[2] = PlayerInfo_bg[1]:AddFont("角色名字七个字",15,0,98,18,200,20,0xffF9F8FE)
	PlayerName[3] = PlayerInfo_bg[2]:AddFont("角色名字七个字",15,0,98,18,200,20,0xffF9F8FE)
	PlayerName[4] = PlayerInfo_bg[3]:AddFont("角色名字七个字",15,0,98,18,200,20,0xffF9F8FE)
	PlayerName[5] = PlayerInfo_bg[4]:AddFont("角色名字七个字",15,0,98,18,200,20,0xffF9F8FE)
	PlayerName[6] = PlayerInfo_bg[5]:AddFont("角色名字七个字",15,0,98,18,200,20,0xffF9F8FE)
	PlayerName[7] = PlayerInfo_bg[6]:AddFont("角色名字七个字",15,0,98,18,200,20,0xffF9F8FE)
	PlayerName_Info[1] = PlayerInfo_TeamFight[1]:AddFont("等级：99\n胜场：10000/10000",15,0,32,145,250,50,0xffB5A9D7)
	PlayerName_Info[2] = PlayerInfo_bg[1]:AddFont("等级：99\n胜场：10000/10000",15,0,100,45,250,50,0xffB5A9D7)
	PlayerName_Info[3] = PlayerInfo_bg[2]:AddFont("等级：99\n胜场：10000/10000",15,0,100,45,250,50,0xffB5A9D7)
	PlayerName_Info[4] = PlayerInfo_bg[3]:AddFont("等级：99\n胜场：10000/10000",15,0,100,45,250,50,0xffB5A9D7)
	PlayerName_Info[5] = PlayerInfo_bg[4]:AddFont("等级：99\n胜场：10000/10000",15,0,100,45,250,50,0xffB5A9D7)
	PlayerName_Info[6] = PlayerInfo_bg[5]:AddFont("等级：99\n胜场：10000/10000",15,0,100,45,250,50,0xffB5A9D7)
	PlayerName_Info[7] = PlayerInfo_bg[6]:AddFont("等级：99\n胜场：10000/10000",15,0,100,45,250,50,0xffB5A9D7)
	-- 队长旗帜
	LeaderFlag = img_TeamFight_bg:AddImage(path_mode.."DZBZ_mode.png",818,52,64,128)
	
	-- 以下是组队邀请界面UI
	img_FriendsYaoQing = wnd:AddImage(path_mode.."TeamFightBK_mode.png",180,85,930,647)
	img_FriendsYaoQing:SetVisible(0)
	img_FriendsYaoQing:AddImage(path_mode.."Teamfont2_mode.png",35,0,372,52)
	img_FriendsYaoQing:AddImage(path_mode.."Teamfont1_mode.png",497,0,372,52)
	for i=1, 5 do
		img_FriendsYaoQing:AddImage(path_mode.."TeamPlayer_mode.png", 26+15, 55+(105*(i-1)), 343, 112)
		img_FriendsYaoQing:AddImage(path_mode.."TeamPlayer_mode.png", 499+15, 55+(105*(i-1)), 343, 112)
	end
	local btn_button1 = img_FriendsYaoQing:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png",622,583, 179, 56)
	btn_button1:AddFont("确认邀请",18,8,0,0,179,56,0xffffffff)
	local btn_button2 = img_FriendsYaoQing:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png",122,583, 179, 56)
	btn_button2:AddFont("一键加入",18,8,0,0,179,56,0xffffffff)
	local btn_Close = img_FriendsYaoQing:AddButton(path_shop.."close1_rec.png",path_shop.."close2_rec.png",path_shop.."close3_rec.png",889,6,35,35)
	
	-- 滑动条
	img_Image1 = img_FriendsYaoQing:AddImage(path.."toggleBK_main.png",380,80,16,480)
	img_Image2 = img_FriendsYaoQing:AddImage(path.."toggleBK_main.png",852,80,16,480)
	img_Image1:SetVisible(0)
	img_Image2:SetVisible(0)
	
	img_DownPullFrameLaTiao = img_Image1:AddButton(path.."toggleBTN1_main.png",path.."toggleBTN2_main.png",path.."toggleBTN3_main.png",0,0,16,50)
	local ToggleT = img_Image1:AddImage(path.."TD1_main.png",0,-16,16,16)
	local ToggleD = img_Image1:AddImage(path.."TD1_main.png",0,480,16,16)
	XSetWindowFlag(img_DownPullFrameLaTiao.id,1,1,0,430)	-- 设置滚动范围
	img_DownPullFrameLaTiao:ToggleBehaviour(XE_ONUPDATE, 1)	-- 添加消息
	img_DownPullFrameLaTiao:ToggleEvent(XE_ONUPDATE, 1)	-- 添加消息
	
	img_DownPullFrameLaTiao1 = img_Image2:AddButton(path.."toggleBTN1_main.png",path.."toggleBTN2_main.png",path.."toggleBTN3_main.png",0,0,16,50)
	local ToggleT = img_Image2:AddImage(path.."TD1_main.png",0,-16,16,16)
	local ToggleD = img_Image2:AddImage(path.."TD1_main.png",0,480,16,16)
	XSetWindowFlag(img_DownPullFrameLaTiao1.id,1,1,0,430)	-- 设置滚动范围
	img_DownPullFrameLaTiao1:ToggleBehaviour(XE_ONUPDATE, 1)	-- 添加消息
	img_DownPullFrameLaTiao1:ToggleEvent(XE_ONUPDATE, 1)	-- 添加消息
	
	-- 滚动条消息处理Left
	img_DownPullFrameLaTiao.script[XE_ONUPDATE] = function()
		if img_DownPullFrameLaTiao._T == nil then
			img_DownPullFrameLaTiao._T = 0
		end
		
		local curL,curT = XGetWindowClientPosition(img_DownPullFrameLaTiao.id)
		if (img_DownPullFrameLaTiao._T ~= curT) then
			curPer1 = math.floor(430/math.ceil(LeftCount-5))
			curPer1 = math.floor(curT/curPer1)
			
			if Many_Equip1 ~= curPer1 then
				Many_Equip1 = curPer1
				ReBuildInfo()
			end
			img_DownPullFrameLaTiao._T = curT
		end
	end
	
	-- 滚动条消息处理Right
	img_DownPullFrameLaTiao1.script[XE_ONUPDATE] = function()
		if img_DownPullFrameLaTiao1._T == nil then
			img_DownPullFrameLaTiao1._T = 0
		end
		
		local curL,curT = XGetWindowClientPosition(img_DownPullFrameLaTiao1.id)
		if (img_DownPullFrameLaTiao1._T ~= curT) then
			curPer2 = math.floor(430/math.ceil(RightCount-5))
			curPer2 = math.floor(curT/curPer2)
			
			if Many_Equip2 ~= curPer2 then
				Many_Equip2 = curPer2
				ReBuildInfo()
			end
			img_DownPullFrameLaTiao1._T = curT
		end
	end
	
	-- 确定YQAN
	btn_button1.script[XE_LBUP] = function()
		RightCount = 0
		LeftCount = 0
		YaoQingCount = 0
		SelPlayerId = {}
		PopFriendsUI()
		XIsYaoQing()
		for index,value in pairs(img_YaoQingFriends_bg) do
			img_YaoQingFriends_bg[index]:SetVisible(0)
		end
		chatInputEdit_Team:SetVisible(1)
	end
	
	-- 一键加入按钮
	btn_button2.script[XE_LBUP] = function()
		if ( LeftCount > 0) then
			local MaxCount = LeftCount
			for i=1, MaxCount do
				-- log("\nPlayerIdlen = " .. #PlayerId)
				-- log("\ni+Many_Equip1 = " .. i+Many_Equip1)
				XAddYaoQingFriends(PlayerId[1+Many_Equip1])
				if ( LeftCount < 6 ) then
					img_YaoQingFriends_bg[LeftCount]:SetVisible(0)
				end
				
				LeftCount = LeftCount - 1
				RightCount = RightCount + 1
				SelPlayerId[RightCount] = PlayerId[1+Many_Equip1]
				PlayerId = Vector_Remove( PlayerId, 1+Many_Equip1)
				SelYaoQingInfo[RightCount] = YaoQingInfo[1+Many_Equip1]
				YaoQingInfo = Vector_Remove( YaoQingInfo, 1+Many_Equip1)
				SelYaoQingIconPath[RightCount] = YaoQingIconPath[1+Many_Equip1]
				YaoQingIconPath = Vector_Remove( YaoQingIconPath, 1+Many_Equip1)
				
				if ( RightCount < 6) then
					img_YaoQingFriends_bg[RightCount+5]:SetVisible(1)
				end
			end
			ResetScrollList_TeamFight()
			ReBuildInfo()
		end
	end
	
	-- GBAN
	btn_Close.script[XE_LBUP] = function()
		RightCount = 0
		LeftCount = 0
		YaoQingCount = 0
		SelPlayerId = {}
		XIsClearFriendsList()
		PopFriendsUI()
		for index,value in pairs(img_YaoQingFriends_bg) do
			img_YaoQingFriends_bg[index]:SetVisible(0)
		end
		chatInputEdit_Team:SetVisible(1)
	end
	
	InitGameTeamChat(img_TeamFight_bg)
	-- TeamChatBg = img_TeamFight_bg:AddImage(path_mode.."组队聊天底.png", 16, 400, 1024, 256)
	-- TeamChatBg:AddFont("队伍聊天",18,0,277,1,100,20,0xff645E9E)
	
	-- -- 聊天框
	-- chatInputEdit_Team = CreateWindow(wnd.id, 447,656,512,64)
	-- chatInput_Team = chatInputEdit_Team:AddEdit(path_mode.."聊天输入栏.png","","onchatEnter_Team","onLoginTab1111",20,0,10,415,43,0xffffffff,0xff000000,0,"onLBUP")
	-- XEditSetMaxByteLength(chatInput_Team.id,60)
	-- chatInputText_Team = chatInput_Team:AddFont("聊天输入内容后按Enter键发送", 12, 0, 5, 10, 415, 43, 0x303b4a)
	for i = 1, 5 do
		img_YaoQingFriends_bg[i] = img_FriendsYaoQing:AddImage(path_mode.."TeamPlayer_mode.png", 41, 55+(i-1)*105, 343,112)
		img_YaoQingFriends_bg[i]:SetVisible(0)
		font_Name[i] = img_YaoQingFriends_bg[i]:AddFont( "",18,0,112,23,150,20,0xffF9F8FE)
		img_HeadFrame[i] = img_YaoQingFriends_bg[i]:AddImage(path_shop.."iconside_shop.png",17,19,70,70)
		img_Head[i] = img_HeadFrame[i]:AddImage(path_shop.."D_rec.png", 2, 2, 66, 66)
		YQAddBtn[i] = img_YaoQingFriends_bg[i]:AddButton(path_shop.."D_rec.png",path_shop.."D1_rec.png",path_shop.."D2_rec.png",270,38,30,30)
		
		YQAddBtn[i].script[XE_LBUP] = function()
			if ( LeftCount > 0) then
				-- log("\nPlayerIdlen = " .. #PlayerId)
				-- log("\ni+Many_Equip1 = " .. i+Many_Equip1)
				XAddYaoQingFriends(PlayerId[i+Many_Equip1])
				if ( LeftCount < 6 ) then
					img_YaoQingFriends_bg[LeftCount]:SetVisible(0)
				end
				
				-- img_YaoQingFriends_bg[i]:SetPosition(514, RightCount*105+55)
				LeftCount = LeftCount - 1
				RightCount = RightCount + 1
				SelPlayerId[RightCount] = PlayerId[i+Many_Equip1]
				PlayerId = Vector_Remove( PlayerId, i+Many_Equip1)
				SelYaoQingInfo[RightCount] = YaoQingInfo[i+Many_Equip1]
				YaoQingInfo = Vector_Remove( YaoQingInfo, i+Many_Equip1)
				SelYaoQingIconPath[RightCount] = YaoQingIconPath[i+Many_Equip1]
				YaoQingIconPath = Vector_Remove( YaoQingIconPath, i+Many_Equip1)
				
				if ( RightCount < 6) then
					img_YaoQingFriends_bg[RightCount+5]:SetVisible(1)
				end
				ResetScrollList_TeamFight()
				
				-- 重新刷新数据
				ReBuildInfo()
			end
		end
	end
	
	for i=1, 5 do
		img_YaoQingFriends_bg[i+5] = img_FriendsYaoQing:AddImage(path_mode.."TeamPlayer_mode.png", 514, 55+(i-1)*105, 343,112)
		img_YaoQingFriends_bg[i+5]:SetVisible(0)
		font_Name[i+5] = img_YaoQingFriends_bg[i+5]:AddFont( "",18,0,112,23,150,20,0xffF9F8FE)
		img_HeadFrame[i+5] = img_YaoQingFriends_bg[i+5]:AddImage(path_shop.."iconside_shop.png",17,19,70,70)
		img_Head[i+5] = img_HeadFrame[i+5]:AddImage(path_shop.."D_rec.png", 2, 2, 66, 66)
		YQSubBtn[i] = img_YaoQingFriends_bg[i+5]:AddButton(path_shop.."P_rec.png",path_shop.."P1_rec.png",path_shop.."P2_rec.png",270,38,30,30)
		
		YQSubBtn[i].script[XE_LBUP] = function()
			if ( RightCount > 0) then
				-- log("\nSelPlayerId = " .. #SelPlayerId)
				-- log("\ni+Many_Equip2 = " .. i+Many_Equip2)
				XIsDelFriends(SelPlayerId[i+Many_Equip2])
				
				PlayerId[#PlayerId+1] = SelPlayerId[i+Many_Equip2]
				SelPlayerId = Vector_Remove( SelPlayerId, i+Many_Equip2)
				YaoQingInfo[#YaoQingInfo+1] = SelYaoQingInfo[i+Many_Equip2]
				SelYaoQingInfo = Vector_Remove( SelYaoQingInfo, i+Many_Equip2)
				YaoQingIconPath[#YaoQingIconPath+1] = SelYaoQingIconPath[i+Many_Equip2]
				SelYaoQingIconPath = Vector_Remove( SelYaoQingIconPath, i+Many_Equip2)
				
				if ( RightCount < 6 ) then
					img_YaoQingFriends_bg[RightCount+5]:SetVisible(0)
				end
				-- img_YaoQingFriends_bg[i+5]:SetPosition(41, LeftCount*105+55)
				LeftCount = LeftCount + 1
				RightCount = RightCount - 1
				if ( LeftCount < 6) then
					img_YaoQingFriends_bg[LeftCount]:SetVisible(1)
				end
				ResetScrollList_TeamFight()
				ReBuildInfo()
			end
		end
	end
	
	img_TeamFight_bg:AddFont( "七人组队所有成员必须大于等于30级", 15, 0, 15, 370, 500, 20, 0x7f94fd)
end

-- 开始游戏成功，隐藏组队UI并弹出大厅
function StartGameSuccess()
	--清空聊天框中的内容
	ClearChatStringandChatInfo()
	--关闭当前界面
	g_GameTeamFight_ui:SetVisible(0)
	ClearGameTeamChat()

	g_game_fight_ui:SetVisible(0)
	img_SOLObk:SetVisible(0)
end

-- 弹出组队界面UI
function PopTeamFightUI()
	SetGameHallIsVisible(1)				--退回大厅界面
	XGameTeamFight(Team_type)
	g_GameTeamFight_ui:SetVisible(1)
	RightCount = 0
	LeftCount = 0
end

-- 得到组队界面UI是否隐藏
function TeamFightIsOpen()
	local b
	if (g_GameTeamFight_ui:IsVisible()) then
		b = 1
	else
		b = 0
	end
	XGetIsInTeamRoom(b)
end

-- 设置组对界面UI是否可见
function SetTeamFightVisible(b,Type)
	g_GameTeamFight_ui:SetVisible(b)
	Team_type = Type
end

-- 得到队伍中所有成员的信息(玩家名字, 是不是队长, 索引)
function GetIsLeader(b)
	IsLeader = b
	if (IsLeader == 1) then
		-- XGetIsLeader(IsLeader)
		LeaderFlag:SetPosition(818, 52)
		
		for i,value in pairs(btn_Team_n) do
			btn_Team_n[i]:SetEnabled(1)
		end
		
		for i=1, 6 do
			btn_AddFriend_n[i]:SetVisible(0)
		end
	
		btn_HaoJiaoYaoQing:SetEnabled(0)
		btn_YiJianYaoQing:SetEnabled(1)
		btn_StartGame:SetEnabled(1)
		BigBtn_Font1:SetFontText("解散队伍", 0xffB5A9D7)
		for num = 1,6 do
			btn_Out_n[num]:SetEnabled(1)
		end
		btn_Out_n[1]:SetVisible(1)
	else
		LeaderFlag:SetPosition(260,52)

		for j,val in pairs(btn_Team_n) do
			btn_Team_n[j]:SetEnabled(0)
		end
		for i=1, 6 do
			btn_AddFriend_n[i]:SetVisible(1)
		end
		btn_AddFriend_n[1]:SetVisible(0)
	
		btn_HaoJiaoYaoQing:SetEnabled(0)
		btn_YiJianYaoQing:SetEnabled(0)
		btn_StartGame:SetEnabled(0)
		BigBtn_Font1:SetFontText("退出队伍", 0xffB5A9D7)
		for num = 1,6 do
			btn_Out_n[num]:SetEnabled(0)
		end
		btn_Out_n[1]:SetVisible(0)
	end
end

-- 得到自己在队伍中的信息
function GetMyselfInfo(name, index, lv, win, lose, Cindex)
	MyName = name
	PlayerName[index]:SetFontText(name, 0xffF9F8FE)
	local All = win + lose
	PlayerName_Info[index]:SetFontText("等级："..lv.."\n胜场："..win.."/"..All, 0xffB5A9D7)
	if (index ~= 1) then
		PlayerNameFont[index-1] = name
		PlayerInfo_TeamFight[index]:SetVisible(0)
		PlayerInfo_bg[index-1]:SetVisible(1)
	else
		MySelfIndex = Cindex
	end
	if (PlayerHead[index] == nil) then
		PlayerHead[index] = PlayerHead_bg[index]:AddImage(path_equip.."bag_equip.png", 2, 2, 66, 66)
		Punish[index] = PlayerHead[index]:AddImage(path.."punish1_hall.png",47,48,16,16)
		Punish_tip[index] = PlayerHead[index]:AddImage(path.."chatBK_hall.png",47,48,16,16)
		Punish_tip[index]:SetTransparent(0)
		Punish_tip[index]:SetVisible(0)
		Punish[index]:SetVisible(0)
	end
end

-- 设置头像
function SetSummonerHead(namepath, index)
	if PlayerHead[index] ~= nil then
		local sStart, sEnd = string.find(namepath, "U")
		if sStart == 1 then
			PlayerHead[index].changeimage("..\\"..namepath)
		elseif sStart == 2 then
			PlayerHead[index].changeimage(".."..namepath)
		else
			PlayerHead[index].changeimage("..\\U"..namepath)
		end
	end
end

-- 设置玩家游戏惩罚
function SetTeamPunish(index,IsPunish,tip)
--log("\n index = "..index.."  IsPunish = "..IsPunish.."  tip = "..tip)
	if IsPunish == 1 then
		Punish[index]:SetVisible(1)
		Punish_tip[index]:SetImageTip(tip)
		Punish_tip[index]:SetVisible(1)
	else	
		Punish[index]:SetVisible(0)
		Punish_tip[index]:SetVisible(0)
	end	
end

-- 清空当前位置的玩家信息
function CleanPlayInfo(index)
	PlayerInfo_TeamFight[index+1]:SetVisible(1)
	PlayerInfo_bg[index]:SetVisible(0)
	PlayerNameFont[index] = nil
	YaoQingCount = 0
end

-- 每次创建成功队伍都要重置一遍UI的状态
function ReDrawUi(IsShow)
	YaoQingCount = 0
	for i = 1,7 do
		if (PlayerNameFont[i] ~= nil) then
			PlayerNameFont[i] = nil
		end
	end
	if (IsShow ~= nil or IsShow ~= 0) then
		g_GameTeamFight_ui:SetVisible(1)
		SetGameHallIsVisible(1)
	end
	if G_login_ui ~= nil then
		for i=1, #PlayerInfo_bg do
			PlayerInfo_bg[i]:SetVisible(0)
		end
		
		for i=1, #PlayerInfo_TeamFight do
			PlayerInfo_TeamFight[i]:SetVisible(1)
		end
		LeaderFlag:SetPosition(818,52)
		for i,values in pairs(btn_Team_n) do
			btn_Team_n[i]:SetEnabled(1)
		end
		btn_HaoJiaoYaoQing:SetEnabled(1)
		btn_YiJianYaoQing:SetEnabled(1)
		btn_StartGame:SetEnabled(1)
	
		BigBtn_Font1:SetFontText("解散队伍", 0xffB5A9D7)
		RightCount = 0
		LeftCount = 0
	end
end

-- 重新调用InitGameTeamFight_ui
function ReInitGameTeamFight_ui()
	InitGameTeamFight_ui(g_game_fight_ui,1)	-- 组队界面UI
end

-- 全部清除UI界面 -- 暂时保留不用
function ReleaseTeamFightUI()
	if img_TeamFight_bg ~= nil then
		img_TeamFight_bg:Release()
		img_TeamFight_bg = nil
	end
	if btn_JieSanDuiWu ~= nil then
		btn_JieSanDuiWu:Release()
		btn_JieSanDuiWu = nil
	end
	if btn_StartGame ~= nil then
		btn_StartGame:Release()
		btn_StartGame = nil
	end
	if btn_HaoJiaoYaoQing ~= nil then
		btn_HaoJiaoYaoQing:Release()
		btn_HaoJiaoYaoQing = nil
	end
	if btn_YiJianYaoQing ~= nil then
		btn_YiJianYaoQing:Release()
		btn_YiJianYaoQing = nil
	end

	if LeaderFlag ~= nil then
		LeaderFlag:Release()
		LeaderFlag = nil
	end
	
	--清除表
	for index,value in pairs(PlayerInfo_TeamFight) do
		PlayerInfo_TeamFight[index]:Release()
		PlayerInfo_TeamFight[index] = nil
	end
	for index,value in pairs(btn_Team_n) do
		btn_Team_n[index]:Release()
		btn_Team_n[index] = nil
	end
	for index,value in pairs(btn_AddFriend_n) do
		btn_AddFriend_n[index]:Release()
		btn_AddFriend_n[index] = nil
	end
	for index,value in pairs(btn_Out_n) do
		btn_Out_n[index]:Release()
		btn_Out_n[index] = nil
	end
	for index,value in pairs(PlayerName) do
		PlayerName[index]:Release()
		PlayerName[index] = nil
	end
	for index,value in pairs(PlayerInfo_bg) do
		PlayerInfo_bg[index]:Release()
		PlayerInfo_bg[index] = nil
	end
	
	ClearGameTeamChat()
end

-- 弹出邀请UI
function PopFriendsUI()
	if (img_FriendsYaoQing:IsVisible()) then
		img_FriendsYaoQing:SetVisible(0)
		img_TeamFight_bg:SetVisible(1)
		if (LeftCount < 5) then
			img_Image1:SetVisible(0)
		else
			img_Image1:SetVisible(1)
		end
		if (RightCount < 5) then
			img_Image2:SetVisible(0)
		else
			img_Image2:SetVisible(1)
		end
	else
		XIsClearFriendsList()
		img_FriendsYaoQing:SetVisible(1)
		img_TeamFight_bg:SetVisible(0)
	end
end

-- 得到可以邀请的玩家信息
function GetYaoQingFriendsInfo(name, IconPath, index, Cplayerid)
	for i = 1,7 do
		if (PlayerNameFont[i] ~= nil and PlayerNameFont[i] == name) then
			-- 已经邀请进入的玩家不需要再显示
			return
		end
	end
	YaoQingInfo[YaoQingCount+1] = name
	PlayerId[YaoQingCount+1] = Cplayerid
	-- log("\nPlayerId = "..Cplayerid)
	
	local sStart, sEnd = string.find(IconPath, "U")
	if sStart == 1 then
		IconPath = "..\\"..IconPath
	elseif sStart == 2 then
		IconPath = ".."..IconPath
	else
		IconPath = "..\\U"..IconPath
	end
	
	YaoQingIconPath[YaoQingCount+1] = IconPath
	YaoQingCount = YaoQingCount + 1
	LeftCount = YaoQingCount
	-- log("\nYaoQingCount = " .. YaoQingCount)
end

-- 创建组队邀请玩家信息的背景按钮
function CreateYaoQingBtn()
	return ReBuildInfo()
end

function ReBuildInfo()
	if ( YaoQingCount > 0) then
		-- 根据当前显示的个数判断是否显示滑动条
		if LeftCount > 5 then
			img_Image1:SetVisible(1)
			for i = 1, 5 do
				img_YaoQingFriends_bg[i]:SetVisible(1)
			end
		else
			img_Image1:SetVisible(0)
			if LeftCount > 0 then
				for i = 1, LeftCount do
					img_YaoQingFriends_bg[i]:SetVisible(1)
				end
			end
		end
		
		if RightCount > 5 then
			img_Image2:SetVisible(1)
			for i = 1, 5 do
				img_YaoQingFriends_bg[i+5]:SetVisible(1)
			end
		else
			img_Image2:SetVisible(0)
			if RightCount > 0 then
				for i = 1, RightCount do
					img_YaoQingFriends_bg[i+5]:SetVisible(1)
				end
			end
		end
		
		for i=1, 5 do
			if YaoQingInfo[i+Many_Equip1] ~= nil then
				font_Name[i]:SetFontText( YaoQingInfo[i+Many_Equip1], 0xffF9F8FE)
				img_Head[i].changeimage( YaoQingIconPath[i+Many_Equip1])
			end
		end
		
		for i=1, 5 do
			if SelYaoQingInfo[i+Many_Equip2] ~= nil then
				font_Name[i+5]:SetFontText( SelYaoQingInfo[i+Many_Equip2], 0xffF9F8FE)
				img_Head[i+5].changeimage( SelYaoQingIconPath[i+Many_Equip2])
			end
		end
	end
end

function GetHeadImgPath(str)
	local path_Head = str
	PlayerInfo_TeamFight[1]:AddImage("../"..path_Head,2,2,66,66)
	--log("../"..str)
end

-- 聊天输入栏按Enter键发送函数到C++
function onchatEnter_Team()
	local msg = chatInput_Team:GetEdit()
	XChatInputChangeChannel(8)
	XChatSendMsg(chatInput_Team.id)
	chatInput_Team:SetEdit("")
end

-- 得到聊天内容并发在聊天框内
function GetChatInfo(str)
	-- 如果ChatInfo为空则，创建一个Font并且索引赋值为1
	if (ChatInfo == nil or ChatString[1] == nil) then
		ChatString[1] = str
		if (ChatInfo ~= nil) then
			ChatInfo:Release()
			ChatInfo = nil
		end
		ChatInfo = TeamChatBg:AddFont(str,18,0,3,144,662,139,0xff645E9E)
		CurChatListCount = 1
	else
		-- 先把索引+1
		CurChatListCount = CurChatListCount + 1
		-- 如果索引小于6(一个Eidit最多6)，则把文本框位置上移
		if (CurChatListCount <= 6) then
			local x,y = ChatInfo:GetPosition()
			local x1,y1 = TeamChatBg:GetPosition()
			ChatInfo:SetPosition(x - x1, y - y1 - 22)
		end
		-- 如果文本框中的信息满了，则清空最上面的一条信息
		local count = 1
		if (CurChatListCount > 6) then
			while (true) do
				if (ChatString[count] == nil) then
					CurChatListCount = 6
					break
				end
				ChatString[count] = ChatString[count + 1]
				count = count + 1
			end
		end
		-- 把新收到的信息添加进文本框
		ChatString[CurChatListCount] = str
		-- 通过While链接所有字符然后添加进ChatInfo
		local s_1 = nil
		local count1 = 1
		while (true) do
			if (ChatString[count1] == nil) then
				break
			end
			if (s_1 == nil) then
				s_1 = ChatString[count1]
			else
				s_1 = s_1..ChatString[count1]
			end
			count1 = count1 + 1
		end
		ChatInfo:SetFontText(s_1,0xff645E9E)
	end
end

-- 清空聊天空里的内容
function ClearChatStringandChatInfo()
	if (ChatInfo ~= nil) then
		ChatInfo:SetFontText("",0xffffffff)
		ChatInfo:SetPosition(3,144)
		chatInput_Team:SetEdit("")
		for index,value in pairs(ChatString) do
			ChatString[index] = nil
		end
		ReDrawUi()
	end
end

-- 点击聊天输入框
function onLBUP()
	chatInputText_Team:SetVisible(0)
end

-- 重绘聊天输入框中的提示内容
function ReDrawFont()
	if (chatInputText_Team ~= nil) then
		chatInput_Team:SetEdit("")
		chatInputText_Team:SetVisible(1)
	end
end

-- 得到玩家离开房间的信息
function GetLeavePlayerText(str)
	local sss = "玩家["..str.."]离开了房间\n"
	GetChatInfo(sss)
end

-- 得到玩家进入房间的信息
function GetEnterPlayerText(str)
	local sss = "玩家["..str.."]进入了房间\n"
	GetChatInfo(sss)
end

function ReturnGameHall()
	--退回大厅界面
	SetGameHallIsVisible(1)
	g_game_fight_ui:SetVisible(0)
	img_SOLObk:SetVisible(0)
end

function ChangeTeamTypeName(cName)
	TeamTypeName:SetFontText(cName, 0xffffff)
end

function SetTeamFightIsVisible(flag)
	if g_GameTeamFight_ui ~= nil then
		if flag == 1 and g_GameTeamFight_ui:IsVisible() == false then
			g_GameTeamFight_ui:SetVisible(1)
		elseif flag ==0 and g_GameTeamFight_ui:IsVisible() == true then 
			g_GameTeamFight_ui:SetVisible(0)
			ClearGameTeamChat()
			XQuitTeam()
			RightCount = 0
			LeftCount = 0
		end
	end
end
function GetTeamFightIsVisible()
	if g_GameTeamFight_ui~=nil and g_GameTeamFight_ui:IsVisible() == true then
		return 1
	else
		return 0
	end
end

function ResetScrollList_TeamFight()
	-- 让控件和滚动条保持一致
	-- if Many_Equip ~= Many then
	Many_Equip1 = 0
	curPer1 = 0
	img_DownPullFrameLaTiao:SetPosition(0,0)
	img_DownPullFrameLaTiao._T = 0
	
	Many_Equip2 = 0
	curPer2 = 0
	img_DownPullFrameLaTiao1:SetPosition(0,0)
	img_DownPullFrameLaTiao1._T = 0
end