local text = Class("text", OBJECTS.base)

function text:initialize(world, x, y, w, h, props)
    self.X, self.Y, self.W, self.H = x, y, w, h
    self.checkignore = true
    
    self.text = props.text or "no text?"
    self.opacity = 1

    self.triggerid = props.linkid or 0
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
            self.action = TWEEN.new(self.opacity/3, self, {opacity=0}, "linear")
        else
            self.action = TWEEN.new((1-self.opacity)/3, self, {opacity=1}, "linear")
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