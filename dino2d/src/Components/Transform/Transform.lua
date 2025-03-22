return function()
    local vec2 = import 'Math.Vec2'

    local TransformComponent = {
        pos = vec2.ZERO(),
        z = 0,
    }

    function TransformComponent:center(this)
        self.pos.x, self.pos.y = Dino2D.pushpush.getWidth() / 2, Dino2D.pushpush.getHeight() / 2
    end

    return TransformComponent
end