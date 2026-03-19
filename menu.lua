local scene = {}
MENU = {}

function scene.LoadScene()
    CHECKPOINT = nil

    local mapname = "level"..math.random(3)
    MENU.MAP = MAP:new("assets/maps/"..mapname..".lua",{menu=true})
    layers = MENU.MAP.layers
    MENU.SX = 0

    local theme = UI:RegisterStyle("assets/ui/theme.lua")
    if SETTINGS:GetInside("codes","oldschool") then
        MENU.MENU = UI:RegisterUI("assets/ui/debugmenu.lua", theme)
    else
        MENU.MENU = UI:RegisterUI("assets/ui/menu.lua", theme)
    end
    MENU.OPTIONS = UI:RegisterUI("assets/ui/options.lua", theme)
    MENU.LEVELSELECT = UI:RegisterUI("assets/ui/levelselect.lua", theme)
    changestate(MENU,"MENU")

    loadsetting(MENU, "volumesfx")
    loadsetting(MENU, "volumemusic")
    loadsetting(MENU, "pixelperfect")

    if SETTINGS:Get("lastlevel") ~= "level1" then
        local stb = MENU.MENU:Find("strict",{{"id","start"}})
        if stb[1] then
            stb[1]:SetText("continue")
        end
    end

    playmusic(Music)
end
function scene.UnloadScene()
    changestate(MENU)
    MENU = {}
    slaymusic(Music)
end

function scene.Update(dt)
    MENU.SX = MENU.SX + dt*16
    if MENU.SX > (MENU.MAP.W*MENU.MAP.TW)-ENV.width then
        MENU.SX = 0
    end
    
    local emv = MENU.OPTIONS:Find("strict",{{"id","volumemusic"}})
    local eml = MENU.OPTIONS:Find("strict",{{"id","volumemusiclabel"}})
    eml[1]:SetText(emv[1]:GetValue(true))

    local esv = MENU.OPTIONS:Find("strict",{{"id","volumesfx"}})
    local esl = MENU.OPTIONS:Find("strict",{{"id","volumesfxlabel"}})
    esl[1]:SetText(esv[1]:GetValue(true))

    --[[local epv = MENU.OPTIONS:Find("strict",{{"id","pixelperfect"}})
    local epl = MENU.OPTIONS:Find("strict",{{"id","pixelperfectlabel"}})
    local t = epv[1]:GetValue(true) and "on" or "off"
    epl[1]:SetText(t)]]
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
    
    UI:Draw(DEBUG.hitbox)
end

return scene