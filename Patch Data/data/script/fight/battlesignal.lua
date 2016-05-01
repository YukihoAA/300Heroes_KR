include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

local TacticsMidButton = nil					-- ÖÐ
local TacticsUpButton = nil						-- ÉÏ
local TacticsRightButton = nil					-- ÓÒ
local TacticsDownButton = nil					-- ÏÂ
local TacticsLeftButton = nil					-- ×ó

function InitBattleSignal_ui(wnd,bisopen)
	if n_battlesignal_ui==nil then
		n_battlesignal_ui = CreateWindow(wnd.id, (1920-350)/2, (1080-345)/2, 96, 93)
		InitMain_BattleSignal(n_battlesignal_ui)
		n_battlesignal_ui:SetVisible(bisopen)
	end
end

function InitMain_BattleSignal(wnd)
	local offset = 18
	TacticsMidButton = wnd:AddImage( path_Tactics .. "closesel.png", 127, 127, 96, 93)
	TacticsUpButton = wnd:AddImage( path_Tactics .. "weixiansel.png", 115, offset, 119, 127)
	TacticsRightButton = wnd:AddImage( path_Tactics .. "comingsel.png", 223-offset, 113, 127, 119)
	TacticsDownButton = wnd:AddImage( path_Tactics .. "helpsel.png", 115, 220-offset, 119, 126)
	TacticsLeftButton = wnd:AddImage( path_Tactics .. "wenhaosel.png", offset, 113, 127, 119)
end

function SetBattleSignalIsVisible(flag) 
	if n_battlesignal_ui ~= nil then
		if flag == 1 and n_battlesignal_ui:IsVisible() == false then
			n_battlesignal_ui:CreateResource()
			n_battlesignal_ui:SetVisible(1)
		elseif flag == 0 and n_battlesignal_ui:IsVisible() == true then
			n_battlesignal_ui:DeleteResource()
			n_battlesignal_ui:SetVisible(0)
		end
	end
end

function GetBattleSignalIsVisible()  
	if n_battlesignal_ui~=nil and n_battlesignal_ui:IsVisible() then
		XGetBattleSignalUiVisible(1)
		return 1
	else
		XGetBattleSignalUiVisible(0)
		return 0
	end
end

function SetBattleSignalPostation( uHoldX, uHoldY)
	local l,t,r,b = n_battlesignal_ui:GetClientPosition()
	-- log("\nl = " .. l)
	-- log("\nt = " .. t)
	-- log("\nr = " .. r)
	-- log("\nb = " .. b)
	n_battlesignal_ui:SetPosition(uHoldX-r/2-127,uHoldY-b/2-127)
end

function SetImageState_BattleSingnal( iStatePos, iarf)
	-- log("\na = " .. iStatePos)
	-- log("\nb = " .. iarf)
	if iStatePos == -1 then
		TacticsMidButton:SetTransparent(iarf)
	elseif iStatePos == 1 then
		TacticsUpButton:SetTransparent(iarf)
	elseif iStatePos == 2 then
		TacticsRightButton:SetTransparent(iarf)
	elseif iStatePos == 3 then
		TacticsDownButton:SetTransparent(iarf)
	elseif iStatePos == 4 then
		TacticsLeftButton:SetTransparent(iarf)
	end
end