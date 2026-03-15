local utils = require(__BritUI.requirepath..".utilities")
-------------------------------------------------------------------------------

local style = Class("BritUI_Style")

function style:initialize(core,data)
    self.core = core

    self.categories = utils:DeepCopy(data)
    for i, v in pairs(self.categories) do
        if v.styles then
            for j, w in pairs(v.styles) do
                local gen = self:GenerateStyle(w)
                self.categories[i].styles[j] = utils:DeepCopy(gen)
            end
        end
    end
end

local defaults = {
    margin=0, marginx=0, marginy=0, allign=0, allignx=0, alligny=0, spacing=0,
    font=function() return love.graphics.newFont(12) end,
    styles = {
        base = {type="color", color={{{0,0,0},{0,0,0},{0,0,0},{0,0,0,.5}}}, cornersize=0},
        basebase = {type="color", color={{{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}}}, cornersize=0},
        text = {type="color", color={{{1,1,1},{1,1,1},{1,1,1},{1,1,1,.5}}}, cornersize=0},
        image = {type="color", color={{{1,1,1},{1,1,1},{1,1,1},{1,1,1,.5}}}, cornersize=0},
        tooltip = {type="color", color={{{0,0,0,.5},{0,0,0,.5},{0,0,0,.5},{0,0,0,.25}}}, cornersize=0},
    }
}
function style:Get(element,elementkeys,stylekeys,defaultkey,style)
    -- First check element for overrides
    if elementkeys then
        for _,v  in pairs(elementkeys) do
            if element[v] then return element[v], v end
            if element._data[v] then return element._data[v], v end
        end
    end

    -- Then check style defaults
    if stylekeys then
        -- Get type or parent type if cosmetic
        local  _type = (element.parent and element.cosmetic) and element.parent.type or element.type

        -- Firstly check type category if applicable
        local category = self.categories[_type]
        if category then
            for _,v  in pairs(stylekeys) do
                if style then
                    if category.styles and category.styles[v] then return category.styles[v], v end
                else
                    if category[v] then return category[v], v end
                end
            end
        end
        
        -- Otherwise check defaults
        local defaultcategory = self.categories.default
        if defaultcategory then
            for _,v  in pairs(stylekeys) do
                if style then
                    if defaultcategory.styles and defaultcategory.styles[v] then return defaultcategory.styles[v], v end
                else
                    if defaultcategory[v] then return defaultcategory[v], v end
                end
            end
        end
    end

    -- If no luck use default if applicable
    if defaultkey then

        if style and defaults.styles[defaultkey] then
            if type(defaults.styles[defaultkey]) == "function" then
                return defaults.styles[defaultkey](), defaultkey
            else
                return defaults.styles[defaultkey], defaultkey
            end
        elseif (not style) and defaults[defaultkey] then
            if type(defaults[defaultkey]) == "function" then
                return defaults[defaultkey](), defaultkey
            else
                return defaults[defaultkey], defaultkey
            end
        end
    end

    -- No luck? Return nil so it can be filtered out
    return nil, nil
end

function style:GetAllign(pos,size,fullsize,allign,margin)
    if (size > fullsize-(margin*2)) or allign == -1 then
        return pos + margin
    elseif allign == 1 then
        return pos + fullsize-margin-size
    elseif allign == 0 then
        return pos + ((fullsize/2) - (size/2))
    end
end

function style:GetState(element)
    if element.parent and element.cosmetic then
        return self:GetState(element.parent)
    end
    if not element.active then
        return 4
    elseif element.click then
        return 3
    elseif element.hover then
        return 2
    else
        return 1
    end
end

function style:GenerateStyle(data)
    if data.image then
        local image = love.graphics.newImage(data.image)
        local iw,ih = image:getWidth(), image:getHeight()
        local cs = data.cornersize or ((ih-4)/8) -- corndersize
        local qs = 1+cs*2 -- quadsize
        local vqs, hqs = ih/qs, iw/qs -- vertical/horizontal quad size

        local _createquadgroup = function(sx,sy)
            return {
                tl = love.graphics.newQuad(sx,      sy,      cs, cs, iw, ih),
                tm = love.graphics.newQuad(sx+cs,   sy,      1,  cs, iw, ih),
                tr = love.graphics.newQuad(sx+cs+1, sy,      cs, cs, iw, ih),
                cl = love.graphics.newQuad(sx,      sy+cs,   cs, 1,  iw, ih),
                cm = love.graphics.newQuad(sx+cs,   sy+cs,   1,  1,  iw, ih),
                cr = love.graphics.newQuad(sx+cs+1, sy+cs,   cs, 1,  iw, ih),
                bl = love.graphics.newQuad(sx,      sy+cs+1, cs, cs, iw, ih),
                bm = love.graphics.newQuad(sx+cs,   sy+cs+1, 1,  cs, iw, ih),
                br = love.graphics.newQuad(sx+cs+1, sy+cs+1, cs, cs, iw, ih),
            }
        end

        local quads = {}
        for x = 1, hqs do
            quads[x] = {} -- variants
            for y = 1, 4 do
                if y > vqs then
                    quads[x][y] = utils:DeepCopy(quads[x][vqs])
                else
                    quads[x][y] = _createquadgroup((x-1)*qs, (y-1)*qs) -- states
                end
            end
        end

        return {type="image", image=image, quads=quads, cornersize=cs}
    elseif data.color then
        local cs = data.cornersize or 0
        return {type="color", color=data.color, cornersize=cs}
    end
end

function style:CacheStyle(transform,data)
    if data.type == "image" then
        local image, quads, cs = data.image, data.quads, data.cornersize
        local x,y,w,h = 0, 0, transform.w, transform.h

        local batches = {}
        for v = 1, #quads do
            batches[v] = {}
            for s = 1, #quads[v] do
                local quad = quads[v][s]
                batches[v][s] = love.graphics.newSpriteBatch(image,9)
                batches[v][s]:add(quad.tl, x,      y)
                batches[v][s]:add(quad.tm, x+cs,   y,      0, w-cs*2, 1)
                batches[v][s]:add(quad.tr, x+w-cs, y)
                batches[v][s]:add(quad.cl, x,      y+cs,   0, 1,      h-cs*2)
                batches[v][s]:add(quad.cm, x+cs,   y+cs,   0, w-cs*2, h-cs*2)
                batches[v][s]:add(quad.cr, x+w-cs, y+cs,   0, 1,      h-cs*2)
                batches[v][s]:add(quad.bl, x,      y+h-cs)
                batches[v][s]:add(quad.bm, x+cs,   y+h-cs, 0, w-cs*2, 1)
                batches[v][s]:add(quad.br, x+w-cs, y+h-cs)
            end
        end

        return {type="image", style=batches}
    elseif data.type == "color" then
        return {type="color", style=data.color, cornersize=data.cornersize}
    end
end

function style:DrawSetup(element,transform,id,keys,state,varient)
    state = state or self:GetState(element)
    varient = varient or 1

    local category, catkey = self:Get(element,nil,keys,keys[#keys],true)
    if not category then return nil, nil, nil, true end
    if not element._cache[catkey] then
        element._cache[catkey] = {}
    end
    if not element._cache[catkey][id] then
        element._cache[catkey][id] = self:CacheStyle(transform,category)
    end
    local data = element._cache[catkey][id]
    if not data.style[varient] then varient = 1 end
    return data, state, varient, false
end

--- Box ----------------------------------------------------------------------------

function style:DrawBox(element,transform,id,keys,state,varient)
    local data, failed
    data, state, varient, failed = self:DrawSetup(element,transform,id,keys,state,varient)
    if failed then return end

    if data.type == "color" then
        local color = data.style[varient][state]
        if color[4] == 0 then return end -- Optimization, skip drawing if fully transparent
        love.graphics.setColor(color)
        love.graphics.rectangle("fill", transform.x, transform.y, transform.w, transform.h, data.cornersize, data.cornersize, 8)
    elseif data.type == "image" then
        local batch = data.style[varient][state]
        love.graphics.setColor(1,1,1)
        love.graphics.draw(batch, transform.x, transform.y)
    end
end

--- Text ---------------------------------------------------------------------------

function style:GetTextBounds(element,transform,font,text)
    local w,h = font:getWidth(text)-1, font:getHeight()-1
    local x = self:GetAllign(transform.x, w, transform.w, element.allignx, element.marginx)
    local y = self:GetAllign(transform.y, h, transform.h, element.alligny, element.marginy)
    return x,y,w,h
end

function style:DrawText(element,transform,id,keys,state,varient,text)
    local data, failed
    data, state, varient, failed = self:DrawSetup(element,transform,id,keys,state,varient)
    if failed then return end

    if data.type == "color" then
        local color = data.style[varient][state]
        if color[4] == 0 or text == "" then return end -- Optimization, skip drawing if fully transparent or empty text
        love.graphics.setFont(element.font)
        love.graphics.setColor(color)
        local x,y,_,_ = self:GetTextBounds(element,transform,element.font,text)
        -- STO Addition
        if element.parent and (state ~= 3) then
            y = y - 1
        end
        love.graphics.print(text, x, y)
    elseif data.type == "image" then
        return -- Not Supported
    end
end

--- Image --------------------------------------------------------------------------

function style:GetImageBounds(element,transform,image,quad)
    local w,h,_,_
    if quad then
        _,_,w,h = quad:getViewport()
    else
        w,h = image:getWidth(), image:getHeight()
    end
    local x = self:GetAllign(transform.x, w, transform.w, element.allignx, element.marginx)
    local y = self:GetAllign(transform.y, h, transform.h, element.alligny, element.marginy)
    return x,y,w,h
end

function style:GetImageBoundsFit(x,y,w,h,transform,fit)
    local imgw,imgh = w, h
    local fullw, fullh = transform.w, transform.h
    if fit == "cover" then
        local scale = math.max(transform.w/w, transform.h/h)
        w,h = w*scale,h*scale
        x = x + (imgw-w)/2
        y = y + (imgh-h)/2
    elseif fit == "contain" then
        local scale = math.min(transform.w/w, transform.h/h)
        w,h = w*scale,h*scale
        x = x + (imgw-w)/2
        y = y + (imgh-h)/2
    elseif fit == "fill" then
        w,h = fullw, fullh
        x,y = transform.x, transform.y
    end
    local scalex, scaley = w/imgw, h/imgh
    return x,y,scalex,scaley
end

function style:DrawImage(element,transform,id,keys,state,varient,image,quad,fit)
    local data, failed
    data, state, varient, failed = self:DrawSetup(element,transform,id,keys,state,varient)
    if failed then return end

    if data.type == "color" then
        local color = data.style[varient][state]
        if color[4] == 0 then return end -- Optimization, skip drawing if fully transparent
        love.graphics.setColor(color)
        local sx,sy = 1,1
        local x,y,w,h = self:GetImageBounds(element,transform,image,quad)
        x,y,sx,sy = self:GetImageBoundsFit(x,y,w,h,transform,fit)
        if quad then
            love.graphics.draw(image, quad, x, y, 0, sx, sy)
        else
            love.graphics.draw(image, x, y, 0, sx, sy)
        end
    elseif data.type == "image" then
        return -- Not Supported
    end
end

return style