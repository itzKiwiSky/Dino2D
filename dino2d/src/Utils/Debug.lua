local Color = import 'Utils.Color'

local Debug = {}

Debug.LOGTYPE = { INFO = "info", WARN = "warn", ERROR = "error", DEPRECATION = "deprecation" }

function Debug:init(x, y)
    self.x, self.y = x or 0, self.y or math.floor(Loveplay.windowHeight / 2)
    self.maxWidth = math.floor(push.getWidth() / 2)
    self.maxHeight = math.floor(Loveplay.windowHeight / 2)
    self.messages = {}

    -- Loveplay ingame debug --
    self.ttl = 200 -- time to leave --
    self.opacity = 1
    self.colorBG = Color.fromInt(0x00000080)
    --self.colorFG = Color.WHITE
    self.font = Loveplay.assets.get(Loveplay.assets.assetType.FONT, "fredoka", { fontsize = 14 })

    self.warnColors = {
        ["info"] = Color.fromInt(0xE3C2CDFF),
        ["warn"] = Color.fromInt(0xF5C436FF),
        ["error"] = Color.fromInt(0xF04861FF),
        ["deprecation"] = Color.fromInt(0xE18346FF),
    }
end

function Debug:_draw()
    for _, message in ipairs(self.messages) do
        local oc = { love.graphics.getColor() }
        love.graphics.setColor(self.colorBG)
            love.graphics.rectangle("fill", self.x, self.y, self.font:getWidth(message.text), self.font:getHeight() + 5)
        love.graphics.setColor(oc)
    end
end

function Debug:_update(elapsed)
    
end

----- exported -----
--- Output to the Loveplay ingame log
---@param type Loveplay.Debug.LOGTYPE
---@param message string
function Debug:log(type, message)
    --self.font:getHeight() + 5
end

return Debug