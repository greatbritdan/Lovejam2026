local canvas
function love.load()
    
    math.randomseed(os.time());math.random();math.random()

    -- Load Graphics --
    love.graphics.setDefaultFilter("nearest","nearest")
    canvas = love.graphics.newCanvas(ENV.width, ENV.height)
    --Font = love.graphics.newImageFont("assets/graphics/smallfont.png","abcdefghijklmnopqrstuvwxyz 0123456789.,!?'():/%$-=",1)
    --love.graphics.setFont(Font)

    Counterimg, Counterquads = LoadSprites{path="assets/graphics/counter.png", xquads=3, yquads=3, xquadnames={"counter","rook","knight"}}
    Switchimg, Switchquads = LoadSprites{path="assets/graphics/switch.png", xquads=3}
    Doorimg, Doorquads = LoadSprites{path="assets/graphics/door.png", yquads=3}
    Marbleimg = LoadSprites{path="assets/graphics/marble.png", noquads=true}
    Shadowimg = LoadSprites{path="assets/backgrounds/shadow.png", noquads=true}
    Promptsimg, Promptsquads = LoadSprites{path="assets/graphics/prompts.png", xquads=7, yquads=4, xquadnames={"left","right","up","down","jump","split","merge"}, yquadnames={"kbm","kbm_alt","joy","joy_stick"}}

    Font = love.graphics.newImageFont("assets/graphics/newfont.png","abcdefghijklmnopqrstuvwxyz1234567890.,!? /",1)
    love.graphics.setFont(Font)

    -- Load Audio --
    Landsounds = {
        love.audio.newSource("assets/audio/land.ogg","static"),
        love.audio.newSource("assets/audio/land2.ogg","static"),
        love.audio.newSource("assets/audio/land3.ogg","static")
    }
    Flipsounds = {
        love.audio.newSource("assets/audio/flip.ogg","static"),
        love.audio.newSource("assets/audio/flip2.ogg","static"),
        love.audio.newSource("assets/audio/flip3.ogg","static")
    }
    Jumpsound = love.audio.newSource("assets/audio/jump.ogg","static")
    Successsound = love.audio.newSource("assets/audio/success.ogg","static")

    Music = love.audio.newSource("assets/audio/music.ogg","stream")
    Music:setLooping(true)

    -- Load Libraries --
    Class = require("libs.middleclass")
    JSON = require("libs.JSON")
    BUMP = require("libs.bump")
    TWEEN = require("libs.tween")
    local baton = require("libs.baton")
    IN = baton.new(ENV.controls)

    MAP = require("libs.BritMap")
    SCENE = require("libs.BritScene")
    UI = require("libs.BritUI")
    SAVE = require("libs.BritSaveManager")
    DEBUG = require("libs.BritDebug")

    require("utils")

    SETTINGS = SAVE:new{config="save"}
    SETTINGS:LOAD()
    updatecodes()
    
    OBJECTS = {}
    require("class.base")
    require("class.tile")
    require("class.counter")
    require("class.player")
    require("class.switch")
    require("class.door")
    require("class.marble")
    require("class.misc")
    INFO = require("class.info")

    SCENE:LoadScene("menu")
end

function love.update(dt)
    dt = math.min(dt, 1/60) -- no falling through the world
    if DEBUG:Update(dt) then return end
    dt = dt * DEBUG.framespeed
    dt = dt * GAMESPEED
    SCENE:Update(dt)
    UI:Update(dt)

    if IN._activeDevice == "joy" then
        love.mouse.setVisible(false)
    elseif IN._activeDevice == "kbm" then
        love.mouse.setVisible(true)
    end
    IN:update()
    collectgarbage("collect")
end

function love.draw()
    --[[love.graphics.setCanvas(canvas)
    love.graphics.clear()]]
    love.graphics.push()
    love.graphics.scale(ENV.scale, ENV.scale)
    SCENE:Draw()
    DEBUG:Draw()
    love.graphics.pop()
    --[[love.graphics.setCanvas()
    love.graphics.draw(canvas, 0, 0, 0, ENV.scale, ENV.scale)]]
end

function love.mousepressed(x,y,b)
    x, y = x/ENV.scale, y/ENV.scale
    SCENE:Run("Mousepressed",{x,y,b})
    UI:Click(x,y,b)
end
function love.mousereleased(x,y,b)
    x, y = x/ENV.scale, y/ENV.scale
    SCENE:Run("Mousereleased",{x,y,b})
    UI:Release(x,y,b)
end
function love.wheelmoved(x,y)
    SCENE:Run("Wheelmoved",{x,y})
    UI:Scroll(x,y)
end

function love.keypressed(key)
    if DEBUG:Keypressed(key) then return end
    SCENE:Run("Keypressed",{key})
    UI:Input(key)
end
function love.keyreleased(key)
    SCENE:Run("Keyreleased",{key})
end
function love.textinput(key)
    if DEBUG:Textinput(key) then return end
    SCENE:Run("Textinput",{key})
    UI:InputText(key)
end

function love.resize(w,h)
    ENV.windowwidth, ENV.windowheight = w, h
    ENV.width, ENV.height = ENV.windowwidth/ENV.scale, ENV.windowheight/ENV.scale
    SCENE:Run("Resize",{w,h})
end

local gx = love.mouse.getX
function love.mouse.getX()
    return gx()/ENV.scale
end
local gy = love.mouse.getY
function love.mouse.getY()
    return gy()/ENV.scale
end
local gxy = love.mouse.getPosition
function love.mouse.getPosition()
    return gx()/ENV.scale, gy()/ENV.scale
end

-----------------------------

function AABB(x1,y1,w1,h1,x2,y2,w2,h2)
    return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end

function Split(str, d, len)
	local data = {}
	local from, to = 1, string.find(str, d)
	while to do
		table.insert(data, string.sub(str, from, to-1))
        len = len or d:len()
		from = to+len
		to = string.find(str, d, from)
	end
	table.insert(data, string.sub(str, from))
	return data
end

function TableContains(text, table, key)
    for i, v in pairs(table) do
        if (key and v[key] == text) or ((not key) and v == text) then
            return i
        end
    end
    return false
end

function DeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[DeepCopy(orig_key)] = DeepCopy(orig_value)
        end
        setmetatable(copy, DeepCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function LoadSprites(args)
    local path = args.path
    local img = love.graphics.newImage(path)
    if args.noquads then
        return img -- Avoid unnecessary quad creation
    end
    local quads = {}

    local fullw, fullh = img:getDimensions()
    local xquads, yquads = args.xquads or 1, args.yquads or 1
    local quadw, quadh = fullw/xquads, fullh/yquads

    local function getname(idx,names)
        if names then
            return names[idx]
        end
        return idx
    end

    if xquads > 1 and yquads > 1 then
        for y = 1, yquads do
            local yname = getname(y,args.yquadnames)
            quads[yname] = {}
            for x = 1, xquads do
                local xname = getname(x,args.xquadnames)
                quads[yname][xname] = love.graphics.newQuad((x-1)*quadw, (y-1)*quadh, quadw, quadh, fullw, fullh)
            end
        end
    elseif xquads > 1 and yquads <= 1 then
        for x = 1, xquads do
            local xname = getname(x,args.xquadnames)
            quads[xname] = love.graphics.newQuad((x-1)*quadw, 0, quadw, quadh, fullw, fullh)
        end
    elseif xquads <= 1 and yquads > 1 then
        for y = 1, yquads do
            local yname = getname(y,args.yquadnames)
            quads[yname] = love.graphics.newQuad(0, (y-1)*quadh, quadw, quadh, fullw, fullh)
        end
    else
        quads = love.graphics.newQuad(0, 0, quadw, quadh, fullw, fullh)
    end

    return img, quads
end

-- Better printing (with table support) - Inspired by WilliamFrog
Printold = print
function print(...)
    local vals = {...}
    local outvals = {}
    for i, t in pairs(vals) do
        if type(t) == "table" then
            outvals[i] = Tabletostring(t)
        elseif type(t) == "function" then
            outvals[i] = "function"
        else
            outvals[i] = tostring(t)
        end
    end
    ---@diagnostic disable-next-line: deprecated
    Printold(unpack(outvals))
end
function Tabletostring(t)
    local array = true
    local ai = 0
    local outtable = {}
    for i, v in pairs(t) do
        if type(v) == "table" then
            outtable[i] = Tabletostring(v)
        elseif type(v) == "function" then
            outtable[i] = "function"
        else
            outtable[i] = tostring(v)
        end

        ai = ai + 1
        if t[ai] == nil then
            array = false
        end
    end
    local out = ""
    if array then
        out = "[" .. table.concat(outtable,",") .. "]"
    else
        for i, v in pairs(outtable) do
            out = string.format("%s%s: %s, ", out, i, v)
        end
        out = "{" .. out .. "}"
    end
    return out
end