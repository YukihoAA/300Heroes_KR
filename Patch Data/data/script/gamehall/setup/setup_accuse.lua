include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

--------举报界面

local friend_ManageShow = {}
friend_ManageShow.back = {}--底图
friend_ManageShow.headPic = {}--头像
friend_ManageShow.namefont = {}--名字
friend_ManageShow.Accuse = {}--举报
friend_ManageShow.CancelAccuse = {} --取消举报

	
function InitSetup_AccuseUI(wnd, bisopen)
	g_setup_accuse_ui = CreateWindow(wnd.id, 650, 300, 512, 1024)
	Init_AccuseTips(g_setup_accuse_ui)
	g_setup_accuse_ui:SetVisible(bisopen)
end

function Init_AccuseTips(wnd)
    wnd:AddImage(path_setup.."FriendBg_setup.png", -4, -4, 380, 540)
	local btn_close = wnd:AddButton(path_shop.."close1_rec.png",path_shop.."close2_rec.png",path_shop.."close3_rec.png",332,5,35,35)
	btn_close.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XShow_SetupAccuse(0)
		Set_SetupAccuseIsVisible(0)
	end	
	
	for index = 1,7 do
	    friend_ManageShow.back[index] = wnd:AddImage(path_setup.."friendinfoback_setup.png",15,64*index,334,62)
		friend_ManageShow.headPic[index] = friend_ManageShow.back[index]:AddImage(path_equip.."bag_equip.png",5,5,50,50)	--图片路径--好友头像
		friend_ManageShow.namefont[index] = friend_ManageShow.back[index]:AddFont("玩家名字"..index,15, 0, 70, 10, 200, 18, 0x82d2e6)--好友名字
		friend_ManageShow.Accuse[index] = friend_ManageShow.back[index]:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",230,14,83,35)
		friend_ManageShow.Accuse[index]:AddFont("举报",15,8,8,-8,100,20,0xbcbcc4)
		friend_ManageShow.Accuse[index].script[XE_LBUP] = function()
		    XAccuseClickUp(index)
		end
		friend_ManageShow.CancelAccuse[index] = friend_ManageShow.back[index]:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",260,20,83,35)
		friend_ManageShow.CancelAccuse[index].script[XE_LBUP] = function()
		    XCancelAccuseClickUp(index)
		end 
	end
	Setup_AccuseSetAllShowClear()
end

function Setup_AccuseSetvisible(index,ibool)
    if(index<1 or index>7) then
	    return
	end	
	friend_ManageShow.Accuse[index]:SetVisible(ibool)
end
function Setup_AccuseSetEnable(index,ibool)
    if(index<1 or index>7) then
	    return
	end	
	friend_ManageShow.Accuse[index]:SetEnabled(ibool)
end
function Setup_CancelAccuseSetEnable(index,ibool)
    if(index<1 or index>7) then
	    return
	end	
	friend_ManageShow.CancelAccuse[index]:SetEnabled(ibool)
end

function Setup_CancelAccuseSetvisible(index,ibool)
    if(index<1 or index>7) then
	    return
	end	
	friend_ManageShow.CancelAccuse[index]:SetVisible(ibool)
end







function Setup_AccuseSetAllShowClear()
    for index =1,7 do
        friend_ManageShow.back[index]:SetVisible(0)
	    friend_ManageShow.Accuse[index]:SetVisible(0)
		friend_ManageShow.Accuse[index]:SetEnabled(1)
		friend_ManageShow.CancelAccuse[index]:SetVisible(0)
		friend_ManageShow.CancelAccuse[index]:SetEnabled(1)
	end
end
function Setup_AccuseSetOneShow(name,strPic,index)
    if(index<1 or index>7) then
	    return
	end	
	friend_ManageShow.headPic[index].changeimage("..\\"..strPic)
	friend_ManageShow.namefont[index]:SetFontText(name)
	friend_ManageShow.back[index]:SetVisible(1)
end













----------整个界面显示
function Set_SetupAccuseIsVisible(flag) 
	if g_setup_accuse_ui ~= nil then
		if flag == 1 and g_setup_accuse_ui:IsVisible() == false then
			g_setup_accuse_ui:CreateResource()
		    XShow_SetupAccuse(1)
			g_setup_accuse_ui:SetVisible(1)
			Set_SetupIsVisible(0)
		elseif flag == 0 and g_setup_accuse_ui:IsVisible() == true then
			g_setup_accuse_ui:DeleteResource()
			g_setup_accuse_ui:SetVisible(0)
		end
	end
end
function MainAccuseSetPosition(x,y)
	g_setup_accuse_ui:SetPosition(x, y)
end




