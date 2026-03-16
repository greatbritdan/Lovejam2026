local scene = {}
GAME = {}

local layers
function scene.LoadScene()
    GAME.WORLD = BUMP.newWorld(16)
    MAPNAME = MAPNAME or "level1"
    GAME.MAP = MAP:new("assets/maps/"..MAPNAME..".lua")
    layers = GAME.MAP.layers

    GAME.SX, GAME.SY = GAME.PLAYER.X-(ENV.width/2)+(GAME.PLAYER.W/2), 0
    GAME.PLAYER:Respawn()

    local theme = UI:RegisterStyle("assets/ui/theme.lua")
    GAME.PAUSE = UI:RegisterUI("assets/ui/pause.lua", theme)
    GAME.OPTIONS = UI:RegisterUI("assets/ui/options.lua", theme)

    playmusic(Music)
end
function scene.UnloadScene()
    GAME = {}
    slaymusic(Music)
end

function scene.Update(dt)
    if GAME.STATE then return end

    if GAME.INFO then
        GAME.INFO:Update(dt)
        if GAME.INFO.DONE then GAME.INFO = nil end
    end

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

    if GAME.INFO then
        GAME.INFO:Draw()
    end
    
    UI:Draw(DEBUG.hitbox)
end

function scene.Mousepressed(mx,my,b)
    if GAME.STATE then return end
    if not DEBUG.ENABLED then return end
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

function scene.Keypressed(key)
    if key == "escape" then
        if GAME.STATE then
            changestate(GAME)
        else
            changestate(GAME,"PAUSE")
        end
    end
end

return scene