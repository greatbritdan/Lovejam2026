local base = require(__BritUI.requirepath..".elements.base")
-------------------------------------------------------------------------------

local cycle = Class("BritUI_Cycle", base)

function cycle:initialize(core,data,_style)
    base.initialize(self,core,data,_style)
    self.values = data.values or {"no values"}
    self.displayvalues = data.displayvalues
    self.value = data.value or 1
    self.func = data.func
end

function cycle:Draw()
    self.style:DrawBox(self,self.t,"base",{"base"},nil,self.varient)
end

function cycle:Release()
    self:Cycle(1)
    self.core:DefaultCallback(self)
end

function cycle:Cycle(dir)
    self.value = self.value + dir
    if self.value > #self.values then
        self.value = 1
    elseif self.value < 1 then
        self.value = #self.values
    end
end

function cycle:GetValue(display)
    if display and self.displayvalues then
        return self.displayvalues[self.value]
    end
    return self.values[self.value]
end

return cycle