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

UI.Callback = function(e)
    local id = e.id or "nil"
    if id:sub(1,3) == "map" then
        MAPNAME = id:sub(4,-1)
        SCENE:StartTransition("game")
    else
        -- updates settings if the ID matches one, works for codes
        updatesetting(id, e:GetValue())

        if id == "start" then
            MAPNAME = SETTINGS:Get("lastlevel")
            SCENE:StartTransition("game")
        end
        if id == "levelselect" then changestate(MENU,"LEVELSELECT") end
        if id == "options" then changestate(MENU,"OPTIONS") end
        if id == "quit" then love.event.quit() end
        if id == "menu" then
            if MENU.MENU then
                changestate(MENU,"MENU")
            else
                changestate(GAME,"PAUSE")
            end
        end
        if id == "resetsave" then
            SETTINGS:Set("volumemusic",0.5)
            SETTINGS:Set("volumesfx",0.5)
            SETTINGS:Set("lastlevel","level1")
            SETTINGS:SetInside("codes","gimmestimmy",false)
            SETTINGS:SetInside("codes","iamgod",false)
            SETTINGS:SetInside("codes","imsohungry",false)
            SETTINGS:SetInside("codes","oldschool",false)
            SETTINGS:SetInside("codes","puttpartyreference",false)
            SETTINGS:SetInside("codes","rookymistake",false)
            SETTINGS:SAVE()
            SCENE:StartTransition("menu")
        end
        
        if id == "continue" then changestate(GAME) end
        if id == "pauseoptions" then changestate(GAME,"OPTIONS") end
        if id == "exit" then SCENE:StartTransition("menu") end
    end
end

function changestate(root, name)
    if root.STATE then
        UI:Unload(root[root.STATE])
    end
    if name then
        root.STATE = name
        UI:Load(root[root.STATE])
    else
        root.STATE = false
    end
end

function loadsetting(root, name)
    local e = root.OPTIONS:Find("strict",{{"id",name}})
    if e and e[1] then
        e[1].value = SETTINGS:Get(name)
        if name == "volumesfx" or name == "volumemusic" then
            e[1].value = e[1].value*100
        end
    end
end

function updatesetting(name, value)
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

function updatecodes()
    DEBUG.ENABLED = SETTINGS:GetInside("codes","iamgod")
    GAMESPEED = 1
    if SETTINGS:GetInside("codes","gimmestimmy") then
        GAMESPEED = 4
    end
    FORCEDFORM = nil
    if SETTINGS:GetInside("codes","rookymistake") then
        FORCEDFORM = "rook"
    end
    if SETTINGS:GetInside("codes","imsohungry") then
        FORCEDFORM = "knight"
    end
end

function updatevolume()
    Music:setVolume(SETTINGS:Get("volumemusic"))
end

function playsound(v,vol)
    vol = vol or 1
    v:setVolume(vol*SETTINGS:Get("volumesfx"))
    v:stop()
    v:play()
end

function playmusic(v)
    v:setVolume(SETTINGS:Get("volumemusic"))
    v:stop()
    v:play()
end
function slaymusic(v)
    v:stop()
end

function neweffect(x, y, t)
    local e = EFFECT:new(x, y, t)
    table.insert(EFFECTS, e)
end