return {type="layout", flow="x", allign=-1, {
    {type="layout", size="40%", flow="y", {
        {type="spacer", size=18},
        {type="layout", size="auto", flow="y", spacing=4, margin=8, {
            {type="button", size=31, text="start", id="start"},
            {type="button", size=21, text="select level", id="levelselect"},
            {type="button", size=21, text="options", id="options"},
            {type="button", size=21, text="quit", id="quit"},
        }},
        {type="text", size=5, text="made by britdan for the", allignx=-1, alligny=1, marginx=4, marginy=-1},
        {type="text", size=13, text="love2d game jam 2026!", allignx=-1, alligny=1, marginx=4, marginy=3}
    }},
    {type="layout", size="60%", flow="y", allign=-1, {
        {type="spacer", size=20},
        {type="image", size=88, image="assets/graphics/logo.png"},
        {type="spacer", size="auto"}
    }}
}}