local marble = Class("marble", OBJECTS.base)

function marble:initialize(world, x, y, w, h, props)
    OBJECTS.base.initialize(self, world, x, y, w, h)

    self.static = false
    self.grounded = true
    self.G = 512
    self.F = 256

    self.collideid = "marble"
    self.collidelookup = {"tile","door","player","counter","switch","marble"}
end

function marble:Update(dt)
end

function marble:Draw()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(Marbleimg, self.X+6, self.Y+10, 0, 1, 1, 8, 8)
end

OBJECTS.marble = marble