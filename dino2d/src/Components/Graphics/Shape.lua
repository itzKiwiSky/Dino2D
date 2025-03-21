local vec2 = import 'Math.Vec2'
local Color = import 'Utils.Color'

return function()
    local ShapeRendererComponent = {}

    ShapeRendererComponent.FILLSTYLE = {
        FILL = "fill",
        LINE = "line"
    }

    ShapeRendererComponent.MODE = {
        MESH = "mesh",
        NATIVE = "native"
    }

    ShapeRendererComponent.verts = {}
    ShapeRendererComponent.fillmode = ShapeRendererComponent.FILLSTYLE.FILL
    ShapeRendererComponent.color = Color.WHITE
    --ShapeRendererComponent.mode = ShapeRendererComponent.MODE.NATIVE

    --ShapeRendererComponent.__mesh = {}

    -- if ShapeRendererComponent.mode == ShapeRendererComponent.MODE.MESH then
    --     ShapeRendererComponent.__mesh = love.graphics.newMesh()
    -- end

    function ShapeRendererComponent:__draw()
        if #self.verts >= 3 then
            love.graphics.setColor(type(self.color) == "table" and self.color or Color.fromInt(self.color))
            love.graphics.polygon(self.fillmode, self.verts)
        end
        love.graphics.setColor(1, 1, 1, 1)
    end

    return ShapeRendererComponent
end