function love.conf(t)
    ENV = require("env")

    t.identity = "stacktheodds"
    t.window.icon = "assets/graphics/icon.png"
    t.window.title = "Stack The Odds - By Britdan"
    t.window.width = ENV.windowwidth
    t.window.height = ENV.windowheight
    t.window.vsync = false
    t.window.resizable = false
end