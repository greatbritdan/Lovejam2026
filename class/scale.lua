local scalecontroller = Class("scalecontroller", OBJECTS.base)

function scalecontroller:initialize(id, obj)
    self.scaleid = id
    CONTROLLERS[id] = self
    self.left, self.right = nil, nil
end
function scalecontroller:AddScale(obj, side)
    self[side] = obj
end

function scalecontroller:Setup()
    local l, r = self.left, self.right
    if l.Y < r.Y then
        self.startY, self.endY = l.Y, r.Y
    else
        self.startY, self.endY = r.Y, l.Y
    end
    self.dist = self.endY - self.startY
    self.balanceY = self.startY + (self.dist/2)

    l.Y = self.startY+(self.dist/2)
    r.Y = self.startY+(self.dist/2)
    l.world:update(l, l.X, l.Y, l.W, l.H)
    r.world:update(r, r.X, r.Y, r.W, r.H)
end

function scalecontroller:Update(dt)
    local l, r = self.left, self.right
    if l.countersgot > r.countersgot then
        l.VY, r.VY = l.scalespeed, -r.scalespeed
    elseif r.countersgot > l.countersgot then
        l.VY, r.VY = -l.scalespeed, r.scalespeed
    else
        if l.Y < self.balanceY then l.VY = l.scalespeed end
        if l.Y > self.balanceY then l.VY = -l.scalespeed end
        if r.Y < self.balanceY then r.VY = r.scalespeed end
        if r.Y > self.balanceY then r.VY = -r.scalespeed end
    end
    self.balanced = (l.countersgot == r.countersgot)
    self:ScaleUpdate(l)
    self:ScaleUpdate(r)
end

function scalecontroller:ScaleUpdate(o)
    if o.VY < 0 and o.Y < self.startY+0.1 then
        o.VY = 0
    end
    if o.VY > 0 and o.Y > self.endY-0.1 then
        o.VY = 0
    end
    if self.balanced and (not o.triggered) then
        o:SendTrigger(true)
    end
    if (not self.balanced) and o.triggered then
        o:SendTrigger(false)
    end
end

------------------------------------------------

OBJECTS.scale = scale

local scale = Class("scale", OBJECTS.base)

function scale:initialize(world, x, y, w, h, props)
    OBJECTS.base.initialize(self, world, x, y, w, h)
    self.static = false
    --self.oneway = "up"

    self.collideid = "scale"
    self.collidelookup = {"player","counter","marble"}

    self.scalespeed = 32
    self.scaleid = props.scaleid or 0
    self.scaleside = props.scaleside or "left"

    self.triggered = false
    self.triggerid = props.linkid or 0

    if CONTROLLERS[self.scaleid] then
        self.controller = CONTROLLERS[self.scaleid]
    else
        self.controller = scalecontroller:new(self.scaleid)
    end
    self.controller:AddScale(self, self.scaleside)
end

function scale:Update(dt)
    self.countersgot = self:CountersCheck()
end

function scale:Draw()
    if self.X+self.W > GAME.SX and self.X < GAME.SX+ENV.width then
        local i = ((self.countersgot > 0) and 2) or 1
        love.graphics.setColor(1,1,1)
        love.graphics.draw(Scaleimg, Scalequads[i], self.X, self.Y-7)
        love.graphics.setColor(1,1,1)
        love.graphics.printf(self.countersgot, self.X+3, self.Y+2, self.W-4, "center")
    end
end

function scale:Collide(other, nx, ny)
    return true, true
end

OBJECTS.scale = scale