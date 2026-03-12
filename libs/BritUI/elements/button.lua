local base = require(__BritUI.requirepath..".elements.base")
-------------------------------------------------------------------------------

local button = Class("BritUI_Button", base)

function button:initialize(core,data,_style)
    base.initialize(self,core,data,_style)
    self.func = data.func
end

function button:Draw()
    if self.radio and self.radio.selected == self then
        self.style:DrawBox(self,self.t,"base",{"baseon","base"},nil,self.varient)
    else
        self.style:DrawBox(self,self.t,"base",{"baseoff","base"},nil,self.varient)
    end
end

function button:Release()
    if self.radio then self.core:SelectRadio(self) end
    self.core:DefaultCallback(self)
end

function button:GetValue(display)
    if display then return nil end -- No display value, just show text
    if self.radio then return self.radio.value end
end

return button