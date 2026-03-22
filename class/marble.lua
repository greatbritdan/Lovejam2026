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
    self.collidelookup = {"tile","door","player","counter","switch","marble","scale"}

    self.colortimer = 0
end

function marble:Update(dt)
    if self.parent then
        self.colortimer = self.colortimer + dt*3
    end
    
    self.R = self.R + (self.VX/8)*dt

    if self.teleportimmunity then
        self.teleportimmunity = self.teleportimmunity - dt
        if self.teleportimmunity <= 0 then
            self.teleportimmunity = nil
        end
    end

    if self.Y > (GAME.MAP.H*GAME.MAP.TH) then
        GAME.MAP.layers["objects"]:RemoveObject(self)
    end
end 

function marble:Draw()
    if self.parent then
        love.graphics.setColor(self.colortimer,self.colortimer,self.colortimer)
    else
        love.graphics.setColor(1,1,1)
    end
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

    self.spawntimer = 0
end

function marblespawner:Spawn()
    self.child = GAME.MAP.layers["objects"]:AddObject("marble", self.X+2, self.Y+4, 12, 12, {})
    self.child.VX = self.speed
    self.child.grounded = true
    self.child.parent = self
    playsound(Shootsound)
end 

function marblespawner:Update(dt)
    -- Only spawn when on screen (or close enough)
    if ((not self.child) or self.child.__DELETED) and self.X+self.W+2 > GAME.SX and self.X-2 < GAME.SX+ENV.width then
        self.spawntimer = self.spawntimer + dt
        if self.spawntimer >= 1.5 then
            self:Spawn()
            self.spawntimer = 0
        end
    end
end 

function marblespawner:Draw()
    if self.X+self.W+2 > GAME.SX and self.X-2 < GAME.SX+ENV.width then
        love.graphics.setColor(1,1,1)
        love.graphics.draw(Marbleimg, Marblequads[2], self.X, self.Y)
    end
end

OBJECTS.marblespawner = marblespawner