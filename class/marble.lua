local marble = Class("marble", OBJECTS.base)

function marble:initialize(world, x, y, w, h, props)
    OBJECTS.base.initialize(self, world, x, y, w, h)
    self.DIR = 1
    self.R = 0

    self.static = false
    self.grounded = true
    self.G = 512
    self.VX = 32

    self.collideid = "marble"
    self.collidelookup = {"tile","door","player","counter"}
end

function marble:Update(dt)
    self.R = self.R + (math.pi*self.DIR*dt)
end

function marble:Draw()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(Marbleimg, self.X+6, self.Y+6, self.R%(math.pi/2), 1, 1, 8, 8)
end

function marble:Collide(other, nx, ny)
    if nx ~= 0 then
        self.DIR = -self.DIR
        self.VX = -self.VX
        return true, false
    end
    return false, false
end

OBJECTS.marble = marble