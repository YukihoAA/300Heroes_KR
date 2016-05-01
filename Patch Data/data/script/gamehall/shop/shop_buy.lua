include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

local m_pFatherNode_Item = nil
local m_pFatherNode_Hero = nil

local EquipInfo = {}
EquipInfo.name = {}
EquipInfo.desc = {}
EquipInfo.pic = {}
EquipInfo.money = {}
EquipInfo.gold = {}
EquipInfo.honour = {}
EquipInfo.contri = {}
EquipInfo.vip = {}

local m_bBuyType = 0			-- 购买的商品类型

-- 购买点击界面
local Equip_name = nil
local Equip_desc = nil
local Equip_pic = nil
local Equip_money = nil
local Equip_gold = nil
local Equip_honour = nil
local Equip_contri = nil
local Equip_vip = nil
local Equip_BuyCount = nil
local Equip_Max = nil
local Equip_BuyByMoney = nil
local Equip_BuyByGold = nil
local Equip_BuyByHonour = nil
local Equip_BuyByExploit = nil
local Equip_BuyByVip = nil

-- Hero
local EveryInfoCount = {}
local Tip_ColLife = {}
local Num_BK = {}
local m_pIcon = nil				-- 英雄头像
local m_vecHeroSkillIcon = {}	-- 英雄技能图标
local m_pMoneyImg = nil
local m_pGoldImg = nil
local m_pHonourImg = nil
local m_pExploitImg = nil
local m_pVipImg = nil
local m_iMoney = 999
local m_iGold = 999
local m_pMoneyFont = nil
local m_pGoldFont = nil
local m_pHonourFont = nil
local m_pExploitFont = nil
local m_pVipFont = nil
local m_fNotEnoughL = nil
local m_fNotEnoughR = nil
local m_sNEL = "NULL"
local m_sNER = "NULL"
local buy_P = nil		-- 减
local buy_D = nil		-- 加
local ppx = -406
local ppy = -130
local isDownAdd = false
local isDownReduce = false

function InitShopBuy_ui(wnd,bisopen)
	g_shop_buy_ui = CreateWindow(wnd.id, (1920-438)/2, (1080-530)/2, 438, 530)
	g_shop_buy_ui:EnableBlackBackgroundTop(1)
	InitMain_ShopBuy(g_shop_buy_ui)
	g_shop_buy_ui:SetVisible(bisopen)
end

function InitMain_ShopBuy(wnd)
	wnd:AddImage(path_shop.."buyBK_rec.png",-4,-4,446,538)
	wnd:AddFont("购买方式", 15, 8, -119, -315, 200, 20, 0xffffff)
	Equip_name = wnd:AddFont("装备等级是超级全能升级包", 15, 8, -44, -140-ppy, 350, 20, 0xffffff)
	
	m_pGoldImg = wnd:AddImage(path_shop.."gold_shop.png", 715+ppx, 495+ppy, 64, 64)
	m_pMoneyImg = wnd:AddImage(path_shop.."money_shop.png", 463+ppx, 495+ppy, 64, 64)
	m_pHonourImg = wnd:AddImage(path_shop.."honour_shop.png", 715+ppx, 495+ppy, 64, 64)
	m_pExploitImg = wnd:AddImage(path_shop.."exploit_shop.png", 463+ppx, 495+ppy, 64, 64)
	m_pVipImg = wnd:AddImage(path_shop.."vippoint_shop.png", 590+ppx, 495+ppy, 64, 64)
	
	m_pGoldFont = m_pGoldImg:AddFontEx(m_iGold, 15, 0, 30, 7, 200, 15, 0x7cceda)
	m_pMoneyFont = m_pMoneyImg:AddFontEx(m_iMoney, 15, 0, 30, 7, 200, 15, 0xe4df8b)
	m_pHonourFont = m_pHonourImg:AddFontEx("1", 15, 0, 30, 7, 200, 15, 0xff83d1e7)
	m_pExploitFont = m_pExploitImg:AddFontEx("1", 15, 0, 30, 7, 200, 15, 0xffe4e18b)
	m_pVipFont = m_pVipImg:AddFontEx("1", 15, 0, 30, 7, 200, 15, 0x938ae3)
	
	m_fNotEnoughL = wnd:AddFont(m_sNEL, 15, 8, -410-ppx, -617-ppy, 200, 15, 0xc32a46)
	m_fNotEnoughR = wnd:AddFont(m_sNER, 15, 8, -660-ppx, -617-ppy, 200, 15, 0xc32a46)
	m_fNotEnoughL:SetVisible(0)
	m_fNotEnoughR:SetVisible(0)
	
	-- 金币购买按钮
	Equip_BuyByMoney = wnd:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png", 468+ppx, 550+ppy, 83, 35)
	Equip_BuyByMoney:AddFont("购买", 18, 0, 18, 5, 50, 20, 0xffffff)
	Equip_BuyByMoney.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if m_bBuyType == 0 then
			XClickMoneyBtnAtBuyItemUi(1)
		else
			XClickMoneyBtnAtBuyHeroUi(1)
		end
	end
	
	-- 钻石购买按钮
	Equip_BuyByGold = wnd:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png", 720+ppx, 550+ppy, 83, 35)
	Equip_BuyByGold:AddFont("购买", 18, 0, 18, 5, 50, 20, 0xffffff)
	Equip_BuyByGold.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if m_bBuyType == 0 then
			XClickGoldBtnAtBuyItemUi(1)
		else
			XClickGoldBtnAtBuyHeroUi(1)
		end
	end
	
	-- 功勋购买按钮
	Equip_BuyByExploit = wnd:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png", 468+ppx, 550+ppy, 83, 35)
	Equip_BuyByExploit:AddFont("购买", 18, 0, 18, 5, 50, 20, 0xffffff)
	Equip_BuyByExploit.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if m_bBuyType == 0 then
			XClickExploitBtnAtBuyItemUi(1)
		else
			XClickExploitBtnAtBuyHeroUi(1)
		end
	end
	
	-- 荣誉购买按钮
	Equip_BuyByHonour = wnd:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png", 720+ppx, 550+ppy, 83, 35)
	Equip_BuyByHonour:AddFont("购买", 18, 0, 18, 5, 50, 20, 0xffffff)
	Equip_BuyByHonour.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if m_bBuyType == 0 then
			XClickHonourBtnAtBuyItemUi(1)
		else
			XClickHonourBtnAtBuyHeroUi(1)
		end
	end
	
	-- Vip
	Equip_BuyByVip = wnd:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png", 588+ppx, 550+ppy, 83, 35)
	Equip_BuyByVip:AddFont("购买", 18, 0, 18, 5, 50, 20, 0xffffff)
	Equip_BuyByVip.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if m_bBuyType == 0 then
			XClickVipBtnAtBuyItemUi(1)
		else
			XClickVipBtnAtBuyHeroUi(1)
		end
	end
		
	m_pFatherNode_Item = wnd:AddImage(path_shop.."buyBK_rec.png",0,0,100,100)
	m_pFatherNode_Item:SetTransparent(0)
	m_pFatherNode_Item:SetVisible(0)
	m_pFatherNode_Hero = wnd:AddImage(path_shop.."buyBK_rec.png",0+ppx,0+ppy,100,100)
	m_pFatherNode_Hero:SetTransparent(0)
	m_pFatherNode_Hero:SetVisible(0)
	
	local buy_close = wnd:AddButton(path_shop.."close1_rec.png",path_shop.."close2_rec.png",path_shop.."close3_rec.png",804+ppx,134+ppy,35,35)
	buy_close.script[XE_LBUP] = function()
		XClickPlaySound(5)
		SetShopBuyIsVisible(0)
	end
	
	-- Item
	buy_D = m_pFatherNode_Item:AddButton(path_shop.."D_rec.png",path_shop.."D1_rec.png",path_shop.."D2_rec.png",141,140,30,30)
	buy_D.script[XE_LBDOWN] = function()
		-- XClickPlaySound(5)
		XClickAlwaysDownAddButton(1)
		isDownAdd = true
	end
	buy_D.script[XE_ONUNHOVER] = function()
		if isDownAdd then
			XClickShopItemBuyAddCount(1)
			XClickAlwaysUpAddButton(1)
		end
		isDownAdd = false
	end
	buy_D.script[XE_LBUP] = function()
		XClickPlaySound(5)
		-- XClickAlwaysDownAddButton(0)
		XClickShopItemBuyAddCount(1)
		XClickAlwaysUpAddButton(1)
		buy_P:SetEnabled(1)
		isDownAdd = false
	end
	
	buy_P = m_pFatherNode_Item:AddButton(path_shop.."P_rec.png",path_shop.."P1_rec.png",path_shop.."P2_rec.png",47,140,30,30)
	buy_P.script[XE_LBDOWN] = function()
		XClickAlwaysDownReduceButton(1)
		isDownReduce = true
	end
	buy_P.script[XE_ONUNHOVER] = function()
		if isDownReduce then
			XClickShopItemBuyPusCount(1)
			XClickAlwaysUpReduceButton(1)
		end
		isDownReduce = false
	end
	buy_P.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickShopItemBuyPusCount(1)
		XClickAlwaysUpReduceButton(1)
		buy_D:SetEnabled(1)
		isDownReduce = false
	end
	m_pFatherNode_Item:AddFont("物品说明", 13, 8, -169, -170, 100, 20, 0x8296d1)
	
	Equip_desc = m_pFatherNode_Item:AddFont("NULL", 15, 8, -69, -150, 300, 200, 0x82d2e6)
	
	Equip_pic = m_pFatherNode_Item:AddImageMultiple(path_equip.."bag_equip.png", "", "", 187, 70, 64, 64)
	Equip_pic:AddImage(path_shop.."itemside_shop.png",-6,-6,76,76)
	Equip_BuyCount = m_pFatherNode_Item:AddFontEx("999", 15, 8, -82, -145, 50, 15, 0xffffff)
	Equip_Max = m_pFatherNode_Item:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png", 300, 138, 83, 35)
	Equip_Max:AddFont("MAX", 18, 0, 15, 5, 50, 20, 0xffffff)
	Equip_Max.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickShopItemBuyMaxCount(1)
		buy_P:SetEnabled(1)
		buy_D:SetEnabled(0)
	end
	
	-- Hero
	m_pIcon = m_pFatherNode_Hero:AddImage(path_equip.."bag_equip.png", 453, 223, 64, 64)
	m_pIcon:AddImage(path_shop.."itemside_shop.png", -6, -6, 76,76)
	local Font_NQWER = {"被动","Q","W","E","R"}	
	local Font_QUA = {"生命","攻击","法术","团队","操作"}
	local MovedX,MovedY = 530,110
	
	for i = 1,5 do
		m_pFatherNode_Hero:AddImage(path_hero.."WAKEBTN1_hero.png",12+MovedX,55+28*i+MovedY,46,21)
		m_pFatherNode_Hero:AddFont(Font_QUA[i],12,0,18+MovedX,57+28*i+MovedY,100,12,0xbeb5ee)
		m_pFatherNode_Hero:AddImage(path_hero.."PTBK_hero.png",65+MovedX,60+28*i+MovedY,256,8)
		Num_BK[i] = m_pFatherNode_Hero:AddImage(path.."friend4_hall.png",255+MovedX,55+28*i+MovedY,32,32)
		EveryInfoCount[i] = Num_BK[i]:AddFont("10",12,8,42,-3,100,12,0xbeb5ee)
		for k =1,10 do
			Tip_ColLife[10*i-10+k] = m_pFatherNode_Hero:AddImage(path_hero.."PT"..i.."_hero.png",45+k*18+MovedX,60+28*i+MovedY,32,16)
		end
		
		m_vecHeroSkillIcon[i] = m_pFatherNode_Hero:AddImage(path_equip.."bag_equip.png", 460+ (72*(i-1)), 362, 50, 50)
		m_vecHeroSkillIcon[i]:AddImage(path_shop.."iconside_shop.png", -2, -2, 54,54)
	end
end

function SetShopBuyIsVisible(flag) 
	if g_shop_buy_ui ~= nil then
		if flag == 1 and g_shop_buy_ui:IsVisible() == false then
			g_shop_buy_ui:CreateResource()
			XShopBuyIsOpen(1)
			XSetBuyUiIsVisible(1)
			g_shop_buy_ui:SetVisible(1)
		elseif flag == 0 and g_shop_buy_ui:IsVisible() == true then
			XSetBuyUiIsVisible(0)
			XShopBuyIsOpen(0)
			g_shop_buy_ui:SetVisible(0)
			g_shop_buy_ui:DeleteResource()
		end
	end
end

function GetShopBuyIsVisible()  
    if(g_shop_buy_ui:IsVisible()) then
       XShopBuyIsOpen(1)
    else
       XShopBuyIsOpen(0)
    end
end

function GetShopBuyUiIsVisible()
	if g_shop_buy_ui ~= nil and g_shop_buy_ui:IsVisible() then
		return 1
	else
		return 0
	end
end

function SetShopItemBuyNameInfo( mStr)
	Equip_name:SetFontText(mStr, 0xffffff)
end

function SetShowType( cType)
	m_bBuyType = cType
end

function PopBuyUi()
	SetShopBuyIsVisible(1)
	if (m_bBuyType == 0) then
		m_pFatherNode_Item:SetVisible(1)
		m_pFatherNode_Hero:SetVisible(0)
	else
		m_pFatherNode_Item:SetVisible(0)
		m_pFatherNode_Hero:SetVisible(1)
		XClearSkinSelIndexForBuy_shopbuy()
	end
end

function BuyUiSetHeroInfo( cHeroIconPath, cSkillIcon_1, cSkillIcon_2, cSkillIcon_3, cSkillIcon_4, cSkillIcon_5, cPoint_1, cPoint_2, cPoint_3, cPoint_4, cPoint_5)
	m_pIcon.changeimage("..\\"..cHeroIconPath)
	m_vecHeroSkillIcon[1].changeimage("..\\"..cSkillIcon_1)
	m_vecHeroSkillIcon[2].changeimage("..\\"..cSkillIcon_2)
	m_vecHeroSkillIcon[3].changeimage("..\\"..cSkillIcon_3)
	m_vecHeroSkillIcon[4].changeimage("..\\"..cSkillIcon_4)
	m_vecHeroSkillIcon[5].changeimage("..\\"..cSkillIcon_5)
	for i = 1, 50 do
		Tip_ColLife[i]:SetVisible(0)
	end
	for i = 1, cPoint_1 do
		Tip_ColLife[i]:SetVisible(1)
	end
	for i = 11, cPoint_2+10 do
		Tip_ColLife[i]:SetVisible(1)
	end
	for i = 21, cPoint_3+20 do
		Tip_ColLife[i]:SetVisible(1)
	end
	for i = 31, cPoint_4+30 do
		Tip_ColLife[i]:SetVisible(1)
	end
	for i = 41, cPoint_5+40 do
		Tip_ColLife[i]:SetVisible(1)
	end
	EveryInfoCount[1]:SetFontText(tostring(cPoint_1), 0xffffff)
	EveryInfoCount[2]:SetFontText(tostring(cPoint_2), 0xffffff)
	EveryInfoCount[3]:SetFontText(tostring(cPoint_3), 0xffffff)
	EveryInfoCount[4]:SetFontText(tostring(cPoint_4), 0xffffff)
	EveryInfoCount[5]:SetFontText(tostring(cPoint_5), 0xffffff)
end

-- 没有足够的金币
function NotEnoughMoney( cStr)
	Equip_BuyByMoney:SetEnabled(0)
	--Equip_BuyByMoney_UnEnable:SetVisible(1)
	if Equip_BuyByMoney:IsVisible() then
		m_fNotEnoughL:SetFontText( cStr, 0xc32a46)
		m_fNotEnoughL:SetVisible(1)
	end
end

-- 没有足够的钻石
function NotEnoughGold( cStr)
	Equip_BuyByGold:SetEnabled(0)
	--Equip_BuyByGold_UnEnable:SetVisible(1)
	if Equip_BuyByGold:IsVisible() then
		m_fNotEnoughR:SetFontText( cStr, 0xc32a46)
		m_fNotEnoughR:SetVisible(1)
	end
end

-- 没有足够的荣誉
function NotEnoughHonour( cStr)
	Equip_BuyByHonour:SetEnabled(0)
	--Equip_BuyByHonour_UnEnable:SetVisible(1)
	if Equip_BuyByHonour:IsVisible() then
		m_fNotEnoughR:SetFontText( cStr, 0xc32a46)
		m_fNotEnoughR:SetVisible(1)
	end
end

-- 没有足够的功勋
function NotEnoughExploit( cStr)
	Equip_BuyByExploit:SetEnabled(0)
	--Equip_BuyByExploit_UnEnable:SetVisible(1)
	if Equip_BuyByExploit:IsVisible() then
		m_fNotEnoughL:SetFontText( cStr, 0xc32a46)
		m_fNotEnoughL:SetVisible(1)
	end
end

-- NotEnoughVipPoint
function NotEnoughVipPoint( cStr)
	Equip_BuyByVip:SetEnabled(0)
	--Equip_BuyByVip_UnEnable:SetVisible(1)
	if Equip_BuyByVip:IsVisible() then
		m_fNotEnoughL:SetFontText( cStr, 0xc32a46)
		m_fNotEnoughL:SetVisible(1)
	end
end

function ReSetBuyBtn()
	m_fNotEnoughR:SetVisible(0)
	m_fNotEnoughL:SetVisible(0)
	Equip_BuyByGold:SetVisible(0)
	Equip_BuyByMoney:SetVisible(0)
	Equip_BuyByExploit:SetVisible(0)
	Equip_BuyByHonour:SetVisible(0)
	Equip_BuyByVip:SetVisible(0)
	m_pGoldImg:SetVisible(0)
	m_pMoneyImg:SetVisible(0)
	m_pHonourImg:SetVisible(0)
	m_pExploitImg:SetVisible(0)
	m_pVipImg:SetVisible(0)
	
	buy_D:SetEnabled(1)
	buy_P:SetEnabled(0)
	Equip_Max:SetEnabled(1)
end

-- 设置钻石价格
function SetHeroBuyGold( cGold)
	m_pGoldFont:SetFontText(cGold, 0x7cceda)
	if (m_fNotEnoughR:IsVisible() == false) then
		Equip_BuyByGold:SetEnabled(1)
		--Equip_BuyByGold_UnEnable:SetVisible(0)
	end
end

-- 设置金币价格
function SetHeroBuyMoney( cMoney)
	m_pMoneyFont:SetFontText(cMoney, 0xe4df8b)
	if (m_fNotEnoughL:IsVisible() == false) then
		Equip_BuyByMoney:SetEnabled(1)
		--Equip_BuyByMoney_UnEnable:SetVisible(0)
	end
end

-- 设置荣誉价格
function SetHeroBuyHonour( cHonour)
	m_pHonourFont:SetFontText(tostring(cHonour), 0xff83d1e7)
	if (m_fNotEnoughL:IsVisible() == false) then
		Equip_BuyByHonour:SetEnabled(1)
		--Equip_BuyByHonour_UnEnable:SetVisible(0)
	end
end

-- 设置功勋价格
function SetHeroBuyExploit( cExploit)
	m_pExploitFont:SetFontText(tostring(cExploit), 0xffe4e18b)
	if (m_fNotEnoughR:IsVisible() == false) then
		Equip_BuyByExploit:SetEnabled(1)
		--Equip_BuyByGold_UnEnable:SetVisible(0)
	end
end

function SetHeroBuyVip( cVipPoint)
	m_pVipFont:SetFontText(tostring(cVipPoint), 0x938ae3)
	if (m_fNotEnoughR:IsVisible() == false) then
		Equip_BuyByVip:SetEnabled(1)
		--Equip_BuyByVip_UnEnable:SetVisible(0)
	end
end

-- 设置金币购买按钮是否显示
function SetBuyBtnIsVisible_Money( cVisible)
	m_pMoneyImg:SetVisible(cVisible)
	Equip_BuyByMoney:SetVisible(cVisible)
end

-- 设置钻石购买按钮是否显示
function SetBuyBtnIsVisible_Gold( cVisible)
	m_pGoldImg:SetVisible(cVisible)
	Equip_BuyByGold:SetVisible(cVisible)
end

-- 设置荣誉购买按钮是否显示
function SetBuyBtnIsVisible_Honour( cVisible)
	m_pHonourImg:SetVisible(cVisible)
	Equip_BuyByHonour:SetVisible(cVisible)
	-- if cVisible==0 or cVisible==false then
		-- m_pExploitImg:SetPosition(610+ppx, 495+ppy)
		-- Equip_BuyByExploit:SetPosition(610+ppx, 550+ppy)
		-- m_fNotEnoughL:SetPosition(141, 480)
	-- else
		-- m_pExploitImg:SetPosition(725+ppx, 495+ppy)
		-- Equip_BuyByExploit:SetPosition(730+ppx, 550+ppy)
		-- m_fNotEnoughL:SetPosition(20, 480)
	-- end
end

-- 设置功勋购买按钮是否显示
function SetBuyBtnIsVisible_Exploit( cVisible)
	m_pExploitImg:SetVisible(cVisible)
	Equip_BuyByExploit:SetVisible(cVisible)
	-- if cVisible==0 or cVisible==false then
		-- m_pHonourImg:SetPosition(610+ppx, 495+ppy)
		-- Equip_BuyByHonour:SetPosition(610+ppx, 550+ppy)
		-- m_fNotEnoughR:SetPosition(141, 480)
	-- else
		-- m_pHonourImg:SetPosition(725+ppx, 495+ppy)
		-- Equip_BuyByHonour:SetPosition(730+ppx, 550+ppy)
		-- m_fNotEnoughR:SetPosition(266, 480)
	-- end
end

-- 设置Vip购买按钮是否显示
function SetBuyBtnIsVisible_VIP( cVisible)
	m_pVipImg:SetVisible(cVisible)
	Equip_BuyByVip:SetVisible(cVisible)
	-- if cVisible==0 or cVisible==false then
		-- m_fNotEnoughL:SetPosition(141, 480)
	-- else
		-- m_fNotEnoughL:SetPosition(20, 480)
	-- end
end

function SetContrnlPosition(cpos)
	if cpos==0 then
		-- 只显示R
		m_pGoldImg:SetPosition(590+ppx, 495+ppy)
		Equip_BuyByGold:SetPosition(588+ppx, 550+ppy)
		m_pHonourImg:SetPosition(590+ppx, 495+ppy)
		Equip_BuyByHonour:SetPosition(588+ppx, 550+ppy)
		m_fNotEnoughR:SetPosition(123, 480)
	elseif cpos==1 then
		-- 只显示L
		m_pVipImg:SetPosition(590+ppx, 495+ppy)
		Equip_BuyByVip:SetPosition(588+ppx, 550+ppy)
		m_pMoneyImg:SetPosition(590+ppx, 495+ppy)
		Equip_BuyByMoney:SetPosition(588+ppx, 550+ppy)
		m_pExploitImg:SetPosition(590+ppx, 495+ppy)
		Equip_BuyByExploit:SetPosition(588+ppx, 550+ppy)
		m_fNotEnoughL:SetPosition(123, 480)
	elseif cpos==2 then
		-- 都显示
		m_pGoldImg:SetPosition(710+ppx, 495+ppy)
		Equip_BuyByGold:SetPosition(710+ppx, 550+ppy)
		m_pHonourImg:SetPosition(710+ppx, 495+ppy)
		Equip_BuyByHonour:SetPosition(710+ppx, 550+ppy)
		m_fNotEnoughR:SetPosition(245, 480)
		m_pMoneyImg:SetPosition(458+ppx, 495+ppy)
		Equip_BuyByMoney:SetPosition(458+ppx, 550+ppy)
		m_pVipImg:SetPosition(458+ppx, 495+ppy)
		Equip_BuyByVip:SetPosition(458+ppx, 550+ppy)
		m_pExploitImg:SetPosition(458+ppx, 495+ppy)
		Equip_BuyByExploit:SetPosition(458+ppx, 550+ppy)
		m_fNotEnoughL:SetPosition(-5, 480)
	else
	end
end

function VisibleBuyUi()
	g_shop_buy_ui:SetVisible(0)
	-- for i=1, 5 do
		-- XSetImageTip(m_vecHeroSkillIcon[i].id, 0)
	-- end
	-- XSetImageTip(m_pIcon.id, 0)
end

function SetBuyItemCount( cCount)
	Equip_BuyCount:SetFontText(cCount, 0xffffff)
end

function SetBuyItemDescAndIconPath( cDesc, cPath, cPath1, cPath2, cBx, cBy, cW, cH, cIsSkin)
	Equip_desc:SetFontText( cDesc, 0x82d2e6)
	Equip_pic.changeimageMultiple( "..\\"..cPath, "..\\"..cPath1, "..\\"..cPath2)
	-- log("\nIconPath = "..cPath)
	-- if cIsSkin==1 then
		-- Equip_pic:SetAddImageRect(Equip_pic.id, cBx, cBy, cW, cH, 627, 181, 50, 50)
	-- else
		-- Equip_pic:SetAddImageRect(Equip_pic.id, 0, 0, 50, 50, 627, 181, 50, 50)
	-- end
end

-- 设置ITEM相关加号减号MAX按钮是否显示
function SetChangeCountBtnIsVisible( cVisible)
	buy_D:SetVisible(cVisible)
	buy_P:SetVisible(cVisible)
	Equip_Max:SetVisible(cVisible)
	Equip_BuyCount:SetVisible(cVisible)
end

function SetHeroSkillTip_shopbuy( ctip, cindex)
	XSetImageTip(m_vecHeroSkillIcon[cindex].id, ctip)
end

function SetHeroSkinTip_shopbuy(ctip)
	XSetImageTip(Equip_pic.id, ctip)
end

function SetAddButtonEnabled_shopitembuy( cEnabled)
	buy_D:SetEnabled(cEnabled)
end
function SetDucButtonEnabled_shopitembuy( cEnabled)
	buy_P:SetEnabled(cEnabled)
end

function SetGoldButtonEnabled_shopitembuy( cEnabled)
	Equip_BuyByGold:SetEnabled(cEnabled)
end