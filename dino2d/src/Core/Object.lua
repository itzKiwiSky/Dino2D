return function(components)
    local self = {}
    self.health = 5
    self.alive = true
    self.children = {}
    self.tags = {}

    local meta = { __index = {} }
    for _, component in ipairs(components) do
        local c

        if type(component) == "string" then table.insert(self.tags, component) else c = component() end
    
        if c ~= nil then
            for k, v in pairs(c) do
                if type(v) == "function" then
                    meta.__index[k] = v
                else
                    self[k] = self[k] or v
                end
            end
    
            if type(c.__init) == "function" then
                c.__init(self)
            end
        end
    end

    setmetatable(self, meta)

    return self
end