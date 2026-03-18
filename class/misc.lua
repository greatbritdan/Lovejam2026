local text = Class("text", OBJECTS.base)

function text:initialize(world, x, y, w, h, props)
    self.X, self.Y, self.W, self.H = x, y, w, h
    self.checkignore = true
    
    self.text = props.text or "no text?"
    self.opacity = 1

    self.triggerid = props.linkid or 0
    if self.triggerid > 0 then
        self.opacity = 0
    end
end

function text:Update(dt)
    if self.action and self.action:update(dt) then self.action = nil end
end

function text:Draw()
    love.graphics.setColor(1,1,1,self.opacity)
    love.graphics.print(self.text, math.floor(self.X-((Font:getWidth(self.text)-1)/2)), self.Y-2)
end

function text:Trigger(id, state)
    if self.triggerid == id then
        self.triggered = state
        if state then
            self.action = TWEEN.new((1-self.opacity)/3, self, {opacity=1}, "linear")
        else
            self.action = TWEEN.new((self.opacity)/3, self, {opacity=0}, "linear")
        end
    end
end

OBJECTS.text = text

--------------------------------------------

local trigger = Class("trigger", OBJECTS.base)

function trigger:initialize(world, x, y, w, h, props)
    self.X, self.Y, self.W, self.H = x, y, w, h
    self.checkignore = true

    self.triggered = false
    self.triggerid = props.linkid or 0
    self.triggerinfo = props.linkinfo or nil
    self.triggermode = props.mode or "toggle"
end

function trigger:Update(dt)
    if self.triggered and self.triggermode ~= "toggle" then return end

    local hits = self:PhysicsCheckAABB{include={"player"}}
    if self.triggermode == "toggle" then
        if #hits > 0 and (not self.triggered) then
            self:SendTrigger(true)
        end
        if #hits == 0 and self.triggered then
            self:SendTrigger(false)
        end
    elseif self.triggermode == "on" then
        if #hits > 0 and (not self.triggered) then
            self:SendTrigger(true)
        end
    elseif self.triggermode == "off" then
        if #hits > 0 and (not self.triggered) then
            self:SendTrigger(false)
        end        
    end
end

OBJECTS.trigger = trigger

--------------------------------------------

local checkpoint = Class("checkpoint", OBJECTS.base)

function checkpoint:initialize(world, x, y, w, h, props)
    self.X, self.Y, self.W, self.H = x, y, w, h
    self.checkignore = true

    self.triggered = false
    self.triggerid = props.linkid or 0
end

function checkpoint:Trigger(id, state)
    if self.triggerid == id then
        self.triggered = state
        CHECKPOINT = {self.X, self.Y}
    end
end

OBJECTS.checkpoint = checkpoint

--------------------------------------------

local grate = Class("checkpoint", OBJECTS.base)

function grate:initialize(world, x, y, w, h, props)
    OBJECTS.base.initialize(self, world, x, y, w, h)
    self.X, self.Y, self.W, self.H = x, y, 16, 0.375*16

    self.collideid = "tile"
    self.collidelookup = {"player"}

    self.oneway = "up"
    
    self.frame = 1
    self.open = false
    self.timer = 1

    self.quadcenterx = 8
    self.quadcentery = 7.5
    self.quadoffsetx = 0.5*16
    self.quadoffsety = 0.15625*16
end

function grate:Update(dt)
    -- did its state change?
    local col = #self:PhysicsCheckAABB{include={"player"}}
    if col > 0 and (not self.open) then
        self.open = true
        self.frame = 1
        self.timer = 0
    elseif col == 0 and self.open then
        self.open = false
        self.frame = 3
        self.timer = 0
    end
    
    self.timer = self.timer + dt
    if self.timer <= 0.21 then
        if self.open then
            if self.frame == 1 and self.timer >= 0.1 then self.frame = 2 end
            if self.frame == 2 and self.timer >= 0.2 then self.frame = 3 end
        else
            if self.frame == 3 and self.timer >= 0.1 then self.frame = 4 end
            if self.frame == 4 and self.timer >= 0.2 then self.frame = 1 end
        end
    end
end

function grate:Draw()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(Grateimg, Gratequads[self.frame], self.X+self.quadoffsetx, self.Y+self.quadoffsety, 0, 1, 1, self.quadcenterx, self.quadcentery)
end

OBJECTS.grate = grate