local font = import 'GFX.Font'

local AssetPool = {}
AssetPool.audios = {}
AssetPool.fonts = {
    cache = {},
    paths = {}
}
AssetPool.images = {}
AssetPool.shaders = {}

AssetPool.AUDIOLOADTYPE = {
    ["STATIC"] = "static",
    ["STREAM"] = "stream"
}

AssetPool.ASSETTYPE = {
    AUDIO = "audios",
    FONT = "fonts",
    IMAGE = "images",
    SHADER = "shaders"
}

function AssetPool.get(type, tag, args)
    args = args or {
        fontsize = 20,
        sourcetype = AssetPool.AUDIOLOADTYPE.STATIC
    }

    return switch(type, {
        ["audios"] = function()
            return AssetPool.audios[tag .. "_" .. args.sourcetype]
        end,
        ["fonts"] = function()
            print("d")
            if AssetPool.fonts.paths[tag] then
                if not AssetPool.fonts.cache[tag .. "-" .. args.fontsize] then
                    AssetPool.fonts.cache[tag .. "-" .. args.fontsize] = AssetPool.fonts.paths[tag]:makeFont(args.fontsize)
                    return AssetPool.fonts.cache[tag .. "-" .. args.fontsize]
                end
            end
        end,
        ["images"] = function()
            if AssetPool.images[tag] then
                return AssetPool.images[tag]
            else
                print("invalid image")
            end
        end
    })
end

function AssetPool.addImage(tag, source)
    AssetPool.images[tag] = love.graphics.newImage(source)
end

function AssetPool.addAudio(tag, source, type)
    AssetPool.audios[tag .. "_" .. audiotypes[type]] = love.audio.newSource(source, audiotypes[type] or "static")
end

function AssetPool.addFont(tag, source)
    --AssetPool.images[tag] = love.graphics.newImage(source)
    AssetPool.fonts.paths[tag] = font.new(source)
end

return AssetPool