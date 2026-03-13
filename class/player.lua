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
    self.movefriction = nil
    self.idlefriction = 384
    self.tunrfriction = 512
    self.hopspeed = 192
    self.turnspeed = 3
    self.movehopspeed = 92

    self.rookboostspeed = 512
    self.rookboostspeedy = 312
    self.rookcollide = nil
    self.rookdouble = nil

    self.controlsenabled = true

    self.collideid = "player"
    self.collidelookup = {"tile","counter"}

    self.counters = 0
    self.counterspecial = nil
    self:AddCounters(props.counters or 3)
    self:AddCounters(props.counterspecial)
    self:UpdateHeight()

    self.anim = nil
    self.animtime = nil
    self.animcheck = nil
    self.animwait = nil
end

function player:Update(dt)
    self:UpdateAnim(dt)
    if self.controlsenabled then
        if IN:pressed("special") then
            self:SpecialRook()
        else
            self:Movement(dt)
            self:Hop()
        end
    end
    self:UpdateRook(dt)
    self:UpdateState(dt)
end

function player:Draw()
    if self.rookdouble then
        love.graphics.setColor(1,1,1,1-(self.rookdouble.timer*10))
        self:DrawSelf(self.rookdouble.X, self.rookdouble.Y)
    end
    love.graphics.setColor(1,1,1)
    self:DrawSelf(self.X, self.Y)
end

function player:DrawSelf(x, y)
    x, y = x+6, y+(self.H-4)+2

    y = y + math.sin(-math.abs(self.R))*6
    local scalex, scaley = 1, 1
    if math.abs(self.R) >= math.pi/2 then scaley = -1 end
    if math.abs(self.R) >= math.pi/2 then scalex = -1 end
    love.graphics.draw(Counterimg, Counterquads["counter"], x, y, self.R, scalex, scaley, 8, 14)

    y = y + math.sin(-math.abs(self.R))*6
    for i = 1, self.counters do
        love.graphics.draw(Counterimg, Counterquads["counter"], x, y-(i*4), 0, 1, 1, 8, 14)
    end
    if self.counterspecial then
        love.graphics.draw(Counterimg, Counterquads[self.counterspecial], x, y-(self.counters*4)-4, 0, 1, 1, 8, 14)
    end
end

function player:Collide(other, nx, ny)
    if self.rookdouble then self.rookcollide = true end
    if other.collideid == "counter" then
        return other:Collide(self, -nx, -ny)
    end
    return false, false
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
            --self.VY = -self.movehopspeed
        end
        self.DIR = -1
    elseif right and (not left) then
        self.VX = math.min(self.VX + (self.moveacc * dt), self.movespeed)
        self.F = self.movefriction
        if (not self.moving) and self.grounded then
            self.moving = 1/self.turnspeed
            self.movingdir = 1
            --self.VY = -self.movehopspeed
        end
        self.DIR = 1
    end
    if (left and self.VX > 0) or (right and self.VX < 0) then
        self.F = self.tunrfriction
    end
end

function player:Hop()
    if IN:pressed("jump") and self.grounded then
        local cols = self:PhysicsCheck{H=self.H+12, Y=self.Y-12}
        if #cols == 0 then
            self.VY = -self.hopspeed
            self.jumping = 1/self.turnspeed
            self:UpdateHeight()
        end
    end
end

function player:UpdateState(dt)
    if self.jumping then
        self.moving = nil
        self.jumping = self.jumping - dt
        self.R = math.pi*(-self.DIR)*self.jumping*self.turnspeed
        if self.jumping <= 0 then
            self.jumping = nil
            self:UpdateHeight()
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
    if self.counterspecial then h = h + 15 end
    if self.jumping or self.moving then
        h = h + 12 -- TODO: redo this with better collision detection, too many teleports
    end
    if h ~= self.H then
        self.Y = self.Y - (h-self.H)
        self.H = h
        self:Move(self.X,self.Y,self.W,self.H)
    end
end

function player:AddCounters(t)
    if tonumber(t) then
        self.counters = self.counters + t
    elseif tostring(t) then
        self.counterspecial = t
    end
end

----------
-- ROOK --
----------

function player:SpecialRook()
    if self.counterspecial ~= "rook" then return end

    local dash, sx, sy = false, 0, 0
    if IN:down("up") then dash, sx, sy = true, 0, -self.rookboostspeedy end
    if IN:down("left") then dash, sx, sy = true, -self.rookboostspeed, 0 end
    if IN:down("right") then dash, sx, sy = true, self.rookboostspeed, 0 end
    if dash then
        self:NewAnim(function()
            self.rookcollide = false
            self.rookdouble = {timer=0, time=0.1, X=self.X, Y=self.Y}
            self.controlsenabled = false
            self.G = 0
            self.VX, self.VY = sx, sy
            self:Wait(0.4, function() return self.rookcollide end)
            self.G = 512
            self.VX, self.VY = 0, 0
            self.rookdouble = nil
            self:Wait(2.5, function() return self.grounded end)
            self.controlsenabled = true
        end)
    end
end

function player:UpdateRook(dt)
    if self.counterspecial ~= "rook" then return end

    if self.rookdouble then
        self.rookdouble.timer = self.rookdouble.timer + dt
        if self.rookdouble.timer >= self.rookdouble.time then
            self.rookdouble.timer = self.rookdouble.timer - self.rookdouble.time
            self.rookdouble.X, self.rookdouble.Y = self.X, self.Y
        end
    end
end

-----------------

function player:Wait(delay, checkfunc)
    self.animtime = delay;
    self.animcheck = checkfunc;
    self.animwait = true
    coroutine.yield()
end
function player:NewAnim(func)
    self.animtime = 0
    self.anim = coroutine.create(func)
    coroutine.resume(self.anim)
end
function player:UpdateAnim(dt)
    if self.animwait then
        if self.animtime and self.animtime > 0 then
            self.animtime = self.animtime - dt
            if self.animtime <= 0 then
                self.animtime = nil
            end
        end
        if self.animcheck then
            if self.animcheck() then
                self.animcheck = nil
            end
        end
        if (not self.animtime) or (not self.animcheck) then
            self.animwait = nil
            coroutine.resume(self.anim)
        end
    end
    if self.anim and coroutine.status(self.anim) == "dead" then
        self.anim = nil
    end
end

OBJECTS.player = player