function love.conf(t)
    ENV = require("env")

    t.identity = "BritBase"
    t.window.icon = "assets/graphics/icon.png"
    t.window.width = ENV.windowwidth
    t.window.height = ENV.windowheight
    t.window.vsync = false
    t.window.resizable = false
end