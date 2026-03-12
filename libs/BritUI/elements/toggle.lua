local base = require(__BritUI.requirepath..".elements.base")
-------------------------------------------------------------------------------

local toggle = Class("BritUI_Toggle", base)

function toggle:initialize(core,data,_style)
    base.initialize(self,core,data,_style)
    self.value = data.value or false
    self.func = data.func

    self.square = data.square
    self.flow = data.flow or "x"
end
function toggle:Reinitialize()
    self.ew, self.eh = self.t.w-(self.marginx*2), self.t.h-(self.marginy*2)

    local ox, oy, w, h = 0, 0, self.ew, self.eh
    if self.flow == "x" then
        w = w/2; ox = w
        if self.square then w = h; ox = self.ew-w end
    else
        h = h/2; oy = h
        if self.square then h = w; oy = self.eh-h end
    end
    self.btoff = {x=self.t.x+self.marginx, y=self.t.y+self.marginy, w=w, h=h}
    self.bton = {x=(self.t.x+self.marginx)+ox, y=(self.t.y+self.marginy)+oy, w=w, h=h}
end

function toggle:Draw()
    if self.value or (self.radio and self.radio.selected == self) then
        self.style:DrawBox(self,self.t,"base",{"baseon","base"},nil,self.varient)
        self.style:DrawBox(self,self.bton,"bulb",{"bulbon","bulb","baseon","base"},nil,self.varient)
    else
        self.style:DrawBox(self,self.t,"base",{"baseoff","base"},nil,self.varient)
        self.style:DrawBox(self,self.btoff,"bulb",{"bulboff","bulb","baseoff","base"},nil,self.varient)
    end
end

function toggle:Release()
    if self.radio then
        self.core:SelectRadio(self)
    else
        self.value = not self.value
    end
    self.core:DefaultCallback(self)
end

function toggle:GetValue()
    if self.radio then return self.radio.value end
    return self.value
end

return toggle