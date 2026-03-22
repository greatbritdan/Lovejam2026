local scene = {}
MENU = {}

function scene.LoadScene()
    CHECKPOINT = nil

    local mapname = "level"..math.random(3)
    MENU.MAP = MAP:new("assets/maps/"..mapname..".lua",{menu=true})
    layers = MENU.MAP.layers
    MENU.SX = {speed=20, pos=0, dir=1, pause=0}

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

    local text = {level1="start new game", level2="continue (2)", level3="continue (3)", credits="continue (credits)"}
    local stb = MENU.MENU:Find("strict",{{"id","start"}})
    if stb[1] then
        stb[1]:SetText(text[SETTINGS:Get("lastlevel")])
    end

    playmusic(Music)
end
function scene.UnloadScene()
    changestate(MENU)
    MENU = {}
    slaymusic(Music)
end

function scene.Update(dt)
    MENU.SX.pause = MENU.SX.pause - dt
    if MENU.SX.pause <= 0 then
        MENU.SX.pos = MENU.SX.pos + dt*MENU.SX.dir*MENU.SX.speed
        if MENU.SX.dir == 1 and MENU.SX.pos >= (MENU.MAP.W*MENU.MAP.TW)-ENV.width then
            MENU.SX.dir = -1
            MENU.SX.pos = (MENU.MAP.W*MENU.MAP.TW)-ENV.width
            MENU.SX.pause = 1
        elseif MENU.SX.dir == -1 and MENU.SX.pos <= 0 then
            MENU.SX.dir = 1
            MENU.SX.pos = 0
            MENU.SX.pause = 1
        end
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
    layers["background3"]:Draw(MENU.SX.pos, 0)
    layers["background2"]:Draw(MENU.SX.pos, 0)
    layers["background1"]:Draw(MENU.SX.pos, 0)
    
    layers["tilesback"]:Draw(MENU.SX.pos, 0)
    layers["tiles"]:Draw(MENU.SX.pos, 0)
    love.graphics.draw(Shadowimg, 0, 0)
    
    love.graphics.setColor(1,1,1)
    UI:Draw(DEBUG.hitbox)
end

return scene