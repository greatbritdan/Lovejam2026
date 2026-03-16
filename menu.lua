local scene = {}
MENU = {}

UI.Callback = function(e)
    local id = e.id
    if id == "sendcode" then
        if SETTINGS:HasInside("codes",e:GetValue()) then
            SETTINGS:SetInside("codes",e:GetValue(),true)
            SETTINGS:SAVE()
            updatecodes()
        end
        e.value = ""
    else
        if id == "maptest" then MAPNAME = "test" end
        if id == "maplevel1" then  MAPNAME = "level1" end
        if id == "maplevel2" then  MAPNAME = "level2" end
        SCENE:StartTransition("game")
    end
end

function scene.LoadScene()
    MENU.MAP = MAP:new("assets/maps/level1.lua",{menu=true})
    layers = MENU.MAP.layers
    MENU.SX = 0

    local theme = UI:RegisterStyle("assets/ui/theme.lua")
    MENU.MENU = UI:RegisterUI("assets/ui/menu.lua", theme)
    UI:Load(MENU.MENU)
    playmusic(Music)
end
function scene.UnloadScene()
    UI:Unload(MENU.MENU)
    MENU = {}
    slaymusic(Music)
end

function scene.Update(dt)
    MENU.SX = MENU.SX + dt*16
end

function scene.Draw()
    love.graphics.setColor(.4,.4,.4)
    layers["background3"]:Draw(MENU.SX, 0)
    layers["background2"]:Draw(MENU.SX, 0)
    layers["background1"]:Draw(MENU.SX, 0)
    
    layers["tilesback"]:Draw(MENU.SX, 0)
    layers["tiles"]:Draw(MENU.SX, 0)
    love.graphics.setColor(.4,.4,.4)
    love.graphics.draw(Shadowimg, 0, 0)
end

return scene