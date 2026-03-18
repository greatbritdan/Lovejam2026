return {type="layout", flow="x", allign=-1, margin=0, spacing=0, {
    {type="layout", size="40%", flow="y", margin=0, spacing=2, {
        {type="button", size=17, text="test map", id="maptest"},
        {type="button", size=17, text="level1 map", id="maplevel1"},
        {type="button", size=17, text="level2 map", id="maplevel2"},
        {type="button", size=17, text="level3 map", id="maplevel3"},
        {type="text", size=13, text="enter codes:"},
        {type="input", size=17, text="", id="sendcode", marginx=5},
    }},
    {type="layout", size="60%", flow="y", margin=0, {
        {type="layout", size="auto", flow="x", margin=0, {
            {type="image", size=160, image="assets/graphics/logo.png", margin=0, imagefit="contain"},
        }},
        {type="text", size=13, text="work in progress!"}
    }}
}}