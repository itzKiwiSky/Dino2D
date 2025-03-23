local keyConstants = import 'Utils.KeyConstants'

local Keyboard = {}

Keyboard.keys = keyConstants

function Keyboard.keyDown(key)
    if keyConstants[key] then
        return love.keyboard.isDown(keyConstants[key])
    end
end

return Keyboard