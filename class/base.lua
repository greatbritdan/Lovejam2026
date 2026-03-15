local base = Class("base")

-- Based on Maurice's implimentation for Timelines
-- https://github.com/Stabyourself/timelines/blob/master/systems/physics.lua

function base:initialize(world, x, y, w, h)
    self.world = world
    self.X, self.Y, self.W, self.H = x, y, w, h

    if self.collision == false then -- TILES!
        self.active = false; return
    end

    self.VX, self.VY = 0, 0
    self.world:add(self, x, y, w, h)

    self.static = true
    self.active = true
    self.grounded = false

    self.collideid = nil
    self.collidelookup = {}

    self.movement = "slide"
    self.oneway = false
end
function base:Move(x,y,w,h)
    self.world:update(self,x,y,w,h)
end
function base:Release()
    self.world:remove(self)
end

function base:PhysicsUpdate(dt)
    if self.static or (not self.active) then return end

    if self.G then
        self.VY = self.VY + (self.G*dt)
    end
    if self.F then
        if self.VX > 0 then self.VX = self.VX - (self.F * dt) end
        if self.VX < 0 then self.VX = self.VX + (self.F * dt) end
        if math.abs(self.VX) < 1 then self.VX = 0 end
    end

    local wasgrounded = self.grounded
    self.grounded = false
    self.oldX, self.oldY = self.X, self.Y
    local newx, newy = self.newX, self.newY

    if self.riding and self.riding.movedX then
        self:PhysicsMove(self.X + self.riding.movedX, self.Y + self.riding.movedY, true)
        self.riding.rider = nil
    end
    self.riding = nil

    if not self.newX then
        newx, newy = self.X + (self.VX * dt), self.Y + (self.VY * dt)
    end
    if newx == self.X and newy == self.Y then
        self.movedX, self.movedY = 0, 0
        return
    end

    self:PhysicsMove(newx, newy)

    if (not wasgrounded) and self.grounded and self.Land then self:Land() end
    if wasgrounded and (not self.grounded) and self.Fall then self:Fall() end
    self.movedX, self.movedY = self.X - self.oldX, self.Y - self.oldY
end

function base:PhysicsFilter(other)
    if other.collideid and (not TableContains(self.collideid, other.collidelookup)) or (not TableContains(other.collideid, self.collidelookup)) then
        return false
    end
    if other.oneway == "up" and self.Y+self.H > other.Y then return false end
    if other.oneway == "down" and self.Y < other.Y+other.H then return false end
    if other.oneway == "left" and self.X-self.W > other.X then return false end
    if other.oneway == "right" and self.X < other.X+other.W then return false end
    return self.movement
end

function base:PhysicsMove(newx, newy, isriding)
    self.owX, self.owY = nil, nil
    local filter = function(self, other)
        if isriding and self.riding == other then return false end
        return self:PhysicsFilter(other)
    end
    local nextx, nexty, cols = self.world:move(self, newx, newy, filter)

    local keeppos = falsez
    for _, col in ipairs(cols) do
        local keepspeed = false
        if self.Collide then
            keepspeed, keeppos = self:Collide(col.other, col.normal.x, col.normal.y)
        end
        if col.type ~= "cross" and not keepspeed then
            self:PhysicsResolve(col.other, col.normal.x, col.normal.y)
        end
    end

    if keeppos == "ignore" then
        self.X, self.Y = self.owX or self.oldX, self.owY or self.oldY
        self.world:update(self, self.X, self.Y, self.W, self.H)
    elseif keeppos then
        self.X, self.Y = newx, newy
        self.world:update(self, self.X, self.Y, self.W, self.H)
    else
        self.X, self.Y = nextx, nexty
    end
end

function base:PhysicsCheck(args)
    args = args or {}
    local filter = function(self, other)
        return self:PhysicsFilter(other)
    end

    local oldx, oldy, oldw, oldh = self.X, self.Y, self.W, self.H
    self.X, self.Y, self.W, self.H = args.X or self.X, args.Y or self.Y, args.W or self.W, args.H or self.H
    self.world:update(self, self.X, self.Y, self.W, self.H)
    local nextx, nexty, cols = self.world:check(self, self.X, self.Y, filter)
    self.X, self.Y, self.W, self.H = oldx, oldy, oldw, oldh
    self.world:update(self, self.X, self.Y, self.W, self.H)

    return cols
end

function base:PhysicsCheckAABB(args)
    args = args or {}
    args.X, args.Y, args.W, args.H = args.X or self.X, args.Y or self.Y, args.W or self.W, args.H or self.H
    local ret = {}
    for _,obj in pairs(GAME.MAP.layers["objects"].objects) do
        if obj ~= self and (not obj.checkignore) and ((not args.include) or TableContains(obj.collideid, args.include)) then
            if AABB(obj.X, obj.Y, obj.W, obj.H, args.X, args.Y, args.W, args.H) then
                table.insert(ret, obj)
            end
        end
    end
    return ret
end

function base:PhysicsResolve(other, nx, ny)
    if (ny < 0 and self.VY > 0) then
        self.grounded = true; self.riding = other; other.rider = self
    end
    if (nx < 0 and self.VX > 0) or (nx > 0 and self.VX < 0) then self.VX = 0 end
    if (ny < 0 and self.VY > 0) or (ny > 0 and self.VY < 0) then self.VY = 0 end
end

local displaysize = 4
function base:PhysicsDraw()
    local color = {.6,1,.6,.35}
    if self.static then color = {1,1,1,.35} end
    if not self.active then color = {1,.6,.6,.35} end
    if self.oneway then
        love.graphics.setColor(color)
        if self.oneway == "up" then love.graphics.rectangle("fill", self.X, self.Y, self.W, displaysize) end
        if self.oneway == "down" then love.graphics.rectangle("fill", self.X, self.Y+(self.H-displaysize), self.W, displaysize) end
        if self.oneway == "left" then love.graphics.rectangle("fill", self.X, self.Y, displaysize, self.H) end
        if self.oneway == "right" then love.graphics.rectangle("fill", self.X, self.Y+(self.W-displaysize), displaysize, self.H) end
    else
        love.graphics.setColor(color)
        love.graphics.rectangle("fill", self.X, self.Y, self.W, self.H)
    end
end

-------------------------

function base:SendTrigger(state, id)
    id = id or self.triggerid
    self.triggered = state
    if id > 0 then
        GAME.MAP.layers["objects"]:Run("Trigger",{id, state})
    end
end

OBJECTS.base = base