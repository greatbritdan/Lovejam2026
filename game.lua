local scene = {}
GAME = {}

MAP.Register = function(t, data)
    if data.class == "spawn" then
        GAME.STARTX, GAME.STARTY = data.X, data.Y; return nil -- don't create object
    else
        return OBJECTS[data.class]:new(GAME.WORLD, data.X, data.Y, data.W, data.H, data.props)
    end
end

local layers
function scene.LoadScene()
    GAME.STARTX, GAME.STARTY = 1.5, 10
    GAME.WORLD = BUMP.newWorld(16)
    GAME.MAP = MAP:new("assets/maps/test.lua")
    layers = GAME.MAP.layers

    layers["objects"]:AddObject("player", GAME.STARTX, GAME.STARTY, 16, 4)
end
function scene.UnloadScene()
end

function scene.Update(dt)
    layers["objects"]:Run("Update",{dt})
    layers["objects"]:Run("PhysicsUpdate",{dt})
end

function scene.Draw()
    layers["objects"]:Draw(0, 0, DEBUG.ENABLED)
end

return scene