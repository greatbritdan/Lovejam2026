local scene = {}
GAME = {}

MAP.Register = function(t, data, layer)
    if t == "tile" then
        if data.props.collision and layer.class == "tiles" then -- ignore background tiles
            return OBJECTS.tile:new(GAME.WORLD, data.X, data.Y, data.W, data.H, data.props)
        end
    elseif t == "object" and OBJECTS[data.class] then
        local object = OBJECTS[data.class]:new(GAME.WORLD, data.X, data.Y, data.W, data.H, data.props)
        if data.class == "player" then GAME.PLAYER = object end
        return object
    end
end

DEBUG:NewCommand("f1",function() GAME.PLAYER:AddCounters(1) end)
DEBUG:NewCommand("f2",function() GAME.PLAYER:AddCounters(-1) end)

local layers
function scene.LoadScene()
    GAME.SX, GAME.SY = 0, 0
    GAME.WORLD = BUMP.newWorld(16)
    GAME.MAP = MAP:new("assets/maps/level1.lua")
    layers = GAME.MAP.layers

    if not GAME.PLAYER then
        GAME.PLAYER = layers["objects"]:AddObject("player",  0, 0, 2, 4)
    end
end
function scene.UnloadScene()
end

function scene.Update(dt)
    GAME.SX = math.min(math.max(0, GAME.PLAYER.X-(ENV.width/2)+(GAME.PLAYER.W/2)), (GAME.MAP.W*GAME.MAP.TW)-ENV.width)

    layers["objects"]:Run("Update",{dt})
    layers["objects"]:Run("PhysicsUpdate",{dt})
end

function scene.Draw()
    love.graphics.setColor(1,1,1)
    layers["background3"]:Draw(GAME.SX, GAME.SY)
    layers["background2"]:Draw(GAME.SX, GAME.SY)
    layers["background1"]:Draw(GAME.SX, GAME.SY)
    
    layers["tilesback"]:Draw(GAME.SX, GAME.SY)
    layers["tiles"]:Draw(GAME.SX, GAME.SY)
    layers["objects"]:Draw(GAME.SX, GAME.SY, false)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(Shadowimg, 0, 0)

    --love.graphics.print("this is the epic font!!!")
end

return scene