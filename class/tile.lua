local tile = Class("tile", OBJECTS.base)

function tile:initialize(world, x, y, w, h, props)
    OBJECTS.base.initialize(self, world, x, y, w, h)
    self.oneway = props.oneway

    self.collideid = "tile"
    self.collidelookup = {"player","counter","marble"}
end

OBJECTS.tile = tile

-------------------------

local blocker = Class("blocker", OBJECTS.base)

function blocker:initialize(world, x, y, w, h, props)
    OBJECTS.base.initialize(self, world, x, y, w, h)
    self.QY = 0

    self.collideid = "blocker"
    self.collidelookup = {"counter","marble"}

    self.batch = love.graphics.newSpriteBatch(Blockerimg, math.ceil(self.W/16)*math.ceil(self.H/16)+1)
    for y = 1, math.ceil(self.H/16)+1 do
        for x = 1, math.ceil(self.W/16) do
            self.batch:add((x-1)*16, (y-1)*16)
        end
    end
end

function blocker:Update(dt)
    self.QY = self.QY + dt*8
    if self.QY >= 16 then
        self.QY = self.QY - 16
    end
end

function blocker:Draw()
    love.graphics.setScissor((self.X-GAME.SX)*ENV.scale, (self.Y-GAME.SY)*ENV.scale, self.W*ENV.scale, self.H*ENV.scale)
    love.graphics.setColor(1,1,1,.2)
    love.graphics.draw(self.batch, self.X, self.Y+self.QY-16)
    love.graphics.setScissor()
end

OBJECTS.blocker = blocker