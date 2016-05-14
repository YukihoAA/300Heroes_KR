include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")


function InitShop_InsideUI(wnd, bisopen)
	n_shop_inside_ui = CreateWindow(wnd.id, (1920-1280)/2, (1080-750)/2, 1280, 750)
	InitMainShop_Inside(n_shop_inside_ui)
	n_shop_inside_ui:SetVisible(bisopen)
end
function InitMainShop_Inside(wnd)
	local A = wnd:AddImage(path_shop.."BK_shop.png",30,27,1280,800)
	A:SetAddImageRect(A.id, 0, 50, 1220, 700, 30 ,27, 1220, 700)
	XWindowEnableAlphaTouch(A.id)
	A:AddImage(path.."upLine2_hall.png",0,3,1220,35)
	
	
	A:AddImage(path_shop.."lineUp_shop.png",-4,-3,1228,5)
	A:AddImage(path_shop.."lineDown_shop.png",-4,698,1228,5)
	A:AddImage(path_shop.."lineLeft_shop.png",-5,1,5,698)
	A:AddImage(path_shop.."lineRight_shop.png",1220,1,5,698)
	
	for i = 1,6 do	
		wnd:AddImage(path.."linecut_hall.png",163+110*i,60-25,2,32)
	end	
	
	local btn_close = wnd:AddButton(path_shop.."close1_rec.png",path_shop.."close2_rec.png",path_shop.."close3_rec.png",1210,52-22,35,35)
	btn_close.script[XE_LBUP] = function()
		XClickPlaySound(5)
		SetShop_InsideIsVisible(0)
		XSetShopUiVisible(0)
	end
end


function SetShop_InsideIsVisible(flag) 
	if n_shop_inside_ui ~= nil then
		if flag == 1 and n_shop_inside_ui:IsVisible() == false then
		
			ShopCreateResource()
		
			n_shop_inside_ui:SetVisible(1)
			SetShop_HeadIsVisible(1)			
			
			SetShop_RecommendIsVisible(1)		--log("\nWWWWWWW    2")
			SetShop_HeroIsVisible(0)			--log("\nWWWWWWW    3")
			SetShop_BattleEquipIsVisible(0)		--log("\nWWWWWWW    4")
			SetShop_StoneStrIsVisible(0)		--log("\nWWWWWWW    5")
			SetShop_ExpendableIsVisible(0)		--log("\nWWWWWWW    6")
			SetShop_HonourIsVisible(0)			--log("\nWWWWWWW    7")
			SetShop_VipIsVisible(0)				--log("\nWWWWWWW    8")
			
			SetNumIsVisible(0)
		elseif flag == 0 and n_shop_inside_ui:IsVisible() == true then
		
			ShopDeleteResource()
		
			n_shop_inside_ui:SetVisible(0)
			SetShop_HeadIsVisible(0)			--log("\nWWWWWWW11    0")
			
			SetShop_RecommendIsVisible(0)		--log("\nWWWWWWW11    2")
			SetShop_HeroIsVisible(0)			--log("\nWWWWWWW11    3")
			SetShop_BattleEquipIsVisible(0)		--log("\nWWWWWWW11    4")
			SetShop_StoneStrIsVisible(0)		--log("\nWWWWWWW11    5")
			SetShop_ExpendableIsVisible(0)		--log("\nWWWWWWW11    6")
			SetShop_HonourIsVisible(0)			--log("\nWWWWWWW11    7")
			SetShop_VipIsVisible(0)				--log("\nWWWWWWW11    8")
			
			SetNumIsVisible(0)
		end
	end
end
function GetShop_InsideIsVisible()
	if n_shop_inside_ui~=nil and n_shop_inside_ui:IsVisible()==true then
       return 1
    else
       return 0
    end

end
