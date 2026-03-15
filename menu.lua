local scene = {}
MENU = {}

UI.Callback = function(e)
    local id = e.id
    if id == "maptest" then MAPNAME = "test" end
    if id == "maplevel1" then  MAPNAME = "level1" end
    SCENE:StartTransition("game")
end

function scene.LoadScene()
    local theme = UI:RegisterStyle("assets/ui/theme.lua")
    MENU.MENU = UI:RegisterUI("assets/ui/menu.lua", theme)
    UI:Load(MENU.MENU)
end
function scene.UnloadScene()
    UI:Unload(MENU.MENU)
    MENU = {}
end

function scene.Update(dt)
end

function scene.Draw()
end

return scene