-- BritSaveManager - A class for managing save data in Love2d, made by Britdan

local savemanager = Class("britsave")

function savemanager:initialize(args)
    self.path = args.path or "save.json"
    self.data = {}
    if args.config then
        self.config = require(args.config)
    end
end

function savemanager:LOAD()
    if love.filesystem.getInfo(self.path) then
        self.data = self:ModifyTable(self.config, JSON:decode(love.filesystem.read(self.path)))
    else
        self.data = self:ModifyTable(self.config, {})
    end
end
function savemanager:SAVE()
    love.filesystem.write(self.path, JSON:encode_pretty(self.data))
end

function savemanager:ModifyTable(config, loadeddata)
    local result = {}
    for name, data in pairs(config) do
        if data.type == "table" then
            local value = loadeddata and loadeddata[name] or {}
            result[name] = self:ModifyTable(data.table, value)
        else
            local value = loadeddata and loadeddata[name] or nil
            result[name] = self:ModifyValue(data, value)
        end
    end
    return result
end
function savemanager:ModifyValue(config, loaded)
    if not loaded then return config.default end

    if config.type == "string" then
        if type(loaded) == "string" then return loaded
        elseif tostring(loaded) then return tostring(loaded)
        else return config.default end
    end

    if config.type == "number" then
        local value
        if type(loaded) == "number" then value = loaded
        elseif tonumber(loaded) then value = tonumber(loaded)
        else value = config.default end

        if config.min and value < config.min then value = config.min end
        if config.max and value > config.max then value = config.max end

        return value
    end

    if config.type == "boolean" then
        if type(loaded) == "boolean" then return loaded
        elseif loaded == "true" or loaded == 1 then return true
        elseif loaded == "false" or loaded == 0 then return false
        else return config.default end
    end

    return config.default or nil
end

function savemanager:SetInside(name, key, value)
    self.data[name][key] = self:ModifyValue(self.config[name].table[key], value)
end
function savemanager:Set(name, value)
    if self.config[name].type == "table" then
        self.data[name] = self:ModifyTable(self.config[name].table, value)
    else
        self.data[name] = self:ModifyValue(self.config[name], value)
    end
end
function savemanager:Get(name)
    return self.data[name]
end
function savemanager:GetInside(name, key)
    return self.data[name][key]
end
function savemanager:Reset(name)
    if self.config[name].type == "table" then
        self.data[name] = self:ModifyTable(self.config[name].table, {})
    else
        self.data[name] = self:ModifyValue(self.config[name], nil)
    end
end

return savemanager