local w, h, s = 400, 256, 4
return {
    scale = s,
    width = w, height = h,
    windowwidth = w*s, windowheight = h*s,
    
    controls = {
        controls = {
            left = {"sc:a", "axis:leftx-", "button:dpleft"},
            right = {"sc:d", "axis:leftx+", "button:dpright"},
            up = {"sc:w", "axis:lefty-", "button:dpup"},
            down = {"sc:s", "axis:lefty+", "button:dpdown"},
            jump = {"sc:space", "button:a"},
            special = {"sc:lshift", "button:b"},
            split = {"sc:q", "axis:triggerleft+"},
            merge = {"sc:e", "axis:triggerright+"},
        }
    }
}