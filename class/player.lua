local player = Class("player", OBJECTS.base)

function player:initialize(world, x, y, w, h, props)
    OBJECTS.base.initialize(self, world, x, y, w, h)
    self.DIR = 1
    self.R = 0
    self.BY = 0

    self.static = false
    self.G = 512
    self.F = 256

    self.movespeed = 192
    self.moveacc = 256
    self.movefriction = 0
    self.idlefriction = 384
    self.tunrfriction = 512
    self.hopspeed = 212
    self.turnspeed = 2

    self.rookboostspeed = 312

    self.controlsenabled = true

    self.collideid = "player"
    self.collidelookup = {"ground"}

    self.counters = 0
    self.counterspecial = nil
    self:AddCounters(3)
    self:AddCounters("rook")

    self.anim = nil
    self.animtime = 0
end

function player:Update(dt)
    self:UpdateAnim(dt)
    if self.controlsenabled then
        if IN:down("special") and self.counterspecial then
            self:Special(self.counterspecial)
        else
            self:Movement(dt)
            self:Hop()
        end
    end
    self:UpdateState(dt)
    self:UpdateHeight()
end

function player:UpdateState(dt)
    if self.jumping then
        self.moving = nil
        self.jumping = self.jumping - dt
        self.R = math.pi*(-self.DIR)*self.jumping*self.turnspeed
        if self.jumping <= 0 then
            self.jumping = nil
        end
    elseif self.moving then
        self.moving = self.moving - dt
        self.R = math.pi*(-self.movingdir)*self.moving*self.turnspeed
        if self.moving <= 0 then
            self.moving = nil
        end 
    end
end

function player:UpdateHeight()
    local h = (4*(1+self.counters))
    if self.counterspecial then h = h + 16 end
    if self.jumping or self.moving then
        h = h + 6
    end
    if h ~= self.H then
        self.Y = self.Y - (h-self.H)
        self.H = h
        self:Move(self.X,self.Y,self.W,self.H)
    end
end

function player:Movement(dt)
    local left, right = IN:down("left"), IN:down("right")
    
    self.F = self.idlefriction
    if left and (not right) then
        self.VX = math.max(self.VX - (self.moveacc * dt), -self.movespeed)
        self.F = self.movefriction
        if (not self.moving) and self.grounded then
            self.moving = 1/self.turnspeed
            self.movingdir = -1
            self.VY = -120
        end
        self.DIR = -1
    elseif right and (not left) then
        self.VX = math.min(self.VX + (self.moveacc * dt), self.movespeed)
        self.F = self.movefriction
        if (not self.moving) and self.grounded then
            self.moving = 1/self.turnspeed
            self.movingdir = 1
            self.VY = -120
        end
        self.DIR = 1
    end
    if (left and self.VX > 0) or (right and self.VX < 0) then
        self.F = self.tunrfriction
    end
end

function player:Hop()
    if IN:pressed("jump") and self.grounded then
        self.VY = -self.hopspeed
        self.jumping = 1/self.turnspeed
    end
end

function player:Special(t)
    if not self.grounded then return end
    if IN:pressed("right") and t == "rook" then
        self.controlsenabled = false
        self.G = 0; self.VY = 0
        self.VX = self.rookboostspeed
        self:NewAnim(function()
            self:Wait(0.5)
            self.G = 512
            self.VX = 0
            self.controlsenabled = true
        end)
    elseif IN:pressed("left") and t == "rook" then
        self.controlsenabled = false
        self.G = 0; self.VY = 0
        self.VX = -self.rookboostspeed
        self:NewAnim(function()
            self:Wait(0.5)
            self.G = 512
            self.VX = 0
            self.controlsenabled = true
        end)
    elseif IN:pressed("jump") and t == "rook" then
        self.controlsenabled = false
        self.G = 0; self.VX = 0
        self.VY = -self.rookboostspeed
        self:NewAnim(function()
            self:Wait(0.5)
            self.G = 512
            self.VY = 0
            self.controlsenabled = true
        end)
    end
end

function player:Draw()
    love.graphics.draw(Counterimg, Counterquads[1], self.X+8, self.Y+(self.H-4)+2, self.R, 1, 1, 8, 14)
    local offsety = math.sin(-math.abs(self.R))*6
    for i = 1, self.counters do
        love.graphics.draw(Counterimg, Counterquads[1], self.X+8, self.Y+(self.H-4)+2-(i*4)+offsety, 0, 1, 1, 8, 14)
    end
    if self.counterspecial then
        love.graphics.draw(Counterimg, Counterquads[2], self.X+8, self.Y+(self.H-4)+2-(self.counters*4)-4+offsety, 0, 1, 1, 8, 14)
    end
end

function player:AddCounters(t)
    if tonumber(t) then
        self.counters = self.counters + t
    else
        self.counterspecial = t
    end
end

-----------------

function player:Wait(delay)
    self.animtime = delay; coroutine.yield()
end
function player:NewAnim(func)
    self.animtime = 0
    self.anim = coroutine.create(func)
    coroutine.resume(self.anim)
end
function player:UpdateAnim(dt)
    if self.animtime > 0 then
        self.animtime = self.animtime - dt
        if self.animtime <= 0 then
            coroutine.resume(self.anim)
        end
    end
    if self.anim and coroutine.status(self.anim) == "dead" then
        self.anim = nil
    end
end

OBJECTS.player = player