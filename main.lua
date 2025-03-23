local dino2d = require 'dino2d'
local lust = nil

dino2d.engine.timeScale = 1
dino2d.load({ debug = true })

if love.arg.parseGameArguments(arg)[1] == "--test" then
    lust = require 'Tests.Libraries.lust'
    local fsutil = require 'dino2d.FSUtil'

    local tests = fsutil.scanFolder("Tests/suites")
    for _, test in ipairs(tests) do
        dino2d.scene.reset()
        local t = require((test:gsub("/", ".")):gsub("%.lua", ""))
        t({
            lust = lust,
            dino2d = dino2d
        })
    end
end


dino2d.scene.newScene("main", function(scene)
    local circle = dino2d.object({
        dino2d.components.Transform,
        dino2d.components.Circle,
    })

    circle:center()
    circle.color = 0xAAFF66

    local rect = dino2d.object({
        dino2d.components.Transform,
        dino2d.components.Rectangle,
    })

    rect.pos = dino2d.Vec2(90, 90)
    rect.size.w = 128
    rect.size.h = 64
    rect.color = 0xBBAA32

    local img = dino2d.object({
        dino2d.components.Transform,
        dino2d.components.Drawable,
    })

    img.scale = dino2d.Vec2(0.5, 0.5)
    img:centerOrigin()
    img:center()
    img.pos.x = img.pos.x + 160

    dino2d.scene.add(circle)
    dino2d.scene.add(rect)
    dino2d.scene.add(img)

    scene.sceneUpdate = function(elapsed)
        --circle.pos.x = circle.pos.x + 100 * elapsed
        circle.pos.y = dino2d.Math.wave(32, dino2d.windowHeight - 64, dino2d.getTime() * 2)
    end
end)

dino2d.scene.switchScene("main")