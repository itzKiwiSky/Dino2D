return function(libraries)
    local lust = libraries.lust
    local dino2d = libraries.dino2d

    lust.describe("Transform component test", function()
        --lust.describe("")
        lust.it("Component integration with object", function()
            local obj = dino2d.object({
                dino2d.components.Transform
            })

            lust.expect(obj.pos).to.exist()
            lust.expect(obj.pos.x).to.be.a("number")
            lust.expect(obj.pos.y).to.be.a("number")
        end)

        lust.describe("Component coordinate system", function()
            lust.it("Check vector values, X and Y", function()
                local obj = dino2d.object({
                    dino2d.components.Transform
                })
                
                local oldX, oldY = obj.pos.x, obj.pos.y
    
                obj.pos.x = 90
                obj.pos.y = 90
    
                lust.expect(obj.pos.x).to_not.be(oldX)
                lust.expect(obj.pos.y).to_not.be(oldY)
            end)

            lust.describe("vector operations", function()
                lust.it("Vector addition", function()
                    local obj = dino2d.object({
                        dino2d.components.Transform
                    })
    
                    obj.pos:add(dino2d.Vec2(32, 32))
                    lust.expect(obj.pos.x).to.be(32)
                    lust.expect(obj.pos.y).to.be(32)
                end)

                lust.it("Vector subtraction", function()
                    local obj = dino2d.object({
                        dino2d.components.Transform
                    })
    
                    obj.pos:sub(dino2d.Vec2(32, 32))
                    lust.expect(obj.pos.x).to.be(-32)
                    lust.expect(obj.pos.y).to.be(-32)
                end)

                lust.it("Vector multiplication", function()
                    local obj = dino2d.object({
                        dino2d.components.Transform
                    })

                    -- set the point to be a number above zero, to not multiply by zero --
                    obj.pos = dino2d.Vec2(32)
    
                    obj.pos:mul(32)
                    lust.expect(obj.pos.x).to.be(1024)
                    lust.expect(obj.pos.y).to.be(1024)
                end)

                lust.it("Vector division", function()
                    local obj = dino2d.object({
                        dino2d.components.Transform
                    })

                    obj.pos = dino2d.Vec2(1024)
    
                    obj.pos:div(32)
                    lust.expect(obj.pos.x).to.be(32)
                    lust.expect(obj.pos.y).to.be(32)
                end)
            end)
        end)
    end)
end