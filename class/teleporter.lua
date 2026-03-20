local teleporter = Class("teleporter", OBJECTS.base)

function teleporter:initialize(world, x, y, w, h, props)
    self.X, self.Y, self.W, self.H = x, y, w, h
    self.R = 0
    self.checkignore = true

    self.varient = props.varient or 1
    self.teleactive = props.active or false
    self.teleid = props.teleportid or 0
end

function teleporter:Update(dt)
    self.R = self.R + (math.pi*dt)

    if self.teleactive then return end

    local p = GAME.PLAYER
    if (not p.teleportimmunity) and AABB(p.X+5, p.Y+p.H-3, 2, 2, self.X+3, self.Y+3, 6, 6) then
        local t = self:Find("strict",{{"teleactive",true},{"teleid",self.teleid}})
        if t then
            local other = t[1]
            local dx, dy = other.X-self.X, other.Y-self.Y
            p.teleportimmunity = .6
            p.X, p.Y = p.X+dx, p.Y+dy
            p.world:update(p, p.X, p.Y, p.W, p.H)
            other.teleactive = false
            self.teleactive = true
            playsound(Teleportsound)
            neweffect(self.X+2, self.Y+2, "telein")
            neweffect(other.X+2, other.Y+2, "teleout")
        end
    end
end

function teleporter:Draw()
    if self.X+self.W+2 > GAME.SX and self.X-2 < GAME.SX+ENV.width then
        love.graphics.setColor(1,1,1,.2)
        if self.teleactive then
            love.graphics.setColor(1,1,1)
        end
        love.graphics.draw(Teleporterimg, Teleporterquads[self.varient][1], self.X+6, self.Y+6, self.R, math.sin(self.R), 1, 6, 6)
        love.graphics.draw(Teleporterimg, Teleporterquads[self.varient][2], self.X+6, self.Y+6, -self.R, 1, math.cos(self.R), 6, 6)
        love.graphics.draw(Teleporterimg, Teleporterquads[self.varient][3], self.X+6, self.Y+6, self.R/4, 1, 1, 6, 6)
    end
end

OBJECTS.teleporter = teleporterz