local utils = require(__BritUI.requirepath..".utilities")
-------------------------------------------------------------------------------

local base = Class("BritUI_Base")

local cosmetic = {"layout","text","image","spacer","tooltip"}
local radio = {"button","checkbox","toggle"}

function base:initialize(core,data,_style)
    self._cache = {} -- Used by style, stores visual information related to image buttons
    self._data = utils:DeepCopy(data)
    self.type = data.type or "base"
    self.core = core
    self.style = _style

    self.id = data.id
    self.varient = data.varient
    
    self.scissor = {x=0, y=0, w=0, h=0}

    self.size = data.size or "auto"
    if type(data.size) == "table" then
        self.t = {x=data.size.x, y=data.size.y, w=data.size.w, h=data.size.h}
    else
        self.t = {x=0, y=0, w=ENV.width, h=ENV.height}
    end
    if data.tooltip then
        local text = data.tooltip.text or data.tooltip[1] or "no text"
        local marginx = data.tooltip.marginx or data.tooltip.margin or data.tooltip[2] or 0 
        local marginy = data.tooltip.marginy or data.tooltip.margin or data.tooltip[2] or 0
        local varient = data.tooltip.varient or 1
        self.tooltip = {text=text, marginx=marginx, marginy=marginy, varient=varient}
    end

    self.active = true
    if data.active == false then self.active = false end

    self.cosmetic = false
    if utils:TableContains(self.type, cosmetic) then
        self.cosmetic = true
    end

    self.radio = false
    if utils:TableContains(self.type, radio) and data.radio then
        self.radio = self.core:RegisterRadio(self,data.radio)
    end

    self.hover, self.click = nil, nil
    if data.joy then
        self.joy = DeepCopy(data.joy)
    end

    self._text = nil
    self.elements = {}
    if data[1] then
        for i, v in pairs(data[1]) do
            local child = self:AddChild(v, true)
            if v.type == "text" and not self._text then
                self._text = child
            end
        end
    end
    if data.text and not (self.type == "text") then
        local child = self:AddChild({type="text", text=data.text, allignx=data.allignx, alligny=data.alligny, margin=data.margin, marginx=data.marginx, marginy=data.marginy}, true)
        if not self._text then
            self._text = child
        end
    end
    if data.image and not (self.type == "image") then
        self:AddChild({type="image", image=data.image, allignx=data.allignx, alligny=data.alligny, margin=data.margin, marginx=data.marginx, marginy=data.marginy, imagefit=data.imagefit}, true)
    end
end

function base:BaseReinitialize()
    self.marginx = self.style:Get(self,{"marginx","margin"},{"marginx","margin"},"marginx")
    self.marginy = self.style:Get(self,{"marginy","margin"},{"marginy","margin"},"marginy")
    self.margin = self.style:Get(self,{"margin"},{"margin"},"margin")
    self.allignx = self.style:Get(self,{"allignx"},{"allignx"},"allignx")
    self.alligny = self.style:Get(self,{"alligny"},{"alligny"},"alligny")
    self.allign = self.style:Get(self,{"allign"},{"allign"},"allign")
    self.spacing = self.style:Get(self,{"spacing"},{"spacing"},"spacing")
    self.font = self.style:Get(self,{"font"},{"font"},"font")
    
    if self.Reinitialize then self:Reinitialize() end
end

function base:AddChild(data, dontreshape)
    local element = self.core:RegisterElement(self.core,data,self.style)
    element.parent = self
    table.insert(self.elements, element)
    if not dontreshape then
        self:Reshape()
    end
    return element
end

function base:ChangeStyle(style)
    self.style = style

    self:BaseReinitialize()
    self._cache = {}

    self:Propigate("ChangeStyle",{style})
end

function base:BaseUpdate(dt,inside)
    if not self.active then return end
    self.hover = false
    inside = (inside and self:InsideMouse())
    if (not self.cosmetic) and inside and (not self.core:HasHover()) then
        self.core:SetHover(self)
        self.hover = true
    end
    self:Propigate("BaseUpdate",{dt,inside})
    if self.Update then self:Update(dt) end
end

function base:BaseDraw()
    if self.type == "layout" and self.Draw then self:Draw() end
    if not self.scissor.disable then
        utils:ScissorPush((self.t.x+self.scissor.x)*ENV.scale, (self.t.y+self.scissor.y)*ENV.scale, (self.t.w+self.scissor.w)*ENV.scale, (self.t.h+self.scissor.h)*ENV.scale)
    end
    if self.type ~= "layout" and self.Draw then self:Draw() end
    self:Propigate("BaseDraw",{},true)
    if not self.scissor.disable then
        utils:ScissorPop()
    end
end
function base:BaseDebugDraw()
    if not self.scissor.disable then
        utils:ScissorPush((self.t.x+self.scissor.x)*ENV.scale, (self.t.y+self.scissor.y)*ENV.scale, (self.t.w+self.scissor.w)*ENV.scale, (self.t.h+self.scissor.h)*ENV.scale)
    end
    if self.type == "layout" then
        love.graphics.setColor(1,0,0,0.1)
        love.graphics.rectangle("fill", self.t.x, self.t.y, self.t.w, self.t.h)
    end
    love.graphics.setColor(1,0,0,0.2)
    love.graphics.rectangle("line", self.t.x, self.t.y, self.t.w, self.t.h)
    love.graphics.setColor(1,1,0,0.2)
    if self.marginx then
        -- Text/Image
        love.graphics.rectangle("line", self.t.x+self.marginx, self.t.y+self.marginy, self.t.w-(self.marginx*2), self.t.h-(self.marginy*2))
    elseif self.margin then
        -- Layout
        love.graphics.rectangle("line", self.t.x+self.margin, self.t.y+self.margin, self.t.w-(self.margin*2), self.t.h-(self.margin*2))
    end
    if self.GetBounds then
        local x,y,w,h = self:GetBounds()
        love.graphics.setColor(0,1,0,0.2)
        love.graphics.rectangle("line", x, y, w, h)
    end
    if (not self.cosmetic) and ((not self.parent) or self.parent:InsideMouse()) and self:InsideMouse() then
        love.graphics.setColor(1,1,1,0.2)
        local x,y,w,h = self:InsideBounds()
        love.graphics.rectangle("fill", x, y, w, h)
    end
    local t = self.type
    if t and t ~= "" then
        love.graphics.setColor(1,1,1,0.5)
        love.graphics.print(t, self.t.x+2, self.t.y+2, 0, 1/ENV.scale, 1/ENV.scale)
    end
    self:Propigate("BaseDebugDraw",{},true)
    if not self.scissor.disable then
        utils:ScissorPop()
    end
end

function base:BaseClick(mx,my,mb)
    if mb ~= 1 then return end
    if not self.active then return end
    if self.hover then
        self.click = true
        if (not self.core:HasFocus()) and (not self.cosmetic) then
            self.core:SetFocus(self)
            self.focus = true
        end
        if self.Click then self:Click() end
    end
    self:Propigate("BaseClick",{mx,my,mb})
end
function base:BaseRelease(mx,my,mb)
    if mb ~= 1 then return end
    if not self.active then return end
    if self.hover and self.click and self.Release then
        self:Release()
        playsound(Mergesounds[math.random(#Mergesounds)])
    end
    self.click = false
    self:Propigate("BaseRelease",{mx,my,mb})
end
function base:BaseScroll(sx,sy)
    if not self.active then return end
    self:Propigate("BaseScroll",{sx,sy})
    if ((self.type == "layout" and self:InsideMouse()) or self.hover) and (not self.core.scroll) and self.Scroll then
        self:Scroll(sx,sy)
    end
end

function base:BaseInput(k)
    if not self.active then return end
    if self.focus and self.Input then
        self:Input(k)
    end
    self:Propigate("BaseInput",{k})
end
function base:BaseInputText(t)
    if not self.active then return end
    if self.focus and self.Input then
        self:InputText(t)
    end
    self:Propigate("BaseInputText",{t})
end

function base:Resize(args)
    if args.x then self.t.x = args.x end
    if args.y then self.t.y = args.y end
    if args.w then self.t.w = args.w end
    if args.h then self.t.h = args.h end
    self:Reshape()
end
function base:Reshape()
    self:BaseReinitialize()
    
    -- Reset Cache so updated graphics get generated
    self._cache = {}

    -- Update Child positions
    for _, v in ipairs(self.elements) do
        v.t.x, v.t.y, v.t.w, v.t.h = self.t.x, self.t.y, self.t.w, self.t.h
    end

    self:Propigate("Reshape",{})
end

-------------------------------------------------------------------------------

function base:Propigate(name,args,onlyvisible)
    for _, v in pairs(self.elements) do
        if ((not onlyvisible) or self:InsideElement(v)) and v[name] then
            v[name](v,unpack(args))
        end
    end
end

function base:InsideBounds()
    return self.t.x, self.t.y, self.t.w, self.t.h
end
function base:InsideMouse(mx,my)
    if not mx then mx, my = love.mouse.getPosition() end
    local x,y,w,h = self:InsideBounds()
    return utils:AABB(mx, my, 1, 1, x, y, w, h)
end
function base:InsideElement(element)
    local x,y,w,h = self:InsideBounds()
    return utils:AABB(element.t.x, element.t.y, element.t.w, element.t.h, x, y, w, h)
end

-------------------------------------------------------------------------------

-- Useful to have, good enough a reason to add
function base:GetText()
    if self._text then
        return self._text.text
    end
end
function base:SetText(txt)
    if self._text then
        local oldtext = self._text.text
        self._text.text = txt
        if self._text.text ~= oldtext then self._text:BaseReinitialize() end
    end
end

function base:Find(mode,conditions)
    local results = {}

    -- Check self
    local yes = (mode == "strict") and true or false
    for _, cond in ipairs(conditions) do
        if self[cond[1]] == cond[2] then
            yes = true
        elseif mode == "strict" then
            yes = false; break
        end
    end
    if yes then table.insert(results, self) end

    -- Check children
    for _, v in pairs(self.elements) do
        local subresults = v:Find(mode,conditions)
        for _, sv in pairs(subresults) do
            table.insert(results, sv)
        end
    end

    return results
end

return base