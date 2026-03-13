local scene = {}
GAME = {}

MAP.Register = function(t, data, layer)
    if t == "tile" then
        if data.props.collision and layer.class == "tiles" then -- ignore background tiles
            return OBJECTS.tile:new(GAME.WORLD, data.X, data.Y, data.W, data.H, data.props)
        end
    elseif data.class == "spawn" then
        GAME.STARTX, GAME.STARTY = data.X, data.Y; return nil -- don't create object
    elseif t == "object" then
        return OBJECTS[data.class]:new(GAME.WORLD, data.X, data.Y, data.W, data.H, data.props)
    end
end

DEBUG:NewCommand("f1",function()
    GAME.PLAYER:AddCounters(1)
end)
DEBUG:NewCommand("f2",function()
    GAME.PLAYER:AddCounters(-1)
end)

local layers
function scene.LoadScene()
    GAME.STARTX, GAME.STARTY = 1.5, 10
    GAME.WORLD = BUMP.newWorld(16)
    GAME.MAP = MAP:new("assets/maps/test.lua")
    layers = GAME.MAP.layers

    GAME.PLAYER = layers["objects"]:AddObject("player", GAME.STARTX, GAME.STARTY, 16, 4)
end
function scene.UnloadScene()
end

function scene.Update(dt)
    layers["objects"]:Run("Update",{dt})
    layers["objects"]:Run("PhysicsUpdate",{dt})
end

function scene.Draw()
    love.graphics.setColor(1,1,1,.5)
    layers["tilesback"]:Draw(0, 0)
    love.graphics.setColor(1,1,1)
    layers["tiles"]:Draw(0, 0)
    layers["objects"]:Draw(0, 0, false) --love.keyboard.isDown("tab"))
end

return scene