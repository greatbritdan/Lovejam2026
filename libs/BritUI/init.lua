-- BritUI - A UI Librry for Love2d, made by Britdan

__BritUI = {
    requirepath = (...):gsub("%.init$", ""),
    loadpath = (...):gsub("%.init$", ""):gsub("%.", "/")
}

--love.keyboard.setKeyRepeat(true)
return require(__BritUI.requirepath..".core")