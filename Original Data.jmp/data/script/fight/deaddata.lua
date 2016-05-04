include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

--死亡回放界面

local skillNameColor = 0xff21568a
local physicalColor = 0xffa55438
local magicColor = 0xff894ba2
local whiteColor = 0xffffffff
local defaultPic = "..\\UI\\Icon\\equip\\weizhi.dds"

local BKWnd = nil

local killer = {}
killer.headPic = {}
killer.levelText = {}
killer.summonerSkillPic = {}
killer.equip = {}
killer.equip.pic = {}
killer.nameText = {}
killer.damage = {}

function InitDeadData_ui(wnd,bisopen)
	n_deadData_ui = CreateWindow(wnd.id, (1920-872)/2, (1080-416-30)/2 + 50, 872, 416+30)
	BKWnd = CreateWindow(n_deadData_ui.id,0,30,872,416)
	InitDataWnd(BKWnd)
	InitMain_DeadData(n_deadData_ui)
	n_deadData_ui:SetVisible(bisopen)
end

function InitMain_DeadData(wnd)	
	local btn = wnd:AddButton(path_fight_deadData.."deadback1_fight.png",path_fight_deadData.."deadback2_fight.png",path_fight_deadData.."deadback3_fight.png",(872-207)/2,0,207,50)
	btn.script[XE_LBUP] = function()
		XClickPlaySound(5)
		UpdateGroupShow()
	end
end

function InitDataWnd(wnd)
	wnd:AddImage(path_fight_deadData.."BK_dead.png",0,0,872,416)
	
	for i = 1, 3 do
		killer[i] = CreateWindow(wnd.id,0,0,290,416)
		
		if i == 1 then
			killer[i]:AddImage(path_fight_deadData.."killer.png",22,30,248,54)
		else
			killer[i]:AddImage(path_fight_deadData.."helper.png",22,30,248,54)
		end
		
		killer.headPic[i] = killer[i]:AddImage(defaultPic,29,93,36,36)
		killer[i]:AddImage(path_fight_deadData.."roleframe.png",26,90,46,42)
				
		killer[i]:AddImage(path_fight_deadData.."summonerskillframe.png",76,90,22,43)
		killer.summonerSkillPic[i] = {}
		killer.summonerSkillPic[i][1] = killer[i]:AddImage(defaultPic,77,91,20,20)
		killer.summonerSkillPic[i][2] = killer[i]:AddImage(defaultPic,77,113,20,20)

		killer[i]:AddImage(path_fight_deadData.."equipframe.png",102,98,151,26)
		killer.equip[i] = {}
		killer.equip[i].pic = {}
		for j = 1, 6 do
			killer.equip[i].pic[j] = killer[i]:AddImage(defaultPic,103+25*(j-1),99,24,24)
		end
		
		killer.damage[i] = {}
		killer.damage[i].wnd = {}
		killer.damage[i].skillPic = {}
		killer.damage[i].nameText = {}
		killer.damage[i].detailText = {}
		for k = 1, 5 do
			killer.damage[i].wnd[k] = CreateWindow(killer[i].id,24,165,250,36)
			killer.damage[i].wnd[k]:AddImage(path_fight_deadData.."skillframe.png",0,40*(k-1),36,36)
			killer.damage[i].skillPic[k] = killer.damage[i].wnd[k]:AddImage(defaultPic,2,2+40*(k-1),32,32)			
		end
	end
	
	
	for i = 1, 3 do
		killer.levelText[i] = killer[i]:AddFont("1",11,0,52,115,16,16,whiteColor)
		killer.nameText[i] = killer[i]:AddFont("角色名字七个字/英雄五个字",12,0,54,140,160,12,whiteColor)
		for k = 1, 5 do
			killer.damage[i].nameText[k] = killer.damage[i].wnd[k]:AddFont("王之宝库",12,0,40,1+40*(k-1),200,12,skillNameColor)
			killer.damage[i].detailText[k] = killer.damage[i].wnd[k]:AddFont("605    (40%  物理伤害)",12,0,40,21+40*(k-1),200,12,physicalColor)
		end		
	end
	SetKillerWndPos(killer[1], 0, 0);
	SetKillerWndPos(killer[2], 290, 0);
	SetKillerWndPos(killer[3], 580, 0);
end

function SetKillerWndPos(wnd,x,y)
	if wnd ~= nil then
		wnd:SetPosition(x,y)
	end
end

function UpdateGroupShow() 
	if BKWnd ~= nil then
		if BKWnd:IsVisible()==true then
			BKWnd:SetVisible(0)
		else
			BKWnd:SetVisible(1)
			XClickShowDeadData(1)
		end
	end
end

function SetHeadInfo(index,level,name)
	if index > 0 and index < 4 then
		killer[index]:SetVisible(1)
		
		if level==0 then
			killer.levelText[index]:SetFontText("?",whiteColor)
		else
			killer.levelText[index]:SetFontText(""..level,whiteColor)
		end
		
		if name ~= nil then
			killer.nameText[index]:SetFontText(name,whiteColor)
		else
			killer.nameText[index]:SetFontText(" ",whiteColor)
		end
	end
end

function SetHeadPic(index,headpic,tip)
	if index > 0 and index < 4 then
		killer[index]:SetVisible(1)
		-- log("tip:fjriofjqofijrqeof ")
		if headpic ~= nil then
			killer.headPic[index].changeimage(headpic)
			killer.headPic[index]:SetImageTip(tip)
		else
			killer.headPic[index].changeimage(defaultPic)
			killer.headPic[index]:SetImageTip(tip)
		end
	end
end

function SetSummonerSkillPic(index, i, pic,tip)
	if index > 0 and index < 4 and i > 0 and i < 3 then
		killer.summonerSkillPic[index][i]:SetVisible(1)
		
		if pic ~= nil then
			killer.summonerSkillPic[index][i].changeimage(pic)
			killer.summonerSkillPic[index][i]:SetImageTip(tip)
		else
			killer.summonerSkillPic[index][i].changeimage(defaultPic)
			killer.summonerSkillPic[index][i]:SetImageTip(tip)
		end
	end
end

function SetEquipPic(index, i, pic,tip)
	if index > 0 and index < 4 and i > 0 and i < 7 then
		killer.equip[index].pic[i]:SetVisible(1)
		
		if pic ~= nil then
			killer.equip[index].pic[i].changeimage(pic)
			killer.equip[index].pic[i]:SetImageTip(tip)
		else
			killer.equip[index].pic[i].changeimage(defaultPic)
			killer.equip[index].pic[i]:SetImageTip(tip)
		end
	end
end

function SetDamageInfo(index, i, colortype, name, pic, detail,tip)
	if index > 0 and index < 4 and i > 0 and i < 6 then
	
		local color = whiteColor
		if colortype == 0 then
			color = physicalColor
		elseif colortype == 1 then
			color = magicColor
		end
		
		if name ~= nil then
			killer.damage[index].nameText[i]:SetFontText(name,skillNameColor)
		else
			killer.damage[index].nameText[i]:SetFontText(" ",skillNameColor)
		end
		
		if pic ~= nil then
			killer.damage[index].skillPic[i].changeimage(pic)
			killer.damage[index].skillPic[i]:SetImageTip(tip)
		else
			killer.damage[index].skillPic[i].changeimage(defaultPic)
			killer.damage[index].skillPic[i]:SetImageTip(tip)
		end
		
		if detail ~= nil then
			killer.damage[index].detailText[i]:SetFontText(detail,color)
		else
			killer.damage[index].detailText[i]:SetFontText(" ",color)
		end
		
		killer.damage[index].wnd[i]:SetVisible(1)
	end
end

function Reset()
	for i = 1, 3 do
		for j = 1, 5 do
			killer.damage[i].wnd[j]:SetVisible(0)
		end
		
		killer.summonerSkillPic[i][1]:SetVisible(0)
		killer.summonerSkillPic[i][2]:SetVisible(0)

		for j = 1, 6 do
			killer.equip[i].pic[j]:SetVisible(0)
		end
		
		killer[i]:SetVisible(0)
	end
end

function ChangePos(total)
	if total > 0 then
		if total == 1 then
			SetKillerWndPos(killer[1], 312, 0)
		elseif total == 2 then
			SetKillerWndPos(killer[1], 125, 0)
			SetKillerWndPos(killer[2], 498, 0)
		else
			SetKillerWndPos(killer[1], 0, 0)
			SetKillerWndPos(killer[2], 290, 0)
			SetKillerWndPos(killer[3], 580, 0)
		end
	end
end


-- 设置显示
function SetDeadDataIsVisible(flag) 
	if n_deadData_ui ~= nil then
		if flag == 1 and n_deadData_ui:IsVisible() == false then
			n_deadData_ui:CreateResource()
			n_deadData_ui:SetVisible(1)
			BKWnd:SetVisible(0)
		elseif flag == 0 and n_deadData_ui:IsVisible() == true then
			n_deadData_ui:DeleteResource()
			n_deadData_ui:SetVisible(0)
		end
	end
end

function GetDeadDataIsVisible()  
    if n_deadData_ui ~= nil and n_deadData_ui:IsVisible() then
		return 1
    else
		return 0
    end
end