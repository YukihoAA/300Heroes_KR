include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

-- 商品的最大数量
local Max_MarketGoods = 14
local Many = 0
-- 商店装备分类
local PyAttack = nil		-- 攻击装
local MgAttack = nil		-- 法术装
local Defence = nil			-- 防御装

local MoveSpeed = nil		-- 移动速度
local ExtraMoney = nil		-- 额外金钱
local GrowEquip = nil		-- 成长类
local ControlEquip = nil	-- 控制类
local BuffEquip = nil		-- 光环类
local Expendable = nil		-- 消耗品

local PyAttack_ui = nil
local MgAttack_ui = nil
local Defence_ui = nil

local PyAttack_kid = {}
local MgAttack_kid = {}
local Defence_kid = {}

local Equip_BtnFont = {"攻击装","法术装","防御装","移动速度","额外金钱","成长类","控制类","光环类","消耗品"}
local PyAttack_kidFont = {"攻击力","暴击率","攻击速度","护甲穿透","生命偷取"}
local MgAttack_kidFont = {"法术强度","冷却缩减","法力回复","法力值","法术穿透"}
local Defence_kidFont = {"生命值","护甲值","法术抗性","生命回复","韧性"}

local clickBtnA =nil
local clickFontA = nil
local PyAttack_clickBtnB = nil
local MgAttack_clickBtnB = nil
local Defence_clickBtnB = nil

local PyAttack_clickFontB = nil
local MgAttack_clickFontB = nil
local Defence_clickFontB = nil

local check_suggest = nil
local check_yes = nil
local check_talentYes = nil

-- 定义
local market_posx = {}
local market_posy = {}

local market_equip = {}
local market_hide = {}
local market_icon = {}
local market_name = {}
local market_money = {}

-- 选中的装备、划过的装备
local market_click = nil
local market_hover = nil
local click_index = 0

-- 炼金宝石的背景
local EquipUp_BK = nil
local Equip_Bag = {}
local Equip_BagSideClick = nil
local Equip_BagFlag = {}
local Equip_BagUp = {}
local Equip_BagUpHide = {}
local Equip_BagLayer = {}
	
local HDT_BK = nil		-- 滚动条
local HDT_BTN = nil

local Equip_SuggestBag = {}
local Equip_SuggestBagHide = {}
	
local Equip_current = nil
local Equip_currentFont = nil

local btn_suggest = nil
local btn_Left = nil
local btn_Right = nil

local Equip_canSyn = {}
local Equip_canSynHide = {}
local Equip_canSynHave = {}

local MarketSyn_ui = nil	
local market_max = {}
local market_maxHide = {}
local market_maxHave = {}
local market_maxClick = nil
local market_maxFont = {}
local market_maxPosX = {150,40,150,260,10,70,120,180,230,290}
local market_maxPosY = {30,105,105,105,180,180,180,180,180,180}

local lineA,lineB,lineC,lineD,lineE,lineF,lineG,lineH,lineI = nil
local my_money =nil
local btn_ReturnBack =nil
local btn_BuyEquip = nil
local btn_BuyEquipimg = nil

local btn_SellEquip = nil

local PersonalPick = nil   -- 用于响应自定义推荐Tip
local DefaultBtn = nil	   -- 用于响应恢复默认按钮Tip
local defaulttip = nil
	
-- 商店的道具表单
local Market_goods = {}
Market_goods.strName = {}
Market_goods.strPictureName = {}
Market_goods.money = {}
Market_goods.Id = {}
Market_goods.Enabled = {}
Market_goods.tip = {}

-- 自己的道具表单
local Self_goods = {}
Self_goods.strPictureName = {}
Self_goods.Id = {}	
Self_goods.Layer = {}

local Self_goodsUp = {}
Self_goodsUp.strPictureName = {}
Self_goodsUp.strPictureName1 = {}
Self_goodsUp.strPictureName2 = {}
Self_goodsUp.Id = {}

-- 推荐的道具表单
local Suggest_goods = {}
Suggest_goods.strName = {}
Suggest_goods.strPictureName = {}
Suggest_goods.Id = {}

-- 当前选中的装备
local Current_goodsPictureName = nil
local Current_goodsMoney = nil
local Current_goodsId = nil

-- 可以合成的装备栏
local CanSyn_goods = {}
CanSyn_goods.strName = {}
CanSyn_goods.strPictureName = {}
CanSyn_goods.Id = {}

-- 合成树的装备
local max_goods = {}
max_goods.strPictureName = {}
max_goods.money = {}
max_goods.Id = {}
max_goods.Enabled = {}

-- 窗口滚动
local updownCount = 0
local maxUpdown = 0
local suggestback = {}	
	
local pullPicMarket = {} 	-- 用于拖拽的区块  公有拖拽图片
pullPicMarket.pullPosX = 0 	-- 拖拽的X坐标
pullPicMarket.pullPosY = 0	-- 拖拽的y坐标
pullPicMarket.pic = nil 	-- 拖拽图片
pullPicMarket.ustID = 0 	-- 拖拽图片索引信息ID 0 表示没有图片

local Back = nil
local pullPosX = 100
local pullPosY = 100

-- 清空拖拽图片
function Market_cleanpullPicType()
    pullPicMarket.pullPosX = 0
	pullPicMarket.pullPosY = 0
	pullPicMarket.pic:SetVisible(0)
	pullPicMarket.pic:SetTouchEnabled(0)
	pullPicMarket.pic.changeimage()
	pullPicMarket.ustID = 0
	pullPicMarket.pic:ToggleEvent(XE_ONUPDATE, 0)	-- 添加消息	
end

-- 创建拖拽区块
function Market_creatpullPicMarket(wnd)
    pullPicMarket.pic = wnd:AddImage(path_equip.."bag_equip.png",0,0,40,40)
	pullPicMarket.pic.changeimage()
	pullPicMarket.pic:SetVisible(0)-- 需要人为开启
	pullPicMarket.pic:SetTouchEnabled(0)-- 需要人为开启
	pullPicMarket.pic:ToggleBehaviour(XE_ONUPDATE, 1)	-- 添加消息
	
	-- 当鼠标移动时响应拖拽
	pullPicMarket.pic.script[XE_ONUPDATE] = function()
		if(pullPicMarket.pic:IsVisible()) then
		    local PosX = XGetCursorPosX()-pullPicMarket.pullPosX
		    local PosY = XGetCursorPosY()-pullPicMarket.pullPosY
		    pullPicMarket.pic:SetPosition(PosX,PosY)
		end
	end
	
	-- 当鼠标左键抬起
	pullPicMarket.pic.script[XE_LBUP] = function()
	    if(pullPicMarket.pic:IsVisible()) then
		    Market_pullPicXLUP()
            Market_cleanpullPicType()
		end
	end	
end

-- 直接设置
function Market_pullPicbyUstID(picPath,ustid,tempic)
    local tempPosX,tempPosY = tempic:GetPosition()-- GetPosition和XgetCursorPosX得到的都是绝对坐标
	pullPicMarket.pic:SetVisible(1) -- 让假图片显示
	pullPicMarket.pic:SetTouchEnabled(1) -- 让假图片响应
	pullPicMarket.pic:SetPosition(XGetCursorPosX()-20,XGetCursorPosY()-20) -- 设置初始
	pullPicMarket.pullPosX = 20 -- 设置焦点距离X
	pullPicMarket.pullPosY = 20 -- 设置焦点距离Y
	pullPicMarket.ustID = ustid  -- 这里用类型id代替
	pullPicMarket.pic.changeimage(picPath) -- 更换图片
	pullPicMarket.pic:ToggleEvent(XE_ONUPDATE, 1)	-- 添加消息	
	pullPicMarket.pic:TriggerBehaviour(XE_LBDOWN)-- 模拟点击
end	

function Market_pullPicXLUP()
    if(n_market_ui:IsVisible() == false) then
	    return 
	end
	local tempRanking = CheckMarketAllSuggestPullResult()
	if(tempRanking == 0) then
	    return
	end	
	XMarket_pullPicXLUP(tempRanking,pullPicMarket.ustID)
end

function CheckMarketPullResult(pic)
    local PosX = XGetCursorPosX()
	local PosY = XGetCursorPosY()
	local BlockX,BlockY = pic:GetPosition()
	if(PosX>BlockX and PosX<BlockX+40 and PosY>BlockY and PosY<BlockY+40) then
	    return true
    else 
	    return false
    end
end

function CheckMarketAllSuggestPullResult()
    for i = 1,6 do
	    if(CheckMarketPullResult(suggestback[i])) then
		    return i
		end
	end
	return 0
end

function InitMarket_ui(wnd,bisopen)
	n_market_ui = CreateWindow(wnd.id, (1920-878)/2, (1080-542)/2, 878, 542)
	InitMain_MarketA(n_market_ui)
	InitMain_MarketB(n_market_ui)
	InitMain_MarketC(n_market_ui)
	n_market_ui:SetVisible(bisopen)
end

function InitMain_MarketA(wnd)
	
	Back = wnd:AddImage(path_fight_market.."market_BK.png",0,0,878,542)
	wnd:AddImage(path_fight_market.."font_name.png",150,-4,248,58)
	
	PersonalPick = wnd:AddImage(path_fight.."skill_nolearn_S.png",630,23,100,14)
	PersonalPick:SetTransparent(0)	
	
	-- 智能购买推荐装备
	check_talent = wnd:AddImage(path_fight_market.."check_bk.png",30,26,16,16)
	check_talent:SetTouchEnabled(1)
	
	
	check_talentYes = check_talent:AddImage(path_fight_market.."yes.png",2,0,17,14)
	check_talentYes:SetTouchEnabled(0)
	check_talentYes:SetVisible(0)
	check_talent.script[XE_LBUP] = function()
		if (check_talentYes:IsVisible()) then
			check_talentYes:SetVisible(0)
			
			XClickMarketTalentYes(0)			-- 点掉智能购买
		else
			check_talentYes:SetVisible(1)
			
			XClickMarketTalentYes(1)			-- 点上智能购买
		end		
	end
	
	-- 自定义推荐
	check_suggest = wnd:AddImage(path_fight_market.."check_bk.png",610,26,16,16)
	check_suggest:SetTouchEnabled(1)
	
	check_yes = check_suggest:AddImage(path_fight_market.."yes.png",2,0,17,14)
	check_yes:SetTouchEnabled(0)
	check_yes:SetVisible(0)
	check_suggest.script[XE_LBUP] = function()
		if (check_yes:IsVisible()) then
			check_yes:SetVisible(0)
			XClickMarketSuggestYes(0)			-- 点掉自定义推荐
		else
			check_yes:SetVisible(1)
			XClickMarketSuggestYes(1)			-- 点上自定义推荐
		end
	end
	
	btn_suggest = wnd:AddButton(path_setup.."btn1_mail.png",path_setup.."btn2_mail.png",path_setup.."btn3_mail.png",712,15,100,32)
	
	DefaultBtn = btn_suggest:AddImage(path_fight.."skill_nolearn_S.png",0,0,128,32)
	DefaultBtn:SetTouchEnabled(0)
	DefaultBtn:SetTransparent(0)
	btn_suggest.script[XE_ONHOVER] = function()	
		DefaultBtn:SetImageTip(defaulttip)
	end
	btn_suggest.script[XE_LBUP] = function()
		XClickPlaySound(5)		
		XClickMarketDefaultBtn()
	end
	
	local btn_close = wnd:AddButton(path_shop.."close1_rec.png",path_shop.."close2_rec.png",path_shop.."close3_rec.png",818,13,35,35)
	btn_close.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		XClickMarketCloseBtn()
	end
	
	PyAttack = wnd:AddButton(path_fight_market.."btnA.png",path_fight_market.."btnA_1.png",path_fight_market.."btnA_2.png",22,56,122,30)
	MgAttack = wnd:AddButton(path_fight_market.."btnA.png",path_fight_market.."btnA_1.png",path_fight_market.."btnA_2.png",22,88,122,30)	
	Defence = wnd:AddButton(path_fight_market.."btnA.png",path_fight_market.."btnA_1.png",path_fight_market.."btnA_2.png",22,120,122,30)	
	MoveSpeed = wnd:AddButton(path_fight_market.."btnA.png",path_fight_market.."btnA_1.png",path_fight_market.."btnA_2.png",22,152,122,30)	
	ExtraMoney = wnd:AddButton(path_fight_market.."btnA.png",path_fight_market.."btnA_1.png",path_fight_market.."btnA_2.png",22,184,122,30)
	GrowEquip = wnd:AddButton(path_fight_market.."btnA.png",path_fight_market.."btnA_1.png",path_fight_market.."btnA_2.png",22,216,122,30)
	ControlEquip = wnd:AddButton(path_fight_market.."btnA.png",path_fight_market.."btnA_1.png",path_fight_market.."btnA_2.png",22,248,122,30)
	BuffEquip = wnd:AddButton(path_fight_market.."btnA.png",path_fight_market.."btnA_1.png",path_fight_market.."btnA_2.png",22,280,122,30)
	Expendable = wnd:AddButton(path_fight_market.."btnA.png",path_fight_market.."btnA_1.png",path_fight_market.."btnA_2.png",22,312,122,30)
	
	-- 攻击类
	PyAttack.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		clickBtnA:SetPosition(22,56)
		clickFontA:SetFontText(Equip_BtnFont[1],0xffffff)
		if PyAttack_ui:IsVisible() == true then
			PyAttack_ui:SetVisible(0)
			ResetEquipBtnPosition(4)
		else
			XClickMarketIndex(0,0)			-- 点击攻击类、攻击力
			PyAttack_ui:SetVisible(1)
			MgAttack_ui:SetVisible(0)
			Defence_ui:SetVisible(0)
			ResetEquipBtnPosition(1)
			
			PyAttack_clickBtnB:SetPosition(25,0)
			PyAttack_clickFontB:SetFontText(PyAttack_kidFont[1],0xffffff)
		end
	end
	PyAttack_ui = CreateWindow(PyAttack.id, 0, 30, 140, 160)	
	for i=1,5 do
		local posx = 25
		local posy = 28*i-28
		PyAttack_kid[i] = PyAttack_ui:AddButton(path_fight_market.."btnB.png",path_fight_market.."btnB_1.png",path_fight_market.."btnB_2.png",posx,posy,94,27)
		
		PyAttack_kid[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			
			XClickMarketIndex(0,i-1)			-- 点击攻击类
			PyAttack_clickBtnB:SetPosition(25,28*i-28)
			PyAttack_clickFontB:SetFontText(PyAttack_kidFont[i],0xffffff)
		end
	end
	PyAttack_clickBtnB = PyAttack_ui:AddImage(path_fight_market.."btnB_2.png",25,0,94,27)
	PyAttack_clickBtnB:AddImage(path_info.."R2_info.png",95,-5,27,36)
	
	-- 法术类
	MgAttack.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		clickBtnA:SetPosition(22,88)
		clickFontA:SetFontText(Equip_BtnFont[2],0xffffff)
		if MgAttack_ui:IsVisible() == true then
			MgAttack_ui:SetVisible(0)
			ResetEquipBtnPosition(4)
		else
			XClickMarketIndex(1,0)			-- 点击法术类
			PyAttack_ui:SetVisible(0)
			MgAttack_ui:SetVisible(1)
			Defence_ui:SetVisible(0)
			ResetEquipBtnPosition(2)
			
			MgAttack_clickBtnB:SetPosition(25,0)
			MgAttack_clickFontB:SetFontText(MgAttack_kidFont[1],0xffffff)
		end
	end
	MgAttack_ui = CreateWindow(MgAttack.id, 0, 30, 140, 160)
	for i=1,5 do
		local posx = 25
		local posy = 28*i-28
		MgAttack_kid[i] = MgAttack_ui:AddButton(path_fight_market.."btnB.png",path_fight_market.."btnB_1.png",path_fight_market.."btnB_2.png",posx,posy,94,27)
	
		MgAttack_kid[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			
			XClickMarketIndex(1,i-1)			-- 点击法术类
			MgAttack_clickBtnB:SetPosition(25,28*i-28)
			MgAttack_clickFontB:SetFontText(MgAttack_kidFont[i],0xffffff)
		end
	end
	MgAttack_clickBtnB = MgAttack_ui:AddImage(path_fight_market.."btnB_2.png",25,0,94,27)	
	MgAttack_clickBtnB:AddImage(path_info.."R2_info.png",95,-5,27,36)
	
	-- 防御装
	Defence.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		clickBtnA:SetPosition(22,120)
		clickFontA:SetFontText(Equip_BtnFont[3],0xffffff)
		if Defence_ui:IsVisible() == true then
			Defence_ui:SetVisible(0)
			ResetEquipBtnPosition(4)
		else
			XClickMarketIndex(2,0)			-- 点击防御类
			PyAttack_ui:SetVisible(0)
			MgAttack_ui:SetVisible(0)
			Defence_ui:SetVisible(1)
			ResetEquipBtnPosition(3)
			
			Defence_clickBtnB:SetPosition(25,0)
			Defence_clickFontB:SetFontText(Defence_kidFont[1],0xffffff)
		end
	end
	Defence_ui = CreateWindow(Defence.id, 0, 30, 140, 160)
	for i=1,5 do
		local posx = 25
		local posy = 28*i-28
		Defence_kid[i] = Defence_ui:AddButton(path_fight_market.."btnB.png",path_fight_market.."btnB_1.png",path_fight_market.."btnB_2.png",posx,posy,94,27)
		
		Defence_kid[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			
			XClickMarketIndex(2,i-1)			-- 点击防御类
			Defence_clickBtnB:SetPosition(25,28*i-28)
			Defence_clickFontB:SetFontText(Defence_kidFont[i],0xffffff)
		end
	end
	Defence_clickBtnB = Defence_ui:AddImage(path_fight_market.."btnB_2.png",25,0,94,27)
	Defence_clickBtnB:AddImage(path_info.."R2_info.png",95,-5,27,36)
	
	-- 移动速度
	MoveSpeed.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		XClickMarketIndex(3,0)			-- 点击移动速度类
		clickBtnA:SetPosition(22,152)
		clickFontA:SetFontText(Equip_BtnFont[4],0xffffff)
		PyAttack_ui:SetVisible(0)
		MgAttack_ui:SetVisible(0)
		Defence_ui:SetVisible(0)
		ResetEquipBtnPosition(4)
	end
	
	-- 额外金钱
	ExtraMoney.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		XClickMarketIndex(3,1)			-- 点击额外金钱类
		clickBtnA:SetPosition(22,184)
		clickFontA:SetFontText(Equip_BtnFont[5],0xffffff)
		PyAttack_ui:SetVisible(0)
		MgAttack_ui:SetVisible(0)
		Defence_ui:SetVisible(0)
		ResetEquipBtnPosition(4)
	end
	
	-- 成长类
	GrowEquip.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		XClickMarketIndex(3,2)			-- 点击成长类
		clickBtnA:SetPosition(22,216)
		clickFontA:SetFontText(Equip_BtnFont[6],0xffffff)
		PyAttack_ui:SetVisible(0)
		MgAttack_ui:SetVisible(0)
		Defence_ui:SetVisible(0)
		ResetEquipBtnPosition(4)
	end
	
	-- 控制类
	ControlEquip.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		XClickMarketIndex(3,3)			-- 点击消耗类
		clickBtnA:SetPosition(22,248)
		clickFontA:SetFontText(Equip_BtnFont[7],0xffffff)
		PyAttack_ui:SetVisible(0)
		MgAttack_ui:SetVisible(0)
		Defence_ui:SetVisible(0)
		ResetEquipBtnPosition(4)
	end
	
	-- 光环类
	BuffEquip.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		XClickMarketIndex(3,4)			-- 光环类
		clickBtnA:SetPosition(22,280)
		clickFontA:SetFontText(Equip_BtnFont[8],0xffffff)
		PyAttack_ui:SetVisible(0)
		MgAttack_ui:SetVisible(0)
		Defence_ui:SetVisible(0)
		ResetEquipBtnPosition(4)
	end
	
	-- 消耗品
	Expendable.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		XClickMarketIndex(4,0)			-- 点击消耗类
		clickBtnA:SetPosition(22,312)
		clickFontA:SetFontText(Equip_BtnFont[9],0xffffff)
		PyAttack_ui:SetVisible(0)
		MgAttack_ui:SetVisible(0)
		Defence_ui:SetVisible(0)
		ResetEquipBtnPosition(4)
	end
	
	-- 点击按钮停留在第三种状态
	clickBtnA = wnd:AddImage(path_fight_market.."btnA_2.png",22,56,122,30)
	clickBtnA:SetTouchEnabled(0)	
	PyAttack_ui:SetVisible(0)
	MgAttack_ui:SetVisible(0)
	Defence_ui:SetVisible(0)

	-- 自身装备格子
	EquipUp_BK = wnd:AddImage(path_fight_market.."equipup_BK.png",166,525,324,56)
	for i=1,6 do
		local posx = 176+44*i
		local posy = 475		
		
		wnd:AddImage(path_fight_market.."equip_side.png",posx,posy,40,40)
		Equip_Bag[i] = wnd:AddImage(path_fight.."Me_equip.png",posx+2,posy+2,36,36)	
		Equip_BagFlag[i] = Equip_Bag[i]:AddImage(path_fight_market.."have.png",23,23,13,13)	
		Equip_BagFlag[i]:SetVisible(0)
		Equip_Bag[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			
			XClickSelfGoods(i-1,Self_goods.Id[i])
		end
		-- 炼金装备		
		Equip_BagUp[i] = EquipUp_BK:AddImageMultiple(path_fight.."Me_equip.png", "", "",posx-166,10,36,36)
		Equip_BagUp[i]:AddImage(path_fight_market.."equip_side.png",-2,-2,40,40)
		
		Equip_BagUpHide[i] = Equip_BagUp[i]:AddImage(path_fight_market.."current_hide.png",-3,-3,41,41)
		Equip_BagUpHide[i]:SetTouchEnabled(0)
		
		Equip_BagUp[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			
			XClickSelfGoodsUp(Self_goodsUp.Id[i])
		end
	end
	Equip_BagSideClick = wnd:AddImage(path_fight_market.."equip_click.png",220,475,40,40)
	Equip_BagSideClick:SetVisible(0)
	
	-- 商店装备栏	
	-- 先默认创建Max_MarketGoods个装备栏(现在分类栏里最多的是防御类生命值（41件装备）)
	for i=1,Max_MarketGoods do
		market_posx[i] = ((i+1)%2+1)*170
		market_posy[i] = 56*math.ceil(i/2)+45-40
		market_equip[i] = wnd:AddImage(path_fight_market.."market_equip.png",market_posx[i],market_posy[i],164,50)
	
		local AA = market_equip[i]:AddImage(path_fight_market.."equip_side.png",5,5,40,40)
		market_icon[i] = market_equip[i]:AddImage(path_fight.."Me_equip.png",7,7,36,36)
		AA:SetTouchEnabled(0)
		market_icon[i]:SetTouchEnabled(0)
		
		market_hide[i] = market_equip[i]:AddImage(path_fight_market.."market_hide.png",0,0,164,50)
		market_hide[i]:SetTouchEnabled(0)
		market_hide[i]:SetVisible(1)
		
		market_equip[i].script[XE_LBDOWN] = function()
			click_index = i
			local L,T = market_equip[i]:GetPosition()
			--log("\ndianji   x   y"..L.."   "..T)
			market_click:SetAbsolutePosition(L,T)
			market_click:SetVisible(1)
			XClickMarketGoods(Market_goods.Id[i+Many*2])
		end
		
		market_equip[i].script[XE_DRAG] = function()-- 拖拽
		    if(check_yes:IsVisible()) then
		        Market_pullPicbyUstID(Market_goods.strPictureName[i+Many*2],Market_goods.Id[i+Many*2],market_icon[i])
			end	
		end
		
		-- 双击购买 无响应
		market_equip[i].script[XE_LBDBCLICK] = function()
			XClickPlaySound(5)
			XDBClickMarketGoods(Market_goods.Id[i+Many*2])
		end
		market_equip[i].script[XE_RBUP] = function()
			XClickPlaySound(5)
			XDBClickMarketGoods(Market_goods.Id[i+Many*2])
		end
		market_equip[i].script[XE_ONHOVER] = function()
			local L,T = market_equip[i]:GetPosition()
			
			market_hover:SetAbsolutePosition(L,T)
			market_hover:SetVisible(1)
		end
		market_equip[i].script[XE_ONUNHOVER] = function()
			market_hover:SetVisible(0)
		end
		
		if market_posy[i]>400 then
			market_equip[i]:SetVisible(0)
		end
	end
	
	market_hover = wnd:AddImage(path_fight_market.."market_hover.png",0,0,164,50)
	market_click = wnd:AddImage(path_fight_market.."market_click.png",0,0,164,50)
	market_hover:SetVisible(0)
	market_click:SetVisible(0)
	
	-- 显示滚动条
	HDT_BK = wnd:AddImage(path.."toggleBK_main.png",510,74,16,358)
	HDT_BTN = HDT_BK:AddButton(path.."toggleBTN1_main.png",path.."toggleBTN2_main.png",path.."toggleBTN3_main.png",0,0,16,50)
	local ToggleT = HDT_BK:AddImage(path.."TD1_main.png",0,-16,16,16)
	local ToggleD = HDT_BK:AddImage(path.."TD1_main.png",0,358,16,16)
	
	XSetWindowFlag(HDT_BTN.id,1,1,0,308)
	
	HDT_BTN:ToggleBehaviour(XE_ONUPDATE, 1)
	HDT_BTN:ToggleEvent(XE_ONUPDATE, 1)
	HDT_BTN.script[XE_ONUPDATE] = function()
		if HDT_BTN._T == nil then
			HDT_BTN._T = 0
		end
		local L,T,R,B = XGetWindowClientPosition(HDT_BTN.id)
		if HDT_BTN._T ~= T then
			local length = 0
			if #Market_goods.Id <=14 then
				length = 308
			else
				length = 308/math.ceil((#Market_goods.Id/2)-7)
			end
			Many = math.floor(T/length)
			updownCount = Many
			
			ReDraw_MarketGoods()
			HDT_BTN._T = T
		end
	end
	XWindowEnableAlphaTouch(n_market_ui.id)
	n_market_ui:EnableEvent(XE_MOUSEWHEEL)
	n_market_ui.script[XE_MOUSEWHEEL] = function()
		local updown  = XGetMsgParam0()
		local length = 0
		if #Market_goods.Id >14 then
			maxUpdown = math.ceil((#Market_goods.Id/2)-7)
			length = 308/maxUpdown
		else
			maxUpdown = 0
			length = 308
		end
		
		if updown>0 then
			updownCount = updownCount-1
			if updownCount<0 then
				updownCount=0
			end
		else
			updownCount = updownCount+1
			if updownCount>maxUpdown then
				updownCount=maxUpdown
			end
		end	
		
		btn_pos = length*updownCount
		Many = updownCount
		
		HDT_BTN:SetPosition(0,btn_pos)
		HDT_BTN._T = btn_pos
		
		if updownCount >= 0 and updownCount <= maxUpdown then
			ReDraw_MarketGoods()
		end
	end
	
	n_market_ui:ToggleBehaviour(XE_ONUPDATE, 1)	-- 添加消息
	
    Back.script[XE_LBDOWN] = function()
	    n_market_ui:ToggleEvent(XE_ONUPDATE, 1)	-- 添加消息	
		local L,T = n_market_ui:GetPosition()
		pullPosX = XGetCursorPosX()-L
		pullPosY = XGetCursorPosY()-T
	end
	Back.script[XE_LBUP] = function()
	    n_market_ui:ToggleEvent(XE_ONUPDATE, 0)	-- 添加消息	
	end	
	n_market_ui.script[XE_ONUPDATE] = function()-- 当鼠标移动时响应拖拽
		if(n_market_ui:IsVisible()) then
		    local x = XGetCursorPosX()
			local y = XGetCursorPosY()
			local w,h = Back:GetWH()
			local PosX
			local PosY
            PosX = x- pullPosX
			if(PosX < 0) then
			    PosX = 0
			elseif(PosX > windowswidth-w)	then
			    PosX = windowswidth - w
			end
			PosY = y- pullPosY
			if(PosY < 0) then
			    PosY = 0
			elseif(PosY > windowsheight - h)	then
			    PosY = windowsheight - h
			end			
		    n_market_ui:SetAbsolutePosition(PosX,PosY)
		else
	        n_market_ui:ToggleEvent(XE_ONUPDATE, 0)	-- 添加消息	
		end
	end
	
end

function InitMain_MarketB(wnd)	
	-- 自定义推荐装备
	for i=1,6 do
		local posx = 500+50*i
		local posy = 60		
		
		suggestback[i] = wnd:AddImage(path_fight_market.."equip_side.png",posx,posy,40,40)
		Equip_SuggestBag[i] = wnd:AddImage(path_fight.."Me_equip.png",posx+2,posy+2,36,36)
		
		Equip_SuggestBagHide[i] = wnd:AddImage(path_fight_market.."current_hide.png",posx-1,posy-1,41,41)
		Equip_SuggestBagHide[i]:SetTouchEnabled(0)
		Equip_SuggestBagHide[i]:SetVisible(1)
		
		Equip_SuggestBag[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			
			XClickSuggestGoods(Suggest_goods.Id[i])
		end
		Equip_SuggestBag[i].script[XE_LBDBCLICK] = function()
			XClickPlaySound(5)
			
			XDBClickSuggestGoods(Suggest_goods.Id[i])
		end
		Equip_SuggestBag[i].script[XE_RBUP] = function()
			XClickPlaySound(5)
			
			XDBClickSuggestGoods(Suggest_goods.Id[i])
		end
	end	
	
	-- 当前选中的装备		
	wnd:AddImage(path_fight_market.."equip_side.png",538,134,40,40)
	wnd:AddImage(path_fight_market.."current_click.png",538-4,134-6,48,64)
	Equip_current = wnd:AddImage(path_fight.."Me_equip.png",538+2,134+2,36,36)
	Equip_currentHide = Equip_current:AddImage(path_fight_market.."current_hide.png",-3,-3,41,41)
	Equip_currentHide:SetTouchEnabled(0)
	Equip_currentHide:SetVisible(1)
	Equip_currentHave = Equip_current:AddImage(path_fight_market.."have.png",24,24,13,13)
	Equip_currentHave:SetTouchEnabled(0)
	Equip_currentHave:SetVisible(0)
	
	Equip_current.script[XE_LBDBCLICK] = function()
		XClickPlaySound(5)
	
		XDBClickCurrentGoods(Current_goodsId)
	end
	Equip_current.script[XE_RBUP] = function()
		XClickPlaySound(5)
	
		XDBClickCurrentGoods(Current_goodsId)
	end
	Equip_current:SetVisible(0)
	
	-- 方向按钮
	btn_Left = wnd:AddButton(path_info.."L1_info.png",path_info.."L2_info.png",path_info.."L3_info.png",584,138,27,36)
	XWindowEnableAlphaTouch(btn_Left.id)
	btn_Right = wnd:AddButton(path_info.."R1_info.png",path_info.."R2_info.png",path_info.."R3_info.png",832,138,27,36)
	XWindowEnableAlphaTouch(btn_Right.id)
	btn_Left.script[XE_LBUP] = function()
		XClickPlaySound(5)
	
		XClickMarketLeftAndRight(1)
	end
	btn_Right.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		XClickMarketLeftAndRight(2)
	end
	
	-- 可合成的装备
	for i=1,5 do
		local posx = 566+45*i
		local posy = 134		
		
		wnd:AddImage(path_fight_market.."equip_side.png",posx,posy,40,40)
		Equip_canSyn[i] = wnd:AddImage(path_fight.."Me_equip.png",posx+2,posy+2,36,36)
		Equip_canSyn[i]:SetVisible(0)
		Equip_canSynHide[i] = wnd:AddImage(path_fight_market.."current_hide.png",posx-1,posy-1,41,41)
		Equip_canSynHide[i]:SetTouchEnabled(0)
		Equip_canSynHide[i]:SetVisible(1)
		Equip_canSynHave[i] = wnd:AddImage(path_fight_market.."have.png",posx+26,posy+26,13,13)
		Equip_canSynHave[i]:SetTouchEnabled(0)
		Equip_canSynHave[i]:SetVisible(0)
	
		Equip_canSyn[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			
			XClickCanSynGoods(CanSyn_goods.Id[i])
		end		
	end
	
	-- 合成树	
	MarketSyn_ui = CreateWindow(wnd.id, 525, 205, 330, 240)
	
	for i=1,10 do
	
		market_max[i] = MarketSyn_ui:AddImage(path_fight.."Me_equip.png",market_maxPosX[i]+2,market_maxPosY[i]+2,36,36)
		market_max[i]:AddImage(path_fight_market.."equip_side.png",-2,-2,40,40)
		market_maxHide[i] = market_max[i]:AddImage(path_fight_market.."current_hide.png",-3,-3,41,41)
		market_maxHide[i]:SetTouchEnabled(0)
		market_maxHide[i]:SetVisible(0)
		market_maxHave[i] = market_max[i]:AddImage(path_fight_market.."have.png",23,23,13,13)
		market_maxHave[i]:SetTouchEnabled(0)
		market_maxHave[i]:SetVisible(0)
		
		market_max[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			XClickMaxGoods(max_goods.Id[i])
			
			local L,T = market_max[i]:GetPosition()			
			market_maxClick:SetAbsolutePosition(L-6,T-8)
			market_maxClick:SetVisible(1)
		end
		market_max[i].script[XE_LBDBCLICK] = function()
			XClickPlaySound(5)
			XDBClickMaxGoods(max_goods.Id[i],max_goods.Enabled[i])
			
			local L,T = market_max[i]:GetPosition()			
			market_maxClick:SetAbsolutePosition(L-6,T-8)
			market_maxClick:SetVisible(1)
		end
		market_max[i].script[XE_RBUP] = function()
			XClickPlaySound(5)
			XDBClickMaxGoods(max_goods.Id[i],max_goods.Enabled[i])
			
			local L,T = market_max[i]:GetPosition()			
			market_maxClick:SetAbsolutePosition(L-6,T-8)
			market_maxClick:SetVisible(1)
		end
	end
	market_maxClick = market_max[1]:AddImage(path_fight_market.."current_click.png",0,0,48,64)
	market_maxClick:SetVisible(0)
	
	-- 合成线
	lineA = MarketSyn_ui:AddImage(path_fight_market.."line_1.png",60,90,111,9)
	lineB = MarketSyn_ui:AddImage(path_fight_market.."line_2.png",170,90,1,9)
	lineC = MarketSyn_ui:AddImage(path_fight_market.."line_3.png",170,90,110,9)
	lineD = MarketSyn_ui:AddImage(path_fight_market.."line_4.png",32,163,28,10)
	lineE = MarketSyn_ui:AddImage(path_fight_market.."line_5.png",60,163,28,10)
	lineF = MarketSyn_ui:AddImage(path_fight_market.."line_4.png",142,163,28,10)
	lineG = MarketSyn_ui:AddImage(path_fight_market.."line_5.png",170,163,28,10)
	lineH = MarketSyn_ui:AddImage(path_fight_market.."line_4.png",252,163,28,10)
	lineI = MarketSyn_ui:AddImage(path_fight_market.."line_5.png",280,163,28,10)
	
	-- 自身金钱界面
	wnd:AddImage(path_shop.."money_shop.png",532,475,64,64)
	
	btn_ReturnBack = wnd:AddButton(path_fight_market.."return.png",path_fight_market.."return_1.png",path_fight_market.."return_2.png",640,476,39,39)
	btn_ReturnBack:SetEnabled(0)
	btn_ReturnBack:SetVisible(0)
	
	btn_BuyEquip = wnd:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",682,479,83,35)
	
	btn_BuyEquipimg = wnd:AddImage(path_setup.."buy1_setup.png",682,479,83,35)
	btn_BuyEquipimg:SetTransparent(0)
	btn_BuyEquipimg:SetTouchEnabled(0)
	
	btn_SellEquip = wnd:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",768,479,83,35)
	
	btn_ReturnBack.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
	end
	btn_BuyEquip.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		XClickMarketBuyAndSell(1)
	end
	btn_SellEquip.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		XClickMarketBuyAndSell(2)
	end
	
end

function InitMain_MarketC(wnd)	
	-- 文字
	wnd:AddFont("推荐装备",15,0,532,23,100,20,0x7787c3)
	wnd:AddFont("可合成道具",15,0,528,108,100,20,0x7787c3)
	wnd:AddFont("合成树",15,0,540,210,100,20,0x7787c3)
	wnd:AddFont("自定义推荐",15,0,630,23,100,20,0x83d1e6)
	wnd:AddFont("当前\n装备",15,0,178,475,100,100,0x7787c3)
	check_talent:AddFont("智能购买推荐装备",15,0,20,-3,200,20,0x83d1e6)
	btn_suggest:AddFont("默认推荐",15, 8, 0, 0, 100, 30, 0xffffff)
	PyAttack:AddFont(Equip_BtnFont[1],15,0,10,4,100,20,0x7787c3)
	MgAttack:AddFont(Equip_BtnFont[2],15,0,10,4,100,20,0x7787c3)
	Defence:AddFont(Equip_BtnFont[3],15,0,10,4,100,20,0x7787c3)
	MoveSpeed:AddFont(Equip_BtnFont[4],15,0,10,4,100,20,0x7787c3)
	ExtraMoney:AddFont(Equip_BtnFont[5],15,0,10,4,100,20,0x7787c3)
	GrowEquip:AddFont(Equip_BtnFont[6],15,0,10,4,100,20,0x7787c3)
	ControlEquip:AddFont(Equip_BtnFont[7],15,0,10,4,100,20,0x7787c3)
	BuffEquip:AddFont(Equip_BtnFont[8],15,0,10,4,100,20,0x7787c3)
	Expendable:AddFont(Equip_BtnFont[9],15,0,10,4,100,20,0x7787c3)
	
	for i=1,5 do
		PyAttack_kid[i]:AddFont(PyAttack_kidFont[i],15,0,10,5,100,20,0x7787c3)
		MgAttack_kid[i]:AddFont(MgAttack_kidFont[i],15,0,10,5,100,20,0x7787c3)
		Defence_kid[i]:AddFont(Defence_kidFont[i],15,0,10,5,100,20,0x7787c3)
	end

	PyAttack_clickFontB = PyAttack_clickBtnB:AddFont(PyAttack_kidFont[1],15,0,10,5,100,20,0xffffff)
	MgAttack_clickFontB = MgAttack_clickBtnB:AddFont(MgAttack_kidFont[1],15,0,10,5,100,20,0xffffff)
	Defence_clickFontB = Defence_clickBtnB:AddFont(Defence_kidFont[1],15,0,10,5,100,20,0xffffff)
	clickFontA = clickBtnA:AddFont(Equip_BtnFont[1],15,0,10,4,100,20,0xffffff)

	-- 自身装备格子
	for i=1,6 do
		Equip_BagLayer[i] = Equip_Bag[i]:AddFont("1",15,0,22,20,100,20,0xffffff)
	end
	for i=1,Max_MarketGoods do
		market_name[i] = market_equip[i]:AddFont("神装无敌"..i,15,0,45,5,130,20,0xffffff)
		market_money[i] = market_equip[i]:AddFontEx("5321",12,0,45,28,100,20,0xffe4e18b)
		-- market_money[i]:SetFontSpace(1,0)
	end
	Equip_currentFont = Equip_current:AddFontEx("500",12,8,0,0,36,94,0xffe4e18b)
	for i=1,10 do	
		market_maxFont[i] = market_max[i]:AddFontEx("50"..i,15,8,0,0,36,94,0xffe4e18b)
	end

	my_money = wnd:AddFontEx("5042",18,0,570,482,200,20,0xffe4e18b)
	btn_BuyEquip:AddFont("购买",15,0,22,8,200,100,0xffffff)
	btn_SellEquip:AddFont("出售",15,0,22,8,200,100,0xffffff)
	
end

-- 重绘装备
function ReDraw_MarketGoods()
	for i=1, Max_MarketGoods do
		if i+Many*2 > #Market_goods.Id then
			market_equip[i]:SetVisible(0)
		else
			market_equip[i]:SetVisible(1)
			
			market_icon[i].changeimage( Market_goods.strPictureName[i+Many*2])
			market_equip[i]:SetImageTip( Market_goods.tip[i+Many*2])
			market_name[i]:SetFontText( Market_goods.strName[i+Many*2],0xffffff)
			market_money[i]:SetFontText( Market_goods.money[i+Many*2],0xffe4e18b)
			market_hide[i]:SetVisible( Market_goods.Enabled[i+Many*2])
		end
	end
	market_click:SetVisible(0)
end

function ResetEquipBtnPosition(index)
	if index == 1 then
		MgAttack:SetPosition(22,88+140)
		Defence:SetPosition(22,120+140)
		MoveSpeed:SetPosition(22,152+140)
		ExtraMoney:SetPosition(22,184+140)
		GrowEquip:SetPosition(22,216+140)
		ControlEquip:SetPosition(22,248+140)
		BuffEquip:SetPosition(22,280+140)
		Expendable:SetPosition(22,312+140)
	elseif index == 2 then
		MgAttack:SetPosition(22,88)
		Defence:SetPosition(22,120+140)
		MoveSpeed:SetPosition(22,152+140)
		ExtraMoney:SetPosition(22,184+140)
		GrowEquip:SetPosition(22,216+140)
		ControlEquip:SetPosition(22,248+140)
		BuffEquip:SetPosition(22,280+140)
		Expendable:SetPosition(22,312+140)
	elseif index == 3 then
		MgAttack:SetPosition(22,88)
		Defence:SetPosition(22,120)
		MoveSpeed:SetPosition(22,152+140)
		ExtraMoney:SetPosition(22,184+140)
		GrowEquip:SetPosition(22,216+140)
		ControlEquip:SetPosition(22,248+140)
		BuffEquip:SetPosition(22,280+140)
		Expendable:SetPosition(22,312+140)
	else
		MgAttack:SetPosition(22,88)
		Defence:SetPosition(22,120)
		MoveSpeed:SetPosition(22,152)
		ExtraMoney:SetPosition(22,184)
		GrowEquip:SetPosition(22,216)
		ControlEquip:SetPosition(22,248)
		BuffEquip:SetPosition(22,280)
		Expendable:SetPosition(22,312)
	end
end

-- 商城物品通信
function Clear_MarketGoods()
	Market_goods = {}
	
	Market_goods.strName = {}
	Market_goods.strPictureName = {}
	Market_goods.money = {}
	Market_goods.Id = {}
	Market_goods.Enabled = {}
	Market_goods.tip = {}
	for index,value in pairs(market_equip) do
		market_equip[index]:SetVisible(0)
	end
	market_click:SetVisible(0)
	click_index = 0
	
	-- 滚动条恢复
	updownCount = 0
	maxUpdown = 0
	Many = 0
	HDT_BTN:SetPosition(0,0)
	HDT_BTN._T = 0
	
	for i,value in pairs(market_equip) do		
		local Li, Ti = market_posx[i],market_posy[i]
		market_equip[i]:SetPosition(Li, Ti)
		
		if market_posy[i]>400 then
			market_equip[i]:SetVisible(0)
		end
	end	
end

function SendData_MarketGoods(name,pictureName,money,id,tip)
	local size = #Market_goods.Id+1
	
	Market_goods.strName[size] = name
	Market_goods.strPictureName[size] = "..\\"..pictureName
	Market_goods.money[size] = money	
	Market_goods.Id[size] = id
	Market_goods.tip[size] = tip
	ReDraw_MarketGoods()
end

function SendData_MarketGoodsOver()
	if #Market_goods.Id <=14 then
		HDT_BK:SetVisible(0)
	else
		HDT_BK:SetVisible(1)
	end
	ReDraw_MarketGoods()
end

-- 自己的物品栏清单
function Clear_SelfGoods()
	Self_goods = {}
	Self_goods.strPictureName = {}
	Self_goods.Id = {}
	Self_goods.Layer = {}
	
	for index = 1,6 do
		Equip_Bag[index]:SetVisible(0)
		Equip_BagLayer[index]:SetVisible(0)
	end
end

function SendData_SelfGoods(pictureName,id,layer,flag,tip,index)
	
	Self_goods.strPictureName[index] = "..\\"..pictureName
	Self_goods.Id[index] = id
	Self_goods.Layer[index] = layer
	
	Equip_Bag[index].changeimage(Self_goods.strPictureName[index])
	Equip_Bag[index]:SetImageTip(tip)
	Equip_BagLayer[index]:SetFontText(layer,0xffffff)
	if layer >1 then 
		Equip_BagLayer[index]:SetVisible(1)
	end
	if flag>0 then
		if flag>1 then
			Equip_BagFlag[index].changeimage(path_fight_market.."have.png")
		else
			Equip_BagFlag[index].changeimage(path_fight_market.."tan.png")
		end
		Equip_BagFlag[index]:SetVisible(1)
	else
		Equip_BagFlag[index]:SetVisible(0)
	end
	Equip_Bag[index]:SetVisible(1)
end

-- 炼金所用宝石界面
function Clear_SelfGoodsUp()
	Self_goodsUp = {}
	Self_goodsUp.strPictureName = {}
	Self_goodsUp.strPictureName1 = {}
	Self_goodsUp.strPictureName2 = {}
	Self_goodsUp.Id = {}
	for index = 1,6 do	
		Equip_BagUp[index]:SetVisible(0)
		Equip_BagUpHide[index]:SetVisible(0)
	end
end

function SendData_SelfGoodsUp(pictureName,pictureName1,pictureName2,id,Enabled,index,tip)	
	Self_goodsUp.strPictureName[index] = "..\\"..pictureName
	Self_goodsUp.strPictureName1[index] = "..\\"..pictureName1
	Self_goodsUp.strPictureName2[index] = "..\\"..pictureName2
	Self_goodsUp.Id[index] = id
	Equip_BagUp[index].changeimageMultiple(Self_goodsUp.strPictureName[index], Self_goodsUp.strPictureName1[index], Self_goodsUp.strPictureName2[index])
	Equip_BagUp[index]:SetImageTip(tip)
	
	Equip_BagUp[index]:SetVisible(1)
	if Enabled>0 then
		Equip_BagUpHide[index]:SetVisible(0)
	else
		Equip_BagUpHide[index]:SetVisible(1)
	end
end

function SetVisible_SelfGoodsUp(flag)
	if flag==1 and EquipUp_BK:IsVisible()==false then
		EquipUp_BK:SetVisible(1)
	elseif flag==0 and EquipUp_BK:IsVisible()==true then
		EquipUp_BK:SetVisible(0)
	end
end

-- 推荐物品栏
function Clear_SuggestGoods()
	Suggest_goods = {}
	Suggest_goods.strName = {}
	Suggest_goods.strPictureName = {}
	Suggest_goods.Id = {}
	
	for index = 1,6 do
		Equip_SuggestBag[index]:SetVisible(0)
		Equip_SuggestBagHide[index]:SetVisible(1)
	end
end

function SendData_SuggestGoods(name,pictureName,id,index,tip,persontip,Defaulttip)
	Suggest_goods.strName[index] = name
	Suggest_goods.strPictureName[index] = "..\\"..pictureName
	Suggest_goods.Id[index] = id
	Equip_SuggestBag[index]:SetImageTip(tip)
	PersonalPick:SetImageTip(persontip)
	defaulttip = Defaulttip
	if pictureName ~= "" then
		Equip_SuggestBag[index].changeimage(Suggest_goods.strPictureName[index])
	end
	Equip_SuggestBag[index]:SetVisible(1)
end

-- 当前选中的装备
function Clear_CurrentClick()
	Equip_current:SetVisible(0)
end

function Draw_CurrentClick(strPictureName,money,Id,tip)
	Current_goodsPictureName = "..\\"..strPictureName
	Current_goodsMoney = money
	Current_goodsId = Id
	Equip_current:SetImageTip(tip)
	if strPictureName ~= "" then
		Equip_current.changeimage(Current_goodsPictureName)
	end
	Equip_currentFont:SetFontText(money,0xffe4e18b)
	Equip_current:SetVisible(1)
end

-- 可合成物品栏
function Clear_CanSynGoods()
	CanSyn_goods = {}
	CanSyn_goods.strName = {}
	CanSyn_goods.strPictureName = {}
	CanSyn_goods.Id = {}
	
	for index = 1,6 do
		Equip_canSyn[index]:SetVisible(0)
		Equip_canSynHide[index]:SetVisible(1)
		Equip_canSynHave[index]:SetVisible(0)
	end
end

function SendData_CanSynGoods(name,pictureName,id,tip)
	local size = #CanSyn_goods.Id+1
	
	CanSyn_goods.strName[size] = name
	CanSyn_goods.strPictureName[size] = "..\\"..pictureName
	CanSyn_goods.Id[size] = id	
	
	Equip_canSyn[size]:SetImageTip(tip)
end

function Draw_CanSynGoods()
	for index = 1,#CanSyn_goods.Id do
		Equip_canSyn[index].changeimage(CanSyn_goods.strPictureName[index])
		Equip_canSyn[index]:SetVisible(1)
	end	
end

-- 当前查看的物品的合成表
function Clear_LineVisible()
	lineA:SetVisible(0)
	lineB:SetVisible(0)
	lineC:SetVisible(0)
	lineD:SetVisible(0)
	lineE:SetVisible(0)
	lineF:SetVisible(0)
	lineG:SetVisible(0)
	lineH:SetVisible(0)
	lineI:SetVisible(0)
	
	for i=1,10 do
		market_max[i]:SetVisible(0)
		market_maxHide[i]:SetVisible(0)
		market_maxHave[i]:SetVisible(0)
	end	
	market_maxClick:SetVisible(0)
end

function SetLineIndexVisible(EquipIcon,EquipMoney,EquipId,EquipEnabled,indexA,indexB,tip)
	local index = 1
	if indexA==1 and indexB==0 then
		lineA:SetVisible(1)
		index = 2
	elseif indexA==1 and indexB==1 then
		lineB:SetVisible(1)
		index = 3
	elseif indexA==1 and indexB==2 then
		lineC:SetVisible(1)
		index = 4
	elseif indexA==2 and indexB==0 then
		lineD:SetVisible(1)
		index = 5
	elseif indexA==2 and indexB==1 then
		lineE:SetVisible(1)
		index = 6
	elseif indexA==2 and indexB==2 then
		lineF:SetVisible(1)
		index = 7
	elseif indexA==2 and indexB==3 then
		lineG:SetVisible(1)
		index = 8
	elseif indexA==2 and indexB==4 then
		lineH:SetVisible(1)
		index = 9
	elseif indexA==2 and indexB==5 then
		lineI:SetVisible(1)
		index = 10
	end
	max_goods.strPictureName[index] = "..\\"..EquipIcon
	max_goods.money[index] = EquipMoney
	max_goods.Id[index] = EquipId
	max_goods.Enabled[index] = EquipEnabled
	market_max[index]:SetImageTip(tip)
	if(EquipIcon ~="") then
		market_max[index].changeimage(max_goods.strPictureName[index])
	end
	market_maxFont[index]:SetFontText(max_goods.money[index],0xffe4e18b)
	market_max[index]:SetVisible(1)
end

-- 最终合成的物品
function SetMainComposeGoods(EquipIcon,EquipMoney,EquipId,EquipEnabled,tip)
	max_goods.strPictureName[1] = "..\\"..EquipIcon
	max_goods.money[1] = EquipMoney
	max_goods.Id[1] = EquipId
	max_goods.Enabled[1] = EquipEnabled
	market_max[1]:SetImageTip(tip)
	if(EquipIcon ~="") then
		market_max[1].changeimage(max_goods.strPictureName[1])
	end
	market_maxFont[1]:SetFontText(max_goods.money[1],0xffe4e18b)
	market_max[1]:SetVisible(1)	
	
end

-- 当前自身金钱
function SetCurrentMoney(money)
	my_money:SetFontText(money,0xffe4e18b)
end

function SetMarketGoodsHide(index,flag)
	if Market_goods.Enabled[index] ~= nil and Market_goods.Enabled[index] ~= flag then
		market_hide[index]:SetVisible(flag)
	end
	Market_goods.Enabled[index] = flag
end

function SetSuggestGoodsHide(index,flag)
	Equip_SuggestBagHide[index]:SetVisible(flag)
end

function SetCurrentGoodsHide(flag)
	if flag ==0 then			-- 遮罩隐藏
		Equip_currentHide:SetVisible(0)
		Equip_currentHave:SetVisible(0)
	elseif flag ==1 then		-- 遮罩显示
		Equip_currentHide:SetVisible(1)
		Equip_currentHave:SetVisible(0)
	elseif flag ==2 then		-- 对号显示（已经拥有）
		Equip_currentHide:SetVisible(0)
		Equip_currentHave:SetVisible(1)
	elseif flag ==3 then		-- eIcon_BRight
		Equip_currentHide:SetVisible(1)
		Equip_currentHave:SetVisible(1)
	end
end

function SetCanSynGoodsHide(flag,index)
	if flag ==0 then			-- 遮罩隐藏
		Equip_canSynHide[index]:SetVisible(0)
		Equip_canSynHave[index]:SetVisible(0)
	elseif flag ==1 then		-- 遮罩显示
		Equip_canSynHide[index]:SetVisible(1)
		Equip_canSynHave[index]:SetVisible(0)
	elseif flag ==2 then		-- 对号显示（已经拥有）
		Equip_canSynHide[index]:SetVisible(0)
		Equip_canSynHave[index]:SetVisible(1)
	elseif flag ==3 then		-- eIcon_BRight
		Equip_canSynHide[index]:SetVisible(1)
		Equip_canSynHave[index]:SetVisible(1)
	end
end

function SetMainComposeGoodsHide(flag,indexA,indexB)
	local index = 1
	if indexA==1 and indexB==0 then
		index = 2
	elseif indexA==1 and indexB==1 then
		index = 3
	elseif indexA==1 and indexB==2 then
		index = 4
	elseif indexA==2 and indexB==0 then
		index = 5
	elseif indexA==2 and indexB==1 then
		index = 6
	elseif indexA==2 and indexB==2 then
		index = 7
	elseif indexA==2 and indexB==3 then
		index = 8
	elseif indexA==2 and indexB==4 then
		index = 9
	elseif indexA==2 and indexB==5 then
		index = 10
	end
	
	if flag ==0 then			-- 遮罩隐藏
		market_maxHide[index]:SetVisible(0)
		market_maxHave[index]:SetVisible(0)
	elseif flag ==1 then		-- 遮罩显示
		market_maxHide[index]:SetVisible(1)
		market_maxHave[index]:SetVisible(0)
	elseif flag ==2 then		-- 对号显示（已经拥有）
		market_maxHide[index]:SetVisible(0)
		market_maxHave[index]:SetVisible(1)
	elseif flag ==3 then		-- eIcon_BRight
		market_maxHide[index]:SetVisible(1)
		market_maxHave[index]:SetVisible(1)
	end
	
end

-- 卖出按钮能否点击
function SetSellBtnEnabled(sell,index)
	btn_SellEquip:SetEnabled(sell)
	if sell==0 then
		Equip_BagSideClick:SetVisible(0)
	else
		Equip_BagSideClick:SetPosition(220+44*index,475)
		Equip_BagSideClick:SetVisible(1)
	end
end

-- 可合成左右键的能否点击
function SetLeftAndRightEnabled(index,b_Eable)
	if index ==1 then
		btn_Left:SetEnabled(b_Eable)
	elseif index ==2 then
		btn_Right:SetEnabled(b_Eable)
	end
end

-- 设置智能购买是否可见
function SetTalentBuyIsVisible(flag)
	check_talent:SetVisible(flag)
end
function SetTalentBuyIsChecked(flag)
	check_talentYes:SetVisible(flag)
end

function SetEffectTutorial(cid, cEnabled)
	if cid==1 then
		Equip_SuggestBag[1]:EnableImageAnimateEX(cEnabled, 7, 70, 5, 50, 5, -40)
	elseif cid==2 then
		btn_BuyEquipimg:EnableImageAnimateEX(cEnabled, 4, 70, 0, 0, 0, 0)
	else
	end
end

-- 设置显示
function SetMarketIsVisible(flag) 
	if n_market_ui ~= nil then
		if flag == 1 and n_market_ui:IsVisible() == false then
			n_market_ui:CreateResource()
			XClickMarketIndex(0,0)			-- 点击攻击类、攻击力
			clickBtnA:SetPosition(22,56)
			clickFontA:SetFontText(Equip_BtnFont[1],0xffffff)
			
			PyAttack_ui:SetVisible(0)
			MgAttack_ui:SetVisible(0)
			Defence_ui:SetVisible(0)
			ResetEquipBtnPosition(4)
			
			n_market_ui:SetVisible(1)			
		elseif flag == 0 and n_market_ui:IsVisible() == true then
			n_market_ui:DeleteResource()
			n_market_ui:SetVisible(0)
		end
	end
end

function GetMarketIsVisible()  
    if(n_market_ui ~= nil and market_ui:IsVisible()) then
		return 1
    else
		return 0
    end
end