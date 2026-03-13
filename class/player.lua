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
    self.hopspeed = 192
    self.turnspeed = 3
    self.movehopspeed = 92

    self.rookboostspeed = 312

    self.controlsenabled = true

    self.collideid = "player"
    self.collidelookup = {"tile"}

    self.counters = 0
    self.counterspecial = nil
    self:AddCounters(3)
    self:AddCounters("rook")

    self.anim = nil
    self.animtime = nil
    self.animcheck = nil
    self.animwait = nil

    self.rep = nil
end

function player:Update(dt)
    self:UpdateAnim(dt)

    if self.controlsenabled then
        if IN:pressed("special") and (IN:down("up") or IN:down("left") or IN:down("right")) then
            self:MovementRook()
        else
            self:Movement(dt)
            self:Hop()
        end
    end

    if self.rep then
        self.rep.timer = self.rep.timer + dt
        if self.rep.timer >= self.rep.time then
            self.rep.timer = self.rep.timer - self.rep.time
            self.rep.X, self.rep.Y = self.X, self.Y
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
    if self.counterspecial then h = h + 15 end
    --[[if self.jumping or self.moving then
        h = h + 6 -- TODO: redo this with better collision detection, too many teleports
    end]]
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
            self.VY = -self.movehopspeed
        end
        self.DIR = -1
    elseif right and (not left) then
        self.VX = math.min(self.VX + (self.moveacc * dt), self.movespeed)
        self.F = self.movefriction
        if (not self.moving) and self.grounded then
            self.moving = 1/self.turnspeed
            self.movingdir = 1
            self.VY = -self.movehopspeed
        end
        self.DIR = 1
    end
    if (left and self.VX > 0) or (right and self.VX < 0) then
        self.F = self.tunrfriction
    end
end

function player:MovementRook(t)
    local up = IN:down("up")
    local left = IN:down("left")
    local right = IN:down("right")

    self:NewAnim(function()
        self.rep = {timer=0, time=0.1, X=self.X, Y=self.Y}
        self.controlsenabled = false
        self.G = 0
        self.VX, self.VY = 0, 0
        if up then self.VY = -self.rookboostspeed
        elseif left then self.VX = -self.rookboostspeed
        elseif right then self.VX = self.rookboostspeed
        end
        self:Wait(0.3, function()
            if up then return self.VY ~= -self.rookboostspeed
            elseif left then return self.VX ~= -self.rookboostspeed
            elseif right then return self.VX ~= self.rookboostspeed
            end
        end)
        self.G = 512
        self.VX, self.VY = 0, 0
        self.rep = nil
        self:Wait(5, function() return self.grounded end)
        self.controlsenabled = true
    end)
end

function player:Hop()
    if IN:pressed("jump") and self.grounded then
        self.VY = -self.hopspeed
        self.jumping = 1/self.turnspeed
    end
end

function player:Draw()
    if self.rep then
        love.graphics.setColor(1,1,1,1-(self.rep.timer*10))
        self:DrawSelf(self.rep.X, self.rep.Y)
    end
    love.graphics.setColor(1,1,1)
    self:DrawSelf(self.X, self.Y)
end

function player:DrawSelf(x, y)
    x, y = x+8, y+(self.H-4)+2
    love.graphics.draw(Counterimg, Counterquads["counter"], x, y, self.R, 1, 1, 8, 14)

    y = y + math.sin(-math.abs(self.R))*6
    for i = 1, self.counters do
        love.graphics.draw(Counterimg, Counterquads["counter"], x, y-(i*4), 0, 1, 1, 8, 14)
    end
    if self.counterspecial then
        love.graphics.draw(Counterimg, Counterquads[self.counterspecial], x, y-(self.counters*4)-4, 0, 1, 1, 8, 14)
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