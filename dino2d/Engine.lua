local signal = import 'Utils.Signal'

local Engine = {}

local callbacks = {
    "onTextInput",
    "onKeyPressed",
    "onKeyreleased",

    "onMouseMoved",
    "onMousePressed",
    "onMouseReleased",
    "onWheelMoved",
}

for _, callback in ipairs(callbacks) do
    Engine[callback] = signal.new()
end

function Engine.init()
    
end

return Engine