local base = require(__BritUI.requirepath..".elements.base")
-------------------------------------------------------------------------------

local input = Class("BritUI_Input", base)

function input:initialize(core,data,_style)
    base.initialize(self,core,data,_style)
    self.value = data.value or ""
    self.func = data.func

    self.placeholdervalue = data.placeholdervalue or "enter text..."
    self.validation = data.validation
    self.limit = data.limit or {}
end

function input:Draw()
    self.style:DrawBox(self,self.t,"base",{"base"},nil,self.varient)
end

function input:Focus()
    self.oldvalue = self.value
end
function input:Unfocus()
    self.focus = false
    if self.validation and self.valid == false then
        self.value = self.oldvalue
        self:CheckValidation()
        return
    else
        self.core:DefaultCallback(self)
    end
end

function input:Input(k,t)
    local oldvalue = self.value

    if k == "return" then
        self.core:SetFocus()
    elseif k == "backspace" then
        self.value = self.value:sub(1,#self.value-1)
    elseif t then
        if (not self.limit.chars) or self.limit.chars:find(t,1,true) then
            self.value = self.value .. t
        else
            return
        end
    end

    if self.limit.length and #self.value > self.limit.length then
        self.value = oldvalue
    else
        self:CheckValidation()
    end
end
function input:InputText(t)
    self:Input(nil,t)
end

function input:GetValue(display)
    if display and self.limit.password then
        local char = "*"
        if type(self.limit.password) == "string" then char = self.limit.password:sub(1,1) end
        return char:rep(#self.value)
    end
    return self.value
end
function input:CheckValidation()
    if self.validation then
        self.valid = false
        if self.validation(self.value,self) then self.valid = true end
    end
end

return input