local ui = {type="layout", size={x=12,y=12,w=ENV.width-24,h=ENV.height-24}, flow="y", allign=-1, varient=2, spacing=4, margin=8, {
    {type="text", size=21, text="level select!"},
    {type="layout", size="auto", flow="y", spacing=4, margin=0, {

        {type="layout", size=21, flow="x", spacing=4, margin=0, {
            {type="button", size=160, text="level 1", id="maplevel1"},
        }},

        {type="layout", size=21, flow="x", spacing=4, margin=0, {
            {type="button", size=160, text="level 2", id="maplevel2"},
        }},

        {type="layout", size=21, flow="x", spacing=4, margin=0, active=false, {
            {type="button", size=160, text="level 3", id="maplevel3"},
        }},

    }},
    {type="button", size=21, text="go back", id="menu"},
}}

if DEBUG.ENABLED then
    -- Add test map
    table.insert(ui[1][2][1], 1, {type="layout", size=21, flow="x", spacing=4, margin=0, {
        {type="button", size=160, text="test", id="maptest"},
    }})
    -- Add credits map
    table.insert(ui[1][2][1], {type="layout", size=21, flow="x", spacing=4, margin=0, {
        {type="button", size=160, text="credits", id="mapcredits"},
    }})
end

return ui