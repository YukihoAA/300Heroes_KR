include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

local IMG_SummonerSkillIcon = {}		-- 召唤师技能图片
local BTN_JiNengKuang = {}				-- 技能框按钮
local IMG_JiNengKuangXuanZhong = {}		-- 技能框选中状态
local IMG_JiNengKuangZheZhao = {}		-- 技能框遮罩
local Row = 1							-- 行
local Col = 1							-- 列
local Count = nil						-- 个数
local iBool = false						-- 是否执行点击消息
local SummonerSkillInfo = {}			-- 召唤师技能
SummonerSkillInfo.LearnLevel = {}		-- 召唤师技能等级
SummonerSkillInfo.Info = {}				-- 召唤师技能详细信息
SummonerSkillInfo.IconPath = {}			-- 召唤师技能图标路径
local IMG_ExampleIcon = nil				-- 选中后的实例图片
local IMG_ExampleKuang = nil			-- 选中后的实例框
local FONT_ExampleSkillName = nil		-- 选中后的实例技能名
local FONT_ExampleLearnLevel = nil		-- 学习等级
local FONT_ExampleInfo = nil			-- 技能具体描述

function InitGame_HeroSkillUI(wnd, bisopen)
	g_game_heroSkill_ui = CreateWindow(wnd.id, 0, 0, 1280, 800)
	InitMainGame_HeroSkill(g_game_heroSkill_ui)
	g_game_heroSkill_ui:SetVisible(bisopen)
end
function InitMainGame_HeroSkill(wnd)
	IMG_ExampleKuang = wnd:AddImage(path_info.."skill1_info.png", 666, 220, 90, 90)
	IMG_ExampleIcon = IMG_ExampleKuang:AddImage(path_info.."skill2_info.png", 13, 13, 64,64)
	FONT_ExampleSkillName = IMG_ExampleKuang:AddFont("技能名称", 18, 0, 96, 15, 150, 20, 0xffffffff)
	FONT_ExampleLearnLevel = IMG_ExampleKuang:AddFont("学习等级 8", 15, 0, 96, 45, 150, 20, 0xffffffff)
	FONT_ExampleInfo = IMG_ExampleKuang:AddFont("啊啊啊啊啊啊啊啊啊啊", 15, 0, 3, 90, 333, 300, 0xffffffff)
end

function SetGameHeroSkillIsVisible(flag) 
	if g_game_heroSkill_ui ~= nil then
		if flag == 1 and g_game_heroSkill_ui:IsVisible() == false then
			XGetSkillInfo(1)
			g_game_heroSkill_ui:SetVisible(1)
			SetAllSpecialVisible()
		elseif flag == 0 and g_game_heroSkill_ui:IsVisible() == true then
			g_game_heroSkill_ui:SetVisible(0)
		end
	end
end

function GetGameHeroSkillIsVisible()
    if(g_game_heroSkill_ui:IsVisible()) then
       -- XGameHeroSkinIsOpen(1)
    else
       -- XGameHeroSkinIsOpen(0)
    end
end

function GetSummonerSkillInfo( SummonerSkillName, LearnLevel, Info, Index, IconPath)
	SummonerSkillInfo[Index + 1] = SummonerSkillName
	SummonerSkillInfo.LearnLevel[Index + 1] = LearnLevel
	SummonerSkillInfo.Info[Index + 1] = Info
	SummonerSkillInfo.IconPath[Index + 1] = IconPath
	Count = Index + 1
end

function CreatJiNengKuangAnNiu()
	for i = 1, Count do
		if (Col > 5) then
			Col = 1
		end
		if (i > 5) then
			Row = 2
			if (i > 10) then
				Row = 3
			end
		end
	
		if (BTN_JiNengKuang[i] == nil) then
			BTN_JiNengKuang[i] = g_game_heroSkill_ui:AddButton(path_info.."skill1_info.png", path_info.."skill2_info.png", path_info.."skill1_info.png", 82 * Col, 100 + 120 * Row, 90, 90)

			IMG_SummonerSkillIcon[i] = BTN_JiNengKuang[i]:AddImage(".."..SummonerSkillInfo.IconPath[i], 13, 13, 64, 64)
			
			IMG_JiNengKuangZheZhao[i] = BTN_JiNengKuang[i]:AddImage(path_info.."skill0_info.png", 0, 0, 90, 90)
			IMG_JiNengKuangZheZhao[i]:SetVisible(0)

			IMG_JiNengKuangXuanZhong[i] = BTN_JiNengKuang[i]:AddImage(path_info.."skill3_info.png", 0, 0, 90, 90)
			IMG_JiNengKuangXuanZhong[i]:SetVisible(0)
		
			BTN_JiNengKuang[i]:AddFont(SummonerSkillInfo[i], 15, 8, 6, -86, 100, 15, 0xffB9AEE6)
		end
		
		IMG_SummonerSkillIcon[i].script[XE_ONHOVER] = function()
			BTN_JiNengKuang[i]:SetButtonFrame(1)
		end
		IMG_SummonerSkillIcon[i].script[XE_ONUNHOVER] = function()
			BTN_JiNengKuang[i]:SetButtonFrame(0)
		end
		IMG_SummonerSkillIcon[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			SetAllSpecialVisible()
			IMG_JiNengKuangXuanZhong[i]:SetVisible(1)
			-- 创建实例
			IMG_ExampleIcon.changeimage(".."..SummonerSkillInfo.IconPath[i])
			FONT_ExampleSkillName:SetFontText(SummonerSkillInfo[i], 0xffB6EADD)
			FONT_ExampleLearnLevel:SetFontText("学习等级 "..SummonerSkillInfo.LearnLevel[i], 0xff6E7FB3)
			FONT_ExampleInfo:SetFontText(SummonerSkillInfo.Info[i], 0xffB9AEE6)
			--log("\nSummonerSkillInfo.Info[i]="..SummonerSkillInfo.Info[i])
		end
		
		IMG_JiNengKuangZheZhao[i].script[XE_ONHOVER] = function()
			BTN_JiNengKuang[i]:SetButtonFrame(1)
		end
		IMG_JiNengKuangZheZhao[i].script[XE_ONUNHOVER] = function()
			BTN_JiNengKuang[i]:SetButtonFrame(0)
		end
		IMG_JiNengKuangZheZhao[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			SetAllSpecialVisible()
			IMG_JiNengKuangXuanZhong[i]:SetVisible(1)
			-- 创建实例
			IMG_ExampleIcon.changeimage(".."..SummonerSkillInfo.IconPath[i])
			FONT_ExampleSkillName:SetFontText(SummonerSkillInfo[i], 0xffB6EADD)
			FONT_ExampleLearnLevel:SetFontText("学习等级 "..SummonerSkillInfo.LearnLevel[i], 0xff6E7FB3)
			FONT_ExampleInfo:SetFontText(SummonerSkillInfo.Info[i], 0xffB9AEE6)
		end
		
		Col = Col + 1
	end
end

function SetTolerantIcon()
	IMG_ExampleIcon.changeimage(".."..SummonerSkillInfo.IconPath[1])
	FONT_ExampleSkillName:SetFontText(SummonerSkillInfo[1], 0xffB6EADD)
	FONT_ExampleLearnLevel:SetFontText("学习等级 "..SummonerSkillInfo.LearnLevel[1], 0xff6E7FB3)
	FONT_ExampleInfo:SetFontText(SummonerSkillInfo.Info[1], 0xffB9AEE6)
end

function SetAllSpecialVisible()
	local i = 1
	while true do
		if (IMG_JiNengKuangXuanZhong[i] ~= nil) then
			IMG_JiNengKuangXuanZhong[i]:SetVisible(0)
		end
		if (IMG_JiNengKuangXuanZhong[i] == nil) then
			return
		end
		i = i + 1
	end
end

function SetSummonerSkillZheZhaoShow(Index)
	if (IMG_JiNengKuangZheZhao[Index + 1] ~= nil) then
		IMG_JiNengKuangZheZhao[Index + 1]:SetVisible(1)
	end
end

function SetSummonerSkillZheZhaoVisible(Index)
	if (IMG_JiNengKuangZheZhao[Index + 1] ~= nil) then
		IMG_JiNengKuangZheZhao[Index + 1]:SetVisible(0)
	end
end