include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")


local FarShopBK = nil
local shop_icon = {}

------远程商店装备ID，Enabled
local shopItem = {}
shopItem.Id = {}
shopItem.Enabled = {}

function InitFarshop_ui(wnd,bisopen)
	n_farshop_ui = CreateWindow(wnd.id, 1920-273, 85, 273, 49)
	InitMain_Farshop(n_farshop_ui)
	n_farshop_ui:SetVisible(bisopen)
end

function InitMain_Farshop(wnd)

	FarShopBK = wnd:AddImage(path_fight.."farshop.png",0,0,266,56)
	
	--点击可点穿
	DisableRButtonClick(FarShopBK.id)
	
	for i=1,6 do
		shop_icon[i] = wnd:AddImage(path_fight.."Me_equip.png",44*i-76,7,40,40)
		shop_icon[i]:AddImage(path_fight.."farshop_side.png",-1,-1,42,42)
		shop_icon[i]:SetVisible(0)
		shop_icon[i]:SetTouchEnabled(1)
		DisableRButtonClick(shop_icon[i].id)
		shop_icon[i].script[XE_LBDBCLICK] = function()
			XClickPlaySound(5)
			XSetShopBuyIndex_FarShop()
			XClickFarShopBuy(shopItem.Id[i],shopItem.Enabled[i])
		end
	end
	FarShopBK:AddFontEx("远程",11,0,232,8,100,15,0xffffff)
	FarShopBK:AddFontEx("商店",11,0,226,22,100,15,0xffffff)
end

-----接收C++传来的装备
function FarShop_ReciveEquip(pictureName,index,Id,Enabled,tip)
	
	shopItem.Id[index+1] = Id
	shopItem.Enabled[index+1] = Enabled
	shop_icon[index+1]:SetImageTip(tip)
	pictureName = "..\\"..pictureName
	if pictureName ~= "..\\" then
		shop_icon[index+1].changeimage(pictureName)
		shop_icon[index+1]:SetVisible(1)
	end
end
function FarShop_ClearEquip()
	for i = 1,6 do
		shop_icon[i]:SetVisible(0)	
	end
end
-----------设置远程商店背景显示
function SetFarshopBKIsVisible(flag) 
	if FarShopBK ~= nil then
		if flag == 1 and FarShopBK:IsVisible() == false then
			FarShopBK:SetVisible(1)
		elseif flag == 0 and FarShopBK:IsVisible() == true then
			FarShopBK:SetVisible(0)
		end
	end

end

-- 设置显示
function SetFarshopIsVisible(flag) 
	if n_farshop_ui ~= nil then
		if flag == 1 and n_farshop_ui:IsVisible() == false then
			n_farshop_ui:CreateResource()
			n_farshop_ui:SetVisible(1)
		elseif flag == 0 and n_farshop_ui:IsVisible() == true then
			n_farshop_ui:DeleteResource()
			n_farshop_ui:SetVisible(0)
		end
	end
end

function GetFarshopIsVisible()  
    if( n_farshop_ui ~= nil and n_farshop_ui:IsVisible()) then
		return 1
    else
		return 0
    end
end