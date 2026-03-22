EFFECT = Class("effect")

-- I did infact steal this from Premeditated... which I stole this for reverse polarity... which I stole from seismic shakeup... which I stole fro-
function EFFECT:initialize(x, y, t)
    self.X, self.Y = x, y
    self.VX, self.VY = 0, 0

    self.color = {1,1,1,1}
    if t == "dustl" or t == "dustr" or t == "dustj" then
        self.frames = {frames={1,2,3,4}, frame=1, timer=0, time=0.1}
        self.lifetime = 0.4
        self.VX = (t == "dustr") and 32 or -32
        if t == "dustj" then
            self.VX = 0
            self.VY = 32
        end
        self.fade = true
    elseif t == "telein" or t == "teleout" then
        self.frames = {frames={5,6,7,8}, frame=1, timer=0, time=0.1}
        if t == "telein" then 
            self.frames = {frames={8,7,6,5}, frame=1, timer=0, time=0.1}
        end
        self.lifetime = 0.4
    elseif t == "teleinred" or t == "teleoutred" then
        self.frames = {frames={9,10,11,12}, frame=1, timer=0, time=0.1}
        if t == "teleinred" then 
            self.frames = {frames={12,11,10,9}, frame=1, timer=0, time=0.1}
        end
        self.lifetime = 0.4
    end

    self.lifetimer = 0
end

function EFFECT:Update(dt)
    self.lifetimer = self.lifetimer + dt
    if self.lifetimer >= self.lifetime then
        return true -- Delete
    end

    local f = self.frames
    if f and #f.frames > 1 then
        f.timer = f.timer + dt
        if f.timer >= f.time then
            f.frame = f.frame + 1
            f.timer = f.timer - f.time
            if f.frame > #f.frames then
                f.frame = 1
            end
        end
    end

    if self.fade then
        self.color[4] = 1 - self.lifetimer/self.lifetime
    end

    self.X = self.X + self.VX*dt
    self.Y = self.Y + self.VY*dt
end

function EFFECT:Draw()
    love.graphics.setColor(self.color)
    t = self.frames.frames[self.frames.frame]
    love.graphics.draw(Effectimg, Effectquads[t], self.X-GAME.SX, self.Y-GAME.SY)
end