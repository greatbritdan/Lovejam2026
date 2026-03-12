-- BritScene - A scene manager for Love2D, made by Britdan

local britstate = {}

function britstate:Initialize()
    self.scenes = {}
    self.scene = nil
    self.lastscene = nil
    self.transition = nil
    self.transitionTime = 0
    self.transitionDuration = 0.5
end

function britstate:Run(func, args, scene)
    if self.scene then
        local sceneclass = self.scenes[self.scene]
        if scene then
            sceneclass = self.scenes[scene]
        end
        args = args or {}
        if sceneclass[func] then
            ---@diagnostic disable-next-line: deprecated
            sceneclass[func](unpack(args))
        end
    end
end

function britstate:LoadScene(name)
    if not self.scenes[name] then
        self.scenes[name] = require(name)
    end
    self:Run("UnloadScene", {self.scene, name})
    self.lastscene = self.scene
    self.scene = name
    self:Run("LoadScene", {name, self.lastscene})
end

function britstate:StartTransition(name)
    self.transition = { from=self.scene, to=name, time=0, phase="fadeout" }
end

function britstate:Update(dt)
    if self.transition then
        self.transition.time = self.transition.time + dt
        if self.transition.phase == "fadeout" and self.transition.time >= self.transitionDuration then
            self:LoadScene(self.transition.to)
            self.transition.time = 0
            self.transition.phase = "fadein"
        elseif self.transition.phase == "fadein" and self.transition.time >= self.transitionDuration then
            self.transition = nil
        end
    end
    self:Run("Update", {dt})
end

function britstate:Draw()
    if self.transition then
        local progress = self.transition.time / self.transitionDuration
        if self.transition.phase == "fadeout" then
            self:Run("Draw",nil,self.transition.from)
            love.graphics.setColor(0, 0, 0, progress) 
        elseif self.transition.phase == "fadein" then
            self:Run("Draw",nil,self.transition.to)
            love.graphics.setColor(0, 0, 0, 1 - progress)
        end
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1, 1)
    else
        self:Run("Draw")
    end
end

britstate:Initialize()
return britstate