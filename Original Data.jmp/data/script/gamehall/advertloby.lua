include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

--消息界面

local AdvertImage = nil
local AdvertImageIndex = 1

local Left = nil
local Right = nil

local changAdvertPoint = {}
local ChangeAdvertLightPoint = nil
local ChangeImagePic = {}
local m_sFontText = {}
local m_sFontText_info = {}
local m_sFontLink = {}
local m_sFontWnd = {}

function InitLobbyAdvert_ui(wnd,bisopen)
	n_Advert_ui = CreateWindow(wnd.id, 860, 240, 414, 184)
	InitAdvert_ui(n_Advert_ui)
	n_Advert_ui:SetVisible(bisopen)
end

function InitAdvert_ui(wnd)
	AdvertImage = wnd:AddImage(path_equip.."GemBuyBack_equip.png",9, 7, 398, 170)
    wnd:AddImage(path.."advertback.png",0, 0, 414, 184)
	Left = wnd:AddButton(path.."AdvertLeftBlack.png",path.."AdvertLeftLight.png",path.."AdvertLeftBlack.png",346,146,30,30)
	Left.script[XE_LBUP] = function()
	    AdvertChangeShowPre()
	end
	Right = wnd:AddButton(path.."AdvertRightBlack.png",path.."AdvertRightLight.png",path.."AdvertRightBlack.png",376,146,30,30)
	Right.script[XE_LBUP] = function()
	    AdvertChangeShowNext()
	end
	AdvertImage.script[XE_LBUP] = function()
	    AdvertOpenWebpage(AdvertImageIndex)
	end
	for i = 1,5 do
	    changAdvertPoint[i] = wnd:AddImage(path.."point.png",265+(i-1)*10, 160, 8, 4)
	end	
	ChangeAdvertLightPoint = wnd:AddImage(path.."pointlight.png",265, 160, 16, 4)
	n_Advert_ui:SetVisible(0)
	
	-- for i=1, 3 do
		-- m_sFontWnd[i] = wnd:AddImage( path.."point.png", 0, -110+((i-1)*40), 400, 20)
		-- m_sFontWnd[i]:SetTransparent(0)
		-- m_sFontWnd[i].script[XE_ONHOVER] = function()
			-- m_sFontText[i]:SetFontText( m_sFontText_info[i], 0xff0000)
		-- end
		-- m_sFontWnd[i].script[XE_ONUNHOVER] = function()
			-- m_sFontText[i]:SetFontText( m_sFontText_info[i], 0xffffff)
		-- end
		-- m_sFontWnd[i].script[XE_LBUP] = function()
			-- XClickFontLobbyLink( m_sFontLink[i])
		-- end
		-- m_sFontText[i] = m_sFontWnd[i]:AddFont( "1", 15, 8, 0, 0, 400, 20, 0xffffff)
	-- end
end

function AdvertSetPosPic(index)
    local PosX = 265
	for i = 1,5 do
	    if i~= index then
		    changAdvertPoint[i]:SetPosition(PosX,160)
			PosX = PosX + 10
		else
		    changAdvertPoint[i]:SetPosition(PosX,160)
			ChangeAdvertLightPoint:SetPosition(PosX,160)
			PosX = PosX + 18
		end
	end
end

function AdvertAddImagePicPath(strPic)
    local index = #ChangeImagePic+1
    -- log("sss:: "..strPic.."  index::"..index)
	ChangeImagePic[index] = "lobby/"..strPic
	if index == 1 then
	    AdvertImage.changeimage(ChangeImagePic[1])
	end
end

function AdvertChangeImage(index)
    if(g_game_hall_ui:IsVisible() == false) then
        return
    end		
   if(index<=5 and index>=1) then
       AdvertImage.changeimage(ChangeImagePic[index])
	   AdvertImageIndex = index
	   AdvertSetPosPic(index)
   end
end

function AdvertChangeShowPre()
    local index = AdvertImageIndex
	if index == 1 then
	    index = 5
	else
        index = index - 1
    end	
	XAdvertShow(index)
end

function AdvertChangeShowNext()
    local index = AdvertImageIndex
	if index == 5 then
	    index = 1
	else
        index = index + 1
    end	
	XAdvertShow(index)
end

function SetAdvertIsVisible(flag) 
	if n_Advert_ui ~= nil then
		if flag == 1 and n_Advert_ui:IsVisible() == false then
			n_Advert_ui:SetVisible(1)
		elseif flag == 0 and n_Advert_ui:IsVisible() == true then
			n_Advert_ui:SetVisible(0)
		end
	end
end

function CreateFontLobby( cFontText, cFontLink, cIndex)
	-- 暂不开放
	-- m_sFontText[cIndex]:SetFontText( cFontText, 0xffffff)
	-- m_sFontText_info[cIndex] = cFontText
	-- m_sFontLink[cIndex] = cFontLink
end