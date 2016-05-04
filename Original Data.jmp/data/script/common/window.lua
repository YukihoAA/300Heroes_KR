include("../Data/Script/Common/mathlib.lua")

--[[ 窗口类型 ]]--
Wnd_Windows = 0
Wnd_Image = 1
Wnd_Button = 2
Wnd_Font = 3
Wnd_ImageMultiple = 4

CHANGE_SPEED_MULTIPLE = 20

function SkipLoadResource(skip)
	XSkipLoadResource(skip)
end

windows = {}
function AddWindow( wnd )
	--log("\nwnd="..wnd.id)
    windows[wnd.id] = wnd
end

function RemoveWindow(id)
	windows[id] = nil
end

WINDOW = {}

function WINDOW:new(parentid, rect, type )
    local o = {}
    setmetatable(o,self)
    self.__index = WINDOW
    type = type or ""
    parentid = parentid or 0
		rect = rect or RECT:new()
    o.id = XCreateWindow( parentid, type, rect.l, rect.t, rect.r, rect.b )
    o.rect = rect
    o.script = {}
    o.parentid = parentid
	AddWindow( o )

    return o
end
	
function WINDOW:Release()
    XReleaseWindow(self.id)
	if windows[self.id] ~= nil then
		windows[self.id] = nil
	end
end

function WINDOW:ReleaseEx(pathex)
	XRemoveImage(self.id, pathex)
end


function WINDOW:DeleteResource()
	XDeleteResourceWindow(self.id)
end
function WINDOW:CreateResource()
	XCreateResourceWindow(self.id)
end

--
function WINDOW:EnableBlackBackgroundTop(enable)
	return XEnableWindowBlackBackgroundTop(self.id,enable)
end

--获取窗口绝对的坐标   left,top,right,bottom
function WINDOW:GetRect()
	return XGetWindowRect(self.id)
end
--设置窗口相对的坐标   left,top,width,height
--function WINDOW:SetDrawRect(l,t,w,h)
--	return XSetDrawRect(self.id,l,t,w,h)
--end

--获取窗口宽高
function WINDOW:GetWH()
	return XGetWindowClientRect(self.id)
end

--设置宽高
function WINDOW:SetWH(width,height)
	log("modify tip width "..width)
	return XSetWindowClientRect(self.id,width,height)
end

--设置等比例缩放
function WINDOW:SetScale(ratio)
	local w,h = XGetWindowClientRect(self.id)
	return XSetWindowClientRect(self.id,w*ratio,h*ratio)
end 

--设置等比例缩放
function WINDOW:SetWindowScale(ratiox,ratioy,type)
	return XSetWindowScale(self.id,ratiox,ratioy,type)
end 

--设置比例缩放宽度
function WINDOW:SetScaleW(ratio)
	local w,h = XGetWindowClientRect(self.id)
	return XSetWindowClientRect(self.id,w*ratio,h)
end 
--设置比例缩放高度
function WINDOW:SetScaleH(ratio)
	local w,h = XGetWindowClientRect(self.id)
	return XSetWindowClientRect(self.id,w,h*ratio)
end 

--设置透明度，参数为0~1,值越小透明度越高
function WINDOW:SetTransparent(transparency)
	return XSetWindowTransparent(self.id,transparency)
end 

--获得透明度，用来判断是否完全显示（淡入到1）
function WINDOW:GetTransparent()
	return XGetWindowTransparent(self.id)
end 

--获取窗口位置
function WINDOW:GetPosition()
	return XGetWindowPosition(self.id)
end

function WINDOW:GetClientPosition()
	return XGetWindowPosition_Client(self.id)
end

--设置窗口位置
function WINDOW:SetPosition(x,y)
	return XSetWindowPosition(self.id,x,y)
end

--设置窗口绝对位置
function WINDOW:SetAbsolutePosition(x,y)
	return XSetWindowAbsolutePosition(self.id,x,y)
end

--动作移动到,第三个参数表示持续时间(单位为秒)
function WINDOW:MoveTo(from_x,from_y,to_x,to_y,duration)
	local x_length = math.abs(from_x - to_x)
	local y_length = math.abs(from_y - to_y)
	local speed_x = 0
	local speed_y = 0
	local current_x = from_x
	local current_y = from_y
	if duration > 0 then 
		 speed_x = x_length/(duration *1000)
		 speed_y = y_length/(duration *1000)
	end 
	self:SetTimer(0,10).Timer = function(timer, interval)
		if from_x <= to_x then 
			current_x = math.min(to_x,current_x + speed_x * interval)
		else
			current_x = math.max(to_x,current_x - speed_x * interval)
		end
		if from_y <= to_y then 
			current_y = math.min(to_y,current_y + speed_y * interval)
		else
			current_y = math.max(to_y,current_y - speed_y * interval)
		end 
		if  (from_x < to_x and  current_x >=  to_x) or (from_x > to_x and  current_x <=  to_x) then
			self:KillTimer(timer)
			XSetWindowPosition(self.id,to_x,to_y)
			if self.callback ~= nil then 
				self.callback()
			end 
		end
		
		XSetWindowPosition(self.id,current_x,current_y)
	end 
end 

--相对位移
function WINDOW:MoveBy(x_length,y_length,duration)
	local from_x,from_y = XGetWindowPosition(self.id)
	local to_x,to_y = 0,0
	to_x = from_x + x_length
	to_y = from_y + y_length
	self:MoveTo(from_x,from_y,to_x,to_y,duration)
end 

--设置旋转中心，转动角度
function WINDOW:SetRotationBasedPoint(originx,originy,rat)
	local ratio = rat*math.pi/180
	local tempratio = 0
	local current_x,current_y = self:GetPosition()
	local x_length = originx - current_x
	local y_length = originy - current_y
	local radius = math.sqrt(x_length*x_length + y_length*y_length)
	self:SetTimer(0,1,1,0).Timer = function(timer, interval)
		local tempx = originx + math.cos(tempratio)*radius*interval
		local tempy = originy + math.sin(tempratio)*radius*interval
		self:SetPosition(tempx,tempy)
		tempratio = ratio + tempratio
		local tempgap = tempratio - 2*math.pi
		if math.abs(tempgap) >= 0 and math.abs(tempgap) < ratio  then 
			tempgap = 0 
		end 
	end
end 


--淡入
function WINDOW:FadeIn(duration)
	local transparency = 0
	local d_value = 1/(duration*1000)
	
	XSetWindowTransparent(self.id,transparency)
	self:SetTimer(0,1).Timer = function(timer,interval)
		if transparency == 0 then
			self:SetVisible(1)
		end
		if transparency >= 0 then 
			transparency = transparency + d_value*interval
		end
		if  transparency >= 1 then
			self:KillTimer(timer)
			transparency = 1
			if self.callback ~= nil then 
				self.callback()
			end 
		end 
		
		XSetWindowTransparent(self.id,transparency)
	end 
end 

--淡出
function WINDOW:FadeOut(duration)
	local transparency = 1
	local d_value = 1/(duration*1000)
	
	XSetWindowTransparent(self.id,transparency)
	self:SetTimer(0,1).Timer = function(timer,interval)
		if transparency <= 1 then 
			transparency = transparency - d_value*interval
		end
		if  transparency <= 0 then
			self:KillTimer(timer)
			transparency = 0
			self:SetVisible(0)
			if self.callback ~= nil then 
				self.callback()
			end 
		end 	
		
		XSetWindowTransparent(self.id,transparency)
	end 
end 

--相对移动并淡出
function WINDOW:MoveByAndFadeOut(x_length,y_length,duration)
	local from_x,from_y = XGetWindowPosition(self.id)
	local to_x,to_y = 0,0
	to_x = from_x + x_length
	to_y = from_y + y_length
	local x_length = math.abs(from_x - to_x)
	local y_length = math.abs(from_y - to_y)
	local speed_x = 0
	local speed_y = 0
	local current_x = from_x
	local current_y = from_y
	if duration > 0 then 
		 speed_x = x_length/(duration *1000)
		 speed_y = y_length/(duration *1000)
	end 
	local transparency = 1
	local d_value = 1/(duration*1000)
	XSetWindowTransparent(self.id,transparency)
	self:SetTimer(0,1).Timer = function(timer,interval)
		if from_x <= to_x then 
			current_x = current_x +speed_x*interval
		else
			current_x = current_x - speed_x*interval
		end
		if from_y <= to_y then 
			current_y = current_y + speed_y*interval
		else
			current_y = current_y - speed_y*interval
		end 
		if transparency <= 1 then 
			transparency = transparency - d_value*interval
		end
		if  (from_x <= to_x and  current_x >=  to_x) or (from_x >= to_x and  current_x <=  to_x) then
			self:KillTimer(timer)
			XSetWindowPosition(self.id,to_x,to_y)
			XSetWindowTransparent(self.id,0)
			if self.callback ~= nil then 
				self.callback()
			end 
		end 	
		XSetWindowPosition(self.id,current_x,current_y)
		XSetWindowTransparent(self.id,transparency)
	end 
end  

--获取鼠标在本地的位置
function WINDOW:GetLocalMousePosition()
	return XGetWindowLocalMousePosition(self.id)
end

--设置接收消息为最后
function WINDOW:SetBottomMost()
	return XSetWindowBottomMost(self.id)
end

function WINDOW:SetTopMost()
	return XSetWindowTopMost(self.id)
end

--设置接收消息为最后
function WINDOW:SetBackGroundColor(uColor)
	return XSetWindowBackGroundColor(self.id,uColor)
end

--设置是否可见,1表示可见,0表示不可见
function WINDOW:SetVisible(iVisible)
	XSetWindowVisible(self.id,iVisible)
end

--查看是否可见
function WINDOW:IsVisible()
	return XIsWindowVisible(self.id)
end


--开关标识位
function WINDOW:ToggleFlags(uFlags,bEnable)
	XToggleWindowFlags(self.id,uFlags,bEnable)
end

--开关接收某种行为
function WINDOW:ToggleEvent(evt,bEnable)
	XToggleWindowEvent(self.id,evt,bEnable)
end

--开关接收某种行为
function WINDOW:ToggleBehaviour(behaviours,bEnable)
	XToggleWindowBehaviour(self.id,behaviours,bEnable)
end

--触发某种行为
function WINDOW:TriggerBehaviour(behaviours)
	XTriggerWindowBehaviour(self.id,behaviours)
end
--触发down事件后cancelcapture
function WINDOW:CancelCapture()
	XCancelCapture(self.id)
end
function WINDOW:AddImage(file, l, t, w, h)
	local o = {}
    setmetatable(o,self)
    self.__index = WINDOW
		file = file or ""
		l = l or 0
		t = t or 0
		local size = self.rect:GetSize()
		w = w or size.x
		h = h or size.y
    o.id = XCreateImage( self.id, l, t, l+w, t+h, file )
    o.rect = RECT:new(l,t,w,h)
    o.parentid = self.id
	o.script = {}
	o.changeimage = function (file)
		XChangeImage(o.id, file, Wnd_Image ,0)
	end
	o.setrotation = function(angle)
		XSetWindowRotation(o.id,angle)  --设置旋转
	end 
	o.setTip = function(notice,w,h)
			o:ToggleBehaviour(XE_ONHOVER, 1)
			o:ToggleBehaviour(XE_ONUNHOVER, 1)
			o:ToggleEvent(XE_ONHOVER, 1)
			o:ToggleEvent(XE_ONUNHOVER, 1)	
  			o.script[XE_ONHOVER] = function()
	    			setTip(notice,0,0,w,h,o.id)
			end
  			o.script[XE_ONUNHOVER] = function()
	   			 setTip(nil)
			end
	end
	o.setTipEx = function(tipstr,item_id,item_type,item_level,item_has)		--表id,表等级，类型
			o:ToggleBehaviour(XE_RENDER, 1)
			o:ToggleEvent(XE_RENDER, 1)
			o:ToggleBehaviour(XE_ONHOVER, 1)
			o:ToggleBehaviour(XE_ONUNHOVER, 1)
			o:ToggleEvent(XE_ONHOVER, 1)
			o:ToggleEvent(XE_ONUNHOVER, 1)	
  			o.script[XE_ONHOVER] = function()
				log("on hover set tipex")
				self.ItemStr = tipstr
				self.ItemId=item_id
				self.ItemLevel=item_level
				self.ItemType=item_type
				self.ItemHas = item_has
				log("on hover set tipex exit")
			end
  			o.script[XE_ONUNHOVER] = function()
				log("unhover ")
				self.ItemId=nil
				self.ItemLevel=nil
				self.ItemType=nil
				self.ItemStr=nil
				self.ItemHas=nil
				log("unhover exit")
			end
	end
	
	o.script[XE_RENDER] = function()
		if self.ItemId == nil and self.ItemStr == nil then
			return
		end
		
		local px=XGetCursorPosX()
		local py=XGetCursorPosY()
		px = px + 32
		py = py + 32
			XShowTip(px,py,self.ItemId,self.ItemType,self.ItemLevel,self.ItemStr,self.ItemHas)
	end
	AddWindow( o )
	
	return o
end

function WINDOW:AddImageEx(file1, file2, l, t, w, h)
		local o = {}
    setmetatable(o,self)
    self.__index = WINDOW
		file = file or ""
		l = l or 0
		t = t or 0
		local size = self.rect:GetSize()
		w = w or size.x
		h = h or size.y
    o.id = XCreateImageEx( self.id, l, t, l+w, t+h, file1, file2 )
    o.rect = RECT:new(l,t,w,h)
    o.parentid = self.id
	o.script = {}
	o.changeimage = function (file)
		XChangeImage(o.id, file, Wnd_Image ,0)
	end
	o.setrotation = function(angle)
		XSetWindowRotation(o.id,angle)  --设置旋转
	end 
	o.setTip = function(notice,w,h)
			o:ToggleBehaviour(XE_ONHOVER, 1)
			o:ToggleBehaviour(XE_ONUNHOVER, 1)
			o:ToggleEvent(XE_ONHOVER, 1)
			o:ToggleEvent(XE_ONUNHOVER, 1)	
  			o.script[XE_ONHOVER] = function()
	    			setTip(notice,0,0,w,h,o.id)
			end
  			o.script[XE_ONUNHOVER] = function()
	   			 setTip(nil)
			end
	end
	o.setTipEx = function(tipstr,item_id,item_type,item_level,item_has)		--表id,表等级，类型
			o:ToggleBehaviour(XE_RENDER, 1)
			o:ToggleEvent(XE_RENDER, 1)
			o:ToggleBehaviour(XE_ONHOVER, 1)
			o:ToggleBehaviour(XE_ONUNHOVER, 1)
			o:ToggleEvent(XE_ONHOVER, 1)
			o:ToggleEvent(XE_ONUNHOVER, 1)	
  			o.script[XE_ONHOVER] = function()
				log("on hover set tipex")
				self.ItemStr = tipstr
				self.ItemId=item_id
				self.ItemLevel=item_level
				self.ItemType=item_type
				self.ItemHas = item_has
				log("on hover set tipex exit")
			end
  			o.script[XE_ONUNHOVER] = function()
				log("unhover ")
				self.ItemId=nil
				self.ItemLevel=nil
				self.ItemType=nil
				self.ItemStr=nil
				self.ItemHas=nil
				log("unhover exit")
			end
	end
	
	o.script[XE_RENDER] = function()
		if self.ItemId == nil and self.ItemStr == nil then
			return
		end
		
		local px=XGetCursorPosX()
		local py=XGetCursorPosY()
		px = px + 32
		py = py + 32
			XShowTip(px,py,self.ItemId,self.ItemType,self.ItemLevel,self.ItemStr,self.ItemHas)
	end
	AddWindow( o )
	
	return o
end

-- 指定显示图片的显示区域
function WINDOW:SetAddImageRect(id, sl, st, sw, sh, dl, dt, dw, dh) --前面4个参数中后面2个（st, sw）表示坐标，后面4个参数中的后面2个，表示宽和高（dw, dh）
	XSetAddImageRect(id, sl, st, sw, sh, dl, dt, dw, dh)
end

-- 指定显示图片的显示区域
function WINDOW:SetImageColdTime(coldtime,isskillcd) --设置CD
	XSetImageColdTime(self.id, coldtime,isskillcd)
end
function WINDOW:SetImageColdTimeEx(coldtime,starttime,isskillcd) --设置CD加强版
	XSetImageColdTimeEx(self.id, coldtime, starttime,isskillcd)
end
function WINDOW:SetImageColdTimeFontSize(fontsize) --设置CD字体大小
	XSetImageColdTimeFontSize(self.id, fontsize)
end
function WINDOW:SetImageColdTimeFontColor(fontcolor) --CD字体颜色
	XSetImageColdTimeFontColor(self.id, fontcolor)
end
function WINDOW:SetImageColdTimeType(type) --CD倒计时显示方式，0是在控件中间，1是在控件下方
	XSetImageColdTimeType(self.id, type)
end
function WINDOW:SetImageColdTimeNeedMask(need)
	XSetImageColdTimeNeedMask(self.id, need)
end

function WINDOW:EnableImageAnimate(enable,type, speed, cutsize)
	if type==9 then
		XEnableImageAnimate(self.id, enable, type, 15, -2)
	elseif type == 6 then
		XEnableImageAnimate(self.id, enable, type, 25, cutsize)
	else
 		XEnableImageAnimate(self.id, enable, type, speed, cutsize)	
	end
end

function WINDOW:EnableImageFlash(enable,ftime)
	XEnableImageFlash(self.id,enable,ftime)
end

function WINDOW:EnableImageAnimateEX(enable,type, speed, ll, lt, lw, lh)
	XEnableImageAnimateEX(self.id, enable, type, speed, ll, lt, lw, lh)
end

function WINDOW:GetBoolImageAnimate()
	return XGetBoolImageAnimate(self.id)
end

function WINDOW:CleanImageAnimate()
    XCleanImageAnimate(self.id)
end



function WINDOW:SetImageTip(tip)
	XSetImageTip(self.id, tip)
end

function WINDOW:SetTextTip(str)
	XSetTextTip(self.id, str)
end

------Test
function WINDOW:AddCutImage(file, l, t, w, h)
		local o = {}
    setmetatable(o,self)
    self.__index = WINDOW
		file = file or ""
		l = l or 0
		t = t or 0
		local size = self.rect:GetSize()
		w = w or size.x
		h = h or size.y
    o.id = XCreateCutImageWindow( self.id, l, t, l+w, t+h, file )
    o.rect = RECT:new(l,t,w,h)
    o.parentid = self.id
	o.script = {}
	o.changeimage = function (file)
		XChangeImage(o.id, file, Wnd_Image ,0)
	end
	o.setrotation = function(angle)
		XSetWindowRotation(o.id,angle)  --设置旋转
	end 
	return o
end


--------------

function WINDOW:AddAsciiWnd(str, l, t, w, h)
		local o = {}
    setmetatable(o,self)
    self.__index = WINDOW
		l = l or 0
		t = t or 0
		local size = self.rect:GetSize()
		w = w or size.x
		h = h or size.y
    o.id = XCreateAsciiWindow( self.id, l, t, l+w, t+h, str )
    o.rect = RECT:new(l,t,w,h)
    o.parentid = self.id
	o.script = {}

	return o
end
--触发某种行为
function WINDOW:SetAsciiString(str)
	XSetAsciiString(self.id,str)
end
-- function WINDOW:ChangeImage(file, img, wnd_type, index)	
		-- local o = {}
    -- setmetatable(o,self)
    -- self.__index = WINDOW
		-- file = file or ""
		-- wnd_type = wnd_type or 0
		-- index = index or 0
    -- o.id = XChangeImage( img.id, file, wnd_type ,index)
    -- o.parentid = self.id
		-- return o
-- end

function WINDOW:AddFont( text, fontsize, align, x, y ,width,height,color)
		local o = {}
		setmetatable(o,self)
    self.__index = WINDOW
		text = text or ""
    fontsize = fontsize or 16
	--fontsize = 16
		align = align or 0
		x = x or 0
		y = y or 0
    o.id = XCreateFont( self.id, fontsize, text, align, x, y ,width,height,color,"msyh")
	--o.id = XCreateFont( self.id, fontsize, text, align, x, y ,width,height,color,"bdzy")
    o.parentid = self.id
    --o.Update = function( text, fontsize, align, x, y,color )
	--	XUpdateFont( o.id, fontsize, text, align, x, y ,color)
	--	return o
	--end
	return o
end

--移动window，为FONT设置TIP而设
function WINDOW:MoveWindow(x,y,width,height)
	return XMoveWindow(self.id,x,y,width,height)
end

function WINDOW:AddFontEx( text, fontsize, align, x, y ,width,height,color,fontname)
		local o = {}
		setmetatable(o,self)
    self.__index = WINDOW
		text = text or ""
    fontsize = fontsize or 16
	--fontsize = 16
	fontname = fontname or "msyh"
		align = align or 0
		x = x or 0
		y = y or 0
    o.id = XCreateFont( self.id, fontsize, text, align, x, y ,width,height,color,fontname)
	--o.id = XCreateFont( self.id, fontsize, text, align, x, y ,width,height,color,"bdzy")
    o.parentid = self.id
    --o.Update = function( text, fontsize, align, x, y,color )
	--	XUpdateFont( o.id, fontsize, text, align, x, y ,color)
	--	return o
	--end
	return o
end
function WINDOW:SetFontSpace(x,y)
	return XSetWndowFontSpace(self.id,x,y)
end

function WINDOW:AddChat(fontsize, align, x, y ,width,height,color)
		local o = {}
		setmetatable(o,self)
    self.__index = WINDOW
		text = text or ""
		fontsize = fontsize or 16
		align = align or 0
		x = x or 0
		y = y or 0
    o.id = XCreateChat( self.id, fontsize, align, x, y ,width,height,color,"msyh")
    o.parentid = self.id
    --o.Update = function( text, fontsize, align, x, y,color )
	--	XUpdateFont( o.id, fontsize, text, align, x, y ,color)
	--	return o
	--end
	return o
end

function WINDOW:AddMiniMap(l,t,w,h)
		local o = {}
		setmetatable(o,self)
    self.__index = WINDOW
		x = x or 0
		y = y or 0
    o.id = XCreateMiniMapWnd(self.id, l, t ,l+w,t+h)
    o.parentid = self.id

	return o
end

function WINDOW:AddEdit( path,text, onenter, ontab,fontsize,  x, y ,width,height,color,bcolor,passwd,onLBUp)
		local o = {}
		setmetatable(o,self)
    self.__index = WINDOW
		text = text or ""
		path = path or ""
		x = x or 0
		y = y or 0
		
    o.id = XCreateEdit( self.id, path, text, onenter,ontab,fontsize, x, y ,width,height,color,bcolor,passwd,onLBUp)
    o.parentid = self.id
		return o
end
-------判断光标是否在此窗口闪动
function WINDOW:IsFocus()
	return XIsFocus( self.id )
end
function WINDOW:SetFocus(focus)
	return XSetFocus( self.id, focus )
end
------判断窗口是当前窗口
function WINDOW:IsCaptureWindow()
	return XIsCaptureWindow( self.id )
end
function WINDOW:GetEdit( )
	return XGetEdit( self.id)
end
function WINDOW:SetEdit( str)
     XSetEdit( self.id,str)
end
--修改文本框文字
function WINDOW:SetFontText(text, color)
	return XSetFontText(self.id,text, color)
end
--设置输入文本框默认文字
function WINDOW:SetDefaultFontText(text, color)
	return XSetEditDefaultText(self.id,text, color)
end
--此接口----暂时毫无作用
function WINDOW:SetFontTextAlign(align)
	return XSetFontTextAlign(align)
end
function WINDOW:AddChatText(text)
	return XAddChatText(self.id,text, 0xFFFFFFFF)
end
function WINDOW:ClearChatText(text)
	return XClearChatText(self.id)
end

function WINDOW:AddBubble( text, life, speed )
		local o = {}
		setmetatable(o,self)
    self.__index = WINDOW
		text = text or ""
    life = life or 2000
		speed = speed or 2
    o.id = XCreateBubble( self.id, text, life, speed )
    o.parentid = self.id
		return o
end

function WINDOW:AddBubble_NoAligned( text , l, t, w, h, life, speed)
		local o = {}
		setmetatable(o,self)
    self.__index = WINDOW
		text = text or ""
    life = life or 2000
		speed = speed or 2
    o.id = XCreateBubble_NoAligned( self.id, text, life, speed , l, t, w, h )
    o.parentid = self.id
		return o
end

function WINDOW:AddButton( file1, file2, file3,l, t, w, h, bScale, cmd, para)
    local o = {}
    setmetatable(o,self)
    self.__index = WINDOW
    l = l or 0
    t = t or 0
	bScale = bScale or 0
    local size = self.rect:GetSize()
		w = w or size.x
		h = h or size.y
	if para ~= nil  and para ~= 0 then
		o:ToggleFlags(XF_RIGHT_PARAQUAD_WINDOW,1)
	end
    o.id = XCreateButton( self.id, l, t, l+w, t+h, file1, file2, file3, bScale, cmd, para)
    o.rect = RECT:new(l,t,w,h)
    o.parentid = self.id
		o.script = {}
	o.changeimage = function (file1)
		XChangeImage(o.id, file1, Wnd_Button ,0)
	end

	o.setTip = function(notice,w,h)
			o:ToggleBehaviour(XE_ONHOVER, 1)
			o:ToggleBehaviour(XE_ONUNHOVER, 1)
			o:ToggleEvent(XE_ONHOVER, 1)
			o:ToggleEvent(XE_ONUNHOVER, 1)	
  			o.script[XE_ONHOVER] = function()
	    			setTip(notice,0,0,w,h,o.id)
			end
  			o.script[XE_ONUNHOVER] = function()
	   			 setTip(nil)
			end
	end

	o.setTipEx = function(tipstr,item_id,item_type,item_level,item_has)
			o:ToggleBehaviour(XE_RENDER, 1)
			o:ToggleEvent(XE_RENDER, 1)
			o:ToggleBehaviour(XE_ONHOVER, 1)
			o:ToggleBehaviour(XE_ONUNHOVER, 1)
			o:ToggleEvent(XE_ONHOVER, 1)
			o:ToggleEvent(XE_ONUNHOVER, 1)	
  			o.script[XE_ONHOVER] = function()
				self.ItemStr=tipstr
				self.ItemId=item_id
				self.ItemType=item_type
				self.ItemLevel=item_level
				self.ItemHas=item_has
			end
  			o.script[XE_ONUNHOVER] = function()
				self.ItemId=nil
				self.ItemType=nil
				self.ItemLevel=nil
				self.ItemStr=nil
				self.ItemHas=nil
			end
	end
	
	o.script[XE_RENDER] = function()
		if self.ItemId == nil and self.ItemStr == nil then
			return
		end
		
		local px=XGetCursorPosX()
		local py=XGetCursorPosY()
		px = px + 32
		py = py + 32
			XShowTip(px,py,self.ItemId,self.ItemType,self.ItemLevel,self.ItemStr,self.ItemHas)
	end
		AddWindow( o )
		return o
end

function WINDOW:AddButtonEx( file1, file2, file3, file4, l, t, w, h, bScale, cmd, para)
    local o = {}
    setmetatable(o,self)
    self.__index = WINDOW
    l = l or 0
    t = t or 0
	bScale = bScale or 0
    local size = self.rect:GetSize()
		w = w or size.x
		h = h or size.y
	if para ~= nil  and para ~= 0 then
		o:ToggleFlags(XF_RIGHT_PARAQUAD_WINDOW,1)
	end
    o.id = XCreateButtonEx( self.id, l, t, l+w, t+h, file1, file2, file3, file4, bScale, cmd, para)
    o.rect = RECT:new(l,t,w,h)
    o.parentid = self.id
		o.script = {}
	o.changeimage = function (file1)
		XChangeImage(o.id, file1, Wnd_Button ,0)
	end

	o.setTip = function(notice,w,h)
			o:ToggleBehaviour(XE_ONHOVER, 1)
			o:ToggleBehaviour(XE_ONUNHOVER, 1)
			o:ToggleEvent(XE_ONHOVER, 1)
			o:ToggleEvent(XE_ONUNHOVER, 1)	
  			o.script[XE_ONHOVER] = function()
	    			setTip(notice,0,0,w,h,o.id)
			end
  			o.script[XE_ONUNHOVER] = function()
	   			 setTip(nil)
			end
	end

	o.setTipEx = function(tipstr,item_id,item_type,item_level,item_has)
			o:ToggleBehaviour(XE_RENDER, 1)
			o:ToggleEvent(XE_RENDER, 1)
			o:ToggleBehaviour(XE_ONHOVER, 1)
			o:ToggleBehaviour(XE_ONUNHOVER, 1)
			o:ToggleEvent(XE_ONHOVER, 1)
			o:ToggleEvent(XE_ONUNHOVER, 1)	
  			o.script[XE_ONHOVER] = function()
				self.ItemStr=tipstr
				self.ItemId=item_id
				self.ItemType=item_type
				self.ItemLevel=item_level
				self.ItemHas=item_has
			end
  			o.script[XE_ONUNHOVER] = function()
				self.ItemId=nil
				self.ItemType=nil
				self.ItemLevel=nil
				self.ItemStr=nil
				self.ItemHas=nil
			end
	end
	
	o.script[XE_RENDER] = function()
		if self.ItemId == nil and self.ItemStr == nil then
			return
		end
		
		local px=XGetCursorPosX()
		local py=XGetCursorPosY()
		px = px + 32
		py = py + 32
			XShowTip(px,py,self.ItemId,self.ItemType,self.ItemLevel,self.ItemStr,self.ItemHas)
	end
		AddWindow( o )
		return o
end

function WINDOW:AddCheckButton(file1, file2, file3, l, t, w, h, cmd)
    local o = {}
    setmetatable(o,self)
    self.__index = WINDOW
    l = l or 0
    t = t or 0
    local size = self.rect:GetSize()
		w = w or size.x
		h = h or size.y
    o.id = XCreateCheckButton( self.id, l, t, l+w, t+h, file1, file2, file3, cmd )
    o.rect = RECT:new(l,t,w,h)
    o.parentid = self.id
		o.script = {}
		AddWindow( o )
		return o
end
--------2张图片点击切换
function WINDOW:AddTwoButton(file1, file2, file3, l, t, w, h, cmd)
    local o = {}
    setmetatable(o,self)
    self.__index = WINDOW
    l = l or 0
    t = t or 0
    local size = self.rect:GetSize()
		w = w or size.x
		h = h or size.y
    o.id = XCreateTwoButton( self.id, l, t, l+w, t+h, file1, file2, file3, cmd )
    o.rect = RECT:new(l,t,w,h)
    o.parentid = self.id
		o.script = {}
		AddWindow( o )
		return o
end


function WINDOW:SetTouchEnabled(touchabled)  --0为不可触摸，1为可触摸
	return XSetTouchEnabled(self.id,touchabled)
end

function WINDOW:AddListViewPort(l, t, w, h, mode, count, rowcount)
    local o = {}
    setmetatable(o,self)
    self.__index = WINDOW
    l = l or 0
    t = t or 0
    local size = self.rect:GetSize()
		w = w or size.x
		h = h or size.y
		mode = mode or 0
		count = count or 1
		rowcount = rowcount or 1
    o.viewpotrid, o.id = XCreateListViewport( self.id, l, t, l+w, t+h, mode, count, rowcount )
    o.rect = RECT:new(l,t,w,h)
    o.parentid = self.id
    o.AddItem = function(item)
			XAddListViewportItem(o.viewpotrid, item.id)
			return o
		end
    o.ClearAllItems = function(canSlided)
		XClearListViewport(o.viewpotrid)
		--return o
	end
	o.SetSlidedAble = function(canSlided)
		XSetListViewportCanBeSlided(o.viewpotrid,canSlided) --0为不可滑动，1为可滑动
	end 
		AddWindow(o)
		return o
end

function WINDOW:OnEvent( event )
	if( event==nil ) then
		return 
	end
	if event == XE_RELEASE then
		if windows[self.id] ~= nil then
			windows[self.id] = nil  	
		end
		self.id = nil
	elseif self.script and self.script[event] then
		self.script[event]()
	end
end

function WINDOW:SetTimer(timer,duration,immediate,bOneShot)
	timer = timer or 0
	duration = duration or 1000
	immediate = immediate or 0
	bOneShot = bOneShot or 0
	--
	XSetTimer(self.id,timer,duration,immediate,bOneShot)
	return self
end

function WINDOW:KillTimer(timer)
	timer = timer or 0
	XKillTimer(self.id,timer)
	return self
end

function WINDOW:OnTimer( timer, interval )
	if( timer==nil ) then return end
	if self.Timer then
		self.Timer(timer, interval)
	end
end

function OnWindowEvent( id, event )
	local o = windows[id]
    if( o ~= nil ) then
		o:OnEvent( event )
	end    
end

function OnWindowTimer( id, timer, interval )
    local o = windows[id]
    if( o ~= nil ) then 
		o:OnTimer( timer, interval )
	end
end

function CreateWindow(parentid,l,t,w,h,type)
	return WINDOW:new(parentid,RECT:new(l,t,w,h),type)
	--return XCreateWindow(parentid, "child", l, t, w, h)
end


-- testing
function WINDOW:AddObserver(msg)
    --local o = {}
    --setmetatable(o,self)
    --self.__index = WINDOW
	g_NotifyCenter.AddObserver(msg , self.update)
	
	--g_NotifyCenter.AddObserver(msg , func)
	return o
end

function WINDOW:Notification(msg,para)
    --local o = {}
    --setmetatable(o,self)
    --self.__index = WINDOW
	g_NotifyCenter.Notification(msg ,para)
	--g_NotifyCenter.AddObserver(msg , func)
	return o
end

function WINDOW:RemoveObserver(msg,para)
    --local o = {}
    --setmetatable(o,self)
    --self.__index = WINDOW
	g_NotifyCenter.RemoveObserver(msg ,self.update)
	--g_NotifyCenter.AddObserver(msg , func)
	return o
end
---

--设置checkButton按钮状态0为图片0，1为图片1
function WINDOW:SetCheckButtonClicked(index)
    XSetCheckButtonClicked(self.id, index)
end
--设置按钮状态图片是否可改变，<=0 不可
function WINDOW:SetButtonCanChangeFrame(index)
    XSetButtonCanChangeFrame(self.id, index)
end
--设置按钮状态，0 = 常态， 1 = hover状态， 2 = down状态
function WINDOW:SetButtonFrame(index)
    XSetButtonFrame(self.id, index)
end

--绑定两个按钮，触发同一事件
function WINDOW:BindStateAndTriggerUP(btnwnd, func)
    func = func or nil
    btnwnd:SetTouchEnabled(0)
    self.script[XE_ONHOVER] = function()
	    btnwnd:SetButtonFrame(2)
	end
	self.script[XE_LBDOWN] = function()
	    btnwnd:SetButtonFrame(1)
	end
	self.script[XE_LBUP] = function()
		btnwnd:SetButtonFrame(2)
		func()
	end
end

--
function WINDOW:EnableEvent(eventid)
	return XEnableEvent(self.id,eventid)
end
function WINDOW:DisableEvent(eventid)
	return XDisableEvent(self.id,eventid)
end

function WINDOW:SetEnabled(enable)
	return XSetWindowEnabled(self.id, enable)
end

function WINDOW:IsEnabled()
	return XIsEnabled(self.id)
end

--字体窗口的裁剪范围
function WINDOW:SetFontScissorRect(left,right,top,buttom)
	return XSetFontScissorRect(self.id,left,right,top,buttom)
end

--
g_TipWnd = nil
g_TipBK1 = nil
g_TipString = nil
g_TipWidth = nil
g_TipHeight = nil

g_msgWnd = nil
g_msgBK0 = nil
g_msgString = nil
g_msgYes = nil
g_msgNo = nil
g_msgYesString = nil
g_msgNoString = nil

function  setMsg(Selector0,Selector1 ,notice,onYes,x,y,w,h,wnd)
		log("entry setMsg")

	if	w == 0 then 
			 w=512
			 log("w=512")
	end
	
	log("w")
	
	if	h == 0 then 
			 h=256
			 log("h=256")
	end
	
	log("h")
	
	if	g_msgWnd  == nil		then
				g_msgWnd= CreateWindow(wnd, x, y, w, h)
				g_msgWnd:SetVisible(1)
				log("create g_msgWnd")
	end

		if Selector0 == nil	then
				if	g_msgWnd ~= nil	then
							g_msgWnd:SetVisible(0)
							log("close msg")
							return	
				end
		else
				g_msgWnd:SetVisible(1)
		end
		
	log("g_msgWnd:SetPosition(x,y)")
	g_msgWnd:SetPosition(x,y)	
	
	
	if	g_msgBK0	== nil	then
				g_msgBK0 = g_msgWnd:AddImage("../Data/UI/PMG/index_108.png",0,0,w,h)
				log("g_msgBK0 = g_msgWnd:AddImage")
				g_msgBK0:SetVisible(1)
				log("g_msgBK0:SetVisible(1)")
	end
	
	if	g_msgString == nil		then
							g_msgString= g_msgWnd:AddFont(notice, 15, 0, 5, 5, 408, h, 0xffffffff)
							log("g_msgString= g_msgWnd:AddFont")
	else 
					   g_msgString.Update(notice,15,0,5,5,0xffffffff)
					   log("g_msgString:Update")
	end						
	log("out setMsg1")
	if 	Selector0 ~= nil then					-- not a tip
			log("Selector0 ~= nil")
			if	g_msgYes	== nil	then
						log("g_msgYes	== nil")
						g_msgYes=g_msgWnd:AddButton("../Data/UI/PMG/index_120.png", "../Data/UI/PMG/index_120.png", "../Data/UI/PMG/index_120.png", 416/2-128, h/2, 128, 32)
						log("g_msgYes=g_msgWnd:AddButton")
			end
			
			if	g_msgNo	== nil	then
					log("g_msgNo	== nil")
						g_msgNo=g_msgWnd:AddButton("../Data/UI/PMG/index_120.png", "../Data/UI/PMG/index_120.png", "../Data/UI/PMG/index_120.png", 416/2+96, h/2, 128, 32)
						log("g_msgNo=g_msgWnd:AddButton")
			end

			if	g_msgYesString == nil	then
					log("g_msgYesString == nil")
						g_msgYesString=g_msgWnd:AddFont(Selector0, 20, 0, 416/2-128, h/2, 100, 18, 0x809bc6)
						log("g_msgYesString=g_msgWnd:AddFont")
			else 
					  g_msgYesString.Update(Selector0, 20, 0, 416/2-128, h/2, 100, 18, 0x809bc6)
					  log("g_msgYesString:Update")
			end
			if	g_msgNoString == nil	then
						log("g_msgNoString == nil")
						g_msgNoString=g_msgWnd:AddFont(Selector1, 20, 0, 416/2+96, h/2, 100, 18, 0x809bc6)
						log("	g_msgNoString=g_msgWnd:AddFont")
			else 
					  g_msgNoString.Update(Selector1, 20, 0, 416/2+96, h/2, 100, 18, 0x809bc6)
					  log("g_msgNoString:Update")
			end
			g_msgYes:ToggleBehaviour(XE_LBDOWN, 1)
			g_msgNo:ToggleBehaviour(XE_LBDOWN, 1)
			log("g_msgYes:ToggleBehaviour(XE_LBDOWN, 1)")
			log("g_msgNo:ToggleBehaviour(XE_LBDOWN, 1)")
			g_msgYes:ToggleEvent(XE_LBDOWN, 1)
			g_msgNo:ToggleEvent(XE_LBDOWN, 1)
			log("g_msgYes:ToggleEvent(XE_LBDOWN, 1)")
			log("g_msgNo:ToggleEvent(XE_LBDOWN, 1)")
			g_msgYes.script[XE_LBDOWN] = function()
				log("# YES")
				if onYes ~= nil then 
					onYes()
				end
				g_msgWnd:SetVisible(0)
			end
			g_msgNo.script[XE_LBDOWN] = function()
				log("# NO")
				g_msgWnd:SetVisible(0)
			end
	else
		  if g_msgYes ~= nil then
		  		g_msgYes:SetVisible(0)
		  end
		  if	g_msgNo ~= nil 	then
		  		g_msgNo:SetVisible(0)
		  end
		  log("g_msgYes:SetVisible(0)")
		  log("g_msgNo:SetVisible(0)")
	end
		log("out setMsg")
end



function  setTip(notice,x,y,w,h,wnd)
	if	w == 0 then 
			 w=512
	end
	if	h == 0 then 
			 h=256
	end
	if	g_TipWnd  == nil		then
				g_TipWnd= CreateWindow(wnd, x, y, w, h)
				XWindowOrder(g_TipWnd.id,1)
				g_TipWnd:SetTouchEnabled(0)
				XSetTipWindow(g_TipWnd.id)
				g_TipWnd:SetVisible(1)
	end
	
	g_TipWidth = w
	g_TipHeight = h
	
	if notice == nil	then
				if	g_TipWnd ~= nil	then
							g_TipWnd:SetVisible(0)
							return	
				end
	else
				g_TipWnd:SetVisible(1)
	end
	g_TipWnd:SetVisible(1)
	local px=XGetCursorPosX()
	local py=XGetCursorPosY()
	px =  x+px + 32
	py =  y+py + 32
	
	rx = px + w
	if rx > windowswidth then
		px = XGetCursorPosX() - w
	end
	by = py + h
	if by > windowsheight then
		py = XGetCursorPosY() - h
	end
	
	g_TipWnd:SetPosition(px,py)
	g_TipWnd:SetWH(w,h)
	

	if	g_TipBK1 	== nil	then
				g_TipBK1 = g_TipWnd:AddImage("../Data/UI/PMG/tips.png",0,0,w,h)  --/index_120
				g_TipBK1:SetTouchEnabled(0)
				g_TipBK1:SetVisible(1)
	else
				g_TipBK1:SetWH(w,h)
	end
	if	g_TipString == nil		then
							g_TipString= g_TipWnd:AddFont(notice, 15, 0, 5, 5, w, h, 0xffffffff)
							g_TipString:SetTouchEnabled(0)
	else 
					   XUpdateFontRect(g_TipString.id,w,h)
					   g_TipString.Update(notice,15,0,5,5,0xffffffff)
					   
	end	
end
function  setTipEx(item_id,wnd)

	w=512
	h=512
		local px=XGetCursorPosX()
		local py=XGetCursorPosY()
		px = px + 32
		py = py + 32
	


	if	g_TipWnd  == nil		then
				g_TipWnd= CreateWindow(wnd, px, py, w, h)
				XWindowOrder(g_TipWnd.id,1)
				g_TipWnd:SetTouchEnabled(0)
				XSetTipWindow(g_TipWnd.id)
				g_TipWnd:SetVisible(1)
	end
	
	
	if wnd== nil	then
				if	g_TipWnd ~= nil	then
							g_TipWnd:SetVisible(0)
							log("exit setTipEx")
							return	
				end
	else


				g_TipWnd:SetVisible(1)
	end
	g_TipWnd:ToggleBehaviour(XE_RENDER, 1)
	g_TipWnd:ToggleEvent(XE_RENDER, 1)
	
	g_TipWnd.script[XE_RENDER] = function()
		
		local px=XGetCursorPosX()
		local py=XGetCursorPosY()
		px = px + 32
		py = py + 32
	
	    	XShowTip(px,py,item_id,1)
	end
end

  --自定义函数
function Ratebar(wnd,f_image,b_image,sx,sy,dw,dh,per)
	if per >= 1 then per = 1 end
	wnd:AddImage(b_image,sx,sy,dw,dh)
	local front_img = wnd:AddImage(f_image,sx,sy,dw,dh)
	wnd:SetAddImageRect(front_img.id, sx, sy, dw*per, dh, sx,sy, dw*per, dh)
	local str = (per*100).."%"
	wnd:AddFont(str,12,0,sx+dw/3,sy,0xFFFFFFFF)
	
end


-- 分割字符串，根据 “逗号” 分割 （可改为任何分割符号）
 function PartitionString(str,s)
	local Table_str = {}
	local j = 0
	local i = 0
	local num = 1
	if (str == nil or str == "") then
		return nil
	end
	while true do
		i = string.find(str,s,i+1)
		if (i == nil or i == -1) then
			break
		end
		Table_str[num] = string.sub(str,j,i-1)
		j = i + 1
		num = num + 1
	end
	return Table_str
end


function WINDOW:AddEffect( text,  x, y ,width,height)
	local o = {}
	setmetatable(o,self)
	self.__index = WINDOW
	text = text or ""
	x = x or 0
	y = y or 0
	o.id=XCreatEffect(self.id,text,x,y,width,height)
	o.parentid = self.id
	return o
end
function WINDOW:SetFontBackground()
	return XSetFontBackground(self.id,"../Data/UI/Main/FongBack.png")
end

-- 取反
function TakeReverse( Number)
	if Number==false or  Number==0 then
		return 1
	else
		return 0
	end
end

function WINDOW:AddImageMultiple(file, file1, file2, l, t, w, h)
	local o = {}
    setmetatable(o,self)
    self.__index = WINDOW
		file = file or ""
		if file=="..\\" then
			file = ""
		end
		file1 = file1 or ""
		if file1=="..\\" then
			file1 = ""
		end
		file2 = file2 or ""
		if file2=="..\\" then
			file2 = ""
		end
		l = l or 0
		t = t or 0
		local size = self.rect:GetSize()
		w = w or size.x
		h = h or size.y
    o.id = XCreateImageMultiple( self.id, l, t, l+w, t+h, file, file1, file2)
    o.rect = RECT:new(l,t,w,h)
    o.parentid = self.id
	o.script = {}
	o.changeimageMultiple = function (file, file1, file2)
		if file=="..\\" then
			file = ""
		end
		file1 = file1 or ""
		if file1=="..\\" then
			file1 = ""
		end
		file2 = file2 or ""
		if file2=="..\\" then
			file2 = ""
		end
		XChangeImage(o.id, file, Wnd_ImageMultiple ,0, file1, file2)
	end
	o.changeimage = function (file)
		if file=="..\\" then
			file = ""
		end
		XChangeImage(o.id, file, Wnd_ImageMultiple ,0,"","")
	end
	
	o.setrotation = function(angle)
		XSetWindowRotation(o.id,angle)  --设置旋转
	end 
	o.setTip = function(notice,w,h)
			o:ToggleBehaviour(XE_ONHOVER, 1)
			o:ToggleBehaviour(XE_ONUNHOVER, 1)
			o:ToggleEvent(XE_ONHOVER, 1)
			o:ToggleEvent(XE_ONUNHOVER, 1)	
  			o.script[XE_ONHOVER] = function()
	    			setTip(notice,0,0,w,h,o.id)
			end
  			o.script[XE_ONUNHOVER] = function()
	   			 setTip(nil)
			end
	end
	o.setTipEx = function(tipstr,item_id,item_type,item_level,item_has)		--表id,表等级，类型
			o:ToggleBehaviour(XE_RENDER, 1)
			o:ToggleEvent(XE_RENDER, 1)
			o:ToggleBehaviour(XE_ONHOVER, 1)
			o:ToggleBehaviour(XE_ONUNHOVER, 1)
			o:ToggleEvent(XE_ONHOVER, 1)
			o:ToggleEvent(XE_ONUNHOVER, 1)	
  			o.script[XE_ONHOVER] = function()
				log("on hover set tipex")
				self.ItemStr = tipstr
				self.ItemId=item_id
				self.ItemLevel=item_level
				self.ItemType=item_type
				self.ItemHas = item_has
				log("on hover set tipex exit")
			end
  			o.script[XE_ONUNHOVER] = function()
				log("unhover ")
				self.ItemId=nil
				self.ItemLevel=nil
				self.ItemType=nil
				self.ItemStr=nil
				self.ItemHas=nil
				log("unhover exit")
			end
	end
	
	o.script[XE_RENDER] = function()
		if self.ItemId == nil and self.ItemStr == nil then
			return
		end
		
		local px=XGetCursorPosX()
		local py=XGetCursorPosY()
		px = px + 32
		py = py + 32
			XShowTip(px,py,self.ItemId,self.ItemType,self.ItemLevel,self.ItemStr,self.ItemHas)
	end
	AddWindow( o )
	
	return o
end

-- 移除
function Vector_Remove( Vector, Index )
	if Index > #Vector then
		return Vector
	else
		for i=Index, #Vector do
			if i+1 > #Vector then
				Vector[i] = nil
				return Vector
			end
			Vector[i] = Vector[i+1]
		end
		return Vector
	end
end

-- 设置相应ID的TIP
function SetSomeOneItemTip( pImage, iId)
	XSetSomeOneItemTip( pImage.id, iId)
end