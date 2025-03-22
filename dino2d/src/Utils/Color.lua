local bit = require 'bit'

local Color = {}

local function hexToRGBA(hex)
    local hasAlpha = hex > 0xFFFFFF -- Verifica se há canal alpha
    local r = bit.band(bit.rshift(hex, hasAlpha and 24 or 16), 0xFF) / 255
    local g = bit.band(bit.rshift(hex, hasAlpha and 16 or 8), 0xFF) / 255
    local b = bit.band(bit.rshift(hex, hasAlpha and 8 or 0), 0xFF) / 255
    local a = hasAlpha and (bit.band(hex, 0xFF) / 255) or 1.0 -- Se não houver alpha, assume 1.0
    return { r, g, b, a }
end

Color.TRANSPARENT   =       hexToRGBA(0x00000000)
Color.BLACK         =       hexToRGBA(0x000000FF)
Color.WHITE         =       hexToRGBA(0xFFFFFFFF)
Color.RED           =       hexToRGBA(0xFF0000FF)
Color.GREEN         =       hexToRGBA(0x00FF00FF)
Color.BLUE          =       hexToRGBA(0x0000FFFF)
Color.YELLOW        =       hexToRGBA(0xFFFF00FF)
Color.PURPLE        =       hexToRGBA(0xFF00FFFF)
Color.CYAN          =       hexToRGBA(0x00FFFFFF)
Color.PINK          =       hexToRGBA(0xFFC0CBFF)
Color.GRAY          =       hexToRGBA(0x808080FF)
Color.LIGHTGRAY     =       hexToRGBA(0xD3D3D3FF)
Color.DARKGRAY      =       hexToRGBA(0xA9A9A9FF)
Color.ORANGE        =       hexToRGBA(0xFFA500FF)
Color.BROWN         =       hexToRGBA(0xA52A2AFF)
Color.GOLD          =       hexToRGBA(0xFFD700FF)
Color.SILVER        =       hexToRGBA(0xC0C0C0FF)
Color.TEAL          =       hexToRGBA(0x008080FF)
Color.NAVY          =       hexToRGBA(0x000080FF)
Color.OLIVE         =       hexToRGBA(0x808000FF)
Color.MAROON        =       hexToRGBA(0x800000FF)
Color.LIME          =       hexToRGBA(0x00FF00FF)
Color.MAGENTA       =       hexToRGBA(0xFF00FFFF)

--- Convert any decimal to a color in RRGGBBAA
---@param int number
---@return table
function Color.fromInt(int) return hexToRGBA(int) end

return Color