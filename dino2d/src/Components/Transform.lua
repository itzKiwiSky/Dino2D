local vec2 = import 'Math.Vec2'

local TransformComponent = {
    pos = vec2.ZERO()
}

function TransformComponent:center(this)
    self.pos.x, self.pos.y = push.getWidth() / 2, push.getHeight() / 2
end

return TransformComponent