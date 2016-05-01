include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

-- 菜单栏
local btn_task_signin = nil					-- 签到奖励
local btn_task_limittime = nil				-- 限时活动
local btn_task_growup = nil					-- 成长福利
local btn_task_sevenday = nil				-- 七天目标
local btn_task_newserver = nil				-- 新服庆典

local btn_ListBK = nil


function InitTask_UI(wnd, bisopen)
	g_task_ui = CreateWindow(wnd.id, 0, 0, 1280, 800)
	InitMainTask(g_task_ui)
	g_task_ui:SetVisible(bisopen)
end

function InitMainTask(wnd)
	
	-- 底图背景
	wnd:AddImage(path_shop.."BK_shop.png",0,0,1280,800)
	-- 上边栏
	wnd:AddImage(path.."upBK_hall.png",0,0,1280,54)
	wnd:AddImage(path.."upLine2_hall.png",0,54,1280,35)
	wnd:AddImage(path.."linecut_hall.png",163+110,60,2,32)	
	btn_ListBK = wnd:AddImage(path_start.."ListBK_start.png",135,53,256,38)

	InitTask_signinUI(g_task_ui, 0)				-- 签到奖励
	InitTask_limittimeUI(g_task_ui, 0)			-- 限时活动
	InitTask_growupUI(g_task_ui, 0)				-- 成长福利
	InitTask_sevendayUI(g_task_ui, 0)			-- 七天目标
	InitTask_newserverUI(g_task_ui, 0)			-- 新服庆典
	
	-- 签到奖励
	btn_task_signin = wnd:AddCheckButton(path_task.."indexF1_sign.png",path_task.."indexF2_sign.png",path_task.."indexF3_sign.png",165,53,110,33)
	XWindowEnableAlphaTouch(btn_task_signin.id)
	btn_task_signin.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		XShopUiIsClick(1, 0)
		btn_ListBK:SetPosition(135,53)
		
		SetTask_signinIsVisible(1)
		SetTask_limittimeIsVisible(0)
		SetTask_growupIsVisible(0)
		SetTask_sevendayIsVisible(0)
		SetTask_newserverIsVisible(0)
		
		btn_task_limittime:SetCheckButtonClicked(0)
		btn_task_growup:SetCheckButtonClicked(0)
		btn_task_sevenday:SetCheckButtonClicked(0)
		btn_task_newserver:SetCheckButtonClicked(0)
	end
	-- 首冲大礼
	btn_task_limittime = wnd:AddCheckButton(path_task.."indexG1_sign.png",path_task.."indexG2_sign.png",path_task.."indexG3_sign.png",275,53,110,33)
	XWindowEnableAlphaTouch(btn_task_limittime.id)
	btn_task_limittime.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(245,53)
		
		SetTask_signinIsVisible(0)
		SetTask_limittimeIsVisible(1)
		SetTask_growupIsVisible(0)
		SetTask_sevendayIsVisible(0)
		SetTask_newserverIsVisible(0)
			
		btn_task_signin:SetCheckButtonClicked(0)
		btn_task_growup:SetCheckButtonClicked(0)
		btn_task_sevenday:SetCheckButtonClicked(0)
		btn_task_newserver:SetCheckButtonClicked(0)
	end
	-- 成长福利
	btn_task_growup = wnd:AddCheckButton(path_task.."indexC1_sign.png",path_task.."indexC2_sign.png",path_task.."indexC3_sign.png",385,53,110,33)
	XWindowEnableAlphaTouch(btn_task_growup.id)
	btn_task_growup.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(355,53)
		
		SetTask_signinIsVisible(0)
		SetTask_limittimeIsVisible(0)
		SetTask_growupIsVisible(1)
		SetTask_sevendayIsVisible(0)
		SetTask_newserverIsVisible(0)
			
		btn_task_signin:SetCheckButtonClicked(0)
		btn_task_limittime:SetCheckButtonClicked(0)
		btn_task_sevenday:SetCheckButtonClicked(0)
		btn_task_newserver:SetCheckButtonClicked(0)
	end
	-- 七天目标
	btn_task_sevenday = wnd:AddCheckButton(path_task.."indexD1_sign.png",path_task.."indexD2_sign.png",path_task.."indexD3_sign.png",495,53,110,33)
	XWindowEnableAlphaTouch(btn_task_sevenday.id)
	btn_task_sevenday.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(465,53)

		SetTask_signinIsVisible(0)
		SetTask_limittimeIsVisible(0)
		SetTask_growupIsVisible(0)
		SetTask_sevendayIsVisible(1)
		SetTask_newserverIsVisible(0)
			
		btn_task_signin:SetCheckButtonClicked(0)
		btn_task_limittime:SetCheckButtonClicked(0)
		btn_task_growup:SetCheckButtonClicked(0)
		btn_task_newserver:SetCheckButtonClicked(0)
	end
	-- 新服庆典
	btn_task_newserver = wnd:AddCheckButton(path_task.."indexE1_sign.png",path_task.."indexE2_sign.png",path_task.."indexE3_sign.png",605,53,110,33)
	XWindowEnableAlphaTouch(btn_task_newserver.id)
	btn_task_newserver.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(575,53)
		
		SetTask_signinIsVisible(0)
		SetTask_limittimeIsVisible(0)
		SetTask_growupIsVisible(0)
		SetTask_sevendayIsVisible(0)
		SetTask_newserverIsVisible(1)
			
		btn_task_signin:SetCheckButtonClicked(0)
		btn_task_limittime:SetCheckButtonClicked(0)
		btn_task_growup:SetCheckButtonClicked(0)
		btn_task_sevenday:SetCheckButtonClicked(0)
	end
	
	btn_task_growup:SetVisible(0)					-- 成长福利
	btn_task_sevenday:SetVisible(0)					-- 七天目标
	btn_task_newserver:SetVisible(0)				-- 新服庆典
end

function SetIndexWindowChecked(index)

	if index == 1 then
		XShopUiIsClick(1, 0)
		SetTask_signinIsVisible(1)
		SetTask_limittimeIsVisible(0)
		SetTask_growupIsVisible(0)
		SetTask_sevendayIsVisible(0)
		SetTask_newserverIsVisible(0)
		
		btn_ListBK:SetPosition(135,53)
		btn_ListBK:SetVisible(1)
		
		btn_task_signin:SetCheckButtonClicked(1)
		btn_task_limittime:SetCheckButtonClicked(0)
		btn_task_growup:SetCheckButtonClicked(0)
		btn_task_sevenday:SetCheckButtonClicked(0)
		btn_task_newserver:SetCheckButtonClicked(0)
	elseif index == 2 then
		XShopUiIsClick(1, 0)
		SetTask_signinIsVisible(0)
		SetTask_limittimeIsVisible(1)
		SetTask_growupIsVisible(0)
		SetTask_sevendayIsVisible(0)
		SetTask_newserverIsVisible(0)
	
		btn_ListBK:SetPosition(245,53)
		btn_ListBK:SetVisible(1)
		
		btn_task_signin:SetCheckButtonClicked(0)
		btn_task_limittime:SetCheckButtonClicked(1)
		btn_task_growup:SetCheckButtonClicked(0)
		btn_task_sevenday:SetCheckButtonClicked(0)
		btn_task_newserver:SetCheckButtonClicked(0)
	elseif index == 3 then
		XShopUiIsClick(1, 0)
		SetTask_signinIsVisible(0)
		SetTask_limittimeIsVisible(0)
		SetTask_growupIsVisible(1)
		SetTask_sevendayIsVisible(0)
		SetTask_newserverIsVisible(0)
	
		btn_ListBK:SetPosition(355,53)
		btn_ListBK:SetVisible(1)
		
		btn_task_signin:SetCheckButtonClicked(0)
		btn_task_limittime:SetCheckButtonClicked(0)
		btn_task_growup:SetCheckButtonClicked(1)
		btn_task_sevenday:SetCheckButtonClicked(0)
		btn_task_newserver:SetCheckButtonClicked(0)
	elseif index == 4 then
		XShopUiIsClick(1, 0)
		SetTask_signinIsVisible(0)
		SetTask_limittimeIsVisible(0)
		SetTask_growupIsVisible(0)
		SetTask_sevendayIsVisible(1)
		SetTask_newserverIsVisible(0)
	
		btn_ListBK:SetPosition(465,53)
		btn_ListBK:SetVisible(1)
		
		btn_task_signin:SetCheckButtonClicked(0)
		btn_task_limittime:SetCheckButtonClicked(0)
		btn_task_growup:SetCheckButtonClicked(0)
		btn_task_sevenday:SetCheckButtonClicked(1)
		btn_task_newserver:SetCheckButtonClicked(0)
	elseif index == 5 then
		XShopUiIsClick(1, 0)
		SetTask_signinIsVisible(0)
		SetTask_limittimeIsVisible(0)
		SetTask_growupIsVisible(0)
		SetTask_sevendayIsVisible(0)
		SetTask_newserverIsVisible(1)
	
		btn_ListBK:SetPosition(575,53)
		btn_ListBK:SetVisible(1)
		
		btn_task_signin:SetCheckButtonClicked(0)
		btn_task_limittime:SetCheckButtonClicked(0)
		btn_task_growup:SetCheckButtonClicked(0)
		btn_task_sevenday:SetCheckButtonClicked(0)
		btn_task_newserver:SetCheckButtonClicked(1)
	else
		SetTask_signinIsVisible(0)
		SetTask_limittimeIsVisible(0)
		SetTask_growupIsVisible(0)
		SetTask_sevendayIsVisible(0)
		SetTask_newserverIsVisible(0)
	end
end

function SetTaskIsVisible(flag,index) 
	if g_task_ui ~= nil then
		SetIndexWindowChecked(index)
		if flag == 1 and g_task_ui:IsVisible() == false then
			g_task_ui:SetVisible(1)
			SetFourpartUIVisiable(1)		
		elseif flag == 0 and g_task_ui:IsVisible() == true then
			g_task_ui:SetVisible(0)
		end
	end
end

function GetTaskIsVisible()  
    if g_task_ui~=nil and g_task_ui:IsVisible() ==true then
        return 1
    else
        return 0
    end
end