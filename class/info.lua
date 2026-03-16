local info = Class("info")

function info:initialize(id)
    if id == "movement" then
        self.text = {
            {"press ","!left"," or ","!right"," to move,"},
            {"press ","!jump"," to hop!"},
        }
    elseif id == "merge" then
        self.text = {
            {"press ","!merge"," to merge with counters,"},
            {"press ","!split"," to split into two half stacks!"},
        }
    elseif id == "down" then
        self.text = {
            {"top tip, you can press ","!down"," while holding ","!jump"},
            {"to fall back through one way platforms!"},
        }
    end
    self.duration = 6

    self.w1 = 0
    for i,v in pairs(self.text[1]) do
        if v:sub(1,1) == "!" then
            if v:sub(2,-1) == "space" then
                self.w1 = self.w1 + 25
            else
                self.w1 = self.w1 + 19
            end
        else
            self.w1 = self.w1 + Font:getWidth(v)-1
        end
    end

    self.w2 = 0
    for i,v in pairs(self.text[2]) do
        if v:sub(1,1) == "!" then
            if v:sub(2,-1) == "space" then
                self.w2 = self.w2 + 25
            else
                self.w2 = self.w2 + 19
            end
        else
            self.w2 = self.w2 + Font:getWidth(v)-1
        end
    end

    self.alttime = 1.5
    self.alt = false
end

function info:Update(dt)
    self.alttime = self.alttime - dt
    if self.alttime <= 0 then
        self.alttime = self.alttime + 1.5
        self.alt = not self.alt
    end
    self.duration = self.duration - dt
    if self.duration <= 0 then
        self.DONE = true
    end
end

function info:Draw()
    local q, kbm = "kbm", true
    if IN._activeDevice == "joy" then
        q, kbm = "joy", false
    elseif self.alt then
        q = "kbm_alt"
    end

    love.graphics.setColor(0,0,0,.4)
    love.graphics.rectangle("fill", 0, ENV.height-54, ENV.width, 54)

    love.graphics.setColor(1,1,1)
    local x, y = (ENV.width/2) - (self.w1/2), (ENV.height/2)+78
    for i,v in pairs(self.text[1]) do
        if v:sub(1,1) == "!" then
            if v:sub(2,-1) == "jump" then
                love.graphics.draw(Promptsimg, Promptsquads[q][v:sub(2,-1)], x, y)
                x = x + 25
            else
                love.graphics.draw(Promptsimg, Promptsquads[q][v:sub(2,-1)], x-3, y)
                x = x + 19
            end
        else
            love.graphics.print(v, x, y+10)
            x = x + Font:getWidth(v)-1
        end
    end

    x, y = (ENV.width/2) - (self.w2/2), (ENV.height/2)+100
    for i,v in pairs(self.text[2]) do
        if v:sub(1,1) == "!" then
            if v:sub(2,-1) == "jump" then
                love.graphics.draw(Promptsimg, Promptsquads[q][v:sub(2,-1)], x, y)
                x = x + 25
            else
                love.graphics.draw(Promptsimg, Promptsquads[q][v:sub(2,-1)], x-3, y)
                x = x + 19
            end
        else
            love.graphics.print(v, x, y+10)
            x = x + Font:getWidth(v)-1
        end
    end
end

return info