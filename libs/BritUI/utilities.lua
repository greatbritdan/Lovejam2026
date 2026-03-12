local utils = {scissorstack = {}}

function utils:AABB(x1,y1,w1,h1,x2,y2,w2,h2)
    return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end

function utils:DeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[DeepCopy(orig_key)] = DeepCopy(orig_value)
        end
        setmetatable(copy, DeepCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function utils:TableContains(text, table, key)
    for i, v in pairs(table) do
        if (key and v[key] == text) or ((not key) and v == text) then
            return i
        end
    end
    return false
end

function utils:TransformOffset(transform,offset)
    transform = self:DeepCopy(transform)
    if offset.x then transform.x = transform.x + offset.x end
    if offset.y then transform.y = transform.y + offset.y end
    if offset.w then transform.w = transform.w + offset.w end
    if offset.h then transform.h = transform.h + offset.h end
    return transform
end

function utils:SetAutoscroll(size,fullsize)
    if size > fullsize then
        return {dist=size-fullsize, pos=0, stage="wait_r", timer=0}
    else
        return {dist=0, pos=0}
    end
end

function utils:UpdateAutoscroll(a,dt)
    if a.dist == 0 then return 0 end
    a.timer = a.timer + dt
    if a.stage == "wait_r" and a.timer > 2 then
        a.stage, a.timer = "scroll_r", 0
    elseif a.stage == "scroll_r" then
        a.pos = math.min(a.pos + (dt*16), a.dist)
        if a.pos >= a.dist then
            a.stage, a.timer = "wait_l", 0
        end
    elseif a.stage == "wait_l" and a.timer > 2 then
        a.stage, a.timer = "scroll_l", 0
    elseif a.stage == "scroll_l" then
        a.pos = math.max(a.pos - (dt*16), 0)
        if a.pos <= 0 then
            a.stage, a.timer = "wait_r", 0
        end
    end
    return a.pos
end

function utils:ScissorPush(x,y,w,h)
    local x1,x2,y1,y2 = x, x+w, y, y+h
    local ox,oy,ow,oh = love.graphics.getScissor()
    ox,oy,ow,oh = ox or 0, oy or 0, ow or love.graphics.getWidth(), oh or love.graphics.getHeight()
    local ox1,ox2,oy1,oy2 = ox, ox+ow, oy, oy+oh
    if x1 < ox1 then x1 = ox1 end
    if y1 < oy1 then y1 = oy1 end
    if x2 > ox2 then x2 = ox2 end
    if y2 > oy2 then y2 = oy2 end
    local fx,fy,fw,fh = x1,y1,math.max(0,x2-x1),math.max(0,y2-y1)
    table.insert(self.scissorstack, {fx,fy,fw,fh})
    love.graphics.setScissor(fx,fy,fw,fh)
end

function utils:ScissorPop()
    table.remove(self.scissorstack)
    if #self.scissorstack == 0 then
        love.graphics.setScissor()
    else
        local x,y,w,h = unpack(self.scissorstack[#self.scissorstack])
        love.graphics.setScissor(x,y,w,h)
    end
end

return utils