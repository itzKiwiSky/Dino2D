--[[
local LPObject = {}
LPObject.__index = LPObject

function LPObject.new(tags, components)
    local self = setmetatable({}, LPObject)
    self.health = 5
    self.alive = true
    self.children = {}
    self.tags = tags or {}

    for c = 1, #components, 1 do
        deepMerge(self, components[c])
    end

    return self
end

return setmetatable(LPObject, { __call = function(_, ...) return LPObject.new(...) end})
]]--

return function(tags, components)
    local self = {}
    self.health = 5
    self.alive = true
    self.children = {}
    self.tags = tags or {}

    -- for c = 1, #components, 1 do
    --     table.deepmerge(self, components[c], true)
    --     setmetatable(self, { __index = components[c] })
    -- end

    local meta = { __index = {} }

    for _, component in ipairs(components) do
        -- Adiciona métodos na metatabela
        for k, v in pairs(component()) do
            if type(v) == "function" then
                meta.__index[k] = v -- Métodos são armazenados corretamente
            else
                self[k] = self[k] or v -- Copia valores, se ainda não existirem
            end
        end
    end

    -- Aplicamos a metatabela para garantir que os métodos sejam encontrados
    setmetatable(self, meta)

    return self
end