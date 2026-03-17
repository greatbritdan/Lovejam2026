local base = require(__BritUI.requirepath..".elements.base")
local utils = require(__BritUI.requirepath..".utilities")
-------------------------------------------------------------------------------

local slider = Class("BritUI_Slider", base)

function slider:initialize(core,data,_style)
    base.initialize(self,core,data,_style)
    self.limit = data.limit or {min=0, max=100, step=1, scroll=5}
    self.square = data.square
    self.flow = data.flow or "x"
    self.oldfill = data.fill or 0.5
    self.value = data.value or self.limit.min
    self.func = data.func
end
function slider:Reinitialize()
    self.ew, self.eh = self.t.w-(self.marginx*2), self.t.h-(self.marginy*2)

    local fill = self.oldfill or 0.25
    if self.flow == "x" then
        self.fill = (fill > 1) and math.min(fill,self.ew) or self.ew*fill
        if self.square then self.fill = self.eh end
    else
        self.fill = (fill > 1) and math.min(fill,self.eh) or self.eh*fill
        if self.square then self.fill = self.ew end
    end

    if self.flow == "x" then
        self.bt = {x=self.t.x+self.marginx, y=self.t.y+self.marginy, w=self.fill, h=self.eh}
        self.pt = {x=self.t.x+self.marginx, y=self.t.y+self.marginy, w=(self.fill/2), h=self.eh}
    else
        self.bt = {x=self.t.x+self.marginx, y=self.t.y+self.marginy, w=self.ew, h=self.fill}
        self.pt = {x=self.t.x+self.marginx, y=self.t.y+self.marginy, w=self.ew, h=(self.fill/2)}
    end
end

function slider:Update(dt)
    if self.click then
        local mx,my = love.mouse.getPosition()
        local oldvalue = self.value
        if self.flow == "x" then
            local offset = mx-self.t.x -self.marginx-(self.fill/2)
            self.value = self.limit.min + (offset / (self.ew-self.fill)) * (self.limit.max-self.limit.min)
        else
            local offset = my-self.t.y -self.marginy-(self.fill/2)
            self.value = self.limit.min + (offset / (self.eh-self.fill)) * (self.limit.max-self.limit.min)
        end
        if oldvalue ~= self.value then
            self:Clamp()
            self.core:DefaultCallback(self)
        end
    end
end

function slider:Draw()
    local offset, bt, pt
    if self.flow == "x" then
        offset = (self.value - self.limit.min) / (self.limit.max-self.limit.min) * (self.ew-self.fill)
        bt = utils:TransformOffset(self.bt,{x=offset})
        pt = utils:TransformOffset(self.pt,{w=offset})
    else
        offset = (self.value - self.limit.min) / (self.limit.max-self.limit.min) * (self.eh-self.fill)
        bt = utils:TransformOffset(self.bt,{y=offset})
        pt = utils:TransformOffset(self.pt,{h=offset})
    end
    self.style:DrawBox(self,pt,"progress",{"progress"},nil,self.varient)
    self.style:DrawBox(self,self.t,"base",{"base"},nil,self.varient)
    if self.fill > 0 then
        self.style:DrawBox(self,bt,"bulb",{"bulb","base"},nil,self.varient)
    end
end

function slider:Scroll(sx,sy)
    self.core.scroll = self
    self.value = self.value - ((sx+sy)*self.limit.scroll)
    self:Clamp()
    self.core:DefaultCallback(self)
end

function slider:Release()
    -- for sound!
end

function slider:Clamp()
    self.value = math.max(self.limit.min, math.min(self.value, self.limit.max))
    self.value = math.floor((self.value - self.limit.min) / self.limit.step + 0.5) * self.limit.step + self.limit.min
end

function slider:GetValue()
    return self.value
end

return slider