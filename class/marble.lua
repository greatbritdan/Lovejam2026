local marble = Class("marble", OBJECTS.base)

function marble:initialize(world, x, y, w, h, props)
    OBJECTS.base.initialize(self, world, x, y, w, h)
    self.DIR = -1
    self.R = 0

    self.static = false
    self.grounded = true
    self.G = 512
    self.F = nil
    self.VX = -32

    self.collideid = "marble"
    self.collidelookup = {"tile","blocker","door","player","counter","switch","marble"}
end

function marble:Update(dt)
    self.R = self.R + (self.VX/8)*dt
end 

function marble:Draw()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(Marbleimg, self.X+6, self.Y+6, self.R, self.DIR, 1, 8, 8)
end

function marble:Land()
    if self.grounded then
        -- if a tree falls in the forest and no one is around to hear it, does it make a sound?
        if self.X > GAME.SX and self.X < GAME.SX+ENV.width then
            playsound(Landsounds[math.random(#Landsounds)])
            neweffect(self.X-4, self.Y+self.H-4, "dustl")
            neweffect(self.X+8, self.Y+self.H-4, "dustr")
        end
    end
end

function marble:Collide(other, nx, ny)
    if nx ~= 0 then
        self.VX = -self.VX
        self.DIR = -self.DIR
        return true
    end
end

OBJECTS.marble = marble