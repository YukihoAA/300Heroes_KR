include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")


local heroname_herodetail = nil
local Current_HeroId = 0		-- 当前英雄的ID
local FontColor = {}

-- 折扣背景
local PRICE_BK = nil

-- 英雄数据修改
local ICON_HEAD = nil
local LOVE_count,FONT_hero_name,FONT_hero_name1,FONT_hero_name2 = nil
local NUM_stlife = {}
local COL_stlife = {}
local IMG_skill = {}

local FONT_baseNum = {}
local FONT_levelUpNum = {}

local HeroIconPath_GrowthUPUi = "null"

-- 修改完毕
local NAME_LOVENO,NAME_LOVEYES = nil
local WND_TYPE,WND_SKILL,WND_WAKEUP,WND_FILE = nil

local BTN_TYPE,BTN_SKILL,BTN_WAKEUP,BTN_FILE = nil

local BTN_BUY = nil
local HaveHero = 0

local m_stNum = {}
local m_skillPic = {}
local m_skillDis = {}
local m_skillTip = {}
local BTN_SkillPic = {}
-- 觉醒
local WND_WAKEINIT_FONT = {}	-- 初始值窗口
local WND_WAKEGROW_FONT = {}	-- 成长窗口
local WND_WAKESTPT_FONT = {}	-- 觉醒点窗口
local WND_WAKEADD_BTN = {}		-- "+"
local WND_WAKEADD_IMG = {}		-- "+"灰色不可点击
local WND_WAKEPLUS_BTN = {}		-- "-"
local WND_WAKEPLUS_IMG = {}		-- "-"灰色不可点击

local NUM_WAKEINIT = {}			-- 初始值
local NUM_WAKEGROW = {}			-- 成长值
local NUM_WAKESTPT = {}

local left_point = nil 
local btn_wakeupp = nil
-- local img_WakeUpUnEnable = nil
local btn_Advice = nil 
local btn_Yes = nil 
local btn_Cancel = nil 
-- local btn_Yes_UnEnable = nil
-- local btn_Cancel_UnEnable = nil
local font_point = 0
-- 觉醒完毕
local Li,Ti = 0
-- 信息	
local baseNum = {}
local levelUpNum = {}
local FONT_skillname = {}
local FONT_skilldis = {}
local FONT_FILE = nil
local NQWER = {"","Q","W","E","R"}

-- 英雄皮肤小图片
local SkinHaveBK = {}
local SKIN_LISTL_BK = {}
local SKIN_LISTL_BTN = {}			-- 图片按钮
local SKIN_LISTL_NAME = {}			-- 皮肤名称
local SKIN_LISTL_HAVE = {}			-- 皮肤是否拥有
local SKIN_LISTL_BUY = {}			-- 皮肤购买按钮
local SKIN_LISTL_PRICE = {}			-- 皮肤钻石价格
local Skin_Listimg_Lv = nil
local SKIN_EFFECT1 = nil

local SKIN_LISTL = {}
SKIN_LISTL.BK = {path_hero.."ffffff_hero.png",path_hero.."ffffff_hero.png",path_hero.."ffffff_hero.png",path_hero.."ffffff_hero.png",path_hero.."ffffff_hero.png"}
SKIN_LISTL.BTN = {path_hero.."ffffff_hero.png",path_hero.."ffffff_hero.png",path_hero.."ffffff_hero.png",path_hero.."ffffff_hero.png",path_hero.."ffffff_hero.png"}
SKIN_LISTL.NAME = {"中间","中间皮","中间皮肤","中间的皮肤"}
SKIN_LISTL.HAVE = {0,0,0,0}
SKIN_LISTL.POSXS = {40,185,330,475,620}
SKIN_LISTL.PRICE = {999,898,887,666}
SKIN_LISTL.POSX = {0,0,0,0}
SKIN_LISTL.POSY = {0,0,0,0}
SKIN_LISTL.POSW = {100,100,100,100}
SKIN_LISTL.POSH = {200,200,200,200}
SKIN_LISTL.SkinLv = {0, 0, 0, 0}
SKIN_LISTL.SkinRealId = {}

local GameFont = {}				-- 定位窗口里的战绩控件
local hero_goldSrc = nil		-- 英雄原始钻石价格
local hero_discount = nil		-- 英雄钻石折扣
local hero_money = nil			-- 英雄金币价格
local hero_goldDis = nil		-- 英雄折扣后钻石价格

local HeroType,HeroWinPercent = nil							-- 英雄定位文字和胜率文字
-- 新增背包信息
local WND_BAG = nil
local BTN_BAG = nil

local BagDefault, BagChoiceA, BagChoiceB= nil
-- local BagTimeA, BagTimeB = nil
local BagBtnDefault,BagBtnA, BagBtnB = nil
-- local BagBtnDefaultUnEable,BagBtnAUnEable, BagBtnBUnEable = nil
local BagDefaultInfo = {}
local BagChoiceAInfo = {}
local BagChoiceBInfo = {}
-- 专属
local OnlyEquipFont = nil
local OnlyEquip = {}
local OnlyEquip_State = {}
local OnlyEquip_BG = nil
-- 专属套装通信表
local OnlyEquipId = {}

local HeroDefaultEquip = {}
HeroDefaultEquip.PictureName = {}
HeroDefaultEquip.Id = {}

local HeroFirstEquip = {}
HeroFirstEquip.PictureName = {}
HeroFirstEquip.Id = {}

local HeroSecondEquip = {}
HeroSecondEquip.PictureName = {}
HeroSecondEquip.Id = {}

local img_money = nil
local img_gold = nil
local img_HeroPriceBg = nil

-- 初始化UI
function InitGame_HeroDetailUI(wnd, bisopen)
	if g_game_heroDetail_ui == nil then
		g_game_heroDetail_ui = CreateWindow(wnd.id, 0, 0, 1280, 800)
		InitMainGame_HeroDetailA(g_game_heroDetail_ui)
		InitMainGame_HeroDetailC(g_game_heroDetail_ui)
		InitMainGame_HeroDetailB(g_game_heroDetail_ui)
	end
	g_game_heroDetail_ui:SetVisible(bisopen)
end
function InitMainGame_HeroDetailA(wnd)
	for i = 1,5 do
		SKIN_LISTL_BK[i] = wnd:AddImage(SKIN_LISTL.BK[i],0,0,1280,800)
		SKIN_LISTL_BK[i]:SetVisible(0)
	end
	SKIN_EFFECT1 = wnd:AddEffect("../Data/Magic/Common/UI/changwai/183Skin1/183Skin1_01_od.x",0,0,1280,800)
	SKIN_EFFECT1:SetVisible(0)
	-- for i=1, 4 do
	Skin_Listimg_Lv = wnd:AddImage(path_hero.."skinlv_1.png", 10, 10, 111, 69)
	Skin_Listimg_Lv:SetVisible(0)
	-- end
	SKIN_LISTL_BK[5]:SetVisible(1)
	
	wnd:AddImage(path_hero.."bkinfo_hero.png",928,146,332,298)
	
	-- 上边栏	
	local BTN_RETURN = wnd:AddButton(path_hero.."return1_hero.png",path_hero.."return2_hero.png",path_hero.."return3_hero.png",1180,290,56,48)
	BTN_RETURN.script[XE_LBUP] = function()
		XClickPlaySound(5)
		SKIN_EFFECT1:SetVisible(0)
		if SKIN_LISTL_BK[5]:IsVisible()==true then
			g_game_heroDetail_ui:SetVisible(0)
			SetGameHeroAllIsVisible(1)
		else
			for i=1, 4 do
				SKIN_LISTL_BK[i]:SetVisible(0)
			end
			SKIN_LISTL_BK[5]:SetVisible(1)
			Skin_Listimg_Lv:SetVisible(0)
		end
		-- ReturnBackHeroInfo()
	end
	
	-- 皮肤切换
	for i = 1,4 do
		SKIN_LISTL_BTN[i] = wnd:AddImage(SKIN_LISTL.BK[i],0,0,1280,800)
		SKIN_LISTL_BTN[i]:SetAddImageRect(SKIN_LISTL_BTN[i].id, 500, 80, 110+500, 170+80, SKIN_LISTL.POSXS[i] ,555-OffsetY1, 110, 170)
		XWindowEnableAlphaTouch(SKIN_LISTL_BTN[i].id)
		SKIN_LISTL_BTN[i]:SetTouchEnabled(1)
		
		SKIN_LISTL_BTN[i]:AddImage(path_hero.."skinbg_hero.png", -33, -40, 168, 38)
		SKIN_LISTL_NAME[i] = SKIN_LISTL_BTN[i]:AddFont(SKIN_LISTL.NAME[i],11,8,95,22,300,0,0xf99700)
		local AA = SKIN_LISTL_BTN[i]:AddImage(path_hero.."skinside_hero.png",0,0,112,173)
		AA:SetTouchEnabled(0)
		SkinHaveBK[i] = AA:AddImage(path_hero.."skinhave_hero.png",3,146,105,23)
		SkinHaveBK[i]:SetTouchEnabled(0)
		SKIN_LISTL_HAVE[i] = SkinHaveBK[i]:AddFont("未拥有",12,8,0,0,105,23,0xff0000)
		
		-- 皮肤按钮
		SKIN_LISTL_BTN[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			SKIN_LISTL_BK[5]:SetVisible(0)	
			SKIN_EFFECT1:SetVisible(0)
			
			if SKIN_LISTL.SkinLv[i]==0 then
				Skin_Listimg_Lv:SetVisible(0)
			else
				Skin_Listimg_Lv:SetVisible(1)
				Skin_Listimg_Lv.changeimage(path_hero.."skinlv_"..SKIN_LISTL.SkinLv[i]..".png")
			end
			if i == 1 then
				SKIN_LISTL_BK[1]:SetVisible(1)
				SKIN_LISTL_BK[2]:SetVisible(0)
				SKIN_LISTL_BK[3]:SetVisible(0)
				SKIN_LISTL_BK[4]:SetVisible(0)
				
				if Current_HeroId == 183 then 
					SKIN_EFFECT1:SetVisible(1)
				end
				
			elseif i == 2 then
				SKIN_LISTL_BK[1]:SetVisible(0)
				SKIN_LISTL_BK[2]:SetVisible(1)
				SKIN_LISTL_BK[3]:SetVisible(0)
				SKIN_LISTL_BK[4]:SetVisible(0)
			elseif i == 3 then
				SKIN_LISTL_BK[1]:SetVisible(0)
				SKIN_LISTL_BK[2]:SetVisible(0)
				SKIN_LISTL_BK[3]:SetVisible(1)
				SKIN_LISTL_BK[4]:SetVisible(0)
			elseif i == 4 then
				SKIN_LISTL_BK[1]:SetVisible(0)
				SKIN_LISTL_BK[2]:SetVisible(0)
				SKIN_LISTL_BK[3]:SetVisible(0)
				SKIN_LISTL_BK[4]:SetVisible(1)
			end
			
		end
		-- 皮肤购买
		SKIN_LISTL_BUY[i] =  SKIN_LISTL_BTN[i]:AddButton(path_hero.."buySkin1_hero.png",path_hero.."buySkin2_hero.png",path_hero.."buySkin3_hero.png",0,175,128,32)
		local but = SKIN_LISTL_BUY[i]:AddImage(path_shop.."gold_shop.png",10,-5,64,64)
		but:SetTouchEnabled(0)
		SKIN_LISTL_PRICE[i] = SKIN_LISTL_BUY[i]:AddFont("999",12,8,0,-12,130,0,0xffffff)
		
		SKIN_LISTL_BUY[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			-- SetShopItemBuyNameInfo( SKIN_LISTL.NAME[i])
			-- log("\ni = "..i)
			-- log("\naaaaaaa = "..SKIN_LISTL.SkinRealId[i])
			XClickBuyHeroSkinButton_Lua( Current_HeroId, i-1)
		end
				
	end
	
	-- 我的最爱
	local NAME_IMG = wnd:AddImage(path_hero.."NAMEBK_hero.png",950,170,256,64)
	FONT_hero_name = NAME_IMG:AddFont("",15,0,50,13,200,15,0x95f9fd)
	NAME_LOVENO = wnd:AddImage(path_hero.."LOVE1_hero.png",960,180,32,32)
	NAME_LOVENO:SetVisible(1)
	
	NAME_LOVEYES = wnd:AddImage(path_hero.."LOVE2_hero.png",960,180,32,32)
	NAME_LOVEYES:SetTouchEnabled(0)
	NAME_LOVEYES:SetVisible(0)
	NAME_LOVENO.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if NAME_LOVEYES:IsVisible() == true then
			NAME_LOVEYES:SetVisible(0)
			-- 取消我的最爱
			XClickFavoriteHero(Current_HeroId,0)
		else
			XClickFavoriteHero(Current_HeroId,-1)
			
			WND_TYPE:SetVisible(0)
			WND_SKILL:SetVisible(0)
			WND_WAKEUP:SetVisible(0)
			WND_FILE:SetVisible(0)
			WND_BAG:SetVisible(0)
			
			BTN_TYPE:SetCheckButtonClicked(0)
			BTN_SKILL:SetCheckButtonClicked(0)
			if HaveHero >0 then 
				BTN_WAKEUP:SetCheckButtonClicked(0)
			end
			BTN_FILE:SetCheckButtonClicked(0)
			BTN_BAG:SetCheckButtonClicked(0)
		end
	end
	-- 确定设置为最爱？
	WND_LOVE = CreateWindow(wnd.id, 640, 170, 295, 165)
	local BK_TYPE = WND_LOVE:AddImage(path_hero.."LOVEBK_hero.png",0,0,296,167)
	WND_LOVE:SetAddImageRect(BK_TYPE.id, 0, 0, 295, 165, 0 ,0, 295, 165)
	WND_LOVE:AddFont("确定将",15,0,70,25,200,15,0xa7a7e8)
	FONT_hero_name1 = WND_LOVE:AddFont(hero_name,15,0,120,25,200,15,0x95f9fd)
	WND_LOVE:AddFont("设定为您最爱的英雄吗？",15,0,70,45,200,15,0xa7a7e8)
	LOVE_count = WND_LOVE:AddFont("7",15,0,173,130,200,15,0x95f9fd)
	WND_LOVE:AddFont("您还可以设置      位",15,0,80,130,200,15,0xa7a7e8)
	
	local BTN_LOVEYES = WND_LOVE:AddButton(path_hero.."LYES1_hero.png",path_hero.."LYES2_hero.png",path_hero.."LYES3_hero.png",44,85,128,64)
	WND_LOVE:AddFont("确定",15,0,80,90,100,15,0xffffff)
	BTN_LOVEYES.script[XE_LBUP] = function()
		XClickPlaySound(5)
		WND_LOVE:SetVisible(0)
		NAME_LOVEYES:SetVisible(1)
		XClickFavoriteHero(Current_HeroId,1)
	end
	local BTN_LOVENO = WND_LOVE:AddButton(path_hero.."LNO1_hero.png",path_hero.."LNO2_hero.png",path_hero.."LNO3_hero.png",146,85,128,64)
	WND_LOVE:AddFont("取消",15,0,175,90,100,15,0xeeeef2)
	BTN_LOVENO.script[XE_LBUP] = function()
		XClickPlaySound(5)
		WND_LOVE:SetVisible(0)
	end
	WND_LOVE:SetVisible(0)
	
	-- 觉醒
	NUM_WAKEINIT = {999,888,777,666,555,444,333,222,111,100,11}	-- 初始值
	NUM_WAKEGROW = {180,82,91,67,43,32,76,23,15,98,19}	-- 成长值
	NUM_WAKESTPT = {10,55,33,22,77,88,99,90,23,36,82}	-- 觉醒值
	
	WND_WAKEUP = CreateWindow(wnd.id, 540, 190, 400, 280)
	local BK_WAKEUP = WND_WAKEUP:AddImage(path_hero.."BK2_hero.png",0,0,400,280)
	WND_WAKEUP:SetAddImageRect(BK_WAKEUP.id, 0, 0, 400, 280, 0 ,0, 400, 280)
	WND_WAKEUP:AddImage(path_hero.."arrow_hero.png",386,98,32,128)
	local WAKEUPBTN_CLOSE = WND_WAKEUP:AddButton(path_hero.."closesmall1_hero.png",path_hero.."closesmall2_hero.png",path_hero.."closesmall3_hero.png",372,8,32,32)
	WAKEUPBTN_CLOSE.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XSetHeroGrowthUpUiVisible(0, "")
		WND_WAKEUP:SetVisible(0)
		if HaveHero >0 then 
			BTN_WAKEUP:SetCheckButtonClicked(0)
		end
		
		for i = 1, #FontColor do
			FontColor[i] = 0xffbeb5ee
		end
	end
	local FONTMAIN_WAKEUP = {"属性","初始值","成长","觉醒点","配置","觉醒规则"}
	local FONTMAIN_posX = {20,70,130,180,240,300}
	for i=1,6 do
		WND_WAKEUP:AddFont(FONTMAIN_WAKEUP[i],15,0,FONTMAIN_posX[i],10,100,15,0xa7a7e8)
	end
	
	local FONTLIST_WAKEUP = {"生命值","法力值","护甲","法术抗性","物理攻击","法术强度","冷却缩减","攻击速度","移动速度","护甲穿透","法术穿透"}
	local FONTLIST_posX = {15,15,20,12,12,12,12,12,12,12,12}
	for i=1,11 do
		if i%2 == 1 then
			WND_WAKEUP:AddImage(path_hero.."WAKEBK_hero.png",7,20+i*18,268,17)
		end	
		WND_WAKEUP:AddFont(FONTLIST_WAKEUP[i],11,0,FONTLIST_posX[i],20+i*18,100,11,0xbeb5ee)
		WND_WAKEINIT_FONT[i] = WND_WAKEUP:AddFont(NUM_WAKEINIT[i],11,0,80,22+i*18,100,11,0xbeb5ee)
		WND_WAKEGROW_FONT[i] = WND_WAKEUP:AddFont(NUM_WAKEGROW[i],11,0,135,22+i*18,100,11,0xbeb5ee)
		WND_WAKESTPT_FONT[i] = WND_WAKEUP:AddFont(NUM_WAKESTPT[i],11,0,190,22+i*18,100,11,0xbeb5ee)
		-- 加减按钮
		WND_WAKEADD_BTN[i] = WND_WAKEUP:AddButton(path_hero.."add1_hero.png",path_hero.."add2_hero.png",path_hero.."add3_hero.png",245,22+i*18,16,16)
		WND_WAKEADD_IMG[i] = WND_WAKEUP:AddImage(path_hero.."add0_hero.png",245,22+i*18,16,16)			-- 灰色不可点击图片
		WND_WAKEADD_BTN[i]:SetVisible(0)
		
		WND_WAKEPLUS_BTN[i] = WND_WAKEUP:AddButton(path_hero.."plus1_hero.png",path_hero.."plus2_hero.png",path_hero.."plus3_hero.png",260,22+i*18,16,16)
		WND_WAKEPLUS_IMG[i] = WND_WAKEUP:AddImage(path_hero.."plus0_hero.png",260,22+i*18,16,16)			-- 灰色不可点击图片
		WND_WAKEPLUS_BTN[i]:SetVisible(0)
		
		-- 加
		WND_WAKEADD_BTN[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			XClickAddButtonGrowthUp(i-1)
		end
		
		-- 减
		WND_WAKEPLUS_BTN[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			XClickPlusButtonGrowthUp(i-1)
		end
	end
	WND_WAKEUP:AddFont("觉醒         点",12,0,12,245,100,12,0xbeb5ee)
	left_point = WND_WAKEUP:AddFont(font_point,12,8,0,0,106,508,0x6ffefc)
	
	btn_Advice = WND_WAKEUP:AddButton(path_hero.."WAKEBTN1_hero.png",path_hero.."WAKEBTN2_hero.png",path_hero.."WAKEBTN3_hero.png",90,243,46,21)
	btn_Advice:AddFont("推荐",12,0,6,2,100,12,0xbeb5ee)
	btn_Advice:SetVisible(0)
	btn_Advice.script[XE_LBUP] = function()
		XClickPlaySound(5)
		-- 推荐
		XClickAdviceGrowth()
	end
	btn_Yes = WND_WAKEUP:AddButton(path_hero.."WAKEBTN1_hero.png",path_hero.."WAKEBTN2_hero.png",path_hero.."WAKEBTN3_hero.png",160,243,46,21)
	btn_Yes:AddFont("确定",12,0,6,2,100,12,0xbeb5ee)
	btn_Yes:SetVisible(0)
	btn_Cancel = WND_WAKEUP:AddButton(path_hero.."WAKEBTN1_hero.png",path_hero.."WAKEBTN2_hero.png",path_hero.."WAKEBTN3_hero.png",230,243,46,21)
	btn_Cancel:AddFont("取消",12,0,6,2,100,12,0xbeb5ee)
	btn_Cancel:SetVisible(0)
	
	btn_Yes.script[XE_LBUP] = function()
		-- 确定
		XClickPlaySound(5)
		XClickOkButton_HeroGrowthUp()
	end
	
	btn_Cancel.script[XE_LBUP] = function()
		-- 取消
		XClickPlaySound(5)
		XClickCancelButton_HeroGrowthUp()
	end
	
	btn_wakeupp = WND_WAKEUP:AddButton(path_setup.."btn1_mail.png",path_setup.."btn2_mail.png",path_setup.."btn3_mail.png",135,240,100,32)
	-- img_WakeUpUnEnable = WND_WAKEUP:AddButton(path_hero.."buyS_3.png",135,240,128,32)
	-- img_WakeUpUnEnable:SetVisible(0)
	btn_wakeupp:AddFont("开启觉醒",15,8,0,0,100,32,0xbeb5ee)
	btn_wakeupp.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickOpenWakeup()
	end
	
	WND_WAKEUP:AddImage(path_hero.."wakerules_hero.png",280,33,113,233)
	WND_WAKEUP:AddFont("觉醒点数额外分配3点以上产生效果衰减：额外第三点衰减20%，额外第四点衰减40%，额外第五点衰减60%，额外第六点衰减80%，每项属性最多6点！",11,0,288,50,95,300,0xbeb5ee)
	WND_WAKEUP:SetVisible(0)
	
	-- 觉醒完毕
	wnd:AddImage(path_hero.."kuangL_hero.png", 0, 22, 10, 756)
	wnd:AddImage(path_hero.."kuangR_hero.png", 1270, 22, 10, 756)
	wnd:AddImage(path_hero.."kuangT_hero.png", 0, 0, 1280, 22)
	wnd:AddImage(path_hero.."kuangB_hero.png", 0, 778, 1280, 22)
	
end

-- 4个左边窗口定位、技能、觉醒、档案
function InitMainGame_HeroDetailB(wnd)
	WND_TYPE = CreateWindow(wnd.id, 540, 190, 400, 280)
	local BK_TYPE = WND_TYPE:AddImage(path_hero.."BK2_hero.png",0,0,400,280)
	WND_TYPE:SetAddImageRect(BK_TYPE.id, 0, 0, 400, 280, 0 ,0, 400, 280)
	WND_TYPE:AddImage(path_hero.."arrow_hero.png",386,18,32,128)
	local TYPEBTN_CLOSE = WND_TYPE:AddButton(path_hero.."closesmall1_hero.png",path_hero.."closesmall2_hero.png",path_hero.."closesmall3_hero.png",372,8,32,32)
	TYPEBTN_CLOSE.script[XE_LBUP] = function()
		XClickPlaySound(5)
		WND_TYPE:SetVisible(0)
		BTN_TYPE:SetCheckButtonClicked(0)
	end
	WND_TYPE:AddFont("技能",12,0,18,40,100,20,0xbeb5ee)
	WND_TYPE:AddFont("属性",12,0,18,112,100,20,0xbeb5ee)
	WND_TYPE:AddFont("竞技",12,0,285,60,100,20,0xbeb5ee)
	WND_TYPE:AddFont("出战             场",11,0,305,80,100,20,0xbeb5ee)
	WND_TYPE:AddFont("获胜             场",11,0,305,100,100,20,0xbeb5ee)
	
	WND_TYPE:AddFont("战场",12,0,285,130,100,20,0xbeb5ee)
	WND_TYPE:AddFont("出战             场",11,0,305,150,100,20,0xbeb5ee)
	WND_TYPE:AddFont("获胜             场",11,0,305,170,100,20,0xbeb5ee)
	
	WND_TYPE:AddFont("排位",12,0,285,200,100,20,0xbeb5ee)
	WND_TYPE:AddFont("出战             场",11,0,305,220,100,20,0xbeb5ee)
	WND_TYPE:AddFont("获胜             场",11,0,305,240,100,20,0xbeb5ee)
	GameFont[1] = WND_TYPE:AddFont("9999",11,0,335,80,100,20,0xbeb5ee)
	GameFont[2] = WND_TYPE:AddFont("666",11,0,335,100,100,20,0xbeb5ee)
	GameFont[3] = WND_TYPE:AddFont("88",11,0,335,150,100,20,0xbeb5ee)
	GameFont[4] = WND_TYPE:AddFont("5",11,0,335,170,100,20,0xbeb5ee)
	GameFont[5] = WND_TYPE:AddFont("7777",11,0,335,220,100,20,0xbeb5ee)
	GameFont[6] = WND_TYPE:AddFont("0",11,0,335,240,100,20,0xbeb5ee)
	local Font_TYPE = {"生命","攻击","法术","团队","操作"}
	
	
	
	m_stNum = {5,5,5,5,5}
	m_skillPic = {path_start.."herohead_start.png",path_start.."herohead_start.png",path_start.."herohead_start.png",path_start.."herohead_start.png",path_start.."herohead_start.png"}
	m_skillDis = {"斯塔克","斯塔克","斯塔克","斯塔克","斯塔克"}
	for i = 1,5 do
		WND_TYPE:AddImage(path_hero.."WAKEBTN1_hero.png",12,105+28*i,46,21)
		WND_TYPE:AddFont(Font_TYPE[i],12,0,18,107+28*i,100,12,0xbeb5ee)
		
		WND_TYPE:AddImage(path_hero.."PTBK_hero.png",65,110+28*i,256,8)
		WND_TYPE:AddImage(path.."friend4_hall.png",246,105+28*i,32,32)
		NUM_stlife[i] = WND_TYPE:AddFont(m_stNum[i],12,0,246,106+28*i,100,12,0xbeb5ee)
		for k =1,10 do
			COL_stlife[10*i-10+k] = WND_TYPE:AddImage(path_hero.."PT"..i.."_hero.png",45+k*18,110+28*i,32,16)
			COL_stlife[10*i-10+k]:SetVisible(0)
		end
		for k =1,m_stNum[i] do
			COL_stlife[10*i-10+k]:SetVisible(1)
		end
			
		IMG_skill[i] = WND_TYPE:AddImage(path_equip.."bag_equip.png",55*i-42,60,50,50)
		WND_TYPE:AddImage(path_shop.."iconside_shop.png",55*i-44,58,54,54)
	end
	
	WND_TYPE:AddImage(path_hero.."herotypeBK_hero.png",10,10,128,32)
	WND_TYPE:AddImage(path_hero.."herotypeBK_hero.png",270,10,128,32)
	HeroType = WND_TYPE:AddFont("法师、辅助",15,0,15,14,100,20,0x95f9fd)
	WND_TYPE:AddFont("胜率",15,0,275,14,100,20,0x95f9fd)
	HeroWinPercent = WND_TYPE:AddFont("10/100",15,0,310,14,100,20,0xbeb5ee)
	WND_TYPE:SetVisible(0)

	-- 技能
	WND_SKILL = CreateWindow(wnd.id, 540, 190, 400, 280)
	local BK_SKILL = WND_SKILL:AddImage(path_hero.."BK2_hero.png",0,0,400,280)
	WND_SKILL:SetAddImageRect(BK_SKILL.id, 0, 0, 400, 280, 0 ,0, 400, 280)
	WND_SKILL:AddImage(path_hero.."arrow_hero.png",386,58,32,128)
	local SKILLBTN_CLOSE = WND_SKILL:AddButton(path_hero.."closesmall1_hero.png",path_hero.."closesmall2_hero.png",path_hero.."closesmall3_hero.png",372,8,32,32)
	SKILLBTN_CLOSE.script[XE_LBUP] = function()
		XClickPlaySound(5)
		WND_SKILL:SetVisible(0)
		BTN_SKILL:SetCheckButtonClicked(0)
	end
	
	for i = 1,5 do
		BTN_SkillPic[i] = WND_SKILL:AddImage(m_skillPic[i],14,52*i-38,46,46)
		WND_SKILL:AddImage(path_shop.."iconside_shop.png",12,52*i-40,50,50)		
		WND_SKILL:AddImage(path_hero.."skilldis_hero.png",67,52*i-44,303,57)
		FONT_skillname[i] = WND_SKILL:AddFont("技能名称",11,0,75,52*i-38,285,20,0x95f9fd)
		FONT_skilldis[i] = WND_SKILL:AddFont("技能描述",11,0,75,52*i-24,281,45,0xbeb5ee)
		WND_SKILL:AddFont(NQWER[i],11,0,335,52*i-36,30,20,0x62f4f4)
	end

	WND_SKILL:SetVisible(0)
	
	-- 信息
	local FONTLIST_FILE = {" 生命值"," 魔法值","物理攻击","法术强度","物理防御","魔法抗性","暴       击","攻击速度","攻击范围","移动速度"}
	
	WND_FILE = CreateWindow(wnd.id, 540, 190, 400, 280)
	local BK_FILE = WND_FILE:AddImage(path_hero.."BK2_hero.png",0,0,400,280)
	WND_FILE:SetAddImageRect(BK_FILE.id, 0, 0, 400, 280, 0 ,0, 400, 280)
	WND_FILE:AddImage(path_hero.."arrow_hero.png",386,138,32,128)
	local FILEBTN_CLOSE = WND_FILE:AddButton(path_hero.."closesmall1_hero.png",path_hero.."closesmall2_hero.png",path_hero.."closesmall3_hero.png",372,8,32,32)
	FILEBTN_CLOSE.script[XE_LBUP] = function()
		XClickPlaySound(5)
		WND_FILE:SetVisible(0)
		BTN_FILE:SetCheckButtonClicked(0)
	end
	WND_FILE:AddFont("英雄信息",15,0,12,12,100,15,0xbeb5ee)
	WND_FILE:AddImage(path_hero.."fileBK_hero.png",7,38,358,17)
	WND_FILE:AddImage(path_hero.."fileBK_hero.png",7,74,358,17)
	WND_FILE:AddImage(path_hero.."fileBK_hero.png",7,110,358,17)
	WND_FILE:AddImage(path_hero.."fileBK3_hero.png",7,135,363,130)
	FONT_FILE = WND_FILE:AddFont("英雄介绍卡卡卡卡",12,0,14,140,350,120,0xbeb5ee)
	FONT_FILE:SetFontScissorRect(554,330,350,115)

	baseNum = {99,88,77,66,55,44,33,32,22,11}
	levelUpNum = {10,8,7,0,6,0,0,5,0,0}
	for i=1,10 do
		local index = math.ceil(i/2)
		if i%2 == 1 then
			WND_FILE:AddFont(FONTLIST_FILE[i],11,0,12,20+index*18,100,11,0xbeb5ee)
			FONT_baseNum[i] = WND_FILE:AddFont(baseNum[i],11,0,90,20+index*18,100,11,0xb6aedf)
			FONT_levelUpNum[i] = WND_FILE:AddFont("+"..levelUpNum[i],11,0,135,20+index*18,100,11,0x62f4f4)
		else
			WND_FILE:AddFont(FONTLIST_FILE[i],11,0,182,20+index*18,100,11,0xbeb5ee)
			FONT_baseNum[i] = WND_FILE:AddFont(baseNum[i],11,0,260,20+index*18,100,11,0xb6aedf)
			FONT_levelUpNum[i] = WND_FILE:AddFont("+"..levelUpNum[i],11,0,305,20+index*18,100,11,0x62f4f4)
		end
	end
	-- 信息窗口 滑动条、滑动键		
	local FILE_toggleImg = WND_FILE:AddImage(path.."toggleBK_main.png",372,54,16,190)
	FILE_togglebtn = FILE_toggleImg:AddButton(path.."toggleBTN1_main.png",path.."toggleBTN2_main.png",path.."toggleBTN3_main.png",0,0,16,50)
	local ToggleT = FILE_toggleImg:AddImage(path.."TD1_main.png",0,-16,16,16)
	local ToggleD = FILE_toggleImg:AddImage(path.."TD1_main.png",0,190,16,16)
	
	Li,Ti = FONT_FILE:GetPosition()
	XSetWindowFlag(FILE_togglebtn.id,1,1,0,140)
	FILE_togglebtn:ToggleBehaviour(XE_ONUPDATE, 1)
	FILE_togglebtn:ToggleEvent(XE_ONUPDATE, 1)
	FILE_togglebtn.script[XE_ONUPDATE] = function()
		if FILE_togglebtn._T == nil then
			FILE_togglebtn._T = 0
		end
		local L,T = FILE_togglebtn:GetPosition()	
		if FILE_togglebtn._T ~= T then	
			FONT_FILE:SetPosition(Li-540,Ti-T+56)		
			FILE_togglebtn._T = T
		end
	end	
	WND_FILE:SetVisible(0)
	
	-- 战场背包
	WND_BAG = CreateWindow(wnd.id, 540, 190, 400, 280)
	local BK_SKILL = WND_BAG:AddImage(path_hero.."BK2_hero.png",0,0,400,280)
	OnlyEquip_BG = WND_BAG:AddImage(path_hero.."bagBK_hero.png", -126, 0, 128, 280)
	WND_BAG:SetAddImageRect(BK_SKILL.id, 0, 0, 400, 280, 0 ,0, 400, 280)
	WND_BAG:AddImage(path_hero.."arrow_hero.png",386,178,32,128)
	local BAGBTN_CLOSE = WND_BAG:AddButton(path_hero.."closesmall1_hero.png",path_hero.."closesmall2_hero.png",path_hero.."closesmall3_hero.png",372,8,32,32)
	BAGBTN_CLOSE.script[XE_LBUP] = function()
		XClickPlaySound(5)
		WND_BAG:SetVisible(0)
		BTN_BAG:SetCheckButtonClicked(0)
	end
		
	BagDefault = WND_BAG:AddFont("默认套装",15,0,15,10,200,15,0x62f4f4)
	BagChoiceA = WND_BAG:AddFont("扩展套装1",15,0,15,100,200,15,0x62f4f4)
	BagChoiceB = WND_BAG:AddFont("扩展套装2",15,0,15,190,200,15,0x62f4f4)
	-- BagTimeA = WND_BAG:AddFont("2015年11月17日10点50分",12,0,190,101,200,15,0x62f4f4)
	-- BagTimeB = WND_BAG:AddFont("2015年11月27日10点55分",12,0,190,191,200,15,0x62f4f4)
	
	BagBtnDefault = WND_BAG:AddButton(path_hero.."WAKEBTN1_hero.png",path_hero.."WAKEBTN2_hero.png",path_hero.."WAKEBTN3_hero.png",346,60-7,46,21)
	BagBtnDefault:AddFont("应用",12,0,6,2,100,12,0xbeb5ee)
	BagBtnA = WND_BAG:AddButton(path_hero.."WAKEBTN1_hero.png",path_hero.."WAKEBTN2_hero.png",path_hero.."WAKEBTN3_hero.png",346,150-7,46,21)
	BagBtnA:AddFont("应用",12,0,6,2,100,12,0xbeb5ee)
	BagBtnB = WND_BAG:AddButton(path_hero.."WAKEBTN1_hero.png",path_hero.."WAKEBTN2_hero.png",path_hero.."WAKEBTN3_hero.png",346,240-7,46,21)
	BagBtnB:AddFont("应用",12,0,6,2,100,12,0xbeb5ee)
	
	BagBtnDefault.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickApplyButton_HeroEquip(0)
	end
	BagBtnA.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickApplyButton_HeroEquip(1)
	end
	BagBtnB.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickApplyButton_HeroEquip(2)
	end
	
	for i=1,6 do
		local posx = 55*i-40
		local posy = 37
		
		BagDefaultInfo[i] = WND_BAG:AddImage(path_equip.."bag_equip.png",posx,posy,50,50)
		WND_BAG:AddImage(path_shop.."iconside_shop.png",posx-2,posy-2,54,54)		
	end
	for i=1,6 do
		local posx = 55*i-40
		local posy = 127
		
		BagChoiceAInfo[i] = WND_BAG:AddImage(path_equip.."bag_equip.png",posx,posy,50,50)
		WND_BAG:AddImage(path_shop.."iconside_shop.png",posx-2,posy-2,54,54)	
	end
	for i=1,6 do
		local posx = 55*i-40
		local posy = 217
		
		BagChoiceBInfo[i] = WND_BAG:AddImage(path_equip.."bag_equip.png",posx,posy,50,50)
		WND_BAG:AddImage(path_shop.."iconside_shop.png",posx-2,posy-2,54,54)	
	end
	
	-- 英雄专属
	OnlyEquipFont = WND_BAG:AddFont("套装.大话",15,8,126,0,126,40,0x62f4f4)
	for i=1,4 do
		local posx = -87
		local posy = 58*i-20
		
		OnlyEquip[i] = WND_BAG:AddImage(path_equip.."bag_equip.png",posx,posy,50,50)
		OnlyEquip[i]:AddImage(path_shop.."iconside_shop.png",-2,-2,54,54)		
		
		OnlyEquip[i].script[XE_LBUP] = function()
			XClickIconBuyGroupListing_HeroEquip(OnlyEquipId[i])
		end
		
		OnlyEquip_State[i] = OnlyEquip[i]:AddImage(path_hero.."checkboxYes_hero.png", 14, 14, 32, 32)
		OnlyEquip_State[i]:SetVisible(0)
	end
	-- WND_BAG:AddFont("点击购买",12,8,135,-250,200,15,0xffffff)
	
	WND_BAG:SetVisible(0)
	
	
	-- 定位、技能、觉醒、档案、战场背包
	BTN_TYPE = wnd:AddCheckButton(path_hero.."detail3_hero.png",path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",950,220,90,40)
	BTN_TYPE:AddFont("定位",15,0,25,10,100,15,0xbeb5ee)
	BTN_TYPE.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		XHeroDetailType(Current_HeroId)
		
		WND_TYPE:SetVisible(1)
		WND_SKILL:SetVisible(0)
		WND_WAKEUP:SetVisible(0)
		WND_FILE:SetVisible(0)
		WND_BAG:SetVisible(0)
		
		XSetHeroGrowthUpUiVisible(0, "")
		XClickHeroOnlyEquip(0, "")
		
		BTN_SKILL:SetCheckButtonClicked(0)
		if HaveHero >0 then 
			BTN_WAKEUP:SetCheckButtonClicked(0)
		end
		BTN_FILE:SetCheckButtonClicked(0)
		BTN_BAG:SetCheckButtonClicked(0)
	end
	BTN_SKILL = wnd:AddCheckButton(path_hero.."detail3_hero.png",path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",950,260,90,40)
	BTN_SKILL:AddFont("技能",15,0,25,10,100,15,0xbeb5ee)
	BTN_SKILL.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		XHeroDetailSkill(Current_HeroId)
		
		WND_TYPE:SetVisible(0)
		WND_SKILL:SetVisible(1)
		WND_WAKEUP:SetVisible(0)
		WND_FILE:SetVisible(0)
		WND_BAG:SetVisible(0)
		
		XSetHeroGrowthUpUiVisible(0, "")
		XClickHeroOnlyEquip(0, "")
		
		BTN_TYPE:SetCheckButtonClicked(0)
		if HaveHero >0 then 
			BTN_WAKEUP:SetCheckButtonClicked(0)
		end
		BTN_FILE:SetCheckButtonClicked(0)
		BTN_BAG:SetCheckButtonClicked(0)
	end
	BTN_WAKEUP = wnd:AddCheckButton(path_hero.."detail3_hero.png",path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",950,300,90,40)
	BTN_WAKEUP:AddFont("觉醒",15,0,25,10,100,15,0xbeb5ee)
	BTN_WAKEUP.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		WND_TYPE:SetVisible(0)
		WND_SKILL:SetVisible(0)
		WND_WAKEUP:SetVisible(1)
		WND_FILE:SetVisible(0)
		WND_BAG:SetVisible(0)
		
		XSetHeroGrowthUpUiVisible(1, HeroIconPath_GrowthUPUi)
		XClickHeroOnlyEquip(0, "")
		
		BTN_TYPE:SetCheckButtonClicked(0)
		BTN_SKILL:SetCheckButtonClicked(0)
		BTN_FILE:SetCheckButtonClicked(0)
		BTN_BAG:SetCheckButtonClicked(0)
	end
	BTN_FILE = wnd:AddCheckButton(path_hero.."detail3_hero.png",path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",950,340,90,40)
	BTN_FILE:AddFont("档案",15,0,25,10,100,15,0xbeb5ee)
	BTN_FILE.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		XHeroDetailFile(Current_HeroId)
		
		WND_TYPE:SetVisible(0)
		WND_SKILL:SetVisible(0)
		WND_WAKEUP:SetVisible(0)
		WND_FILE:SetVisible(1)
		WND_BAG:SetVisible(0)
		
		XSetHeroGrowthUpUiVisible(0, "")
		XClickHeroOnlyEquip(0, "")
		
		BTN_TYPE:SetCheckButtonClicked(0)
		BTN_SKILL:SetCheckButtonClicked(0)
		if HaveHero >0 then 
			BTN_WAKEUP:SetCheckButtonClicked(0)
		end
		BTN_BAG:SetCheckButtonClicked(0)
	end
	BTN_BAG = wnd:AddCheckButton(path_hero.."detail3_hero.png",path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",950,380,90,40)
	BTN_BAG:AddFont("背包",15,0,25,10,100,15,0xbeb5ee)
	BTN_BAG.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		WND_TYPE:SetVisible(0)
		WND_SKILL:SetVisible(0)
		WND_WAKEUP:SetVisible(0)
		WND_FILE:SetVisible(0)
		WND_BAG:SetVisible(1)
		
		XSetHeroGrowthUpUiVisible(0, "")
		XClickHeroOnlyEquip(1, HeroIconPath_GrowthUPUi)
		
		BTN_TYPE:SetCheckButtonClicked(0)
		BTN_SKILL:SetCheckButtonClicked(0)
		if HaveHero >0 then 
			BTN_WAKEUP:SetCheckButtonClicked(0)
		end
		BTN_FILE:SetCheckButtonClicked(0)
	end
	
	ICON_HEAD = wnd:AddImage(path_start.."herohead_start.png",1078,245,64,148)	-- 原来是256，暂时修改成148
	ICON_HEAD.script[XE_LBUP] = function()
		SKIN_EFFECT1:SetVisible(0)
		for i=1, 4 do
			SKIN_LISTL_BK[i]:SetVisible(0)
		end
		SKIN_LISTL_BK[5]:SetVisible(1)
		Skin_Listimg_Lv:SetVisible(0)
	end
	local ICON_BK = ICON_HEAD:AddImage(path_start.."icon7_start.png",-10,-10,86,170)
	ICON_BK:SetTouchEnabled(0)
	
	img_HeroPriceBg = wnd:AddImage(path_hero.."goldBK_hero.png", 900, 673-OffsetY1, 247, 30)
	-- 金币钻石图片
	img_money = wnd:AddImage(path_shop.."money_shop.png",950,670-OffsetY1,64,64)
	img_gold = wnd:AddImage(path_shop.."gold_shop.png",1036,670-OffsetY1,64,64)
	-- 折扣-90%
	PRICE_BK = wnd:AddImage(path_hero.."priceBK_hero.png",1000,635-OffsetY1,128,32)
	-- PRICE_BK:AddImage(path_shop.."gold_shop.png",10,-2,64,64)
	PRICE_BK:AddImage(path_hero.."goldBK_hero.png", 900, 673-OffsetY1, 247, 30)
	hero_goldSrc = PRICE_BK:AddFontEx("12590", 15, 0, 40, 4, 100, 16, 0x8adde5)
	-- hero_goldSrc:SetFontSpace(2,2)
	local DISCOUNT_BK = PRICE_BK:AddImage(path_hero.."discount_hero.png",-40,-15,64,64)
	hero_discount = DISCOUNT_BK:AddFont("-90%", 15, 0, 8, 15, 100, 15, 0xffffff)
	local PRICE_LINE = PRICE_BK:AddImage(path_hero.."priceline_hero.png",15,11,128,16)
	
	hero_money = wnd:AddFontEx("12950", 15, 0, 980, 675-OffsetY1, 200, 20, 0xe3e38d)
	-- hero_money:SetFontSpace(2,2)
	hero_goldDis = wnd:AddFontEx("12956", 15, 0, 1066, 675-OffsetY1, 200, 20, 0x8adde5)
	-- hero_goldDis:SetFontSpace(2,2)
	
	-- 购买英雄
	BTN_BUY = wnd:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png",950,700-OffsetY1,179,56)
	BTN_BUY:AddFont("购买英雄", 15, 8, 0, 0, 179, 56, 0xbeb9cf)
	BTN_BUY.script[XE_LBUP] = function()
		XClickPlaySound(5)
		-- SetShopItemBuyNameInfo( heroname_herodetail)
		XClickBuyHeroButton_herodetail(Current_HeroId)
	end
end

function InitMainGame_HeroDetailC(wnd)
	-- 最爱英雄设置已超过10位！
	WND_LOVENO = CreateWindow(wnd.id, 640, 170, 295, 165)
	local BK_TYPE = WND_LOVENO:AddImage(path_hero.."LOVEBK_hero.png",0,0,296,167)
	WND_LOVENO:SetAddImageRect(BK_TYPE.id, 0, 0, 295, 165, 0 ,0, 295, 165)
	
	WND_LOVENO:AddFont("最爱英雄设置已超过10位!",15,0,65,25,200,20,0xa7a7e8)
	WND_LOVENO:AddFont("点击红心可取消最爱设置!",15,0,65,55,200,20,0xa7a7e8)
	local BTN_LOVEYES2 = WND_LOVENO:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",108,100,90,40)
	BTN_LOVEYES2:AddFont("确定",15,8,0,0,90,40,0xffffff)
	BTN_LOVEYES2.script[XE_LBUP] = function()
		XClickPlaySound(5)
		WND_LOVENO:SetVisible(0)
	end
	WND_LOVENO:SetVisible(0)
end

-- 修改界面数据
function Change_HeroDetail(wnd, 
icon_head,
hero_name,
SkinAdressA,	-- 英雄第一个皮肤路径		
SkinAdressB,	
SkinAdressC,	
SkinAdressD,	
SkinNameA,		-- 英雄第一个皮肤名称
SkinNameB,
SkinNameC,
SkinNameD,
SkinPosxA,		-- 小皮肤的截取开始位置X
SkinPosxB,
SkinPosxC,
SkinPosxD,
SkinPosyA,		-- 小皮肤的截取开始位置y
SkinPosyB,		
SkinPosyC,	
SkinPosyD,	
SkinPoswA,		-- 小皮肤的截取w
SkinPoswB,		
SkinPoswC,		
SkinPoswD,		
SkinPoshA,		-- 小皮肤的截取h
SkinPoshB,		
SkinPoshC,	
SkinPoshD,
SkinHaveA,		-- 是否拥有皮肤
SkinHaveB,		
SkinHaveC,		
SkinHaveD,
SkinPriceA,		-- 皮肤钻石价格
SkinPriceB,	
SkinPriceC,
SkinPriceD,
skinlvA,
skinlvB,
skinlvC,
skinlvD,
skinRealID1,
skinRealID2,
skinRealID3,
skinRealID4,
getHero,
IsFavorite,
heroMoney,
heroGold,
heroDiscount,
cHeroId,
tip,
HeroWinCount,HeroAllCount
)

	-- HeroWinPercent:SetFontText( HeroWinCount .. "/" .. HeroAllCount, 0xbeb5ee)
	-- log("\nskinRealID1 = "..skinRealID1)
	SKIN_LISTL.SkinRealId[1] = skinRealID1
	SKIN_LISTL.SkinRealId[2] = skinRealID2
	SKIN_LISTL.SkinRealId[3] = skinRealID3
	SKIN_LISTL.SkinRealId[4] = skinRealID4
	SKIN_EFFECT1:SetVisible(0)

	-- 界面控制
	ReSetMemberState_herodetail()
	HaveHero = getHero
	Current_HeroId = cHeroId
	
	-- 英雄价格
	img_HeroPriceBg:SetVisible(0)
	BTN_BUY:SetVisible(0)
	if heroMoney==0 then
		img_money:SetVisible(0)
		hero_money:SetFontText("",0xe3e38d)
	else
		img_money:SetVisible(1)
		hero_money:SetFontText(heroMoney,0xe3e38d)
		img_money:SetPosition(1000, 670-OffsetY1)
		hero_money:SetPosition(1030, 678-OffsetY1)
		img_HeroPriceBg:SetVisible(1)
		BTN_BUY:SetVisible(1)
	end
	if heroGold==0 then
		img_gold:SetVisible(0)
		hero_goldDis:SetFontText("",0x8adde5)
	else
		if img_money:IsVisible() then
			img_gold:SetPosition(1036, 670-OffsetY1)
			hero_goldDis:SetPosition(1066, 678-OffsetY1)
			img_money:SetPosition(950, 670-OffsetY1)
			hero_money:SetPosition(980, 678-OffsetY1)
		else
			img_gold:SetPosition(1000, 670-OffsetY1)
			hero_goldDis:SetPosition(1030, 678-OffsetY1)
		end
		img_gold:SetVisible(1)
		hero_goldDis:SetFontText(heroGold*heroDiscount,0x8adde5)
		img_HeroPriceBg:SetVisible(1)
		BTN_BUY:SetVisible(1)
	end
	if heroDiscount == 1 then
		PRICE_BK:SetVisible(0)
	else
		PRICE_BK:SetVisible(1)
		hero_goldSrc:SetFontText(heroGold,0x8adde5)
		hero_discount:SetFontText((heroDiscount*(-100)).."%",0xffffff)
	end
	
	-- 英雄皮肤
	SKIN_LISTL.BK		= {SkinAdressA,SkinAdressB,SkinAdressC,SkinAdressD}
	SKIN_LISTL.NAME		= {SkinNameA,SkinNameB,SkinNameC,SkinNameD}
	SKIN_LISTL.HAVE		= {SkinHaveA,SkinHaveB,SkinHaveC,SkinHaveD}
	SKIN_LISTL.PRICE	= {SkinPriceA,SkinPriceB,SkinPriceC,SkinPriceD}
	SKIN_LISTL.SkinLv	= {skinlvA,skinlvB,skinlvC,skinlvD}

	SKIN_LISTL.POSX		= {SkinPosxA,SkinPosxB,SkinPosxC,SkinPosxD}
	SKIN_LISTL.POSY		= {SkinPosyA,SkinPosyB,SkinPosyC,SkinPosyD}
	SKIN_LISTL.POSW		= {SkinPoswA,SkinPoswB,SkinPoswC,SkinPoswD}
	SKIN_LISTL.POSH		= {SkinPoshA,SkinPoshB,SkinPoshC,SkinPoshD}
	-- log("\nx = SkinPosxA"..SkinPosxA)
	-- log("\ny = SkinPosxA"..SkinPosyA)
	-- log("\ny = SkinPosxw"..SkinPoswA)
	-- log("\ny = SkinPosxh"..SkinPoshA)
	for i=1, 4 do
		SKIN_LISTL_BTN[i]:SetVisible(0)
	end
	SKIN_LISTL_BK[5].changeimage(path_hero.."ffffff_hero.png")
	-- SKIN_LISTL_BK[5]:SetAddImageRect(SKIN_LISTL_BK[5].id, 0, 0, 1280, 800, 0 ,0, 1280, 800)
	for i=1,4 do
		if FindHeroHeadIcon(cHeroId) then
			SKIN_LISTL_BK[5].changeimage("..\\UI\\hero\\"..cHeroId..".png")
			-- log("\nSKIN_LISTL_BK moren  ".."..\\UI\\hero\\"..cHeroId..".png")
			-- SKIN_LISTL_BK[5]:SetAddImageRect(SKIN_LISTL_BK[5].id, 0, 0, 1280, 800, 0 ,0, 1280, 800)
		end
		SKIN_LISTL_BK[i].changeimage(SKIN_LISTL.BK[i])
		
		-- log("\nSKIN_LISTL_BK  "..SKIN_LISTL.BK[i])
		-- SKIN_LISTL_BK[i]:SetAddImageRect(SKIN_LISTL_BK[i].id, 0, 0, 1280, 800, 0 ,0, 1280, 800)
		SKIN_LISTL_BTN[i]:SetVisible(1)
		if SKIN_LISTL.BK[i] == "" then
			SKIN_LISTL_BTN[i]:SetVisible(0)
		end
		SKIN_LISTL_NAME[i]:SetFontText(SKIN_LISTL.NAME[i],0xffffff)
		SKIN_LISTL_PRICE[i]:SetFontText(SKIN_LISTL.PRICE[i],0xffffff)
		if SKIN_LISTL.HAVE[i] == 1 then
			SKIN_LISTL_HAVE[i]:SetFontText("已拥有",0x22b14c)
			SKIN_LISTL_BUY[i]:SetVisible(0)
		else
			SKIN_LISTL_HAVE[i]:SetFontText("未拥有",0xff0000)
			SKIN_LISTL_BUY[i]:SetVisible(1)
		end
		
		if SKIN_LISTL.PRICE[i]==998 then
			SKIN_LISTL_BUY[i]:SetVisible(0)
		end
		SKIN_LISTL_BTN[i].changeimage(SKIN_LISTL.BK[i])
		SKIN_LISTL_BTN[i]:SetAddImageRect(SKIN_LISTL_BTN[i].id, SKIN_LISTL.POSX[i], SKIN_LISTL.POSY[i], SKIN_LISTL.POSW[i]+SKIN_LISTL.POSX[i], SKIN_LISTL.POSH[i]+SKIN_LISTL.POSY[i], SKIN_LISTL.POSXS[i] ,555-OffsetY1, 110, 170)
	end
	
	-- 小皮肤截图	
	SKIN_LISTL_BK[1]:SetVisible(0)
	SKIN_LISTL_BK[2]:SetVisible(0)
	SKIN_LISTL_BK[3]:SetVisible(0)
	SKIN_LISTL_BK[4]:SetVisible(0)
	SKIN_LISTL_BK[5]:SetVisible(1)
	
	ICON_HEAD.changeimage(icon_head)
	ICON_HEAD:SetImageTip(tip)
	HeroIconPath_GrowthUPUi = icon_head
	heroname_herodetail = hero_name
	FONT_hero_name:SetFontText(hero_name,0x95f9fd)
	FONT_hero_name1:SetFontText(hero_name,0x95f9fd)
	FONT_FILE:SetFontText(strHeroDesc,0xbeb5ee)
	
	-- 是否拥有次英雄决定购买和觉醒按钮
	if HaveHero >0 then
		BTN_BUY:SetEnabled(0)
		BTN_WAKEUP:SetEnabled(1)
		-- for i=1,4 do		
			-- SkinHaveBK[i]:SetVisible(0)
		-- end
	else
		BTN_BUY:SetEnabled(1)
		BTN_WAKEUP:SetEnabled(0)
		for i=1,4 do
			SKIN_LISTL_HAVE[i]:SetFontText("未拥有该英雄",0xff0000)
			-- SkinHaveBK[i]:SetVisible(1)
		end
	end
	
	if IsFavorite>0 then
		NAME_LOVEYES:SetVisible(1)
	else
		NAME_LOVEYES:SetVisible(0)
	end
end

function Redraw_Wakeup(
lvHP,
lvMP,
lvArmor,
lvMagicArmor,
lvAttack,
lvMagicAttack,
lvCoolDown,
lvAttackSpeed,
lvMoveSpeed,
lvArmorPena,
lvMagicArmorPena,
pwHP,
pwMP,
pwArmor,
pwMagicArmor,
pwAttack,
pwMagicAttack,
pwCoolDown,
pwAttackSpeed,
pwMoveSpeed,
pwArmorPena,
pwMagicArmorPena,
AddHP,
AddMP,
AddArmor,
AddMagicArmor,
AddAttack,
AddMagicAttack,
AddCoolDown,
AddAttackSpeed,
AddMoveSpeed,
AddArmorPena,
AddMagicArmorPena,
PlusHP,
PlusMP,
PlusArmor,
PlusMagicArmor,
PlusAttack,
PlusMagicAttack,
PlusCoolDown,
PlusAttackSpeed,
PlusMoveSpeed,
PlusArmorPena,
PlusMagicArmorPena,

Getwakeup,			-- 是否觉醒
MaxPoint			-- 最大觉醒点
)


	lvHP = string.format("%d",lvHP)				
	lvMP = string.format("%d",lvMP)				
	lvArmor = string.format("%.2f",lvArmor)
	lvMagicArmor = string.format("%.2f",lvMagicArmor)
	lvAttack = string.format("%.2f",lvAttack)
	lvMagicAttack = string.format("%.2f",lvMagicAttack)
	lvCoolDown = string.format("%.2f",lvCoolDown)
	lvAttackSpeed = string.format("%.2f",lvAttackSpeed)
	lvMoveSpeed = string.format("%.2f",lvMoveSpeed)
	lvArmorPena = string.format("%.2f",lvArmorPena)
	lvMagicArmorPena = string.format("%.2f",lvMagicArmorPena)

	pwHP = string.format("%d",pwHP)				
	pwMP = string.format("%d",pwMP)				
	pwArmor = string.format("%d",pwArmor)
	pwMagicArmor = string.format("%d",pwMagicArmor)
	pwAttack = string.format("%d",pwAttack)
	pwMagicAttack = string.format("%d",pwMagicAttack)
	pwCoolDown = string.format("%d",pwCoolDown)
	pwAttackSpeed = string.format("%d",pwAttackSpeed)
	pwMoveSpeed = string.format("%d",pwMoveSpeed)
	pwArmorPena = string.format("%d",pwArmorPena)
	pwMagicArmorPena = string.format("%d",pwMagicArmorPena)
	
	-- AddHP = string.format("%d",AddHP)				
	-- AddMP = string.format("%d",AddMP)				
	-- AddArmor = string.format("%d",AddArmor)
	-- AddMagicArmor = string.format("%d",AddMagicArmor)
	-- AddAttack = string.format("%d",AddAttack)
	-- AddMagicAttack = string.format("%d",AddMagicAttack)
	-- AddCoolDown = string.format("%d",AddCoolDown)
	-- AddAttackSpeed = string.format("%d",AddAttackSpeed)
	-- AddMoveSpeed = string.format("%d",AddMoveSpeed)
	-- AddArmorPena = string.format("%d",AddArmorPena)
	-- AddMagicArmorPena = string.format("%d",AddMagicArmorPena)
	
	-- PlusHP = string.format("%d",PlusHP)				
	-- PlusMP = string.format("%d",PlusMP)				
	-- PlusArmor = string.format("%d",PlusArmor)
	-- PlusMagicArmor = string.format("%d",PlusMagicArmor)
	-- PlusAttack = string.format("%d",PlusAttack)
	-- PlusMagicAttack = string.format("%d",PlusMagicAttack)
	-- PlusCoolDown = string.format("%d",PlusCoolDown)
	-- PlusAttackSpeed = string.format("%d",PlusAttackSpeed)
	-- PlusMoveSpeed = string.format("%d",PlusMoveSpeed)
	-- PlusArmorPena = string.format("%d",PlusArmorPena)
	-- PlusMagicArmorPena = string.format("%d",PlusMagicArmorPena)

	NUM_WAKEGROW = {lvHP,lvMP,lvArmor,lvMagicArmor,lvAttack,lvMagicAttack,lvCoolDown,lvAttackSpeed,lvMoveSpeed,lvArmorPena,lvMagicArmorPena}								--成长值
	NUM_WAKESTPT = {pwHP,pwMP,pwArmor,pwMagicArmor,pwAttack,pwMagicAttack,pwCoolDown,pwAttackSpeed,pwMoveSpeed,pwArmorPena,pwMagicArmorPena}
	local BTN_WAKEADD = {AddHP,AddMP,AddArmor,AddMagicArmor,AddAttack,AddMagicAttack,AddCoolDown,AddAttackSpeed,AddMoveSpeed,AddArmorPena,AddMagicArmorPena}
	local BTN_WAKEPLUS = {PlusHP,PlusMP,PlusArmor,PlusMagicArmor,PlusAttack,PlusMagicAttack,PlusCoolDown,PlusAttackSpeed,PlusMoveSpeed,PlusArmorPena,PlusMagicArmorPena}
	for i=1,11 do
		WND_WAKEGROW_FONT[i]:SetFontText(NUM_WAKEGROW[i],0xbeb5ee)
		WND_WAKESTPT_FONT[i]:SetFontText(NUM_WAKESTPT[i],0xbeb5ee)
	end
	local Point_wk = MaxPoint-pwHP-pwMP-pwArmor-pwMagicArmor-pwAttack-pwMagicAttack-pwCoolDown-pwAttackSpeed-pwMoveSpeed-pwArmorPena-pwMagicArmorPena
	left_point:SetFontText(Point_wk,0x6ffefc)
	
	if Getwakeup >0 then
		btn_wakeupp:SetVisible(0)
		btn_Advice:SetVisible(1)
		btn_Yes:SetVisible(1)
		btn_Cancel:SetVisible(1)
					
		for index,value in pairs(WND_WAKEADD_BTN) do
			WND_WAKEADD_BTN[index]:SetVisible(1)
			WND_WAKEPLUS_BTN[index]:SetVisible(1)
	
			if BTN_WAKEADD[index] >0 then
				WND_WAKEADD_IMG[index]:SetVisible(0)	
			else
				WND_WAKEADD_IMG[index]:SetVisible(1)	
			end
			if BTN_WAKEPLUS[index] >0 then
				WND_WAKEPLUS_IMG[index]:SetVisible(0)	
			else
				WND_WAKEPLUS_IMG[index]:SetVisible(1)	
			end
		end
	else
		btn_wakeupp:SetVisible(1)
		btn_Advice:SetVisible(0)
		btn_Yes:SetVisible(0)
		btn_Cancel:SetVisible(0)
		
		for index,value in pairs(WND_WAKEADD_BTN) do
			WND_WAKEADD_BTN[index]:SetVisible(0)
			WND_WAKEPLUS_BTN[index]:SetVisible(0)
		end
	end
end

-- 英雄装备 推荐装备
function ClearHeroEquipBuy_HeroEquip()
	OnlyEquipId = {}
	OnlyEquipFont:SetVisible(0)
	for i = 1, 4 do
		OnlyEquip[i]:SetVisible(0)
	end
	OnlyEquip_BG:SetVisible(0)
end
function Redraw_HeroOnlyEquipName(OnlyName)
	OnlyEquipFont:SetFontText(OnlyName,0x62f4f4)
	OnlyEquipFont:SetVisible(1)
end
function SendData_HeroOnlyEquip( PictureName, Id, index, IsBuy)
	OnlyEquip_BG:SetVisible(1)
	OnlyEquip[index+1]:SetVisible(1)
	OnlyEquip[index+1].changeimage("..\\"..PictureName)
	OnlyEquipId[index+1] = Id
	-- OnlyEquip[index+1]:SetVisible(1)
	if IsBuy == true or IsBuy == 1 then
		-- 已经购买
	else
		-- 未购买
	end
end

function SetHeroOnlyEquipTip( cTip, cindex)
	XSetImageTip(OnlyEquip[cindex+1].id, cTip)
end

-- 英雄装备 默认套装、扩展套装1、扩展套装2
function Clear_HeroDefaultEquip()
	HeroDefaultEquip = {}
	HeroDefaultEquip.PictureName = {}
	HeroDefaultEquip.Id = {}
	Clear_HeroFirstEquip()
	Clear_HeroSecondEquip()
end
function Clear_HeroFirstEquip()
	HeroFirstEquip = {}
	HeroFirstEquip.PictureName = {}
	HeroFirstEquip.Id = {}
end
function Clear_HeroSecondEquip()
	HeroSecondEquip = {}
	HeroSecondEquip.PictureName = {}
	HeroSecondEquip.Id = {}
end
function Redraw_HeroFightEquipName(NameDefault,NameA,NameB,BtnDefault,BtnA,BtnB)
	BagDefault:SetFontText(NameDefault,0x62f4f4)
	BagChoiceA:SetFontText(NameA,0x62f4f4)
	BagChoiceB:SetFontText(NameB,0x62f4f4)
	
	if BtnDefault==1 then
		-- 设置应用是否可以点击
	elseif BtnA==1 then
		-- 设置应用是否可以点击
	elseif BtnB==1 then
		-- 设置应用是否可以点击
	end
end

function SetHeroEquipGroupListingName( cName, cIndex)
	if cIndex==0 then
		BagDefault:SetFontText( cName, 0x62f4f4)
	elseif cIndex==1 then
		BagChoiceA:SetFontText( cName, 0x62f4f4)
	elseif cIndex==2 then
		BagChoiceB:SetFontText( cName, 0x62f4f4)
	end
	
end

-- 英雄套装第一行
function SendData_HeroDefaultEquip(PictureName,Id,index,ctip)
	if PictureName == "" then
		BagDefaultInfo[index+1]:SetVisible(0)
	else
		BagDefaultInfo[index+1]:SetVisible(1)
		HeroDefaultEquip.PictureName[index+1] = "..\\"..PictureName
		HeroDefaultEquip.Id[index+1] = Id
		BagDefaultInfo[index+1].changeimage(HeroDefaultEquip.PictureName[index+1])
		BagDefaultInfo[index+1]:SetImageTip( ctip)
	end
end

-- 英雄套装第二行
function SendData_HeroFirstEquip(PictureName,Id,index,ctip)
	index = index-6
	if PictureName == "" then
		BagChoiceAInfo[index+1]:SetVisible(0)
	else
		BagChoiceAInfo[index+1]:SetVisible(1)
		HeroFirstEquip.PictureName[index+1] = "..\\"..PictureName
		HeroFirstEquip.Id[index+1] = Id
		BagChoiceAInfo[index+1].changeimage(HeroFirstEquip.PictureName[index+1])
		BagChoiceAInfo[index+1]:SetImageTip(ctip)
	end
end

-- 英雄套装第三行
function SendData_HeroSecondEquip(PictureName,Id,index,ctip)
	index = index-12
	if PictureName == "" then
		BagChoiceBInfo[index+1]:SetVisible(0)
	else
		BagChoiceBInfo[index+1]:SetVisible(1)
		HeroSecondEquip.PictureName[index+1] = "..\\"..PictureName
		HeroSecondEquip.Id[index+1] = Id
		BagChoiceBInfo[index+1].changeimage(HeroSecondEquip.PictureName[index+1])
		BagChoiceBInfo[index+1]:SetImageTip(ctip)
	end
end

function SetOkButtonState_HeroEquip( cIndex, cState)
	BagBtnDefault:SetEnabled(1)
	BagBtnA:SetEnabled(1)
	BagBtnB:SetEnabled(1)
	-- BagBtnDefaultUnEable:SetVisible(0)
	-- BagBtnAUnEable:SetVisible(0)
	-- BagBtnBUnEable:SetVisible(0)
	if cIndex == 0 then
		BagBtnDefault:SetEnabled(cState)
		-- BagBtnDefaultUnEable:SetVisible(TakeReverse(cState))
	elseif cIndex == 1 then
		BagBtnA:SetEnabled(cState)
		-- BagBtnAUnEable:SetVisible(TakeReverse(cState))
	elseif cIndex == 2 then
		BagBtnB:SetEnabled(cState)
		-- BagBtnBUnEable:SetVisible(TakeReverse(cState))
	end
end

-- 觉醒界面相关函数
-- 初始化UI
function ClearAllGrowthData()
	font_point = 0
	btn_wakeupp:SetVisible(1)
	btn_Advice:SetVisible(0)
	btn_Yes:SetVisible(0)
	btn_Cancel:SetVisible(0)
	for i=1, 11 do
		WND_WAKEADD_BTN[i]:SetVisible(0)
		WND_WAKEPLUS_BTN[i]:SetVisible(0)
		WND_WAKEADD_IMG[i]:SetVisible(0)
		WND_WAKEPLUS_IMG[i]:SetVisible(0)
	end
end

-- 是否拥有英雄
function IsHaveHero_HeroGrowthUp( cIsHave)
	-- 没用
end

-- 设置已加点数
function SetGrowthUpPoint( c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11)
	NUM_WAKESTPT[1] = c1
	WND_WAKESTPT_FONT[1]:SetFontText(NUM_WAKESTPT[1], 0xbeb5ee)
	NUM_WAKESTPT[2] = c2
	WND_WAKESTPT_FONT[2]:SetFontText(NUM_WAKESTPT[2], 0xbeb5ee)
	NUM_WAKESTPT[3] = c3
	WND_WAKESTPT_FONT[3]:SetFontText(NUM_WAKESTPT[3], 0xbeb5ee)
	NUM_WAKESTPT[4] = c4
	WND_WAKESTPT_FONT[4]:SetFontText(NUM_WAKESTPT[4], 0xbeb5ee)
	NUM_WAKESTPT[5] = c5
	WND_WAKESTPT_FONT[5]:SetFontText(NUM_WAKESTPT[5], 0xbeb5ee)
	NUM_WAKESTPT[6] = c6
	WND_WAKESTPT_FONT[6]:SetFontText(NUM_WAKESTPT[6], 0xbeb5ee)
	NUM_WAKESTPT[7] = c7
	WND_WAKESTPT_FONT[7]:SetFontText(NUM_WAKESTPT[7], 0xbeb5ee)
	NUM_WAKESTPT[8] = c8
	WND_WAKESTPT_FONT[8]:SetFontText(NUM_WAKESTPT[8], 0xbeb5ee)
	NUM_WAKESTPT[9] = c9
	WND_WAKESTPT_FONT[9]:SetFontText(NUM_WAKESTPT[9], 0xbeb5ee)
	NUM_WAKESTPT[10] = c10
	WND_WAKESTPT_FONT[10]:SetFontText(NUM_WAKESTPT[10], 0xbeb5ee)
	NUM_WAKESTPT[11] = c11
	WND_WAKESTPT_FONT[11]:SetFontText(NUM_WAKESTPT[11], 0xbeb5ee)
end

-- 设置成长属性
function SetGrowthUpChengZhangPoint( c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11)
	c3 = string.format("%.2f", c3)
	c4 = string.format("%.2f", c4)
	c5 = string.format("%.2f", c5)
	c6 = string.format("%.2f", c6)
	c7 = string.format("%.2f", c7)
	c8 = string.format("%.2f", c8)
	c9 = string.format("%.2f", c9)
	c10 = string.format("%.2f", c10)
	c11 = string.format("%.2f", c11)
	NUM_WAKEGROW[1] = c1
	WND_WAKEGROW_FONT[1]:SetFontText(NUM_WAKEGROW[1], FontColor[1])
	NUM_WAKEGROW[2] = c2
	WND_WAKEGROW_FONT[2]:SetFontText(NUM_WAKEGROW[2], FontColor[2])
	NUM_WAKEGROW[3] = c3
	WND_WAKEGROW_FONT[3]:SetFontText(NUM_WAKEGROW[3], FontColor[3])
	NUM_WAKEGROW[4] = c4
	WND_WAKEGROW_FONT[4]:SetFontText(NUM_WAKEGROW[4], FontColor[4])
	NUM_WAKEGROW[5] = c5
	WND_WAKEGROW_FONT[5]:SetFontText(NUM_WAKEGROW[5], FontColor[5])
	NUM_WAKEGROW[6] = c6
	WND_WAKEGROW_FONT[6]:SetFontText(NUM_WAKEGROW[6], FontColor[6])
	NUM_WAKEGROW[7] = c7
	WND_WAKEGROW_FONT[7]:SetFontText(NUM_WAKEGROW[7], FontColor[7])
	NUM_WAKEGROW[8] = c8
	WND_WAKEGROW_FONT[8]:SetFontText(NUM_WAKEGROW[8], FontColor[8])
	NUM_WAKEGROW[9] = c9
	WND_WAKEGROW_FONT[9]:SetFontText(NUM_WAKEGROW[9], FontColor[9])
	NUM_WAKEGROW[10] = c10
	WND_WAKEGROW_FONT[10]:SetFontText(NUM_WAKEGROW[10], FontColor[10])
	NUM_WAKEGROW[11] = c11
	WND_WAKEGROW_FONT[11]:SetFontText(NUM_WAKEGROW[11], FontColor[11])
end

-- 设置基础属性
function SetGrowthUpBasePoint( c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11)
	c1 = string.format("%d", c1)
	c2 = string.format("%d", c2)
	c3 = string.format("%d", c3)
	c4 = string.format("%d", c4)
	c5 = string.format("%d", c5)
	c6 = string.format("%d", c6)
	c7 = string.format("%d", c7)
	c8 = string.format("%d", c8)
	c9 = string.format("%d", c9)
	c10 = string.format("%d", c10)
	c11 = string.format("%d", c11)
	NUM_WAKEINIT[1] = c1
	WND_WAKEINIT_FONT[1]:SetFontText(NUM_WAKEINIT[1], 0xbeb5ee)
	NUM_WAKEINIT[2] = c2
	WND_WAKEINIT_FONT[2]:SetFontText(NUM_WAKEINIT[2], 0xbeb5ee)
	NUM_WAKEINIT[3] = c3
	WND_WAKEINIT_FONT[3]:SetFontText(NUM_WAKEINIT[3], 0xbeb5ee)
	NUM_WAKEINIT[4] = c4
	WND_WAKEINIT_FONT[4]:SetFontText(NUM_WAKEINIT[4], 0xbeb5ee)
	NUM_WAKEINIT[5] = c5
	WND_WAKEINIT_FONT[5]:SetFontText(NUM_WAKEINIT[5], 0xbeb5ee)
	NUM_WAKEINIT[6] = c6
	WND_WAKEINIT_FONT[6]:SetFontText(NUM_WAKEINIT[6], 0xbeb5ee)
	NUM_WAKEINIT[7] = c7
	WND_WAKEINIT_FONT[7]:SetFontText(NUM_WAKEINIT[7], 0xbeb5ee)
	NUM_WAKEINIT[8] = c8
	WND_WAKEINIT_FONT[8]:SetFontText(NUM_WAKEINIT[8], 0xbeb5ee)
	NUM_WAKEINIT[9] = c9
	WND_WAKEINIT_FONT[9]:SetFontText(NUM_WAKEINIT[9], 0xbeb5ee)
	NUM_WAKEINIT[10] = c10
	WND_WAKEINIT_FONT[10]:SetFontText(NUM_WAKEINIT[10], 0xbeb5ee)
	NUM_WAKEINIT[11] = c11
	WND_WAKEINIT_FONT[11]:SetFontText(NUM_WAKEINIT[11], 0xbeb5ee)
end

function SetOpenGrowthButtonState( cState)
	btn_wakeupp:SetVisible(cState)
end

function SetGrowthUpButtonThreeVisible( cState)
	btn_Advice:SetVisible(cState)
	btn_Yes:SetVisible(cState)
	btn_Cancel:SetVisible(cState)
	-- btn_Yes_UnEnable:SetVisible(cState)
	-- btn_Cancel_UnEnable:SetVisible(cState)
	SetJiaJianButtonVisible(cState)
end

function SetGrowthUpButtonOkCancelState( cState)
	if btn_wakeupp:IsVisible() == false then
		btn_Yes:SetEnabled(cState)
		btn_Cancel:SetEnabled(cState)
		-- btn_Yes_UnEnable:SetVisible(TakeReverse(cState))
		-- btn_Cancel_UnEnable:SetVisible(TakeReverse(cState))
	end
end

function SetJiaJianButtonVisible( cState)
	for i=1, 11 do
		WND_WAKEADD_BTN[i]:SetVisible(cState)
		WND_WAKEPLUS_BTN[i]:SetVisible(cState)
		WND_WAKEADD_IMG[i]:SetVisible(cState)
		WND_WAKEPLUS_IMG[i]:SetVisible(cState)
	end
end

function SetSurplusPoint( cPoint)
	font_point = cPoint
	left_point:SetFontText(font_point, 0x6ffefc)
end

function SetAddGrowthButtonState( c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11)
	if btn_wakeupp:IsVisible() == false then
		WND_WAKEADD_BTN[1]:SetVisible(c1)
		WND_WAKEADD_BTN[2]:SetVisible(c2)
		WND_WAKEADD_BTN[3]:SetVisible(c3)
		WND_WAKEADD_BTN[4]:SetVisible(c4)
		WND_WAKEADD_BTN[5]:SetVisible(c5)
		WND_WAKEADD_BTN[6]:SetVisible(c6)
		WND_WAKEADD_BTN[7]:SetVisible(c7)
		WND_WAKEADD_BTN[8]:SetVisible(c8)
		WND_WAKEADD_BTN[9]:SetVisible(c9)
		WND_WAKEADD_BTN[10]:SetVisible(c10)
		WND_WAKEADD_BTN[11]:SetVisible(c11)
		
		WND_WAKEADD_IMG[1]:SetVisible(TakeReverse(c1))
		WND_WAKEADD_IMG[2]:SetVisible(TakeReverse(c2))
		WND_WAKEADD_IMG[3]:SetVisible(TakeReverse(c3))
		WND_WAKEADD_IMG[4]:SetVisible(TakeReverse(c4))
		WND_WAKEADD_IMG[5]:SetVisible(TakeReverse(c5))
		WND_WAKEADD_IMG[6]:SetVisible(TakeReverse(c6))
		WND_WAKEADD_IMG[7]:SetVisible(TakeReverse(c7))
		WND_WAKEADD_IMG[8]:SetVisible(TakeReverse(c8))
		WND_WAKEADD_IMG[9]:SetVisible(TakeReverse(c9))
		WND_WAKEADD_IMG[10]:SetVisible(TakeReverse(c10))
		WND_WAKEADD_IMG[11]:SetVisible(TakeReverse(c11))
	end
end

function SetPlusGrowthButtonState( c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11)
	if btn_wakeupp:IsVisible() == false then
		WND_WAKEPLUS_BTN[1]:SetVisible(c1)
		WND_WAKEPLUS_BTN[2]:SetVisible(c2)
		WND_WAKEPLUS_BTN[3]:SetVisible(c3)
		WND_WAKEPLUS_BTN[4]:SetVisible(c4)
		WND_WAKEPLUS_BTN[5]:SetVisible(c5)
		WND_WAKEPLUS_BTN[6]:SetVisible(c6)
		WND_WAKEPLUS_BTN[7]:SetVisible(c7)
		WND_WAKEPLUS_BTN[8]:SetVisible(c8)
		WND_WAKEPLUS_BTN[9]:SetVisible(c9)
		WND_WAKEPLUS_BTN[10]:SetVisible(c10)
		WND_WAKEPLUS_BTN[11]:SetVisible(c11)
		
		WND_WAKEPLUS_IMG[1]:SetVisible(TakeReverse(c1))
		WND_WAKEPLUS_IMG[2]:SetVisible(TakeReverse(c2))
		WND_WAKEPLUS_IMG[3]:SetVisible(TakeReverse(c3))
		WND_WAKEPLUS_IMG[4]:SetVisible(TakeReverse(c4))
		WND_WAKEPLUS_IMG[5]:SetVisible(TakeReverse(c5))
		WND_WAKEPLUS_IMG[6]:SetVisible(TakeReverse(c6))
		WND_WAKEPLUS_IMG[7]:SetVisible(TakeReverse(c7))
		WND_WAKEPLUS_IMG[8]:SetVisible(TakeReverse(c8))
		WND_WAKEPLUS_IMG[9]:SetVisible(TakeReverse(c9))
		WND_WAKEPLUS_IMG[10]:SetVisible(TakeReverse(c10))
		WND_WAKEPLUS_IMG[11]:SetVisible(TakeReverse(c11))
	end
end

-- 觉醒界面相关函数完毕
function SetAllBuutonUnEnable_HeroEquip()
	BagBtnDefault:SetEnabled(0)
	BagBtnA:SetEnabled(0)
	BagBtnB:SetEnabled(0)
	-- BagBtnDefaultUnEable:SetVisible(1)
	-- BagBtnAUnEable:SetVisible(1)
	-- BagBtnBUnEable:SetVisible(1)
end

function SetOnlyEquipState_HeroEquip( cState, cIndex)
	OnlyEquip_State[cIndex+1]:SetVisible(cState)
end

function SetApplyButtonVisible_HeroEquip( cIndex)
	if cIndex==0 then
		BagBtnDefault:SetVisible(0)
		-- BagBtnDefaultUnEable:SetVisible(0)
	elseif cIndex==1 then
		BagBtnA:SetVisible(0)
		-- BagBtnAUnEable:SetVisible(0)
	elseif cIndex==2 then
		BagBtnB:SetVisible(0)
		-- BagBtnBUnEable:SetVisible(0)
	end
end

function FindHeroHeadIcon( cHeroId)
	for i = 1, #HeroHeadMMM do
		if HeroHeadMMM[i] == cHeroId then
			return true
		end
	end
	return false
end

-- 通信英雄定位
function SendData_HeroDetailType(m_type,m_heroWin,strPicN,strPicQ,strPicW,strPicE,strPicR,stLife,stAttack,stDefence,stSkill,stOperation,
TotalGameA,WinGameA,TotalGameB,WinGameB,TotalGameC,WinGameC,tipQ,tipW,tipE,tipR,tipN)
	m_stNum = {stLife,stAttack,stDefence,stSkill,stOperation}
	m_skillPic = {strPicN,strPicQ,strPicW,strPicE,strPicR}
	m_skillTip = {tipQ,tipW,tipE,tipR,tipN}
	for index,value in pairs(NUM_stlife) do
		NUM_stlife[index]:SetFontText(m_stNum[index],0xbeb5ee)
	end

	for index,value in pairs(COL_stlife) do
		COL_stlife[index]:SetVisible(0)
	end
	for i =1,5 do
		for k =1,m_stNum[i] do
			COL_stlife[10*i-10+k]:SetVisible(1)
		end
		IMG_skill[i].changeimage("..\\"..m_skillPic[i])
		IMG_skill[i]:SetImageTip(m_skillTip[i])
	end

	HeroType:SetFontText(m_type,0x95f9fd)
	HeroWinPercent:SetFontText(m_heroWin,0xbeb5ee)
	GameFont[1]:SetFontText(TotalGameA,0xbeb5ee)
	GameFont[2]:SetFontText(WinGameA,0xbeb5ee)
	GameFont[3]:SetFontText(TotalGameB,0xbeb5ee)
	GameFont[4]:SetFontText(WinGameB,0xbeb5ee)
	GameFont[5]:SetFontText(TotalGameC,0xbeb5ee)
	GameFont[6]:SetFontText(WinGameC,0xbeb5ee)

end

-- 通信英雄技能
function SendData_HeroDetailSkill(strPicN,strPicQ,strPicW,strPicE,strPicR,strNameN,strNameQ,strNameW,strNameE,strNameR,strDisN,strDisQ,strDisW,strDisE,strDisR,tipQ,tipW,tipE,tipR,tipN)
	m_skillPic = {strPicN,strPicQ,strPicW,strPicE,strPicR}
	m_skillName = {strNameN,strNameQ,strNameW,strNameE,strNameR}
	m_skillDis = {strDisN,strDisQ,strDisW,strDisE,strDisR}
	m_skillTip = {tipQ,tipW,tipE,tipR,tipN}
	for i =1,5 do
		BTN_SkillPic[i].changeimage("..\\"..m_skillPic[i])
		BTN_SkillPic[i]:SetImageTip(m_skillTip[i])
		FONT_skillname[i]:SetFontText(m_skillName[i],0x95f9fd)
		FONT_skilldis[i]:SetFontText(m_skillDis[i],0xbeb5ee)
	end
end

-- 通信英雄档案
function SendData_HeroDetailFile(strHeroDesc,
baseHP,baseMP,baseAttack,baseMagicAttack,baseArmor,baseMagicArmor,baseCritialHit,baseAttackSpeed,AttackRange,baseMoveSpeed,
levelUpHP,levelUpMP,levelUpAttack,levelUpMagicAttack,levelUpArmor,levelUpMagicArmor,levelUpCriticalHit,levelUpAttackSpeed,levelUpAttackRange,levelUpMoveSpeed)
	
	baseHP = string.format("%d",baseHP)				
	baseMP = string.format("%d",baseMP)				
	levelUpHP = string.format("%d",levelUpHP)	
	levelUpMP = string.format("%d",levelUpMP)		
	baseAttack = string.format("%d",baseAttack)		
	baseMagicAttack = string.format("%d",baseMagicAttack)	
	baseArmor = string.format("%d",baseArmor)							
	baseMagicArmor = string.format("%.1f",baseMagicArmor)				
	baseCritialHit = string.format("%.1f",baseCritialHit)				
	baseMoveSpeed = string.format("%d",baseMoveSpeed)
	levelUpMoveSpeed = string.format("%d",levelUpMoveSpeed)
	
	levelUpAttack = string.format("%.1f",levelUpAttack)
	levelUpArmor = string.format("%.1f",levelUpArmor)
	levelUpMagicArmor = string.format("%.1f",levelUpMagicArmor)
	baseAttackSpeed = string.format("%.2f",baseAttackSpeed)
	levelUpAttackSpeed = string.format("%.2f",levelUpAttackSpeed)
	AttackRange = string.format("%.2f",AttackRange)
	levelUpAttackRange= string.format("%.2f",levelUpAttackRange)
		
	baseNum = {baseHP,baseMP,baseAttack,baseMagicAttack,baseArmor,baseMagicArmor,baseCritialHit,baseAttackSpeed,AttackRange,baseMoveSpeed}
	levelUpNum = {levelUpHP,levelUpMP,levelUpAttack,levelUpMagicAttack,levelUpArmor,levelUpMagicArmor,levelUpCriticalHit,levelUpAttackSpeed,levelUpAttackRange,levelUpMoveSpeed}
	
	for i=1,10 do
		FONT_baseNum[i]:SetFontText(baseNum[i],0xb6aedf)
		FONT_levelUpNum[i]:SetFontText("+"..levelUpNum[i],0x62f4f4)
	end
	FONT_FILE:SetFontText(strHeroDesc,0xbeb5ee)
	
	FILE_togglebtn:SetAbsolutePosition(912,244)
	FONT_FILE:SetPosition(Li-540,Ti-188)	
			
end



-- 设置是否可见
function SetGameHeroDetailIsVisible(flag) 
	if g_game_heroDetail_ui ~= nil then
		if flag == 1 and g_game_heroDetail_ui:IsVisible() == false then
			SetGameHeroAllIsVisible(0)
			g_game_heroDetail_ui:SetVisible(1)
			for i = 1, #FontColor do
				FontColor[i] = 0xffbeb5ee
			end
			SetFourpartUIVisiable(0)
		elseif flag == 0 and g_game_heroDetail_ui:IsVisible() == true then
			g_game_heroDetail_ui:SetVisible(0)
		end
	end
end

function GetGameHeroDetailIsVisible()  
    if g_game_heroDetail_ui~=nil and g_game_heroDetail_ui:IsVisible()==true then
        return 1
    else
        return 0
    end
end

function BuySuccessRefesh_herodetail()
	if g_game_heroDetail_ui ~=nil and g_game_heroDetail_ui:IsVisible()==true then
		BTN_BUY:SetEnabled(0)
		BTN_WAKEUP:SetEnabled(1)
		HaveHero = 1
		for i=1,4 do
			if SKIN_LISTL_BUY[i]:IsVisible() then
				SKIN_LISTL_HAVE[i]:SetFontText("未拥有",0xff0000)
			end
		end
		return 1
	else
		return 0
	end
	
end

function RecoverHeroSkinInfo_herodetail( cCurSelIndex)
	if cCurSelIndex>0 then
		SKIN_LISTL_HAVE[cCurSelIndex]:SetFontText("已拥有",0x22b14c)
		SKIN_LISTL_BUY[cCurSelIndex]:SetVisible(0)
	end
end

function ReSetMemberState_herodetail()
	WND_LOVE:SetVisible(0)
	WND_LOVENO:SetVisible(0)
	WND_TYPE:SetVisible(0)
	WND_SKILL:SetVisible(0)
	WND_WAKEUP:SetVisible(0)
	WND_FILE:SetVisible(0)
	WND_BAG:SetVisible(0)
	BTN_TYPE:SetCheckButtonClicked(0)
	BTN_SKILL:SetCheckButtonClicked(0)
	BTN_WAKEUP:SetCheckButtonClicked(0)
	BTN_FILE:SetCheckButtonClicked(0)
	BTN_BAG:SetCheckButtonClicked(0)
	SetGameHeroDetailIsVisible(1)
end

function SetFontColor_growthup( iIndex, dwColor)
	FontColor[iIndex] = dwColor
end

-- 我的最爱数量是否封顶10
function ShowFavoriteCount(flag,left_count)
	WND_LOVE:SetVisible(flag)
	WND_LOVENO:SetVisible(1-flag)
	LOVE_count:SetFontText(left_count,0x95f9fd)
end

function ChangeBuyImage_HeroDetail( iType)
	if iType == 1 then
		img_money.changeimage( path_shop.."money_shop.png")
	elseif iType == 2 then
		img_money.changeimage( path_shop.."vippoint_shop.png")
	else
		img_money.changeimage( path_shop.."money_shop.png")
	end
end