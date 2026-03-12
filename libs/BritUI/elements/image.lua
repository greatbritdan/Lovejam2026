local base = require(__BritUI.requirepath..".elements.base")
-------------------------------------------------------------------------------

local image = Class("BritUI_Image", base)

function image:initialize(core,data,_style)
    base.initialize(self,core,data,_style)
    if type(data.image) == "string" and love.filesystem.getInfo(data.image) then
        self.image = love.graphics.newImage(data.image)
    elseif type(data.image) == "table" then
        self.image, self.quad = unpack(data.image)
    else
        self.image = data.image
    end
    self.imagefit = data.imagefit or "none" -- none, contain, cover, fill

    self.scissor = {x=self.marginx, y=self.marginy, w=-(self.marginx*2), h=-(self.marginy*2)}
end

function image:Draw()
    self.style:DrawImage(self,self.t,"image",{"image"},nil,self.varient,self.image,self.quad,self.imagefit)
end

function image:GetBounds()
    local x,y,w,h = self.style:GetImageBounds(self,self.t,self.image,self.quad)
    local sx,sy = 1,1
    x,y,sx,sy = self.style:GetImageBoundsFit(x,y,w,h,self.t,self.imagefit)
    w = w*sx
    h = h*sy
    return x,y,w,h
end

return image