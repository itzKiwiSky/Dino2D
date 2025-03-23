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

    "onDraw",
    "onUpdate",
    "onBootUp"
}

for _, callback in ipairs(callbacks) do
    Engine[callback] = signal.new()
end

Engine.timeScale = 1

function Engine.init()
    
end

return Engine