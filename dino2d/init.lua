Dino2D = {}

local KIWI_PATH = (...) .. "."

function import(modname)
    if modname == nil or #modname == 0 then
        return require(KIWI_PATH)
    end
    return require(KIWI_PATH .. "src." .. modname)
end

class = require(KIWI_PATH .. "libraries.classic")
xml = require(KIWI_PATH .. "libraries.xml")

lume = require(KIWI_PATH .. "libraries.lume")
enum = require(KIWI_PATH .. "libraries.enum")
camera = require(KIWI_PATH .. "libraries.camera")
push = require(KIWI_PATH .. "libraries.push")

local fsutil = require(KIWI_PATH .. "FSutil")

local addons = fsutil.scanFolder(KIWI_PATH .. "/addons")
for a = 1, #addons, 1 do
    local ad = addons[a]:gsub(".lua", "")
    require(ad:gsub("/", "%."))
end

-- interfaces --
Dino2D.components = {}

-- apis --
Dino2D.Vec2 = import 'Math.Vec2'
Dino2D.scene = import 'Core.Scene'
Dino2D.object = import 'Core.Object'
Dino2D.assets = import 'Core.AssetPool'
Dino2D.signal = import 'Utils.Signal'

-- preload some essential stuff --
Dino2D.assets.addImage("logo", KIWI_PATH .. "/assets/images/icon.png")
Dino2D.assets.addFont("fredoka", KIWI_PATH .. "/assets/fonts/fredoka_regular.ttf")

Dino2D.initialized = false

function Dino2D.load(config)
    assert(Dino2D.initialized == false, "[LovePlayError] : Loveplay is already initialized")

    -- load configs --
    config = config or {}
    local conf = {
        width = config.width or 640,
        height = config.height or 480,
        vsync = config.vsync or false,
        title = config.title or "Powered with Dino2D",
        scene = config.scene or "root",
        resizable = config.resizable or true,
        fullscreen = config.fullscreen or false,
        packageid = config.packageid or "loveplay.game",
        fpscap = config.fpscap or 60,
        unfocusedfps = config.unfocusedfps or 25,
        errhand = config.errhand or true,
        debug = config.debug or false,
        global = config.global or false,
        antialiasing = config.antialiasing or false
    }

    love.window.setMode(conf.width, conf.height, { resizable = conf.resizable, vsync = conf.vsync, fullscreen = conf.fullscreen })

    local mainCanvas = love.graphics.newCanvas(conf.width, conf.height)

    -- load components --
    local components = fsutil.scanFolder(KIWI_PATH .. "/src/Components")
    for c = 1, #components, 1 do
        local comp = components[c]:gsub(".lua", "")
        Dino2D.components[components[c]:match("[^/]+$"):gsub(".lua", "")] = require(comp:gsub("/", "%."))
    end

    love.graphics.setDefaultFilter(
        conf.antialiasing and "linear" or "nearest",
        conf.antialiasing and "linear" or "nearest"
    )

    push.setupScreen(conf.width, conf.height, { upscale = "normal" })

    -- create a default scene --
    Dino2D.scene.newScene(conf.scene, function() end)
    Dino2D.scene.switchScene(conf.scene)

    love.window.setTitle(conf.title)
    love.filesystem.setIdentity(conf.packageid)

    love.run = function()
        love._FPSCap = conf.fpscap
        love._unfocusedFPSCap = conf.unfocusedfps

        love.math.setRandomSeed(os.time())
        math.randomseed(os.time())
    
        local fpsfont = love.graphics.newFont(16)
    
        local pargs = love.arg.parseGameArguments(arg)  -- parsed arguments
        local rargs = arg   -- raw arguments

        if love.timer then love.timer.step() end

        local elapsed = 0

        return function()
            if love.event then
                love.event.pump()
                for name, a,b,c,d,e,f in love.event.poll() do
                    if name == "quit" then
                        if not love.quit or not love.quit() then
                            return a or 0
                        end
                    elseif name == "resize" then
                        push.resize(a, b)
                    end
                    love.handlers[name](a,b,c,d,e,f)
                end
            end

            local isFocused = love.window.hasFocus()
    
            local fpsCap = isFocused and love._FPSCap or love._unfocusedFPSCap
            if love.timer then 
                elapsed = love.timer.step()
            end

            Dino2D.scene.update(elapsed)

            if love.graphics and love.graphics.isActive() then
                love.graphics.origin()

                love.graphics.push("all")
                    love.graphics.setCanvas(mainCanvas)
                        love.graphics.clear(love.graphics.getBackgroundColor())
                        Dino2D.scene.draw()
                    love.graphics.setCanvas()
                    love.graphics.origin()
                love.graphics.pop("all")

                love.graphics.clear(love.graphics.getBackgroundColor())
                
                    love.graphics.setColor(1, 1, 1, 1)
                    push.start()

                        love.graphics.draw(mainCanvas)

                    push.finish()
    
                love.graphics.present()
            end
        end
    end

    love.errorhandler = function(msg)
        local utf8 = require("utf8")

        -- assets --
        local fonterr = love.graphics.newFont(KIWI_PATH .. "/assets/fonts/fredoka_regular.ttf", 18)

        push.setupScreen(conf.width, conf.height, { upscale = "normal" })
        local curTitle = love.window.getTitle()

        local function error_printer(msg, layer)
            print((debug.traceback("Error: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", "")))
        end

        msg = tostring(msg)

        error_printer(msg, 2)
    
        if not love.window or not love.graphics or not love.event then
            return
        end

        if not love.graphics.isCreated() or not love.window.isOpen() then
            local success, status = pcall(love.window.setMode, 800, 600)
            if not success or not status then
                return
            end
        end

        -- Reset state.
        if love.mouse then
            love.mouse.setVisible(true)
            love.mouse.setGrabbed(false)
            love.mouse.setRelativeMode(false)
            if love.mouse.isCursorSupported() then
                love.mouse.setCursor()
            end
        end
        if love.joystick then
            -- Stop all joystick vibrations.
            for i,v in ipairs(love.joystick.getJoysticks()) do
                v:setVibration()
            end
        end
        if love.audio then love.audio.stop() end

        --love.graphics.reset()
    
        love.graphics.setColor(1, 1, 1)
    
        local trace = debug.traceback()
    
        love.graphics.origin()
    
        local sanitizedmsg = {}
        for char in msg:gmatch(utf8.charpattern) do
            table.insert(sanitizedmsg, char)
        end
        sanitizedmsg = table.concat(sanitizedmsg)
    
        local err = {}
    
        table.insert(err, "Error\n")
        table.insert(err, sanitizedmsg)
    
        if #sanitizedmsg ~= #msg then
            table.insert(err, "Invalid UTF-8 string in error message.")
        end
    
        table.insert(err, "\n")

        for l in trace:gmatch("(.-)\n") do
            if not l:match("boot.lua") then
                l = l:gsub("stack traceback:", "Traceback\n")
                table.insert(err, l)
            end
        end
    
        local p = table.concat(err, "\n")
    
        p = p:gsub("\t", "")
        p = p:gsub("%[string \"(.-)\"%]", "%1")

        love.window.setTitle("[Dino2D Runtime Error] | " .. curTitle)

        local function __draw()
            love.graphics.clear(223 / 255, 77 / 255, 67 / 255)
                push.start()
                local pos = 70
                love.graphics.printf(p, fonterr, pos, pos, push.getWidth() - pos)
                push.finish()
            love.graphics.present()
        end
        
        local function __update()
            
        end

        return function()
            love.event.pump()
    
            for e, a, b, c in love.event.poll() do
                if e == "quit" then
                    return 1
                elseif e == "keypressed" and a == "escape" then
                    return 1
                elseif e == "keypressed" and a == "c" and love.keyboard.isDown("lctrl", "rctrl") then
                    --copyToClipboard()
                elseif e == "touchpressed" then
                    local name = love.window.getTitle()
                    if #name == 0 or name == "Untitled" then name = "Game" end
                    local buttons = {"OK", "Cancel"}
                    if love.system then
                        buttons[3] = "Copy to clipboard"
                    end
                    local pressed = love.window.showMessageBox("Quit "..name.."?", "", buttons)
                    if pressed == 1 then
                        return 1
                    elseif pressed == 3 then
                        --copyToClipboard()
                    end
                end
            end
                __draw()

            if love.timer then
                love.timer.sleep(0.001)
            end
        end
    end
end

return Dino2D