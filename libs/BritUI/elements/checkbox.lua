local base = require(__BritUI.requirepath..".elements.base")
-------------------------------------------------------------------------------

local checkbox = Class("BritUI_Checkbox", base)

function checkbox:initialize(core,data,_style)
    base.initialize(self,core,data,_style)
    self.value = data.value or false
    self.checktext = data.checktext or "x"
    self.func = data.func
end

function checkbox:Draw()
    if self.value or (self.radio and self.radio.selected == self) then
        self.style:DrawBox(self,self.t,"base",{"baseon","base"},nil,self.varient)
    else
        self.style:DrawBox(self,self.t,"base",{"baseoff","base"},nil,self.varient)
    end
end

function checkbox:Release()
    if self.radio then
        self.core:SelectRadio(self)
    else
        self.value = not self.value
    end
    self.core:DefaultCallback(self)
end

function checkbox:GetValue(display)
    if display then return (self.value or (self.radio and self.radio.selected == self)) and self.checktext or "" end
    if self.radio then return self.radio.value end
    return self.value
end

return checkbox