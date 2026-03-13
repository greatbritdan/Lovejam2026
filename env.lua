local w, h, s = 400, 256, 4
return {
    scale = s,
    width = w, height = h,
    windowwidth = w*s, windowheight = h*s,
    
    controls = {
        controls = {
            left = {"sc:a"},
            right = {"sc:d"},
            jump = {"sc:space"},
            special = {"sc:lshift"}
        }
    }
}