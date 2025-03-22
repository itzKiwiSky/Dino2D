local camera = import 'Core.Camera'
local Color = import 'Utils.Color'

local Scene = {}
Scene.scenes = {
    ["root"] = {
        objects = {},
        def = function()end
    }
}
Scene.currentScene = "root"
Scene.camera = camera.new(0, 0)

local function drawBGGrid(width, height, cellSize)
    for y = 0, math.floor(height), 1 do
        for x = 0, math.floor(width), 1 do
            local ogc = { love.graphics.getColor() }
            if (x + y) % 2 == 0 then
                love.graphics.setColor(((x + y) % 2 == 0) and Color.fromInt(0x808080FF) or Color.fromInt(0x414141FF))
            end
            love.graphics.rectangle("fill", x * 32, y * 32, cellSize, cellSize)
            love.graphics.setColor(Color.fromInt(0x414141FF))
        end
    end
end

----- interfaces -----------

local LPSceneEvents = {}

function LPSceneEvents.sceneLoad()end

function LPSceneEvents.sceneDraw()end

function LPSceneEvents.sceneUpdate(elapsed)end

---------------------

function Scene.newScene(name, fun)
    Scene.scenes[name] = {
        objects = {},
        def = fun
    }
end

function Scene.switchScene(name)
    Scene.currentScene = name
    Scene.camera:setCameraPosition(Dino2D.push.getWidth() / 2, Dino2D.push.getHeight() / 2)
    Scene.scenes[Scene.currentScene].def(LPSceneEvents)
    if LPSceneEvents.sceneLoad then
        LPSceneEvents.sceneLoad()
    end
end

function Scene.add(gameObject)
    table.insert(Scene.scenes[Scene.currentScene].objects, gameObject)
    --print(inspect(Scene.scenes[Scene.currentScene].objects))
    --Loveplay.event.dispatch("sceneObjectAdded", gameObject)
end

function Scene.reset()
    table.clear(Scene.scenes[Scene.currentScene].objects)
end

function Scene.getObjectCount()
    return #Scene.scenes[Scene.currentScene].objects
end

function Scene.draw()
    drawBGGrid(Dino2D.push.getWidth() / 32, Dino2D.push.getHeight() / 32, 32)
    Scene.camera:start()
        for _, obj in ipairs(Scene.scenes[Scene.currentScene].objects) do
            if obj.__draw then
                obj:__draw(obj)
            end
        end
        love.graphics.origin()
    Scene.camera:stop()
    if LPSceneEvents.sceneDraw then
        LPSceneEvents.sceneDraw()
    end
end

function Scene.update(elapsed)
    for _, obj in ipairs(Scene.scenes[Scene.currentScene].objects) do
        if obj.__update then
            obj:__update(obj, elapsed)
        end
    end
    if LPSceneEvents.sceneUpdate then
        LPSceneEvents.sceneUpdate(Scene.scenes[Scene.currentScene].objects, elapsed)
    end
end


return Scene