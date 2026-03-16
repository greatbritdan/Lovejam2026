local scene = {}
GAME = {}

MAP.Register = function(t, data, layer, spawnparams)
    if spawnparams.menu then return {} end
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

local layers
function scene.LoadScene()
    GAME.WORLD = BUMP.newWorld(16)
    MAPNAME = MAPNAME or "level1"
    GAME.MAP = MAP:new("assets/maps/"..MAPNAME..".lua")
    layers = GAME.MAP.layers

    GAME.SX, GAME.SY = GAME.PLAYER.X-(ENV.width/2)+(GAME.PLAYER.W/2), 0
    GAME.PLAYER:Respawn()

    playmusic(Music)
end
function scene.UnloadScene()
    GAME = {}
    slaymusic(Music)
end

function scene.Update(dt)
    local tx = GAME.PLAYER.X-(ENV.width/2)+(GAME.PLAYER.W/2)
    local dx = tx-GAME.SX
    GAME.SX = math.min(math.max(0, GAME.SX+(dx*(4*dt))), (GAME.MAP.W*GAME.MAP.TW)-ENV.width)

    if GAME.PLAYER.Y > (GAME.MAP.H*GAME.MAP.TH) then
        GAME.PLAYER:Respawn()
    end

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
    layers["objects"]:Draw(GAME.SX, GAME.SY, DEBUG.hitbox)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(Shadowimg, 0, 0)
end

function scene.Mousepressed(mx,my,b)
    if b == 1 then
        GAME.PLAYER.X = GAME.SX+mx
        GAME.PLAYER.Y = GAME.SY+my
        GAME.PLAYER.world:update(GAME.PLAYER, GAME.PLAYER.X, GAME.PLAYER.Y, GAME.PLAYER.W, GAME.PLAYER.H)
    end
    if b == 2 then
        if CHECKPOINT then
            GAME.PLAYER.X = CHECKPOINT[1]-6
            GAME.PLAYER.Y = CHECKPOINT[2]-GAME.PLAYER.H
            GAME.PLAYER.world:update(GAME.PLAYER, GAME.PLAYER.X, GAME.PLAYER.Y, GAME.PLAYER.W, GAME.PLAYER.H)
        end
    end
end

return scene