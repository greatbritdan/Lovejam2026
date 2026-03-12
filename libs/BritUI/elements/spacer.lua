local base = require(__BritUI.requirepath..".elements.base")
-------------------------------------------------------------------------------

local spacer = Class("BritUI_Spacer", base)

function spacer:initialize(core,data,_style)
    base.initialize(self,core,data,_style)
end

return spacer