include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

-------装备总览
local bag_wnd = {}
bag_wnd.kuang = {}
bag_wnd.lock = {}

local destory = nil

local BagActive = nil
local BagActivefont = nil
local BagTimeLimit = nil

local sort_btn,repair_btn = nil

--包裹框
local packageBlock = {} --包裹框用于存放装备
packageBlock.pic = {} --包裹框的图片
packageBlock.id= {} --包裹框在装备库利的索引Id 0 为没有装备
packageBlock.type = {} --包裹框中是装备还是宝石 分别用 1和2 表示装备 和 宝石 0 代表没有装备 
packageBlock.itemCount = {} --物品数量

local StrExp = nil
local CurExp = 0
local MaxExp = 30


-------装备界面背包扩展
function InitBag_Expend_2_UI(wnd, bisopen)
	----------背包扩展
	g_bag_expend2_ui = CreateWindow(wnd.id, 700,220,410,460)
	for i=1,18 do
		local posx = 54*((i-1)%7+1)+10
		local posy = math.ceil(i/7)*54-44
		
		bag_wnd[i] = g_bag_expend2_ui:AddImage(path_equip.."bag_equip.png",posx,posy,50,50)

		packageBlock.pic[i] = bag_wnd[i]:AddImageMultiple(path_equip.."bag_equip.png","","",0,0,50,50)
		packageBlock.pic[i]:SetVisible(0)
		bag_wnd.lock[i] = bag_wnd[i]:AddImage(path_info.."lock_info.png", -2, -2, 64, 64)
		bag_wnd.lock[i]:SetTouchEnabled(0)
		bag_wnd.kuang[i] = bag_wnd[i]:AddImage(path_equip.."kuang_equip.png",0,0,50,50)
		packageBlock.pic[i].script[XE_DRAG] = function()
		    if(packageBlock.id[i] == nil or packageBlock.id[i] == 0) then--id不存在 不响应
			    return
			end
			game_equip_pullPic(packageBlock.id[i],packageBlock.pic[i])
			bag_wnd.kuang[i].changeimage(path_equip.."kuang3_equip.png")
		end
		
		packageBlock.pic[i].script[XE_ONHOVER] = function()
			bag_wnd.kuang[i].changeimage(path_equip.."kuang2_equip.png")
		end
		packageBlock.pic[i].script[XE_ONUNHOVER] = function()
			bag_wnd.kuang[i].changeimage(path_equip.."kuang_equip.png")
		end
		
		packageBlock.pic[i].script[XE_RBUP] = function()
		    if(packageBlock.id[i] == nil or packageBlock.id[i] == 0) then--id不存在 不响应
			    return
			end			
			if(g_BagStorage_ui:IsVisible() == true) then
			    local mndex = GetBagStorage_empty()
			    if(mndex == 0) then
				   return
				else
                    XEquip_BagStorage_change(5,2,i,mndex)
                end	
			elseif(packageBlock.type[i]~=3) then
			    XBagEquipOnIconRButtonUp(equipManage.itemOnlyID[packageBlock.id[i]])			
			else
			    local BagNow = Equip_BattleBag_GetBagNow()
				local tempRanking = Equip_BattleBag_GetEmptyBlock()
				if(tempRanking == 0) then
				    return
				end	
			    if(BagNow == 2) then
			        tempRanking = tempRanking+6
			    elseif(BagNow == 3) then
			        tempRanking = tempRanking+12
			    end	
                XEquip_BattleBag_DragIn(tempRanking,equipManage.itemOnlyID[packageBlock.id[i]])--传给lua信息
			end
		end
	end
	
	for i=1,18 do
		packageBlock.itemCount[i] = packageBlock.pic[i]:AddFont("0",12,6,-50,-33,100,17,0xFFFFFF)
	    packageBlock.itemCount[i]:SetVisible(0)
		packageBlock.itemCount[i]:SetFontBackground()
	end	
	
	g_bag_expend2_ui:AddImage(path_equip.."blacklight_equip.png",150,220,202,10)
	StrExp = g_bag_expend2_ui:AddImage(path_equip.."pinklight_equip.png",150,220,202,10)
	StrExp:SetAddImageRect(StrExp.id, 0, 0, 202*(CurExp/MaxExp), 10, 150 ,220, 202*(CurExp/MaxExp), 10)
	
	local Attention = g_bag_expend2_ui:AddFont("提示：\n◆拖动物品移至最上方的背包标签，再松开即可完成物品的转移.",11,0,80,330,340,40,0x8295cf)
	Attention:SetFontSpace(1,1)
	BagActive = g_bag_expend2_ui:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",210,250,83,35)
	BagActivefont = BagActive:AddFont("激活背包",15,8,0,0,83,35,0xbcbcc4)
	BagTimeLimit = BagActive:AddFont("有效期已过只能取出不能存入",12, 8, 58, -38, 200, 20, 0x6ffefc)
	BagActive.script[XE_LBUP] = function()
	    XBagOpenClick(3)
	end
	
	destory = g_bag_expend2_ui:AddImage(path_equip.."destory_equip.png",65,400,32,32)
	XWindowEnableAlphaTouch(destory.id)
	g_bag_expend2_ui:AddFont("物品销毁",11, 0, 85, 404, 100, 20, 0x8295cf)

	sort_btn = g_bag_expend2_ui:AddButton(path_setup.."btn1_mail.png",path_setup.."btn2_mail.png",path_setup.."btn3_mail.png", 245, 395, 100, 32)
	sort_btn:AddFont("物品整理",12, 8, 0, 0, 100, 32, 0xffffff)
	sort_btn.script[XE_LBUP] = function()
	    XEquip_BagEquipSortAll()--需要区分
	end
	
	
	repair_btn = g_bag_expend2_ui:AddButton(path_setup.."btn1_mail.png",path_setup.."btn2_mail.png",path_setup.."btn3_mail.png", 345, 395, 100, 32)
	repair_btn:AddFont("全部修理",12, 8, 0, 0, 100, 32, 0xffffff)
	repair_btn.script[XE_LBUP] = function()
	    XEquip_BagEquipRpaireAll()--需要区分
	end
	
	
	g_bag_expend2_ui:SetVisible(bisopen)
end

function GetBagExpand2_empty()
    for index = 1,18 do
	    if(packageBlock.id[index] == 0 or packageBlock.id[index] == nil) then
		    return index
		end
	end
	return 0
end

function SetBagExpand2lockVisible(index)
   for i = 1,18 do
      bag_wnd.lock[i]:SetVisible(index)
   end
end

function SetBagExpand2Station(ibool)
	if(ibool == 1) then
		BagActivefont:SetFontText("续费背包")
        SetBagExpand2lockVisible(0)		
	elseif(ibool == 0) then
		BagActivefont:SetFontText("激活背包")
		BagTimeLimit:SetFontText("有效期已过只能取出不能存入",0x6ffefc)
		SetBagExpand2lockVisible(1)	
	end
end

function SetBagExpand2TimeLimit(Ctext,iday)
	BagTimeLimit:SetFontText(Ctext,0x6ffefc)
	local restDay
	if(iday >= MaxExp) then
	    restDay = MaxExp
	else
        restDay = iday	
	end
	if(CurExp == restDay) then
	    return
	end	
	CurExp = restDay
	StrExp:SetAddImageRect(StrExp.id, 0, 0, 202*(CurExp/MaxExp), 10, 150 ,220, 202*(CurExp/MaxExp), 10)
end


function Equip_BagExpand2_cleanALl_ItemInfo()
    for index =1,18 do
	    packageBlock.pic[index].changeimage() --包裹框的图片
		packageBlock.pic[index]:SetVisible(0)
		packageBlock.itemCount[index]:SetFontText("0",0xFFFFFF)
		packageBlock.pic[index]:SetImageTip(0)
	    if(packageBlock.pic[index]:GetBoolImageAnimate() == 1) then
		    packageBlock.pic[index]:CleanImageAnimate()
		end
	end
	packageBlock.id = {}
    packageBlock.type = {}
end


function Equip_BagExpand2_needEquipInfo()--需要全部 导入第一个背包数据
    if(g_bag_expend2_ui:IsVisible() == false) then
        return
	end	
	Equip_BagExpand2_cleanALl_ItemInfo()--equipManage.CpackCindex = {}
    for index,value in pairs(equipManage.CitemIndex) do
	    local packCindex = equipManage.CpackCindex[index]+1
	    if(equipManage.bagType[index] == 5 and equipManage.CpackCindex[index] <=18) then
	        packageBlock.pic[packCindex].changeimageMultiple(equipManage.picPath[index],equipManage.picPath1[index],equipManage.picPath2[index])
		    packageBlock.pic[packCindex]:SetVisible(1)
		    packageBlock.pic[packCindex]:SetImageTip(equipManage.tip[index])
            packageBlock.id[packCindex] = equipManage.id[index]
            packageBlock.type[packCindex] = equipManage.type[index]
		    packageBlock.itemCount[packCindex]:SetFontText(equipManage.itemCount[index])
		    if(equipManage.itemCount[index]>1 and equipManage.type[index]~=3) then
			    packageBlock.itemCount[packCindex]:SetVisible(1)
		    else 
			    packageBlock.itemCount[packCindex]:SetVisible(0)
		    end
			if(equipManage.itemAnimation[index] ~= -1) then
			    packageBlock.pic[packCindex]:EnableImageAnimate(1,equipManage.itemAnimation[index],15,5)
			end	
		end	
	end
end	

---用于拖拽---
function Equip_BagExpand2_pullPicXLUP()
    if(g_bag_expend2_ui:IsVisible() == false or pullPicType.id == 0 or pullPicType.id ==nil) then
	    return
	end
    local tempRanking = Equip_BagExpand2_checkRect() --判断是否在包裹框
	local oldBag = equipManage.bagType[pullPicType.id]
	local oldranking = equipManage.CpackCindex[pullPicType.id]+1  --得到老的位置
	
	if(oldranking<=18 and oldranking>=1 and oldBag == 5) then
	    bag_wnd.kuang[oldranking].changeimage(path_equip.."kuang_equip.png")	
    end	
	if(tempRanking == 0) then
	    return
	end
	XEquip_BagEquip_change(oldBag,4,oldranking,tempRanking)
end

function Equip_BagExpand2_checkRect()
    for i = 1,18 do
	    if(CheckEquipPullResult(bag_wnd[i])) then
		    return i
		end
	end
	return 0
end
function Equip_BagExpand2_getPullPicIndexInPackage(id) --得到老的位置
   for i = 1,18 do
	    if(packageBlock.id[i] == id) then
		    return i
		end
	end
	return 0
end

function Equip_BagExpand2_PullPicDeleteXLUP()  
    if(g_bag_expend2_ui:IsVisible() == false) then
	    return
	end
	if(CheckEquipPullResultDestory(destory)) then
       XEquip_BagEquip_DeleteItem(equipManage.itemOnlyID[pullPicType.id])
	end
end





function SetBagExpend2IsVisible(flag) 
	if g_bag_expend2_ui ~= nil then
		if flag == 1 and g_bag_expend2_ui:IsVisible() == false then
			g_bag_expend2_ui:SetVisible(1)
			EquipChangeBag(5)
			Equip_BagExpand2_needEquipInfo()
		elseif flag == 0 and g_bag_expend2_ui:IsVisible() == true then
			g_bag_expend2_ui:SetVisible(0)
			Equip_BagExpand2_cleanALl_ItemInfo()
		end
	end
end

function Bag_BagExpend2SetPosition(x,y)
	g_bag_expend2_ui:SetPosition(x,y)
end