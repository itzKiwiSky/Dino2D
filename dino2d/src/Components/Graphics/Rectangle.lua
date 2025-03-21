local ShapeRenderer = import 'Components.Graphics.Shape'
local vec2 = import 'Math.Vec2'
local Color = import 'Utils.Color'

return function()
    local RectangleShapeComponent = {}
    table.deepmerge(RectangleShapeComponent, ShapeRenderer())
    RectangleShapeComponent.size = vec2(32, 32)

    function RectangleShapeComponent:__init()
        self.verts = {
            self.pos.x, self.pos.y,
            self.pos.x + RectangleShapeComponent.size.x, self.pos.y,
            self.pos.x + RectangleShapeComponent.size.x, self.pos.y + RectangleShapeComponent.size.y,
            self.pos.x, self.pos.y + RectangleShapeComponent.size.y,
        }
    end

    local shapeDraw = RectangleShapeComponent.__draw

    function RectangleShapeComponent:__draw()
        self.verts = {
            self.pos.x, self.pos.y,
            self.pos.x + RectangleShapeComponent.size.x, self.pos.y,
            self.pos.x + RectangleShapeComponent.size.x, self.pos.y + RectangleShapeComponent.size.y,
            self.pos.x, self.pos.y + RectangleShapeComponent.size.y,
        }
        -- super --
        shapeDraw(self)
    end

    return RectangleShapeComponent
end