local base = require(__BritUI.requirepath..".elements.base")
-------------------------------------------------------------------------------

local tooltip = Class("BritUI_Tooltip", base)

function tooltip:initialize(core,data,_style)
    base.initialize(self,core,data,_style)
end
function tooltip:Reinitialize()
    if self.core._tooltip.ui ~= self then return end
    local _,_,w,h = self:GetBounds()
    self.t.w, self.t.h = w+(self.marginx*2), h+(self.marginy*2)
    self._text.t.w, self._text.t.h = self.t.w, self.t.h
    self:Update(0)
end

function tooltip:Update(dt)
    if self.core._tooltip.ui ~= self then return end
    self.t.x, self.t.y = love.mouse.getPosition()
    -- Ensure the tooltip doesn't go offscreen
    if self.t.x+self.t.w > ENV.width then
        self.t.x = ENV.width - self.t.w
    end
    if self.t.y+self.t.h > ENV.height then
        self.t.y = ENV.height - self.t.h
    end
    self._text.t.x, self._text.t.y = self.t.x, self.t.y
end

function tooltip:Draw()
    self.style:DrawBox(self,self.t,"tooltip",{"tooltip"},nil,self.varient)
end

function tooltip:GetBounds()
    return self.style:GetTextBounds(self,self.t,self.font,self:GetText())
end

return tooltip