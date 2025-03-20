local Signal = {}
Signal.__index = Signal

function Signal.new()
    local self = setmetatable({}, Signal)
    self.connected = {}

    self.connectedOnce = {}

    self.cancelled = false
    return self
end

function Signal:connect(listener, priority, once)
    if type(listener) ~= "function" or table.contains(self.connected, listener) then
        return
    end

    if priority then
        table.insert(self.connected, priority, listener)
    else
        table.insert(self.connected, listener)
    end

    if once then
        table.insert(self.connectedOnce, listener)
    end
end

function Signal:disconnect(listener)
    if type(listener) ~= "function" or not table.contains(self.connected, listener) then
        return
    end

    table.remove(self.connected, listener)
end

function Signal:trigger(...)
    self.cancelled = false
    for _, f in ipairs(self.connected) do
        if not self.cancelled then
            f(...)
        end
    end

    for _, v in ipairs(self.connectedOnce) do
        self:disconnect(v)
    end
end

function Signal:cancel()
    self.cancelled = true
end

function Signal:reset()
    table.clear(self.connected)
end

return setmetatable(Signal, { __call = function(_, ...) return Signal.new(...) end})