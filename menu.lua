local scene = {}
MENU = {}

local function changestate(name)
    if MENU.STATE then
        UI:Unload(MENU[MENU.STATE])
    end
    if name then
        MENU.STATE = name
        UI:Load(MENU[MENU.STATE])
    end
end

local function loadsetting(name)
    local e = MENU.OPTIONS:Find("strict",{{"id",name}})
    if e and e[1] then
        e[1].value = SETTINGS:Get(name)
        if name == "volumesfx" or name == "volumemusic" then
            e[1].value = e[1].value*100
        end
    end
end

local function updatesetting(name, value)
    if SETTINGS:Has(name) then
        if name == "volumesfx" or name == "volumemusic" then
            value = value/100
        end
        SETTINGS:Set(name,value)
        SETTINGS:SAVE()
        if name == "volumemusic" then
            updatevolume()
        end
    elseif name == "sendcode" then
        if SETTINGS:HasInside("codes", value) then
            local old = SETTINGS:GetInside("codes", value)
            SETTINGS:SetInside("codes", value, (not old))
            SETTINGS:SAVE()
            updatecodes()
            playsound(Successsound)
        end
    end
end

function scene.UICallback(e)
    local id = e.id or "nil"
    if id:sub(1,3) == "map" then
        MAPNAME = id:sub(4,-1)
        SCENE:StartTransition("game")
    else
        -- updates settings if the ID matches one, works for codes
        updatesetting(id, e:GetValue())

        if id == "start" then MAPNAME = "level1"; SCENE:StartTransition("game") end
        if id == "menu" then changestate("MENU") end
        if id == "options" then changestate("OPTIONS") end
        if id == "quit" then love.event.quit() end
    end
end

function scene.LoadScene()
    MENU.MAP = MAP:new("assets/maps/level1.lua",{menu=true})
    layers = MENU.MAP.layers
    MENU.SX = 0

    local theme = UI:RegisterStyle("assets/ui/theme.lua")
    if SETTINGS:GetInside("codes","oldschool") then
        MENU.MENU = UI:RegisterUI("assets/ui/debugmenu.lua", theme)
    else
        MENU.MENU = UI:RegisterUI("assets/ui/menu.lua", theme)
    end
    MENU.OPTIONS = UI:RegisterUI("assets/ui/options.lua", theme)
    changestate("MENU")

    loadsetting("volumesfx")
    loadsetting("volumemusic")

    playmusic(Music)
end
function scene.UnloadScene()
    changestate()
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