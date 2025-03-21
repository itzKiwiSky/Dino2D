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

    local label = dino2d.object({ "label" }, {
        dino2d.components.Transform,
        dino2d.components.Text,
    })

    label.pos.y = 32
    label.text = "Hello world"
    label.align = label.ALIGNMENT.CENTER
    label.textLimit = dino2d.windowWidth
    label.color = dino2d.Color.WHITE
    label.shadow = true

    local rect = dino2d.object({ "rect" }, {
        dino2d.components.Transform,
        dino2d.components.Rectangle
    })

    rect.color = 0xFF00BB
    rect.size.x = 96


    dino2d.scene.add(obj)
    dino2d.scene.add(label)
    dino2d.scene.add(rect)

    scene.sceneUpdate = function(st, elapsed)
        --obj.pos.x = obj.pos.x + 10 * elapsed
        rect.size.x = rect.size.x + 20 * elapsed
    end
end)

dino2d.scene.switchScene("main")