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
    self.hopspeed = 200
    self.turnspeed = 2

    self.collideid = "player"
    self.collidelookup = {"ground"}

    self.counters = 3
end

function player:Update(dt)
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

    if IN:pressed("jump") and self.grounded then
        self.VY = -self.hopspeed
        self.jumping = 1/self.turnspeed
    end
    
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

function player:Draw()
    love.graphics.draw(Counterimg, self.X+8, self.Y+2, self.R, 1, 1, 8, 2)
    local offsety = math.sin(-math.abs(self.R))*8
    print(offsety)
    for i = 1, self.counters do
        love.graphics.draw(Counterimg, self.X+8, self.Y+2-(i*4)+offsety, 0, 1, 1, 8, 2)
    end
end

OBJECTS.player = player