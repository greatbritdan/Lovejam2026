-- BritMap - A Tiled map loader for Love2d, made by Britdan

local function fixrelativepath(fullpath, relativepath)
    local relvparts = Split(relativepath,"/")
    local parts = Split(fullpath,"/")

    for i = #relvparts, 2, -1 do
        parts[((#parts)-(i-2))] = relvparts[((#relvparts)-(i-2))]
    end

    return table.concat(parts, "/")
end

local _map = Class("BritMap_Map")
local _tileset = Class("BritMap_Tileset")
local _layer = Class("BritMap_Layer")

-- MAP --
function _map:initialize(path)
    self.path = path
    local d = love.filesystem.load(path)(); self.data = d
    self.W, self.H = d.width, d.height
    self.TW, self.TH = d.tilewidth, d.tileheight

    self.tiles = {}
    self.tilesets = {}
    for _,ts in ipairs(d.tilesets) do
        local tileset = _tileset:new(self, fixrelativepath(path, ts.exportfilename), ts.firstgid-1)
        self.tilesets[tileset.class] = tileset
    end

    self.layers = {}
    for _,l in ipairs(d.layers) do
        self:CreateLayer(l)
    end
end

function _map:CreateLayer(layer)
    if not layer.visible then return end
    if layer.type == "group" then
        for _,l in ipairs(layer.layers) do
            self:CreateLayer(l) -- Ew recursion
        end
    else
        local newlayer =  _layer:new(self, layer)
        self.layers[newlayer.class] = newlayer
    end
end

-- TILESET --
function _tileset:initialize(map, path, gidx)
    self.map = map
    self.path = path
    local d = love.filesystem.load(path)(); self.data = d
    self.class = d.class

    self.tileprops = {}
    if d.tiles then
        for _,t in ipairs(d.tiles) do
            self.tileprops[t.id+1] = t.properties
        end
    end

    self.W, self.H, self.TW, self.TH = d.imagewidth, d.imageheight, d.tilewidth, d.tileheight
    self.image = love.graphics.newImage(fixrelativepath(path, "../"..d.image))
    self.tiles = {}
    local xcount, ycount = self.W/(self.TW), self.H/(self.TH)

    local i = 0
    for y = 1, ycount do
        for x = 1, xcount do
            i = i + 1
            local quad = love.graphics.newQuad((x-1)*self.TW, (y-1)*self.TH, self.TW, self.TH, self.W, self.H)
            local props = self.tileprops[i] or {}
            local tile = {image=self.image, quad=quad, lidx=i, gidx=i+gidx, props=props, tileset=self}
            self.tiles[i] = tile
            map.tiles[gidx+i] = tile
        end
    end
end

-- LAYER --
function _layer:initialize(map, d)
    self.map = map
    self.data = d
    self.type, self.class = d.type, d.class

    if self.type == "tilelayer" then
        self.W, self.H = d.width, d.height
        self.grid = {}
        
        local i = 0
        for y = 1, self.H do
            self.grid[y] = {}
            for x = 1, self.W do
                i = i + 1
                self:AddTile(d.data[i], x, y, "init")
            end
        end

        if d.properties.batch then
            self:Rebatch()
        end
    elseif self.type == "objectgroup" then -- I will never forgive tiled for not calling this "objectlayer"
        self.objects = {}

        for _,o in ipairs(d.objects) do
            if o.visible then
                if o.shape == "polyline" then o.properties.path = o.polyline end
                if o.shape == "ellipse" then o.properties.radiusx, o.properties.radiusy = o.width/2, o.height/2 end
                self:AddObject(o.type, o.x, o.y, o.width, o.height, o.properties)
            end
        end
    elseif self.type == "imagelayer" then
        self.image = love.graphics.newImage(fixrelativepath(self.map.path, d.image))
        self.image:setWrap("repeat","repeat")
        self.PX, self.PY = d.parallaxx, d.parallaxy
        local qw = ENV.width+((self.map.W*self.map.TW-ENV.width)*self.PX)
        local qh = ENV.height+((self.map.H*self.map.TH-ENV.height)*self.PY)
        self.quad = love.graphics.newQuad(0,0,qw,qh,self.image:getWidth(),self.image:getHeight())
    end
end

function _layer:AddTile(id, x, y, cause)
    if id <= 0 then return end
    if not cause then id = id + 1 end

    local data = self.map.tiles[id]
    if self.grid[y][x] then
        self.grid[y][x].obj:Release()
    end
    local tile = {
        X=(x-1)*self.map.TW, Y=(y-1)*self.map.TH, W=self.map.TW, H=self.map.TH,
        tile=id, image=data.image, quad=data.quad, props=data.props, tileset=data.tileset
    }
    local obj
    if self.map.Register then obj = self.map.Register("tile", tile) end
    if obj then tile.obj = obj end
    self.grid[y][x] = tile

    if not cause then self:Rebatch() end
end

function _layer:AddObject(class, x, y, w, h, props)
    props = props or {}
    local object = {
        X=x, Y=y, W=w, H=h,
        class=class, props=props
    }
    if self.map.Register then object = self.map.Register("object", object) end
    if object then
        table.insert(self.objects, object)
    end
end

function _layer:Rebatch()
    if self.type == "tilelayer" then
        self.batches = {}
        for y = 1, self.H do
            for x = 1, self.W do
                if self.grid[y][x] then
                    local tile = self.grid[y][x]
                    local ts = tile.tileset
                    if not self.batches[ts.class] then
                        self.batches[ts.class] = love.graphics.newSpriteBatch(ts.image, self.W*self.H)
                    end
                    self.batches[ts.class]:add(tile.quad, tile.X, tile.Y)
                end
            end
        end
    end
end

function _layer:Run(name, args)
    if self.type == "objectgroup" then
        args = args or {}
        for _,obj in pairs(self.objects) do
            if obj[name] then obj[name](obj,unpack(args)) end
        end
    end
end
function _layer:Draw(scrollx, scrolly, debug)
    if self.type == "tilelayer" then
        if self.batches then
            for _,tsb in pairs(self.batches) do
                love.graphics.draw(tsb, -scrollx, -scrolly)
            end
        else
            for y = 1, self.H do
                for x = 1, self.W do
                    if self.grid[y][x] then
                        local tile = self.grid[y][x]
                        love.graphics.draw(tile.image, tile.quad, tile.X-scrollx, tile.Y-scrolly)
                    end
                end
            end
        end
    elseif self.type == "objectgroup" then
        love.graphics.push()
        love.graphics.translate(-scrollx, -scrolly)
        self:Run("Draw")
        if debug then self:Run("PhysicsDraw") end
        love.graphics.pop()
    elseif self.type == "imagelayer" then
        love.graphics.draw(self.image, self.quad, -(scrollx*self.PX), -(scrolly*self.PY))
    end
end

return _map