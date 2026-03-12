local base = require(__BritUI.requirepath..".elements.base")
local utils = require(__BritUI.requirepath..".utilities")
-------------------------------------------------------------------------------

local layout = Class("BritUI_Layout", base)

function layout:initialize(core,data,_style)
    base.initialize(self,core,data,_style)
    self.flow = data.flow or "y"

    self.scrollpos = 0
    self.maxscroll = false
end
function layout:Reinitialize()
    self.scissor = {x=self.margin, y=self.margin, w=-(self.margin*2), h=-(self.margin*2)}
end

function layout:Reshape(justscroll)
    self:BaseReinitialize()

    -- If we're only scrolling, there is no need to run the whole thing as nothing will be resized.
    if justscroll then
        for _, v in ipairs(self.elements) do
            if self.flow == "y" then
                v.t.y = v.t.rawy + self.scrollpos
            elseif self.flow == "x" then
                v.t.x = v.t.rawx + self.scrollpos
            end
        end
        self:Propigate("Reshape",{})
        return
    end
    
    -- Reset Cache so updated graphics get generated
    self._cache = {}

    -- I tried my best to explain what the fuck this is doing, forgive me father.
    -- local transform, same as transform but with margin included
    local t = {x=self.t.x+self.margin, y=self.t.y+self.margin, w=self.t.w-(self.margin*2), h=self.t.h-(self.margin*2)}

    -- Set remaining size to the full length + spacing to account for 1 element not needing the extra spacing
    -- Set total size to 0 - spacing to account for 1 element not needing the extra spacing
    local remainingsize = self.flow == "y" and (t.h + self.spacing) or (t.w + self.spacing)
    local fixedlen = self.flow == "y" and t.w or t.h
    local varlen = self.flow == "y" and t.h or t.w
    local totalsize = -self.spacing

    -- Auto is a fucking bitch, this value stores the number of elements labeled with "auto"
    local negativeautosize = 16
    local autocount = 0

    -- Loop through each element and set it's width to the layouts width, and the height to its determented height
    -- supports a plain number, percentage, square to make it... square and auto to fill in remaining space
    -- Update remainingsize by subtracting its size (& spacing), and update totalsize but adding its size (& spacing)
    for _, v in ipairs(self.elements) do
        local skipsizechange = false
        local size = 0
        if v.size and type(v.size) == "number" then
            size = v.size
        elseif v.size and type(v.size) == "string" and v.size:sub(-1) == "%" then
            size = varlen * (tonumber(v.size:sub(1, -2))/100)
        elseif v.size and v.size == "square" then
            size = fixedlen
        elseif v.size and v.size == "auto" then
            size = 0; autocount = autocount + 1; skipsizechange = true
        end
        v.t.w = self.flow == "y" and t.w or size
        v.t.h = self.flow == "y" and size or t.h
        if not skipsizechange then
            remainingsize = remainingsize - size - self.spacing
            totalsize = totalsize + size + self.spacing
        end
    end

    -- Autosize is the remaining space left for elements to fit into, it splits them evenly between all the remaining auto elements
    -- Loop through each element and change the size of ones labeled with auto.
    local autosize = (remainingsize-(self.spacing*(autocount-1))-self.spacing) / autocount
    for _,v in ipairs(self.elements) do
        if v.size and v.size == "auto" then
            if autosize < 0 then autosize = negativeautosize-self.spacing end
            if self.flow == "x" then
                v.t.w = autosize
            elseif self.flow == "y" then
                v.t.h = autosize
            end
            remainingsize = remainingsize - autosize - self.spacing
            totalsize = totalsize + autosize + self.spacing
        end
    end

    -- If allignment is specified, change start position to the center if its allign is 0 and right/bottom if its allign is 1
    -- -1 refers to left/top allign and thus doesnt need ajusting.
    -- If total size of UI is bigger than the size of the layout, allow scrolling by setting a maxscroll
    -- Scrollable layouts dont need allignment
    if remainingsize < 0 then
        self.maxscroll = remainingsize
        self.scrollpos = math.min(math.max(self.maxscroll, self.scrollpos), 0)
    else
        if self.maxscroll then
            self.maxscroll = false
            self.scrollpos = 0
        end
        if self.flow == "y" then
            if self.allign == 0 then
                t.y = t.y + (t.h-totalsize)/2
            elseif self.allign == 1 then
                t.y = t.y + t.h-totalsize
            end
        elseif self.flow == "x" then
            if self.allign == 0 then
                t.x = t.x + (t.w-totalsize)/2
            elseif self.allign == 1 then
                t.x = t.x + t.w-totalsize
            end
        end
    end

    -- After all widths and heights have been set, loop through again and set its x and y
    -- If the layout has been scrolled, also adjust its position based on scroll position
    -- Iterate local position to shift down/across after each element, including spacing
    -- Then reshape all children as layouts inside will also need adjusting
    for _, v in ipairs(self.elements) do
        v.t.rawx, v.t.rawy = t.x, t.y
        if self.flow == "y" then
            v.t.x, v.t.y = t.x, (t.y + self.scrollpos)
            t.y = t.y + v.t.h + self.spacing
        elseif self.flow == "x" then
            v.t.x, v.t.y = (t.x + self.scrollpos), t.y
            t.x = t.x + v.t.w + self.spacing
        end
    end

    self:Propigate("Reshape",{})
end

function layout:Draw()
    self.style:DrawBox(self,self.t,"base",{"backbase"},nil,self.varient)
end

function layout:Scroll(sx,sy)
    -- Only scroll if none of the children have scrolled
    if self.maxscroll then
        self.core.scroll = self
        self.scrollpos = math.min(math.max(self.maxscroll, self.scrollpos + (sy*5)), 0)
        self:Reshape(true)
    end
end

function layout:InsideBounds()
    return self.t.x+self.margin, self.t.y+self.margin, self.t.w-(self.margin*2), self.t.h-(self.margin*2)
end

return layout