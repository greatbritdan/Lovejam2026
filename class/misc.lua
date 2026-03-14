local text = Class("text", OBJECTS.base)

function text:initialize(world, x, y, w, h, props)
    self.X, self.Y = x, y
    self.text = props.text or "no text?"
    self.opacity = 1

    self.triggerid = props.linkid or 0
end

function text:Update(dt)
    if self.updating then
        if self.triggered then
            self.opacity = self.opacity - (dt*3)
            if self.opacity <= 0 then
                self.opacity = 0
                self.updating = false
            end
        else
            self.opacity = self.opacity + (dt*3)
            if self.opacity >= 1 then
                self.opacity = 1
                self.updating = false
            end
        end
    end
end

function text:Draw()
    love.graphics.setColor(1,1,1,self.opacity)
    love.graphics.print(self.text, math.floor(self.X-((Font:getWidth(self.text)-1)/2)), self.Y-2)
end

function text:Trigger(id, state)
    if self.triggerid == id then
        self.triggered = state
        self.updating = true
    end
end

OBJECTS.text = text

--------------------------------------------

local trigger = Class("trigger", OBJECTS.base)

function trigger:initialize(world, x, y, w, h, props)
    self.X, self.Y, self.W, self.H = x, y, w, h

    self.triggered = false
    self.triggerid = props.linkid or 0
    self.oneshot = props.oneshot or false
end

function trigger:Update(dt)
    if self.oneshot and self.triggered then return end

    local hits = self:PhysicsCheckAABB{include={"player"}}
    if #hits > 0 and (not self.triggered) then
        self:SendTrigger(true)
    end
    if #hits == 0 and self.triggered then
        self:SendTrigger(false)
    end
end

OBJECTS.trigger = trigger