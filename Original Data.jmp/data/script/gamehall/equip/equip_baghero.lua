include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

-------装备总览
local font_heroname = nil
local font_heropic = nil
local font_heroid = 53
local font_HeroTempId = 0 --临时id用于控制减少操作
local hero_HIDE = nil
local equip_hero = {}
equip_hero.kuang = {}

local SKILL_pic = {}
local skill_posx = {429,489,545,601,657}

--包裹框A--只能用于存放装备
local packageBlock = {} --包裹框用于存放装备
packageBlock.pic = {} --包裹框的图片
packageBlock.picPath = {} --包裹框的图片路径
packageBlock.onlyid= {} --包裹框在装备库利的索引Id 0 为没有装备
packageBlock.bProfession = {} --是否是当前英雄专属标记
packageBlock.bProfession_bg = {} --非英雄专属装备遮罩

local BagNow = 1 --用来控制显示
local BagHerofirst = {}
BagHerofirst.onlyid ={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
BagHerofirst.picPath ={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
BagHerofirst.tip = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
BagHerofirst.itemAnimate = {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1}
BagHerofirst.bProfession = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

local BagOpenBtn = nil
local BagOpenBtnfont = nil

local ifjumpFromhero = 0


	


-------装备英雄界面
function InitBag_HeroUI(wnd, bisopen)
	g_bag_hero_ui = CreateWindow(wnd.id, 410,208,320,480)
	
	---------左二界面
	font_heroname = g_bag_hero_ui:AddFont("英雄名字七个字",15, 8, 0, 0, 146, 100, 0x49d3f0)
	font_heropic = g_bag_hero_ui:AddImage(path_start.."herohead_start.png",450-410,285-208,64,148)

	hero_HIDE = font_heropic:AddButton(path_start.."icon7_start.png",path_start.."icon1_start.png",path_start.."icon1_start.png",-10,-10,86,170)
	XWindowEnableAlphaTouch(hero_HIDE.id)
	hero_HIDE.script[XE_LBUP] = function()
		XClickPlaySound(5)
	
		if XGetMapId()==1 then
			Set_JumpToHeroAll()
		end
	end
	
	BagOpenBtn = g_bag_hero_ui:AddButton(path_setup.."btn1_mail.png",path_setup.."btn2_mail.png",path_setup.."btn3_mail.png", 160, 40, 100, 32)
	BagOpenBtn:AddFont("激活",12, 8, 0, 0, 100, 32, 0xffffff)
	BagOpenBtn:SetVisible(0)
	BagOpenBtnfont = BagOpenBtn:AddFont(" ",12, 8, 30, 20, 160, 12, 0x49d3f0)
	BagOpenBtn.script[XE_LBUP] = function()
	    if(BagNow == 2 or BagNow == 3) then
            Xbag_heroOpenClick(BagNow)
        end		
	end
	
	
	local BB = g_bag_hero_ui:AddFont("提示：鼠标右击装备，可穿上或拿下装备。",11, 0, 446-410, 532-208, 500, 20, 0x8295cf)
	BB:SetFontSpace(1,1)
	g_bag_hero_ui:AddImage(path_equip.."line_equip.png",420-410,558-208,512,2)
	g_bag_hero_ui:AddFont("英雄技能",15, 0, 424-410, 575-208, 200, 20, 0x49d3f0)
	
	for i=1,6 do
		local posx = ((i+1)%2)*80+550
		local posy = math.ceil(i/2)*84+200
		
		equip_hero[i] = g_bag_hero_ui:AddImage(path_equip.."bag_equip.png",posx-410,posy-208,50,50)
		equip_hero[i]:AddFont(i,18, 0, 14, 10, 200, 20, 0x8295cf)
		packageBlock.pic[i] = equip_hero[i]:AddImage(path_equip.."bag_equip.png",0,0,50,50)
		packageBlock.bProfession_bg[i] = packageBlock.pic[i]:AddImage(path_fight.."skill_nolearn.png",0,0,50,50)
		packageBlock.bProfession_bg[i]:SetTouchEnabled(0)
		packageBlock.bProfession_bg[i]:SetVisible(0)
		packageBlock.bProfession[i] = packageBlock.pic[i]:AddImage(path.."punish1_hall.png",5,5,40,40)
		packageBlock.bProfession[i]:SetTouchEnabled(0)
		packageBlock.pic[i]:SetVisible(0)
		packageBlock.bProfession[i]:SetVisible(0)
		equip_hero.kuang[i] = equip_hero[i]:AddImage(path_equip.."kuang_equip.png",0,0,50,50)
		equip_hero.kuang[i]:SetTouchEnabled(0)
		
		packageBlock.pic[i].script[XE_RBDOWN] = function()
			XClickPlaySound(5)
			local mapid = XGetMapId()
			if(g_BagStorage_ui:IsVisible() == false and mapid == 1) then --场外
		        if(packageBlock.onlyid[i] ~= 0 and packageBlock.onlyid[i] ~= nil) then
			        local oldranking = i
			        if(BagNow == 2) then
			            oldranking = oldranking+6
		            elseif(BagNow == 3) then
			            oldranking = oldranking+12
		            end	
                XEquip_BattleBag_NeedClean(oldranking)
			    end
			elseif(g_BagStorage_ui:IsVisible() == false and mapid ~= 1) then
			    XEquip_fightBag_NeedClean(i)
			end
		end
		packageBlock.pic[i].script[XE_DRAG] = function()
		    if(packageBlock.onlyid[i] ~= 0 and packageBlock.onlyid[i] ~= nil) then
				game_equip_pullPicbyUstIDandType(packageBlock.picPath[i],packageBlock.onlyid[i],3,packageBlock.pic[i])
			end
		end
	end
	
	-----英雄技能	
	for i =1,5 do
		SKILL_pic[i] = g_bag_hero_ui:AddImage(path_equip.."bag_equip.png",skill_posx[i]-410,606-208,50,50)
		SKILL_pic[i]:AddImage(path_shop.."iconside_shop.png",-2,-2,54,54)
	end
	
	g_bag_hero_ui:SetVisible(bisopen)
end


function SetBagHeroBagNow(index)
    if (index>=1 and index<=3) then
	    BagNow = index
	end
end 

function GetBagHeroBagNow()
    if (BagNow>=1 and BagNow<=3) then
	    return BagNow
	end
end
function SetifjumpFromhero(index) --用来判断是否从hero直接跳转过来
    ifjumpFromhero = index
end

function SetBagHeroIsVisible(flag) 
	if g_bag_hero_ui ~= nil then
		if flag == 1 and g_bag_hero_ui:IsVisible() == false then
		    g_bag_hero_ui:SetVisible(1)
		    if(ifjumpFromhero == 0 and font_heroid ~= 0 and g_bag_equip_ui:IsVisible() == true) then
			    XBagChangeSendMsg(1,font_heroid)
			else
 			    ifjumpFromhero = 0
			end	
			SetBagHerofirstClean()
			XBag_Hero_OpenClickUP()
		elseif flag == 0 and g_bag_hero_ui:IsVisible() == true then
		    XRestoreHeroEquip()--还原当前英雄套装
			g_bag_hero_ui:SetVisible(0)
			BagNow = 1
			font_HeroTempId = 0
		end
	end
end

function SetBagHerofirstClean()
    if(g_bag_equip_ui:IsVisible() == false and g_bag_expend_ui:IsVisible() == false) then
	    return
	end	
    for index = 1,18 do
	    BagHerofirst.onlyid[index] =0
        BagHerofirst.picPath[index] =0
		BagHerofirst.tip[index] = 0
		BagHerofirst.itemAnimate[index] = -1
		BagHerofirst.bProfession[index] = 0
	end
	for index = 1,6 do
        packageBlock.pic[index].changeimage() --包裹框的图片
        packageBlock.picPath[index] = 0 --包裹框的图片路径
        packageBlock.onlyid[index] = 0 --包裹框在装备库利的索引Id 0 为没有装备
		packageBlock.pic[index]:SetImageTip(0)
		packageBlock.bProfession_bg[index]:SetVisible(0)
		packageBlock.bProfession[index]:SetVisible(0)
		if(packageBlock.pic[index]:GetBoolImageAnimate() == 1) then
	        packageBlock.pic[index]:CleanImageAnimate()
		end	
	end
	BagOpenBtn:SetVisible(0)
	BagNow = 1
end

function SetBagHerobProfession_bg(index,ibool)
    packageBlock.bProfession_bg[index]:SetVisible(ibool)
	packageBlock.bProfession[index]:SetVisible(ibool)
end
function GetHeroInfo_ID()
    return font_HeroTempId
end

function SetBagHeroEquipClean()
    local mapid = XGetMapId()
    if(mapid == 1) then
	    return
	end	
	for index = 1,6 do
        packageBlock.pic[index].changeimage() --包裹框的图片
        packageBlock.picPath[index] = 0 --包裹框的图片路径
        packageBlock.onlyid[index] = 0 --包裹框在装备库利的索引Id 0 为没有装备
		packageBlock.pic[index]:SetVisible(0)
		packageBlock.pic[index]:SetImageTip(0)
		packageBlock.bProfession_bg[index]:SetVisible(0)
		packageBlock.bProfession[index]:SetVisible(0)
		if(packageBlock.pic[index]:GetBoolImageAnimate() == 1) then
	        packageBlock.pic[index]:CleanImageAnimate()
		end	
	end
end

function Equip_BattleBag_Setdata(onlyidid,strPic,ranking,tip,itemAnimate,bSameProfession)--用于场外
    if(onlyidid == 0 or onlyidid == nil or g_bag_hero_ui:IsVisible()==false or (BagHerofirst.onlyid[ranking] == onlyidid)) then
		return
	end	
	-- log("Equip_BattleBag_Setdata")
    BagHerofirst.onlyid[ranking] = onlyidid
    BagHerofirst.picPath[ranking] = "..\\"..strPic
	BagHerofirst.tip[ranking] = tip
	BagHerofirst.itemAnimate[ranking] = itemAnimate
	BagHerofirst.bProfession[ranking] = bSameProfession
end

function Equip_BattleBag_CallHerowhenBattleEquipChange()
    if(g_bag_hero_ui:IsVisible()==false or font_heroid == 0) then
	    return
	end	 
	XBagChangeSendMsg(BagNow,font_heroid)
end

function Equip_fightBag_Setdata(strPic,onlyidid,ranking,tip,itemAnimation,bProfession)--用于场内
    local mapid = XGetMapId()
    if(onlyidid == 0 or onlyidid == nil or mapid == 1 or g_bag_hero_ui == nil or g_bag_hero_ui:IsVisible() == false) then
		return
	end	
    packageBlock.onlyid[ranking] = onlyidid
	packageBlock.picPath[ranking] = "..\\"..strPic
	packageBlock.pic[ranking].changeimage(packageBlock.picPath[ranking]) --包裹框的图片
	packageBlock.pic[ranking]:SetVisible(1)
	packageBlock.pic[ranking]:SetImageTip(tip)
	if(packageBlock.pic[ranking]:GetBoolImageAnimate() == 1 and itemAnimation == -1) then
	    packageBlock.pic[ranking]:CleanImageAnimate()
	elseif(itemAnimation ~= -1) then
	    packageBlock.pic[ranking]:EnableImageAnimate(1,itemAnimation,15,5)
    end   
	if bProfession == 0 then
		packageBlock.bProfession_bg[ranking]:SetVisible(1)
		packageBlock.bProfession[ranking]:SetVisible(1)
	else
		packageBlock.bProfession_bg[ranking]:SetVisible(0)
		packageBlock.bProfession[ranking]:SetVisible(0)
	end		
	BagOpenBtn:SetVisible(0)
end

function checkEveryEquip()
   if(BagNow == 1) then
        for index = 1,6 do
		    if(packageBlock.onlyid[index] ~= BagHerofirst.onlyid[index]) then
			    return false
			end	
		end
		return true
   elseif(BagNow == 2) then
        for index = 7,12 do
		    if(packageBlock.onlyid[index-6] ~= BagHerofirst.onlyid[index]) then
			    return false
			end	
		end
		return true
   elseif(BagNow == 3) then
        for index = 7,12 do
		    if(packageBlock.onlyid[index-12] ~= BagHerofirst.onlyid[index]) then
			    return false
			end	
		end
		return true
   end
   return false
end

function Equip_BattleBag_draw()
    local mapid = XGetMapId()
    if(g_bag_hero_ui:IsVisible() == false or mapid ~= 1) then
	    return
	end	
	if checkEveryEquip() then
	    return
	end	
    if(BagNow == 1) then
	    for index = 1,6 do
		    if(BagHerofirst.onlyid[index]~= 0 and BagHerofirst.onlyid[index]~= nil and BagHerofirst.picPath[index]~= 0 and BagHerofirst.picPath[index]~= nil) then
			    if(BagHerofirst.onlyid[index] ~= packageBlock.onlyid[index]) then
					packageBlock.pic[index].changeimage(BagHerofirst.picPath[index]) --包裹框的图片
					packageBlock.picPath[index] = BagHerofirst.picPath[index] --包裹框的图片路径
					packageBlock.onlyid[index] = BagHerofirst.onlyid[index] --包裹框在装备库利的索引Id 0 为没有装备
					packageBlock.pic[index]:SetVisible(1)
					packageBlock.pic[index]:SetImageTip(BagHerofirst.tip[index])
					if(BagHerofirst.itemAnimate[index] ~= -1) then
						packageBlock.pic[index]:EnableImageAnimate(1,BagHerofirst.itemAnimate[index],15,5)
					else
                        packageBlock.pic[index]:CleanImageAnimate() 
					end	
					if(BagHerofirst.bProfession[index] == 1) then
						packageBlock.bProfession_bg[index]:SetVisible(1)
						packageBlock.bProfession[index]:SetVisible(1)
					else
						packageBlock.bProfession_bg[index]:SetVisible(0)
						packageBlock.bProfession[index]:SetVisible(0)
                    end					
                else
                    if(BagHerofirst.itemAnimate[index] ~= -1) then
						packageBlock.pic[index]:EnableImageAnimate(1,BagHerofirst.itemAnimate[index],15,5)
                    end					
                end				
			else
			    if packageBlock.onlyid[index] ~= 0 then
					packageBlock.pic[index].changeimage() --包裹框的图片
					packageBlock.picPath[index] = 0 --包裹框的图片路径
					packageBlock.onlyid[index] = 0 --包裹框在装备库利的索引Id 0 为没有装备
					if(packageBlock.pic[index]:GetBoolImageAnimate() == 1) then
						packageBlock.pic[index]:CleanImageAnimate()
					end	
					packageBlock.bProfession_bg[index]:SetVisible(0)
					packageBlock.bProfession[index]:SetVisible(0)
				end
			end
		end
		BagOpenBtn:SetVisible(0)
	elseif(BagNow == 2) then
	    for index = 7,12 do
		    if(BagHerofirst.onlyid[index]~= 0 and BagHerofirst.onlyid[index]~= nil and BagHerofirst.picPath[index]~= 0 and BagHerofirst.picPath[index]~= nil) then
			    if(BagHerofirst.onlyid[index] ~= packageBlock.onlyid[index-6]) then
					packageBlock.pic[index-6].changeimage(BagHerofirst.picPath[index]) --包裹框的图片
					packageBlock.picPath[index-6] = BagHerofirst.picPath[index] --包裹框的图片路径
					packageBlock.onlyid[index-6] = BagHerofirst.onlyid[index] --包裹框在装备库利的索引Id 0 为没有装备
					packageBlock.pic[index-6]:SetVisible(1)
					packageBlock.pic[index-6]:SetImageTip(BagHerofirst.tip[index])
					if(BagHerofirst.itemAnimate[index] ~= -1) then
						packageBlock.pic[index-6]:EnableImageAnimate(1,BagHerofirst.itemAnimate[index],15,5)
					end   
					if(BagHerofirst.bProfession[index] == 1) then
						packageBlock.bProfession_bg[index-6]:SetVisible(1)
						packageBlock.bProfession[index-6]:SetVisible(1)
					else
						packageBlock.bProfession_bg[index-6]:SetVisible(0)
						packageBlock.bProfession[index-6]:SetVisible(0)
                    end		
				else	
 			        if(BagHerofirst.itemAnimate[index] ~= -1) then
						packageBlock.pic[index-6]:EnableImageAnimate(1,BagHerofirst.itemAnimate[index],15,5)
					end 
				end	
			else
			    if packageBlock.onlyid[index-6] ~= 0 then
					packageBlock.pic[index-6].changeimage() --包裹框的图片
					packageBlock.picPath[index-6] = 0 --包裹框的图片路径
					packageBlock.onlyid[index-6] = 0 --包裹框在装备库利的索引Id 0 为没有装备
					if(packageBlock.pic[index-6]:GetBoolImageAnimate() == 1) then
						packageBlock.pic[index-6]:CleanImageAnimate()
					end	
					packageBlock.bProfession_bg[index-6]:SetVisible(0)
					packageBlock.bProfession[index-6]:SetVisible(0)
				end
            end	
		end
		BagOpenBtn:SetVisible(1)
	elseif(BagNow == 3) then
	    for index = 13,18 do
		    if(BagHerofirst.onlyid[index]~= 0 and BagHerofirst.onlyid[index]~= nil and BagHerofirst.picPath[index]~= 0 and BagHerofirst.picPath[index]~= nil) then
			    if(BagHerofirst.onlyid[index] ~= packageBlock.onlyid[index-12]) then
					packageBlock.pic[index-12].changeimage(BagHerofirst.picPath[index]) --包裹框的图片
					packageBlock.picPath[index-12] = BagHerofirst.picPath[index] --包裹框的图片路径
					packageBlock.onlyid[index-12] = BagHerofirst.onlyid[index] --包裹框在装备库利的索引Id 0 为没有装备
					packageBlock.pic[index-12]:SetVisible(1)
					packageBlock.pic[index-12]:SetImageTip(BagHerofirst.tip[index])
					if(BagHerofirst.itemAnimate[index] ~= -1) then
						packageBlock.pic[index-12]:EnableImageAnimate(1,BagHerofirst.itemAnimate[index],15,5)
					end 
					if(BagHerofirst.bProfession[index] == 1) then
						packageBlock.bProfession_bg[index-12]:SetVisible(1)
						packageBlock.bProfession[index-12]:SetVisible(1)
					else
						packageBlock.bProfession_bg[index-12]:SetVisible(0)
						packageBlock.bProfession[index-12]:SetVisible(0)
                    end		
                else	
 			        if(BagHerofirst.itemAnimate[index] ~= -1) then
						packageBlock.pic[index-12]:EnableImageAnimate(1,BagHerofirst.itemAnimate[index],15,5)
					end 
				end						
			else
			    if packageBlock.onlyid[index-12] ~= 0 then
					packageBlock.pic[index-12].changeimage() --包裹框的图片
					packageBlock.picPath[index-12] = 0 --包裹框的图片路径
					packageBlock.onlyid[index-12] = 0 --包裹框在装备库利的索引Id 0 为没有装备
					if(packageBlock.pic[index-12]:GetBoolImageAnimate() == 1) then
						packageBlock.pic[index-12]:CleanImageAnimate()
					end	
					packageBlock.bProfession_bg[index-12]:SetVisible(0)
					packageBlock.bProfession[index-12]:SetVisible(0)
				end
			end
		end
		BagOpenBtn:SetVisible(1)
	end
end
function Equip_BattleBag_SetBtnFont(itime,index)
    if(index ~= BagNow) then
	    return
	end	
    BagOpenBtnfont:SetFontText(itime)
	BagOpenBtnfont:SetVisible(1)
end
function Equip_BattleBag_SetBtnFontallSetvisible(ibool)
	BagOpenBtnfont:SetVisible(ibool)
end
function Equip_BattleBag_SetBtnFontSetvisible(ibool,index)
    if(index ~= BagNow) then
	    return
	end	
	BagOpenBtnfont:SetVisible(0)
end

function Equip_BattleBag_Clean(ranking)
    BagHerofirst.onlyid[ranking] = 0
    BagHerofirst.picPath[ranking] = 0
	BagHerofirst.tip[ranking] = 0
	BagHerofirst.itemAnimate[ranking] = -1
	BagHerofirst.bProfession[ranking] = 0
end

function Equip_BattleBag_XELP()--用于场外
    local mapid = XGetMapId()
    if(g_bag_hero_ui:IsVisible() == false or mapid ~=1 or g_BagStorage_ui:IsVisible() == true) then
	    return
	end
	if(pullPicType.type ~=3) then
	    return
	end	
	
    local tempRanking = Equip_BattleBag_checkRect() --判断是否在包裹框
	local oldranking = Equip_BattleBag_GetOldId(pullPicType.ustID)
	if(tempRanking == 0 and oldranking ==0) then
	    return
	end
	if(oldranking == 0 and tempRanking ~= 0)then
	    if(pullPicType.id~=0 and pullPicType.id~=nil) then
            if(BagNow == 2) then
			    tempRanking = tempRanking+6
			elseif(BagNow == 3) then
			    tempRanking = tempRanking+12
			end	
            XEquip_BattleBag_DragIn(tempRanking,equipManage.itemOnlyID[pullPicType.id])--传给lua信息
	    end
	elseif(oldranking<=6 and oldranking>=1 and tempRanking>=1 and tempRanking<=6) then
	    if(BagNow == 2) then
			tempRanking = tempRanking+6
			oldranking = oldranking+6
		elseif(BagNow == 3) then
		    tempRanking = tempRanking+12
			oldranking = oldranking+12
		end	
        XEquip_BattleBag_ChangePos(tempRanking,oldranking)
	elseif(oldranking<=6 and oldranking>=1 and tempRanking == 0) then
	    if(BagNow == 2) then
			oldranking = oldranking+6
		elseif(BagNow == 3) then
			oldranking = oldranking+12
		end	
        XEquip_BattleBag_NeedClean(oldranking)
    end	
end

function Equip_BattleBag_GetBagNow()
    return BagNow
end
function Equip_BattleBag_GetEmptyBlock()
    for index = 1,6 do
	    if(packageBlock.onlyid[index] ==0 or packageBlock.onlyid[index] == nil or packageBlock.onlyid[index] =="") then
		     return index
		end	 
	end
	return 0
end


function Equip_BattleBag_XELP_inGame()--用于场内
    local mapid = XGetMapId()
    if(g_bag_hero_ui:IsVisible() == false or mapid ==1 or g_BagStorage_ui:IsVisible() == true) then
	    return
	end
	if(pullPicType.type ~=3) then
	    return
	end	
    local tempRanking = Equip_BattleBag_checkRect() --判断是否在包裹框
	local oldranking = Equip_BattleBag_GetOldId(pullPicType.ustID)
	if(tempRanking == 0 and oldranking ==0) then
	    return
	end
	if(oldranking == 0 and tempRanking ~= 0)then --从背包拖到套装
	    if(pullPicType.id~=0 and pullPicType.id~=nil) then
           XEquip_fightBag_DragIn(tempRanking,equipManage.itemOnlyID[pullPicType.id])--传给lua信息
	    end
	elseif(oldranking<=6 and oldranking>=1 and tempRanking>=1 and tempRanking<=6) then
        XEquip_FightBag_ChangePos(tempRanking,oldranking)
	elseif(oldranking<=6 and oldranking>=1 and tempRanking == 0) then
        XEquip_fightBag_NeedClean(oldranking)
    end	
end





function Equip_BattleBag_checkRect()
    for i = 1,6 do
	    if(CheckEquipPullResult(equip_hero[i])) then
		    return i
		end
	end
	return 0
end
function Equip_BattleBag_GetOldId(onlyidid)
    if(onlyidid ==0 or onlyidid ==nil) then
	    return 0
	end	
    for index = 1,6 do
	    if(packageBlock.onlyid[index] == onlyidid) then
		    return index
		end
	end
	return 0
end

----------------改变选择的英雄图片
function Equip_ChangeHeroPic(pictureName,name,id)
	font_heropic.changeimage("..\\"..pictureName)
	font_heroid= id
	font_HeroTempId = id
	font_heroname:SetFontText(name, 0x49d3f0)
end

function Equip_BagHero_GetHeroID()
    return font_heroid
end
----------------英雄技能图片
function Equip_ChangeHeroSkillPic(q,w,e,r,n)
	SKILL_pic[2].changeimage("..\\"..q)
	SKILL_pic[3].changeimage("..\\"..w)
	SKILL_pic[4].changeimage("..\\"..e)
	SKILL_pic[5].changeimage("..\\"..r)
	SKILL_pic[1].changeimage("..\\"..n)
end

function Equip_ChangeHeroTip(tip)
    if(font_heropic ~= nil) then
        hero_HIDE:SetImageTip(tip)
	end
end

function Bag_Hero_ChangeHeroSkillPicTip(q,w,e,r,n)
	SKILL_pic[2]:SetImageTip(q)
	SKILL_pic[3]:SetImageTip(w)
	SKILL_pic[4]:SetImageTip(e)
	SKILL_pic[5]:SetImageTip(r)
	SKILL_pic[1]:SetImageTip(n)
end

function Bag_HeroSetPosition(x,y)
	g_bag_hero_ui:SetPosition(x,y)
end

function Check_Bag_HeroIsVisible()
    if (g_bag_hero_ui:IsVisible()) then
	    return true
	else
	    return false
	end
end
