local switch = Class("switch", OBJECTS.base)

function switch:initialize(world, x, y, w, h, props)
    OBJECTS.base.initialize(self, world, x, y, w, h)

    self.collideid = "switch"
    self.collidelookup = {"player","counter","marble"}

    self.countersgot = 0
    self.countersneeded = props.counters or 3
    self.triggered = false

    self.triggerid = props.linkid or 0
end

function switch:Update(dt)
    local hits = self:PhysicsCheckAABB{Y=self.Y-1, include={"player","counter"}}
    local c = 0
    for i, v in pairs(hits) do
        c = c + v.counters
        if v.counterspecial then c = c + 1 end
        if v.collideid == "player" then c = c + 1 end
        -- Yeah sure, players on counters should count.
        if v.rider and v.rider.counters then
            c = c + v.rider.counters
            if v.rider.counterspecial then c = c + 1 end
            if v.rider.collideid == "player" then c = c + 1 end
        end
    end
    if c >= self.countersneeded and (not self.triggered) then
        self:SendTrigger(true)
    end
    if c < self.countersneeded and self.triggered then
        self:SendTrigger(false)
    end
    self.countersgot = c
end

function switch:Draw()
    local i = ((self.triggered) and 3) or ((self.countersgot > 0) and 2) or 1
    love.graphics.setColor(1,1,1)
    love.graphics.draw(Switchimg, Switchquads[i], self.X, self.Y-7)
    if i == 2 then
        local w = math.floor((self.W-4)*(self.countersgot/self.countersneeded))
        love.graphics.setColor(89/255,193/255,53/255)
        love.graphics.rectangle("fill", self.X+2, self.Y+2, w, self.H-3)
        love.graphics.setColor(1,1,1)
        love.graphics.printf(self.countersgot.."/"..self.countersneeded, self.X+3, self.Y+2, self.W-4, "center")
    end
end
function switch:DebugDraw()
    love.graphics.setColor(0,0,1,1)
    love.graphics.rectangle("line", self.X, self.Y-1, self.W, 2)
end

OBJECTS.switch = switch