return {type="layout", flow="x", allign=-1, margin=0, spacing=0, {
    {type="layout", size="40%", flow="y", margin=0, spacing=4, {
        {type="button", size=16, text="test map", id="maptest"},
        {type="button", size=16, text="level1 map", id="maplevel1"}
    }},
    {type="layout", size="60%", flow="y", margin=0, {
        {type="layout", size="auto", flow="x", margin=0, {
            {type="image", size=160, image="assets/graphics/logo.png", margin=0, imagefit="contain"},
        }},
        {type="text", size=16, text="work in progress!"}
    }}
}}