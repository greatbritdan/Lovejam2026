local player = Class("player", OBJECTS.base)

function player:initialize(world, x, y, w, h, props)
    OBJECTS.base.initialize(self, world, x, y, w, h)
    self.startX, self.startY = self.X, self.Y
    self.DIR = 1
    self.R = 0

    self.static = false
    self.grounded = true
    self.G = 512
    self.F = 256

    self.movespeed = 128
    self.moveacc = 256
    self.movefriction = nil
    self.idlefriction = 384
    self.tunrfriction = 512
    self.hopspeed = 196
    self.turnspeed = 3
    self.movehopspeed = 92

    self.rookboostspeed = 384
    self.rookcollide = nil
    self.rookdouble = nil

    self.knightdouble = nil

    self.controlsenabled = true
    self.specialcontrolsenabled = true
    self.specialcooldown = nil

    self.collideid = "player"
    self.collidelookup = {"tile","blocker","counter","switch","door","marble","scale"}

    self.counters = 0
    self.counterspecial = nil
    self:AddCounters(props.counters or 0)
    self:AddCounters(props.counterspecial)
    self:UpdateHeight()

    self.blinktimer = math.random(3, 7)

    self.credits = props.credits or false
    if self.credits then
        self.controlsenabled = false
        self.F = nil -- no friction
        self.VX = 64
    end

    self.anim = nil
    self.animtime = nil
    self.animcheck = nil
    self.animwait = nil
end

function player:Update(dt)
    self:UpdateAnim(dt)
    if self.controlsenabled then
        local used = self:SpecialUpdate(dt)
        if not used then
            self:Movement(dt)
            if IN:pressed("split") then
                self:SplitCounters()
            elseif IN:pressed("merge") then
                self:MergeCounters()
            elseif IN:pressed("jump") and (self.grounded or SETTINGS:GetInside("codes","puttpartyreference")) then
                self:Hop()
            end
        end
    elseif self.credits then
        self:MovementCredits(dt)
    end
    self:UpdateRook(dt)
    self:UpdateKnight(dt)
    self:UpdateState(dt)
    if math.abs(self.R) < 0.05 then self.R = 0 end
end

function player:Draw()
    if self.rookdouble then
        love.graphics.setColor(1,1,1,1-(self.rookdouble.timer*10))
        self:DrawSelf(self.rookdouble.X, self.rookdouble.Y)
    end
    if self.knightdouble then
        love.graphics.setColor(1,1,1,.5)
        self:DrawSelf(self.knightdouble.X, self.knightdouble.Y)
    end
    love.graphics.setColor(1,1,1)
    self:DrawSelf(self.X, self.Y)
end

function player:DrawSelf(x, y)
    x, y = x+6, y+(self.H-4)+2

    y = y + math.sin(-math.abs(self.R))*6
    local scalex, scaley = 1, 1
    if math.abs(self.R) >= math.pi/2 then scaley = -scaley end
    if math.abs(self.R) >= math.pi/2 then scalex = -scalex end
    love.graphics.draw(Counterimg, Counterquads[1]["counter"], x, y, self.R, scalex, scaley, 8, 30)
    local cutex, cutey = x, y

    y = y + math.sin(-math.abs(self.R))*6
    for i = 1, self.counters do
        love.graphics.draw(Counterimg, Counterquads[1]["counter"], x, y-(i*4), 0, 1, 1, 8, 30)
    end
    if self.counterspecial then
        local i = (self.specialcooldown) and 3 or 1
        love.graphics.draw(Counterimg, Counterquads[i][self.counterspecial], x, y-(self.counters*4)-4, 0, 1, 1, 8, 30)
    end

    scalex, scaley = 1, 1
    if self.DIR == -1 then scalex = -scalex end
    local i = (self.blinktimer <= 0) and 2 or 1
    if self.jumping then i = 3 end
    love.graphics.draw(Cuteimg, Cutequads[i], cutex, cutey, 0, scalex, scaley, 8, 14)
end

function player:Collide(other, nx, ny)
    if self.rookdouble then self.rookcollide = true end
    if other.collideid == "scale" then
        if nx ~= 0 or ny == 1 or (ny == -1 and self.Y > other.Y) then
            return true, true
        end
    end
    return false, false
end

function player:Land()
    if self.grounded then
        if not self.credits then
            playsound(Landsounds[math.random(#Landsounds)])
        end
        neweffect(self.X-4, self.Y+self.H-4, "dustl")
        neweffect(self.X+8, self.Y+self.H-4, "dustr")
    end
end

function player:Movement(dt)
    local left, right = IN:down("left"), IN:down("right")
    self.F = self.idlefriction
    if left and (not right) then
        self.VX = math.max(self.VX - (self.moveacc * dt), -self.movespeed)
        self.F = self.movefriction
        if (not self.moving) and (not self.jumping) and self.grounded then
            if #self:PhysicsCheck{Y=self.Y-1} == 0 then
                self.moving = 1/self.turnspeed
                playsound(Flipsounds[math.random(#Flipsounds)], .6)
                self.movingdir = -1
            end
        end
        self.DIR = -1
    elseif right and (not left) then
        self.VX = math.min(self.VX + (self.moveacc * dt), self.movespeed)
        self.F = self.movefriction
        if (not self.moving) and (not self.jumping) and self.grounded then
            if #self:PhysicsCheck{Y=self.Y-1} == 0 then
                self.moving = 1/self.turnspeed
                playsound(Flipsounds[math.random(#Flipsounds)], .6)
                self.movingdir = 1
            end
        end
        self.DIR = 1
    end
    if (left and self.VX > 0) or (right and self.VX < 0) then
        self.F = self.tunrfriction
    end
end

function player:MovementCredits(dt)
    if (not self.moving) then
        self.moving = 1/self.turnspeed
        self.movingdir = 1
    end
    self.VX = 64 -- incase something stops the player
    self.DIR = 1
end

function player:Hop()
    if IN:down("down") then
        self.Y = self.Y + 0.1
    else
        if #self:PhysicsCheck{H=self.H+12, Y=self.Y-12} == 0 then
            self.VY = -self.hopspeed
            self.jumping = 1/self.turnspeed
            playsound(Jumpsound)
            self:UpdateHeight()
            for i = 1,3 do
                local x = math.random(10)
                neweffect(self.X-3+x, self.Y+self.H-4, "dustj")
            end
        end
    end
end

function player:SpecialUpdate(dt)
    if not self.specialcontrolsenabled then return end
    if self.specialcooldown then
        self.specialcooldown = self.specialcooldown - dt
        if self.specialcooldown <= 0 then
            self.specialcooldown = nil
        end
    end
    if IN:pressed("special") and (not self.specialcooldown) then
        if self:SpecialRook() then return true end
        if self:SpecialKnight() then return true end
    end
    return false
end

function player:UpdateState(dt)
    if self.jumping then
        self.moving = nil
        self.jumping = self.jumping - dt
        self.R = math.pi*(-self.DIR)*self.jumping*self.turnspeed
        if self.jumping <= 0 then
            self.jumping = nil
            self:UpdateHeight()
        end
    elseif self.moving then
        self.moving = self.moving - dt
        self.R = math.pi*(-self.movingdir)*self.moving*self.turnspeed
        if self.moving <= 0 then
            self.moving = nil
            self:Land()
        end 
    end

    if self.teleportimmunity then
        self.teleportimmunity = self.teleportimmunity - dt
        if self.teleportimmunity <= 0 then
            self.teleportimmunity = nil
        end
    end

    -- negative == blinking
    self.blinktimer = self.blinktimer - dt
    if self.blinktimer <= -0.2 then
        self.blinktimer = math.random(3, 7)
    end
end

function player:UpdateHeight(ignorey)
    local h = (4*(1+self.counters))
    if self.counterspecial then h = h + 15 end
    if (self.jumping or self.moving) and not ignorey then
        h = h + 12 -- TODO: redo this with better collision detection, too many teleports
    end
    if h ~= self.H then
        if not ignorey then
            self.Y = self.Y - (h-self.H)
        end
        self.H = h
        self:Move(self.X,self.Y,self.W,self.H)
    end
end

function player:Respawn()
    if CHECKPOINT then
        self.X = CHECKPOINT[1]-7
        self.Y = CHECKPOINT[2]-self.H
    else
        self.X = self.startX
        self.Y = self.startY
    end
    self.world:update(self, self.X, self.Y, self.W, self.H)

    self.VX, self.VY = 0, 0
    if self.credits then
        self.VX = 64
    end
end

--------------
-- COUNTERS --
--------------

function player:AddCounters(t)
    if tonumber(t) then
        self.counters = self.counters + t
    elseif tostring(t) then
        self.counterspecial = t
        self.rookdouble = nil
        self.knightdouble = nil
    end
end

function player:SplitCounters()
    if not self.grounded then return end
    if self.counters <= 0 then return end
    -- don't split in counter blockers
    if #self:PhysicsCheckAABB{include={"blocker"}} == 0 then 
        local t = self.counters
        local obj = GAME.MAP.layers["objects"]:AddObject("counter", self.X, self.Y+self.H-(t*4), 12, t*4, {counters=t})
        obj.grounded = true
        self:AddCounters(-t)
        self:UpdateHeight(true)
        playsound(Splitsounds[math.random(#Splitsounds)])
    end
end

function player:MergeCounters()
    local cols = self:PhysicsCheckAABB{Y=self.Y+1, include={"counter"}}
    for i,v in pairs(cols) do
        local t = v.counters
        if v.counterspecial then
            t = v.counterspecial
        end
        self.X = v.X
        GAME.MAP.layers["objects"]:RemoveObject(v)
        self:AddCounters(t)
    end
    if #cols > 0 then
        self.world:update(self, self.X, self.Y, self.W, self.H)
        playsound(Mergesounds[math.random(#Mergesounds)])
        self:UpdateHeight(true)
    end
end

----------
-- ROOK --
----------

function player:SpecialRook()
    if self.counterspecial ~= "rook" then return end

    local dash, sx, sy = false, 0, 0
    if IN:down("up") then dash, sx, sy = true, 0, -self.rookboostspeed end
    if IN:down("left") then dash, sx, sy = true, -self.rookboostspeed, 0 end
    if IN:down("right") then dash, sx, sy = true, self.rookboostspeed, 0 end
    if dash then
        self.specialcooldown = 3
        self:NewAnim(function()
            self.rookcollide = false
            self.rookdouble = {timer=0, time=0.1, X=self.X, Y=self.Y}
            self.controlsenabled = false
            self.specialcontrolsenabled = false
            self.G = 0
            self.VX, self.VY = sx, sy
            self:Wait(0.4, function() return self.rookcollide end)
            self.controlsenabled = true
            self.G = 512
            self.VX, self.VY = 0, 0
            self.rookdouble = nil
            self:Wait(2.5, function() return self.grounded end)
            self.specialcontrolsenabled = true
        end)
        return true
    end
end

function player:UpdateRook(dt)
    if self.counterspecial ~= "rook" then return end

    if self.rookdouble then
        self.rookdouble.timer = self.rookdouble.timer + dt
        if self.rookdouble.timer >= self.rookdouble.time then
            self.rookdouble.timer = self.rookdouble.timer - self.rookdouble.time
            self.rookdouble.X, self.rookdouble.Y = self.X, self.Y
        end
    end
end

------------
-- KNIGHT --
------------

function player:SpecialKnight()
    if self.counterspecial ~= "knight" then return end

    local dir = false
    if IN:down("up") then
        if #self:PhysicsCheckAABB{X=self.X+(self.DIR*48), Y=self.Y-96} == 0 then
            self.specialcooldown = 3
            self.X, self.Y = self.X+(self.DIR*48), self.Y-96
            self.world:update(self, self.X, self.Y, self.W, self.H)
            return true
        end
    end
end

function player:UpdateKnight(dt)
    if self.counterspecial ~= "knight" then return end

    self.knightdouble = nil
    if (not self.specialcontrolsenabled) or self.specialcooldown then return end
    if IN:down("up") then
        self.knightdouble = {}
        self.knightdouble.X, self.knightdouble.Y = self.X+(self.DIR*48), self.Y-96
    end
end

-----------------

function player:Wait(delay, checkfunc)
    self.animtime = delay;
    self.animcheck = checkfunc;
    self.animwait = true
    coroutine.yield()
end
function player:NewAnim(func)
    self.animtime = 0
    self.anim = coroutine.create(func)
    coroutine.resume(self.anim)
end
function player:UpdateAnim(dt)
    if self.animwait then
        if self.animtime and self.animtime > 0 then
            self.animtime = self.animtime - dt
            if self.animtime <= 0 then
                self.animtime = nil
            end
        end
        if self.animcheck then
            if self.animcheck() then
                self.animcheck = nil
            end
        end
        if (not self.animtime) or (not self.animcheck) then
            self.animwait = nil
            coroutine.resume(self.anim)
        end
    end
    if self.anim and coroutine.status(self.anim) == "dead" then
        self.anim = nil
    end
end

OBJECTS.player = player