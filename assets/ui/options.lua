return {type="layout", size={x=12,y=12,w=ENV.width-24,h=ENV.height-24}, flow="y", allign=-1, varient=2, spacing=4, margin=8, {
    {type="text", size=21, text="options!"},
    {type="layout", size="auto", flow="y", spacing=4, margin=0, {

        {type="text", size=13, text="music volume:"},
        {type="layout", size=21, flow="x", spacing=4, margin=0, {
            {type="spacer", size=21},
            {type="slider", size=160, id="volumemusic"},
            {type="text", size=21, text="", id="volumemusiclabel"},
        }},

        {type="text", size=13, text="sfx volume:"},
        {type="layout", size=21, flow="x", spacing=4, margin=0, {
            {type="spacer", size=21},
            {type="slider", size=160, id="volumesfx"},
            {type="text", size=21, text="", id="volumesfxlabel"},
        }},

        {type="text", size=13, text="reset save data: (no undo)"},
        {type="layout", size=21, flow="x", spacing=4, margin=0, {
            {type="button", size=160, text="bye bye, mr save file", id="resetsave"},
        }},

        {type="spacer", size=79},
        {type="text", size=13, text="enter code:"},
        {type="layout", size=21, flow="x", spacing=4, margin=0, {
            {type="input", size=160, text="", id="sendcode", marginx=7},
        }},
        {type="spacer", size=21},

    }},
    {type="button", size=21, text="go back", id="menu"},
}}