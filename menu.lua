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
end

function scene.Draw()
end

return scene