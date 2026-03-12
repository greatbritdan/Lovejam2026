local base = require(__BritUI.requirepath..".elements.base")
local utils = require(__BritUI.requirepath..".utilities")
-------------------------------------------------------------------------------

local text = Class("BritUI_Text", base)

function text:initialize(core,data,_style)
    base.initialize(self,core,data,_style)
    self.text = data.text or ""
    self.gapwidth = data.gapwidth or 16
end
function text:Reinitialize()
    self.originalallignx = self.allignx
    self.scissor = {x=self.marginx, y=self.marginy, w=-(self.marginx*2), h=-(self.marginy*2)}
    local _,_,w,_ = self:GetBounds()
    self.textscroll = utils:SetAutoscroll(w,self.t.w-(self.marginx*2))
end

function text:Update(dt)
    if self.parent and self.parent.GetValue and self.parent:GetValue(true) then
        local oldtext = self.text
        if self.parent.type == "input" and (not self.parent.focus) and self.parent:GetValue(true) == "" then
            self.text = self.parent.placeholdervalue
        else
            self.text = self.parent:GetValue(true)
        end
        if self.text ~= oldtext then self:BaseReinitialize() end
    end
    utils:UpdateAutoscroll(self.textscroll, dt)
end

function text:Draw()
    if self.parent.type == "input" then
        self.allignx = self.parent.focus and -1 or self.allignx -- Hacky fix, but it works
        local pos = self.textscroll.pos
        if self.parent.focus then
            local _,_,w,_ = self:GetBounds()
            pos = math.max(0, w-((self.t.w-(self.marginx*2))-self.gapwidth))
        end

        local t = utils:TransformOffset(self.t,{x=-pos})
        if (not self.parent.focus) and self.parent:GetValue() == "" then
            self.style:DrawText(self,t,"text",{"placeholder","text"},nil,self.varient,self.text)
        else
            if self.parent.validation and (self.parent.valid == false) then
                self.style:DrawText(self,t,"text",{"texterror","text"},nil,self.varient,self.text)
            else
                self.style:DrawText(self,t,"text",{"text"},nil,self.varient,self.text)
            end
        end
        self.allignx = self.originalallignx
    else
        local t = utils:TransformOffset(self.t,{x=-self.textscroll.pos})
        -- I really hate this, TODO: Find a better way to do this
        if self.parent and self.parent.type == "button" and self.parent.radio and self.parent.radio.selected == self.parent then
            self.style:DrawText(self,t,"text",{"texton","text"},nil,self.varient,self.text)
        else
            self.style:DrawText(self,t,"text",{"text"},nil,self.varient,self.text)
        end
    end
end

function text:GetBounds()
    return self.style:GetTextBounds(self,self.t,self.font,self.text)
end

-------------------------------------------------------------------------------

function text:GetText()
    return self.text
end
function text:SetText(txt)
    local oldtext = self.text
    self.text = txt
    if self.text ~= oldtext then self:BaseReinitialize() end
end

return text