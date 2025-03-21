local dino2d = require 'dino2d'

dino2d.load({ debug = true })

dino2d.scene.newScene("main", function(scene)
    local obj = dino2d.object({ "test" }, {
        dino2d.components.Transform,
        dino2d.components.Drawable,
    })

    obj.pos.x = 0
    obj.pos.y = 0
    obj.scale = dino2d.Vec2(0.4, 0.4)
    obj:centerOrigin()
    obj:center()

    --print(inspect(obj))

    dino2d.scene.add(obj)

    scene.sceneUpdate = function(st, elapsed)
        --obj.pos.x = obj.pos.x + 10 * elapsed
    end
end)

dino2d.scene.switchScene("main")