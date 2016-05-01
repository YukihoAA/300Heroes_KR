include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")


local GameTime =nil
local TimeCount = 100
local Score_sideB = {}	--蓝方
local Score_sideR = {}	--红方

local blueS = nil
local redS = nil

local TeamatesCD = {}
local EnemyCD = {}
function InitScore_ui(wnd,bisopen)
	n_score_ui = CreateWindow(wnd.id, (1920-1470)/2, 0, 1470, 60)
	InitMain_Score(n_score_ui)
	n_score_ui:SetVisible(bisopen)
end

function InitMain_Score(wnd)
	
	local bg = wnd:AddImage(path_fight.."score.png",0,0,1470,60)
	blueS = wnd:AddImage(path_fight.."blueScore_fight.png",560,6,132,19)	
	redS = wnd:AddImage(path_fight.."redScore_fight.png",780,6,132,19)	
	blueS:SetVisible(0)
	redS:SetVisible(0)
	
	local score_pk = wnd:AddImage(path_fight.."score_pk.png",684,0,104,49)	--比分牌背景
	
	--点击可点穿
	DisableRButtonClick(bg.id)
	DisableRButtonClick(blueS.id)
	DisableRButtonClick(redS.id)
	DisableRButtonClick(score_pk.id)
	
	GameTime = wnd:AddFont("00:29:35",12,8,-685,-13,100,0,0xffffff)
	GameTime:SetFontSpace(1,0)
	
	for i=1,4 do
		local index = 0
		Score_sideB[i] = wnd:AddImage(path.."blue/"..index..".png",660-17*i,3,25,26)	--比分牌背景
		Score_sideR[5-i] = wnd:AddImage(path.."red/"..index..".png",790+17*i,3,25,26)	--比分牌背景
		
		Score_sideB[i]:SetVisible(0)
		Score_sideR[5-i]:SetVisible(0)
		
		DisableRButtonClick(Score_sideB[i].id)
		DisableRButtonClick(Score_sideR[5-i].id)
	end
	-----死亡复活进度显示
	for i=1,7 do
		TeamatesCD[i] = bg:AddImage(path_fight.."Me_equip.png",489,44,32,32)
		TeamatesCD[i]:AddImage(path_fight.."reliveCD.png",11,-10,10,10)
		TeamatesCD[i]:AddImage(path_fight.."goodbuff_fight.png",-2,-2,36,36)
		EnemyCD[i] = bg:AddImage(path_fight.."Me_equip.png",755,44,32,32)
		EnemyCD[i]:AddImage(path_fight.."reliveCD.png",11,-10,10,10)
		EnemyCD[i]:AddImage(path_fight.."badbuff_fight.png",-2,-2,36,36)
	end
	
	
	--SetScore(3023,42)
	--SetRedBlueScore(0.5,0.31)
end

----------设置比分
function SetScore(BS,RS)

	for i=1,4 do
		Score_sideB[i]:SetVisible(0)
		Score_sideR[i]:SetVisible(0)
	end
	
	----蓝方
	local M = BS
	local B = 0
	if M < 10 then
		Score_sideB[1]:SetVisible(1)
	elseif M < 100 then
		Score_sideB[1]:SetVisible(1)
		Score_sideB[2]:SetVisible(1)
	elseif M < 1000 then
		Score_sideB[1]:SetVisible(1)
		Score_sideB[2]:SetVisible(1)
		Score_sideB[3]:SetVisible(1)
	elseif M < 10000 then
		Score_sideB[1]:SetVisible(1)
		Score_sideB[2]:SetVisible(1)
		Score_sideB[3]:SetVisible(1)
		Score_sideB[4]:SetVisible(1)
	end
	for i=1,4 do
		B = (M%10)
		Score_sideB[i].changeimage(path.."blue/"..B..".png")
		M = math.floor(M/10)
	end
	
	
	----红方
	local N = RS
	local R = 0
	if N < 10 then
		Score_sideR[4].changeimage(path.."red/"..N..".png")
		Score_sideR[4]:SetVisible(1)
	elseif RS < 100 then
		for i=1,2 do
			R = N%10
			Score_sideR[i+2].changeimage(path.."red/"..R..".png")
			Score_sideR[i+2]:SetVisible(1)
			N = math.floor(N/10)
		end
	elseif RS < 1000 then
		for i=1,3 do
			R = N%10
			Score_sideR[i+1].changeimage(path.."red/"..R..".png")
			Score_sideR[i+1]:SetVisible(1)
			N = math.floor(N/10)
		end
	elseif RS < 10000 then
		for i=1,4 do
			R = N%10
			Score_sideR[i].changeimage(path.."red/"..R..".png")
			Score_sideR[i]:SetVisible(1)
			N = math.floor(N/10)
		end
	end

end
function SetRedBlueScore(BluePer,RedPer)
	BluePer = string.format("%.2f",BluePer)
	RedPer = string.format("%.2f",RedPer)
	--log("\nSetRedBlueScore   "..BluePer.."   "..RedPer)
	blueS:SetAddImageRect(blueS.id,132-BluePer*132,0,BluePer*132,19,560+(1-BluePer)*132,6,BluePer*132,19)
	redS:SetAddImageRect(redS.id,0,0,RedPer*132,19,780,6,RedPer*132,19)
	blueS:SetVisible(1)
	redS:SetVisible(1)
end
function SetRedBlueScoreVisible(flag)
	blueS:SetVisible(flag)
	redS:SetVisible(flag)
end
-----------------通信
function SetGameTime(TimeCount)
	GameTime:SetFontText(TimeCount,0xffffff)
end

----------------设置复活
function SetReliveTime(strPictureName,side,index,Time)
	if side==1 then
		TeamatesCD[index]:SetVisible(1)
		TeamatesCD[index].changeimage("..\\"..strPictureName)
		TeamatesCD[index]:MoveTo(489,44,679,44,Time)
	else
		EnemyCD[index]:SetVisible(1)
		EnemyCD[index].changeimage("..\\"..strPictureName)
		EnemyCD[index]:MoveTo(945,44,755,44,Time)
	end
end
function SetReliveTimeHide(side,index)
	if side==1 then
		TeamatesCD[index]:SetVisible(0)
		TeamatesCD[index]:SetPosition(489,44)
	else
		EnemyCD[index]:SetVisible(0)
		EnemyCD[index]:SetPosition(945,44)
	end
end



function SetScoreIsVisible(flag) 
	if n_score_ui ~= nil then
		if flag == 1 and n_score_ui:IsVisible() == false then
			n_score_ui:CreateResource()
			n_score_ui:SetVisible(1)
			for i=1,7 do
				TeamatesCD[i]:SetVisible(0)
				EnemyCD[i]:SetVisible(0)
			end
		elseif flag == 0 and n_score_ui:IsVisible() == true then
			n_score_ui:DeleteResource()
			n_score_ui:SetVisible(0)
		end
	end
end
