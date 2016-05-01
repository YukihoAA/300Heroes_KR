VEC2 = { x = 0, y = 0 }
function VEC2:new(x,y)
    local o = {}
    setmetatable(o,self)
    self.__index = self
    o.x = x or 0
    o.y = y or 0
    return o
end
function VEC2:Sub(v)
    local o = VEC2:new(0,0)
    o.x = self.x-v.x
    o.y = self.y-v.y
    return o
end

RECT = { l = 0, t = 0, r = 0, b = 0 }
function RECT:new(l,t,w,h)
    local o = {}
    setmetatable(o,self)
    self.__index = self
    l = l or 0
    t = t or 0;
    w = w or 0;
    h = h or 0;
    o.l = l
    o.t = t
    o.r = l+w
    o.b = t+h
    return o
end
function RECT:SetSize( w, h )
	self.r = self.l+w
	self.b = self.t+h
end
function RECT:SetPos( x, y )
	local w = self.r-self.l
	local h = self.b-self.t
	self.l = x
	self.t = y
	self.r = x+w
	self.b = y+h
end
function RECT:GetSize()
    local cs = VEC2:new(self.r-self.l, self.b-self.t)
    return cs
end
function RECT:CenterRect( rect )
    local csSelf = self:GetSize()
    return self:CenterSize( csSelf.x, csSelf.y )
end
function RECT:CenterSize( w, h )
    local csSelf = self:GetSize()
    local x = (csSelf.x-w)/2
    local y = (csSelf.y-h)/2
    local rect = RECT:new()
    rect.l = self.l+x
    rect.t = self.t+y
    rect.r = rect.l+w
    rect.b = rect.t+h
    return rect
end
function RECT:CopyFrom( r )
	self.l = r.l
	self.t = r.t
	self.r = r.r
	self.b = r.b
end