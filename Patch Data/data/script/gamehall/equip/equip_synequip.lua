include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")



local EquipComposeCost = {}           ------物品合成的消耗品格子
local EquipComposeCostPic = {}        ------物品合成的消耗品图片


local SynthesizeCut = {}		    ------减少材料
local SynthesizeCount = {}		    ------材料计数
local SynthesizePlus = {}		    ------增加材料
local castcostcount = {0,0,0,0,0,0}      -----材料计数的数字


local SynthesizeListFont ={"显示全部","宝石","神器","专属","装备","英雄和皮肤"}
local BTN_Synthesize = {}           -----合成目标按钮
local Font_Synthesize = nil  	    -----合成目标内容
local Synthesize_BK = nil      		-----合成目标背景
local SynthesizeTarget = nil 		-----合成目标的下拉选单
local SynthesizeBag = {}			-----合成目标包裹格子
SynthesizeBag.kuang = {}            

local CurPage = 1					-----装备合成当前页
local AllPage = 1					-----装备合成总页数
local SynthesizePageInfo = nil		-----合成背包页码显示

local EquipName,EquipIcon = nil
local EquipChoosePic = nil


local EquipCompose = {}
EquipCompose.ustId = {} 
EquipCompose.picPath = {}
EquipCompose.picPath1 = {}
EquipCompose.picPath2 = {}
local Godpatch = nil
local GodChoosePic = nil
local GodpatchNum = 0

local MakeIt = nil --合成按钮

-------装备数值界面
function InitSyn_EquipUI(wnd, bisopen)
	g_syn_equip_ui = CreateWindow(wnd.id, 200,200,900,500)
	
    EquipName = g_syn_equip_ui:AddFont("装备名称",15, 8, 0, -6, 416, 20, 0x49d3f0)
	EquipName:SetVisible(0)
	EquipIcon = g_syn_equip_ui:AddImage(path_equip.."bag_equip.png",180,34,50,50)
	EquipChoosePic = EquipIcon:AddImageMultiple(path_equip.."bag_equip.png","","",0,0,50,50)
	EquipChoosePic:SetVisible(0)
	
	EquipChoosePic.script[XE_RBUP] =function()
	    Equip_SynEquip_Left_clean()
	end
	
	
	g_syn_equip_ui:AddImage(path_equip.."HeadShine_equip.png",171,25,68,68)
	
	
	
	Godpatch = g_syn_equip_ui:AddImage(path_equip.."bag_equip.png",320,200,50,50)
    GodChoosePic = Godpatch:AddImage(path_equip.."bag_equip.png",0,0,50,50)
	GodChoosePic:SetVisible(0)
	g_syn_equip_ui:AddImage(path_equip.."HeadShine_equip.png",311,191,68,68)
	GodpatchNum = Godpatch:AddFont("0",12, 8, -5, -63, 50, 13, 0xbcbcc4)
	GodpatchNum:SetVisible(0)
	
	
	g_syn_equip_ui:AddImage(path_equip.."synthesizecost_equip.png",179,106,64,16)
	g_syn_equip_ui:AddImage(path_equip.."LigheLine_equip.png", 0, 125, 512, 2)
	
	for i=1,6 do
		local posx = 72+80*((i-1)%3)
		local posy = 42+103*math.ceil(i/3)
		
		EquipComposeCost[i] = g_syn_equip_ui:AddImage(path_equip.."bag_equip.png",posx,posy,50,50)
		EquipComposeCostPic[i] = EquipComposeCost[i]:AddImage(path_shop.."iconside_shop.png",-2,-2,54,54)	
		EquipComposeCostPic[i]:SetVisible(0)
		EquipComposeCost[i]:AddImage(path_shop.."iconside_shop.png",-2,-2,54,54)
			
		SynthesizeCut[i] = g_syn_equip_ui:AddButton(path_hero.."plus1_hero.png",path_hero.."plus2_hero.png",path_hero.."plus3_hero.png",posx,63+posy,16,16)
		SynthesizeCut[i]:SetEnabled(0)
		----减少材料灰
		
		SynthesizeCount[i] = SynthesizeCut[i]:AddFont(castcostcount[i], 12, 8, -2, -2, 50, 13, 0xbcbcc4)
		SynthesizeCount[i]:SetVisible(0)
		
		SynthesizePlus[i] = SynthesizeCut[i]:AddButton(path_hero.."add1_hero.png",path_hero.."add2_hero.png",path_hero.."add3_hero.png",39,0,16,16)
		SynthesizePlus[i]:SetEnabled(0)
		----减少材料灰
		
		SynthesizeCut[i].script[XE_LBUP] = function()
		    XClickPlaySound(5)
		    XEquip_SynEquip_CutClick(i)
		end
		SynthesizePlus[i].script[XE_LBUP] = function()
		    XClickPlaySound(5)
		    XEquip_SynEquip_PlusClick(i)
		end
		
	end

	MakeIt = g_syn_equip_ui:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",168,350,83,35)
	MakeIt:SetEnabled(0)
	MakeIt:AddFont("合成", 15, 8, 0, 0, 83, 35, 0xffbcbcc4)
	MakeIt.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XEquip_SynEquip_ComposeClickUp()
	end
	
	g_syn_equip_ui:AddImage(path_equip.."LigheLine_equip.png", 0, 396, 512, 2)
	local AA = g_syn_equip_ui:AddFont("提示：\n◆X碎片会随着配方碎片的增减自动调整补足，但不能超过对\n 应碎片需求数量的一半，红色数字表示碎片数量不足.", 11, 0, 20, 424, 340, 200, 0x8295cf)
	AA:SetFontSpace(1,1)
	g_syn_equip_ui:AddFont("以下是可合成物品列表", 15, 0, 460, 22, 340, 15, 0x7787c3)
	
	for i=1,49 do
		local posx = 406+54*((i-1)%7+1)
		local posy = math.ceil(i/7)*54
	
		SynthesizeBag[i] = g_syn_equip_ui:AddImage(path_equip.."bag_equip.png",posx,posy,50,50)
		EquipCompose[i] = SynthesizeBag[i]:AddImageMultiple(path_equip.."bag_equip.png","","",0,0,50,50)
	    EquipCompose[i]:SetVisible(0)
		SynthesizeBag.kuang[i] = SynthesizeBag[i]:AddImage(path_equip.."kuang_equip.png",0,0,50,50)
		
		EquipCompose[i].script[XE_DRAG] = function()
		    if(EquipCompose.ustId[i] == nil or EquipCompose.ustId[i] == 0) then
			    return
			end
            game_equip_pullPicbyUstID(EquipCompose.picPath[i],EquipCompose.picPath1[i],EquipCompose.picPath2[i],EquipCompose.ustId[i],EquipCompose[i])
            SynthesizeBag.kuang[i].changeimage(path_equip.."kuang3_equip.png")			
		end
		EquipCompose[i].script[XE_ONHOVER] = function()
			SynthesizeBag.kuang[i].changeimage(path_equip.."kuang2_equip.png")
		end
		EquipCompose[i].script[XE_ONUNHOVER] = function()
			SynthesizeBag.kuang[i].changeimage(path_equip.."kuang_equip.png")
		end
		EquipCompose[i].script[XE_RBUP] = function()
		    if(EquipCompose.ustId[i]~= nil and EquipCompose.ustId[i]~= 0) then
		        XEquip_SynEquip_DragOn(EquipCompose.ustId[i])
			end	
		end
	end

	-------左右翻页键
	local btn_left = g_syn_equip_ui:AddButton(path_info.."L1_info.png",path_info.."L2_info.png",path_info.."L3_info.png",603,430,27,36)
	local pageBK = btn_left:AddImage(path_setup.."yemadiban_mail.png", 27, 9, 42, 18)	
	SynthesizePageInfo = pageBK:AddFont(CurPage.."/"..AllPage,15, 8, -3, 0, 32, 18, 0xffffffff)
	local btn_right = g_syn_equip_ui:AddButton(path_info.."R1_info.png",path_info.."R2_info.png",path_info.."R3_info.png",673,430,27,36)
	XWindowEnableAlphaTouch(btn_left.id)
	XWindowEnableAlphaTouch(btn_right.id)	
	btn_left:SetEnabled(0)
	btn_right:SetEnabled(0)	
	
	btn_left.script[XE_LBUP] = function()
		if (CurPage > 1) then
			CurPage = CurPage - 1
			SynthesizePageInfo:SetFontText(CurPage.."/"..AllPage, 0xffbcbcc4)
		end
	end
	
	btn_right.script[XE_LBUP] = function()
		if (CurPage < AllPage) then
			CurPage = CurPage + 1
			SynthesizePageInfo:SetFontText(CurPage.."/"..AllPage, 0xffbcbcc4)
		end
	end
	
	-- g_syn_equip_ui:AddFont("合成目标",15, 0, 645, 22, 250, 20, 0xbeb5ee)
	-- SynthesizeTarget = g_syn_equip_ui:AddTwoButton(path_hero.."herolist1_hero.png", path_hero.."herolist2_hero.png", path_hero.."herolist1_hero.png",720,17,128,32)

	-- Font_Synthesize = SynthesizeTarget:AddFont(SynthesizeListFont[1], 12, 0, 8, 6, 100, 15, 0xbeb5ee)
	-- Synthesize_BK = g_syn_equip_ui:AddImage(path_hero.."listBK2_hero.png", 720, 47, 128, 256)
	-- Synthesize_BK:SetVisible(0)
	
	-- for dis = 1,6 do
		-- BTN_Synthesize[dis] = g_syn_equip_ui:AddImage(path_hero.."listhover_hero.png",720,18+dis*29,128,32)
		-- Synthesize_BK:AddFont(SynthesizeListFont[dis],12,0,8,dis*29-23,128,32,0xbeb5ee)
		-- BTN_Synthesize[dis]:SetTransparent(0)	
		-- BTN_Synthesize[dis]:SetTouchEnabled(0)
		-- -----------鼠标滑过
		-- BTN_Synthesize[dis].script[XE_ONHOVER] = function()
			-- if Synthesize_BK:IsVisible() == true then
				-- BTN_Synthesize[dis]:SetTransparent(1)
			-- end
		-- end
		-- BTN_Synthesize[dis].script[XE_ONUNHOVER] = function()
			-- if Synthesize_BK:IsVisible() == true then
				-- BTN_Synthesize[dis]:SetTransparent(0)
			-- end
		-- end
		-- BTN_Synthesize[dis].script[XE_LBUP] = function()
			-- Font_Synthesize:SetFontText(SynthesizeListFont[dis],0xbeb5ee)
			-- SynthesizeTarget:SetButtonFrame(0)
			-- Synthesize_BK:SetVisible(0)
			-- for index,value in pairs(BTN_Synthesize) do
				-- BTN_Synthesize[index]:SetTransparent(0)
				-- BTN_Synthesize[index]:SetTouchEnabled(0)
			-- end
		-- end
		
	-- end
	-- SynthesizeTarget.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
		-- if Synthesize_BK:IsVisible() then
			-- Synthesize_BK:SetVisible(0)
			-- for index,value in pairs(BTN_Synthesize) do
				-- BTN_Synthesize[index]:SetTransparent(0)
				-- BTN_Synthesize[index]:SetTouchEnabled(0)
			-- end
		-- else
			-- Synthesize_BK:SetVisible(1)
			-- for index,value in pairs(BTN_Synthesize) do
				-- BTN_Synthesize[index]:SetTransparent(0)
				-- BTN_Synthesize[index]:SetTouchEnabled(1)
			-- end
		-- end
	-- end	
	
	g_syn_equip_ui:SetVisible(bisopen)
end

-----下拉菜单的弹回
function IsFocusOn_EquipSynthesize()
	local flagA = (Synthesize_BK:IsVisible() == true and SynthesizeTarget:IsFocus() == false and BTN_Synthesize[1]:IsFocus() == false and BTN_Synthesize[2]:IsFocus() == false
		and BTN_Synthesize[3]:IsFocus() == false and BTN_Synthesize[4]:IsFocus() == false and BTN_Synthesize[5]:IsFocus() == false and BTN_Synthesize[6]:IsFocus() == false)

	if(flagA == true) then
		SynthesizeTarget:SetButtonFrame(0)
		Synthesize_BK:SetVisible(0)
		for index,value in pairs(BTN_Synthesize) do
			BTN_Synthesize[index]:SetTransparent(0)
			BTN_Synthesize[index]:SetTouchEnabled(0)
		end
	end
end
--添加拖拽
function Equip_SynEquip_pullPicXLUP()
    if(g_syn_equip_ui:IsVisible() == false) then
	    return
	end
    local tempRanking = Equip_SynEquip_checkRect() --判断是否在包裹框
	for i = 1,49 do
	    if(EquipCompose[i]:IsVisible()) then
	        SynthesizeBag.kuang[i].changeimage(path_equip.."kuang_equip.png")
		end	
	end
	if(tempRanking == 1) then
		XEquip_SynEquip_DragOn(pullPicType.ustID)
	end
end
function Equip_SynEquip_checkRect()
    if(CheckEquipPullResult(EquipIcon)) then
		return 1
	else
	    return 0
	end
end


function SynEquip_GetComposeInfo(strPic,strPic1,strPic2,index,ustId,tip)

	 EquipCompose[index].changeimageMultiple("..\\"..strPic,"..\\"..strPic1,"..\\"..strPic2)--跟换图片
	 EquipCompose[index]:SetVisible(1)
	 EquipCompose.ustId[index] = ustId
	 EquipCompose.picPath[index] = "..\\"..strPic
	 EquipCompose.picPath1[index] = "..\\"..strPic1
	 EquipCompose.picPath2[index] = "..\\"..strPic2
	 EquipCompose[index]:SetImageTip(tip)
end

function SynEquip_GetComposeEquipInfo(strPic,strPic1,strPic2,name,ustId,tip)
	 EquipChoosePic.changeimageMultiple("..\\"..strPic,"..\\"..strPic1,"..\\"..strPic2)
	 EquipChoosePic:SetVisible(1)
     EquipName:SetFontText(name,0x49d3f0)
	 EquipName:SetVisible(1)
	 EquipChoosePic:SetImageTip(tip)
end

function SynEquip_GetComposeCostInfo(strPic,index,tip)

	EquipComposeCostPic[index].changeimage("..\\"..strPic)
	EquipComposeCostPic[index]:SetVisible(1)
	EquipComposeCostPic[index]:SetImageTip(tip)
end

function SynEquip_GetComposeCostNum(Num,index,color)
    SynthesizeCount[index]:SetFontText(Num,color)
	SynthesizeCount[index]:SetVisible(1)
end

function SynEquip_GetGodCostInfo(strPic,tip)
	GodChoosePic.changeimage("..\\"..strPic)
	GodChoosePic:SetVisible(1)
	GodChoosePic:SetImageTip(tip)
end

function SynEquip_GetGodCostNum(Num,color)
    GodpatchNum:SetFontText(Num,color)
	GodpatchNum:SetVisible(1)
end



--clean--
function Equip_SynEquip_Left_clean()
    EquipChoosePic.changeimage()
	EquipChoosePic:SetVisible(0)
	EquipChoosePic:SetImageTip(0)
	EquipName:SetFontText(" ",0xfefe00)
	EquipName:SetVisible(0)
	GodChoosePic.changeimage()
	GodChoosePic:SetVisible(0)
	GodChoosePic:SetImageTip(0)
	SynEquip_SetComposebuttonEnable(0)
	for i = 1,6 do
		SynthesizePlus[i]:SetEnabled(0)
		SynthesizeCut[i]:SetEnabled(0)
		EquipComposeCostPic[i].changeimage()
		EquipComposeCostPic[i]:SetVisible(0)
		EquipComposeCostPic[i]:SetImageTip(0)
		SynthesizeCount[i]:SetFontText("0")
		SynthesizeCount[i]:SetVisible(0)
		GodpatchNum:SetFontText("0")
		GodpatchNum:SetVisible(0)
	end
end



function SynEquip_ComposeClean()
    for i=1,49 do
		EquipCompose[i]:changeimage()
	    EquipCompose[i]:SetVisible(0)
		EquipCompose[i]:SetImageTip(0)
	end
end

function SynEquip_SetPlusbuttonEnable(i,ibool)--设置加号按键响应
    if(i>6 or i<1) then
	    return
	end
	if(ibool == 1) then
		SynthesizePlus[i]:SetEnabled(1)
	else
		SynthesizePlus[i]:SetEnabled(0)
    end	
end
function SynEquip_SetCutbuttonEnable(i,ibool)--设置减号按键响应
    if(i>6 or i<1) then
	    return
	end
	if(ibool == 1) then
		SynthesizeCut[i]:SetEnabled(1)
	else
		SynthesizeCut[i]:SetEnabled(0)
    end	
end
function SynEquip_SetComposebuttonEnable(ibool)--设置减号按键响应
	if(ibool == 1) then
		MakeIt:SetEnabled(1)
	else
		MakeIt:SetEnabled(0)
    end	
end










function SetSynEquipIsVisible(flag)

	if g_syn_equip_ui ~= nil then
		if flag == 1 and g_syn_equip_ui:IsVisible() == false then
		    XSynEquip_ClickUp()--通知c++开启界面物品合成
			g_syn_equip_ui:SetVisible(1)
		elseif flag == 0 and g_syn_equip_ui:IsVisible() == true then
		    Equip_SynEquip_Left_clean()
			g_syn_equip_ui:SetVisible(0)
		end
	end
end


