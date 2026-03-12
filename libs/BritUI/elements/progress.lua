local base = require(__BritUI.requirepath..".elements.base")
local utils = require(__BritUI.requirepath..".utilities")
-------------------------------------------------------------------------------

local progress = Class("BritUI_Progress", base)

function progress:initialize(core,data,_style)
    base.initialize(self,core,data,_style)
    self.limit = data.limit or {min=0, max=100, step=1, scroll=5}
    self.flow = data.flow or "x"
    self.value = data.value or self.limit.min
    self.func = data.func
end
function progress:Reinitialize()
    self.ew, self.eh = self.t.w-(self.marginx*2), self.t.h-(self.marginy*2)

    if self.flow == "x" then
        self.pt = {x=self.t.x+self.marginx, y=self.t.y+self.marginy, w=0, h=self.eh}
    else
        self.pt = {x=self.t.x+self.marginx, y=self.t.y+self.marginy, w=self.ew, h=0}
    end
end

function progress:Draw()
    local offset, pt
    if self.flow == "x" then
        offset = (self.value - self.limit.min) / (self.limit.max-self.limit.min) * self.ew
        pt = utils:TransformOffset(self.pt,{w=offset})
    else
        offset = (self.value - self.limit.min) / (self.limit.max-self.limit.min) * self.eh
        pt = utils:TransformOffset(self.pt,{h=offset})
    end
    self.style:DrawBox(self,pt,"progress",{"progress"},nil,self.varient)
    self.style:DrawBox(self,self.t,"base",{"base"},nil,self.varient)
end

function progress:Clamp()
    self.value = math.max(self.limit.min, math.min(self.value, self.limit.max))
    self.value = math.floor((self.value - self.limit.min) / self.limit.step + 0.5) * self.limit.step + self.limit.min
end

function progress:SetValue(value)
    self.value = value
    self:Clamp()
end
function progress:GetValue()
    return self.value
end

return progress