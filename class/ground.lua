local ground = Class("ground", OBJECTS.base)

function ground:initialize(world, x, y, w, h, props)
    OBJECTS.base.initialize(self, world, x, y, w, h)
    self.oneway = props.oneway

    self.collideid = "ground"
    self.collidelookup = {"player"}
end

OBJECTS.ground = ground