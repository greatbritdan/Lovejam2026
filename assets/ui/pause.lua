return {type="layout", size={x=60,y=60,w=ENV.width-120,h=ENV.height-120}, flow="y", allign=-1, varient=2, spacing=4, margin=8, {
    {type="text", size=21, text="game paused!"},
    {type="layout", size="auto", flow="y", spacing=4, margin=0, {

        {type="layout", size=21, flow="x", spacing=4, margin=0, {
            {type="button", size=160, text="continue", id="continue"},
        }},

        {type="layout", size=21, flow="x", spacing=4, margin=0, {
            {type="button", size=160, text="options", id="pauseoptions"},
        }},

        {type="layout", size=21, flow="x", spacing=4, margin=0, {
            {type="button", size=160, text="go to menu", id="exit"},
        }},

    }},
}}