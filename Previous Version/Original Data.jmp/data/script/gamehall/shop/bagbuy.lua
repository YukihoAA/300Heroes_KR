include("../Data/Script/Common/include.lua")

-- 相關成員

-- 最上面的一坨
local img_bagbuybg = nil	-- 背景
local btn_closeui = nil		-- 關
local txt_itemname = nil	-- 道具名
-- 中間的一坨
local img_itemicon = nil	-- 道具圖
local btn_add = nil			-- 加
local btn_pus = nil			-- 減
local txt_buytime = nil		-- 購買天數
local txt_Describe = nil	-- 描述
-- 最下面的一坨
local txt_notenoughtgold = nil
local txt_notenoughtmoney = nil
local txt_gold = nil
local txt_money = nil
local img_gold = nil
local img_money = nil
local btn_goldbuy = nil
local btn_moneybuy = nil

function InitBagBuyUi(wnd,bisopen)
	g_bagbuy_ui = CreateWindow(wnd.id, (1920-438)/2, (1080-530)/2, 438, 530)
	g_bagbuy_ui:EnableBlackBackgroundTop(1)
	Init_BagBuyUi(g_bagbuy_ui)
	g_bagbuy_ui:SetVisible(bisopen)
end

function Init_BagBuyUi(father)
	img_bagbuybg = father:AddImage(path_shop.."buyBK_rec.png",-4,-4,446,538)
	
	btn_closeui = img_bagbuybg:AddButton(path_shop.."close1_rec.png",path_shop.."close2_rec.png",path_shop.."close3_rec.png", 402, 8, 35,35)
	
	btn_closeui.script[XE_LBUP] = function()
		XClickCloseUiButton_BagBuy()
	end
	
	txt_itemname = img_bagbuybg:AddFont("未知", 15, 8, -49, -10, 350, 20, 0xffffff)
	
	img_itemicon = img_bagbuybg:AddImage(path_equip.."bag_equip.png", 199, 70, 50, 50)
	img_itemicon:AddImage(path_shop.."iconside_shop.png", -2,-2,54,54)
	
	btn_add = img_bagbuybg:AddButton(path_shop.."D_rec.png", path_shop.."D1_rec.png", path_shop.."D2_rec.png", 272, 130, 30, 30)
	btn_pus = img_bagbuybg:AddButton(path_shop.."P_rec.png", path_shop.."P1_rec.png", path_shop.."P2_rec.png", 147, 130, 30, 30)
	
	btn_add.script[XE_LBUP] = function()
		-- "+"
		XClickAddButton_BagBuy()
	end
	btn_pus.script[XE_LBUP] = function()
		-- "-"
		XClickPusButton_BagBuy()
	end
	
	txt_buytime = img_bagbuybg:AddFont("99天", 15, 8, -175, -135, 100, 15, 0xffffff)
	
	img_bagbuybg:AddFont("物品描述", 15, 8, -174, -170, 100, 20, 0xffffff)
	img_bagbuybg:AddFont("购买方式", 15, 8, -124, -315, 200, 20, 0xffffff)
	
	txt_Describe = img_bagbuybg:AddFont("未知", 15, 8, -74, -150, 300, 200, 0xffffff)
	
	txt_notenoughtgold = img_bagbuybg:AddFont("身上钻石不够", 15, 8, -245, -465, 200, 15, 0xff0000)
	txt_notenoughtmoney = img_bagbuybg:AddFont("身上金币不够", 15, 8, -25, -465, 200, 15, 0xff0000)
	img_money = img_bagbuybg:AddImage(path_shop.."money_shop.png", 85, 360, 64, 64)
	img_gold = img_bagbuybg:AddImage(path_shop.."gold_shop.png", 305, 360, 64, 64)
	txt_money = img_money:AddFontEx("1024", 15, 0, 30, 7, 60, 15, 0xe4df8b)
	txt_gold = img_gold:AddFontEx("1024", 15, 0, 30, 7, 60, 15, 0x7cceda)
	btn_moneybuy = img_bagbuybg:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png", 85, 410, 83, 35)
	btn_moneybuy:AddFont("购买", 18, 0, 18, 5, 50, 20, 0xffffff)
	btn_goldbuy = img_bagbuybg:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png", 305, 410, 83, 35)
	btn_goldbuy:AddFont("购买", 18, 0, 18, 5, 50, 20, 0xffffff)
	
	btn_moneybuy.script[XE_LBUP] = function()
		XClickBuyButtonMoney_BagBuy()
	end
	
	btn_goldbuy.script[XE_LBUP] = function()
		XClickBuyButtonGold_BagBuy()
	end
end

function SetBagBuyUiIsVisible(flag) 
	if g_bagbuy_ui ~= nil then
		if flag == 1 and g_bagbuy_ui:IsVisible() == false then
			g_bagbuy_ui:CreateResource()
			g_bagbuy_ui:SetVisible(1)
		elseif flag == 0 and g_bagbuy_ui:IsVisible() == true then
			g_bagbuy_ui:DeleteResource()
			g_bagbuy_ui:SetVisible(0)
		end
	end
end

-- 清空所有數據
function ClearAllButtonState_BagBuy()
	if btn_pus == nil or btn_add == nil or txt_notenoughtgold == nil or txt_notenoughtmoney == nil or img_money == nil or img_gold == nil or btn_moneybuy == nil or btn_goldbuy == nil or btn_moneybuy == nil or btn_goldbuy == nil then
		log("\n[ bagbuy.lua [ClearAllButtonState_BagBuy] == error ]")
		return
	end

	btn_pus:SetEnabled(0)
	btn_add:SetEnabled(1)
	txt_notenoughtgold:SetVisible(0)
	txt_notenoughtmoney:SetVisible(0)
	img_money:SetVisible(0)
	img_gold:SetVisible(0)
	btn_moneybuy:SetVisible(0)
	btn_goldbuy:SetVisible(0)
	btn_moneybuy:SetEnabled(1)
	btn_goldbuy:SetEnabled(1)
end

-- 設置購買按鈕enable
function SetBuyButtonEnableState_BagBuy(State,isEnough)
	if btn_goldbuy == nil or txt_notenoughtgold == nil or btn_moneybuy == nil or txt_notenoughtmoney == nil then
		log("\n[ bagbuy.lua [SetBuyButtonEnableState_BagBuy] == error ]")
		return
	end

	if State == 0 then
		btn_goldbuy:SetEnabled(isEnough)
		txt_notenoughtgold:SetVisible(TakeReverse(isEnough))
	else
		btn_moneybuy:SetEnabled(isEnough)
		txt_notenoughtmoney:SetVisible(TakeReverse(isEnough))
	end
end

-- 設置購買按鈕visible
function SetBuyButtonVisibleState_BagBuy(State,isvisible)
	if btn_goldbuy == nil or img_gold == nil or txt_notenoughtgold == nil or btn_moneybuy == nil or img_money == nil then
		log("\n[bagbuy.lua [ SetBuyButtonVisibleState_BagBuy] == error ]")
		return
	end

	if State == 0 then
		btn_goldbuy:SetVisible(isvisible)
		img_gold:SetVisible(isvisible)
		btn_goldbuy:SetPosition(182, 415)
		img_gold:SetPosition(192, 365)
		txt_notenoughtgold:SetPosition(123, 475)
	elseif State == 1 then
		btn_moneybuy:SetVisible(isvisible)
		img_money:SetVisible(isvisible)
	else
		btn_goldbuy:SetVisible(isvisible)
		btn_moneybuy:SetVisible(isvisible)
		img_gold:SetVisible(isvisible)
		img_money:SetVisible(isvisible)
		img_gold:SetPosition(305, 365)
		btn_goldbuy:SetPosition(305, 415)
		txt_notenoughtgold:SetPosition(250, 475)
	end
end

-- 繪製
function Refeash_BagBuy(cfirst, citemname, citemdesc, citembuytime, citemgold, citemmoney, ciconpath)
	if txt_itemname == nil or txt_Describe == nil or txt_buytime == nil or txt_gold == nil or txt_money == nil or img_itemicon == nil then
		log("\n[ bagbuy.lua [Refeash_BagBuy] == error ]")
		return
	end

	if cfirst == 1 then
		txt_itemname:SetFontText(citemname, 0xffffff)
		txt_Describe:SetFontText(citemdesc, 0xffffff)
	end
	txt_buytime:SetFontText(citembuytime, 0xffffff)
	txt_gold:SetFontText(tostring(citemgold), 0x7cceda)
	txt_money:SetFontText(tostring(citemmoney), 0xe4df8b)
	img_itemicon.changeimage(".."..ciconpath)
end

-- 設置加減狀態
function SetAddPusButtonState_BagBuy(cstate, cenable)
	if btn_pus == nil then
		log("\n[ bagbuy.lua [SetAddPusButtonState_BagBuy] == error ]")
		return
	end

	if cstate == 0 then
		btn_pus:SetEnabled(cenable)
	else
		btn_add:SetEnabled(cenable)
	end
end