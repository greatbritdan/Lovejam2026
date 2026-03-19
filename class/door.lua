local door = Class("door", OBJECTS.base)

function door:initialize(world, x, y, w, h, props)
    OBJECTS.base.initialize(self, world, x, y, w, h)

    self.collideid = "door"
    self.collidelookup = {"player","counter","marble"}

    self.triggered = false
    self.triggerid = props.linkid or 0

    self.movespeed = 128
    self.moving = false
    self.startY = self.Y
    self.dist = props.dist or 4

    self.inverted = props.inverted or false
    if self.inverted then
        self.Y = self.Y-self.dist
        self.world:update(self, self.X, self.Y, self.W, self.H)
    end

    local lookup = {level2=2, level3=3}
    local qg = lookup[MAPNAME] or 1
    self.batch = love.graphics.newSpriteBatch(Doorimg, self.H/16)
    for i = 1, self.H/16 do
        local q = (i == 1 and 1) or (i == self.H/16 and 3) or 2
        self.batch:add(Doorquads[q][qg], 0, (i-1)*16)
    end
end

function door:Update(dt)
    if self.moving then
        local open = (self.triggered)
        if self.inverted then open = not open end
        if open then
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
    end
end

function door:Draw()
    if self.X+self.W > GAME.SX and self.X < GAME.SX+ENV.width then
        love.graphics.setColor(1,1,1)
        love.graphics.draw(self.batch, self.X, self.Y)
    end
end

function door:Trigger(id, state)
    if id == self.triggerid then
        local oldstate = self.triggered
        self.triggered = state
        if oldstate ~= self.triggered then
            local open = (self.triggered)
            if self.inverted then open = not open end
            -- Update world straight away to avoid softlocks
            if open then
                self.world:update(self, self.X, self.startY-self.dist, self.W, self.H)
                playsound(Opensound)
            else
                self.world:update(self, self.X, self.startY, self.W, self.H)
                playsound(Closesound)

                local hits = self:PhysicsCheckAABB{Y=self.startY, include={"player","counter","marble"}}
                for i, v in pairs(hits) do
                    local offx = (v.X+(v.W/2)) - (self.X+(self.W/2))
                    if offx <= 0 then
                        v.X = self.X+self.W
                    else
                        v.X = self.X-v.W
                    end
                end
            end
            self.moving = true
        end
    end
end

OBJECTS.door = door