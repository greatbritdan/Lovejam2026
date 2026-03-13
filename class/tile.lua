local tile = Class("tile", OBJECTS.base)

function tile:initialize(world, x, y, w, h, props)
    OBJECTS.base.initialize(self, world, x, y, w, h)
    self.oneway = props.oneway

    self.collideid = "tile"
    self.collidelookup = {"player"}
end

OBJECTS.tile = tile