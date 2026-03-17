local teleporter = Class("teleporter", OBJECTS.base)

function teleporter:initialize(world, x, y, w, h, props)
    self.X, self.Y, self.W, self.H = x, y, w, h
    self.R = 0
    self.checkignore = true

    self.teleactive = props.active or false
    self.teleid = props.teleportid or 0
end

function teleporter:Update(dt)
    self.R = self.R + (math.pi*dt)

    if self.teleactive then return end
    
    local hits = self:PhysicsCheckAABB{X=self.X+8, Y=self.Y+8, W=self.W-16, H=self.H-16, include={"player"}} -- smaller hitbox for teleport
    if #hits > 0 then
        local p = hits[1]
        if p and (not p.teleportimmunity) then
            local t = self:Find("strict",{{"teleactive",true},{"teleid",self.teleid}})
            if t then
                local other = t[1]
                local dx, dy = other.X-self.X, other.Y-self.Y
                p.teleportimmunity = .6
                p.X, p.Y = p.X+dx, p.Y+dy
                p.world:update(p, p.X, p.Y, p.W, p.H)
                other.teleactive = false
                self.teleactive = true
            end
        end
    end
end

function teleporter:Draw()
    love.graphics.setColor(1,1,1,.2)
    if self.teleactive then
        love.graphics.setColor(1,1,1)
    end
    love.graphics.draw(Teleporterimg, Teleporterquads[1], self.X+6, self.Y+6, self.R, math.sin(self.R), 1, 6, 6)
    love.graphics.draw(Teleporterimg, Teleporterquads[2], self.X+6, self.Y+6, -self.R, 1, math.cos(self.R), 6, 6)
    love.graphics.draw(Teleporterimg, Teleporterquads[3], self.X+6, self.Y+6, self.R/4, 1, 1, 6, 6)
end

OBJECTS.teleporter = teleporter