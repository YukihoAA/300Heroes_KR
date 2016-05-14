include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

------菜单栏
local btn_shop_recommend = nil
local btn_shop_hero = nil
local btn_shop_battleEquip = nil
local btn_shop_stoneStr = nil
local btn_shop_expendable = nil
local btn_shop_honour = nil
local btn_shop_vip = nil

local btn_ListBK = nil

local ppx = -50
local ppy = -50

function InitShop_HeadUI(wnd, bisopen)
	n_shop_head_ui = CreateWindow(wnd.id, 50, 50, 800, 50)
	InitMainShop_Head(n_shop_head_ui)
	n_shop_head_ui:SetVisible(bisopen)
end
function InitMainShop_Head(wnd)
	btn_ListBK = wnd:AddImage(path_start.."ListBK_start.png",0,0,256,38)
	
	--推荐
	btn_shop_recommend = wnd:AddCheckButton(path_shop.."indexA1_shop.png",path_shop.."indexA2_shop.png",path_shop.."indexA3_shop.png",115,3,110,33)
	XWindowEnableAlphaTouch(btn_shop_recommend.id)
	btn_shop_recommend.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(85,3)
		
		SetShop_RecommendIsVisible(1)
		SetShop_HeroIsVisible(0)
		SetShop_BattleEquipIsVisible(0)
		SetShop_StoneStrIsVisible(0)
		SetShop_ExpendableIsVisible(0)
		SetShop_HonourIsVisible(0)
		SetShop_VipIsVisible(0)
		
		btn_shop_hero:SetCheckButtonClicked(0)
		btn_shop_battleEquip:SetCheckButtonClicked(0)
		btn_shop_stoneStr:SetCheckButtonClicked(0)
		btn_shop_expendable:SetCheckButtonClicked(0)
		btn_shop_honour:SetCheckButtonClicked(0)
		btn_shop_vip:SetCheckButtonClicked(0)
		
		SetNumIsVisible(0)
	end
	--英雄
	btn_shop_hero = wnd:AddCheckButton(path_shop.."indexB1_shop.png",path_shop.."indexB2_shop.png",path_shop.."indexB3_shop.png",225,3,110,33)
	XWindowEnableAlphaTouch(btn_shop_hero.id)
	btn_shop_hero.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(195,3)
		
		SetShop_RecommendIsVisible(0)		
		SetShop_HeroIsVisible(1)			
		SetShop_BattleEquipIsVisible(0)		
		SetShop_StoneStrIsVisible(0)		
		SetShop_ExpendableIsVisible(0)		
		SetShop_HonourIsVisible(0)			
		SetShop_VipIsVisible(0)				
			
		btn_shop_recommend:SetCheckButtonClicked(0)
		btn_shop_battleEquip:SetCheckButtonClicked(0)
		btn_shop_stoneStr:SetCheckButtonClicked(0)
		btn_shop_expendable:SetCheckButtonClicked(0)
		btn_shop_honour:SetCheckButtonClicked(0)
		btn_shop_vip:SetCheckButtonClicked(0)
		
		SetNumIsVisible(1)
	end
	--战场装备
	btn_shop_battleEquip = wnd:AddCheckButton(path_shop.."indexC1_shop.png",path_shop.."indexC2_shop.png",path_shop.."indexC3_shop.png",335,3,110,33)
	XWindowEnableAlphaTouch(btn_shop_battleEquip.id)
	btn_shop_battleEquip.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(305,3)
		
		SetShop_RecommendIsVisible(0)
		SetShop_HeroIsVisible(0)
		SetShop_BattleEquipIsVisible(1)
		SetShop_StoneStrIsVisible(0)
		SetShop_ExpendableIsVisible(0)
		SetShop_HonourIsVisible(0)
		SetShop_VipIsVisible(0)
			
		btn_shop_recommend:SetCheckButtonClicked(0)
		btn_shop_hero:SetCheckButtonClicked(0)
		btn_shop_stoneStr:SetCheckButtonClicked(0)
		btn_shop_expendable:SetCheckButtonClicked(0)
		btn_shop_honour:SetCheckButtonClicked(0)
		btn_shop_vip:SetCheckButtonClicked(0)
		
		SetNumIsVisible(1)
	end
	--宝石和强化
	btn_shop_stoneStr = wnd:AddCheckButton(path_shop.."indexD1_shop.png",path_shop.."indexD2_shop.png",path_shop.."indexD3_shop.png",445,3,110,33)
	XWindowEnableAlphaTouch(btn_shop_stoneStr.id)
	btn_shop_stoneStr.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(415,3)

		SetShop_RecommendIsVisible(0)
		SetShop_HeroIsVisible(0)
		SetShop_BattleEquipIsVisible(0)
		SetShop_StoneStrIsVisible(1)
		SetShop_ExpendableIsVisible(0)
		SetShop_HonourIsVisible(0)
		SetShop_VipIsVisible(0)
		
		btn_shop_recommend:SetCheckButtonClicked(0)
		btn_shop_hero:SetCheckButtonClicked(0)
		btn_shop_battleEquip:SetCheckButtonClicked(0)
		btn_shop_expendable:SetCheckButtonClicked(0)
		btn_shop_honour:SetCheckButtonClicked(0)
		btn_shop_vip:SetCheckButtonClicked(0)
		
		SetNumIsVisible(1)
	end
	--消耗品
	btn_shop_expendable = wnd:AddCheckButton(path_shop.."indexE1_shop.png",path_shop.."indexE2_shop.png",path_shop.."indexE3_shop.png",555,3,110,33)
	XWindowEnableAlphaTouch(btn_shop_expendable.id)
	btn_shop_expendable.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(525,3)
		
		SetShop_RecommendIsVisible(0)
		SetShop_HeroIsVisible(0)
		SetShop_BattleEquipIsVisible(0)
		SetShop_StoneStrIsVisible(0)
		SetShop_ExpendableIsVisible(1)
		SetShop_HonourIsVisible(0)
		SetShop_VipIsVisible(0)
			
		btn_shop_recommend:SetCheckButtonClicked(0)
		btn_shop_hero:SetCheckButtonClicked(0)
		btn_shop_battleEquip:SetCheckButtonClicked(0)
		btn_shop_stoneStr:SetCheckButtonClicked(0)
		btn_shop_honour:SetCheckButtonClicked(0)
		btn_shop_vip:SetCheckButtonClicked(0)
		
		SetNumIsVisible(1)
	end
	--荣誉和功勋
	btn_shop_honour = wnd:AddCheckButton(path_shop.."indexF1_shop.png",path_shop.."indexF2_shop.png",path_shop.."indexF3_shop.png",665,3,110,33)
	XWindowEnableAlphaTouch(btn_shop_honour.id)
	btn_shop_honour.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(635,3)
	
		SetShop_RecommendIsVisible(0)
		SetShop_HeroIsVisible(0)
		SetShop_BattleEquipIsVisible(0)
		SetShop_StoneStrIsVisible(0)
		SetShop_ExpendableIsVisible(0)
		SetShop_HonourIsVisible(1)
		SetShop_VipIsVisible(0)
			
		btn_shop_recommend:SetCheckButtonClicked(0)
		btn_shop_hero:SetCheckButtonClicked(0)
		btn_shop_battleEquip:SetCheckButtonClicked(0)
		btn_shop_stoneStr:SetCheckButtonClicked(0)
		btn_shop_expendable:SetCheckButtonClicked(0)
		btn_shop_vip:SetCheckButtonClicked(0)
		
		SetNumIsVisible(1)
	end
	--VIP商城
	btn_shop_vip = wnd:AddCheckButton(path_shop.."indexG1_shop.png",path_shop.."indexG2_shop.png",path_shop.."indexG3_shop.png",775,3,110,33)
	XWindowEnableAlphaTouch(btn_shop_vip.id)
	btn_shop_vip.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(745,3)

		SetShop_RecommendIsVisible(0)
		SetShop_HeroIsVisible(0)
		SetShop_BattleEquipIsVisible(0)
		SetShop_StoneStrIsVisible(0)
		SetShop_ExpendableIsVisible(0)
		SetShop_HonourIsVisible(0)
		SetShop_VipIsVisible(1)
			
		btn_shop_recommend:SetCheckButtonClicked(0)
		btn_shop_hero:SetCheckButtonClicked(0)
		btn_shop_battleEquip:SetCheckButtonClicked(0)
		btn_shop_stoneStr:SetCheckButtonClicked(0)
		btn_shop_expendable:SetCheckButtonClicked(0)
		btn_shop_honour:SetCheckButtonClicked(0)
		
		SetNumIsVisible(1)
	end
end


function SetShop_HeadIsVisible(flag) 
	if n_shop_head_ui ~= nil then
		if flag == 0 and n_shop_head_ui:IsVisible()==true then
			n_shop_head_ui:SetVisible(0)
		elseif flag>0 and n_shop_head_ui:IsVisible()==false then
			n_shop_head_ui:SetVisible(1)					--log("\nwwwwww     -3")
			btn_shop_recommend:SetCheckButtonClicked(0)
			btn_shop_hero:SetCheckButtonClicked(0)
			btn_shop_battleEquip:SetCheckButtonClicked(0)
			btn_shop_stoneStr:SetCheckButtonClicked(0)
			btn_shop_expendable:SetCheckButtonClicked(0)
			btn_shop_honour:SetCheckButtonClicked(0)
			btn_shop_vip:SetCheckButtonClicked(0)
			if flag == 1 then
				btn_shop_recommend:SetCheckButtonClicked(1)
				btn_ListBK:SetPosition(85,3)
				btn_ListBK:SetVisible(1)
			elseif flag==2 then
				btn_shop_hero:SetCheckButtonClicked(1)
				btn_ListBK:SetPosition(195,3)
				btn_ListBK:SetVisible(1)
			elseif flag==3 then
				btn_shop_battleEquip:SetCheckButtonClicked(1)
				btn_ListBK:SetPosition(305,3)
				btn_ListBK:SetVisible(1)
			elseif flag==4 then
				btn_shop_stoneStr:SetCheckButtonClicked(1)
				btn_ListBK:SetPosition(415,3)
				btn_ListBK:SetVisible(1)
			elseif flag==5 then
				btn_shop_expendable:SetCheckButtonClicked(1)
				btn_ListBK:SetPosition(525,3)
				btn_ListBK:SetVisible(1)
			elseif flag==6 then
				btn_shop_honour:SetCheckButtonClicked(1)
				btn_ListBK:SetPosition(635,3)
				btn_ListBK:SetVisible(1)
			elseif flag==7 then
				btn_shop_vip:SetCheckButtonClicked(1)
				btn_ListBK:SetPosition(745,3)
				btn_ListBK:SetVisible(1)
			end
		end
	end
end

function Set_JumpToShopSecHero()
	btn_shop_hero:TriggerBehaviour(XE_LBDOWN)
	btn_shop_hero:CancelCapture()
end