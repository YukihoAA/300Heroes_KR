include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

---²Ëµ¥À¸
local btn_sec_hero = nil
local btn_sec_heroskin = nil
local btn_sec_herophen = nil

local btn_ListBK = nil

local ppx = -60
local ppy = -100

function InitShop_HeroUI(wnd, bisopen)
	g_shop_hero_ui = CreateWindow(wnd.id, 60, 100, 420, 80)
	InitMainShop_Hero(g_shop_hero_ui)
	g_shop_hero_ui:SetVisible(bisopen)
end
function InitMainShop_Hero(wnd)
	
	btn_ListBK = wnd:AddImage(path_shop.."ListBK_rec.png",60+ppx,107+ppy,256,64)

	wnd:AddImage(path_shop.."upLine_rec.png",60+ppx,155+ppy,188,3)
	wnd:AddImage(path_shop.."upLine_rec.png",200+ppx,155+ppy,188,3)
	--wnd:AddImage(path_shop.."upLine_rec.png",340+ppx,107+ppy,256,64)
		
	InitShop_Sec_HeroUI(G_login_ui, 0)				--Ó¢ÐÛ
	InitShop_Sec_HeroSkinUI(G_login_ui, 0)			--Æ¤·ô
	InitShop_Sec_HeroPhenUI(G_login_ui, 0)			--×°°ç
	
	--Ó¢ÐÛ
	btn_sec_hero = wnd:AddCheckButton(path_shop.."indexA1_rec.png",path_shop.."indexA2_rec.png",path_shop.."indexA3_rec.png",90+ppx,122+ppy,100,34)
	XWindowEnableAlphaTouch(btn_sec_hero.id)
	btn_sec_hero.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(60+ppx,107+ppy)
		
		SetShop_Sec_HeroIsVisible(1)
		SetShop_Sec_HeroSkinIsVisible(0)
		SetShop_Sec_HeroPhenIsVisible(0)
		
		btn_sec_heroskin:SetCheckButtonClicked(0)
		btn_sec_herophen:SetCheckButtonClicked(0)
	end
	--Æ¤·ô
	btn_sec_heroskin = wnd:AddCheckButton(path_shop.."indexB1_rec.png",path_shop.."indexB2_rec.png",path_shop.."indexB3_rec.png",230+ppx,122+ppy,100,34)
	XWindowEnableAlphaTouch(btn_sec_heroskin.id)
	btn_sec_heroskin.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(200+ppx,107+ppy)
		
		SetShop_Sec_HeroIsVisible(0)
		SetShop_Sec_HeroSkinIsVisible(1)
		SetShop_Sec_HeroPhenIsVisible(0)
			
		btn_sec_hero:SetCheckButtonClicked(0)
		btn_sec_herophen:SetCheckButtonClicked(0)
	end
	--×°°ç
	btn_sec_herophen = wnd:AddCheckButton(path_shop.."indexC1_rec.png",path_shop.."indexC2_rec.png",path_shop.."indexC3_rec.png",370+ppx,122+ppy,100,34)
	XWindowEnableAlphaTouch(btn_sec_herophen.id)
	btn_sec_herophen.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(340+ppx,107+ppy)
		
		SetShop_Sec_HeroIsVisible(0)
		SetShop_Sec_HeroSkinIsVisible(0)
		SetShop_Sec_HeroPhenIsVisible(1)
			
		btn_sec_hero:SetCheckButtonClicked(0)
		btn_sec_heroskin:SetCheckButtonClicked(0)
	end
	btn_sec_herophen:SetVisible(0)
end

function SetShop_HeroIsVisible(flag) 
	if g_shop_hero_ui ~= nil then
		if flag == 1 and g_shop_hero_ui:IsVisible() == false then
			g_shop_hero_ui:SetVisible(1)
			SetShop_Sec_HeroIsVisible(1)		
			SetShop_Sec_HeroSkinIsVisible(0)	
			SetShop_Sec_HeroPhenIsVisible(0)	
			
			btn_sec_hero:SetCheckButtonClicked(1)
			btn_sec_heroskin:SetCheckButtonClicked(0)
			btn_sec_herophen:SetCheckButtonClicked(0)
			
			btn_ListBK:SetPosition(60+ppx,107+ppy)
			btn_ListBK:SetVisible(1)
			
		elseif flag == 0 and g_shop_hero_ui:IsVisible() == true then
			g_shop_hero_ui:SetVisible(0)
			
			SetShop_Sec_HeroIsVisible(0)
			SetShop_Sec_HeroSkinIsVisible(0)
			SetShop_Sec_HeroPhenIsVisible(0)
		end
	end
end

function GetShop_HeroIsVisible()  
    if(g_shop_hero_ui:IsVisible()) then
       -- XGameHeroSkinIsOpen(1)
    else
       -- XGameHeroSkinIsOpen(0)
    end
end