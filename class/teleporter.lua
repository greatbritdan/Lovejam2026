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

    self:TryTeleport(GAME.PLAYER)
    -- Marble teleporting
    for _,obj in pairs(GAME.MAP.layers["objects"].objects) do
        if obj.collideid == "marble" then
            self:TryTeleport(obj, true)
        end
    end
end

function teleporter:TryTeleport(obj, marble)
    local aabb
    if marble then
        aabb = AABB(obj.X+3, obj.Y+3, 6, 6, self.X+3, self.Y+3, 6, 6)
    else
        aabb = AABB(obj.X+5, obj.Y+obj.H-3, 2, 2, self.X+3, self.Y+3, 6, 6)
    end
    if (not obj.teleportimmunity) and aabb then
        local t = self:Find("strict",{{"teleactive",true},{"teleid",self.teleid}})
        if t then
            local other = t[1]
            local dx, dy = other.X-self.X, other.Y-self.Y
            obj.teleportimmunity = .6
            obj.X, obj.Y = obj.X+dx, obj.Y+dy
            obj.world:update(obj, obj.X, obj.Y, obj.W, obj.H)
            other.teleactive = false
            self.teleactive = true
            playsound(Teleportsound)
            if self.varient == 2 then
                neweffect(self.X+2, self.Y+2, "teleinred")
                neweffect(other.X+2, other.Y+2, "teleoutred")
            else
                neweffect(self.X+2, self.Y+2, "telein")
                neweffect(other.X+2, other.Y+2, "teleout")
            end
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

OBJECTS.teleporter = teleporter