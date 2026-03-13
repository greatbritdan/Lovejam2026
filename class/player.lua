local player = Class("player", OBJECTS.base)

function player:initialize(world, x, y, w, h, props)
    OBJECTS.base.initialize(self, world, x, y, w, h)

    self.static = false
    self.G = 512
    self.F = 256

    self.movespeed = 192
    self.moveacc = 256
    self.movefriction = 0
    self.idlefriction = 384
    self.tunrfriction = 512

    self.collideid = "player"
    self.collidelookup = {"ground"}
end

function player:Update(dt)
    local left, right = IN:down("left"), IN:down("right")

    self.F = self.idlefriction
    if left and (not right) then
        self.VX = math.max(self.VX - (self.moveacc * dt), -self.movespeed)
        self.F = self.movefriction
    elseif right and (not left) then
        self.VX = math.min(self.VX + (self.moveacc * dt), self.movespeed)
        self.F = self.movefriction
    end
    if (left and self.VX > 0) or (right and self.VX < 0) then
        self.F = self.tunrfriction
    end
    print(self.F, self.VX)
end

OBJECTS.player = player