local LPASSETS = (...):match('(.-)[^/]+$')
local vec2 = import 'Math.Vec2'
local Color = import 'Utils.Color'

local DrawableComponent = {
    drawable = Kiwi2D.assets.get(Kiwi2D.assets.ASSETTYPE.IMAGE, "logo"),
    scale = vec2.ZERO(),
    origin = vec2.ZERO(),
    shear = vec2.ZERO(),
    rotation = 0,
    color = Color.WHITE,
}

function DrawableComponent:__draw()
    local oldColor = { love.graphics.getColor() }
    love.graphics.setColor(self.color)
        love.graphics.draw(
            self.drawable,
            self.pos.x, self.pos.y, math.rad(self.rotation),
            self.scale.x, self.scale.y, self.origin.x, self.origin.y,
            self.shear.x, self.shear.y
        )
    love.graphics.setColor(oldColor)
end

function DrawableComponent:centerOrigin()
    local dw, dh = self.drawable:getDimensions()
    self.origin = vec2(dw / 2, dh / 2)
end

return DrawableComponent