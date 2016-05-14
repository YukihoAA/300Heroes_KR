include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

include("../Data/Script/game_mail_goal_active.lua")
include("../Data/Script/game_shop_hero_equip.lua")
include("../Data/Script/game_setup_friend.lua")

--选区界面
local RotationSpeed = 2

local IdList = {}
local IdList_Font = {}
local img_SelList = {}

local uiedi1 = nil
local uiedi2 = nil
local DownList_Str_Info = {}	-- 下拉列表框内的字符串信息
local IsOut = 0
local IsLock = 0

userinput = nil
passinput = nil

palyerid = nil
password = nil

local num = 1
local b = true
local Height = 0

local remember_user_sign = nil

local ServerListName = {}		-- 服务器链表的名字
local ServerListPing = {}		-- 服务器链表的Ping值
local ServerListPathName = {}

local DangQianXuanZe = nil
local ServerPing = nil
local FatherCheck = nil

-- 当前界面相关成员
local ServerList_Bg = {}		-- Login界面相关背景图片
local img_ServerImageBG_1,img_ServerImageBG_1R,img_ServerImageBG_1E,img_ServerImageBG_1H = nil	-- 电信大区背景窗口，会转的图片，服务器头像
local img_ServerImageBG_2,img_ServerImageBG_2R,img_ServerImageBG_2E,img_ServerImageBG_2H = nil	-- 网通大区背景图片

local img_DianXinTuiJian = nil	-- 文字图片电信推荐
local img_WangTongTuiJian = nil	-- 文字图片网通推荐
local img_DangQianXuanZe = nil	-- 当前选择
local img_DangQianXuanZeF = nil	-- 当前选择的服务器名字
local img_ShangCiDengLu = nil	-- 上次登录
local img_ShangCiDengLuF = nil	-- 上次登录的服务器名字
--local img_StartGameUnenable = nil 	-- 开始游戏按钮禁用状态
local btn_EnterGame = nil
local img_DownPullFrameBg = nil

--------测试
-- local chatInputEdit = nil
-- local chatInput = nil
-- local chatInputText = nil

local ServerList = {}		-- 服务器链表
ServerList.posx = {}	-- 服务器链表X坐标
ServerList.posy = {}	-- 服务器链表Y坐标

local img_ServerLabel_1 = {}
local img_ServerLabel_2 = nil
local ServerList_Ping = {}

local DianXinTuiJianIndex = 0
local WangTongTuiJianIndex = 0
local LastEnterServerImg = nil
local LastEnterServerindex = 0
local DianXinNewServerIndex = 1
local WangTongNewServerIndex = 1

local btn = nil
local pic,pic2,pic3,pic4 = nil
local ServerListIsOpen = false
local BK3_login = nil

function Initserver_selectionUI(wnd, bisopen)

	g_server_selection_ui = CreateWindow(wnd.id, 0, 0, 1280, 800)
	InitStaticserver_selectionUI(g_server_selection_ui)
	g_server_selection_ui:SetVisible(bisopen)
	if bisopen ==1 then
		local index = 0
		g_server_selection_ui:SetTimer(0,50).Timer = function(timer)
			index = index+1
			XSetWindowRotation(img_ServerImageBG_1R.id, index*RotationSpeed*3.14/180)
			XSetWindowRotation(img_ServerImageBG_2R.id, index*RotationSpeed*3.14/180)	
		end
	end
	-- btn = wnd:AddButton(path_setup.."btn1_mail.png",path_setup.."btn2_mail.png",path_setup.."btn3_mail.png",0,100,100,32)
	-- pic = wnd:AddImage(path_setup.."btn3_mail.png",150,100,100,32)
	-- pic2 = wnd:AddImage(path_setup.."btn3_mail.png",150,200,100,32)
	-- pic3 = wnd:AddImage(path_setup.."btn3_mail.png",1000,100,100,32)
	-- pic4 = wnd:AddImage(path_setup.."btn3_mail.png",1000,200,100,32)
	-- btn.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
	
		-- pic:MoveTo(150,100,1000,100,10)
		-- pic2:MoveTo(150,200,1000,200,5)
		-- pic3:MoveTo(1000,100,150,100,10)
		-- pic4:MoveTo(1000,200,150,200,5)
	-- end
end
function InitStaticserver_selectionUI(wnd)

	wnd:AddImage(path_login.."BK1_login.png",0,0,1280,800)
	BK3_login = wnd:AddImage(path_login.."BK3_login.png", 0, 175, 846, 499)
	--BK3_login:EnableImageAnimate(1, 9)
	
	ServerList_Bg[1] = wnd:AddImage(path_login.."BK2_login.png",0,0,792,720)
	
	ServerList_Bg[2] = wnd:AddImage(path_server.."wangtong_server.png",86,175,179,38)
	
	ServerList_Bg[3] = wnd:AddImage(path_server.."dianxin_server.png",0,280,179,38)
	
	ServerList_Bg[4] = wnd:AddImage(path_server.."dianxin_server.png",0,0,0,0)
	ServerList_Bg[4]:SetTransparent(0)
	
	LastEnterServerImg = ServerList_Bg[4]:AddImage(path_server.."smallLatest_server.png",-900,-900,100,23)
	LastEnterServerImg:SetTouchEnabled(0)
	DangQianXuanZe = ServerList_Bg[4]:AddImage(path_server.."mychose_server.png",-900,-900,100,23)
	DangQianXuanZe:SetTouchEnabled(0)
	
	ServerList_Bg[5] = wnd:AddImage(path_server.."tu1.png", 10, 650, 256, 32)
	
	ServerPing = wnd:AddFont("网络良好",15,0,980 - 48,300,200,15,0x00ff00)
	
	ServerPing:SetVisible(0)
	for i = 1,#ServerList_Bg do
		ServerList_Bg[i]:SetVisible(0)
	end

	local btn_300HeroLogo = wnd:AddButton(path_login.."300logo_login.png",path_login.."300logo1_login.png",path_login.."300logo_login.png",5,1,168,73)
	local btn_GuanFangWangZhan = wnd:AddButton(path_login.."GM1_login.png",path_login.."GM2_login.png",path_login.."GM3_login.png",500,10,93,32)
	local btn_ZhangHaoZhuCe = wnd:AddButton(path_login.."GM4_login.png",path_login.."GM5_login.png",path_login.."GM6_login.png",610,10,93,32)
	local btn_XinShouLiBao = wnd:AddButton(path_login.."GM7_login.png",path_login.."GM8_login.png",path_login.."GM9_login.png",713,10,93,32)
	local btn_KeFuZhongXin = wnd:AddButton(path_login.."GM10_login.png",path_login.."GM11_login.png",path_login.."GM12_login.png",813,10,93,32)
	local btn_HuoDongZhuanQu = wnd:AddButton(path_login.."GM13_login.png",path_login.."GM14_login.png",path_login.."GM15_login.png",913,10,93,32)
	local btn_ZhangHuChongZhi = wnd:AddButton(path_login.."GM16_login.png",path_login.."GM17_login.png",path_login.."GM18_login.png",1013,10,93,32)
	
	img_ServerImageBG_1 = CreateWindow(wnd.id,792,100,200,200)
	
	img_ServerImageBG_1R = img_ServerImageBG_1:AddImage(path_server.."List/DJSY_R.png",0,0,200,200)
	img_ServerImageBG_1E = img_ServerImageBG_1:AddEffect("..\\Data\\Magic\\Common\\UI\\daqu\\daquxuanze\\tx_UI_daqu_dianxin_01.x",0,0,1280,800)
	XSetEffectPos(img_ServerImageBG_1E.id,-76,0)
	img_ServerImageBG_1H = img_ServerImageBG_1:AddImage(path_server.."List/DJSY.png",0,0,200,200)
	
	img_ServerImageBG_2 = CreateWindow(wnd.id,1012,100,200,200)
	
	img_ServerImageBG_2R = img_ServerImageBG_2:AddImage(path_server.."List/JDLY_R.png",0,0,200,200)
	img_ServerImageBG_2E = img_ServerImageBG_2:AddEffect("..\\Data\\Magic\\Common\\UI\\daqu\\daquxuanze\\tx_UI_daqu_wangtu_01.x",0,0,1280,800)
	XSetEffectPos(img_ServerImageBG_2E.id,144,0)
	img_ServerImageBG_2H = img_ServerImageBG_2:AddImage(path_server.."List/JDLY.png",0,0,200,200)
	
	local btn_ServerList = wnd:AddButton(path_login.."serverlist1_login.png",path_login.."serverlist2_login.png",path_login.."serverlist3_login.png",655,109,190,48)
	
	img_DianXinTuiJian = wnd:AddImage(path_login.."dianxinAD_login.png",843 - 48,330 - 18,174,42)
	img_WangTongTuiJian = wnd:AddImage(path_login.."wangtongAD_login.png",1065 - 48,330 - 18,174,42)
	img_DianXinTuiJian:AddFont("网络良好",15,0,55,-20,500,15,0xff00ff00)
	img_WangTongTuiJian:AddFont("网络良好",15,0,55,-20,500,15,0xff00ff00)
	img_DangQianXuanZe = wnd:AddImage(path_server.."currentChoice_server.png",920 - 48,350 - 18,128,32)
	img_DangQianXuanZeF = img_DangQianXuanZe:AddFont(":",18,0,80,-5,200,20,0xffffffff)
	img_DangQianXuanZe:SetVisible(0)
	img_ShangCiDengLu = wnd:AddImage(path_server.."latestChoice_server.png",920 - 48,350 - 18,128,32)
	img_ShangCiDengLuF = img_ShangCiDengLu:AddFont(":",18,0,80,-5,200,20,0xffffffff)
	img_ShangCiDengLu:SetVisible(0)
	
	FatherCheck = CreateWindow(wnd.id, 0, 0, 0, 0)
	-- 用户名
	local img_Id = FatherCheck:AddImage(path_login.."account_login.png",785 - 117,400 - 44,512,64)
	img_Id:AddFont("账号",18,0,29,6,500,20,0xffffffff)
	uiedi1 = CreateWindow(FatherCheck.id,910 - 117,405 - 44,260,40)
	userinput = uiedi1:AddEdit(path_login.."passwordEdit_login.png","","onEnterGame","onLoginTab",18,0,0,260,30,0xffffffff,0xff000000,0,"onLBUP")
	userinput:SetTransparent(0)
	XEditSetMaxByteLength(userinput.id,36)
	XEditInclude(userinput.id,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_-.@")
	-- 密码	
	local img_Pass = FatherCheck:AddImage(path_login.."account_login.png",765 - 133,450 - 47,512,64)
	img_Pass:AddFont("密码",18,0,29,6,500,20,0xffffffff)
	uiedi2 = CreateWindow(FatherCheck.id,880 - 133,455 - 47,330,40)
	passinput = uiedi2:AddEdit(path_login.."passwordEdit_login.png","","onEnterGame","onLoginTab",18,0,0,330,30,0xffffffff,0xff000000,1,"onLBUP")
	passinput:SetTransparent(0)
	XEditSetMaxByteLength(passinput.id,100)
	--XEditInclude(passinput.id,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_")
	
	-- 记住账户
	local remember_user = FatherCheck:AddImage(path_login.."checkbox_login.png",772 - 80,500 - 52,64,32)
	remember_user:SetTouchEnabled(1)
	remember_user_sign = remember_user:AddImage(path_login.."checkboxhave_login.png",13,-2,32,32)		-- 暂定为全局的变量
	remember_user_sign:SetTouchEnabled(0)
	remember_user:AddFont("记住账号",15,0,40,0,500,20,0xffffffff)

	-- 以下是按钮的处理
	
	-- 300英雄LOGO
	btn_300HeroLogo.script[XE_LBUP] = function()
		XClickPlaySound(5)
		--XGameSigninToWebsite(1)
		
	end
	
	-- 官方网站
	btn_GuanFangWangZhan.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGameSigninToWebsite(1)
	end
	
	-- 账号注册
	btn_ZhangHaoZhuCe.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGameSigninToRegistId(1)
	end
	-- 新手礼包
	btn_XinShouLiBao.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGameSigninToGift(1)
	end
	
	-- 客服中心
	btn_KeFuZhongXin.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGameSigninToServerCenter(1)
	end
	
	-- 活动专区
	btn_HuoDongZhuanQu.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGameSigninToActiveCenter(1)
	end
	
	-- 账户充值
	btn_ZhangHuChongZhi.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGameSigninToAddMoney(0)
	end
	
	-- 服务器列表开关按钮
	btn_ServerList.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if (ServerListIsOpen) then
			ServerListIsOpen = false
			BK3_login:SetVisible(1)
		else
			ServerListIsOpen = true
			BK3_login:SetVisible(0)
		end
		for i = 1, #ServerList_Bg do
			if (ServerListIsOpen == true) then
				ServerList_Bg[i]:SetVisible(1)
			else
				ServerList_Bg[i]:SetVisible(0)
			end
		end
	end
	
	-- 电信推荐大区点击事件的处理，从未选过服务器的玩家
	img_ServerImageBG_1H.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if img_ServerImageBG_1:IsVisible() and img_ServerImageBG_2:IsVisible() then
			-- log("\nDianXinTuiJianIndex = "..DianXinTuiJianIndex)
			ClickServerPic_TuiJian(DianXinTuiJianIndex)
		end
	end
	
	-- 网通推荐大区点击事件的处理，从未选过服务器的玩家
	img_ServerImageBG_2H.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if img_ServerImageBG_1:IsVisible() and img_ServerImageBG_2:IsVisible() then
			-- log("\nWangTongTuiJianIndex = "..WangTongTuiJianIndex)
			ClickServerPic_TuiJian(WangTongTuiJianIndex)
		end
	end

	-- 登陆游戏
	btn_EnterGame = wnd:AddButton(path_login.."Enter1_login.png",path_login.."Enter2_login.png",path_login.."Enter3_login.png",745,500,325,79)
	btn_EnterGame.script[XE_LBUP] = function()
		XClickPlaySound(5)
		onEnter()
	end
	
	-- 记住账户
	remember_user.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if (remember_user_sign:IsVisible()) then
			remember_user_sign:SetVisible(0)
		else
			remember_user_sign:SetVisible(1)
		end
	end
	
	-- 忘记密码
	local img_forgetPass = FatherCheck:AddButton(path_login.."password1_login.png",path_login.."password2_login.png",path_login.."password3_login.png",1010 - 96,500 - 56,137,35)
	img_forgetPass.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGameSigninforgetPassword(1)
	end
	
	-- 账户下拉列表框窗口
	local img_DownPullFrame = img_Id:AddImage(path_login.."closeBK_login.png",390,14,32,32)
	img_DownPullFrame:SetTouchEnabled(1)
	img_DownPullFrame:SetTransparent(0)
	local img_DownPullFrame_1 = img_DownPullFrame:AddImage(path_login.."accountList_login.png",0,0,32,16)
	img_DownPullFrame_1:SetTouchEnabled(0)
	img_DownPullFrameBg = wnd:AddImage(path_login.."accountListBK_login.png",867 - 117,438 - 44,332,82)
	img_DownPullFrameBg:SetVisible(0)
	
	-- 下拉小三角的点击事件处理
	img_DownPullFrame.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if (img_DownPullFrameBg:IsVisible()) then
			img_DownPullFrameBg:SetVisible(0)
		else
			XClickDownList_PlayerId()
			img_DownPullFrameBg:SetVisible(1)
			CreateButtonById(img_DownPullFrameBg)
		end
	end
	
	-- 缩小按钮
	local btn_min = wnd:AddButton(path_login.."small1_login.png",path_login.."small2_login.png",path_login.."small3_login.png",1209,5,32,32)
	btn_min.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGameSmallWindow(1)
	end
	
	-- 关闭按钮
	local btn_close = wnd:AddButton(path_login.."close1_login.png",path_login.."close2_login.png",path_login.."close3_login.png",1237,5,32,32)
	btn_close.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGameCloseWindow(1)
	end
	
	-- local a = wnd:AddImageMultiple("..\\UI\\Icon\\Restore\\lianjin_fachuan.dds", "..\\UI\\Icon\\Restore\\lianjin_suizhi.dds", "..\\UI\\Icon\\Restore\\lianjin_kuang2.dds", 200, 200, 64, 64)
	-- local b = true
	-- a.script[XE_LBUP] = function()
		-- if b then
			-- b = false
			-- a.changeimage("..\\UI\\Icon\\Restore\\lianjin_fakang.dds", "..\\UI\\Icon\\Restore\\lianjin_rongye.dds", "..\\UI\\Icon\\Restore\\lianjin_kuang1.dds")
		-- else
			-- b = true
			-- a.changeimage("..\\UI\\Icon\\Restore\\lianjin_fachuan.dds", "..\\UI\\Icon\\Restore\\lianjin_suizhi.dds", "..\\UI\\Icon\\Restore\\lianjin_kuang2.dds")
		-- end
	-- end
	
	img_ServerLabel_2 = wnd:AddImage(path_login.."newServer_login.png",134+887,13+100,64,64)
end


-- 回车登陆游戏
function onEnterGame()	
	btn_EnterGame:TriggerBehaviour(XE_LBUP)
end
function onEnter()
	if g_server_selection_ui ~=nil and g_server_selection_ui:IsVisible() then
		-- btn_EnterGame:SetEnabled(0)
		if (remember_user_sign:IsVisible()) then
			XGameSigninRememberId(1)
		else
			XGameSigninRememberId(0)
		end
		XGameSigninId(userinput.id)
		XGameSigninPassword(passinput.id)
		XGameSigninLoginGame()
	else
		-- log("\nonEnter   0")
	end
end

-- Tab键响应
local tabFocus = 1;
function  onLoginTab()
	tabFocus = tabFocus + 1;
	if tabFocus%2 == 0 then
		XWindowFocus(passinput.id)
	else
		XWindowFocus(userinput.id)
	end
end

-- C++传来上次登录数据，是否记住账户
function ShowRemberID(str_ID)
	if IsLock==0 then
		if str_ID == "" then
			remember_user_sign:SetVisible(0)
		else
			userinput:SetEdit(str_ID)
			remember_user_sign:SetVisible(1)
		end
	end
end

-- 账户下拉列表
function GetDownListStrInfo(s)
	DownList_Str_Info = {}
	DownList_Str_Info = PartitionString(s,",")
end

function GetServerListStrName(str, cstr, i,Ping)
	-- log("\n"..str)
	-- log("\n"..cstr)
	-- log("\n"..Ping)
	-- log("\n"..i)
	ServerListName[i] = str
	ServerListPathName[i] = cstr
	ServerListPing[i] = Ping
end

--获得服务器数量
function GetServerListCount(num)
	local ServerListCount = num
	return CreateServerListButton(ServerListCount)
end

--获取服务器名称	
function GetServerListStrName_Ex(str, cstr, i)
	str = string.gsub(str,"（电信）","")
	str = string.gsub(str,"（网通）","")
	str = string.gsub(str,"（电信新）","")
	str = string.gsub(str,"（网通新）","")
	str = string.gsub(str,"()","")
	ServerList[i]:AddFontEx(str,18,0,25,1,200,20,0xffffff)
end

-- 设置“新”图标
function SetNewServerIndex()
	-- local b1 = true
	-- local b2 = true
	for i=1, #ServerListName do
		img_ServerLabel_1[i]:SetVisible(0)
		if string.find(ServerListName[i],"网通新")--[[ and b1--]] then
			-- b1 = false
			WangTongNewServerIndex = i
			img_ServerLabel_1[WangTongNewServerIndex]:SetVisible(1)
		elseif string.find(ServerListName[i],"电信新")--[[ and b2--]] then
			-- b2 = false
			DianXinNewServerIndex = i
			img_ServerLabel_1[DianXinNewServerIndex]:SetVisible(1)
		end
	end
	-- log("\nWangTongNewServerIndex = "..WangTongNewServerIndex)
	-- log("\nDianXinNewServerIndex = "..DianXinNewServerIndex)
end

-- 获取服务器Ping并显示
function GetServerPing(Ping, index)

	ServerListPing[index] = Ping
	if (Ping >= 0 and Ping < 200) then
		ServerPing:SetFontText("网络良好",0xff00ff00)
	end
	if (Ping >= 200 and Ping < 400) then
		ServerPing:SetFontText("网络良好",0xff00ff00)
	end
	if (Ping >= 400 and Ping < 2000) then
		ServerPing:SetFontText("网络良好",0xff00ff00)
	end
	if (Ping >= 2000) then
		ServerPing:SetFontText("网络良好",0xff00ff00)
	end
end

function ChangeServerPingPic(cindex, ping)
	if #ServerList_Ping>0 then
		-- log("\nping = "..ping)
		if (Ping>=0 and Ping<200) then
			ServerList_Ping[cindex].changeimage(path_server.."tip1_server.png")
		elseif (Ping>=200 and Ping<400) then
			ServerList_Ping[cindex].changeimage(path_server.."tip2_server.png")
		elseif (Ping>=400 and Ping<2000) then
			ServerList_Ping[cindex].changeimage(path_server.."tip3_server.png")
		elseif Ping>=2000 then
			ServerList_Ping[cindex].changeimage(path_server.."tip4_server.png")
		end
	end
end

-- 得到上次登陆的服务器名称和索引
function GetLastChoseServer(str, cstr2, cLastSelIndex)
	if cLastSelIndex>0 then
		-- log("\naaaaaaaaaaaaaa1")
		XServerListIndex(cLastSelIndex-1) -- C++索引从0开始，所以-1
		XServerSelectionIsOpen()
		
		img_ShangCiDengLu:SetVisible(1)
		
		local Servername = str
		Servername = string.gsub(Servername,"（电信）","")
		Servername = string.gsub(Servername,"（网通）","")
		Servername = string.gsub(Servername,"（电信新）","")
		Servername = string.gsub(Servername,"（网通新）","")
		Servername = string.gsub(Servername,"()","")
		-- img_DangQianXuanZeF:SetFontText("："..Servername,0xffffff)
				
		img_ShangCiDengLuF:SetFontText("：" .. Servername, 0xffffff)
		
		local ServerType = string.find(str,"网通")
		if (ServerType ~= nil) then
			-- log("\nFindIndex = "..ServerType)
			img_ServerImageBG_2:SetPosition(868,100)
			img_ServerImageBG_2H.changeimage(path_server.."List/"..cstr2..".png")
			img_ServerImageBG_2R.changeimage(path_server.."List/"..cstr2.."_R.png")
			img_ServerImageBG_2:SetVisible(1)
			img_ServerImageBG_1:SetVisible(0)
			XSetEffectPos(img_ServerImageBG_1E.id,0,0)
			XSetEffectPos(img_ServerImageBG_2E.id,0,0)
		else
			img_ServerImageBG_1:SetPosition(868,100)
			img_ServerImageBG_1H.changeimage(path_server.."List/"..cstr2..".png")
			img_ServerImageBG_1R.changeimage(path_server.."List/"..cstr2.."_R.png")
			img_ServerImageBG_1:SetVisible(1)
			img_ServerImageBG_2:SetVisible(0)
			XSetEffectPos(img_ServerImageBG_1E.id,0,0)
			XSetEffectPos(img_ServerImageBG_2E.id,0,0)
		end
		
		if img_ServerLabel_1[cLastSelIndex]:IsVisible() then
			img_ServerLabel_2:SetVisible(1)
		else
			img_ServerLabel_2:SetVisible(0)
		end
		-- if cLastSelIndex==DianXinNewServerIndex or cLastSelIndex==WangTongNewServerIndex then
			-- img_ServerLabel_1:SetVisible(1)
		-- else
			-- img_ServerLabel_1:SetVisible(0)
		-- end
		img_DianXinTuiJian:SetVisible(0)
		img_WangTongTuiJian:SetVisible(0)
		img_ShangCiDengLu:SetVisible(1)
		ServerPing:SetVisible(1)
		LastEnterServerImg:SetPosition(ServerList.posx[cLastSelIndex] + 48, ServerList.posy[cLastSelIndex] - 20)
	else
		-- log("\naaaaaaaaaaaaaa")
		img_ServerImageBG_1:SetVisible(1)
		img_ServerImageBG_1:SetPosition(792, 100)
		img_ServerImageBG_2:SetVisible(1)
		img_ServerImageBG_2:SetPosition(1012, 100)
		XSetEffectPos(img_ServerImageBG_1E.id,-76,0)
		XSetEffectPos(img_ServerImageBG_2E.id,144,0)
		-- log("\nbbbbbbbbbbbbbb")
		XSetTuiJianServerPic()
		-- log("\ncccccccccccccc")
	end
end

function ChangeTuiJianServerPic( cServerName1, cServerName2, cServerIndex1, cServerIndex2)
	local IsSet = true
	local IsSet1 = true
	if cServerIndex1 == -1 then
		IsSet = false
		img_ServerImageBG_1:SetVisible(0)
		img_DianXinTuiJian:SetVisible(0)
	end
	if cServerIndex2 == -1 then
		IsSet1 = false
		img_ServerImageBG_2:SetVisible(0)
		img_WangTongTuiJian:SetVisible(0)
	end
	if IsSet==true then
		img_ServerImageBG_1H.changeimage(path_server.."List/" .. cServerName1 .. ".png")
		img_ServerImageBG_1R.changeimage(path_server.."List/" .. cServerName1 .. "_R.png")
		DianXinTuiJianIndex = cServerIndex1
		img_ServerImageBG_1:SetVisible(1)
		img_DianXinTuiJian:SetVisible(1)
	end
	if IsSet1==true then
		img_ServerImageBG_2.changeimage(path_server.."List/" .. cServerName2 .. ".png")
		img_ServerImageBG_2R.changeimage(path_server.."List/" .. cServerName2 .. "_R.png")
		WangTongTuiJianIndex = cServerIndex2
		
		img_ServerImageBG_2:SetVisible(1)
		img_WangTongTuiJian:SetVisible(1)
	end
end

-- 创建ServerList
function CreateServerListButton(ServerListCount)
	local c_1 = 1					local c_2 = 1
	local ServerWangtong_x = 246	local ServerWangtong_y = 180
	local ServerDianxin_x = 159		local ServerDianxin_y = 286
	local num_x = 46				local num_y = 55
	local num_x1 = 46				local row = 1
	local rowMax = 4

	for c=1, ServerListCount do
		if ServerListName[c]~=nil then
			local ServerType = string.find(ServerListName[c],"网通")
			if (ServerType ~= nil) then
				ServerList[c] = ServerList_Bg[4]:AddButton(path_server.."base2_server.png", path_server.."base3_server.png", path_server.."base4_server.png", ServerWangtong_x, ServerWangtong_y, 140, 37)
				ServerList.posx[c] = ServerWangtong_x
				ServerList.posy[c] = ServerWangtong_y
				ServerWangtong_x = ServerWangtong_x + 132
				c_1 = c_1 + 1
				if (c_1 % 4 == 1) then
					ServerWangtong_x = 246
					ServerWangtong_x = ServerWangtong_x - num_x
					num_x = num_x + 46
					ServerWangtong_y = ServerWangtong_y + num_y
				end
			else
				ServerList[c] = ServerList_Bg[4]:AddButton(path_server.."base2_server.png", path_server.."base3_server.png", path_server.."base4_server.png", ServerDianxin_x, ServerDianxin_y, 140, 37)
				ServerList.posx[c] = ServerDianxin_x
				ServerList.posy[c] = ServerDianxin_y
				ServerDianxin_x = ServerDianxin_x + 132
				c_2 = c_2 + 1
				if (c_2 % rowMax == 1) then
					row = row+1
					ServerDianxin_x = 159
					ServerDianxin_x = ServerDianxin_x - num_x1
					-- log("\nrow = "..row)
					if row>=4 then
						rowMax = 3
						ServerDianxin_x = 153
						ServerDianxin_x = ServerDianxin_x - 46*(row-4)
					-- elseif row==5 then
						-- rowMax = 2
						-- ServerDianxin_x = 170
					end
					num_x1 = num_x1 + 46
					ServerDianxin_y = ServerDianxin_y + num_y
				end
			end
			-- local ppp = ServerListPing[c]
			-- if (ppp >= 0 and ppp < 200) then
				ServerList_Ping[c] = ServerList[c]:AddImage(path_server.."tip1_server.png",9,6,32,32)
			-- elseif (ppp >= 200 and ppp < 400) then
				-- ServerList_Ping[c] = ServerList[c]:AddImage(path_server.."tip2_server.png",9,6,32,32)
			-- elseif (ppp >= 400 and ppp < 2000) then
				-- ServerList_Ping[c] = ServerList[c]:AddImage(path_server.."tip3_server.png",9,6,32,32)
			-- else
				-- ServerList_Ping[c] = ServerList[c]:AddImage(path_server.."tip4_server.png",9,6,32,32)
			-- end
			
			-- 选择服务器
			ServerList[c].script[XE_LBUP] = function()
				XClickPlaySound(5)
				-- 通知C++选择的服务器索引
				XServerListIndex(c-1)
				XServerSelectionIsOpen()
				
				-- 隐藏不需要的UI
				img_DianXinTuiJian:SetVisible(0)
				img_WangTongTuiJian:SetVisible(0)
				img_ShangCiDengLu:SetVisible(0)
				img_ServerImageBG_1:SetVisible(0)
				img_ServerImageBG_2:SetVisible(0)
				
				str = string.gsub(ServerListName[c],"（电信）","")
				str = string.gsub(str,"（网通）","")
				str = string.gsub(str,"（电信新）","")
				str = string.gsub(str,"（网通新）","")
				str = string.gsub(str,"()","")
				img_DangQianXuanZeF:SetFontText("："..str,0xffffff)
				img_DangQianXuanZe:SetVisible(1)
				ServerPing:SetVisible(1)
				
				LastEnterServerindex = c
				-- log("\nLastEnterServerindex = "..LastEnterServerindex)
				DangQianXuanZe:SetPosition(ServerList.posx[c] + 48, ServerList.posy[c] - 20)
				
				if img_ServerLabel_1[LastEnterServerindex]:IsVisible() then
					img_ServerLabel_2:SetVisible(1)
				else
					img_ServerLabel_2:SetVisible(0)
				end
				-- if c==DianXinNewServerIndex or c==WangTongNewServerIndex then
					-- img_ServerLabel_1:SetVisible(1)
				-- else
					-- img_ServerLabel_1:SetVisible(0)
				-- end
					
				ServerType = string.find(ServerListName[c],"网通")
				if (ServerType ~= nil) then
					img_ServerImageBG_2H.changeimage(path_server.."List/"..ServerListPathName[c]..".png")
					img_ServerImageBG_2R.changeimage(path_server.."List/"..ServerListPathName[c].."_R.png")
					img_ServerImageBG_2:SetPosition(868,100)
					img_ServerImageBG_2:SetVisible(1)
					XSetEffectPos(img_ServerImageBG_1E.id,0,0)
					XSetEffectPos(img_ServerImageBG_2E.id,0,0)
				else
					img_ServerImageBG_1H.changeimage(path_server.."List/"..ServerListPathName[c]..".png")
					img_ServerImageBG_1R.changeimage(path_server.."List/"..ServerListPathName[c].."_R.png")
					img_ServerImageBG_1:SetPosition(868,100)
					img_ServerImageBG_1:SetVisible(1)
					XSetEffectPos(img_ServerImageBG_1E.id,0,0)
					XSetEffectPos(img_ServerImageBG_2E.id,0,0)
				end
			end
			
			img_ServerLabel_1[c] = ServerList[c]:AddImage(path_server.."xin.png", 102, 1, 31, 18)
			img_ServerLabel_1[c]:SetTouchEnabled(0)
		end
	end
	
	-- local tempimg1 = ServerList_Bg[4]:AddImage(path_server.."xin.png", 348, 181, 31, 18)
	-- tempimg1:SetTouchEnabled(0)
	-- local tempimg2 = ServerList_Bg[4]:AddImage(path_server.."xin.png", 261, 287, 31, 18)
	-- tempimg2:SetTouchEnabled(0)
end

-- 账户下拉列表框账户按钮
function CreateButtonById(wnd)
	local y = 0
	if IdList[1] == nil then
		for i = 1, 6 do
			IdList[i] = wnd:AddImage(path_login.."passwordEdit_login.png",0,y,377,32)
			IdList[i]:SetTransparent(0)
			IdList[i]:SetVisible(0)
			IdList_Font[i] = IdList[i]:AddFont("NULL",18,0,30,0,300,20,0xC3C3C3)
			IdList_Font[i]:SetFontScissorRect(750, 394, 300, 170)
			
			img_SelList[i] = IdList[i]:AddImage(path_server.."listhover_server.png", 0, 0, 332, 29)
			img_SelList[i]:SetVisible(0)
			
			-- 点击
			IdList[i].script[XE_LBUP] = function()
				XClickPlaySound(5)
				userinput:SetEdit( DownList_Str_Info[i])
				wnd:SetVisible(0)
			end
			
			-- 悬浮
			IdList[i].script[XE_ONHOVER] = function()
				img_SelList[i]:SetVisible(1)
			end
			
			-- 离开
			IdList[i].script[XE_ONUNHOVER] = function()
				img_SelList[i]:SetVisible(0)
			end
			
			y = y+29
		end
	end
	ReDrawPlayerId(wnd)
end

function ReDrawPlayerId(wnd)
	Height = 0
	if #DownList_Str_Info>0 then
		for i = 1, #DownList_Str_Info do
			IdList[i]:SetVisible(1)
			IdList_Font[i]:SetFontText( DownList_Str_Info[i], 0xC3C3C3)
			Height = Height+29
		end
		g_server_selection_ui:SetAddImageRect(wnd.id, 750, 394, 332, 82, 750, 394, 332, Height)
	else
		wnd:SetVisible(0)
	end
end

-- 设置是否显示
function ShowServerselection(bshow)
	if bshow == 1 and g_server_selection_ui:IsVisible() == false then
		ReSetStartButton(1)
		g_server_selection_ui:CreateResource()
		g_server_selection_ui:SetVisible(1)
		
		local index = 0
		g_server_selection_ui:SetTimer(0,50).Timer = function(timer)
			index = index+1
			XSetWindowRotation(img_ServerImageBG_1R.id, index*RotationSpeed*3.14/180)
			XSetWindowRotation(img_ServerImageBG_2R.id, index*RotationSpeed*3.14/180)	
		end
		XCheckIsWangBaEnter()
		SetFourpartUIVisiable(0)
		if IsLock==0 then
			passinput:SetEdit("")
		end
		XClearPassInput_Signin()
		tabFocus = 1
	elseif bshow == 0 and g_server_selection_ui:IsVisible() == true then
		g_server_selection_ui:DeleteResource()
		g_server_selection_ui:SetVisible(0)
		g_server_selection_ui:KillTimer(0)
		
		if IsLock==0 then
			passinput:SetEdit("")
		end
		XSetServerSelectionVisible(0)
		XClearPassInput_Signin()
		
		-- 重置UI状态
		ServerListIsOpen = false
		BK3_login:SetVisible(1)
		if #ServerList_Bg > 0 then
			for i = 1, #ServerList_Bg do
				ServerList_Bg[i]:SetVisible(0)
			end
		end
		-- log("\nServerSelectionVisible")
	end
end

function ReSetStartButton( cBool)
	-- log("\nbtn_EnterGame   "..cBool)
	btn_EnterGame:SetEnabled(cBool)
end

function EnterGameSuccess()
	-- log("\nLastEnterServerindex = "..LastEnterServerindex)
	LastEnterServerImg:SetPosition(ServerList.posx[LastEnterServerindex] + 48, ServerList.posy[LastEnterServerindex] - 20)
end

function SetDebugPassKey()
	passinput:SetEdit("1234")
end

function SetPassKeyNull_Login()
	if IsLock==0 then
		passinput:SetEdit("")
	end
end

function VisibleDownList()
	local x = XGetCursorPosX()
	local y = XGetCursorPosY()
	if (x < 750 or y < 394 or x > 750+332 or y > 394+Height) then
		img_DownPullFrameBg:SetVisible(0)
	end
end

function ClickServerPic_TuiJian( SelServerIndex)
	-- 通知C++选择的服务器索引
	-- log("\nSelServerIndex = "..SelServerIndex)
	if SelServerIndex<1 then
		return
	end
	XServerListIndex(SelServerIndex-1)
	XServerSelectionIsOpen()
	
	-- 隐藏不需要的UI
	img_DianXinTuiJian:SetVisible(0)
	img_WangTongTuiJian:SetVisible(0)
	img_ShangCiDengLu:SetVisible(0)
	img_ServerImageBG_1:SetVisible(0)
	img_ServerImageBG_2:SetVisible(0)
	
	str = string.gsub(ServerListName[SelServerIndex],"（电信）","")
	str = string.gsub(str,"（网通）","")
	str = string.gsub(str,"（电信新）","")
	str = string.gsub(str,"（网通新）","")
	str = string.gsub(str,"()","")
	img_DangQianXuanZeF:SetFontText("："..str,0xffffff)
	img_DangQianXuanZe:SetVisible(1)
	ServerPing:SetVisible(1)
	
	LastEnterServerindex = SelServerIndex
	DangQianXuanZe:SetPosition(ServerList.posx[SelServerIndex] + 48, ServerList.posy[SelServerIndex] - 20)
	
	if img_ServerLabel_1[SelServerIndex]:IsVisible() then
		img_ServerLabel_2:SetVisible(1)
	else
		img_ServerLabel_2:SetVisible(0)
	end
	-- if SelServerIndex==WangTongNewServerIndex or SelServerIndex==DianXinNewServerIndex then
		-- img_ServerLabel_1:SetVisible(1)
	-- else
		-- img_ServerLabel_1:SetVisible(0)
	-- end
		
	ServerType = string.find(ServerListName[SelServerIndex],"网通")
	if (ServerType ~= nil) then
		img_ServerImageBG_2H.changeimage(path_server.."List/"..ServerListPathName[SelServerIndex]..".png")
		img_ServerImageBG_2R.changeimage(path_server.."List/"..ServerListPathName[SelServerIndex].."_R.png")
		img_ServerImageBG_2:SetPosition(868,100)
		img_ServerImageBG_2:SetVisible(1)
		XSetEffectPos(img_ServerImageBG_1E.id,0,0)
		XSetEffectPos(img_ServerImageBG_2E.id,0,0)
	else
		img_ServerImageBG_1H.changeimage(path_server.."List/"..ServerListPathName[SelServerIndex]..".png")
		img_ServerImageBG_1R.changeimage(path_server.."List/"..ServerListPathName[SelServerIndex].."_R.png")
		img_ServerImageBG_1:SetPosition(868,100)
		img_ServerImageBG_1:SetVisible(1)
		XSetEffectPos(img_ServerImageBG_1E.id,0,0)
		XSetEffectPos(img_ServerImageBG_2E.id,0,0)
	end
end

function SetPassAndIdUiVisible( cvisible, cID, cPass, cIsLock)
	FatherCheck:SetVisible(cvisible)
	userinput:SetEdit(cID)
	passinput:SetEdit(cPass)
	IsLock = cIsLock
end