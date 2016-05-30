include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

local IsTodayFirstSignIn = 0      -----是否今日首次登陆
OffsetX1 = 0
OffsetY1 = 0
OffsetX2 = 0
OffsetY2 = 0

function SetWindowOffset(x1,y1,x2,y2)
	OffsetX1 = x1
	OffsetY1 = y1
	OffsetX2 = x2
	OffsetY2 = y2
end

function InitGame_hallUI(wnd, bisopen)
	g_game_hall_ui = CreateWindow(wnd.id, 0, 0, 1280, 800)
	InitMainGame_hall(g_game_hall_ui)
	g_game_hall_ui:SetVisible(bisopen)	
end

-- 主页背景图和英雄Id
local MainHall_BK = nil
local MainHall_Effect = nil
MainHall_BKHeroId = 193
local btn_gotoshop = nil
local btn_herodetail = nil
local btn_defaultbk = nil
local main_herologo = nil

function InitMainGame_hall(wnd)

	--底图背景
	MainHall_BK = wnd:AddImage("../UI/hero/" .. MainHall_BKHeroId .. ".png",0,0,1280,800)
	MainHall_Effect = wnd:AddEffect("../Data/Magic/Common/UI/changwai/183Skin1/183Skin1_od.x",0,0,1280,800)
	
	--英雄图标
	main_herologo = wnd:AddImage(path.."logoHero_hall.png",50,528-OffsetY1,482,170)
	wnd:AddImage(path.."bkmoney_hall.png",925,92,355,30)
	--local AA = wnd:AddImage(path_hero.."LOVEBK_hero.png",200,350,296,167)
	--AA:AddCodeCheck(50,40,300,300)
	
	--恢复默认
	btn_defaultbk = wnd:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png",70,700-OffsetY1, 179, 56)
	btn_defaultbk:AddFont("权其捞瘤", 15, 0, 50, 15, 72, 20, 0xbeb9cf)
	btn_defaultbk.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		SetImage_MainHallBK("../UI/hero/" .. MainHall_BKHeroId .. ".png", "")
		XSendMainBKData(MainHall_BKHeroId,5)
	end
	btn_defaultbk:SetVisible(0)
	
	--前往商城
	btn_gotoshop = wnd:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png",70,700-OffsetY1, 179, 56)
	btn_gotoshop:AddFont("矫厘规巩", 15, 0, 50, 15, 72, 20, 0xbeb9cf)
	btn_gotoshop.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		XShopUiIsClick(1)
		-----跳到商城英雄界面
		Set_JumpToShopHero()
	end
	--英雄详情
	btn_herodetail = wnd:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png",250,700-OffsetY1, 179, 56)
	btn_herodetail:AddFont("康旷沥焊", 15, 0, 50, 15, 72, 20, 0xbeb9cf)
	btn_herodetail.script[XE_LBUP] = function()
		XClickPlaySound(5)
				
		------跳到集卡书二级页面
		Set_JumpToHeroDetail()
	end
	
	InitChat_UI(g_game_hall_ui,0)							-- 聊天界面
	
	wnd:AddImage(path.."downline_hall.png",0,792,1280,8)
	wnd:AddImage(path.."leftline_hall.png",0,0,11,800)
	wnd:AddImage(path.."rightline_hall.png",1269,0,11,800)
end

-----控制签到弹窗只在当日首次登陆显示一次
function Sign_IsFirstLogin(IsfirstLogin)
	IsTodayFirstSignIn = IsfirstLogin
	if IsTodayFirstSignIn == 1 then
	--	SetsigninIsVisible(1)
	else
		--SetsigninIsVisible(0)
	end
end

-- 设置主页背景图
function SetImage_MainHallBK(picture,path)
	MainHall_BK.changeimage(picture)
	
	if path ~= "" then
		MainHall_Effect:ChangeEffect(path)
	else
		MainHall_Effect:ChangeEffect("../Data/Magic/Common/UI/changwai/183Skin1/183Skin1_od.x")
	end
end

-- 恢复默认时按钮处理
function ShowDefaultMainHallBK(flag)
	btn_defaultbk:SetVisible(1-flag)
		
	main_herologo:SetVisible(flag)
	btn_gotoshop:SetVisible(flag)
	btn_herodetail:SetVisible(flag)
end


--设置显示
function SetGameHallIsVisible(flag) 
	if g_game_hall_ui ~= nil then
		if flag == 1 and g_game_hall_ui:IsVisible() == false then
			g_game_hall_ui:SetVisible(1)
			SetReturnVisible(0)
			SetFourpartUIVisiable(1)
			
			SetChatIsVisible(1)
			SetAdvertIsVisible(1)--广告
			SetCurTitleState_teadytime(1)
			SetPassKeyNull_Login()
		elseif flag == 0 and g_game_hall_ui:IsVisible() == true then
			g_game_hall_ui:SetVisible(0)
			SetReturnVisible(1)
			SetChatIsVisible(0)
			SetAdvertIsVisible(0)--广告
		end
	end
end
--获取是否显示
function GetGameHallIsVisible()  
    if g_game_hall_ui~=nil and g_game_hall_ui:IsVisible()==true then
        return 1
    else
        return 0
    end
end