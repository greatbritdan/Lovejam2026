local w, h, s = 400, 256, 4
return {
    scale = s,
    width = w, height = h,
    windowwidth = w*s, windowheight = h*s,
    
    controls = {
        controls = {
            left = {"sc:a", "sc:left", "axis:leftx-", "button:dpleft"},
            right = {"sc:d", "sc:right", "axis:leftx+", "button:dpright"},
            up = {"sc:w", "sc:up", "axis:lefty-", "button:dpup"},
            down = {"sc:s", "sc:down", "axis:lefty+", "button:dpdown"},
            jump = {"sc:space", "sc:z", "button:a"},
            special = {"sc:lshift", "button:b"},
            split = {"sc:q", "sc:x", "axis:triggerleft+"},
            merge = {"sc:e", "sc:c", "axis:triggerright+"},
        }
    }
}