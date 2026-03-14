local door = Class("door", OBJECTS.base)

function door:initialize(world, x, y, w, h, props)
    OBJECTS.base.initialize(self, world, x, y, w, h)

    self.collideid = "door"
    self.collidelookup = {"player","counter"}

    self.triggered = false
    self.triggerid = props.linkid or 0

    self.movespeed = 128
    self.moving = true
    self.startY = self.Y
    self.dist = props.dist or 4
end

function door:Update(dt)
    if self.moving then
        if self.triggered then
            self.Y = self.Y - (self.movespeed*dt)
            if self.Y < self.startY-self.dist then
                self.Y = self.startY-self.dist
                self.moving = false
            end
        else
            self.Y = self.Y + (self.movespeed*dt)
            if self.Y > self.startY then
                self.Y = self.startY
                self.moving = false
            end
        end
        self.world:update(self, self.X, self.Y, self.W, self.H)
    end
end

function door:Draw()
    love.graphics.rectangle("fill", self.X, self.Y, self.W, self.H)
end

function door:Trigger(id, state)
    if id == self.triggerid then
        self.triggered = state
        self.moving = true
    end
end

OBJECTS.door = door