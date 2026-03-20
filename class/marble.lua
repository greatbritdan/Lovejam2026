local marble = Class("marble", OBJECTS.base)

function marble:initialize(world, x, y, w, h, props)
    OBJECTS.base.initialize(self, world, x, y, w, h)
    self.R = 0

    self.static = false
    self.grounded = true
    self.G = 512
    self.F = nil
    self.VX = -32

    self.collideid = "marble"
    self.collidelookup = {"tile","blocker","door","player","counter","switch","marble","scale"}
end

function marble:Update(dt)
    self.R = self.R + (self.VX/8)*dt
    if self.Y > (GAME.MAP.H*GAME.MAP.TH) then
        GAME.MAP.layers["objects"]:RemoveObject(self)
    end
end 

function marble:Draw()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(Marbleimg, Marblequads[1], self.X+6, self.Y+6, self.R, 1, 1, 8, 8)
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
        return true
    end
end

OBJECTS.marble = marble

---------------------------------------------

local marblespawner = Class("marble", OBJECTS.base)

function marblespawner:initialize(world, x, y, w, h, props)
    OBJECTS.base.initialize(self, world, x, y, w, h)

    self.speed = props.speed or 32

    self.collideid = "tile"
    self.collidelookup = {"player","counter"}
end

function marblespawner:Spawn()
    -- Only spawn when on screen (or close enough)
    if self.X+self.W+2 > GAME.SX and self.X-2 < GAME.SX+ENV.width then
        self.child = GAME.MAP.layers["objects"]:AddObject("marble", self.X+2, self.Y+4, 12, 12, {})
        self.child.VX = self.speed
        self.child.grounded = true
        playsound(Shootsound)
    end
end 

function marblespawner:Update(dt)
    if (not self.child) or self.child.__DELETED then
        self:Spawn()
    end
end 

function marblespawner:Draw()
    if self.X+self.W+2 > GAME.SX and self.X-2 < GAME.SX+ENV.width then
        love.graphics.setColor(1,1,1)
        love.graphics.draw(Marbleimg, Marblequads[2], self.X, self.Y)
    end
end

OBJECTS.marblespawner = marblespawner