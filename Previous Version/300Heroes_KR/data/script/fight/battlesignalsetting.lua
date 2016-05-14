include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

-- Member
local TacticsBackgroundImage = nil					-- ±³¾°
local TacticsCheckButton = {}						-- ¹´Ñ¡¿ò
local TacticsSelImage = {}							-- Ð¡¹´¹´
local TacticsEdit = {}								-- ±à¼­¿ò
local TacticsSaveButton = nil						-- ±£´æ
local TacticsCloseButton = nil						-- ¹Ø±Õ

function InitBattleSignalSetting_ui(wnd,bisopen)
	n_battlesignalsetting_ui = CreateWindow(wnd.id, (1920-396)/2, (1080-478)/2, 396, 478)
	InitMain_BattleSignalSetting(n_battlesignalsetting_ui)
	n_battlesignalsetting_ui:SetVisible(bisopen)
end

function InitMain_BattleSignalSetting(wnd)
	TacticsBackgroundImage = wnd:AddImage( path_Tactics .. "TacticsSet.png", 0, 0, 396, 478)
	
	for i=1, 4 do
		TacticsCheckButton[i] = TacticsBackgroundImage:AddImage( path_hero .. "checkbox_hero.png", 352, 95+(91*(i-1)), 32, 32)
		TacticsSelImage[i] = TacticsCheckButton[i]:AddImage( path_hero .. "checkboxYes_hero.png", 4, -3, 32, 32)
		TacticsSelImage[i]:SetTouchEnabled(0)
		
		TacticsCheckButton[i].script[XE_LBDOWN] = function()
			TacticsSelImage[i]:SetVisible( TakeReverse( TacticsSelImage[i]:IsVisible()))
		end
		
		local TacticsEditTempWindow = CreateWindow( wnd.id, 101, 91+(91*(i-1)), 246, 38)
		TacticsEdit[i] = TacticsEditTempWindow:AddEdit( path_Tactics .. "EditBackground.png", "", "", "", 15, 5, 10, 246, 38, 0xffffff, 0x000000, 0, "")
		XEditSetMaxByteLength( TacticsEdit[i].id, 20)
		TacticsEdit[i]:SetDefaultFontText( "»ç¿ëÀÚ¸í·É", 0xffffffff)
		
		TacticsSaveButton = TacticsBackgroundImage:AddButton( path_hero .. "buySkin1_hero.png", path_hero .. "buySkin2_hero.png", path_hero .. "buySkin3_hero.png", 42, 423, 128, 32)
		TacticsCloseButton = TacticsBackgroundImage:AddButton( path_hero .. "buySkin1_hero.png", path_hero .. "buySkin2_hero.png", path_hero .. "buySkin3_hero.png", 239, 423, 128, 32)
		TacticsSaveButton:AddFont( "ÀúÀå", 15, 8, 0, 0, 110, 27, 0xffffff)
		TacticsCloseButton:AddFont( "´Ý±â", 15, 8, 0, 0, 110, 27, 0xffffff)
		
		TacticsSaveButton.script[XE_LBUP] = function()
			XClickPlaySound(5)
			local ischeck = {}
			
			for i=1, #TacticsSelImage do
				if TacticsSelImage[i]:IsVisible() then
					ischeck[i] = 1
				else
					ischeck[i] = 0
				end
			end
			
			XSaveTacticsUi( 
			TacticsEdit[1]:GetEdit(), 
			TacticsEdit[2]:GetEdit(), 
			TacticsEdit[3]:GetEdit(), 
			TacticsEdit[4]:GetEdit(), 
			ischeck[1], 
			ischeck[2], 
			ischeck[3], 
			ischeck[4]
			)
		end
		
		TacticsCloseButton.script[XE_LBUP] = function()
			XClickPlaySound(5)
			XCloseTacticsUi()
		end
	end
end

function SetBattleSignalSettingIsVisible(flag) 
	if n_battlesignalsetting_ui ~= nil then
		if flag == 1 and n_battlesignalsetting_ui:IsVisible() == false then
			n_battlesignalsetting_ui:CreateResource()
			n_battlesignalsetting_ui:SetVisible(1)
		elseif flag == 0 and n_battlesignalsetting_ui:IsVisible() == true then
			n_battlesignalsetting_ui:DeleteResource()
			n_battlesignalsetting_ui:SetVisible(0)
		end
	end
end

function GetBattleSignalSettingIsVisible()  
    if(n_battlesignalsetting_ui:IsVisible()) then
		return 1
    else
		return 0
    end
end

function TacticsSetUiInit( cIsCheck, cString, cIndex)
	-- log("\ncIsCheck = "..cIsCheck)
	TacticsSelImage[cIndex]:SetVisible( cIsCheck)
	TacticsEdit[cIndex]:SetEdit( cString)
end

function CheckIfSignalSettingEditIsFouse()
    if(TacticsEdit[1]:IsFocus() or TacticsEdit[2]:IsFocus() or TacticsEdit[3]:IsFocus() or TacticsEdit[4]:IsFocus()) then
	    return true
	end
	return false
end