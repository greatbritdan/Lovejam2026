return {type="layout", flow="x", allign=-1, margin=0, spacing=0, {
    {type="layout", size="40%", flow="y", margin=0, spacing=2, {
        {type="button", size=16, text="test map", id="maptest"},
        {type="button", size=16, text="level1 map", id="maplevel1"},
        {type="text", size=12, text="enter codes:"},
        {type="input", size=16, text="", id="sendcode"}
    }},
    {type="layout", size="60%", flow="y", margin=0, {
        {type="layout", size="auto", flow="x", margin=0, {
            {type="image", size=160, image="assets/graphics/logo.png", margin=0, imagefit="contain"},
        }},
        {type="text", size=16, text="work in progress!"}
    }}
}}