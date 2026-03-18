local style = require(__BritUI.requirepath..".style")
local utils = require(__BritUI.requirepath..".utilities")

local base = require(__BritUI.requirepath..".elements.base")
local layout = require(__BritUI.requirepath..".elements.layout")
local button = require(__BritUI.requirepath..".elements.button")
local text = require(__BritUI.requirepath..".elements.text")
local image = require(__BritUI.requirepath..".elements.image")
local cycle = require(__BritUI.requirepath..".elements.cycle")
local toggle = require(__BritUI.requirepath..".elements.toggle")
local slider = require(__BritUI.requirepath..".elements.slider")
local input = require(__BritUI.requirepath..".elements.input")
local spacer = require(__BritUI.requirepath..".elements.spacer")
local checkbox = require(__BritUI.requirepath..".elements.checkbox")
local progress = require(__BritUI.requirepath..".elements.progress")
local tooltip = require(__BritUI.requirepath..".elements.tooltip")
-------------------------------------------------------------------------------

local core = {
    hover=nil, focus=nil, scroll=nil, _tooltip={ui=nil, element=nil},
    loaded={}, radios={}, settings={useunstablefeatures=false}, joytarget=nil
}

function core:RegisterUI(data,_style)
    if type(data) == "string" then
        data = love.filesystem.load(data)()
    end
    local result = self:RegisterElement(self,data,_style)
    result:Reshape()
    return result
end

function core:RegisterStyle(data)
    if type(data) == "string" then
        data = love.filesystem.load(data)()
    end
    local result = style:new(self,data)
    return result
end

function core:base(parent,data,_style) return base:new(parent,data,_style) end
function core:layout(parent,data,_style) return layout:new(parent,data,_style) end
function core:button(parent,data,_style) return button:new(parent,data,_style) end
function core:text(parent,data,_style) return text:new(parent,data,_style) end
function core:image(parent,data,_style) return image:new(parent,data,_style) end
function core:cycle(parent,data,_style) return cycle:new(parent,data,_style) end
function core:toggle(parent,data,_style) return toggle:new(parent,data,_style) end
function core:slider(parent,data,_style) return slider:new(parent,data,_style) end
function core:input(parent,data,_style) return input:new(parent,data,_style) end
function core:spacer(parent,data,_style) return spacer:new(parent,data,_style) end
function core:checkbox(parent,data,_style) return checkbox:new(parent,data,_style) end
function core:progress(parent,data,_style) return progress:new(parent,data,_style) end
function core:dropdown(parent,data,_style) return cycle:new(parent,data,_style) end
function core:tooltip(parent,data,_style) return tooltip:new(parent,data,_style) end

function core:RegisterElement(parent,data,_style)
    local element = self[data.type](self,parent,data,_style)
    return element
end

function core:UpdateSetting(setting,value)
    if self.settings[setting] ~= nil then
        self.settings[setting] = value
    end
    return self.settings[setting] -- Chaining
end

-------------------------------------------------------------------------------

function core:Load(element)
    table.insert(self.loaded, element)
end
function core:Unload(element)
    for i,v in pairs(self.loaded) do
        if v == element then
            table.remove(self.loaded, i)
            return
        end
    end
end

function core:Update(dt)
    self:SetHover()

    if IN._activeDevice == "joy" and self.joytarget then
        if self.joytarget.JoyClick then
            self.joytarget:JoyClick()
        end
        print(self.joytarget.id)
    end
    
    self:Propigate("BaseUpdate",{dt,true})
    if ((not self.hover) or self.hover ~= self._tooltip.element) and self._tooltip.element then
        self:CreateTooltip()
    end
    if self.hover and self.hover.tooltip and (not self._tooltip.element) then
        self:CreateTooltip(self.hover)
    end
end

function core:Draw(debug)
    -- Retain old color and font as we'll be messing with it
    local oldfont, oldcolor = love.graphics.getFont(), {love.graphics.getColor()}
    local oldlinesize = love.graphics.getLineWidth()
    self:Propigate("BaseDraw",{})
    if debug then
        love.graphics.setLineWidth(1)
        self:Propigate("BaseDebugDraw",{})
    end
    love.graphics.setFont(oldfont)
    love.graphics.setColor(oldcolor)
    love.graphics.setLineWidth(oldlinesize)
end

function core:Click(mx,my,mb)
    self:SetFocus()
    self:Propigate("BaseClick",{mx,my,mb})
end
function core:Release(mx,my,mb)
    self:Propigate("BaseRelease",{mx,my,mb})
end
function core:Scroll(sx,sy)
    self.scroll = nil
    self:Propigate("BaseScroll",{sx,sy})
end

function core:Input(k)
    self:Propigate("BaseInput",{k})
end
function core:InputText(t)
    self:Propigate("BaseInputText",{t})
end

function core:Resize(args)
    self:Propigate("Resize",{args})
end

-------------------------------------------------------------------------------

function core:FindSingle(mode,conditions)
    local results = self:Find(mode,conditions)
    if #results >= 1 then
        return results[1]
    end
end
function core:Find(mode,conditions)
    -- mode == "strict" means all conditions must be met, "loose" means any condition can be met
    if mode ~= "strict" and mode ~= "loose" then
        error("Invalid mode for Find, must be 'strict' or 'loose'")
        return {}
    end
    local results = {}
    for _, v in pairs(self.loaded) do
        local subresults = v:Find(mode,conditions)
        for _, element in pairs(subresults) do
            table.insert(results, element)
        end
    end
    return results
end

-------------------------------------------------------------------------------

function core:Propigate(name,args)
    for _, v in pairs(self.loaded) do
        v[name](v,unpack(args))
    end
    if self._tooltip.ui then
        self._tooltip.ui[name](self._tooltip.ui,unpack(args))
    end
end

function core:HasHover()
    return self.hover
end
function core:SetHover(element)
    if not element then
        self.hover = nil
        return
    end
    self.hover = element
end

function core:HasFocus()
    return self.focus
end
function core:SetFocus(element)
    if not element then
        if self.focus then
            if self.focus.Unfocus then self.focus:Unfocus() end
        end
        self.focus = nil
        return
    end
    if element.Focus then element:Focus() end
    self.focus = element
end

function core:CreateTooltip(element)
    if element then
        self._tooltip.ui = self:RegisterElement(self, {type="tooltip",
            text=element.tooltip.text, marginx=element.tooltip.marginx,
            marginy=element.tooltip.marginy, varient=element.tooltip.varient
        }, element.style)
        self._tooltip.ui:Reshape()
        self._tooltip.element = element
    else
        self._tooltip.ui = nil
        self._tooltip.element = nil
    end
end

function core:RegisterRadio(element,radio)
    local id,default,value = radio.id, radio.default, radio.value
    if not self.radios[id] then self.radios[id] = {id=id,values={},selected=nil,value=nil} end
    self.radios[id].values[element] = value
    if default then
        self.radios[id].selected = element
        self.radios[id].value = value
    end
    return self.radios[id]
end
function core:SelectRadio(element)
    local id = element.radio.id
    if not self.radios[id] then return end
    self.radios[id].selected = element
    self.radios[id].value = element.radio.values[element]
end

function core:DefaultCallback(e)
    if self.Callback then self.Callback(e) end
    if e.func then e.func(e) end
end

return core