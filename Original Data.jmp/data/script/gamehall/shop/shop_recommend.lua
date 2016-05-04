include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

local click_bk = nil
local Adv_list = {}

-- 新品上架
local wndA = {}				-- 主窗口
local wndA_name = {}		-- 商品名称
local wndA_pic = {}			-- 商品图片
local wndA_desc = {}		-- 商品描述
local wndA_Time = {}		-- 商品剩余时间

local wndA_money = {}		-- 金币价格
local wndA_gold = {}		-- 钻石价格
local wndA_honour = {}		-- 功勋价格
local wndA_contri = {}		-- 荣誉价格
local wndA_vip = {}			-- VIP价格

local wndA_moneyfont = {}
local wndA_goldfont = {}

local wndA_flag = {}		-- 商品限时、打折等等
local wndA_buy = {}			-- 购买按钮

-- 火爆热销
local wndB = {}				-- 主窗口
local wndB_name = {}		-- 商品名称
local wndB_pic = {}			-- 商品图片
local wndB_desc = {}		-- 商品描述
local wndB_Time = {}		-- 商品剩余时间

local wndB_money = {}		-- 金币价格
local wndB_gold = {}		-- 钻石价格
local wndB_honour = {}		-- 功勋价格
local wndB_contri = {}		-- 荣誉价格
local wndB_vip = {}			-- VIP价格

local wndB_moneyfont = {}
local wndB_goldfont = {}

local wndB_flag = {}		-- 商品限时、打折等等
local wndB_buy = {}			-- 购买按钮

-- 限时打折
local wndC = {}				-- 主窗口
local wndC_name = {}		-- 商品名称
local wndC_pic = {}			-- 商品图片
local wndC_desc = {}		-- 商品描述
local wndC_Time = {}		-- 商品剩余时间

local wndC_money = {}		-- 金币价格
local wndC_gold = {}		-- 钻石价格
local wndC_honour = {}		-- 功勋价格
local wndC_contri = {}		-- 荣誉价格
local wndC_vip = {}			-- VIP价格

local wndC_moneyfont = {}
local wndC_goldfont = {}

local wndC_flag = {}		-- 商品限时、打折等等
local wndC_buy = {}			-- 购买按钮

local ppx = -50
local ppy = -150

local EquipInfo = {}
EquipInfo.mstrName = {}			-- 装备名称
EquipInfo.mstrPictureAdr = {}	-- 装备图片路径
EquipInfo.mstrDesc = {}			-- 装备描述
EquipInfo.mleftTime = {}		-- 剩余时间
EquipInfo.mIsCanBuy = {}		-- 是否能购买
EquipInfo.mmoney = {}
EquipInfo.mgold = {}
EquipInfo.mhonour = {}
EquipInfo.mcontri = {}
EquipInfo.mvip = {}
EquipInfo.mm_Flag = {}			-- 装备标签（限时、打折...）
EquipInfo.mm_IsShow = {}		-- 用来判断该空间是否显示
EquipInfo.mId = {}
EquipInfo.mItemId = {}
EquipInfo.mTip = {}
EquipInfo.mIsHaveHero = {}

function InitShop_RecommendUI(wnd, bisopen)
	g_shop_recommend_ui = CreateWindow(wnd.id, 50, 150, 900, 600)
	InitMainShop_Recommend(g_shop_recommend_ui)
	g_shop_recommend_ui:SetVisible(bisopen)
end
function InitMainShop_Recommend(wnd)

	-- 广告部分
	for i=1,5 do
		local posy = 18+120*i
		Adv_list[i] = wnd:AddImage( "Lobby/Adv"..i.."_rec.jpg",60+ppx,posy+ppy,497,106 )
		Adv_list[i].script[XE_LBUP] = function()
			-- 广告点击购买
			XClickPlaySound(5)
			click_bk:SetPosition(47+ppx,posy-13+ppy)
			-- log("\nEquipInfo.mIsCanBuy[i+6] = "..EquipInfo.mIsCanBuy[i+6])
			-- log("\nEquipInfo.mIsHaveHero[i+6] = "..EquipInfo.mIsHaveHero[i+6])
			if EquipInfo.mIsHaveHero[i+6]==1 and EquipInfo.mIsCanBuy[i+6]=="1" then
				-- log("\naaaaaaa")
				XShopBuyItemIndexForLua(i+5)
				XShopClickBuyItem(1, EquipInfo.mId[i+6], EquipInfo.mItemId[i+6])
			elseif EquipInfo.mIsHaveHero[i+6]==0 and EquipInfo.mIsCanBuy[i+6]=="1" then
				-- log("\nbbbbbbb")
				XShopBuyItemIndexForLua(i+5)
				XShopClickBuyItem_Skin(EquipInfo.mItemId[i+6])
			end
		end
		--local aa = Adv_list[i]:AddImage(path_shop.."Advfont_rec.png",10,75,256,32)
		--aa:SetTouchEnabled(0)
	end
	click_bk = wnd:AddImage(path_shop.."AdvBK_rec.png",47+ppx,125+ppy,521,128)
	
	-- 右半部分
	wnd:AddImage(path_shop.."flag1_rec.png",595+ppx,135+ppy,72,72)
	wnd:AddImage(path_shop.."flag2_rec.png",595+ppx,335+ppy,72,72)
	wnd:AddImage(path_shop.."flag3_rec.png",595+ppx,535+ppy,72,72)
	
	wnd:AddImage(path_shop.."line_rec.png",585+ppx,325+ppy,615,2)
	wnd:AddImage(path_shop.."line_rec.png",585+ppx,525+ppy,615,2)
	
	
	-- 新品上架
	for i=1,2 do
		local posx = 675+(i-1)*210
		wndA[i] = wnd:AddImage(path_shop.."ITEMBK_shop.png",posx+ppx,130+ppy,212,195)
		wndA_name[i] = wndA[i]:AddFont("新品上架", 15, 8, -5, -15, 200, 30, 0x83d1e7)
		wndA_flag[i] = wndA[i]:AddImage(path_shop.."flag5_shop.png",0,42,128,32)
		--wndA_Time[i] = wndA[i]:AddFont("99天\n20小时", 11, 0, 155, 57, 50, 50, 0xbeb5ee)
		wndA_pic[i] = wndA[i]:AddImage(path_equip.."bag_equip.png",74,44,64,64)
		wndA_pic[i]:AddImage(path_shop.."itemside_shop.png",-6,-6,76,76)
		
		wndA_money[i] = wndA[i]:AddImage(path_shop.."money_shop.png",7,110,64,64)
		wndA_money[i]:SetVisible(0)
		wndA_gold[i] = wndA[i]:AddImage(path_shop.."gold_shop.png",72,110,64,64)
		
		wndA_moneyfont[i] = wndA_money[i]:AddFontEx("1", 15, 0, 33, 8, 100, 15, 0xe4e18b)
		wndA_goldfont[i] = wndA_gold[i]:AddFontEx("1", 15, 0, 33, 8, 100, 15, 0x83d1e7)
			
		wndA_buy[i] = wndA[i]:AddButton(path_setup.."buy1_setup.png", path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",65,145,83,35)
		wndA_buy[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			--SetShopItemBuyNameInfo(EquipInfo.mstrName[i])
			XShopClickBuyItem(1, EquipInfo.mId[i], EquipInfo.mItemId[i])
			--SetShopBuyIsVisible(1)
		end
			
		wndA_buy[i]:AddFont("购买", 15, 0, 22, 7, 100, 20, 0xc7bcf6)
	end	
	-- local wndA_btnUp = wnd:AddButton(path_shop.."up1_rec.png",path_shop.."up2_rec.png",path_shop.."up3_rec.png",1114+ppx,145+ppy,42,32)
	-- local wndA_btnDown = wnd:AddButton(path_shop.."down1_rec.png",path_shop.."down2_rec.png",path_shop.."down3_rec.png",1114+ppx,270+ppy,42,32)
	-- local wndA_mid = wnd:AddImage(path_shop.."mid_rec.png",1103+ppx,200+ppy,64,64)
	-- wndA_mid:AddFont("/", 15, 0, 24, 15, 100, 20, 0x83d1e7)
	-- local wndA_midFont = wndA_mid:AddFont("10", 15, 0, 28, 15, 100, 20, 0x83d1e7)
	-- local wndA_midpage = wndA_mid:AddFont("2", 15, 0, 12, 15, 100, 20, 0x83d1e7)
	
	--------火爆热销
	for i=1,2 do
		local posx = 675+(i-1)*210
		wndB[i] = wnd:AddImage(path_shop.."ITEMBK_shop.png",posx+ppx,330+ppy,212,195)
		wndB_name[i] = wndB[i]:AddFont("新品上架", 15, 8, -5, -15, 200, 30, 0x83d1e7)
		wndB_flag[i] = wndB[i]:AddImage(path_shop.."flag3_shop.png",0,42,128,32)
		--wndB_Time[i] = wndB[i]:AddFont("99天\n20小时", 11, 0, 155, 57, 50, 50, 0xbeb5ee)
		wndB_pic[i] = wndB[i]:AddImage(path_equip.."bag_equip.png",74,44,64,64)
		wndB_pic[i]:AddImage(path_shop.."itemside_shop.png",-6,-6,76,76)
		
		wndB_money[i] = wndB[i]:AddImage(path_shop.."money_shop.png",7,110,64,64)
		wndB_money[i]:SetVisible(0)
		wndB_gold[i] = wndB[i]:AddImage(path_shop.."gold_shop.png",72,110,64,64)
		
		wndB_moneyfont[i] = wndB_money[i]:AddFontEx("1", 15, 0, 33, 8, 100, 20, 0xe4e18b)
		wndB_goldfont[i] = wndB_gold[i]:AddFontEx("1", 15, 0, 33, 8, 100, 20, 0x83d1e7)
			
		wndB_buy[i] = wndB[i]:AddButton(path_setup.."buy1_setup.png", path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",65,145,83,35)
		wndB_buy[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			--SetShopItemBuyNameInfo(EquipInfo.mstrName[i+2])
			XShopClickBuyItem(1, EquipInfo.mId[i+2], EquipInfo.mItemId[i+2])
			--SetShopBuyIsVisible(1)
		end
			
		wndB_buy[i]:AddFont("购买", 15, 0, 22, 7, 100, 20, 0xc7bcf6)
	end	
	-- local wndB_btnUp = wnd:AddButton(path_shop.."up1_rec.png",path_shop.."up2_rec.png",path_shop.."up3_rec.png",1114+ppx,345+ppy,42,32)
	-- local wndB_btnDown = wnd:AddButton(path_shop.."down1_rec.png",path_shop.."down2_rec.png",path_shop.."down3_rec.png",1114+ppx,470+ppy,42,32)
	-- local wndB_mid = wnd:AddImage(path_shop.."mid_rec.png",1103+ppx,400+ppy,64,64)
	-- wndB_mid:AddFont("/", 15, 0, 24, 15, 100, 20, 0x83d1e7)
	-- local wndB_midFont = wndB_mid:AddFont("50", 15, 0, 28, 15, 100, 20, 0x83d1e7)
	-- local wndB_midpage = wndB_mid:AddFont("22", 15, 0, 12, 15, 100, 20, 0x83d1e7)
	
	--------限时打折
	for i=1,2 do
		local posx = 675+(i-1)*210
		wndC[i] = wnd:AddImage(path_shop.."ITEMBK_shop.png",posx+ppx,530+ppy,212,195)
		wndC_name[i] = wndC[i]:AddFont("新品上架", 15, 8, -5, -15, 200, 30, 0x83d1e7)
		wndC_flag[i] = wndC[i]:AddImage(path_shop.."flag2_shop.png",0,42,128,32)
		--wndC_Time[i] = wndC[i]:AddFont("99天\n20小时", 11, 0, 155, 57, 50, 50, 0xbeb5ee)
		wndC_pic[i] = wndC[i]:AddImage(path_equip.."bag_equip.png",74,44,64,64)
		wndC_pic[i]:AddImage(path_shop.."itemside_shop.png",-6,-6,76,76)
		
		wndC_money[i] = wndC[i]:AddImage(path_shop.."money_shop.png",7,110,64,64)
		wndC_money[i]:SetVisible(0)
		wndC_gold[i] = wndC[i]:AddImage(path_shop.."gold_shop.png",72,110,64,64)
		
		wndC_moneyfont[i] = wndC_money[i]:AddFontEx("1", 15, 0, 33, 8, 100, 15, 0xe4e18b)
		wndC_goldfont[i] = wndC_gold[i]:AddFontEx("1", 15, 0, 33, 8, 100, 15, 0x83d1e7)
			
		wndC_buy[i] = wndC[i]:AddButton(path_setup.."buy1_setup.png", path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",65,145,83,35)
		wndC_buy[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			--SetShopItemBuyNameInfo(EquipInfo.mstrName[i+4])
			XShopClickBuyItem(1, EquipInfo.mId[i+4], EquipInfo.mItemId[i+4])
			--SetShopBuyIsVisible(1)
		end
			
		wndC_buy[i]:AddFont("购买", 15, 0, 22, 7, 100, 20, 0xc7bcf6)
	end	
	-- local wndC_btnUp = wnd:AddButton(path_shop.."up1_rec.png",path_shop.."up2_rec.png",path_shop.."up3_rec.png",1114+ppx,545+ppy,42,32)
	-- local wndC_btnDown = wnd:AddButton(path_shop.."down1_rec.png",path_shop.."down2_rec.png",path_shop.."down3_rec.png",1114+ppx,670+ppy,42,32)
	-- local wndC_mid = wnd:AddImage(path_shop.."mid_rec.png",1103+ppx,600+ppy,64,64)
	-- wndC_mid:AddFont("/", 15, 0, 24, 15, 100, 20, 0x83d1e7)
	-- local wndC_midFont = wndC_mid:AddFont("8", 15, 0, 28, 15, 100, 20, 0x83d1e7)
	-- local wndC_midpage = wndC_mid:AddFont("2", 15, 0, 12, 15, 100, 20, 0x83d1e7)
end

function SetShop_RecommendIsVisible(flag) 
	if g_shop_recommend_ui ~= nil then
		if flag == 1 and g_shop_recommend_ui:IsVisible() == false then
			g_shop_recommend_ui:SetVisible(1)
			click_bk:SetPosition(47+ppx,125+ppy)
			XShopUiIsClick(1, 1)
		elseif flag == 0 and g_shop_recommend_ui:IsVisible() == true then
			g_shop_recommend_ui:SetVisible(0)
		end
	end
end

function GetShop_RecommendIsVisible()  
    if(g_shop_recommend_ui:IsVisible()) then
       -- XGameHeroSkinIsOpen(1)
    else
       -- XGameHeroSkinIsOpen(0)
    end
end

function SecRecommend_ItemInfo(strName,strPictureAdr,strDesc,leftTime,money,gold,honour,contri,vip,m_Flag,IsCanBuy,Id,ItemId, IsCanFree, cTip, IsHaveHero)
	local size = #EquipInfo.mstrName+1
	EquipInfo.mstrName[size] = strName
	EquipInfo.mstrPictureAdr[size] = strPictureAdr
	EquipInfo.mstrDesc[size] = strDesc
	EquipInfo.mleftTime[size] = leftTime
	EquipInfo.mIsCanBuy[size] = IsCanBuy

	EquipInfo.mmoney[size] = money
	EquipInfo.mgold[size] = gold
	EquipInfo.mhonour[size] = honour
	EquipInfo.mcontri[size] = contri
	EquipInfo.mvip[size] = vip
	EquipInfo.mm_Flag[size] = m_Flag
	EquipInfo.mId[size] = Id
	EquipInfo.mItemId[size] = ItemId
	EquipInfo.mTip[size] = cTip
	EquipInfo.mIsHaveHero[size] = IsHaveHero
	-- log("\nmoney = "..EquipInfo.mmoney[size])
	-- log("\ngold = "..EquipInfo.mgold[size])
	-- log("\nsize = "..size)
	-- log("\nEquipInfo.strname[1] = "..EquipInfo.mstrName[size])
end

function SecRecommend_clearEquipInfo()
	if (#EquipInfo.mstrName > 0) then
		EquipInfo = {}
		EquipInfo.mstrName = {}			----装备名称
		EquipInfo.mstrPictureAdr = {}	----装备图片路径
		EquipInfo.mstrDesc = {}			----装备描述
		EquipInfo.mleftTime = {}			----剩余时间

		EquipInfo.mmoney = {}
		EquipInfo.mgold = {}
		EquipInfo.mhonour = {}
		EquipInfo.mcontri = {}
		EquipInfo.mvip = {}
		EquipInfo.mm_Flag = {}

		EquipInfo.mIsCanBuy = {}
		EquipInfo.mm_IsShow = {}
		EquipInfo.mId = {}
		EquipInfo.mItemId = {}
		EquipInfo.mTip = {}
		EquipInfo.mIsHaveHero = {}
	end
end

function GetItemCount_SecRecommend(ItemCount)
	AllCount = ItemCount
	return SecRecommend_RedrawUI()
end

function SecRecommend_RedrawUI()
	for i=1, 2 do
		if wndA_pic[i]==nil or wndB_pic[i]==nil or wndC_pic[i]==nil or wndA_name[i]==nil or wndB_name[i]==nil or wndC_name[i]==nil or wndA_moneyfont[i]==nil or wndB_moneyfont[i]==nil or wndC_moneyfont[i]==nil or wndA_goldfont[i]==nil or wndB_goldfont[i]==nil or wndC_goldfont[i]==nil or wndA_buy[i]==nil or wndB_buy[i]==nil or wndC_buy[i]==nil then
			return
		end
		
		wndA_pic[i].changeimage("..\\"..EquipInfo.mstrPictureAdr[i])
		wndB_pic[i].changeimage("..\\"..EquipInfo.mstrPictureAdr[i+2])
		wndC_pic[i].changeimage("..\\"..EquipInfo.mstrPictureAdr[i+4])
		XSetImageTip(wndA_pic[i].id, EquipInfo.mTip[i])
		XSetImageTip(wndB_pic[i].id, EquipInfo.mTip[i+2])
		XSetImageTip(wndC_pic[i].id, EquipInfo.mTip[i+4])
		wndA_name[i]:SetFontText(EquipInfo.mstrName[i], 0x83d1e7)
		wndB_name[i]:SetFontText(EquipInfo.mstrName[i+2], 0x83d1e7)
		wndC_name[i]:SetFontText(EquipInfo.mstrName[i+4], 0x83d1e7)
		wndA_moneyfont[i]:SetFontText(EquipInfo.mmoney[i], 0xe4e18b)
		wndB_moneyfont[i]:SetFontText(EquipInfo.mmoney[i+2], 0xe4e18b)
		wndC_moneyfont[i]:SetFontText(EquipInfo.mmoney[i+4], 0xe4e18b)
		wndA_goldfont[i]:SetFontText(EquipInfo.mgold[i], 0x83d1e7)
		wndB_goldfont[i]:SetFontText(EquipInfo.mgold[i+2], 0x83d1e7)
		wndC_goldfont[i]:SetFontText(EquipInfo.mgold[i+4], 0x83d1e7)
		if (EquipInfo.mIsCanBuy[i] == tostring(0)) then
			wndA_buy[i]:SetEnabled(0)
		else
			wndA_buy[i]:SetEnabled(1)
		end
		if (EquipInfo.mIsCanBuy[i+2] == tostring(0)) then
			wndB_buy[i]:SetEnabled(0)
		else
			wndB_buy[i]:SetEnabled(1)
		end
		if (EquipInfo.mIsCanBuy[i+4] == tostring(0)) then
			wndC_buy[i]:SetEnabled(0)
		else
			wndC_buy[i]:SetEnabled(1)
		end
	end
end

function SetButtonStateCanBuy_recommed(cindex, cIsHavehero, cHeroOrItem)
	if EquipInfo==nil then
		return
	end

	if cHeroOrItem==0 then
		EquipInfo.mIsHaveHero[cindex] = cIsHavehero
	elseif cHeroOrItem==1 then
		-- EquipInfo.mIsCanBuy[cindex] = "0"
	elseif cHeroOrItem==2 then
	
	end
end