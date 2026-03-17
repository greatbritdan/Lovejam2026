local counter = Class("counter", OBJECTS.base)

function counter:initialize(world, x, y, w, h, props)
    OBJECTS.base.initialize(self, world, x, y, w, h)

    self.static = false

    self.G = 512
    self.F = 256

    self.collideid = "counter"
    self.collidelookup = {"tile","blocker","player","counter","switch","door","marble"}

    self.counters = props.counters or 0
    self.counterspecial = props.counterspecial or nil
    self:UpdateHeight()
end

function counter:Draw()
    love.graphics.setColor(1,1,1)
    self:DrawSelf(self.X, self.Y)
end

function counter:DrawSelf(x, y)
    x, y = x+6, y+(self.H-4)+2
    if self.counterspecial then
        love.graphics.draw(Counterimg, Counterquads[2][self.counterspecial], x, y, 0, 1, 1, 8, 30)
    else
        for i = 1, self.counters do
            love.graphics.draw(Counterimg, Counterquads[2]["counter"], x, y-((i-1)*4), 0, 1, 1, 8, 30)
        end
    end
end

function counter:Land()
    if self.grounded then
        -- if a tree falls in the forest and no one is around to hear it, does it make a sound?
        if self.X > GAME.SX and self.X < GAME.SX+ENV.width then
            playsound(Landsounds[math.random(#Landsounds)])
            neweffect(self.X+2, self.Y+self.H-4, "dustl")
            neweffect(self.X+2, self.Y+self.H-4, "dustr")
        end
    end
end

function counter:Collide(other, nx, ny)
    if other.collideid == "player" then
        if ny == -1 then
            self.owX = other.X+other.W
            return true, "ignore"
        end
    end
    if other.collideid == "counter" and ny ~= 0 then
        if (not self.counterspecial) and (not other.counterspecial) then
            -- Merge counters
            self.counters = self.counters + other.counters
            self:UpdateHeight()
            other:Release()
            GAME.MAP.layers["objects"]:RemoveObject(other)
            self.grounded = true
            return true, "ignore"
        end
    end
    return false, false
end

function counter:UpdateHeight()
    local h = (4*self.counters)
    if self.counterspecial then h = h + 15 end
    if h ~= self.H then
        self.Y = self.Y - (h-self.H)
        self.H = h
        self:Move(self.X,self.Y,self.W,self.H)
    end
end

OBJECTS.counter = counter