local debugfont = love.graphics.newFont(12)

local debug = {}
function debug:Load()
    self.ENABLED = true

    self.commands = {}
    self.infos = {}

    self.console = false
    self.consoleout = "print(\"test\")"

    self.info = false

    self.frameadvance = 0
    self.framespeed = 1

    self.nof3 = true
end

function debug:NewCommand(key, func)
    if not self.commands[key] then
        self.commands[key] = func
    end
end
function debug:NewInfo(text, func)
    if not self.infos[text] then
        self.infos[text] = func
    end
end

function debug:DrawInfo(text, x, y, right)
    love.graphics.setColor(0,0,0,.65)
    local w, h = debugfont:getWidth(text)+4, debugfont:getHeight()+4
    if right then
        love.graphics.rectangle("fill", ENV.width-w, y, w, h)
    else
        love.graphics.rectangle("fill", x, y, w, h)
    end
    love.graphics.setColor(1,1,1)
    if right then
        love.graphics.print(text, x+ENV.width-w+2, y+1)
    else
        love.graphics.print(text, x+2, y+1)
    end
end

function debug:Update(dt)
    if not self.ENABLED then return false end

    if self.frameadvance == 1 then
        self.frameadvance = 2
    elseif self.frameadvance == 2 then
        return true
    end
end

function debug:Draw()
    if not self.ENABLED then return false end

    local calls = love.graphics.getStats().drawcalls
    local oldfont = love.graphics.getFont()
    love.graphics.setFont(debugfont)

    if self.console then
        self:DrawInfo(self.consoleout, 0, ENV.height-18)
    end
    if self.info then
        self:DrawInfo(string.format("fps: %s",love.timer.getFPS()), 0, 0)
        local mx, my = love.mouse.getPosition()
        self:DrawInfo(string.format("mouse: %i, %i",mx,my), 0, 18)
        love.graphics.setColor(1,1,1,.75)
        love.graphics.rectangle("fill",math.floor(mx),math.floor(my),1,1)
        self:DrawInfo(string.format("drawcalls: %i",calls), 0, 36)
        self:DrawInfo(string.format("memory: %.2f MB",collectgarbage("count")/100), 0, 54)
        local i = 0
        for text,func in pairs(self.infos) do
            self:DrawInfo(string.format(text,func()), 0, i, true)
            i = i + 18
        end
    end

    love.graphics.setColor(1,1,1)
    if self.frameadvance > 0 then
        love.graphics.print("Frame Advance", ENV.width-debugfont:getWidth("Frame Advance")-2, ENV.height-debugfont:getHeight("Frame Advance")-2)
    end
    if self.framespeed < 1 then
        love.graphics.print("X0.1 Speed", ENV.width-debugfont:getWidth("X0.1 Speed")-2, ENV.height-debugfont:getHeight("X0.1 Speed")-2)
    end
        
    love.graphics.setFont(oldfont)
end

local down = love.keyboard.isDown
function debug:Keypressed(key)
    if not self.ENABLED then return false end
    self.skipti = false

    if self.console then
        if key == "c" and love.keyboard.isDown("lctrl") then love.system.setClipboardText(self.consoleout); self.skipti = true end
        if key == "v" and love.keyboard.isDown("lctrl") then self.consoleout = love.system.getClipboardText(); self.skipti = true end
        if key == "backspace" then
            self.consoleout = self.consoleout:sub(1,#self.consoleout-1)
            self.skipti = true
        end
        if key == "return" then
            love.system.setClipboardText(self.consoleout) -- incase of crash
            local c = loadstring(self.consoleout); c()
            self.skipti = true
        end
        if key == "delete" then
            self.consoleout = ""
            self.skipti = true
        end
        if key == "escape" then
            self.console = false
            self.skipti = true
        end
        return true
    end

    if self.nof3 or love.keyboard.isDown("f3") then
        if key == "c" then self.console = not self.console; self.skipti = true end
        if key == "i" then self.info = not self.info; self.skipti = true end
        if key == "b" then
            if self.framespeed == 1 then
                self.framespeed = 0.1 
            else
                self.framespeed = 1
            end
            self.skipti = true
        end
    end

    if key == "f16" then self.frameadvance = 0; self.skipti = true end
    if key == "f15" then self.frameadvance = 1; self.framespeed = 1; self.skipti = true end

    if self.commands[key] then
        self.commands[key]()
        self.skipti = true
        return true
    end
end

function debug:Textinput(key)
    if not self.ENABLED then return false end

    if self.console then
        if self.skipti then self.skipti = false; return true end
        self.consoleout = self.consoleout..key
        return true
    end
end

debug:Load()
return debug