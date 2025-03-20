function love.conf(w)
    --% Debug %--
    w.console               =       not love.filesystem.isFused()

    --% Storage %--
    w.externalstorage       =       true
end