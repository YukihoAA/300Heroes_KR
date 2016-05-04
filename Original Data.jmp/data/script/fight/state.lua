include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")



local BBuffInfo = {}
BBuffInfo.pictureName = {}
BBuffInfo.buffId = {}

local GBuffInfo = {}
GBuffInfo.pictureName = {}
GBuffInfo.buffId = {}


------------BUFF状态
local stateB_info = {}
local stateB_good = nil
local stateB_lay = {}
local stateB_time = {}

local stateG_info = {}
local stateG_bad = nil
local stateG_lay = {}
local stateG_time = {}

local stateG_origin = {}
local stateB_origin = {}


function InitState_ui(wnd,bisopen)
	n_state_ui = CreateWindow(wnd.id, (1920-422)/2, 1080-130, 422, 80)
	InitMain_State(n_state_ui)
	n_state_ui:SetVisible(bisopen)
end

function InitMain_State(wnd)
	
	for i=1,20 do
		------减益BUFF
		stateB_info[i] = wnd:AddImage(path_fight.."Me_equip.png",36*i-36,-44,32,32)
		stateB_info[i]:SetVisible(0)
		------增益BUFF
		stateG_info[i] = wnd:AddImage(path_fight.."Me_equip.png",36*i-36,0,32,32)	
		stateG_info[i]:SetVisible(0)
	end
	stateB_good = wnd:AddImage(path_fight.."badBuff_state.png",-1,-45,725,34)
	stateG_bad = wnd:AddImage(path_fight.."goodBuff_state.png",-1,-1,725,34)
	stateB_good:SetVisible(0)
	stateG_bad:SetVisible(0)
	for i=1,20 do	
		stateB_lay[i] = wnd:AddFont(i,11,6,36*i-52,29,50,11,0xffffff)		
		stateB_lay[i]:SetFontBackground()
		stateB_lay[i]:SetVisible(0)
		stateG_lay[i] = wnd:AddFont(i,11,6,36*i-52,-15,50,11,0xffffff)	
		stateG_lay[i]:SetFontBackground()
		stateG_lay[i]:SetVisible(0)
	end
end
-----------------状态UI通信
function Clear_StateUI()
	BBuffInfo = {}
	BBuffInfo.pictureName = {}
	BBuffInfo.buffId = {}
	
	GBuffInfo = {}
	GBuffInfo.pictureName = {}
	GBuffInfo.buffId = {}
	
	for i,v in pairs(stateB_info) do
		stateB_info[i]:SetVisible(0)
		stateG_info[i]:SetVisible(0)
		stateB_lay[i]:SetVisible(0)
		stateG_lay[i]:SetVisible(0)
	end
	stateB_good:SetVisible(0)
	stateG_bad:SetVisible(0)
end
-----------------通信减益BUFF
function SendData_BStateUI(pictureName,buffId,layer,index,tip)
	BBuffInfo.pictureName[index+1] = "..\\"..pictureName
	BBuffInfo.buffId[index+1] = buffId
	
	stateB_info[index+1].changeimage(BBuffInfo.pictureName[index+1])
	stateB_info[index+1]:SetImageTip(tip)
	stateB_info[index+1]:SetVisible(1)
			
	stateB_lay[index+1]:SetFontText(layer,0xffffff)
	if layer>1 then
		stateB_lay[index+1]:SetVisible(1)
	else
		stateB_lay[index+1]:SetVisible(0)
	end
end
function BState_SetTime(index,Time,StartTime)
	stateB_info[index+1]:SetImageColdTimeFontSize(11)
	stateB_info[index+1]:SetImageColdTimeType(1)
	stateB_info[index+1]:SetImageColdTimeEx(Time,StartTime)	
end
function SendData_BStateOver()
	--stateB_good.changeimage(path_fight.."badBuff_state.png")
	if #BBuffInfo.buffId>0 then
		stateB_good:SetAddImageRect(stateB_good.id, 0, 0, #BBuffInfo.buffId*36, 34, -1, -45, #BBuffInfo.buffId*36, 34)
		stateB_good:SetVisible(1)
	else
		stateB_good:SetVisible(0)
	end
	
end
-----------------通信增益BUFF
function SendData_GStateUI(pictureName,buffId,layer,index,tip)
	GBuffInfo.pictureName[index+1] = "..\\"..pictureName
	GBuffInfo.buffId[index+1] = buffId

	stateG_info[index+1].changeimage(GBuffInfo.pictureName[index+1])
	stateG_info[index+1]:SetImageTip(tip)
	stateG_info[index+1]:SetVisible(1)
	
	stateG_lay[index+1]:SetFontText(layer,0xffffff)
	
	if layer>1 then
		stateG_lay[index+1]:SetVisible(1)
	else	
		stateG_lay[index+1]:SetVisible(0)
	end
end
function SendData_GStateOver()
	--stateG_bad.changeimage(path_fight.."goodBuff_state.png")
	if #GBuffInfo.buffId>0 then
		stateG_bad:SetAddImageRect(stateG_bad.id, 0, 0, #GBuffInfo.buffId*36, 34, -1, -1, #GBuffInfo.buffId*36, 34)
		stateG_bad:SetVisible(1)
	else
		stateG_bad:SetVisible(0)
	end
end
function GState_SetTime(index,Time,StartTime)
	stateG_info[index+1]:SetImageColdTimeFontSize(11)
	stateG_info[index+1]:SetImageColdTimeType(1)
	stateG_info[index+1]:SetImageColdTimeEx(Time,StartTime)	
end

--------------设置可见与否
function SetStateIsVisible(flag) 
	if n_state_ui ~= nil then
		if flag == 1 and n_state_ui:IsVisible() == false then
			n_state_ui:CreateResource()
			n_state_ui:SetVisible(1)
		elseif flag == 0 and n_state_ui:IsVisible() == true then
			n_state_ui:DeleteResource()
			n_state_ui:SetVisible(0)
		end
	end
end
